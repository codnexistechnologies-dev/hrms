import 'dart:convert';
import 'dart:io';

import 'package:aeon_hrms/Utility/api_constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:aeon_hrms/GlobalComponents/button_global.dart';
import 'package:aeon_hrms/Screens/Leave%20Management/model/employeeWithManagers.dart';
import 'package:aeon_hrms/Screens/Leave%20Management/model/leaveApprovalDetails.dart';
import 'package:aeon_hrms/Screens/Leave%20Management/model/leaveApprovalEmpDetail.dart';
import 'package:aeon_hrms/Screens/Leave%20Management/model/leaveBalanceModel.dart';
import 'package:aeon_hrms/Screens/Leave%20Management/model/leaveDataSaveModel.dart';
import 'package:aeon_hrms/Screens/Leave%20Management/model/leaveStatusModel.dart';
//import 'package:aeon_hrms/Screens/Leave%20Management/view/leaveApprovalDetails.dart';
import 'package:aeon_hrms/Utility/MLString.dart';
import 'package:aeon_hrms/Utility/shared_preferences_service.dart';
import 'package:aeon_hrms/constant.dart';
import 'package:http/http.dart' as http;

class LeaveController extends GetxController {
  LeaveBalanceModel? leaveBalanceModel;
  EmployeeWithManagersModel? employeeWithManagersModel;
  LeaveDataSaveModelModel? leaveDataSaveModelModel;
  LeaveApprovalDetailsModel? leaveApprovalDetailsModel;
  LeaveApprovalEmpModel? leaveApprovalEmpModel;
  LeaveBalenceData? selectedValue;
  List<LeaveBalenceData> leaveTypeList = <LeaveBalenceData>[];
  LeaveStatusModel? leaveStatusModel;
  String? leaveTypeId;
  String? earn;
  String? availed;
  String? balance;
  String? mngrCode;
  String? leavid;
  String? levAppEmpcode;
  var isLoading = false;
  Future<void> getLeaveBalancebyEmpcode() async {
    isLoading = true;
    String? empCode = SharedPref.getEmpCode();
    final response = await http.post(
      Uri.parse(
        '${ApiConstant.baseUrl}/api/MobileApi/GetLeaveBalanceByEmpcode?EMP_CODE=$empCode',
      ),
    );

    if (response.statusCode == 200) {
      leaveBalanceModel = LeaveBalanceModel.fromJson(jsonDecode(response.body));
      leaveTypeList = leaveBalanceModel!.data!;
      // updateCheckBox();
      isLoading = false;
      update();
      // print("checking response value length ${leaveTypeList.length}");
    } else {
      isLoading = false;
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
    isLoading = false;
    update();
  }

  List<bool> ckeckBoxStatusList = [];

  Future<void> getLeaveApprovelListbyMngrcode() async {
    isLoading = true;
    String? empCode = SharedPref.getEmpCode();
    final response = await http.post(
      Uri.parse(
        '${ApiConstant.baseUrl}/api/MobileApi/GetLeaveApprovelDetailsByMngrCode?MNGR_CODE=$empCode',
      ),
    );

    if (response.statusCode == 200) {
      leaveStatusModel = LeaveStatusModel.fromJson(jsonDecode(response.body));

      isLoading = false;
      update();
      // print(
      //     "checking response value ${leaveBalanceModel?.data?.first.emPName}");
    } else {
      isLoading = false;
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
    isLoading = false;
    update();
  }

  // List<bool> ckeckBoxStatusList = [];
  List<LeaveApproval> leaveApprovalDetailsModelList = [];
  var isMngrCodeandEmpcode = false;
  Future<void> getLeaveApprovelDetailsByMngrCodeandEmpcode() async {
    try {
      isMngrCodeandEmpcode = true;
      String? mngrCode = SharedPref.getEmpCode();
      //String? empCode = SharedPref.getEmpCode();
      final response = await http.post(
        Uri.parse(
          '${ApiConstant.baseUrl}/api/MobileApi/GetLeaveApprovelDetailsByMngrCodeandEmpcode?MNGR_CODE=$mngrCode&EMP_CODE=$levAppEmpcode',
        ),
      );

      if (response.statusCode == 200) {
        // leaveApprovalEmpModel =
        //     LeaveApprovalEmpModel.fromJson(jsonDecode(response.body));
        leaveApprovalDetailsModel = LeaveApprovalDetailsModel.fromJson(
          jsonDecode(response.body),
        );
        leaveApprovalDetailsModelList.clear(); // Clear existing data
        leaveApprovalDetailsModelList.addAll(
          leaveApprovalDetailsModel?.data ?? [],
        ); // Assign fetched data
        ckeckBoxStatusList.clear();
        for (
          int i = 0;
          i < (leaveApprovalDetailsModel?.data?.length ?? 0);
          i++
        ) {
          ckeckBoxStatusList.add(false);
        }

        print(
          "checking ===== response value ${leaveApprovalDetailsModel?.data?.length}",
        );
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('Failed to load album');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      isMngrCodeandEmpcode = false;
      update();
    }
  }

  Future<void> getLeaveStatusByEmpcodeMonthandYear(
    String month,
    String year,
  ) async {
    isLoading = true;
    String? empCode = SharedPref.getEmpCode();
    final response = await http.post(
      Uri.parse(
        '${ApiConstant.baseUrl}/api/MobileApi/GetLeaveStatusByEmpcodeMonthandYear?EMP_CODE=$empCode&Month=$month&Year=$year',
      ),
    );

    if (response.statusCode == 200) {
      leaveStatusModel = LeaveStatusModel.fromJson(jsonDecode(response.body));
      isLoading = false;
      update();
      // print(
      //     "checking response value ${leaveBalanceModel?.data?.first.emPName}");
    } else {
      isLoading = false;
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
    isLoading = false;
    update();
  }

  Future<void> getLeaveCancelationDetailsByEmpcode() async {
    isLoading = true;
    //String? empCode = SharedPref.getEmpCode();
    final response = await http.post(
      Uri.parse(
        '${ApiConstant.baseUrl}/api/MobileApi/GetLeaveCancelationDetailsByEmpcode?EMP_CODE=IWI2021013&FromDate=2023-10-01&ToDate=2023-10-30',
      ),
    );

    if (response.statusCode == 200) {
      leaveStatusModel = LeaveStatusModel.fromJson(jsonDecode(response.body));
      isLoading = false;
      update();
      // print(
      //     "checking response value ${leaveBalanceModel?.data?.first.emPName}");
    } else {
      isLoading = false;
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
    isLoading = false;
    update();
  }

  var isemployeewithManages = false;
  Future<void> getLeaveManagerslDetailsByEmpCode() async {
    isemployeewithManages = true;
    String? empCode = SharedPref.getEmpCode();
    final response = await http.post(
      Uri.parse(
        '${ApiConstant.baseUrl}/api/MobileApi/GetLeaveManagerslDetailsByEmpCode?EMP_CODE=$empCode',
      ),
    );

    if (response.statusCode == 200) {
      employeeWithManagersModel = EmployeeWithManagersModel.fromJson(
        jsonDecode(response.body),
      );
      isemployeewithManages = false;
      update();
      // print(
      //     "checking response value ${employeeWithManagersModel?.data?.first.emPName}");
    } else {
      isemployeewithManages = false;
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
    isemployeewithManages = false;
    update();
  }

  var issaveLeaveApply = false;
  Future<void> saveLeaveApplication(
    BuildContext context,
    String fromDate,
    String toDate,
    String days,
    String type,
    String mngrCode,
    String remarks,
  ) async {
    issaveLeaveApply = true;
    String? empCode = SharedPref.getEmpCode();
    //String? lvType = leaveTypeId;
    final response = await http.post(
      Uri.parse(
        '${ApiConstant.baseUrl}/api/MobileApi/SaveLeaveApplicationByEmpcode?EMP_CODE=$empCode&FROMDATE=$fromDate&TODATE=$toDate&LVTYPE=$leaveTypeId&DAYS=$days&TYPE=$type&MNGR_CODE=$mngrCode&REMARKS=$remarks',
      ),
    );

    if (response.statusCode == 200) {
      // print(response.body["data"].)
      leaveDataSaveModelModel = LeaveDataSaveModelModel.fromJson(
        jsonDecode(response.body),
      );
      // ignore: use_build_context_synchronously
      alertSucess(
        context,
        data: '${leaveDataSaveModelModel?.data?.returnMessage}',
      );
      if (kDebugMode) {
        print(
          "checking response value ${leaveDataSaveModelModel?.data?.returnMessage}",
        );
      }
      issaveLeaveApply = false;
      update();
    } else {
      issaveLeaveApply = false;
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
    issaveLeaveApply = false;
    update();
  }

  var isLeaveapprovelid = false;
  Future<void> getLeaveApprovelDetailsByEmpcodeandId() async {
    isLeaveapprovelid = true;
    //String? empCode = SharedPref.getEmpCode();
    final response = await http.post(
      Uri.parse(
        '${ApiConstant.baseUrl}/api/MobileApi/GetLeaveApprovelDetailsByEmpcodeandId?ID=$leavid&EMP_CODE=$levAppEmpcode',
      ),
    );
    if (response.statusCode == 200) {
      leaveApprovalEmpModel = LeaveApprovalEmpModel.fromJson(
        jsonDecode(response.body),
      );
      isLeaveapprovelid = false;

      update();
    } else {
      isLeaveapprovelid = false;
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
    isLeaveapprovelid = false;
    update();
  }

  var issaveLeaveSanction = false;
  Future<void> saveLeaveSanctionByEmpCodeandId(
    BuildContext context,
    List<Map<String, dynamic>> data,
  ) async {
    issaveLeaveSanction = true;
    print(jsonEncode(data));
    final response = await http.post(
      Uri.parse(
        '${ApiConstant.baseUrl}/api/MobileApi/SaveLeaveSanctionByEmpCodeandId',
      ),
      headers: {HttpHeaders.contentTypeHeader: "application/json"},
      body: jsonEncode(data),
    );
    if (response.statusCode == 200) {
      // print(response.body["data"].)
      leaveDataSaveModelModel = LeaveDataSaveModelModel.fromJson(
        jsonDecode(response.body),
      );
      // ignore: use_build_context_synchronously
      alertSucess(
        context,
        data: '${leaveDataSaveModelModel?.data?.returnMessage}',
      );
      print(
        "checking response value ${leaveDataSaveModelModel?.data?.returnMessage}",
      );
      getLeaveApprovelDetailsByMngrCodeandEmpcode();
      issaveLeaveSanction = false;
      update();
    } else {
      issaveLeaveSanction = false;
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
    issaveLeaveSanction = false;
    update();
  }

  var issaveApprovelLoding = false;
  Future<void> saveLeaveSanctionByEmpCodeandIdByDetails(
    BuildContext context,
    List<Map<String, dynamic>> data,
  ) async {
    issaveApprovelLoding = true;
    print(jsonEncode(data));
    final response = await http.post(
      Uri.parse(
        '${ApiConstant.baseUrl}/api/MobileApi/SaveLeaveSanctionByEmpCodeandId',
      ),
      headers: {HttpHeaders.contentTypeHeader: "application/json"},
      body: jsonEncode(data),
    );
    if (response.statusCode == 200) {
      // print(response.body["data"].)
      leaveDataSaveModelModel = LeaveDataSaveModelModel.fromJson(
        jsonDecode(response.body),
      );
      // ignore: use_build_context_synchronously
      alertSucessAndRedirect(
        context,
        data: '${leaveDataSaveModelModel?.data?.returnMessage}',
      );
      print(
        "checking response value ${leaveDataSaveModelModel?.data?.returnMessage}",
      );
      getLeaveApprovelDetailsByMngrCodeandEmpcode();
      issaveApprovelLoding = false;
      update();
    } else {
      issaveApprovelLoding = false;
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
    issaveApprovelLoding = false;
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

  Future alertMsgSucessGotoHome(
    BuildContext context, {
    required String data,
    required String url,
  }) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          // ignore: sized_box_for_whitespace
          child: SizedBox(
            height: 400.0,
            child: Column(
              children: [
                const SizedBox(height: 20.0),
                const Image(image: AssetImage('images/paymentsuccess.png')),
                const SizedBox(height: 5.0),
                Text('Great', style: kTextStyle.copyWith(color: kMainColor)),
                const SizedBox(height: 5.0),
                Text(
                  data,
                  style: kTextStyle.copyWith(
                    color: kTitleColor,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 50.0),
                ButtonGlobal(
                  buttontext: 'Back To Home',
                  buttonDecoration: kButtonDecoration.copyWith(
                    color: kMainColor,
                  ),
                  onPressed: () {
                    //Get.back();
                    Get.to(() => url);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future alertSucessAndRedirect(BuildContext context, {required String data}) {
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
              // Get.to(() => const LeaveApprovalDetails());
              //Navigator.of(context).pop();
            },
            child: const Text('Ok'),
          ),
        ],
      ),
    );
  }
}
