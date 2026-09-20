import 'dart:convert';

import 'package:aeon_hrms/Screens/Home/model/AppUpdateorNotToCheckModel.dart';
import 'package:aeon_hrms/Screens/Home/model/CompmastModel.dart';
import 'package:aeon_hrms/Utility/api_constants.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:aeon_hrms/Utility/MLString.dart';
import 'package:aeon_hrms/Utility/shared_preferences_service.dart';
import 'package:http/http.dart' as http;

class Homecontroller extends GetxController {
  AppUpdateorNotToCheckModel? appUpdateorNotToCheckModel;
  CompmastModel? compmastModel;
  var isupdateappLoading = false;
  Future<void> AppUpdateorNotToCheck() async {
    isupdateappLoading = true;
    update();
    String? empCode = SharedPref.getEmpCode();
    final response = await http.post(
      Uri.parse(
        '${ApiConstant.baseUrl}/api/MobileApi/AppUpdateorNotToCheck?EMP_CODE=$empCode',
      ),
    );

    if (response.statusCode == 200) {
      appUpdateorNotToCheckModel = AppUpdateorNotToCheckModel.fromJson(
        jsonDecode(response.body),
      );

      isupdateappLoading = false;
      update();
    } else {
      isupdateappLoading = false;

      throw Exception('Failed to load album');
    }
    isupdateappLoading = false;
    update();
  }

  var iscompmastLoading = false;
  Future<void> CompmastToCheckDate() async {
    iscompmastLoading = true;
    update();
    final response = await http.post(
      Uri.parse('${ApiConstant.baseUrl}/api/MobileApi/AppUpdateDate'),
    );

    if (response.statusCode == 200) {
      compmastModel = CompmastModel.fromJson(jsonDecode(response.body));

      iscompmastLoading = false;
      update();
    } else {
      iscompmastLoading = false;

      throw Exception('Failed to load album');
    }
    iscompmastLoading = false;
    update();
  }
}
