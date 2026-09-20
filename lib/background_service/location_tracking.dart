import 'dart:async';

import 'package:aeon_hrms/Utility/DatabaseHelper.dart';
import 'package:aeon_hrms/Utility/shared_preferences_service.dart';
import 'package:aeon_hrms/Utility/utility_function.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String locationTrackingActiveKey = 'location_tracking_active';
const double _minMovementDistanceMeters = 50;
const Duration _minLoggingInterval = Duration(minutes: 2);
const Duration _maxLoggingInterval = Duration(minutes: 30);
const String _lastLatKey = 'nia_last_logged_lat';
const String _lastLngKey = 'nia_last_logged_lng';
const String _lastTimestampKey = 'nia_last_logged_timestamp';

StreamSubscription<Position>? _positionSubscription;
bool _isProcessingPosition = false;
ServiceInstance? _activeService;

void setTrackingServiceInstance(ServiceInstance? service) {
  _activeService = service;
}

/// Called when tracking is (re)enabled so the first fresh fix is always saved.
Future<void> resetLocationTrackingCache() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove(_lastLatKey);
  await prefs.remove(_lastLngKey);
  await prefs.remove(_lastTimestampKey);
}

void startLocationTracking() {
  _positionSubscription?.cancel();
  debugPrint('[Location] Starting GPS position stream');
  const locationSettings = LocationSettings(
    accuracy: LocationAccuracy.bestForNavigation,
    distanceFilter: 20,
  );

  try {
    _positionSubscription =
        Geolocator.getPositionStream(locationSettings: locationSettings).listen(
          (position) async {
            await _handleIncomingPosition(position);
          },
          onError: (error) {
            debugPrint('[Location] GPS stream error: $error');
          },
        );
  } catch (error) {
    debugPrint('[Location] Could not start GPS stream: $error');
  }

  _determinePosition();
  _updateServiceNotification(
    title: 'Location tracking active',
    content: 'Waiting for the first GPS fix…',
  );
}

Future<void> stopLocationTracking() async {
  await _positionSubscription?.cancel();
  _positionSubscription = null;
}

Future<void> _determinePosition() async {
  try {
    if (!await Geolocator.isLocationServiceEnabled()) {
      debugPrint('[Location] Device location is disabled');
      return;
    }
    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      debugPrint('[Location] Location permission unavailable in service');
      return;
    }
    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
      timeLimit: const Duration(seconds: 20),
    );
    await _handleIncomingPosition(position);
  } catch (e) {
    debugPrint('Error determining position: $e');
  }
}

Future<void> _handleIncomingPosition(Position position) async {
  if (_isProcessingPosition) return;
  _isProcessingPosition = true;
  try {
    final shouldLog = await _shouldLogPosition(position);
    if (!shouldLog) {
      return;
    }

    String address = '';
    try {
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (placemarks.isNotEmpty) {
        final p = placemarks.first;
        address =
            '${p.street ?? ''} ${p.subLocality ?? ''} ${p.subAdministrativeArea ?? ''} ${p.locality ?? ''} ${p.country ?? ''} ${p.postalCode ?? ''}'
                .trim();
      }
    } catch (e) {
      debugPrint('Reverse-geocoding failed: $e');
    }

    var loggedSuccessfully = false;
    try {
      await _persistLocationPoint(
        '${position.latitude}',
        '${position.longitude}',
        address,
      );
      loggedSuccessfully = true;
    } catch (e) {
      debugPrint('[Location] Point could not be saved: $e');
    } finally {
      if (loggedSuccessfully) {
        await _cacheLastLoggedPosition(position);
      }
    }
    if (loggedSuccessfully) {
      debugPrint(
        '[Location] Point persisted: ${position.latitude}, ${position.longitude}',
      );
      unawaited(_updateServiceNotification(position: position));
    }
  } catch (e) {
    debugPrint('Error handling position: $e');
  } finally {
    _isProcessingPosition = false;
  }
}

