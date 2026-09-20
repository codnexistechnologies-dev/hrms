import 'dart:convert';

import 'package:aeon_hrms/Utility/api_constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:aeon_hrms/Screens/KPI/model/KpiHistByEmpCodeand%20AtdateModel.dart';
import 'package:aeon_hrms/Screens/KPI/model/KpiMaterEmpCodeandpaydateModel.dart';
import 'package:aeon_hrms/Screens/KPI/model/saveKpiDataModel.dart';
import 'package:aeon_hrms/Utility/MLString.dart';
import 'package:aeon_hrms/Utility/shared_preferences_service.dart';
import 'package:http/http.dart' as http;

class KpiMasterController extends GetxController {
  KpiMaterEmpCodeandpaydateModel? kpiMaterEmpCodeandpaydateModel;
  SaveKpiDataModel? saveKpiDataModel;
  KpiHistByEmpCodeandAtdateModel? kpiHistByEmpCodeandAtdateModel;
  var isKpiMasterLoading = false;

  Future<void> GetKpiMasterByEmpCodeandPaydate(String PAYDATE) async {
    isKpiMasterLoading = true;
    String? empCode = SharedPref.getEmpCode();
    final response = await http.post(
      Uri.parse(
        '${ApiConstant.baseUrl}/api/MobileApi/GetKpiMasterByEmpCodeandPaydate?EMP_CODE=$empCode&PAYDATE=$PAYDATE',
      ),
    );

    if (response.statusCode == 200) {
      kpiMaterEmpCodeandpaydateModel = KpiMaterEmpCodeandpaydateModel.fromJson(
        jsonDecode(response.body),
      );
      isKpiMasterLoading = false;
      update();
    } else {
      isKpiMasterLoading = false;

      throw Exception('Failed to load album');
    }
    isKpiMasterLoading = false;
    update();
  }

  var isSaveKpiMasterData = false;
  Future<void> saveKpiMaster(
    BuildContext context,
    String PAYDATE,
    String fmplanMaster,
    String fdplanMaster,
    String demoMaster,
    String farmerdataMaster,
    String liquidationMaster,
    String collectionMaster,
    String kpiMasterRemarks,
  ) async {
    isSaveKpiMasterData = true;
    String? empCode = SharedPref.getEmpCode();
    //String? lvType = leaveTypeId;
    final response = await http.post(
      Uri.parse(
        '${ApiConstant.baseUrl}/api/MobileApi/SaveKpiMasterByEmpCodeandPaydate?EMP_CODE=$empCode&PAYDATE=$PAYDATE&FM_PLAN_MASTER=$fmplanMaster&FD_PLAN_MASTER=$fdplanMaster&DEMO_MASTER=$demoMaster&FARMERDATA_MASTER=$farmerdataMaster&LIQUIDATION_MASTER=$liquidationMaster&COLLECTION_MASTER=$collectionMaster&KPI_MASTER_REMARKS=$kpiMasterRemarks',
      ),
    );

    if (response.statusCode == 200) {
      saveKpiDataModel = SaveKpiDataModel.fromJson(jsonDecode(response.body));

      alertSucess(context, data: '${saveKpiDataModel?.data.returnMessage}');
      if (kDebugMode) {
        print(
          "checking response value ${saveKpiDataModel?.data.returnMessage}",
        );
      }
      isSaveKpiMasterData = false;
      update();
    } else {
      isSaveKpiMasterData = false;
      throw Exception('Failed to load album');
    }
    isSaveKpiMasterData = false;
    update();
  }

  var isKpiHistLoading = false;
  Future<void> GetKpiHistByEmpCodeandAtdate(String atdate) async {
    isKpiHistLoading = true;
    String? empCode = SharedPref.getEmpCode();
    final response = await http.post(
      Uri.parse(
        '${ApiConstant.baseUrl}/api/MobileApi/GetKpiHistByEmpCodeandAtdate?EMP_CODE=$empCode&ATDATE=$atdate',
      ),
    );

    if (response.statusCode == 200) {
      // if(response.body)
      kpiHistByEmpCodeandAtdateModel = KpiHistByEmpCodeandAtdateModel.fromJson(
        jsonDecode(response.body),
      );
      isKpiHistLoading = false;
      update();
    } else {
      isKpiHistLoading = false;

      throw Exception('Failed to load album');
    }
    isKpiHistLoading = false;
    update();
  }

