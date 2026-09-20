import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:date_format/date_format.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
//import 'package:fluttertoast/fluttertoast.dart';
import 'package:aeon_hrms/Data/Model/attendanceModel.dart';
import 'package:aeon_hrms/Data/Repositories/UserDetails_repository.dart';
import 'package:aeon_hrms/Utility/shared_preferences_service.dart';
import 'package:aeon_hrms/Utility/utility_function.dart';
import 'package:aeon_hrms/constant.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
//import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:aeon_hrms/main.dart' show setLocationTrackingActive;

class MarkAttendanceWithMap extends StatefulWidget {
  const MarkAttendanceWithMap({super.key});

  @override
  State<MarkAttendanceWithMap> createState() => _MarkAttendanceWithMapState();
}

class _MarkAttendanceWithMapState extends State<MarkAttendanceWithMap> {
  dynamic long = "", lat = "";
  // String? _currentAddress;
  dynamic longitude = "";
  dynamic latitude = "";
  String intime = "", outtime = "";
  String inoutflag = "";
  String atdate = "";
  String empname = "";
  String emailid = "";
  String loccode = "";
  LocationSettings locationSettings = const LocationSettings(
    accuracy: LocationAccuracy.high, //accuracy of the location data
    distanceFilter: 10, //minimum distance (measured in meters) a
    // device must move horizontally before an update event is generated;
  );
  Attendance? attendance;
  bool servicestatus = false;
  bool haspermission = false;
  late LocationPermission permission;
  late Position position;

  late StreamSubscription<Position> positionStream;
  late Position _currentPosition;
  // late Position _previousPosition;
  late StreamSubscription<Position> _positionStream;
  double _totalDistance = 0;
  String emp_code = "";
  List<Position> locations = <Position>[];
  @override
  void initState() {
    checkGps();
    super.initState();
  }

  Future<void> checkGps() async {
    servicestatus = await Geolocator.isLocationServiceEnabled();
    if (servicestatus) {
      permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print('Location permissions are denied');
        } else if (permission == LocationPermission.deniedForever) {
          print("'Location permissions are permanently denied");
        } else {
          haspermission = true;
        }
      } else {
        haspermission = true;
      }