Future<void> _persistLocationPoint(
  String latitude,
  String longitude,
  String address,
) async {
  final prefs = await SharedPreferences.getInstance();
  final empCode = prefs.getString('empcode') ?? SharedPref.getEmpCode();
  if (empCode == null || empCode.isEmpty) {
    throw StateError('EMP_CODE not found for location tracking');
  }

  final DateTime now = DateTime.now();
  String two(int n) => n.toString().padLeft(2, '0');
  final String currentDate =
      '${now.year}-${two(now.month)}-${two(now.day)}';
  final String currentDateTime = '$currentDate '
      '${two(now.hour)}:${two(now.minute)}:${two(now.second)}';

  String mobileNetwork = '';
  try {
    mobileNetwork = await Utility.checkNetworkStatus();
  } catch (error) {
    debugPrint('[Location] Network status unavailable: $error');
  }

  await DatabaseHelper().insertEmployee({
    'emp_code': empCode,
    'atdate': currentDate,
    'in_out_date': currentDateTime,
    'LATITUDE': latitude,
    'LONGITUDE': longitude,
    'ADDRESS': address,
    'MOBILE_NETWORK': mobileNetwork,
  });
}

Future<bool> _shouldLogPosition(Position position) async {
  final prefs = await SharedPreferences.getInstance();
  final lastLat = prefs.getDouble(_lastLatKey);
  final lastLng = prefs.getDouble(_lastLngKey);
  final lastTimestampIso = prefs.getString(_lastTimestampKey);

  DateTime? lastTimestamp;
  if (lastTimestampIso != null) {
    lastTimestamp = DateTime.tryParse(lastTimestampIso);
  }
  final Duration timeGap = lastTimestamp == null
      ? const Duration(days: 365)
      : DateTime.now().difference(lastTimestamp);

  if (timeGap >= _maxLoggingInterval) {
    return true;
  }

  if (lastLat == null || lastLng == null) {
    return true;
  }

  final double travelled = Geolocator.distanceBetween(
    lastLat,
    lastLng,
    position.latitude,
    position.longitude,
  );
  if (travelled >= _minMovementDistanceMeters &&
      timeGap >= _minLoggingInterval) {
    return true;
  }

  debugPrint(
    'Skipping duplicate location. Distance=${travelled.toStringAsFixed(2)}m, '
    'elapsed=${timeGap.inSeconds}s',
  );
  return false;
}

Future<void> _cacheLastLoggedPosition(Position position) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setDouble(_lastLatKey, position.latitude);
  await prefs.setDouble(_lastLngKey, position.longitude);
  await prefs.setString(_lastTimestampKey, DateTime.now().toIso8601String());
}

Future<void> _updateServiceNotification({
  String? title,
  String? content,
  Position? position,
}) async {
  try {
    final service = _activeService;
    if (service is AndroidServiceInstance) {
      final DateTime now = DateTime.now();
      final String hh = now.hour.toString().padLeft(2, '0');
      final String mm = now.minute.toString().padLeft(2, '0');
      final String lat = position?.latitude.toStringAsFixed(5) ?? '--';
      final String lng = position?.longitude.toStringAsFixed(5) ?? '--';
      await service.setForegroundNotificationInfo(
        title: title ?? 'Location tracking active',
        content: content ?? 'Last update: $hh:$mm · $lat, $lng',
      );
    }
  } catch (error) {
    debugPrint('[Location] Notification update failed: $error');
  }
}

class GeolocationService {
  static final GeolocationService _instance = GeolocationService._internal();
  factory GeolocationService() => _instance;
  GeolocationService._internal();

  Future<Position?> getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      debugPrint('Location services are disabled.');
      return null;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        debugPrint('Location permissions are denied.');
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      debugPrint('Location permissions are permanently denied.');
      return null;
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.bestForNavigation,
    );
  }
}
