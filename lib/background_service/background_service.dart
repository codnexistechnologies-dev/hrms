import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:aeon_hrms/Utility/DatabaseHelper.dart';
import 'package:aeon_hrms/Utility/utility_function.dart';
import 'package:aeon_hrms/background_service/location_tracking.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

bool isServiceInitialized = false;
const simpleTaskKey = "simpleTask";
Future<void>? _serviceConfiguration;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> initializeBackgroundServices() async {
  // Tracking recovery must not depend on WorkManager scheduling succeeding.
  try {
    await initializeService();
  } catch (error, stackTrace) {
    debugPrint('Location service initialization failed: $error');
    debugPrintStack(stackTrace: stackTrace);
  }
  try {
    final dbHelper = DatabaseHelper();
    dbHelper.resetErrorCounter();
    await Workmanager().initialize(callbackDispatcher);
    await rescheduleTasks();
  } catch (error, stackTrace) {
    debugPrint('Background service initialization failed: $error');
    debugPrintStack(stackTrace: stackTrace);
  }
  // Push any location rows left over from a previous run immediately.
  unawaited(_syncUnsyncedLocationRows());
}

/// Pushes locally stored location points to the server right away when the
/// device is online. Called on app start and after check-in/check-out so data
/// does not depend solely on the periodic WorkManager sync.
Future<void> _syncUnsyncedLocationRows() async {
  try {
    final String network = await Utility.checkNetworkStatus();
    if (network == 'Connected to the Internet') {
      await DatabaseHelper().syncWithServer();
    } else {
      debugPrint('[Location] Offline; skipping immediate sync');
    }
  } catch (error) {
    debugPrint('[Location] Immediate sync failed: $error');
  }
}

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    if (!isServiceInitialized) {
      DartPluginRegistrant.ensureInitialized();
      isServiceInitialized = true;
    }
    try {
      String mobileNetwork = await Utility.checkNetworkStatus();
      if (mobileNetwork == "Connected to the Internet") {
        DatabaseHelper dbHelper = DatabaseHelper();
        await dbHelper.syncWithServer();
      }
      return true;
    } catch (e) {
      DatabaseHelper dbHelper = DatabaseHelper();
      await dbHelper.insertError({
        'emp_code': '',
        'error_message': 'WorkManager Background task failed: $e',
        'error_date': DateTime.now().toString(),
      });
      return false;
    }
  });
}

@pragma('vm:entry-point')
void resumeWorkManager() async {
  DateTime now = DateTime.now();
  DateTime stopTime = DateTime(now.year, now.month, now.day, 20, 0);
  if (now.isAfter(stopTime)) {
    await AndroidAlarmManager.cancel(123);
    debugPrint("Alarm stopped at 8 PM");
    DateTime nextDay = now.add(const Duration(days: 1));
    DateTime nextStartTime = DateTime(
      nextDay.year,
      nextDay.month,
      nextDay.day,
      6,
      0,
    );
    await AndroidAlarmManager.periodic(
      const Duration(hours: 2), // Repeat every 2 hours
      123, // Unique ID for the alarm
      resumeWorkManager, // Callback function
      startAt: nextStartTime, // Start after 10 seconds
      exact: true, // Use exact timing
      wakeup: true, // Wake up the device if necessary
    );
    debugPrint("Alarm rescheduled for 6 AM the next day");
    return;
  }

  // Your task logic here
  //Utility.ToastMessage("Alarm triggered at ${now.toString()}");
  await rescheduleTasks();
}

Future<void> initializeService() async {
  try {
    await (_serviceConfiguration ??= _configureService());
  } catch (_) {
    _serviceConfiguration = null;
    rethrow;
  }
  final prefs = await SharedPreferences.getInstance();
  await prefs.reload();
  final service = FlutterBackgroundService();
  if (!await service.isRunning() &&
      prefs.getBool(locationTrackingActiveKey) == true) {
    final started = await service.startService();
    if (!started) {
      throw StateError('Location foreground service did not start');
    }
  }
}

Future<void> _configureService() async {
  await setupNotificationChannel();
  final service = FlutterBackgroundService();
  final configured = await service.configure(
    iosConfiguration: IosConfiguration(),
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      isForegroundMode: true,
      autoStart: false,
      autoStartOnBoot: true,
      notificationChannelId: 'foreground_service',
      initialNotificationTitle: 'Location Service Running',
      initialNotificationContent: 'Tracking location in the background.',
      foregroundServiceTypes: [AndroidForegroundType.location],
    ),
  );
  if (!configured) {
    throw StateError('Location foreground service configuration failed');
  }
}

