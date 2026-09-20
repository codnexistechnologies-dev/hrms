import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';
import 'dart:io';

class ApkUpdater extends StatelessWidget {
  final String apkUrl =
      'http://160.25.62.162:84/APKFloder/NIA.apk'; // Replace with your actual APK URL
  static const platform = MethodChannel('apk_install_channel');

  const ApkUpdater({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('APK Updater'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                // Request permissions and update the app
                if (await _requestPermissions()) {
                  await _downloadAndInstallApk(apkUrl);
                }
              },
              child: const Text('Update App'),
            ),
            const SizedBox(height: 20), // Spacing between button and message
            Text(
              "If Download completed. Please check the downloaded file.", // Display the message
              style: TextStyle(fontSize: 16, color: Colors.blue),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _requestPermissions() async {
    if (Platform.isAndroid) {
      int sdkVersion = await _getSdkInt();

      if (sdkVersion >= 33) {
        // Android 13+ specific permissions (Photos, Videos, and Files)
        var statusPhotos = await Permission.photos.status;
        var statusVideos = await Permission.videos.status;
        var statusAudio = await Permission.audio.status;

        if (!statusPhotos.isGranted ||
            !statusVideos.isGranted ||
            !statusAudio.isGranted) {
          var statusPhotosRequest = await Permission.photos.request();
          var statusVideosRequest = await Permission.videos.request();
          var statusAudioRequest = await Permission.audio.request();

          if (!statusPhotosRequest.isGranted ||
              !statusVideosRequest.isGranted ||
              !statusAudioRequest.isGranted) {
            return false;
          }
        }
      } else {
        // For Android 12 and below, we request the storage permission
        var status = await Permission.storage.status;
        if (!status.isGranted) {
          status = await Permission.storage.request();
          if (!status.isGranted) {
            return false;
          }
        }
      }

      // Also check if the app can install unknown APKs
      var installStatus = await Permission.requestInstallPackages.status;
      if (!installStatus.isGranted) {
        installStatus = await Permission.requestInstallPackages.request();
        if (!installStatus.isGranted) {
          return false;
        }
      }
      return true;
    }
    return false;
  }

// Helper method to get Android SDK version
  Future<int> _getSdkInt() async {
    final MethodChannel platform = MethodChannel('sdk_channel');
    try {
      final int sdkVersion = await platform.invokeMethod('getSdkVersion');
      return sdkVersion;
    } on PlatformException catch (e) {
      print('Failed to get SDK version: ${e.message}');
      return 0;
    }
  }

  // Create the folder if it doesn't exist
  // Future<String> _createApkFolder() async {
  //   Directory? externalStorageDir = await getExternalStorageDirectory();
  //   String apkFolderPath = '${externalStorageDir!.path}/ApkFolder';

  //   //Directory apkFolder = Directory(apkFolderPath);
  //   Directory apkFolder = Directory('/storage/emulated/0/Download');
  //   if (!await apkFolder.exists()) {
  //     await apkFolder.create(recursive: true);
  //   }

  //   //final filePath = '${directory.path}/payslip_$timestamp.pdf';
  //   //print(filePath);

  //   return apkFolderPath;
  // }

  // Download APK to the ApkFolder and trigger installation
  Future<void> _downloadAndInstallApk(String url) async {
    try {
      // Dio dio = Dio();
      // final directory = Directory('/storage/emulated/0/Download');
      // int timestamp = DateTime.now().millisecondsSinceEpoch;
      // final filePath = '${directory.path}/Nia_$timestamp.apk';
      // print(filePath);
      Dio dio = Dio();
      final directory = await getExternalStorageDirectory();
      int timestamp = DateTime.now().millisecondsSinceEpoch;
      final filePath = '${directory!.path}/Nia_$timestamp.apk';
      print('Saving APK to: $filePath');

      //String apkFolderPath = await _createApkFolder();
      //String filePath = '$apkFolderPath/Nia.apk';

      // Download the APK
      await dio.download(url, filePath);
      print('APK downloaded to: $filePath');

      // Verify if the APK file exists
      if (await File(filePath).exists()) {
        // Call native Android code to install the APK
        await platform.invokeMethod('installApk', {'apkPath': filePath});
      } else {
        print('APK download failed. File not found.');
      }
    } catch (e) {
      print('Error downloading/installing APK: $e');
    }
  }
}
