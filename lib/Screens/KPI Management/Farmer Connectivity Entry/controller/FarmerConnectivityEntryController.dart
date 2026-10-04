import 'dart:convert';

import 'package:aeon_hrms/Screens/KPI%20Management/Demo%20Plan/model/FarmerVisitAchievementmodel.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../model/FarmerConnectivityEntryModel.dart';

import 'package:aeon_hrms/Utility/shared_preferences_service.dart';
import 'package:aeon_hrms/Utility/api_constants.dart';

/// Holds the entry draft and farmer visit achievement data.
class FarmerConnectivityEntryController extends GetxController {
  final entry = FarmerConnectivityEntryModel().obs;

  void setEntry(FarmerConnectivityEntryModel value) {
    entry.value = value;
  }

  void resetEntry() {
    entry.value = FarmerConnectivityEntryModel();
  }

  final isFarmerVisitAchievementLoading = false.obs;
  final RxList<Data> farmerVisitAchievementList = <Data>[].obs;

  Future<void> getFarmerVisitAchievementByUseridandPayDate(
    String atdate,
  ) async {
    isFarmerVisitAchievementLoading.value = true;
    try {
      String? empCode = SharedPref.getEmpCode();
      if (empCode == null || empCode.trim().isEmpty) {
        throw Exception('Employee code is missing');
      }

      final response = await http.post(
        Uri.parse(
          '${ApiConstant.baseUrl}/api/Kpi/GetFarmerConnectivityEntryByUseridandPayDate',
        ).replace(queryParameters: {'EMP_CODE': empCode, 'PAYDATE': atdate}),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        FarmerVisitAchievementModel farmerVisitAchievement =
            FarmerVisitAchievementModel.fromJson(jsonResponse);
        farmerVisitAchievementList.value =
            farmerVisitAchievement.data ?? <Data>[];
      } else {
        throw Exception(
          'Failed to load data, status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      debugPrint('Error fetching farmer visit achievement: $e');
    } finally {
      isFarmerVisitAchievementLoading.value = false;
    }
  }
}
