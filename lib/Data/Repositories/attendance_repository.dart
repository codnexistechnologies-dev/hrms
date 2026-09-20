// ignore_for_file: non_constant_identifier_names, prefer_interpolation_to_compose_strings
import 'dart:convert';
import 'package:aeon_hrms/Data/Model/attendanceModel.dart';
import 'package:aeon_hrms/Data/api/api_client.dart';
import 'package:aeon_hrms/Utility/MLString.dart';
import 'package:aeon_hrms/Utility/api_constants.dart';
import 'package:aeon_hrms/Utility/utility_function.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class AttendanceRepository {
  static Future<dynamic> GetAttendance(Map<String, dynamic> data) async {
    List<Attendance>? AttendanceDetails = <Attendance>[];
    var response = await ApiClient().postMapData(ApiConstant.LoginIn, data);
    if (response is http.Response && response.statusCode == 200) {
      final Map<String, dynamic> result =
          jsonDecode(response.body) as Map<String, dynamic>;
      result[st_JsonData].forEach((v) {
        AttendanceDetails.add(Attendance.fromJson(v));
      });
      return AttendanceDetails;
    } else if (response == "Exception") {
      Utility.ToastMessage(
          "Exception occurred while getting GetAttendance data");
      return AttendanceDetails;
    } else {
      return AttendanceDetails;
    }
  }

  static Future<dynamic> SaveMarkInAndMarkOut(
      Map<String, dynamic> data, String CHECKINOUT) async {
    var response =
        await ApiClient().postMapData(ApiConstant.SaveMarkInAndMarkOut, data);
    if (kDebugMode) {
      print(response);
    }
    if (response is http.Response && response.statusCode == 200) {
      final Map<String, dynamic> result =
          jsonDecode(response.body) as Map<String, dynamic>;
      List<Attendance>? AttDetails = <Attendance>[];
      result["data"].forEach((v) {
        AttDetails.add(Attendance.fromJson(v));
      });
      return AttDetails;
    } else if (response == "Exception") {
      //print('Exception while fetching department doctors');
      return null;
    } else {
      return null;
    }
  }
}
