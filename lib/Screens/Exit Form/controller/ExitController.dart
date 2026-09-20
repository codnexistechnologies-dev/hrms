import 'dart:convert';
import 'dart:io';

import 'package:aeon_hrms/Utility/api_constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:aeon_hrms/Screens/Exit%20Form/model/ResignationAppStatusByEmpCode.dart';
import 'package:aeon_hrms/Screens/Exit%20Form/model/exitReturnMassageModel.dart';
import 'package:aeon_hrms/Utility/MLString.dart';
import 'package:aeon_hrms/Utility/shared_preferences_service.dart';
//import 'package:aeon_hrms/Utility/shared_preferences_service.dart';
import 'package:http/http.dart' as http;

class ExitController extends GetxController {
  ExitReturnMassageModel? exitReturnMassageModel;
  ResignationAppStatusByEmpCode? resignationAppStatusByEmpCode;
  var issaveExitForm = false;
  Future<void> saveExitApplication(
    BuildContext context,
    Map<String, dynamic> data,
  ) async {
    try {
      issaveExitForm = true;
      final response = await http.post(
        Uri.parse('${ApiConstant.baseUrl}/api/MobileApi/SaveSeparationForm'),
        headers: {HttpHeaders.contentTypeHeader: "application/json"},
        body: jsonEncode(data),
      );
      if (response.statusCode == 200) {
        exitReturnMassageModel = ExitReturnMassageModel.fromJson(
          jsonDecode(response.body),
        );
        alertSucessAndRedirect(
          context,
          data: '${exitReturnMassageModel?.data?.returnMessage}',
        );
        if (kDebugMode) {
          print(
            "checking response value ${exitReturnMassageModel?.data?.returnMessage}",
          );
        }
        issaveExitForm = false;
        update();
      } else {
        issaveExitForm = false;
        throw Exception('Failed to load album');
      }
    } catch (e) {
      issaveExitForm = false;
      // Handle exceptions here, such as showing an error message
      print('Exception occurred: $e');
      // You can also rethrow the exception if you want to propagate it
      // throw e;
    } finally {
      issaveExitForm = false;
      update();
    }
  }

  var isExitFormByEmpCode = false;
  Future<void> GetSeparationFormStatusByEmpCode() async {
    isExitFormByEmpCode = true;
    String? empCode = SharedPref.getEmpCode();
    final response = await http.post(
      Uri.parse(
        '${ApiConstant.baseUrl}/api/MobileApi/GetSeparationFormStatusByEmpCode?EMP_CODE=$empCode',
      ),
    );

    if (response.statusCode == 200) {
      // if(response.body)
      resignationAppStatusByEmpCode = ResignationAppStatusByEmpCode.fromJson(
        jsonDecode(response.body),
      );
      isExitFormByEmpCode = false;
      update();
    } else {
      isExitFormByEmpCode = false;

      throw Exception('Failed to load album');
    }
    isExitFormByEmpCode = false;
    update();
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
            },
            child: const Text('Ok'),
          ),
        ],
      ),
    );
  }
}