Future<void> setLocationTrackingActive(bool active) async {
  final prefs = await SharedPreferences.getInstance();
  final wasActive = prefs.getBool(locationTrackingActiveKey) == true;
  if (active && !wasActive) {
    await resetLocationTrackingCache();
  }
  await prefs.setBool(locationTrackingActiveKey, active);
  final service = FlutterBackgroundService();
  if (active) {
    // Ask the user for every permission the reliable background tracking needs:
    // "Allow all the time" (background) location, notifications (Android 13+)
    // and Doze/battery-exemption guidance.
    await requestTrackingPermissions();
    final wasRunning = await service.isRunning();
    try {
      await initializeService();
    } catch (_) {
      await prefs.setBool(locationTrackingActiveKey, false);
      rethrow;
    }
    if (wasRunning) service.invoke('startTracking');
    if (!await service.isRunning()) {
      await prefs.setBool(locationTrackingActiveKey, false);
      throw StateError('Location foreground service is not running');
    }
    unawaited(_suggestBatteryOptimization(prefs));
  } else if (await service.isRunning()) {
    service.invoke('stopTracking');
  }
  // Flush/push pending location rows now (check-out flush, check-in echo)
  // instead of waiting for the 15-minute WorkManager sync.
  unawaited(_syncUnsyncedLocationRows());
}

/// Full permission flow for reliable background tracking.
Future<void> requestTrackingPermissions() async {
  final backgroundGranted = await ensureBackgroundLocationPermission();
  await _requestTrackingNotificationPermission();
  if (Platform.isAndroid) {
    try {
      final info = await DeviceInfoPlugin().androidInfo;
      if (info.version.sdkInt >= 33 &&
          !(await Permission.scheduleExactAlarm.status).isGranted) {
        await Permission.scheduleExactAlarm.request();
      }
    } catch (error) {
      debugPrint('[Location] Exact alarm permission request failed: $error');
    }
  }
  if (Platform.isAndroid && !backgroundGranted) {
    Utility.ToastMessage(
      'Location tracking needs "Allow all the time" permission for background.',
    );
  }
}

/// Requests foreground ("While using the app") location first, then the
/// background ("Allow all the time") access on Android. On Android 11+ the
/// background permission may need a second request or a manual settings toggle.
Future<bool> ensureBackgroundLocationPermission() async {
  if (!Platform.isAndroid) return true;
  try {
    if (!await Geolocator.isLocationServiceEnabled()) {
      await Geolocator.openLocationSettings();
      final enabled = await Geolocator.isLocationServiceEnabled();
      if (!enabled) return false;
    }

    var status = await Permission.locationWhenInUse.status;
    if (status.isDenied) {
      status = await Permission.locationWhenInUse.request();
    }
    if (status.isPermanentlyDenied) {
      await openAppSettings();
      return false;
    }
    if (!status.isGranted) return false;

    var always = await Permission.locationAlways.request();
    if (!always.isGranted) {
      // First request only yields "while in use"; a second one usually exposes
      // the "Allow all the time" dialog on Android 10/11.
      always = await Permission.locationAlways.request();
    }
    if (!always.isGranted) {
      if (always.isPermanentlyDenied) {
        await openAppSettings();
      }
      return false;
    }
    return true;
  } catch (error) {
    debugPrint('[Location] Permission request failed: $error');
    return false;
  }
}

/// Guides the user once to exempt the app from battery optimizations so Doze
/// does not silence the foreground service.
Future<void> _suggestBatteryOptimization(SharedPreferences prefs) async {
  if (!Platform.isAndroid) return;
  if (prefs.getBool('battery_opt_suggested') ?? false) return;
  await prefs.setBool('battery_opt_suggested', true);
  try {
    final info = await DeviceInfoPlugin().androidInfo;
    if (info.version.sdkInt >= 23 &&
        !(await Permission.ignoreBatteryOptimizations.status).isGranted) {
      await checkAndRequestBatteryOptimizations();
    }
  } catch (error) {
    debugPrint('[Location] Battery optimization flow failed: $error');
  }
}

