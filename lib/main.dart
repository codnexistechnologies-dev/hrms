import 'dart:async';

import 'package:aeon_hrms/Data/Repositories/UserDetails_repository.dart';
import 'package:aeon_hrms/Screens/Splash%20Screen/splash_screen.dart';
import 'package:aeon_hrms/Utility/shared_preferences_service.dart';
import 'package:aeon_hrms/background_service/background_service.dart';
import 'package:aeon_hrms/component/storage_helper.dart';
import 'package:aeon_hrms/component/patch_update_notice.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

// Backward-compatible re-exports for screens that used to import these from
// main.dart. The real implementations now live in lib/background_service/.
export 'package:aeon_hrms/background_service/background_service.dart'
    show
        initializeService,
        setLocationTrackingActive,
        callbackDispatcher,
        resumeWorkManager,
        requestPermissions,
        rescheduleTasks,
        scheduleAlarmManager,
        setupNotificationChannel;
export 'package:aeon_hrms/background_service/location_tracking.dart'
    show GeolocationService, locationTrackingActiveKey;

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint(message.data.toString());
  debugPrint(message.notification?.title);

  debugPrint("Handling a background message: ${message.messageId}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SharedPref.initialize();
  await Firebase.initializeApp();
  await StorageHelper.initialize();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());

  // Start optional services after the first frame so startup is not blocked by
  // permission dialogs or Android background-service initialization.
  unawaited(initializeBackgroundServices());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static final GlobalKey<NavigatorState> _navigatorKey =
      GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => UserDetailsRepository(),
      child: GetMaterialApp(
        navigatorKey: _navigatorKey,
        debugShowCheckedModeBanner: false,
        title: 'Welcome to HRMS',
        builder: (context, child) => SafeArea(
          top: false,
          bottom: true,
          child: PatchUpdateNotice(
            navigatorKey: _navigatorKey,
            child: child ?? const SizedBox.shrink(),
          ),
        ),
        home: SplashScreen(),
      ),
    );
  }
}
