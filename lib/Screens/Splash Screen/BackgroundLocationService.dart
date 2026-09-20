// import 'dart:async';
// import 'dart:ui';
// import 'package:flutter_background_service/flutter_background_service.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:get/get.dart';
// import 'package:aeon_hrms/Screens/Time%20Attendence/controller/attendance_controller.dart';

// class BackgroundLocationService {
//   static final AttendanceController attendanceController =
//       Get.put(AttendanceController());

//   static Future<void> initializeService() async {
//     final service = FlutterBackgroundService();
//     await service.configure(
//       iosConfiguration: IosConfiguration(),
//       androidConfiguration: AndroidConfiguration(
//         onStart: onStart,
//         isForegroundMode: true,
//         autoStart: true,
//         autoStartOnBoot: true,
//       ),
//     );
//     service.startService();
//   }

//   static Future<Position?> _getCurrentPosition() async {
//     bool serviceEnabled;
//     LocationPermission permission;

//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       print('Location services are disabled.');
//       return null;
//     }

//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         print('Location permissions are denied.');
//         return null;
//       }
//     }

//     if (permission == LocationPermission.deniedForever) {
//       print('Location permissions are permanently denied.');
//       return null;
//     }

//     return await Geolocator.getCurrentPosition();
//   }

//   static void startBackgroundService() {
//     Timer.periodic(Duration(minutes: 3), (Timer timer) async {
//       Position? position = await _getCurrentPosition();

//       if (position != null) {
//         // Send the most recent position to the API
//         attendanceController.SaveGeoLocationByEmpCodeandAtdate(
//             "${position.latitude}", "${position.longitude}");
//       }
//     });
//   }

//   @pragma('vm:entry-point')
//   static void onStart(ServiceInstance service) async {
//     try {
//       DartPluginRegistrant.ensureInitialized();

//       if (service is AndroidServiceInstance) {
//         service.on('setAsForeground').listen((event) {
//           service.setAsForegroundService();
//         });

//         service.setForegroundNotificationInfo(
//           title: "Background Location Service",
//           content: "Running background location tracking",
//         );
//       }

//       startBackgroundService();
//     } catch (e, stackTrace) {
//       print('Error in background service: $e');
//       print(stackTrace);
//     }
//   }
// }