      if (haspermission) {
        setState(() {
          //refresh the UI
        });

        _calculateDistance();
        GetAttendance();
      }
    } else {
      print("GPS Service is not enabled, turn on GPS location");
    }
  }

  String? address;
  bool isloading = false;
  Future _calculateDistance() async {
    isloading = true;
    _positionStream =
        Geolocator.getPositionStream().listen((Position position) async {
      if ((await Geolocator.isLocationServiceEnabled())) {
        Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
            .then((Position position) async {
          // setState(() {
          _currentPosition = position;
          locations.add(_currentPosition);
          long = position.longitude.toString();
          lat = position.latitude.toString();

          if (locations.length > 1) {
            var distanceBetweenLastTwoLocations = Geolocator.distanceBetween(
              double.parse(SharedPref.getLatitude()),
              double.parse(SharedPref.getLongitude()),
              double.parse(lat),
              double.parse(long),
            );
            _totalDistance = distanceBetweenLastTwoLocations;
          }
          List<Placemark> placemarks = await placemarkFromCoordinates(
              double.parse(lat), double.parse(long));
          address =
              "${placemarks[0].street!} ${placemarks[0].subLocality!} ${placemarks[0].subAdministrativeArea!} ${placemarks[0].locality!} ${placemarks[0].country!} ${placemarks[0].postalCode!}";
          // });
          setState(() {});
        }).catchError((err) {
          print(err);
        });
      } else {
        print("GPS is off.");
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: const Text('Make sure your GPS is on in Settings !'),
                actions: <Widget>[
                  ElevatedButton(
                      child: const Text('OK'),
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).pop();
                      })
                ],
              );
            });
      }
    });
    isloading = false;
  }

  Future<void> chechDistinceMark(checkInOut) async {
    if (_totalDistance > 0) {
      saveAttendance(checkInOut);
    } else {
      saveAttendance(checkInOut);
    }
  }

  Future<String> getDeviceInfo() async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    String model = "";
    if (Platform.isAndroid) {
      final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      model = androidInfo.model;
    }
    return model;
  }

  void saveAttendance(String checkInOut) async {
    final String deviceName = await Utility.getDeviceInfo();
    List<Placemark> placemarks =
        await placemarkFromCoordinates(double.parse(lat), double.parse(long));
    final Map<String, dynamic> data = <String, dynamic>{
      'EMP_CODE': SharedPref.getEmpCode(),
      'ADDRESS':
          "${placemarks[0].street!} ${placemarks[0].subLocality!} ${placemarks[0].subAdministrativeArea!} ${placemarks[0].locality!} ${placemarks[0].country!} ${placemarks[0].postalCode!}",
      'COMP_CODE': deviceName,
      'LOC_CODE': SharedPref.getLocCode(),
      'LATITUDE': lat,
      'LONGITUDE': long,
      'DISTANCE': _totalDistance,
      'CHECK_IN_OUT': checkInOut,
      'MOB_VERSION': "Ver-2",
    };
    if (kDebugMode) {
      print(data);
    }
    try {
      final dataRepository =
          Provider.of<UserDetailsRepository>(context, listen: false);
      final http.Response response = await dataRepository.SaveAttendance(data);
      if (kDebugMode) {
        print(response.statusCode);
      }
      if (response.statusCode == 200) {
        final savedAttendance = Attendance.fromJson(json.decode(response.body));
        if (savedAttendance.data.isEmpty ||
            savedAttendance.data.first.checKInOut?.toUpperCase() !=
                checkInOut.toUpperCase()) {
          throw StateError('Attendance response did not confirm $checkInOut');
        }
        await setLocationTrackingActive(checkInOut.toUpperCase() == 'IN');
        attendance = savedAttendance;
        setState(() {
          atdate =
              formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]).toString();
          intime = attendance!.data.first.iNTime.toString();
          outtime = attendance!.data.first.ouTTime.toString();
          inoutflag = attendance!.data.first.checKInOut.toString();
        });
        Utility.ToastMessage("Done");
      } else {
        Utility.ToastMessage("Not Done");
        throw Exception('Failed');
      }
    } catch (e) {
      debugPrint('Attendance $checkInOut failed: $e');
      Utility.ToastMessage('Attendance failed: $e');
    } finally {}
  }

  Future<void> GetAttendance() async {
    final Map<String, dynamic> data = <String, dynamic>{
      'EMP_CODE': SharedPref.getEmpCode(),
    };
    try {
      final dataRepository =
          Provider.of<UserDetailsRepository>(context, listen: false);
      final http.Response response = await dataRepository.GetAttendance(data);
      if (response.statusCode == 200) {
        attendance = Attendance.fromJson(json.decode(response.body));
        setState(() {
          atdate =
              formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]).toString();
          intime = attendance!.data.first.iNTime.toString();
          outtime = attendance!.data.first.ouTTime.toString();
          inoutflag = attendance!.data.first.checKInOut.toString();
        });
      } else {
        Utility.ToastMessage("Not Done");
        throw Exception('Failed');
      }
    } catch (e) {
      //Utility.ToastMessage(e as String);
      // throw Exception('Failed');
    } finally {}
  }

  @override
  void dispose() {
    super.dispose();
    _positionStream.cancel();
  }

  bool isSelectedDistanceCheckbox = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kMainColor,
        elevation: 0.0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'Mark Attendance',
          style: kTextStyle.copyWith(
              color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: isloading == true
          ? CircularProgressIndicator()
          : Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 80,
                            width: 140,
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 205, 248, 206),
                              borderRadius: BorderRadius.all(
                                Radius.circular(8),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.alarm),
                                    Column(
                                      children: [
                                        Text(
                                          "  In Time",
                                          style: const TextStyle(
                                            color: Colors.green,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 20,
                                          ),
                                        ),
                                        Text(
                                          " $intime",
                                          style: const TextStyle(
                                            color: Colors.green,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            height: 80,
                            width: 140,
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 251, 211, 209),
                              borderRadius: BorderRadius.all(
                                Radius.circular(8),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.alarm),
                                    Column(
                                      children: [
                                        Text(
                                          " Out Time",
                                          style: const TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 18,
                                          ),
                                        ),
                                        Text(
                                          outtime,
                                          style: const TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Current address",
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              fontSize: 17,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("$address"),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Distance",
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              fontSize: 17,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                            ),
                            width: double.infinity,
                            // height: 50,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  // ignore: unnecessary_null_comparison
                                  '${_totalDistance != null ? _totalDistance > 1000 ? (_totalDistance / 1000).toStringAsFixed(2) : _totalDistance.toStringAsFixed(2) : 0} ${_totalDistance != null ? _totalDistance > 1000 ? 'KM' : 'meters' : 0}',
                                  // style: const TextStyle(
                                  //   fontSize: 20,
                                  // ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal: 20),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.center,
                    //     children: [
                    //       SizedBox(
                    //         height: 30,
                    //         width: 30,
                    //         child: Checkbox(
                    //           activeColor: Colors.green,
                    //           value: isSelectedDistanceCheckbox,
                    //           onChanged: (value) {
                    //             setState(() {
                    //               isSelectedDistanceCheckbox = value!;
                    //             });
                    //           },
                    //         ),
                    //       ),
                    //       Text("Out of office"),
                    //     ],
                    //   ),
                    // ),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            // Place `Expanded` inside `Row`

                            child: ElevatedButton(
                              style: TextButton.styleFrom(
                                  backgroundColor: Colors.green),
                              onPressed: () {
                                chechDistinceMark('IN');
                              },
                              child: const Text(
                                'Mark IN',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 17),
                              ), // Every button need a callback
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            // Place 2 `Expanded` mean: they try to get maximum size and they will have same size
                            child: ElevatedButton(
                              style: TextButton.styleFrom(
                                  backgroundColor: Colors.red),
                              onPressed: () {
                                chechDistinceMark('OUT');
                              },
                              child: const Text(
                                'Mark OUT',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 17),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
