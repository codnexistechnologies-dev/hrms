import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

bool isRequestingPermissions = false;

Future<bool> checkAndRequestPermissions(
    {bool requestPermissions = false}) async {
  if (isRequestingPermissions) return false;
  isRequestingPermissions = true;

  // Initialize permissions list
  final List<Permission> permissions = [
    Permission.location,
    Permission.camera,
    if (Platform.isAndroid && await _requiresBatteryOptimizationPermission())
      Permission.ignoreBatteryOptimizations,
  ];

  bool allGranted = true;

  // Request permissions
  for (var permission in permissions) {
    var status = await permission.status;

    if (status.isDenied || status.isPermanentlyDenied) {
      if (requestPermissions) {
        var result = await permission.request();

        // Handle permission permanently denied
        if (result.isPermanentlyDenied) {
          allGranted = false;
          _showSettingsDialog();
          break;
        }

        // If permission still not granted, fail
        if (!result.isGranted) {
          allGranted = false;
          break;
        }
      } else {
        allGranted = false;
        break;
      }
    }
  }

  isRequestingPermissions = false;
  return allGranted;
}

Future<bool> _requiresBatteryOptimizationPermission() async {
  final deviceInfo = DeviceInfoPlugin();
  final androidInfo = await deviceInfo.androidInfo;
  return androidInfo.version.sdkInt < 34;
}

// Show dialog to navigate to app settings
void _showSettingsDialog() {
  print(
      'Some permissions are permanently denied. Please enable them in settings.');
  // Add your UI logic here to navigate the user to settings using `openAppSettings()`
  openAppSettings();
}
