import 'dart:async';

import 'package:aeon_hrms/Utility/MLImage.dart';
import 'package:aeon_hrms/component/storage_helper.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:aeon_hrms/Screens/Authentication/sign_in.dart';
import 'package:aeon_hrms/Screens/Home/home_screen.dart';
import 'package:aeon_hrms/Utility/shared_preferences_service.dart';
//import 'package:aeon_hrms/Utility/location_handler.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../constant.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isLogedin = false;
  String _appVersion = '';

  @override
  void initState() {
    super.initState();
    _loadAppVersion();
    Future.microtask(() => getSPdata(context));
  }

  Future<void> _loadAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    if (!mounted) return;
    setState(() {
      _appVersion = packageInfo.version;
    });
  }

  Future<void> checkAndRequestPermissions() async {
    final statuses = await [
      Permission.location,
      Permission.camera,
      Permission.storage,
      Permission.notification, // etc.
    ].request();

    statuses.forEach((permission, status) {
      if (status.isDenied) {
        // Handle permission denied (e.g., show an alert).
      }
    });
  }

  Future<void> getSPdata(BuildContext context) async {
    // Ensure SharedPref is initialized properly and getEmpCode() is valid

    String? empCode = await SharedPref.getEmpCode();

    if (empCode == null || empCode.isEmpty) {
      // Remove all shared preferences if empCode is null or empty
      SharedPref.instance.removeAll().whenComplete(() {
        Timer(
          const Duration(seconds: 3),
          () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => const SignIn(),
            ),
          ),
        );
      });
    } else {
      // If empCode is valid, navigate to HomeScreen after 3 seconds delay
      Timer(
        const Duration(seconds: 3),
        () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 171, 224, 129),
        // backgroundColor: kMainColor,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 2000),
                curve: Curves.easeIn,
                builder: (context, opacity, child) {
                  return Opacity(opacity: opacity, child: child);
                },
                child: Image.asset(company_logo, height: 150, fit: BoxFit.fill),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Text(
                  _appVersion.isEmpty ? 'Version ...' : 'Version $_appVersion',
                  style: GoogleFonts.manrope(
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                    fontSize: 15.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
