import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:aeon_hrms/Utility/api_constants.dart';
import 'package:aeon_hrms/Utility/shared_preferences_service.dart';

import '../../widgets/contact_entry_form_support.dart';

class AddRetailerDistributorVisitEntry extends StatefulWidget {
  const AddRetailerDistributorVisitEntry({
    super.key,
    this.loadContactsOnOpen = true,
  });

  final bool loadContactsOnOpen;

  @override
  State<AddRetailerDistributorVisitEntry> createState() =>
      _AddRetailerDistributorVisitEntryState();
}

class _AddRetailerDistributorVisitEntryState
    extends ContactEntryFormState<AddRetailerDistributorVisitEntry> {
  List<_ContactPerson> contactPeople = [];
  _ContactPerson? selectedContactPerson;
  bool loadingContactPeople = true;
  final contactLoadCancelToken = dio.CancelToken();
  final contactPersonDropdownKey = GlobalKey<FormFieldState<_ContactPerson>>();

  @override
  void initState() {
    super.initState();
    if (widget.loadContactsOnOpen) {
      unawaited(loadContactPeople());
    } else {
      loadingContactPeople = false;
    }
  }

  @override
  void dispose() {
    contactLoadCancelToken.cancel('Retailer visit form closed.');
    super.dispose();
  }

  Future<List<_ContactPerson>> fetchContactPeople(int visitTypeCode) async {
    final response = await dio.Dio().post(
      '${ApiConstant.baseUrl}/api/Kpi/GetRetailerDetailsByType',
      queryParameters: {'VISIT_TYPE': visitTypeCode},
      cancelToken: contactLoadCancelToken,
      options: dio.Options(headers: {'accept': 'application/json'}),
    );
    final data = response.data is Map ? response.data['data'] : null;
    if (data is! List) {
      throw const FormatException('Invalid contact-person response.');
    }
    return data
        .whereType<Map>()
        .map(
          (item) => _ContactPerson.fromJson(
            Map<String, dynamic>.from(item),
            fallbackVisitType: visitTypeCode,
          ),
        )
        .where((person) => person.id.isNotEmpty && person.name.isNotEmpty)
        .toList();
  }

  Future<void> loadContactPeople() async {
    try {
      final peopleByType = await Future.wait([
        fetchContactPeople(2),
        fetchContactPeople(1),
      ]);
      final loadedPeople = peopleByType.expand((people) => people).toList();
      if (!mounted) return;
      setState(() {
        contactPeople = loadedPeople;
        loadingContactPeople = false;
      });
      if (loadedPeople.isEmpty) {
        showMessage('No contact persons found.');
      }
    } catch (error) {
      if (!mounted) return;
      setState(() => loadingContactPeople = false);
      debugPrint('Failed to load contact persons: $error');
      showMessage('Unable to load contact persons. Please try again.');
    }
  }

  List<_ContactPerson> get visibleContactPeople {
    final visitTypeCode = switch (selectedVisitType) {
      'Retailer' => 2,
      'Distributor' => 1,
      _ => null,
    };
    if (visitTypeCode == null) return [];
    return contactPeople
        .where((person) => person.visitType == visitTypeCode)
        .toList();
  }

  Widget contactPersonDropdown() => KeyedSubtree(
    key: const ValueKey('contact-person-dropdown'),
    child: Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: DropdownButtonFormField<_ContactPerson>(
        key: contactPersonDropdownKey,
        initialValue: selectedContactPerson,
        decoration: fieldDecoration(
          'Contact Person',
          suffix: loadingContactPeople
              ? const Padding(
                  padding: EdgeInsets.all(14),
                  child: SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              : null,
        ),
        isExpanded: true,
        validator: (value) => value == null ? 'Select a contact person' : null,
        items: visibleContactPeople
            .map(
              (person) =>
                  DropdownMenuItem(value: person, child: Text(person.name)),
            )
            .toList(),
        onChanged: loadingContactPeople || selectedVisitType == null
            ? null
            : (value) => setState(() {
                selectedContactPerson = value;
                fields['CONTACT_PERSON']!.text = value?.name ?? '';
                fields['MOBILE_NO']!.text = value?.mobileNo ?? '';
              }),
      ),
    ),
  );

  @override
  Future<void> saveEntry() async {
    if (saving || !formKey.currentState!.validate()) return;
    if (fields['OTHER_PRODUCT_DISCUSS_NAME']!.text.trim().isEmpty) {
      showMessage('Select at least one discussed product.');
      return;
    }
    if (followUpDate == null) {
      showMessage('Select a follow-up date.');
      return;
    }
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
        'VISIT_TYPE': selectedVisitType == 'Retailer' ? '2' : '1',
        'PRODUCT_DISCUSSED': fields['PRODUCT_DISCUSSED']!.text.trim(),
        'LONGITUDE': position?.longitude.toString() ?? '',
        'REMARKS': fields['REMARKS']!.text.trim(),
        'CONTACT_PERSON': selectedContactPerson?.id ?? '',
        'CUSTOMER_ID': selectedContactPerson?.id ?? '',
        'MOBILE_NO': selectedContactPerson?.mobileNo ?? '',
        'ADDRESS': fields['ADDRESS']!.text.trim(),
        'ORDER_TAKEN': orderTaken ? 'Yes' : 'No',
        'PRODUCT_NAME': selectedProduct?.productName ?? '',
        'COMPETITOR_PRODUCT': fields['COMPETITOR_PRODUCT']!.text.trim(),
        'PRODUCT_CODE': selectedProduct?.productCode?.toString() ?? '',
      });

      final response = await dio.Dio().post(
        '${ApiConstant.baseUrl}/api/Kpi/AddRetailerDistributorEntry',
        data: formData,
        options: dio.Options(
          headers: {'accept': '*/*', 'Content-Type': 'multipart/form-data'},
        ),
      );

      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        await showDialog<void>(
          context: context,
          builder: (dialogContext) => AlertDialog(
            title: const Text('Success'),
            content: const Text(
              'Retailer / distributor visit entry saved successfully.',
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
      visitTypeDropdown(
        onChanged: (_) {
          setState(() {
            selectedContactPerson = null;
            fields['CONTACT_PERSON']!.clear();
            fields['MOBILE_NO']!.clear();
          });
          contactPersonDropdownKey.currentState?.didChange(null);
        },
      ),
      contactPersonDropdown(),
      if (selectedContactPerson != null)
        textField(
          'MOBILE_NO',
          'Mobile Number',
          limit: 10,
          required: true,
          readOnly: true,
        ),
      orderTakenDropdown(),
      if (orderTaken)
        textField('ORDER_VALUE', 'Order Value', limit: 19, required: true),
      textField(
        'STOCK_AVAILABLE',
        'Stock Available',
        limit: 250,
        required: true,
      ),
      productDropdown(required: true),
      textField(
        'PRODUCT_DISCUSSED',
        'Product Discussed',
        limit: 500,
        required: true,
      ),
      otherProductDiscussDropdown(),
      textField(
        'COMPETITOR_PRODUCT',
        'Competitor Product',
        limit: 500,
        required: true,
      ),
      textField(
        'SCHEME_DISCUSSED',
        'Scheme Discussed',
        limit: 500,
        required: true,
      ),
      textField(
        'MARKET_FEEDBACK',
        'Market Feedback',
        limit: 1000,
        lines: 3,
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

class _ContactPerson {
  const _ContactPerson({
    required this.id,
    required this.name,
    required this.mobileNo,
    required this.visitType,
  });

  final String id;
  final String name;
  final String mobileNo;
  final int visitType;

  factory _ContactPerson.fromJson(
    Map<String, dynamic> json, {
    required int fallbackVisitType,
  }) => _ContactPerson(
    id: json['retaiL_DIST_ID']?.toString() ?? '',
    name: json['retaileR_NAME']?.toString().trim() ?? '',
    mobileNo: json['mobilE_NO']?.toString() ?? '',
    visitType:
        int.tryParse(json['visiT_TYPE']?.toString() ?? '') ?? fallbackVisitType,
  );
}