  var isKpiHistMonthlyLoading = false;
  Future<void> GetKpiHistByEmpCodeandPayDate(String paydate) async {
    isKpiHistMonthlyLoading = true;
    String? empCode = SharedPref.getEmpCode();
    final response = await http.post(
      Uri.parse(
        '${ApiConstant.baseUrl}/api/MobileApi/GetKpiHistByEmpCodeandPaydate?EMP_CODE=$empCode&PAYDATE=$paydate',
      ),
    );

    if (response.statusCode == 200) {
      // if(response.body)
      kpiHistByEmpCodeandAtdateModel = KpiHistByEmpCodeandAtdateModel.fromJson(
        jsonDecode(response.body),
      );
      isKpiHistMonthlyLoading = false;
      update();
    } else {
      isKpiHistMonthlyLoading = false;

      throw Exception('Failed to load album');
    }
    isKpiHistMonthlyLoading = false;
    update();
  }

  var isKpiMasterMonthlyTotal = false;
  Future<void> GetKpiMaster_and_Kpihist_Total_By_Emp_code_and_Paydate(
    String paydate,
  ) async {
    isKpiMasterMonthlyTotal = true;
    String? empCode = SharedPref.getEmpCode();
    final response = await http.post(
      Uri.parse(
        '${ApiConstant.baseUrl}/api/MobileApi/GetKpiMaster_and_Kpihist_Total_By_Emp_code_and_Paydate?EMP_CODE=$empCode&PAYDATE=$paydate',
      ),
    );

    if (response.statusCode == 200) {
      // if(response.body)
      kpiMaterEmpCodeandpaydateModel = KpiMaterEmpCodeandpaydateModel.fromJson(
        jsonDecode(response.body),
      );
      isKpiMasterMonthlyTotal = false;
      update();
    } else {
      isKpiMasterMonthlyTotal = false;

      throw Exception('Failed to load album');
    }
    isKpiMasterMonthlyTotal = false;
    update();
  }

  var isSaveKpiHistData = false;
  Future<void> saveKpiHist(
    BuildContext context,
    String atdate,
    String actualFmPlan,
    String actualFdPlan,
    String actualDemo,
    String actualFarmerdata,
    String actualLiquidation,
    String actualCollection,
    String remarks,
  ) async {
    isSaveKpiHistData = true;
    String? empCode = SharedPref.getEmpCode();
    final response = await http.post(
      Uri.parse(
        '${ApiConstant.baseUrl}/api/MobileApi/SaveKpiHistByEmpCodeandAtdate?EMP_CODE=$empCode&ATDATE=$atdate&ACTUAL_FM_PLAN=$actualFmPlan&ACTUAL_FD_PLAN=$actualFdPlan&ACTUAL_DEMO=$actualDemo&ACTUAL_FARMERDATA=$actualFarmerdata&ACTUAL_LIQUIDATION=$actualLiquidation&ACTUAL_COLLECTION=$actualCollection&Remarks=$remarks',
      ),
    );

    if (response.statusCode == 200) {
      saveKpiDataModel = SaveKpiDataModel.fromJson(jsonDecode(response.body));

      alertSucess(context, data: '${saveKpiDataModel?.data.returnMessage}');
      if (kDebugMode) {
        print(
          "checking response value ${saveKpiDataModel?.data.returnMessage}",
        );
      }
      isSaveKpiHistData = false;
      update();
    } else {
      isSaveKpiHistData = false;

      throw Exception('Failed to load album');
    }
    isSaveKpiHistData = false;
    update();
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
              // Get.to(() => const LeaveApprovelDetails());
              Navigator.of(context).pop();
            },
            child: const Text('Ok'),
          ),
        ],
      ),
    );
  }
}
