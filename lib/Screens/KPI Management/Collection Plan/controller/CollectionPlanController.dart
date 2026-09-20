import 'dart:convert';

import 'package:aeon_hrms/Screens/KPI%20Management/Collection%20Plan/model/CollectionPlanAchiModel.dart';
import 'package:aeon_hrms/Utility/MLString.dart';
import 'package:aeon_hrms/Utility/api_constants.dart';
import 'package:aeon_hrms/Utility/shared_preferences_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:dio/dio.dart' as dio;
import 'package:http/http.dart' as http;

class CollectionPlanController extends GetxController {
  //Rx<KpiMaster?> productselectedValue = Rx<KpiMaster?>(null);
  var isSaveCollectionPlanLoding = false.obs;
  Future<Map<String, dynamic>> saveCollectionPlan(
    BuildContext context,
    int? txtAchieved,
    String txtRemarks,
  ) async {
    isSaveCollectionPlanLoding.value = true;
    update();

    String? empCode = SharedPref.getEmpCode();
    try {
      dio.FormData formData = dio.FormData.fromMap({
        'EMP_CODE': empCode,
        'COLLECTION_ACHIEVED': txtAchieved,
        'REMARKS': txtRemarks,
      });

      var myDio = dio.Dio();
      var response = await myDio.post(
        '${ApiConstant.baseUrl}/api/Kpi/AddCollectionPlan',
        data: formData,
        options: dio.Options(headers: {'Content-Type': 'multipart/form-data'}),
      );
      if (response.statusCode == 200) {
        return {
          'status': response.statusCode,
          'message': 'Collection data saved successfully!',
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
        'message': 'Failed to save Collection. Please try again.',
      };
    } finally {
      isSaveCollectionPlanLoding.value = false;
      update();
    }
  }

  var isCollectionPlanAchievementLoading =
      false.obs; // Made observable if using GetX
  RxList<CollectionPlanAchi> collectionPlanAchievementList =
      <CollectionPlanAchi>[].obs;

  Future<void> GetCollectionPlanAchievementByUseridandPayDate(
    String atdate,
  ) async {
    isCollectionPlanAchievementLoading.value =
        true; // Use observable for state management
    try {
      String? empCode = SharedPref.getEmpCode();
      if (empCode == null) {
        throw Exception('Employee code is null');
      }

      final response = await http.post(
        Uri.parse(
          '${ApiConstant.baseUrl}/api/Kpi/GetCollectionPlanAchievementByUseridandPayDate?EMP_CODE=$empCode&PAYDATE=$atdate',
        ),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        CollectionPlanAchiModel collectionPlanAchievement =
            CollectionPlanAchiModel.fromJson(jsonResponse);
        collectionPlanAchievementList.value =
            collectionPlanAchievement.data ?? []; // Assign data directly
      } else {
        throw Exception(
          'Failed to load data, status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      isCollectionPlanAchievementLoading.value = false;
    }
  }
}
