// ignore_for_file: use_build_context_synchronously, deprecated_member_use, library_private_types_in_public_api

import 'dart:async';

import 'package:aeon_hrms/Screens/Employee%20management/controller/employee_controller.dart';
import 'package:aeon_hrms/Screens/Employee%20management/view/employee_card_screen.dart';
import 'package:aeon_hrms/Screens/Geolocation/GeoLocationList.dart';
import 'package:aeon_hrms/Screens/Home/controller/HomeController.dart';
import 'package:aeon_hrms/Screens/KPI%20Management/KpiListNew.dart';
import 'package:aeon_hrms/Screens/KPI/view/KpiStatusMonthly.dart';
import 'package:aeon_hrms/Utility/AppUpdateTile.dart';
import 'package:aeon_hrms/Utility/utility_function.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:aeon_hrms/Data/Model/attendanceModel.dart';
import 'package:aeon_hrms/Screens/Employee%20management/view/EmployeeDetailsScreen.dart';
import 'package:aeon_hrms/Screens/Employee%20management/view/edit_profile.dart';
import 'package:aeon_hrms/Screens/Exit%20Form/view/ExitList.dart';
import 'package:aeon_hrms/Screens/Home/Customshape.dart';
//import 'package:aeon_hrms/Screens/KPI/view/KpiList.dart';
import 'package:aeon_hrms/Screens/Leave%20Management/view/leave_management.dart';
import 'package:aeon_hrms/Screens/Report/view/myReport.dart';
import 'package:flutter/material.dart';
import 'package:aeon_hrms/Screens/Authentication/sign_in.dart';
import 'package:aeon_hrms/Screens/Time%20Attendence/controller/attendance_controller.dart';
import 'package:aeon_hrms/Screens/Time%20Attendence/view/attendance_List.dart';
import 'package:aeon_hrms/Utility/MLImage.dart';
import 'package:aeon_hrms/Utility/shared_preferences_service.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../constant.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AttendanceController attendanceController = Get.put(
    AttendanceController(),
  );
  final Homecontroller homeController = Get.put(Homecontroller());

  bool _openingCard = false;
  Future<void> _openEmployeeCard() async {
    if (_openingCard) return;
    _openingCard = true;
    try {
      final controller = Get.isRegistered<EmployeeController>()
          ? Get.find<EmployeeController>()
          : Get.put(EmployeeController());
      await controller.getEmployeeDetails();
      if (!mounted) return;
      final employees = controller.employeeDetailsModel?.data;
      if (employees == null || employees.isEmpty)
        throw StateError('No employee details');
      await EmployeeCardScreen(employee: employees.first).launch(context);
    } catch (_) {
      if (mounted)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Unable to load employee card. Please try again.'),
          ),
        );
    } finally {
      _openingCard = false;
    }
  }

  bool isChecked = false;
  bool servicestatus = false;
  bool haspermission = false;
  late LocationPermission permission;
  Attendance? attendance;
  final Location location = Location();
  @override
  void initState() {
    super.initState();
    getSPdata();
    //checkAppisupdateorNot(context);
  }

  void checkAppisupdateorNot(BuildContext context) async {
    await homeController.CompmastToCheckDate();
    DateTime? appStatus;

    // Check if `data` is not null and contains at least one element
    if (homeController.compmastModel?.data != null &&
        homeController.compmastModel!.data!.isNotEmpty) {
      // Get the first element of the list and attempt to parse `sigNDATE`
      appStatus = DateTime.tryParse(
        homeController.compmastModel!.data![0].sigNDATE ?? '',
      );
    }

    // Compare the `appStatus` with the specified date
    if (appStatus != null &&
        appStatus != DateFormat('dd-MM-yyyy').parse("20-10-2024")) {
      print("Date: ${DateFormat('dd-MM-yyyy').format(appStatus)}");
      ApkUpdater().launch(context);
    } else {
      print(
        "Date1: ${appStatus != null ? DateFormat('dd-MM-yyyy').format(appStatus) : 'No valid date'}",
      );
    }
  }

  Future<void> getSPdata() async {
    if (SharedPref.getEmpCode() == "" || SharedPref.getEmpCode() == null) {
      SharedPref.instance.removeAll().whenComplete(() {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (BuildContext context) => const SignIn()),
        );
      });
    } else {
      checkGps();
    }
  }

  Future<void> checkGps() async {
    servicestatus = await Geolocator.isLocationServiceEnabled();
    if (servicestatus) {
      permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Utility.ToastMessage('Location permissions are denied');
        } else if (permission == LocationPermission.deniedForever) {
          Utility.ToastMessage("'Location permissions are permanently denied");
        } else {
          haspermission = true;
        }
      } else {
        haspermission = true;
      }
    } else {
      Utility.ToastMessage("GPS Service is not enabled, turn on GPS location");
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<bool> _onLogoutPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            title: const Text('Are you sure?'),
            content: const Text('Do you want to logout'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () async {
                  SharedPref.instance.removeAll().whenComplete(() {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => const SignIn(),
                      ),
                    );
                  });
                },
                child: const Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 130,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        flexibleSpace: ClipPath(
          clipper: Customshape(),
          child: Container(
            height: 240,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 171, 224, 129),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Image.asset(company_logo, height: 72, width: 32),
            ),
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            Container(
              //height: context.height() / 3,
              height: MediaQuery.of(context).size.height * 0.35,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30.0),
                  bottomRight: Radius.circular(30.0),
                ),
                color: kMainColor,
              ),
              child: Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.25,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30.0),
                        bottomRight: Radius.circular(30.0),
                      ),
                      color: Colors.white,
                    ),
                    child: Center(
                      child:
                          Column(
                            children: [
                              const SizedBox(height: 5.0),
                              const CircleAvatar(
                                radius: 50.0,
                                backgroundColor: kMainColor,
                                backgroundImage: AssetImage('images/emp1.png'),
                              ),
                              const SizedBox(height: 5.0),
                              Text(
                                SharedPref.getEmpName() ?? "",
                                //'emp name',
                                style: kTextStyle.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5.0),
                              Text(
                                SharedPref.getEmpCode() ?? "",
                                //'emp code',
                                style: kTextStyle.copyWith(
                                  color: kGreyTextColor,
                                ),
                              ),
                              const SizedBox(height: 5.0),
                            ],
                          ).onTap(() {
                            //const ProfileScreen().launch(context);
                          }),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Text(
                            'Latitude',
                            style: kTextStyle.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            SharedPref.getLatitude() ?? "",
                            style: kTextStyle.copyWith(color: Colors.white),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            'Longitude',
                            style: kTextStyle.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            SharedPref.getLongitude() ?? "",
                            style: kTextStyle.copyWith(color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10.0),
            ListTile(
              onTap: () {
                //const SettingScree().launch(context);
                const EditProfile().launch(context);
              },
              leading: const Icon(Icons.settings, color: kGreyTextColor),
              title: Text(
                'Employee Details',
                style: kTextStyle.copyWith(color: kGreyTextColor),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                color: kGreyTextColor,
              ),
            ),
            ListTile(
              onTap: () {
                //const SettingScree().launch(context);
                const AttendanceList().launch(context);
              },
              leading: const Icon(Icons.settings, color: kGreyTextColor),
              title: Text(
                'Time & Attendance',
                style: kTextStyle.copyWith(color: kGreyTextColor),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                color: kGreyTextColor,
              ),
            ),
            ListTile(
              onTap: () {
                //const SettingScree().launch(context);
                const LeaveManagement().launch(context);
              },
              leading: const Icon(Icons.settings, color: kGreyTextColor),
              title: Text(
                'Leave Application',
                style: kTextStyle.copyWith(color: kGreyTextColor),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                color: kGreyTextColor,
              ),
            ),
            ListTile(
              onTap: () {
                //const SettingScree().launch(context);
                const MyReportsScreen().launch(context);
              },
              leading: const Icon(Icons.settings, color: kGreyTextColor),
              title: Text(
                'Reports',
                style: kTextStyle.copyWith(color: kGreyTextColor),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                color: kGreyTextColor,
              ),
            ),
            ListTile(
              onTap: () {
                const KpiListNew().launch(context);
              },
              leading: const Icon(Icons.coffee, color: kGreyTextColor),
              title: Text(
                'KPI',
                style: kTextStyle.copyWith(color: kGreyTextColor),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                color: kGreyTextColor,
              ),
            ),
            // ListTile(
            //   onTap: () async {
            //     ApkUpdater().launch(context);
            //   },
            //   leading: const Icon(
            //     FontAwesomeIcons.coffee,
            //     color: kGreyTextColor,
            //   ),
            //   title: Text(
            //     'App Update',
            //     style: kTextStyle.copyWith(color: kGreyTextColor),
            //   ),
            //   trailing: const Icon(
            //     Icons.arrow_forward_ios,
            //     color: kGreyTextColor,
            //   ),
            // ),

            // ListTile(
            //   onTap: () {
            //     const ProfilePage().launch(context);
            //   },
            //   leading: const Icon(
            //     FontAwesomeIcons.coffee,
            //     color: kGreyTextColor,
            //   ),
            //   title: Text(
            //     'Profile',
            //     style: kTextStyle.copyWith(color: kGreyTextColor),
            //   ),
            //   trailing: const Icon(
            //     Icons.arrow_forward_ios,
            //     color: kGreyTextColor,
            //   ),
            // ),
            // ListTile(
            //   onTap: () {
            //     setState(() {
            //       Share.share('check out This Awesome HRM');
            //     });
            //   },
            //   leading: const Icon(
            //     FontAwesomeIcons.userFriends,
            //     color: kGreyTextColor,
            //   ),
            //   title: Text(
            //     'Share With Friends',
            //     style: kTextStyle.copyWith(color: kGreyTextColor),
            //   ),
            //   trailing: const Icon(
            //     Icons.arrow_forward_ios,
            //     color: kGreyTextColor,
            //   ),
            // ),
            ListTile(
              onTap: () {
                _onLogoutPop();
              },
              leading: const Icon(Icons.logout, color: kGreyTextColor),
              title: Text(
                'Logout',
                style: kTextStyle.copyWith(color: kGreyTextColor),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                color: kGreyTextColor,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.68,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Material(
                            elevation: 2.0,
                            child: GestureDetector(
                              onTap: () {
                                //const EmployeeDetails().launch(context);
                                // const EmployeeManagement().launch(context);
                                //const EditProfile().launch(context);
                                const EmployeeDetailsScreen().launch(context);
                              },
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(10.0),
                                decoration: const BoxDecoration(
                                  border: Border(
                                    left: BorderSide(
                                      color: Color(0xFF7C69EE),
                                      width: 3.0,
                                    ),
                                  ),
                                  color: Colors.white,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Image.asset(
                                      img_EmployeeDetails,
                                      height: 72,
                                      width: 72,
                                      fit: BoxFit.fill,
                                    ),
                                    Text(
                                      'Employee Details',
                                      style: kTextStyle.copyWith(
                                        color: kTitleColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20.0),
                        Expanded(
                          child: Material(
                            elevation: 2.0,
                            child: GestureDetector(
                              onTap: _openEmployeeCard,
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(10.0),
                                decoration: const BoxDecoration(
                                  border: Border(
                                    left: BorderSide(
                                      color: Color(0xFFFD72AF),
                                      width: 3.0,
                                    ),
                                  ),
                                  color: Colors.white,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(
                                      Icons.badge_outlined,
                                      size: 72,
                                      color: Color(0xFF388E3C),
                                    ),
                                    Text(
                                      'Employee Card',
                                      style: kTextStyle.copyWith(
                                        color: kTitleColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18.0),
                    Row(
                      children: [
                        Expanded(
                          child: Material(
                            elevation: 2,
                            color: Colors.white,
                            child: InkWell(
                              onTap: () =>
                                  const AttendanceList().launch(context),
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: const BoxDecoration(
                                  border: Border(
                                    left: BorderSide(
                                      color: Color(0xFFFD72AF),
                                      width: 3,
                                    ),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Image.asset(
                                      img_TimeandAttendance,
                                      width: 72,
                                      height: 72,
                                    ),
                                    Text(
                                      'Time & Attendance',
                                      style: kTextStyle.copyWith(
                                        color: kTitleColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Material(
                            elevation: 2,
                            color: Colors.white,
                            child: InkWell(
                              onTap: () =>
                                  const LeaveManagement().launch(context),
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: const BoxDecoration(
                                  border: Border(
                                    left: BorderSide(
                                      color: Color(0xFF02B984),
                                      width: 3,
                                    ),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Image.asset(
                                      img_leavApp,
                                      width: 72,
                                      height: 72,
                                    ),
                                    Text(
                                      'Leave Application',
                                      style: kTextStyle.copyWith(
                                        color: kTitleColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: Material(
                            elevation: 2,
                            color: Colors.white,
                            child: InkWell(
                              onTap: () =>
                                  const MyReportsScreen().launch(context),
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: const BoxDecoration(
                                  border: Border(
                                    left: BorderSide(
                                      color: Color(0xFF4ACDF9),
                                      width: 3,
                                    ),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Image.asset(
                                      'images/reports1.png',
                                      width: 72,
                                      height: 72,
                                    ),
                                    Text(
                                      'Reports',
                                      style: kTextStyle.copyWith(
                                        color: kTitleColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Material(
                            elevation: 2,
                            color: Colors.white,
                            child: InkWell(
                              onTap: () => const ExitList().launch(context),
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: const BoxDecoration(
                                  border: Border(
                                    left: BorderSide(
                                      color: Color(0xFF4DCEFA),
                                      width: 3,
                                    ),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Image.asset(
                                      'images/exit1.png',
                                      width: 72,
                                      height: 72,
                                    ),
                                    Text(
                                      'Exit form',
                                      style: kTextStyle.copyWith(
                                        color: kTitleColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Material(
                      color: Colors.white,
                      elevation: 2,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          border: Border(
                            left: BorderSide(
                              color: Color(0xFF8DD41B),
                              width: 3,
                            ),
                          ),
                        ),
                        child: ListTile(
                          onTap: () => GeoLocationList().launch(context),
                          leading: Image.asset('images/Training.png'),
                          title: Text(
                            'Training',
                            style: kTextStyle.copyWith(
                              color: kTitleColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          trailing: const Icon(Icons.arrow_forward_ios),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Material(
                      elevation: 2.0,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(10.0),
                        decoration: const BoxDecoration(
                          border: Border(
                            left: BorderSide(
                              color: Color(0xFF4DCEFA),
                              width: 3.0,
                            ),
                          ),
                          color: Colors.white,
                        ),
                        child: ListTile(
                          onTap: () {
                            const KpiListNew().launch(context);
                          },
                          leading: const Image(
                            image: AssetImage('images/KPI.png'),
                          ),
                          title: Text(
                            'KPI Input List',
                            maxLines: 2,
                            style: kTextStyle.copyWith(
                              color: kTitleColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          trailing: const Icon(Icons.arrow_forward_ios),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    InkWell(
                      onTap: () {},
                      child: Material(
                        elevation: 2.0,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(10.0),
                          decoration: const BoxDecoration(
                            border: Border(
                              left: BorderSide(
                                color: Color(0xFF4DCEFA),
                                width: 3.0,
                              ),
                            ),
                            color: Colors.white,
                          ),
                          child: ListTile(
                            onTap: () {
                              // const KpiList().launch(context);
                              const KpiStatusMonthly().launch(context);
                            },
                            leading: const Image(
                              image: AssetImage('images/KPI.png'),
                            ),
                            title: Text(
                              'KPI Status',
                              maxLines: 2,
                              style: kTextStyle.copyWith(
                                color: kTitleColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            trailing: const Icon(Icons.arrow_forward_ios),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            color: Colors.green,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                children: [
                  Text(
                    "AVAYAYAYA AGRISOLUTIONS PRIVATE LIMITED",
                    textAlign: TextAlign.center,
                    style: kTextStyle.copyWith(fontWeight: FontWeight.w100),
                  ),
                  Text(
                    "The Spring CHS FLH/302, Ploat NO.4 Sevctor 20 Kalamboli Node, Panvel, Raigarh(MH)-410218",
                    textAlign: TextAlign.center,
                    style: kTextStyle.copyWith(fontSize: 8),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
