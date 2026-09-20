import 'dart:convert';
import 'dart:io';

import 'package:aeon_hrms/Utility/DatabaseHelper.dart';
import 'package:aeon_hrms/Utility/api_constants.dart';
import 'package:aeon_hrms/Utility/utility_function.dart';
//import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:aeon_hrms/Screens/Time%20Attendence/model/attendanceHistModel.dart';
import 'package:aeon_hrms/Screens/Time%20Attendence/model/attendanceRegApprovelList.dart';
import 'package:aeon_hrms/Screens/Time%20Attendence/model/attendanceRegModel.dart';
import 'package:aeon_hrms/Screens/Time%20Attendence/model/attendanceRegReturnList.dart';
import 'package:aeon_hrms/Screens/Time%20Attendence/model/attendanceSummaryModel.dart';
import 'package:aeon_hrms/Utility/MLString.dart';
import 'package:aeon_hrms/Utility/shared_preferences_service.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AttendanceController extends GetxController {
  AttendanceHistModel? attendanceHistModel;
  AttendanceSummaryModel? attendanceSummaryModel;
  AttendanceRegModel? attendanceRegModel;
  AttendanceRegApprovelListModel? attendanceRegApprovelListModel;
  AttendanceRegReturnListModel? attendanceRegReturnListModel;
  String? attEmpcode;
  String? attAtdate;
  List<bool> ckeckBoxStatusList = [];
  var isHistLoading = false; // Use camelCase for variable names
  List<Attendancehist> attendanceApprovalDetailsModelList = [];
  Future<void> getAttendanceHistByEmpCodeAndMonthWise(
    String month,
    String year,
  ) async {
    isHistLoading = true;
    try {
      String? empCode = SharedPref.getEmpCode();
      final response = await http.post(
        Uri.parse(
          '${ApiConstant.baseUrl}/api/MobileApi/GetAttendanceHistByEmpcodeandMonthWize?EMP_CODE=$empCode&Month=$month&Year=$year',
        ),
      );

      if (response.statusCode == 200) {
        attendanceHistModel = AttendanceHistModel.fromJson(
          jsonDecode(response.body),
        );

        // Uncomment the following line if you want to print the response value
        // print("Checking response value ${attendanceHistModel?.data?.first.emPName}");
      } else {
        // If the server did not return a 200 OK response,
        // throw an exception with the response body as the message.
        throw Exception('Failed to load data: ${response.body}');
      }
    } catch (e) {
      // Handle exceptions here, you might want to log the error or notify the user.
      print('Error: $e');
    } finally {
      isHistLoading = false;
      update();
    }
  }

  var isSummaryLoading = false;

  Future<void> getAttendanceReportByEmpcodeandMonthWize(
    String month,
    String year,
  ) async {
    isSummaryLoading = true;
    String? empCode = SharedPref.getEmpCode();
    try {
      final response = await http.post(
        Uri.parse(
          '${ApiConstant.baseUrl}/api/MobileApi/GetAttendanceReportByEmpcodeandMonthWize?EMP_CODE=$empCode&Month=$month&Year=$year',
        ),
      );

      if (response.statusCode == 200) {
        attendanceSummaryModel = AttendanceSummaryModel.fromJson(
          jsonDecode(response.body),
        );

        print(
          "checking response value ${attendanceSummaryModel?.data?.first.emPName}",
        );
      } else {
        // If the server did not return a 200 OK response,
        // throw an exception.
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      isSummaryLoading = false;
      update();
    }
  }

  var isAttregprocess = false;

  Future<void> getAttRegProcessDisplay(String atdate) async {
    isAttregprocess = true;
    try {
      String? empCode = SharedPref.getEmpCode();
      final response = await http.post(
        Uri.parse(
          '${ApiConstant.baseUrl}/api/MobileApi/GetAttRegProcessDisplay?EMP_CODE=$empCode&ATDATE=$atdate',
        ),
      );

      if (response.statusCode == 200) {
        attendanceRegModel = AttendanceRegModel.fromJson(
          jsonDecode(response.body),
        );
        print(
          "checking response value ${attendanceRegModel?.data?.first.emPCode}",
        );
        // No need to set isAttregprocess to false here
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('Failed to load album');
      }
    } catch (e) {
      // Handle exceptions here if needed
      print('Error: $e');
    } finally {
      isAttregprocess = false;
      update();
    }
  }

  var isAttShowlist = false;

  Future<void> getAttRegApprovalEmployeeList() async {
    // Set isAttShowlist to true before making the API request
    isAttShowlist = true;

    try {
      String? empCode = SharedPref.getEmpCode();
      final response = await http.post(
        Uri.parse(
          '${ApiConstant.baseUrl}/api/MobileApi/GetAttRegApprovalEmployeeList?MNGR_CODE=$empCode',
        ),
      );

      if (response.statusCode == 200) {
        // Parse the response and update the model
        attendanceRegModel = AttendanceRegModel.fromJson(
          jsonDecode(response.body),
        );

        // Update the UI (assuming update() is a method to trigger a UI update)
        update();
      } else {
        // If the server did not return a 200 OK response,
        // throw an exception with a meaningful error message
        throw Exception(
          'Failed to load data. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      // Handle exceptions, log the error, or perform other error-handling tasks
      print('Error in getAttRegApprovalEmployeeList: $e');
    } finally {
      // Set isAttShowlist to false after API request, whether it was successful or not
      isAttShowlist = false;
      // Update the UI (assuming update() is a method to trigger a UI update)
      update();
    }
  }

  void updateCheckBox(bool? value) {
    ckeckBoxStatusList.clear();
    if (value == true) {
      for (
        int i = 0;
        i < (attendanceRegApprovelListModel?.data?.length ?? 0);
        i++
      ) {
        ckeckBoxStatusList.add(true);
      }
    } else {
      for (
        int i = 0;
        i < (attendanceRegApprovelListModel?.data?.length ?? 0);
        i++
      ) {
        ckeckBoxStatusList.add(false);
      }
    }
    update();
  }

  var isApprovalListLoading = false;
  List<Attendancehist> AttendanceApprovalDetailsModelList = [];
  Future<void> getAttRegApprovalListByEmpcode() async {
    try {
      isApprovalListLoading = true;
      String? empCode = SharedPref.getEmpCode();
      final response = await http.post(
        Uri.parse(
          '${ApiConstant.baseUrl}/api/MobileApi/GetAttRegApprovalListByEmpcode?MNGR_CODE=$empCode&EMP_CODE=$attEmpcode',
        ),
      );

      if (response.statusCode == 200) {
        attendanceRegApprovelListModel =
            AttendanceRegApprovelListModel.fromJson(jsonDecode(response.body));
        AttendanceApprovalDetailsModelList.clear(); // Clear existing data
        AttendanceApprovalDetailsModelList.addAll(
          attendanceRegApprovelListModel?.data ?? [],
        ); // Assign fetched data
        ckeckBoxStatusList.clear();
        ckeckBoxStatusList.addAll(
          List.generate(
            attendanceRegApprovelListModel?.data?.length ?? 0,
            (index) => false,
          ),
        );
        isApprovalListLoading = false;
        update();
      } else {
        isApprovalListLoading = false;
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('Failed to load album');
      }
    } catch (e) {
      isApprovalListLoading = false;
      print('Error: $e');
    } finally {
      update();
    }
  }

  var issaveRegLoding = false;
  Future<void> saveRegulaizationApplication(
    BuildContext context,
    Map<String, dynamic> data,
  ) async {
    try {
      issaveRegLoding = true;
      final response = await http.post(
        Uri.parse(
          '${ApiConstant.baseUrl}/api/MobileApi/SaveAttenRegApplication',
        ),
        headers: {HttpHeaders.contentTypeHeader: "application/json"},
        body: jsonEncode(data),
      );
      if (response.statusCode == 200) {
        attendanceRegReturnListModel = AttendanceRegReturnListModel.fromJson(
          jsonDecode(response.body),
        );
        // ignore: use_build_context_synchronously
        alertSucess(
          context,
          data: '${attendanceRegReturnListModel?.data?.returnMessage}',
        );
        print(
          "checking response value ${attendanceRegReturnListModel?.data?.returnMessage}",
        );
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('Failed to load album');
      }
    } catch (e) {
      //issaveRegLoding = false;
      print('Error: $e');
    } finally {
      issaveRegLoding = false;
      update();
    }
  }

  var issaveAttendanceApproval = false;
  Future<void> SaveAttendandanceApprovalByEmpCodeandAtdate(
    BuildContext context,
    List<Map<String, dynamic>> data,
  ) async {
    issaveAttendanceApproval = true;
    print(jsonEncode(data));
    final response = await http.post(
      Uri.parse(
        '${ApiConstant.baseUrl}/api/MobileApi/SaveAttendandanceApprovalByEmpCodeandAtdate',
      ),
      headers: {HttpHeaders.contentTypeHeader: "application/json"},
      body: jsonEncode(data),
    );
    if (response.statusCode == 200) {
      // print(response.body["data"].)
      attendanceRegReturnListModel = AttendanceRegReturnListModel.fromJson(
        jsonDecode(response.body),
      );
      // ignore: use_build_context_synchronously
      alertSucess(
        context,
        data: '${attendanceRegReturnListModel?.data?.returnMessage}',
      );
      print(
        "checking response value ${attendanceRegReturnListModel?.data?.returnMessage}",
      );
      //getAttRegApprovalListByEmpcode();
      issaveAttendanceApproval = false;
      update();
    } else {
      issaveAttendanceApproval = false;
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
    issaveAttendanceApproval = false;
    update();
  }

  var issaveGeoLocation = false;
  Future<int> SaveGeoLocationByEmpCodeandAtdate(
    String latitude,
    String longitude,
    String address,
  ) async {
    String? empCode;
    try {
      SharedPreferences myPrefs = await SharedPreferences.getInstance();
      empCode =
          myPrefs.getString('empcode') ?? SharedPref.getEmpCode();
      issaveGeoLocation = true;
      if (empCode == null || empCode.isEmpty) {
        throw StateError('EMP_CODE not found for location tracking');
      }
      // Offline-first: only write locally. The batched background sync
      // (WorkManager) pushes records to the server, so each point does not
      // fire its own HTTP request — keeps the server load low.
      return await saveEmployeeData(
        empCode,
        latitude,
        longitude,
        address,
      );
    } catch (e) {
      debugPrint('[Location] Could not persist point: $e');
      rethrow;
    } finally {
      issaveGeoLocation = false;
      update(); // Notify listeners (if this is in a GetX or Provider context)
    }
  }

  Future<int> saveEmployeeData(
    String empCode,
    String latitude,
    String longitude,
    String address,
  ) async {
    try {
      DatabaseHelper dbHelper = DatabaseHelper();
      // Get the current date and time
      DateTime now = DateTime.now();
      String mobileNetwork = '';
      try {
        mobileNetwork = await Utility.checkNetworkStatus();
      } catch (error) {
        debugPrint('[Location] Network status unavailable: $error');
      }
      print('Network Status: $mobileNetwork');
      String currentDate =
          "${now.year}-${_twoDigits(now.month)}-${_twoDigits(now.day)}";

      // Format the date and time as 'yyyy-MM-dd HH:mm:ss'
      String currentDateTime =
          "${now.year}-${_twoDigits(now.month)}-${_twoDigits(now.day)} "
          "${_twoDigits(now.hour)}:${_twoDigits(now.minute)}:${_twoDigits(now.second)}";

      Map<String, dynamic> employee = {
        'emp_code': empCode,
        'atdate': currentDate, // Set to current date
        'in_out_date': currentDateTime, // Set to current date and time
        'LATITUDE': latitude,
        'LONGITUDE': longitude,
        'ADDRESS': address,
        'MOBILE_NETWORK': mobileNetwork,
      };

      final localId = await dbHelper.insertEmployee(employee);
      debugPrint('[Location] SQLite saved: id=$localId, data=$employee');
      return localId;
    } catch (e) {
      print('Error: $e');
      rethrow;
    }
  }

  // Helper function to ensure two digits for month, day, hour, minute, and second
  String _twoDigits(int n) {
    if (n >= 10) return "$n";
    return "0$n";
  }

  Future alertSucess(BuildContext context, {required String data}) {
    return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(data),
        content: const Icon(Icons.check_circle_outline_outlined),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
              Get.back();
              Get.back();
              //Navigator.of(context).pop();
            },
            child: const Text('Ok'),
          ),
        ],
      ),
    );
  }
}
