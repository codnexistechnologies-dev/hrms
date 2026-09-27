import 'dart:async';

import 'package:dio/dio.dart' as dio;
import 'package:aeon_hrms/Screens/KPI%20Management/Collection%20Plan/controller/CollectionPlanController.dart';
import 'package:aeon_hrms/Screens/KPI%20Management/LiquidationPlan/controller/LiquidationPlanController.dart';
import 'package:aeon_hrms/Utility/api_constants.dart';
import 'package:aeon_hrms/Utility/utility_function.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:aeon_hrms/GlobalComponents/button_global.dart';
import 'package:aeon_hrms/constant.dart';
import 'package:nb_utils/nb_utils.dart';

class AddCollectionPlan extends StatefulWidget {
  const AddCollectionPlan({super.key});

  @override
  _AddCollectionPlanState createState() => _AddCollectionPlanState();
}

class _AddCollectionPlanState extends State<AddCollectionPlan> {
  final liquidationPlanController = Get.put(
    LiquidationPlanController(),
    permanent: true,
  );
  final collectionPlanController = Get.put(
    CollectionPlanController(),
    permanent: true,
  );
  final TextEditingController txt_Atdate = TextEditingController();
  final TextEditingController txt_Target = TextEditingController();
  final TextEditingController txt_Achieved = TextEditingController();
  final TextEditingController txt_Remarks = TextEditingController();
  final TextEditingController txtMobileNo = TextEditingController();
  final contactLoadCancelToken = dio.CancelToken();
  final contactPersonDropdownKey =
      GlobalKey<FormFieldState<_CollectionPlanContactPerson>>();
  List<_CollectionPlanContactPerson> contactPeople = [];
  _CollectionPlanContactPerson? selectedContactPerson;
  String? selectedVisitType;
  bool loadingContactPeople = true;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    String currentDate = DateTime.now().toString().substring(0, 10);
    liquidationPlanController.GetKpiMasterByUseridandPaydate(currentDate);
    txt_Atdate.text = currentDate;
    unawaited(loadContactPeople());
  }

  @override
  void dispose() {
    contactLoadCancelToken.cancel('Collection plan form closed.');
    txt_Atdate.dispose();
    txt_Target.dispose();
    txt_Achieved.dispose();
    txt_Remarks.dispose();
    txtMobileNo.dispose();
    Get.delete<LiquidationPlanController>();
    Get.delete<CollectionPlanController>();
    super.dispose();
  }

  Future<List<_CollectionPlanContactPerson>> fetchContactPeople(
    int visitTypeCode,
  ) async {
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
          (item) => _CollectionPlanContactPerson.fromJson(
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
      if (!mounted) return;
      setState(() {
        contactPeople = peopleByType.expand((people) => people).toList();
        loadingContactPeople = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => loadingContactPeople = false);
      debugPrint('Failed to load contact persons: $error');
    }
  }

  List<_CollectionPlanContactPerson> get visibleContactPeople {
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

  Widget visitTypeDropdown() => Padding(
    padding: const EdgeInsets.only(bottom: 20),
    child: DropdownButtonFormField<String>(
      initialValue: selectedVisitType,
      decoration: const InputDecoration(
        labelText: 'Visit Type',
        hintText: 'Select Visit Type',
        floatingLabelBehavior: FloatingLabelBehavior.always,
        border: OutlineInputBorder(),
      ),
      isExpanded: true,
      items: const [
        DropdownMenuItem(value: 'Retailer', child: Text('Retailer')),
        DropdownMenuItem(value: 'Distributor', child: Text('Distributor')),
      ],
      onChanged: (value) {
        setState(() {
          selectedVisitType = value;
          selectedContactPerson = null;
          txtMobileNo.clear();
        });
        contactPersonDropdownKey.currentState?.didChange(null);
      },
    ),
  );

  Widget contactPersonDropdown() => Padding(
    padding: const EdgeInsets.only(bottom: 20),
    child: DropdownButtonFormField<_CollectionPlanContactPerson>(
      key: contactPersonDropdownKey,
      initialValue: selectedContactPerson,
      decoration: InputDecoration(
        labelText: 'Contact Person',
        hintText: selectedVisitType == null
            ? 'Select Visit Type First'
            : 'Select Contact Person',
        floatingLabelBehavior: FloatingLabelBehavior.always,
        border: const OutlineInputBorder(),
        suffixIcon: loadingContactPeople
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
              txtMobileNo.text = value?.mobileNo ?? '';
            }),
    ),
  );

  bool isLoading = false;
  Future<void> saveCollectionPlanData() async {
    if (txt_Achieved.text == "") {
      Utility.alertInfo(context, data: "Achieved Can't be blank.");
      return;
    } else {
      Map<String, dynamic> result = await collectionPlanController
          .saveCollectionPlan(
            context,
            int.parse(txt_Achieved.text),
            txt_Remarks.text,
            selectedVisitType ?? '',
            selectedContactPerson?.id ?? '',
          );
      if (result['status'] == 200) {
        // Check for success (status code 200)
        Utility.alertSucess(context, data: result['message']);
        crearData();
      } else {
        Utility.alertInfo(context, data: result['message']);
      }
    }
  }

  void crearData() {
    txt_Achieved.clear();
    txt_Remarks.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kMainColor,
      appBar: AppBar(
        backgroundColor: kMainColor,
        elevation: 0.0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'Add Collection Plan',
          style: kTextStyle.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Obx(() {
          //child: GetBuilder(builder: (LiquidationPlanController controller) {
          return liquidationPlanController.isKpiMasterLoading.value == true
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 20.0),
                    Container(
                      height: MediaQuery.of(context).size.height,
                      padding: const EdgeInsets.all(20.0),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30.0),
                          topRight: Radius.circular(30.0),
                        ),
                        color: Colors.white,
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            const SizedBox(height: 20.0),
                            SizedBox(
                              child: AppTextField(
                                controller: txt_Atdate,
                                textFieldType: TextFieldType.NAME,
                                decoration: const InputDecoration(
                                  labelText: "Atdate",
                                  enabled: false,
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  hintText: "Atdate",
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20.0),
                            visitTypeDropdown(),
                            contactPersonDropdown(),
                            if (selectedContactPerson != null)
                              SizedBox(
                                height: 50,
                                child: AppTextField(
                                  controller: txtMobileNo,
                                  textFieldType: TextFieldType.PHONE,
                                  decoration: const InputDecoration(
                                    labelText: 'Mobile Number',
                                    enabled: false,
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                            if (selectedContactPerson != null)
                              const SizedBox(height: 20.0),
                            const SizedBox(height: 20.0),
                            SizedBox(
                              child: AppTextField(
                                controller: txt_Target
                                  ..text =
                                      liquidationPlanController
                                          .kpimasterList
                                          .isNotEmpty
                                      ? (liquidationPlanController
                                                    .kpimasterList
                                                    .first
                                                    .collectioNPLAN ??
                                                0)
                                            .toString()
                                      : "0",
                                textFieldType: TextFieldType.NAME,
                                decoration: const InputDecoration(
                                  labelText: "Target",
                                  enabled: false,
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  hintText: "Target",
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20.0),
                            SizedBox(
                              height: 50,
                              child: AppTextField(
                                controller: txt_Achieved,
                                textFieldType: TextFieldType.NUMBER,
                                decoration: const InputDecoration(
                                  labelText: "Achieved",
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  hintText: "Achieved",
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20.0),
                            AppTextField(
                              controller: txt_Remarks,
                              textFieldType: TextFieldType.MULTILINE,
                              decoration: const InputDecoration(
                                labelText: 'Remarks',
                                enabled: true,
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                border: OutlineInputBorder(),
                              ),
                            ),
                            //const Spacer(),
                            const SizedBox(height: 40.0),
                            Center(
                              child: Obx(
                                () => ButtonGlobal(
                                  buttontext:
                                      collectionPlanController
                                          .isSaveCollectionPlanLoding
                                          .value
                                      ? "Processing"
                                      : 'Save',
                                  buttonDecoration: kButtonDecoration.copyWith(
                                    color: kMainColor,
                                  ),
                                  onPressed: () {
                                    if (!collectionPlanController
                                        .isSaveCollectionPlanLoding
                                        .value) {
                                      saveCollectionPlanData();
                                    }
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 20.0),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
        }),
      ),
    );
  }
}

class _CollectionPlanContactPerson {
  const _CollectionPlanContactPerson({
    required this.id,
    required this.name,
    required this.mobileNo,
    required this.visitType,
  });

  final String id;
  final String name;
  final String mobileNo;
  final int visitType;

  factory _CollectionPlanContactPerson.fromJson(
    Map<String, dynamic> json, {
    required int fallbackVisitType,
  }) => _CollectionPlanContactPerson(
    id: json['retaiL_DIST_ID']?.toString() ?? '',
    name: json['retaileR_NAME']?.toString().trim() ?? '',
    mobileNo: json['mobilE_NO']?.toString() ?? '',
    visitType:
        int.tryParse(json['visiT_TYPE']?.toString() ?? '') ?? fallbackVisitType,
  );
}