Future<void> _requestTrackingNotificationPermission() async {
  if (!Platform.isAndroid) return;
  try {
    final android = await DeviceInfoPlugin().androidInfo;
    if (android.version.sdkInt < 33) return;
    final status = await Permission.notification.status;
    if (!status.isGranted) {
      final result = await Permission.notification.request();
      if (!result.isGranted) {
        debugPrint(
          '[Location] Service is running; notification permission denied',
        );
      }
    }
  } catch (error) {
    debugPrint('[Location] Notification permission request failed: $error');
  }
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();
  setTrackingServiceInstance(service);
  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
    service.setAsForegroundService();
  }

  service.on('stopService').listen((event) async {
    await stopLocationTracking();
    await service.stopSelf();
  });
  service.on('startTracking').listen((event) => startLocationTracking());
  service.on('stopTracking').listen((event) async {
    await stopLocationTracking();
    service.stopSelf();
  });
  String? restartRequest;
  Future<void>? restartPause;
  Timer? restartWatchdog;
  Future<void> restoreTracking() async {
    try {
      await restartPause;
    } catch (_) {
      // Resume after a failed persistence attempt without starting a second
      // stream while cancellation/draining of the old one is still in progress.
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    if (prefs.getBool(locationTrackingActiveKey) == true) {
      startLocationTracking();
    }
  }

  service.on('cancelPatchRestart').listen((event) async {
    restartRequest = null;
    restartWatchdog?.cancel();
    await restoreTracking();
  });
  service.on('preparePatchRestart').listen((event) async {
    final requestId = event?['requestId'] as String?;
    if (requestId == null || restartRequest != null) return;
    restartRequest = requestId;
    // If the UI/native restart disappears, never leave GPS paused indefinitely.
    restartWatchdog = Timer(const Duration(seconds: 30), () async {
      restartRequest = null;
      await restoreTracking();
    });
    try {
      restartPause = pauseLocationTrackingForRestart();
      await restartPause;
      if (restartRequest != requestId) return;
      service.invoke('patchRestartReady', {
        'requestId': requestId,
        'ready': true,
      });
      // Keep the foreground service alive until the process restarts. Preserve
      // locationTrackingActiveKey; an update is not an attendance check-out.
    } catch (error) {
      if (restartRequest != requestId) return;
      restartRequest = null;
      restartWatchdog?.cancel();
      await restoreTracking();
      service.invoke('patchRestartReady', {
        'requestId': requestId,
        'ready': false,
      });
    }
  });
  final prefs = await SharedPreferences.getInstance();
  await prefs.reload();
  if (prefs.getBool(locationTrackingActiveKey) == true &&
      restartRequest == null) {
    debugPrint('[Location] Foreground service started; subscribing to GPS');
    startLocationTracking();
  }
}

Future<void> prepareLocationForPatchRestart() async {
  final service = FlutterBackgroundService();
  if (!await service.isRunning()) return;
  final requestId = DateTime.now().microsecondsSinceEpoch.toString();
  final ready = Completer<bool>();
  final subscription = service.on('patchRestartReady').listen((event) {
    if (event?['requestId'] == requestId && !ready.isCompleted) {
      ready.complete(event?['ready'] == true);
    }
  });
  try {
    service.invoke('preparePatchRestart', {'requestId': requestId});
    if (!await ready.future.timeout(const Duration(seconds: 20))) {
      throw StateError('Location service could not safely prepare for restart');
    }
  } finally {
    await subscription.cancel();
  }
}

Future<void> resumeLocationAfterFailedRestart() async {
  final service = FlutterBackgroundService();
  if (await service.isRunning()) {
    service.invoke('cancelPatchRestart');
  } else {
    await initializeService();
  }
}

Future<void> checkAndRequestBatteryOptimizations() async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

  if (androidInfo.version.sdkInt >= 23) {
    await requestIgnoreBatteryOptimizations();
  }
}

Future<void> requestIgnoreBatteryOptimizations() async {
  if (Platform.isAndroid) {
    final intent = AndroidIntent(
      action: 'android.settings.IGNORE_BATTERY_OPTIMIZATION_SETTINGS',
      flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
    );
    await intent.launch();
  }
}

Future<void> requestPermissions() async {
  // Request location permissions
  var locationStatus = await Permission.location.request();
  if (!locationStatus.isGranted) {
    // Handle permission denial (Optional: Show user a message)
    return;
  }
  if (Platform.isAndroid &&
      await DeviceInfoPlugin().androidInfo.then(
        (info) => info.version.sdkInt >= 31,
      )) {
    await Permission.scheduleExactAlarm.request();
  }
}

Future<void> setupNotificationChannel() async {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'foreground_service', // Same ID as in your AndroidConfiguration
    'Foreground Location Service',
    description: 'This channel is used by the foreground location service.',
    importance: Importance.low,
  );

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >()
      ?.createNotificationChannel(channel);
}

Future<void> rescheduleTasks() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isTaskScheduled = prefs.getBool('isTaskScheduled') ?? false;

  if (!isTaskScheduled) {
    Workmanager().initialize(callbackDispatcher);
    Workmanager().registerPeriodicTask(
      simpleTaskKey,
      "initializeService",
      frequency: Duration(minutes: 15),
      backoffPolicy: BackoffPolicy.linear,
      initialDelay: Duration(seconds: 10),
      existingWorkPolicy: ExistingPeriodicWorkPolicy.keep,
      backoffPolicyDelay: const Duration(minutes: 1),
      constraints: Constraints(
        networkType: NetworkType.notRequired,
        requiresBatteryNotLow: false,
        requiresCharging: false,
      ),
      inputData: <String, dynamic>{'isForeground': true},
    );

    await prefs.setBool('isTaskScheduled', true);
  }
}

Future<void> scheduleAlarmManager() async {
  await AndroidAlarmManager.periodic(
    const Duration(hours: 2), // Repeat every 2 hours
    123, // Unique ID for the alarm
    resumeWorkManager, // Callback function
    startAt: DateTime.now().add(
      const Duration(seconds: 10),
    ), // Start after 10 seconds
    exact: true,
    wakeup: true,
  );
}
