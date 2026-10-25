import 'dart:async';
import 'dart:convert';

import 'package:date_format/date_format.dart';
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
import 'package:aeon_hrms/Utility/attendance_location.dart';
//import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:aeon_hrms/main.dart' show setLocationTrackingActive;

class MarkAttendanceWithMap extends StatefulWidget {
  const MarkAttendanceWithMap({super.key});

  @override
  State<MarkAttendanceWithMap> createState() => _MarkAttendanceWithMapState();
}

class _MarkAttendanceWithMapState extends State<MarkAttendanceWithMap>
    with WidgetsBindingObserver {
  String intime = '', outtime = '', inoutflag = '', atdate = '';
  Attendance? attendance;
  AttendanceLocation? _location;
  String? _locationError;
  bool isloading = false, _isSaving = false, _foreground = true;
  int _locationRequest = 0;
  Timer? _refreshTimer;
  StreamSubscription<ServiceStatus>? _serviceSubscription;
  double _totalDistance = 0;
  String? get address => _location?.address;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _serviceSubscription = Geolocator.getServiceStatusStream().listen(
      (status) {
        if (!mounted) return;
        if (status == ServiceStatus.disabled) {
          _locationRequest++;
          _refreshTimer?.cancel();
          setState(() {
            _location = null;
            isloading = false;
            _locationError = 'Turn on device location, then retry.';
          });
        } else if (_foreground && !_isSaving) {
          unawaited(_refreshLocation());
        }
      },
      onError: (Object error) {
        debugPrint('Location service status unavailable: $error');
      },
    );
    unawaited(_refreshLocation());
    unawaited(_loadAttendance());
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _foreground = state == AppLifecycleState.resumed;
    if (!_foreground) {
      _locationRequest++;
      _refreshTimer?.cancel();
      setState(() {
        _location = null;
        isloading = false;
      });
    } else if (!_isSaving) {
      unawaited(_refreshLocation());
    }
  }

  Future<AttendanceLocation> _readLocation() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      throw StateError('Turn on device location, then retry.');
    }
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission != LocationPermission.whileInUse &&
        permission != LocationPermission.always) {
      throw StateError(
        'Allow location permission in app settings, then retry.',
      );
    }
    if (await Geolocator.getLocationAccuracy() ==
        LocationAccuracyStatus.reduced) {
      throw StateError('Enable Precise location in app settings, then retry.');
    }
    final requestedAt = DateTime.now();
    // Reject cached/coarse fixes and cancel GPS acquisition even on timeout.
    final position = await AttendanceLocation.waitForFix(
      Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 0,
        ),
      ),
      requestedAt,
    );
    final places = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
      localeIdentifier: 'en_IN',
    ).timeout(const Duration(seconds: 8));
    final resolvedAddress = AttendanceLocation.formatAddress(places);
    if (!AttendanceLocation.isUsable(position, DateTime.now())) {
      throw StateError('Location expired. Please retry.');
    }
    return AttendanceLocation(position, resolvedAddress);
  }

  double _distanceFromOffice(Position position) {
    final officeLat = double.tryParse('${SharedPref.getLatitude()}');
    final officeLng = double.tryParse('${SharedPref.getLongitude()}');
    if (officeLat == null ||
        officeLng == null ||
        !officeLat.isFinite ||
        !officeLng.isFinite ||
        officeLat.abs() > 90 ||
        officeLng.abs() > 180) {
      return 0;
    }
    return Geolocator.distanceBetween(
      officeLat,
      officeLng,
      position.latitude,
      position.longitude,
    );
  }

  void _scheduleRefresh(AttendanceLocation location) {
    _refreshTimer?.cancel();
    final remaining =
        AttendanceLocation.maxAge -
        DateTime.now().difference(location.position.timestamp);
    _refreshTimer = Timer(remaining.isNegative ? Duration.zero : remaining, () {
      if (!mounted) return;
      setState(() => _location = null);
      if (_foreground && !_isSaving) unawaited(_refreshLocation());
    });
  }

  String _locationMessage(Object error) {
    if (error is StateError) return error.message;
    if (error is TimeoutException) {
      return 'Accurate location/address unavailable. Move to an open area, check internet and retry.';
    }
    return 'Could not verify current location/address. Check location settings and internet, then retry.';
  }

  Future<void> _refreshLocation() async {
    if (!mounted || !_foreground || isloading || _isSaving) return;
    final request = ++_locationRequest;
    _refreshTimer?.cancel();
    setState(() {
      isloading = true;
      _location = null;
      _locationError = null;
    });
    try {
      final location = await _readLocation();
      if (!mounted || request != _locationRequest || !_foreground) return;
      setState(() {
        _location = location;
        _totalDistance = _distanceFromOffice(location.position);
      });
      _scheduleRefresh(location);
    } catch (error) {
      if (!mounted || request != _locationRequest) return;
      setState(() => _locationError = _locationMessage(error));
    } finally {
      if (mounted && request == _locationRequest) {
        setState(() => isloading = false);
      }
    }
  }

  Future<void> saveAttendance(String checkInOut) async {
    if (_isSaving || isloading || !_foreground) return;
    final request = ++_locationRequest;
    _refreshTimer?.cancel();
    setState(() {
      _isSaving = true;
      _location = null;
      _locationError = null;
    });
    var submitted = false;
    try {
      final deviceName = await Utility.getDeviceInfo();
      final location = await _readLocation();
      if (!mounted || !_foreground || request != _locationRequest) return;
      if (!await Geolocator.isLocationServiceEnabled()) {
        throw StateError('Turn on device location, then retry.');
      }
      if (!mounted || !_foreground || request != _locationRequest) return;
      if (!AttendanceLocation.isUsable(location.position, DateTime.now())) {
        throw StateError('Location expired. Please retry.');
      }
      final distance = _distanceFromOffice(location.position);
      final data = <String, dynamic>{
        'EMP_CODE': SharedPref.getEmpCode(),
        'ADDRESS': location.address,
        'COMP_CODE': deviceName,
        'LOC_CODE': SharedPref.getLocCode(),
        'LATITUDE': location.position.latitude.toString(),
        'LONGITUDE': location.position.longitude.toString(),
        'DISTANCE': distance,
        'CHECK_IN_OUT': checkInOut,
        'MOB_VERSION': 'Ver-2',
      };
      setState(() {
        _location = location;
        _totalDistance = distance;
      });
      _scheduleRefresh(location);
      final repository = Provider.of<UserDetailsRepository>(
        context,
        listen: false,
      );
      submitted = true;
      final response = await repository.SaveAttendance(data);
      if (response.statusCode != 200) {
        throw StateError('Attendance could not be saved.');
      }
      final saved = Attendance.fromJson(json.decode(response.body));
      if (saved.data.isEmpty ||
          saved.data.first.checKInOut?.toUpperCase() !=
              checkInOut.toUpperCase()) {
        throw StateError('Attendance response did not confirm $checkInOut');
      }
      await setLocationTrackingActive(checkInOut.toUpperCase() == 'IN');
      if (!mounted) return;
      setState(() {
        attendance = saved;
        atdate = formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]);
        intime = saved.data.first.iNTime.toString();
        outtime = saved.data.first.ouTTime.toString();
        inoutflag = saved.data.first.checKInOut.toString();
      });
      Utility.ToastMessage('Done');
    } catch (error) {
      debugPrint('Attendance $checkInOut failed: $error');
      if (!mounted) return;
      if (!submitted) {
        setState(() {
          _location = null;
          _locationError = _locationMessage(error);
        });
      }
      Utility.ToastMessage(
        submitted
            ? 'Attendance could not be confirmed. Refresh attendance before retrying.'
            : _locationMessage(error),
      );
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
        final location = _location;
        if (_foreground && location != null) {
          if (AttendanceLocation.isUsable(location.position, DateTime.now())) {
            _scheduleRefresh(location);
          } else {
            unawaited(_refreshLocation());
          }
        } else if (_foreground && _locationError == null) {
          unawaited(_refreshLocation());
        }
      }
    }
  }

  Future<void> _loadAttendance() async {
    final Map<String, dynamic> data = <String, dynamic>{
      'EMP_CODE': SharedPref.getEmpCode(),
    };
    try {
      final dataRepository = Provider.of<UserDetailsRepository>(
        context,
        listen: false,
      );
      final http.Response response = await dataRepository.GetAttendance(data);
      if (response.statusCode == 200) {
        if (!mounted) return;
        final result = Attendance.fromJson(json.decode(response.body));
        if (result.data.isEmpty) return;
        attendance = result;
        setState(() {
          atdate = formatDate(DateTime.now(), [
            yyyy,
            '-',
            mm,
            '-',
            dd,
          ]).toString();
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
    _locationRequest++;
    _refreshTimer?.cancel();
    _serviceSubscription?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

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
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
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
                        borderRadius: BorderRadius.all(Radius.circular(8)),
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
                    SizedBox(width: 10),
                    Container(
                      height: 80,
                      width: 140,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 251, 211, 209),
                        borderRadius: BorderRadius.all(Radius.circular(8)),
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
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              address ??
                                  (_isSaving || isloading
                                      ? 'Verifying current location and address...'
                                      : _locationError ??
                                            'Refresh to get current address.'),
                            ),
                            if (_location != null)
                              TextButton.icon(
                                onPressed: isloading || _isSaving
                                    ? null
                                    : _refreshLocation,
                                icon: const Icon(Icons.refresh),
                                label: const Text('Refresh location'),
                              ),
                            if (isloading || _isSaving)
                              const LinearProgressIndicator(),
                          ],
                        ),
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
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      width: double.infinity,
                      // height: 50,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            // ignore: unnecessary_null_comparison
                            _location == null
                                ? '--'
                                : '${_totalDistance > 1000 ? (_totalDistance / 1000).toStringAsFixed(2) : _totalDistance.toStringAsFixed(2)} ${_totalDistance > 1000 ? 'KM' : 'meters'}',
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
                          backgroundColor: Colors.green,
                        ),
                        onPressed: isloading || _isSaving || _location == null
                            ? null
                            : () => saveAttendance('IN'),
                        child: const Text(
                          'Mark IN',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 17,
                          ),
                        ), // Every button need a callback
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      // Place 2 `Expanded` mean: they try to get maximum size and they will have same size
                      child: ElevatedButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        onPressed: isloading || _isSaving || _location == null
                            ? null
                            : () => saveAttendance('OUT'),
                        child: const Text(
                          'Mark OUT',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 17,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
