import 'dart:developer';

import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:aeon_hrms/Utility/api_constants.dart';
import 'package:aeon_hrms/Utility/shared_preferences_service.dart';

import '../../widgets/contact_entry_form_support.dart';

class AddRetailerDistributorVisitEntry extends StatefulWidget {
  const AddRetailerDistributorVisitEntry({super.key});

  @override
  State<AddRetailerDistributorVisitEntry> createState() =>
      _AddRetailerDistributorVisitEntryState();
}

class _AddRetailerDistributorVisitEntryState
    extends ContactEntryFormState<AddRetailerDistributorVisitEntry> {
  @override
  Future<void> saveEntry() async {
    if (saving || !formKey.currentState!.validate()) return;
    if (photo == null) {
      showMessage('Please add a photo before saving.');
      return;
    }
    if (position == null) {
      showMessage('Please capture your current location before saving.');
      return;
    }
    if (demoPlanController.productselectedValue.value == null) {
      showMessage('Please select a product before saving.');
      return;
    }
    setState(() => saving = true);

    try {
      final selectedProduct = demoPlanController.productselectedValue.value;
      final image = photo;
      final formData = dio.FormData.fromMap({
        'STOCK_AVAILABLE': fields['STOCK_AVAILABLE']!.text.trim(),
        'ORDER_VALUE':
            orderTaken && fields['ORDER_VALUE']!.text.trim().isNotEmpty
            ? fields['ORDER_VALUE']!.text.trim()
            : '0',
        'IMAGE_FILE': image == null
            ? ''
            : await dio.MultipartFile.fromFile(
                image.path,
                filename: image.name,
              ),
        'FOLLOW_UP_DATE': followUpDate == null
            ? ''
            : DateFormat('yyyy-MM-dd').format(followUpDate!),
        'EMP_CODE': SharedPref.getEmpCode().toString(),
        'SCHEME_DISCUSSED': fields['SCHEME_DISCUSSED']!.text.trim(),
        'MARKET_FEEDBACK': fields['MARKET_FEEDBACK']!.text.trim(),
        'OTHER_PRODUCT_DISCUSS_NAME': fields['OTHER_PRODUCT_DISCUSS_NAME']!.text
            .trim(),
        'LATITUDE': position?.latitude.toString() ?? '',
        'VISIT_TYPE': selectedVisitType ?? '',
        'PRODUCT_DISCUSSED': fields['PRODUCT_DISCUSSED']!.text.trim(),
        'LONGITUDE': position?.longitude.toString() ?? '',
        'REMARKS': fields['REMARKS']!.text.trim(),
        'CONTACT_PERSON': fields['CONTACT_PERSON']!.text.trim(),
        'ADDRESS': fields['ADDRESS']!.text.trim(),
        'ORDER_TAKEN': orderTaken ? 'Yes' : 'No',
        'PRODUCT_NAME': selectedProduct?.productName ?? '',
        'COMPETITOR_PRODUCT': fields['COMPETITOR_PRODUCT']!.text.trim(),
        'PRODUCT_CODE': selectedProduct?.productCode?.toString() ?? '',
      });

      log(
        'Retailer / distributor visit request body:\n'
        '${formData.fields.map((field) => '${field.key}=${field.value}').join('\n')}\n'
        'Files: ${formData.files.map((file) => '${file.key}=${file.value.filename} (${file.value.length} bytes)').join(', ')}',
        name: 'retailer_distributor_api',
      );

      final response = await dio.Dio().post(
        '${ApiConstant.baseUrl}/api/Kpi/AddRetailerDistributorEntry',
        data: formData,
        options: dio.Options(
          headers: {'accept': '*/*', 'Content-Type': 'multipart/form-data'},
        ),
      );
      log(
        "Retailer / distributor visit submit response: "
        "status=${response.statusCode}, "
        "data=${response.data}",
      );
      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        showMessage('Retailer / distributor visit entry saved successfully.');
      } else {
        showMessage('Unable to save retailer / distributor visit entry.');
      }
    } on dio.DioException catch (error) {
      debugPrint(
        'Retailer / distributor visit submit failed: '
        'uri=${error.requestOptions.uri}, '
        'status=${error.response?.statusCode}, '
        'response=${error.response?.data}, '
        'message=${error.message}',
      );
      showMessage(
        'Unable to save retailer / distributor visit entry. Please try again.',
      );
    } catch (error) {
      debugPrint('Retailer / distributor visit submit failed: $error');
      showMessage(
        'Unable to save retailer / distributor visit entry. Please try again.',
      );
    } finally {
      if (mounted) setState(() => saving = false);
    }
  }

  @override
  Widget build(BuildContext context) => buildContactEntryForm(
    title: 'Retailer / Distributor Visit Entry',
    fields: [
      visitTypeDropdown(),
      textField('CONTACT_PERSON', 'Contact Person', limit: 150),
      orderTakenDropdown(),
      if (orderTaken) textField('ORDER_VALUE', 'Order Value', limit: 19),
      textField('STOCK_AVAILABLE', 'Stock Available', limit: 250),
      productDropdown(),
      textField('PRODUCT_DISCUSSED', 'Product Discussed', limit: 500),
      otherProductDiscussDropdown(),
      textField('COMPETITOR_PRODUCT', 'Competitor Product', limit: 500),
      textField('SCHEME_DISCUSSED', 'Scheme Discussed', limit: 500),
      textField('MARKET_FEEDBACK', 'Market Feedback', limit: 1000, lines: 3),
      followUpDateField(),
      textField('REMARKS', 'Remarks', limit: 1000, lines: 4),
      photoUploadField(),
      SizedBox(height: 10),
      locationCaptureButton(),
      SizedBox(height: 15),
      locationReadout(),
    ],
  );
}
