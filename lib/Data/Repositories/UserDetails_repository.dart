// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:io';

import 'package:aeon_hrms/Data/Model/UserDetails.dart';
import 'package:aeon_hrms/Data/api/api_client.dart';
import 'package:aeon_hrms/Utility/MLString.dart';
import 'package:aeon_hrms/Utility/api_constants.dart';
import 'package:aeon_hrms/Utility/utility_function.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class UserDetailsRepository {
  Future<http.Response> login(Map<String, dynamic> data) async {
    Response response;
    try {
      response = await http.post(
        Uri.parse("${ApiConstant.baseUrl}/api/MobileApi/LoginIn"),
        headers: {HttpHeaders.contentTypeHeader: "application/json"},
        body: jsonEncode(data),
      );
    } catch (e) {
      throw Exception('Invalid Credentials.');
    }
    return response;
  }

  Future<http.Response> SaveAttendance(Map<String, dynamic> data) async {
    Response response;
    try {
      response = await http.post(
        Uri.parse("${ApiConstant.baseUrl}/api/MobileApi/SaveAttendance"),
        headers: {HttpHeaders.contentTypeHeader: "application/json"},
        body: jsonEncode(data),
      );
    } catch (e) {
      throw Exception('Invalid Credentials.');
    }
    return response;
  }

  // static Future<http.Response> SaveAttendance1(
  //     Map<String, dynamic> data) async {
  //   Response response;
  //   try {
  //     response = await http.post(
  //         Uri.parse("${ApiConstant.baseUrl}/api/MobileApi/SaveAttendance"),
  //         headers: {HttpHeaders.contentTypeHeader: "application/json"},
  //         body: jsonEncode(data));
  //   } catch (e) {
  //     throw Exception('Invalid Credentials.');
  //   }
  //   return response;
  // }

  Future<http.Response> SaveAttendanceAuto(Map<String, dynamic> data) async {
    Response response;
    try {
      response = await http.post(
        Uri.parse(
          "${ApiConstant.baseUrl}/api/MobileApi/SP_MobileAttendanceAuto",
        ),
        headers: {HttpHeaders.contentTypeHeader: "application/json"},
        body: jsonEncode(data),
      );
    } catch (e) {
      throw Exception('Invalid Credentials.');
    }
    return response;
  }

  Future<http.Response> GetAttendance(Map<String, dynamic> data) async {
    Response response;
    try {
      // response = await apiService.postEndpointWithoutToken(
      //     endpoint: Endpoint.login, data: data);
      response = await http.post(
        Uri.parse("${ApiConstant.baseUrl}/api/MobileApi/GetAttendance"),
        headers: {HttpHeaders.contentTypeHeader: "application/json"},
        body: jsonEncode(data),
      );
    } catch (e) {
      throw Exception('Invalid Credentials.');
    }
    return response;
  }

  static Future<List<UserModel>> UserLogin(Map<String, dynamic> data) async {
    List<UserModel>? LoginDetails = <UserModel>[];
    var response = await ApiClient().postMapData(ApiConstant.LoginIn, data);
    if (response is http.Response && response.statusCode == 200) {
      final Map<String, dynamic> result =
          jsonDecode(response.body) as Map<String, dynamic>;
      result[st_JsonData].forEach((v) {
        LoginDetails.add(UserModel.fromJson(v));
      });
      return LoginDetails;
    } else if (response == "Exception") {
      Utility.ToastMessage("Exception occurred while getting appointment data");
      return LoginDetails;
    } else {
      return LoginDetails;
    }
  }
}
