import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:aeon_hrms/Screens/KPI%20Management/Demo%20Plan/model/ProductMasterListModel.dart';
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
  final Map<ProductData, int> selectedOrderProducts = {};
  final Map<String, TextEditingController> orderValueControllers = {};
  final Map<String, TextEditingController> stockAvailableControllers = {};
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
    for (final controller in orderValueControllers.values) {
      controller.dispose();
    }
    for (final controller in stockAvailableControllers.values) {
      controller.dispose();
    }
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

  Widget orderProductsField() => FormField<Map<ProductData, int>>(
    initialValue: selectedOrderProducts,
    validator: (value) =>
        value == null || value.isEmpty ? 'Select at least one product' : null,
    builder: (field) => Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: InkWell(
        key: const ValueKey('order-products-picker'),
        onTap: () async {
          final products = demoPlanController.productList
              .where(
                (product) => product.productName?.trim().isNotEmpty ?? false,
              )
              .toList();
          final selection = Map<ProductData, int>.from(selectedOrderProducts);
          final result = await showModalBottomSheet<Map<ProductData, int>>(
            context: context,
            isScrollControlled: true,
            useSafeArea: true,
            backgroundColor: Colors.white,
            builder: (sheetContext) => StatefulBuilder(
              builder: (context, setSheetState) => SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.78,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                      child: Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'Product Name',
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                          ),
                          Text('${selection.length} selected'),
                        ],
                      ),
                    ),
                    Expanded(
                      child: products.isEmpty
                          ? const Center(child: Text('No products available'))
                          : ListView.separated(
                              itemCount: products.length,
                              separatorBuilder: (context, index) =>
                                  const Divider(height: 1),
                              itemBuilder: (context, index) {
                                final product = products[index];
                                final productId =
                                    product.productCode?.toString() ??
                                    product.productName!;
                                final isSelected = selection.containsKey(
                                  product,
                                );
                                void updateSelection(bool? checked) {
                                  setSheetState(() {
                                    if (checked ?? false) {
                                      selection[product] = 1;
                                    } else {
                                      selection.remove(product);
                                    }
                                  });
                                }

                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: InkWell(
                                              onTap: () =>
                                                  updateSelection(!isSelected),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      vertical: 12,
                                                    ),
                                                child: Text(
                                                  product.productName!,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Checkbox(
                                            activeColor: const Color(
                                              0xFF567DF4,
                                            ),
                                            key: ValueKey(
                                              'order-product-${product.productCode}',
                                            ),
                                            value: isSelected,
                                            onChanged: updateSelection,
                                          ),
                                        ],
                                      ),
                                      if (isSelected)
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            bottom: 8,
                                          ),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: TextField(
                                                  key: ValueKey(
                                                    'order-product-$productId-available-stock',
                                                  ),
                                                  controller:
                                                      stockAvailableControllers
                                                          .putIfAbsent(
                                                            productId,
                                                            () =>
                                                                TextEditingController(),
                                                          ),
                                                  keyboardType:
                                                      const TextInputType.numberWithOptions(
                                                        decimal: true,
                                                      ),
                                                  decoration:
                                                      const InputDecoration(
                                                        labelText:
                                                            'Available Stock',
                                                        isDense: true,
                                                        border:
                                                            OutlineInputBorder(),
                                                      ),
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Expanded(
                                                child: TextField(
                                                  key: ValueKey(
                                                    'order-product-$productId-order-value',
                                                  ),
                                                  controller: orderValueControllers
                                                      .putIfAbsent(
                                                        productId,
                                                        () =>
                                                            TextEditingController(),
                                                      ),
                                                  keyboardType:
                                                      const TextInputType.numberWithOptions(
                                                        decimal: true,
                                                      ),
                                                  decoration:
                                                      const InputDecoration(
                                                        labelText: 'Order Value(In lakhs)',
                                                        isDense: true,
                                                        border:
                                                            OutlineInputBorder(),
                                                      ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                    ],
                                  ),
                                );
                              },
                            ),
                    ),
                    const Divider(height: 1),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
                      child: Row(
                        children: [
                          TextButton(
                            onPressed: () => setSheetState(selection.clear),
                            child: const Text('Clear'),
                          ),
                          const Spacer(),
                          FilledButton(
                            style: FilledButton.styleFrom(
                              backgroundColor: const Color(0xFF567DF4),
                            ),
                            onPressed: () => Navigator.pop(
                              sheetContext,
                              Map<ProductData, int>.from(selection),
                            ),
                            child: const Text('Done'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
          if (result != null && mounted) {
            setState(() {
              selectedOrderProducts
                ..clear()
                ..addAll(result);
            });
            field.didChange(Map<ProductData, int>.from(result));
          }
        },
        child: InputDecorator(
          decoration: fieldDecoration('Product Name').copyWith(
            suffixIcon: const Icon(Icons.arrow_drop_down),
            errorText: field.errorText,
          ),
          child: Text(
            key: const ValueKey('order-products-summary'),
            selectedOrderProducts.isEmpty
                ? 'Select products'
                : selectedOrderProducts.entries
                      .map((entry) => entry.key.productName!)
                      .join(', '),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    ),
  );

  @override
  Future<void> saveEntry() async {
    if (saving || !formKey.currentState!.validate()) return;
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
    setState(() => saving = true);

    try {
      final selectedOrderProductsList = selectedOrderProducts.entries.toList();
      final orderProductNames = selectedOrderProductsList
          .map((entry) => entry.key.productName)
          .whereType<String>()
          .join(',');
      final orderProductCodes = selectedOrderProductsList
          .map((entry) => entry.key.productCode?.toString())
          .whereType<String>()
          .join(',');
      final orderProductQuantities = selectedOrderProductsList
          .map((_) => '1')
          .join(',');
      final orderValues = selectedOrderProductsList
          .map(
            (entry) =>
                orderValueControllers[entry.key.productCode?.toString() ??
                        entry.key.productName!]
                    ?.text
                    .trim() ??
                '',
          )
          .join(',');
      final stockAvailableValues = selectedOrderProductsList
          .map(
            (entry) =>
                stockAvailableControllers[entry.key.productCode?.toString() ??
                        entry.key.productName!]
                    ?.text
                    .trim() ??
                '',
          )
          .join(',');
      final productDetailsJson = jsonEncode(
        selectedOrderProductsList.map((entry) {
          final productId =
              entry.key.productCode?.toString() ?? entry.key.productName!;

          return {
            'PRODUCT_CODE': entry.key.productCode,
            'STOCK_AVAILABLE': int.tryParse(
              stockAvailableControllers[productId]?.text.trim() ?? '',
            ),
            'ORDER_VALUE': num.tryParse(
              orderValueControllers[productId]?.text.trim() ?? '',
            ),
          };
        }).toList(),
      );
      final image = photo;
      final formData = dio.FormData.fromMap({
        'STOCK_AVAILABLE': orderTaken ? stockAvailableValues : '',
        'ORDER_VALUE': orderTaken ? orderValues : '0',
        'PRODUCT_DETAILS': orderTaken ? productDetailsJson : '[]',
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
        'PRODUCT_NAME': orderTaken ? orderProductNames : '',
        'COMPETITOR_PRODUCT': fields['COMPETITOR_PRODUCT']!.text.trim(),
        'PRODUCT_CODE': orderTaken ? orderProductCodes : '',
        'PRODUCT_QUANTITY': orderTaken ? orderProductQuantities : '',
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
      if (orderTaken) ...[orderProductsField()],
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
