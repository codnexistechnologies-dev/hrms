import 'dart:convert';

import 'package:aeon_hrms/Screens/KPI%20Management/LiquidationPlan/model/KpiMasterList.dart';
import 'package:aeon_hrms/Screens/KPI%20Management/LiquidationPlan/model/LiquidationPlanAchiModel.dart';
import 'package:aeon_hrms/Utility/api_constants.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:http/http.dart' as http;
import 'package:aeon_hrms/Utility/shared_preferences_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:dio/dio.dart' as dio;

class LiquidationPlanController extends GetxController {
  final liquidationProductAchievement = Rx<num>(0);
  int _productAchievementRequestId = 0;

  Future<num> getLiquidationProductwiseAchievement(
    int productCode,
    String payDate,
  ) async {
    final requestId = ++_productAchievementRequestId;
    liquidationProductAchievement.value = 0;
    if (productCode == 0) return 0;
    try {
      final achievement = await _fetchLiquidationProductwiseAchievement(
        productCode,
        payDate,
      );
      if (requestId == _productAchievementRequestId) {
        liquidationProductAchievement.value = achievement;
      }
      return achievement;
    } catch (error) {
      debugPrint('Failed to load liquidation product achievement: $error');
      return 0;
    }
  }

  Future<num> _fetchLiquidationProductwiseAchievement(
    int productCode,
    String payDate,
  ) async {
    final empCode = SharedPref.getEmpCode();
    if (empCode == null) {
      throw Exception('Employee code is null');
    }
    final response = await http.post(
      Uri.parse(
        '${ApiConstant.baseUrl}/api/Kpi/GetLiquidationProductwiseAchievementByUseridandPayDate',
      ).replace(
        queryParameters: {
          'EMP_CODE': empCode,
          'Product_code': productCode.toString(),
          'PAYDATE': payDate,
        },
      ),
      headers: {'accept': 'application/json'},
    );
    if (response.statusCode != 200) {
      throw Exception(
        'Failed to load product achievement: ${response.statusCode}',
      );
    }
    final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
    final data = jsonResponse['data'] as List<dynamic>?;
    if (data == null || data.isEmpty) return 0;
    final value = data.first['liquidatioN_PRODUCT_ACHIEVEMENT'];
    if (value == null) return 0;
    return value is num ? value : num.parse(value.toString());
  }

  //Rx<KpiMaster?> productselectedValue = Rx<KpiMaster?>(null);
  var isSaveLiquaidationPlanLoding = false.obs;
  Future<Map<String, dynamic>> saveLiquidationPlan(
    BuildContext context,
    int productCode,
    int? txtAchieved,
    String txtRemarks,
  ) async {
    isSaveLiquaidationPlanLoding.value = true;
    update();

    String? empCode = SharedPref.getEmpCode();
    try {
      dio.FormData formData = dio.FormData.fromMap({
        'EMP_CODE': empCode,
        'PRODUCT_CODE': productCode,
        'LIQUIDATION_ACHIEVED': txtAchieved,
        'REMARKS': txtRemarks,
      });

      var myDio = dio.Dio();
      var response = await myDio.post(
        '${ApiConstant.baseUrl}/api/Kpi/AddLiquidationPlan',
        data: formData,
        options: dio.Options(headers: {'Content-Type': 'multipart/form-data'}),
      );
      if (response.statusCode == 200) {
        return {
          'status': response.statusCode,
          'message': 'Liquidation data saved successfully!',
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
        'message': 'Failed to save Liquidation. Please try again.',
      };
    } finally {
      isSaveLiquaidationPlanLoding.value = false;
      update();
    }
  }

  var isKpiMasterLoading = false.obs; // Made observable if using GetX
  RxList<KpiMaster> kpimasterList = <KpiMaster>[].obs;

  Future<void> GetKpiMasterByUseridandPaydate(String atdate) async {
    isKpiMasterLoading.value = true; // Use observable for state management
    try {
      String? empCode = SharedPref.getEmpCode();
      if (empCode == null) {
        throw Exception('Employee code is null');
      }

      final response = await http.post(
        Uri.parse(
          '${ApiConstant.baseUrl}/api/Kpi/GetKpiMasterByUseridandPaydate?EMP_CODE=$empCode&PAYDATE=$atdate',
        ),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        KpiMasterList kpiMasterList = KpiMasterList.fromJson(jsonResponse);
        kpimasterList.value = kpiMasterList.data ?? []; // Assign data directly
      } else {
        throw Exception(
          'Failed to load data, status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      isKpiMasterLoading.value = false;
    }
  }

  var isFieldDaysAchievementLoading =
      false.obs; // Made observable if using GetX
  RxList<LiquidationPlanAchi> liquidationPlanList = <LiquidationPlanAchi>[].obs;
  Future<void> GetLiquidationPlanAchievementByUseridandPayDate(
    String atdate,
  ) async {
    isFieldDaysAchievementLoading.value =
        true; // Use observable for state management
    try {
      String? empCode = SharedPref.getEmpCode();
      if (empCode == null) {
        throw Exception('Employee code is null');
      }

      final response = await http.post(
        Uri.parse(
          '${ApiConstant.baseUrl}/api/Kpi/GetLiquidationPlanAchievementByUseridandPayDate?EMP_CODE=$empCode&PAYDATE=$atdate',
        ),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        LiquidationPlanAchiModel liquidationPlanAchi =
            LiquidationPlanAchiModel.fromJson(jsonResponse);
        liquidationPlanList.value =
            liquidationPlanAchi.data ?? []; // Assign data directly
      } else {
        throw Exception(
          'Failed to load data, status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      isFieldDaysAchievementLoading.value = false;
    }
  }
}
