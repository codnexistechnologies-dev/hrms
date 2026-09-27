import 'dart:convert';
import 'dart:io';

import 'package:aeon_hrms/Screens/KPI%20Management/Unorganised%20Farmer/model/UnorganisedMeetingAchiModel.dart';
import 'package:aeon_hrms/Utility/api_constants.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:http/http.dart' as http;
import 'package:aeon_hrms/Utility/MLString.dart';
import 'package:aeon_hrms/Utility/shared_preferences_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:dio/dio.dart' as dio;

class UnorganizedFarmerMeetingController extends GetxController {
  var isSaveUnorganisedFarmerLoding = false.obs;
  Future<Map<String, dynamic>> saveUnorganizedFarmerMeeting(
    BuildContext context,
    int? productCode,
    int? cropCode,
    String? stateCode,
    int? distictCode,
    int? tehsilCode,
    int? villageCode,
    int? NoOfFarmerattendance,
    String txtRemarks,
    double? txtLat,
    double? txtLong,
    String? txtAddress,
    File? imagesFile,
    String farmerText,
    String mobileText,
  ) async {
    isSaveUnorganisedFarmerLoding.value = true;
    update();

    String? empCode = SharedPref.getEmpCode();
    String imageFile = imagesFile!.path.split('/').last;

    try {
      if (!imagesFile.existsSync()) {
        throw Exception("Image file not found.");
      }

      dio.FormData formData = dio.FormData.fromMap({
        'EMP_CODE': empCode,
        'PRODUCT_CODE': productCode,
        'CROP_CODE': cropCode,
        'STATE_CODE': stateCode,
        'DISTRICT_CODE': distictCode,
        'TEHSIL_CODE': tehsilCode,
        'VILLAGE_CODE': villageCode,
        'NO_OF_FARMERS_ATTENDED': NoOfFarmerattendance,
        'REMARKS': txtRemarks,
        'LATITUDE': txtLat,
        'LONGITUDE': txtLong,
        'ADDRESS': txtAddress,
        'IMAGE_FILE': await dio.MultipartFile.fromFile(
          imagesFile.path,
          filename: imageFile,
        ),
        "FARMER_NAME": farmerText,
        "MOBILE_NO": mobileText,
      });

      var myDio = dio.Dio();
      var response = await myDio.post(
        '${ApiConstant.baseUrl}/api/Kpi/AddUnorganisedFarmerMerting',
        data: formData,
        options: dio.Options(headers: {'Content-Type': 'multipart/form-data'}),
      );
      if (response.statusCode == 200) {
        return {
          'status': response.statusCode,
          'message': 'Unorganized Farmer Meeting saved successfully!',
        };
      } else {
        return {
          'status': response.statusCode,
          'message': 'Server returned status code ${response.statusCode}',
        };
      }
    } catch (e) {
      return {
        'status': 500,
        'message': 'Failed to save Unorganized Farmer. Please try again.',
      };
    } finally {
      isSaveUnorganisedFarmerLoding.value = false;
      update();
    }
  }

  var isUnorganisedMeetingAchiLoading =
      false.obs; // Made observable if using GetX
  RxList<UnorganisedMeetingAchi> unorganisedMeetingAchiList =
      <UnorganisedMeetingAchi>[].obs;
  Future<void> GetUnorganisedMeetingAchiByUseridandPayDate(
    String atdate,
  ) async {
    isUnorganisedMeetingAchiLoading.value =
        true; // Use observable for state management
    try {
      String? empCode = SharedPref.getEmpCode();
      if (empCode == null) {
        throw Exception('Employee code is null');
      }

      final response = await http.post(
        Uri.parse(
          '${ApiConstant.baseUrl}/api/Kpi/GetUnorganisedMeetingAchiByUseridandPayDate?EMP_CODE=$empCode&PAYDATE=$atdate',
        ),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        UnorganisedMeetingAchiModel unorganisedMeetingAchi =
            UnorganisedMeetingAchiModel.fromJson(jsonResponse);
        unorganisedMeetingAchiList.value =
            unorganisedMeetingAchi.data ?? []; // Assign data directly
      } else {
        throw Exception(
          'Failed to load data, status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      isUnorganisedMeetingAchiLoading.value = false;
    }
  }
}
