import 'package:aeon_hrms/Utility/MLString.dart';
import 'package:aeon_hrms/Utility/api_constants.dart' show ApiConstant;
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiClient {
  static ApiClient apiClient = ApiClient._internal();

  ApiClient._internal();

  factory ApiClient() {
    return apiClient;
  }

  static Map<String, String> _mainHeaders = {
    'Content-Type': 'application/json; charset=UTF-8',
  };

  static const String noInternetMessage =
      'Connection to API server failed due to internet connection';

  void updateHeader(String token) {
    _mainHeaders = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    };
  }

  Future<dynamic> getData(String path) async {
    String getUrl = ApiConstant.baseUrl + path;
    try {
      http.Response response = await http
          .get(Uri.parse(getUrl), headers: _mainHeaders)
          .timeout(const Duration(seconds: 30));
      return response;
    } on Exception catch (_) {
      return 'Exception';
    }
  }

  Future<dynamic> postData(String path, dynamic body) async {
    String postUrl = ApiConstant.baseUrl + path;
    try {
      http.Response response = await http
          .post(Uri.parse(postUrl), headers: _mainHeaders, body: body)
          .timeout(const Duration(seconds: 30));
      return response;
    } on Exception catch (_) {
      return 'Exception';
    }
  }

  Future<dynamic> postMapData(String path, Map<String, dynamic> body) async {
    String postUrl = ApiConstant.baseUrl + path;
    try {
      http.Response response = await http
          .post(Uri.parse(postUrl), headers: _mainHeaders, body: body)
          .timeout(const Duration(seconds: 30));
      return response;
    } on Exception catch (_) {
      return 'Exception';
    }
  }

  Future<dynamic> patchData(String path, dynamic body) async {
    String updateUrl = ApiConstant.baseUrl + path;
    try {
      http.Response response = await http
          .patch(Uri.parse(updateUrl), headers: _mainHeaders, body: body)
          .timeout(const Duration(seconds: 30));
      return response;
    } on Exception catch (_) {
      return 'Exception';
    }
  }

  Future<dynamic> deleteData(String path) async {
    String deleteUrl = ApiConstant.baseUrl + path;
    try {
      http.Response response = await http
          .delete(Uri.parse(deleteUrl))
          .timeout(const Duration(seconds: 30));
      return response;
    } on Exception catch (_) {
      return 'Exception';
    }
  }

  Future<dynamic> postMultipartData({
    required String path,
    Map<String, String>? textFields,
    Map<String, String>? fileFields,
  }) async {
    String postUrl = ApiConstant.baseUrl + path;
    var request = http.MultipartRequest("POST", Uri.parse(postUrl));

    if (textFields != null && textFields.isNotEmpty) {
      request.fields.addAll(textFields);
    }
    if (fileFields != null && fileFields.isNotEmpty) {
      fileFields.forEach((key, value) async {
        request.files.add(await http.MultipartFile.fromPath(key, value));
      });
    }
    try {
      var response = await request.send();
      if (kDebugMode) {
        print(response.statusCode);
      }
      return response;
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  void handleErrorResponse(http.Response response) {
    if (response.statusCode == 400) {
    } else if (response.statusCode == 401) {
    } else if (response.statusCode == 403) {
    } else if (response.statusCode == 404) {
    } else if (response.statusCode == 408) {
    } else if (response.statusCode == 500) {
    } else if (response.statusCode == 503) {
    } else if (response.statusCode == 504) {
    } else {}
  }
}
