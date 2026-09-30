import 'package:flutter/material.dart';
import 'package:dio/dio.dart' as dio;
import 'package:intl/intl.dart';
import 'package:aeon_hrms/Utility/api_constants.dart';
import 'package:aeon_hrms/Utility/shared_preferences_service.dart';

import '../../widgets/contact_entry_form_support.dart';

class AddFarmerConnectivityEntry extends StatefulWidget {
  const AddFarmerConnectivityEntry({super.key});

  @override
  State<AddFarmerConnectivityEntry> createState() =>
      _AddFarmerConnectivityEntryState();
}

class _AddFarmerConnectivityEntryState
    extends ContactEntryFormState<AddFarmerConnectivityEntry> {
  @override
  Future<void> saveEntry() async {
    if (saving) return;
    final requiredSelections = <String, Object?>{
      'Product Name': demoPlanController.productselectedValue.value,
      'Crop': demoPlanController.selectedCrop.value,
      'State': demoPlanController.selectedState.value,
      'District': demoPlanController.selectedDistrict.value,
      'Tehsil': demoPlanController.selectedTehsil.value,
      'Village': demoPlanController.selectedvillage.value,
    };
    for (final selection in requiredSelections.entries) {
      if (selection.value == null) {
        formKey.currentState!.validate();
        showMessage('Please select ${selection.key}.');
        return;
      }
    }
    if (!formKey.currentState!.validate()) return;
    if (fields['OTHER_PRODUCT_DISCUSS_NAME']!.text.trim().isEmpty) {
      showMessage('Select at least one discussed product.');
      return;
    }
    if (followUpDate == null) {
      showMessage('Select a follow-up date.');
      return;
    }
    if (photo == null) {
      showMessage('Upload a photo before saving.');
      return;
    }
    if (position == null) {
      showMessage('Capture your current location before saving.');
      return;
    }
    setState(() => saving = true);

    try {
      final image = photo;
      final selectedProduct = demoPlanController.productselectedValue.value;
      final selectedCrop = demoPlanController.selectedCrop.value;
      final selectedState = demoPlanController.selectedState.value;
      final selectedDistrict = demoPlanController.selectedDistrict.value;
      final selectedTehsil = demoPlanController.selectedTehsil.value;
      final selectedVillage = demoPlanController.selectedvillage.value;
      final formData = dio.FormData.fromMap({
        'VILLAGE_CODE': selectedVillage?.villagECODE?.toString() ?? '',
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
        'FARMER_INTEREST': fields['FARMER_INTEREST']!.text.trim(),
        'FARMER_NAME': fields['FARMER_NAME']!.text.trim(),
        'OTHER_PRODUCT_DISCUSS_NAME': fields['OTHER_PRODUCT_DISCUSS_NAME']!.text
            .trim(),
        'ACREAGE': fields['ACREAGE']!.text.trim(),
        'TEHSIL_NAME': selectedTehsil?.tehsiLNAME ?? '',
        'LATITUDE': position?.latitude.toString() ?? '',
        'TEHSIL_CODE': selectedTehsil?.tehsiLCODE?.toString() ?? '',
        'ENTRYDATETIME': '',
        'PRODUCT_DISCUSSED': fields['PRODUCT_DISCUSSED']!.text.trim(),
        'LONGITUDE': position?.longitude.toString() ?? '',
        'IMAGE_FILE1': '',
        'IMAGE_FILE2': '',
        'REMARKS': fields['REMARKS']!.text.trim(),
        'IMAGE_FILE3': '',
        'IMAGE_FILE4': '',
        'ADDRESS': fields['ADDRESS']!.text.trim(),
        'UPLOAD_FILE1': '',
        'FARMER_ID': '',
        'UPLOAD_FILE2': '',
        'CONTACT_TYPE': fields['CONTACT_TYPE']!.text.trim(),
        'STATE_NAME': selectedState?.statENAME ?? '',
        'UPLOAD_FILE3': '',
        'UPLOAD_FILE': '',
        'UPLOAD_FILE4': '',
        'CROP_NAME': selectedCrop?.croPNAME ?? '',
        'STATE_CODE': selectedState?.statECODE?.toString() ?? '',
        'PRODUCT_NAME': selectedProduct?.productName ?? '',
        'DISTRICT_NAME': selectedDistrict?.districTNAME ?? '',
        'CROP_CODE': selectedCrop?.croPCODE?.toString() ?? '',
        'PRODUCT_CODE': selectedProduct?.productCode?.toString() ?? '',
        'VILLAGE_NAME': selectedVillage?.villagENAME ?? '',
        'DISTRICT_CODE': selectedDistrict?.districTCODE?.toString() ?? '',
      });

      final response = await dio.Dio().post(
        '${ApiConstant.baseUrl}/api/Kpi/AddFarmerConnectivityEntry',
        data: formData,
        options: dio.Options(
          headers: {'accept': '*/*', 'Content-Type': 'multipart/form-data'},
        ),
      );

      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        if (!mounted) return;
        await showDialog<void>(
          context: context,
          builder: (dialogContext) => AlertDialog(
            title: const Text('Success'),
            content: const Text(
              'Farmer connectivity entry saved successfully.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } else {
        showMessage('Unable to save farmer connectivity entry.');
      }
    } on dio.DioException catch (error) {
      debugPrint('Farmer connectivity submit failed: ${error.message}');
      showMessage(
        'Unable to save farmer connectivity entry. Please try again.',
      );
    } catch (error) {
      debugPrint('Farmer connectivity submit failed: $error');
      showMessage(
        'Unable to save farmer connectivity entry. Please try again.',
      );
    } finally {
      if (mounted) setState(() => saving = false);
    }
  }

  @override
  Widget build(BuildContext context) => buildContactEntryForm(
    title: 'Farmer Connectivity Entry',
    fields: [
      productDropdown(required: true),
      cropDropdown(required: true),
      stateDropdown(required: true),
      districtDropdown(required: true),
      tehsilDropdown(required: true),
      villageDropdown(required: true),
      textField('FARMER_NAME', 'Farmer Name', limit: 1000, required: true),
      textField('PINCODE', 'Pincode', limit: 6, required: true),
      textField(
        'CONTACT_TYPE',
        'Contact Number',
        required: true,
        limit: 10,
      ),
      textField('ACREAGE', 'Acres', required: true),
      otherProductDiscussDropdown(),
      textField(
        'FARMER_INTEREST',
        'Farmer Interest',
        limit: 100,
        required: true,
      ),
      followUpDateField(),
      textField('REMARKS', 'Remarks', limit: 1000, lines: 4, required: true),
      photoUploadField(),
      SizedBox(height: 10),
      locationCaptureButton(),
      SizedBox(height: 15),
      locationReadout(),
      SizedBox(height: 15),
      textField('ADDRESS', 'Address', lines: 3, required: true),
    ],
  );
}
