import 'dart:io';

import 'package:aeon_hrms/constant.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:aeon_hrms/Screens/KPI%20Management/Demo%20Plan/controller/DemoPlanController.dart';
import 'package:aeon_hrms/Screens/KPI%20Management/Demo%20Plan/model/DistrictMasterModel.dart';
import 'package:aeon_hrms/Screens/KPI%20Management/Demo%20Plan/model/ProductMasterListModel.dart';
import 'package:aeon_hrms/Screens/KPI%20Management/Demo%20Plan/model/StateMasterModel.dart';
import 'package:aeon_hrms/Screens/KPI%20Management/Demo%20Plan/model/TehsilListModel.dart';
import 'package:aeon_hrms/Screens/KPI%20Management/Demo%20Plan/model/VillageListModel.dart';
import 'package:aeon_hrms/Screens/KPI%20Management/Organised%20Farmer/model/CropMastModel.dart';

abstract class ContactEntryFormState<T extends StatefulWidget>
    extends State<T> {
  final formKey = GlobalKey<FormState>();
  final demoPlanController = Get.put(DemoPlanController());
  final fields = <String, TextEditingController>{
    for (final key in [
      'FARMER_NAME',
      'CONTACT_TYPE',
      'PURPOSE',
      'ACREAGE',
      'PRODUCT_DISCUSSED',
      'OTHER_PRODUCT_DISCUSS_NAME',
      'FARMER_INTEREST',
      'REMARKS',
      'ADDRESS',
      'VISIT_TYPE',
      'CONTACT_PERSON',
      'MOBILE_NO',
      'CUSTOMER_ID',
      'UPLOAD_FILE',
      'ORDER_VALUE',
      'STOCK_AVAILABLE',
      'COMPETITOR_PRODUCT',
      'SCHEME_DISCUSSED',
      'MARKET_FEEDBACK',
      'PINCODE',
    ])
      key: TextEditingController(),
  };
  final entryDate = DateTime.now();
  final Set<ProductData> selectedOtherDiscussProducts = {};
  String? selectedVisitType;
  DateTime? followUpDate;
  XFile? photo;
  Position? position;
  bool orderTaken = false;
  bool locating = false;
  bool pickingPhoto = false;
  bool saving = false;

  @override
  void initState() {
    super.initState();
    demoPlanController.getAllProductList();
    demoPlanController.GetAllCropList();
    demoPlanController.GetStateListByEmpCode();
  }

  @override
  void dispose() {
    for (final field in fields.values) {
      field.dispose();
    }
    super.dispose();
  }

  InputDecoration fieldDecoration(
    String label, {
    String? hint,
    Widget? suffix,
  }) => InputDecoration(
    labelText: label,
    hintText: hint ?? label,
    floatingLabelBehavior: FloatingLabelBehavior.always,
    alignLabelWithHint: true,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
    suffixIcon: suffix,
  );

  Widget textField(
    String key,
    String label, {
    int? limit,
    int lines = 1,
    bool required = false,
  }) => Padding(
    padding: const EdgeInsets.only(bottom: 24),
    child: TextFormField(
      key: ValueKey('contact-form-$key'),
      controller: fields[key],
      decoration: fieldDecoration(label),
      keyboardType: key == 'ORDER_VALUE'
          ? const TextInputType.numberWithOptions(decimal: true)
          : key == 'MOBILE_NO' || key == 'CUSTOMER_ID'
          ? TextInputType.phone
          : key == "STOCK_AVAILABLE"
          ? TextInputType.number
          : null,
      maxLines: lines,
      maxLength: limit,
      buildCounter: (
        context, {
        required currentLength,
        required isFocused,
        maxLength,
      }) => null,
      validator: (value) => required && (value?.trim().isEmpty ?? true)
          ? 'This field is required'
          : key == 'CUSTOMER_ID' &&
                (value?.trim().isNotEmpty ?? false) &&
                !RegExp(r'^\d+$').hasMatch(value!.trim())
          ? 'Enter a numeric customer ID'
          : key == 'ORDER_VALUE' &&
                (value?.trim().isNotEmpty ?? false) &&
                !RegExp(r'^\d{1,16}(\.\d{1,2})?$').hasMatch(value!.trim())
          ? 'Enter up to 16 digits and 2 decimal places'
          : limit != null && (value?.length ?? 0) > limit
          ? 'Maximum $limit characters allowed'
          : null,
    ),
  );

  Widget masterDropdown<T>({
    required String label,
    required List<T> Function() values,
    required Rx<T?> selected,
    required String? Function(T) itemLabel,
    required ValueChanged<T?> onChanged,
  }) => Padding(
    padding: const EdgeInsets.only(bottom: 24),
    child: Obx(() {
      final options = values();
      return DropdownButtonFormField<T>(
        key: ValueKey('master-field-$label'),
        initialValue: selected.value,
        decoration: fieldDecoration(label),
        isExpanded: true,
        items: [
          DropdownMenuItem<T>(
            value: null,
            child: Text(
              'Select $label',
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          ...options.map(
            (option) => DropdownMenuItem<T>(
              value: option,
              child: Text(itemLabel(option) ?? 'Unknown'),
            ),
          ),
        ],
        onChanged: onChanged,
      );
    }),
  );

  Widget productDropdown() => masterDropdown<ProductData>(
    label: 'Product Name',
    values: () => demoPlanController.productList,
    selected: demoPlanController.productselectedValue,
    itemLabel: (product) => product.productName,
    onChanged: (value) => demoPlanController.productselectedValue.value = value,
  );

  Widget cropDropdown() => masterDropdown<CropMast>(
    label: 'Crop',
    values: () => demoPlanController.cropList,
    selected: demoPlanController.selectedCrop,
    itemLabel: (crop) => crop.croPNAME,
    onChanged: (value) => demoPlanController.selectedCrop.value = value,
  );

  Widget stateDropdown() => masterDropdown<StateData>(
    label: 'State',
    values: () => demoPlanController.stateList,
    selected: demoPlanController.selectedState,
    itemLabel: (state) => state.statENAME,
    onChanged: (value) {
      demoPlanController.selectedState.value = value;
      demoPlanController.selectedDistrict.value = null;
      demoPlanController.selectedTehsil.value = null;
      demoPlanController.selectedvillage.value = null;
      demoPlanController.districtList.clear();
      demoPlanController.tehsilList.clear();
      demoPlanController.villageList.clear();
      fields['PINCODE']!.clear();
      if (value != null) {
        demoPlanController.GetDistrictListByStateCodeandEmpCode(
          value.statECODE,
        );
      }
    },
  );

  Widget districtDropdown() => masterDropdown<DistrictData>(
    label: 'District',
    values: () => demoPlanController.districtList,
    selected: demoPlanController.selectedDistrict,
    itemLabel: (district) => district.districTNAME,
    onChanged: (value) {
      demoPlanController.selectedDistrict.value = value;
      demoPlanController.selectedTehsil.value = null;
      demoPlanController.selectedvillage.value = null;
      demoPlanController.tehsilList.clear();
      demoPlanController.villageList.clear();
      fields['PINCODE']!.clear();
      if (value != null) {
        demoPlanController.GetTehsilListByDistrictCodeandEmpCode(
          value.districTCODE,
        );
      }
    },
  );

  Widget tehsilDropdown() => masterDropdown<TehsilData>(
    label: 'Tehsil',
    values: () => demoPlanController.tehsilList,
    selected: demoPlanController.selectedTehsil,
    itemLabel: (tehsil) => tehsil.tehsiLNAME,
    onChanged: (value) {
      demoPlanController.selectedTehsil.value = value;
      demoPlanController.selectedvillage.value = null;
      demoPlanController.villageList.clear();
      fields['PINCODE']!.clear();
      if (value != null) {
        demoPlanController.getVillageListByTehsilCode(value.tehsiLCODE);
      }
    },
  );

  Widget villageDropdown() => masterDropdown<VillageData>(
    label: 'Village',
    values: () => demoPlanController.villageList,
    selected: demoPlanController.selectedvillage,
    itemLabel: (village) => village.villagENAME,
    onChanged: (value) {
      demoPlanController.selectedvillage.value = value;
      fields['PINCODE']!.text = value?.piNCODE?.toString() ?? '';
    },
  );

  Widget visitTypeDropdown() => Padding(
    padding: const EdgeInsets.only(bottom: 24),
    child: DropdownButtonFormField<String>(
      key: const ValueKey('visit-type-dropdown'),
      initialValue: selectedVisitType,
      decoration: fieldDecoration('Visit Type'),
      isExpanded: true,
      validator: (value) => value == null ? 'Select a visit type' : null,
      items: const [
        DropdownMenuItem(value: 'Retailer', child: Text('Retailer')),
        DropdownMenuItem(value: 'Distributor', child: Text('Distributor')),
      ],
      onChanged: (value) => setState(() {
        selectedVisitType = value;
        fields['VISIT_TYPE']!.text = value ?? '';
      }),
    ),
  );

  Widget orderTakenDropdown() => Padding(
    padding: const EdgeInsets.only(bottom: 24),
    child: DropdownButtonFormField<bool>(
      key: const ValueKey('order-taken-dropdown'),
      initialValue: orderTaken,
      decoration: fieldDecoration('Order Taken'),
      items: const [
        DropdownMenuItem(value: false, child: Text('No')),
        DropdownMenuItem(value: true, child: Text('Yes')),
      ],
      onChanged: (value) => setState(() => orderTaken = value ?? false),
    ),
  );

  Widget otherProductDiscussDropdown() => Padding(
    padding: const EdgeInsets.only(bottom: 24),
    child: InkWell(
      key: const ValueKey('other-product-discuss-picker'),
      onTap: selectOtherDiscussProducts,
      child: InputDecorator(
        decoration: fieldDecoration(
          'Other Product Discuss Name',
          suffix: const Icon(Icons.arrow_drop_down),
        ),
        child: Text(
          key: const ValueKey('other-product-discuss-summary'),
          fields['OTHER_PRODUCT_DISCUSS_NAME']!.text.isEmpty
              ? 'Select products'
              : fields['OTHER_PRODUCT_DISCUSS_NAME']!.text,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ),
  );

  Future<void> selectOtherDiscussProducts() async {
    final products = demoPlanController.productList
        .where((product) => product.productName?.trim().isNotEmpty ?? false)
        .toList();
    final selectedProducts = Set<ProductData>.from(
      selectedOtherDiscussProducts,
    );
    var searchQuery = '';

    final selection = await showModalBottomSheet<Set<ProductData>>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => StatefulBuilder(
        builder: (context, setSheetState) {
          final filteredProducts = products.where((product) {
            final name = product.productName!.toLowerCase();
            return name.contains(searchQuery.trim().toLowerCase());
          }).toList();

          return Material(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
            clipBehavior: Clip.antiAlias,
            child: SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.78,
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  Container(
                    width: 38,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Other Product Discuss Name',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                        ),
                        Text(
                          '${selectedProducts.length} selected',
                          style: TextStyle(color: kMainColor),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      key: const ValueKey('other-product-search'),
                      decoration: InputDecoration(
                        hintText: 'Search products',
                        prefixIcon: const Icon(Icons.search),
                        filled: true,
                        fillColor: const Color(0xFFF3F5F4),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                        ),
                      ),
                      onChanged: (value) => setSheetState(() {
                        searchQuery = value;
                      }),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: filteredProducts.isEmpty
                        ? Center(
                            child: Text(
                              products.isEmpty
                                  ? 'No products available'
                                  : 'No matching products',
                              style: const TextStyle(color: Colors.black54),
                            ),
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            itemCount: filteredProducts.length,
                            separatorBuilder: (_, __) =>
                                const Divider(height: 1, indent: 56),
                            itemBuilder: (context, index) {
                              final product = filteredProducts[index];
                              final isSelected = selectedProducts.contains(
                                product,
                              );
                              return CheckboxListTile(
                                key: ValueKey(
                                  'other-product-option-${product.productCode}',
                                ),
                                value: isSelected,
                                activeColor: kMainColor,
                                controlAffinity:
                                    ListTileControlAffinity.trailing,
                                title: Text(product.productName!),
                                onChanged: (selected) => setSheetState(() {
                                  if (selected ?? false) {
                                    selectedProducts.add(product);
                                  } else {
                                    selectedProducts.remove(product);
                                  }
                                }),
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
                          onPressed: () =>
                              setSheetState(selectedProducts.clear),
                          child: const Text('Clear'),
                        ),
                        const Spacer(),
                        FilledButton(
                          key: const ValueKey('other-product-discuss-done'),
                          style: FilledButton.styleFrom(
                            backgroundColor: kMainColor,
                            minimumSize: const Size(120, 46),
                          ),
                          onPressed: () => Navigator.pop(
                            sheetContext,
                            Set<ProductData>.from(selectedProducts),
                          ),
                          child: const Text('Done'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );

    if (selection != null && mounted) {
      final names = selection
          .map((product) => product.productName!.trim())
          .toList();
      setState(() {
        selectedOtherDiscussProducts
          ..clear()
          ..addAll(selection);
        fields['OTHER_PRODUCT_DISCUSS_NAME']!.text = names.join(', ');
      });
    }
  }

  Widget followUpDateField() => Padding(
    padding: const EdgeInsets.only(bottom: 24),
    child: InkWell(
      onTap: selectFollowUpDate,
      child: InputDecorator(
        decoration: fieldDecoration(
          'Follow-up Date',
          suffix: followUpDate == null
              ? const Icon(Icons.calendar_today_outlined)
              : IconButton(
                  tooltip: 'Clear follow-up date',
                  icon: const Icon(Icons.clear),
                  onPressed: () => setState(() => followUpDate = null),
                ),
        ),
        child: Text(
          followUpDate == null
              ? 'Select Follow-up Date'
              : DateFormat('dd/MM/yyyy').format(followUpDate!),
        ),
      ),
    ),
  );

  Future<void> selectFollowUpDate() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: followUpDate ?? DateUtils.dateOnly(entryDate),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (selected != null && mounted) setState(() => followUpDate = selected);
  }

  Widget photoUploadField() => InputDecorator(
    decoration: fieldDecoration('Upload Photo'),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (photo != null) ...[
          Image.file(
            File(photo!.path),
            height: 160,
            width: double.infinity,
            fit: BoxFit.contain,
          ),
          TextButton(
            onPressed: () => setState(() => photo = null),
            child: const Text('Remove Photo'),
          ),
        ],
        Wrap(
          spacing: 12,
          children: [
            TextButton.icon(
              onPressed: pickingPhoto
                  ? null
                  : () => pickPhoto(ImageSource.camera),
              icon: const Icon(Icons.camera_alt_outlined),
              label: const Text('Camera'),
            ),
            TextButton.icon(
              onPressed: pickingPhoto
                  ? null
                  : () => pickPhoto(ImageSource.gallery),
              icon: const Icon(Icons.photo_library_outlined),
              label: const Text('Gallery'),
            ),
          ],
        ),
      ],
    ),
  );

  Future<void> pickPhoto(ImageSource source) async {
    setState(() => pickingPhoto = true);
    try {
      final selected = await ImagePicker().pickImage(
        source: source,
        imageQuality: 85,
      );
      if (selected != null && mounted) setState(() => photo = selected);
    } catch (_) {
      showMessage(
        'Unable to open the camera or gallery. Check photo permissions.',
      );
    } finally {
      if (mounted) setState(() => pickingPhoto = false);
    }
  }

  Widget locationCaptureButton() => OutlinedButton.icon(
    onPressed: locating ? null : captureLocation,
    icon: const Icon(Icons.my_location),
    label: Text(locating ? 'Getting Location...' : 'Capture Current Location'),
  );

  Widget locationReadout() => InputDecorator(
    decoration: fieldDecoration('Latitude / Longitude'),
    child: Text(
      position == null
          ? 'Location not captured'
          : '${position!.latitude.toStringAsFixed(7)}, ${position!.longitude.toStringAsFixed(7)}',
    ),
  );

  Future<void> captureLocation() async {
    setState(() => locating = true);
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        showMessage('Please turn on location services and try again.');
        return;
      }
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        showMessage(
          'Location permission is needed. Enable it in app settings.',
        );
        return;
      }
      final currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 20),
      );
      if (!mounted) return;
      setState(() => position = currentPosition);
      try {
        final places = await placemarkFromCoordinates(
          currentPosition.latitude,
          currentPosition.longitude,
        );
        if (!mounted) return;
        if (places.isNotEmpty && fields['ADDRESS']!.text.trim().isEmpty) {
          final place = places.first;
          fields['ADDRESS']!.text =
              [
                    place.street,
                    place.subLocality,
                    place.locality,
                    place.administrativeArea,
                    place.postalCode,
                    place.country,
                  ]
                  .whereType<String>()
                  .where((part) => part.trim().isNotEmpty)
                  .toSet()
                  .join(', ');
        }
      } catch (_) {
        showMessage('GPS captured. Please enter the address manually.');
      }
    } catch (_) {
      showMessage('Unable to get location. Please try again.');
    } finally {
      if (mounted) setState(() => locating = false);
    }
  }

  void showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> saveEntry() async {
    if (!formKey.currentState!.validate()) return;
    showMessage(
      'Save is not available yet. Your entry has not been submitted.',
    );
  }

  Widget buildContactEntryForm({
    required String title,
    required List<Widget> fields,
  }) => Scaffold(
    backgroundColor: kMainColor,
    appBar: AppBar(
      backgroundColor: kMainColor,
      foregroundColor: Colors.white,
      elevation: 0,
      titleSpacing: 0,
      title: Text(title, style: const TextStyle(fontSize: 21)),
    ),
    body: Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: SafeArea(
          top: false,
          child: Form(
            key: formKey,
            child: ListView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.fromLTRB(20, 32, 20, 24),
              children: [
                ...fields,
                const Text(
                  'Saving will be available once the server connection is configured.',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 12),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: kMainColor,
                    minimumSize: const Size.fromHeight(50),
                  ),
                  onPressed: saving ? null : saveEntry,
                  child: saving
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Save'),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
