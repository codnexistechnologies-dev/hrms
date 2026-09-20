// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:convert';
import 'dart:io';

import 'package:aeon_hrms/Utility/api_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:path_provider/path_provider.dart';
import 'package:aeon_hrms/Screens/Report/model/PaySlipEmpCodeandMonthYearModel.dart';
import 'package:aeon_hrms/Screens/Report/model/dedFieldModel.dart';
import 'package:aeon_hrms/Screens/Report/model/netpayModel.dart';
import 'package:aeon_hrms/Screens/Report/view/view_pdf.dart';
import 'package:aeon_hrms/Utility/MLString.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:aeon_hrms/Screens/Report/model/earnFieldModel.dart';
import 'package:aeon_hrms/Utility/shared_preferences_service.dart';

class ReportController extends GetxController {
  EarnFiledModel? earnFiledModel;
  DedFiledModel? dedFiledModel;
  NetPayModel? netPayModel;
  PaySlipEmpCodeandMonthYearModel? paySlipEmpCodeandMonthYearModel;
  var isEarnLoding = false;
  Future<void> getGrossEarnDetailsByEmpCodeMonthYear(
    String month,
    String year,
  ) async {
    isEarnLoding = true;
    String? empCode = SharedPref.getEmpCode();
    final response = await http.post(
      Uri.parse(
        '${ApiConstant.baseUrl}/api/MobileApi/GetGrossEarnDetailsByEmpCodeMonthYear?EMP_CODE=$empCode&Month=$month&Year=$year',
      ),
    );

    if (response.statusCode == 200) {
      earnFiledModel = EarnFiledModel.fromJson(jsonDecode(response.body));

      isEarnLoding = false;
      update();
      print("checking response value length ${earnFiledModel!.data!.length}");
    } else {
      isEarnLoding = false;

      throw Exception('Failed to load album');
    }
    isEarnLoding = false;
    update();
  }

  var isDedLoding = false;
  Future<void> getGrossDedDetailsByEmpCodeMonthYear(
    String month,
    String year,
  ) async {
    isDedLoding = true;
    String? empCode = SharedPref.getEmpCode();
    final response = await http.post(
      Uri.parse(
        '${ApiConstant.baseUrl}/api/MobileApi/GetGrossDedDetailsByEmpCodeMonthYear?EMP_CODE=$empCode&Month=$month&Year=$year',
      ),
    );

    if (response.statusCode == 200) {
      dedFiledModel = DedFiledModel.fromJson(jsonDecode(response.body));

      isDedLoding = false;
      update();
      print("checking response value length ${dedFiledModel!.data!.length}");
    } else {
      isDedLoding = false;

      throw Exception('Failed to load album');
    }
    isDedLoding = false;
    update();
  }

  var isnetpayLoding = false;
  Future<void> getNetPayDetailsByEmpCodeMonthYear(
    String month,
    String year,
  ) async {
    isnetpayLoding = true;
    String? empCode = SharedPref.getEmpCode();
    final response = await http.post(
      Uri.parse(
        '${ApiConstant.baseUrl}/api/MobileApi/GetNetPayDetailsByEmpCodeMonthYear?EMP_CODE=$empCode&Month=$month&Year=$year',
      ),
    );

    if (response.statusCode == 200) {
      netPayModel = NetPayModel.fromJson(jsonDecode(response.body));
      isnetpayLoding = false;
      update();
      //print("checking response value length ${netPayModel!.data!.length}");
    } else {
      isnetpayLoding = false;
      throw Exception('Failed to load album');
    }
    isnetpayLoding = false;
    update();
  }

  RxBool ispayslipLoding = false.obs;
  Future<void> getPaySlipDetailsByEmpCodeMonthYear(
    BuildContext context,
    String month,
    String year,
  ) async {
    if (ispayslipLoding.value) return;
    ispayslipLoding.value = true;
    try {
      final uri =
          Uri.parse(
            '${ApiConstant.baseUrl}/api/MobileApi/GetPaySlipByEmpCodeandMonth',
          ).replace(
            queryParameters: {
              'EMP_CODE': SharedPref.getEmpCode() ?? '',
              'Month': month,
              'Year': year,
            },
          );
      final response = await http
          .post(uri)
          .timeout(const Duration(seconds: 60));
      if (response.statusCode != 200)
        // ignore: curly_braces_in_flow_control_structures
        throw HttpException(
          'Payslip API failed (HTTP ${response.statusCode}).',
        );
      paySlipEmpCodeandMonthYearModel =
          PaySlipEmpCodeandMonthYearModel.fromJson(jsonDecode(response.body));
      final records = paySlipEmpCodeandMonthYearModel?.data;
      final pdfUrl = records == null || records.isEmpty
          ? ''
          : (records.first.paysliPPath?.toString().trim() ?? '');
      if (pdfUrl.isEmpty) {
        if (context.mounted)
          // ignore: curly_braces_in_flow_control_structures
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Payslip not available'),
            ),
          );
        return;
      }
      final file = await downloadPdf(pdfUrl);
      if (!context.mounted) return;
      final savedPath = await FlutterFileDialog.saveFile(
        params: SaveFileDialogParams(
          sourceFilePath: file.path,
          fileName: 'payslip_${year}_$month.pdf',
          mimeTypesFilter: const ['application/pdf'],
        ),
      );
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            savedPath == null
                ? 'Save cancelled. PDF is available to preview.'
                : 'Payslip PDF saved successfully.',
          ),
        ),
      );
      Get.to(() => ViewPdf(file.path, isLocal: true));
    } catch (error) {
      debugPrint('Unable to download payslip: $error');
      if (context.mounted)
        // ignore: curly_braces_in_flow_control_structures
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Payslip not available')),
        );
    } finally {
      ispayslipLoding.value = false;
      update();
    }
  }

  Future<File> downloadPdf(String url) async {
    final response = await http
        .get(Uri.parse(url))
        .timeout(const Duration(seconds: 30));
    if (response.statusCode != 200)
      // ignore: curly_braces_in_flow_control_structures
      throw HttpException('PDF download failed (HTTP ${response.statusCode}).');
    if (response.bodyBytes.length < 5 ||
        ascii.decode(response.bodyBytes.take(5).toList(), allowInvalid: true) !=
            '%PDF-')
      throw const FormatException('Server did not return a valid PDF.');
    final directory = await getTemporaryDirectory();
    final file = File(
      '${directory.path}/payslip_${DateTime.now().microsecondsSinceEpoch}.pdf',
    );
    await file.writeAsBytes(response.bodyBytes, flush: true);
    return file;
  }
}
