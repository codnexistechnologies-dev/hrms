import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:aeon_hrms/Data/Model/attendanceModel.dart';
import 'package:aeon_hrms/Data/Repositories/UserDetails_repository.dart';
import 'package:aeon_hrms/constant.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:aeon_hrms/Utility/MLString.dart';
import 'package:aeon_hrms/Utility/shared_preferences_service.dart';
import 'package:aeon_hrms/Utility/utility_function.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:date_format/date_format.dart';
import 'package:provider/provider.dart';

import 'package:geolocator/geolocator.dart';
import 'map.dart';

class MarkAttendance extends StatefulWidget {
  const MarkAttendance({super.key});

  @override
  _MarkAttendanceState createState() => _MarkAttendanceState();
}

class _MarkAttendanceState extends State<MarkAttendance> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  late GoogleMapController mapController;

  bool isPresent = false;
  bool isAbsent = false;
  bool isHalfDay = false;
  bool isHoliday = false;
  bool inTimeSelected = false;
  bool outTimeSelected = false;
  TimeOfDay selectedInTime = TimeOfDay.now();
  TimeOfDay selectedOutTime = TimeOfDay.now();
  dynamic long = "", lat = "";
  //String? _currentAddress;
  dynamic longitude = "";
  dynamic latitude = "";
  String intime = "", outtime = "";
  String inoutflag = "";
  String atdate = "";
  String currentDate = formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]);
  String empname = "";
  String emailid = "";
  bool servicestatus = false;
  bool haspermission = false;
  late LocationPermission permission;
  late Position position;

  late StreamSubscription<Position> positionStream;
  late Position _currentPosition;
  //late Position _previousPosition;
  Attendance? attendance;
  late StreamSubscription<Position> _positionStream;
  double _totalDistance = 0;
  String currentAddress = "";
  List<Position> locations = <Position>[];

  @override
  void initState() {
    //LocationServiceAi.initialize();
    // LocationHandler.requestPermission();

    GetAttendance();
    _calculateDistance();
    super.initState();
  }

  Future<void> selectInTime(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: selectedInTime,
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (timeOfDay != null && timeOfDay != selectedInTime) {
      setState(() {
        selectedInTime = timeOfDay;
        inTimeSelected = true;
      });
    }
  }

  Future<void> selectOutTime(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: selectedOutTime,
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (timeOfDay != null && timeOfDay != selectedOutTime) {
      setState(() {
        selectedOutTime = timeOfDay;
        outTimeSelected = true;
      });
    }
  }

  Future _calculateDistance() async {
    _positionStream =
        Geolocator.getPositionStream().listen((Position position) async {
      if ((await Geolocator.isLocationServiceEnabled())) {
        Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
            .then((Position position) {
          setState(() {
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
              if (_totalDistance < 1000 && _totalDistance > 0) {
                if (_totalDistance < 100) {
                  if (atdate == "") {
                    saveAttendance('IN');
                  } else if (formatDate(DateTime.parse(atdate),
                              [yyyy, '-', mm, '-', dd]) ==
                          formatDate(DateTime.parse(currentDate),
                              [yyyy, '-', mm, '-', dd]) &&
                      inoutflag == "OUT") {
                    saveAttendance('IN');
                  }
                } else if (_totalDistance > 100) {
                  if (formatDate(DateTime.parse(atdate),
                              [yyyy, '-', mm, '-', dd]) ==
                          formatDate(DateTime.parse(currentDate),
                              [yyyy, '-', mm, '-', dd]) &&
                      inoutflag == "IN") {
                    saveAttendance('MOUT');
                  }
                }
                if (kDebugMode) {
                  print(_totalDistance);
                }
              }
              getCurrentAddress();
            }
          });
        }).catchError((err) {
          if (kDebugMode) {
            print(err);
          }
        });
      } else {
        if (kDebugMode) {
          print("GPS is off.");
        }
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
      Utility.ToastMessage(e as String);
      // throw Exception('Failed');
    } finally {}
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
        attendance = Attendance.fromJson(json.decode(response.body));
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
      Utility.ToastMessage(e as String);
      // throw Exception('Failed');
    } finally {}
  }

  void getCurrentAddress() {
    Timer(
        const Duration(seconds: 5),
        () => setState(() async {
              List<Placemark> curPlacemarks = await placemarkFromCoordinates(
                  double.parse(lat), double.parse(long));
              currentAddress =
                  "${curPlacemarks[0].street!} ${curPlacemarks[0].subLocality!} ${curPlacemarks[0].subAdministrativeArea!} ${curPlacemarks[0].locality!} ${curPlacemarks[0].country!} ${curPlacemarks[0].postalCode!}";
            }));
    //print(Current_Address);
  }

  @override
  void dispose() {
    //_selectInTime(context).dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kMainColor,
        elevation: 0.0,
        titleSpacing: 0.0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          st_MarkAttendance,
          maxLines: 2,
          style: kTextStyle.copyWith(
              color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              children: [
                SizedBox(
                  width: context.width(),
                  height: MediaQuery.of(context).size.height * 0.4,
                  child: MapsPage(),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.6,
                  width: context.width(),
                  color: const Color.fromARGB(255, 35, 34, 33),
                  child: Column(
                    children: [
                      const SizedBox(height: 85),
                      const Text(
                        "Punch In Now",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 25),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        Utility.dateToTimeAm(DateTime.now()),
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        // ignore: unnecessary_null_comparison
                        "Out of range (${_totalDistance != null ? _totalDistance > 1000 ? (_totalDistance / 1000).toStringAsFixed(2) : _totalDistance.toStringAsFixed(2) : 0} ${_totalDistance != null ? _totalDistance > 1000 ? 'KM' : 'meters' : 0})",
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                      const SizedBox(height: 10),
                      const Divider(
                        color: Colors.white,
                        thickness: 1,
                        endIndent: 20,
                        indent: 20,
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Today",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 6, 189, 33),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            ),
                            Text(
                              formatDate(
                                  DateTime.now(), [yyyy, '-', mm, '-', dd]),
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 6, 189, 33),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "IN TIME:-$intime",
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            ),
                            Text(
                              "OUT TIME:-$outtime",
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Divider(
                        color: Colors.white,
                        thickness: 1,
                        endIndent: 20,
                        indent: 20,
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Current Location",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 6, 189, 33),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            ),
                            Text(
                              // ignore: unnecessary_null_comparison
                              '${_totalDistance != null ? _totalDistance > 1000 ? (_totalDistance / 1000).toStringAsFixed(2) : _totalDistance.toStringAsFixed(2) : 0} ${_totalDistance != null ? _totalDistance > 1000 ? 'KM' : 'meters' : 0}',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Latitude:-$lat",
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Longitude:-$long",
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            Positioned(
              top: MediaQuery.of(context).padding.top + 250,
              left: 135,
              child: GestureDetector(
                onTap: () async {
                  //await compute(testFunction, "");
                  saveAttendance("OUT");
                  //const AttendanceList().launch(context);
                },
                child: Container(
                  //height: MediaQuery.of(context).size.height * 0.5,
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 82, 78, 78),
                    borderRadius: BorderRadius.all(radiusCircular(80)),
                  ),
                  child: Image.asset(
                    "images/fingerprint.png",
                    height: 60,
                    // width: 30,
                    color: const Color.fromARGB(255, 184, 193, 198),
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
