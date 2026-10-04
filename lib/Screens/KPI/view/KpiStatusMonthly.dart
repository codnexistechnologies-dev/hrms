import 'package:aeon_hrms/Screens/KPI%20Management/Collection%20Plan/controller/CollectionPlanController.dart';
import 'package:aeon_hrms/Screens/KPI%20Management/Demo%20Plan/controller/DemoPlanController.dart';
import 'package:aeon_hrms/Screens/KPI%20Management/Farmer%20Connectivity%20Entry/controller/FarmerConnectivityEntryController.dart';
import 'package:aeon_hrms/Screens/KPI%20Management/FieldDays/controller/FieldDaysController.dart';
import 'package:aeon_hrms/Screens/KPI%20Management/LiquidationPlan/controller/LiquidationPlanController.dart';
import 'package:aeon_hrms/Screens/KPI%20Management/Organised%20Farmer/controller/OrganisedFarmerMeetingController.dart';
import 'package:aeon_hrms/Screens/KPI%20Management/Unorganised%20Farmer/controller/UnorganizedFarmarMeeting.dart';
import 'package:date_format/date_format.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:aeon_hrms/constant.dart';

import 'package:nb_utils/nb_utils.dart';

class KpiStatusMonthly extends StatefulWidget {
  const KpiStatusMonthly({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _KpiStatusMonthlyState createState() => _KpiStatusMonthlyState();
}

class _KpiStatusMonthlyState extends State<KpiStatusMonthly> {
  // String type = '';
  bool selection = false;
  final liquidationPlanController = Get.put(
    LiquidationPlanController(),
    permanent: true,
  );
  final demoPlanController = Get.put(DemoPlanController(), permanent: true);
  final collectionPlanController = Get.put(
    CollectionPlanController(),
    permanent: true,
  );
  final farmerConnectivityController = Get.put(
    FarmerConnectivityEntryController(),
    permanent: true,
  );
  final fieldDaysController = Get.put(FieldDaysController(), permanent: true);
  final organisedFarmerMeetingController = Get.put(
    OrganisedFarmerMeetingController(),
    permanent: true,
  );
  final unorganizedFarmerMeetingController = Get.put(
    UnorganizedFarmerMeetingController(),
    permanent: true,
  );
  final TextEditingController txt_DemoPlanTarget = TextEditingController();
  final TextEditingController txt_DemoPlanAchieved = TextEditingController();
  final TextEditingController txt_LiqPlanTarget = TextEditingController();
  final TextEditingController txt_LiqPlanAchieved = TextEditingController();
  final TextEditingController txt_CollPlanTarget = TextEditingController();
  final TextEditingController txt_CollPlanAchieved = TextEditingController();
  final TextEditingController txt_OrgMeetingTarget = TextEditingController();
  final TextEditingController txt_OrgMeetingAchieved = TextEditingController();
  final TextEditingController txt_UnorgMeetingTarget = TextEditingController();
  final TextEditingController txt_UnorgMeetingAchieved =
      TextEditingController();
  final TextEditingController txt_FieldDaysTarget = TextEditingController();
  final TextEditingController txt_farmerVisitTarget = TextEditingController();
  final TextEditingController txt_farmerVisitAchieved = TextEditingController();
  final TextEditingController txt_FieldDaysAchieved = TextEditingController();
  @override
  void dispose() {
    txt_DemoPlanTarget.dispose();
    txt_DemoPlanAchieved.dispose();
    txt_LiqPlanTarget.dispose();
    txt_LiqPlanAchieved.dispose();
    txt_CollPlanTarget.dispose();
    txt_CollPlanAchieved.dispose();
    txt_OrgMeetingTarget.dispose();
    txt_OrgMeetingAchieved.dispose();
    txt_UnorgMeetingTarget.dispose();
    txt_UnorgMeetingAchieved.dispose();
    txt_FieldDaysTarget.dispose();
    txt_FieldDaysAchieved.dispose();
    txt_farmerVisitTarget.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    GetKpiMasterData();
  }

  String? monthValue = formatDate(DateTime.now(), [MM]).toString();
  String? yearValues = formatDate(DateTime.now(), [yyyy]).toString();

  void GetKpiMasterData() {
    liquidationPlanController.GetKpiMasterByUseridandPaydate(
      "$yearValues-$monthValue-01",
    );
    demoPlanController.GetDemoPlanAchievementByUseridandPayDate(
      "$yearValues-$monthValue-01",
    );
    collectionPlanController.GetCollectionPlanAchievementByUseridandPayDate(
      "$yearValues-$monthValue-01",
    );
    liquidationPlanController.GetLiquidationPlanAchievementByUseridandPayDate(
      "$yearValues-$monthValue-01",
    );
    fieldDaysController.GetFieldDaysAchievementByUseridandPayDate(
      "$yearValues-$monthValue-01",
    );
    organisedFarmerMeetingController.GetOrganisedMeetingAchiByUseridandPayDate(
      "$yearValues-$monthValue-01",
    );
    unorganizedFarmerMeetingController.GetUnorganisedMeetingAchiByUseridandPayDate(
      "$yearValues-$monthValue-01",
    );
    unorganizedFarmerMeetingController.GetUnorganisedMeetingAchiByUseridandPayDate(
      "$yearValues-$monthValue-01",
    );
    farmerConnectivityController.getFarmerVisitAchievementByUseridandPayDate(
      "$yearValues-$monthValue-01",
    );
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
          'KPI Status',
          style: kTextStyle.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Obx(() {
          return liquidationPlanController.isKpiMasterLoading.value
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20.0),
                    Container(
                      //height: context.height(),
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: 140,
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton2<String>(
                                      isExpanded: true,
                                      hint: const Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              'Select Month',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: Color.fromARGB(
                                                  255,
                                                  128,
                                                  126,
                                                  126,
                                                ),
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                      items: monthName
                                          .map(
                                            (
                                              String item,
                                            ) => DropdownMenuItem<String>(
                                              value: item,
                                              child: Text(
                                                item,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  color: Color.fromARGB(
                                                    255,
                                                    128,
                                                    126,
                                                    126,
                                                  ),
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          )
                                          .toList(),
                                      value: monthValue,
                                      onChanged: (String? value) {
                                        setState(() {
                                          monthValue = value;
                                        });
                                        GetKpiMasterData();
                                      },
                                      buttonStyleData: ButtonStyleData(
                                        height: 50,
                                        width: double.infinity,
                                        padding: const EdgeInsets.only(
                                          left: 14,
                                          right: 14,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            5,
                                          ),
                                          border: Border.all(
                                            color: Colors.black26,
                                          ),
                                          color: Colors.white,
                                        ),
                                      ),
                                      iconStyleData: const IconStyleData(
                                        icon: Icon(
                                          Icons.arrow_forward_ios_outlined,
                                        ),
                                        iconSize: 14,
                                        iconEnabledColor: Color.fromARGB(
                                          255,
                                          128,
                                          126,
                                          126,
                                        ),
                                        iconDisabledColor: Color.fromARGB(
                                          255,
                                          179,
                                          178,
                                          178,
                                        ),
                                      ),
                                      dropdownStyleData: DropdownStyleData(
                                        maxHeight: 300,
                                        width: 140,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            5,
                                          ),
                                          border: Border.all(
                                            color: Colors.black26,
                                          ),
                                          color: Colors.white,
                                        ),
                                        offset: const Offset(0, 0),
                                        scrollbarTheme: ScrollbarThemeData(
                                          radius: const Radius.circular(40),
                                          thickness:
                                              WidgetStateProperty.all<double>(
                                                6,
                                              ),
                                          thumbVisibility:
                                              WidgetStateProperty.all<bool>(
                                                true,
                                              ),
                                        ),
                                      ),
                                      menuItemStyleData:
                                          const MenuItemStyleData(
                                            height: 40,
                                            padding: EdgeInsets.only(
                                              left: 14,
                                              right: 14,
                                            ),
                                          ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 140,
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton2<String>(
                                      isExpanded: true,
                                      hint: const Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              'Select Year',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: Color.fromARGB(
                                                  255,
                                                  128,
                                                  126,
                                                  126,
                                                ),
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                      items: yearList
                                          .map(
                                            (
                                              String item,
                                            ) => DropdownMenuItem<String>(
                                              value: item,
                                              child: Text(
                                                item,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  color: Color.fromARGB(
                                                    255,
                                                    128,
                                                    126,
                                                    126,
                                                  ),
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          )
                                          .toList(),
                                      value: yearValues,
                                      onChanged: (String? value) {
                                        setState(() {
                                          yearValues = value;
                                        });
                                        GetKpiMasterData();
                                      },
                                      buttonStyleData: ButtonStyleData(
                                        height: 50,
                                        width: 140,
                                        padding: const EdgeInsets.only(
                                          left: 14,
                                          right: 14,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            5,
                                          ),
                                          border: Border.all(
                                            color: Colors.black26,
                                          ),
                                          color: Colors.white,
                                        ),
                                      ),
                                      iconStyleData: const IconStyleData(
                                        icon: Icon(
                                          Icons.arrow_forward_ios_outlined,
                                        ),
                                        iconSize: 14,
                                        iconEnabledColor: Color.fromARGB(
                                          255,
                                          128,
                                          126,
                                          126,
                                        ),
                                        iconDisabledColor: Color.fromARGB(
                                          255,
                                          179,
                                          178,
                                          178,
                                        ),
                                      ),
                                      dropdownStyleData: DropdownStyleData(
                                        maxHeight: 200,
                                        width: 140,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            5,
                                          ),
                                          border: Border.all(
                                            color: Colors.black26,
                                          ),
                                          color: Colors.white,
                                        ),
                                        offset: const Offset(0, 0),
                                        scrollbarTheme: ScrollbarThemeData(
                                          radius: const Radius.circular(40),
                                          thickness:
                                              WidgetStateProperty.all<double>(
                                                6,
                                              ),
                                          thumbVisibility:
                                              WidgetStateProperty.all<bool>(
                                                true,
                                              ),
                                        ),
                                      ),
                                      menuItemStyleData:
                                          const MenuItemStyleData(
                                            height: 40,
                                            padding: EdgeInsets.only(
                                              left: 14,
                                              right: 14,
                                            ),
                                          ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 40.0),
                            Row(
                              children: [
                                Expanded(
                                  child: AppTextField(
                                    controller: txt_DemoPlanTarget
                                      ..text =
                                          (liquidationPlanController
                                              .kpimasterList
                                              .isNotEmpty)
                                          ? (liquidationPlanController
                                                        .kpimasterList
                                                        .first
                                                        .demOPLAN ??
                                                    0)
                                                .toString()
                                          : 'No Data',
                                    textFieldType: TextFieldType.NUMBER,
                                    decoration: const InputDecoration(
                                      labelText: "Demo Plan Target",
                                      enabled: false,
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
                                      hintText: "Demo Plan Target",
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 20.0),
                                Expanded(
                                  child: AppTextField(
                                    controller: txt_DemoPlanAchieved
                                      ..text =
                                          (demoPlanController
                                              .demoPlanAchievementList
                                              .isNotEmpty)
                                          ? (demoPlanController
                                                        .demoPlanAchievementList
                                                        .first
                                                        .demOPLANACHIEVEMENT ??
                                                    0)
                                                .toString()
                                          : 'No Data',
                                    textFieldType: TextFieldType.NUMBER,
                                    decoration: const InputDecoration(
                                      labelText: "Demo Plan Achieved",
                                      enabled: false,
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
                                      hintText: "Demo Plan Achieved",
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 30.0),
                            Row(
                              children: [
                                Expanded(
                                  child: AppTextField(
                                    controller: txt_OrgMeetingTarget
                                      ..text =
                                          (liquidationPlanController
                                              .kpimasterList
                                              .isNotEmpty)
                                          ? (liquidationPlanController
                                                        .kpimasterList
                                                        .first
                                                        .organiseDFARMERMETTING ??
                                                    0)
                                                .toString()
                                          : 'No Data',
                                    textFieldType: TextFieldType.NUMBER,
                                    decoration: const InputDecoration(
                                      labelText: "Organized Meeting Target",
                                      enabled: false,
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
                                      hintText: "Organized Meeting Target",
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 20.0),
                                Expanded(
                                  child: AppTextField(
                                    controller: txt_OrgMeetingAchieved
                                      ..text =
                                          (organisedFarmerMeetingController
                                              .organisedMeetingAchiList
                                              .isNotEmpty)
                                          ? (organisedFarmerMeetingController
                                                        .organisedMeetingAchiList
                                                        .first
                                                        .organiseDMEETINGACHIEVEMENT ??
                                                    0)
                                                .toString()
                                          : 'No Data',
                                    textFieldType: TextFieldType.NUMBER,
                                    enabled: false,
                                    decoration: const InputDecoration(
                                      labelText: "Organized Meeting Achieved",
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
                                      hintText: "Organized Meeting Achieved",
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 30.0),
                            Row(
                              children: [
                                Expanded(
                                  child: AppTextField(
                                    controller: txt_UnorgMeetingTarget
                                      ..text =
                                          (liquidationPlanController
                                              .kpimasterList
                                              .isNotEmpty)
                                          ? (liquidationPlanController
                                                        .kpimasterList
                                                        .first
                                                        .unorganiseDFARMERMETTING ??
                                                    0)
                                                .toString()
                                          : 'No Data',
                                    textFieldType: TextFieldType.NUMBER,
                                    decoration: const InputDecoration(
                                      labelText: "Unorganized Meeting Target",
                                      enabled: false,
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
                                      hintText: "Unorganized Meeting Target",
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 20.0),
                                Expanded(
                                  child: AppTextField(
                                    controller: txt_UnorgMeetingAchieved
                                      ..text =
                                          (unorganizedFarmerMeetingController
                                              .unorganisedMeetingAchiList
                                              .isNotEmpty)
                                          ? (unorganizedFarmerMeetingController
                                                        .unorganisedMeetingAchiList
                                                        .first
                                                        .unorganiseDMEETINGACHIEVEMENT ??
                                                    0)
                                                .toString()
                                          : 'No Data',
                                    textFieldType: TextFieldType.NUMBER,
                                    decoration: const InputDecoration(
                                      labelText: "Unorganized Meeting Achieved",
                                      enabled: false,
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
                                      hintText: "Unorganized Meeting Achieved",
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 30.0),
                            Row(
                              children: [
                                Expanded(
                                  child: AppTextField(
                                    controller: txt_FieldDaysTarget
                                      ..text =
                                          (liquidationPlanController
                                              .kpimasterList
                                              .isNotEmpty)
                                          ? (liquidationPlanController
                                                        .kpimasterList
                                                        .first
                                                        .fielDDAYS ??
                                                    0)
                                                .toString()
                                          : 'No Data',
                                    textFieldType: TextFieldType.NUMBER,
                                    decoration: const InputDecoration(
                                      labelText: "Field Days Target",
                                      enabled: false,
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
                                      hintText: "Field Days Target",
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 20.0),
                                Expanded(
                                  child: AppTextField(
                                    controller: txt_FieldDaysAchieved
                                      ..text =
                                          (fieldDaysController
                                              .fieldDaysList
                                              .isNotEmpty)
                                          ? (fieldDaysController
                                                        .fieldDaysList
                                                        .first
                                                        .fielDDAYSACHIEVEMENT ??
                                                    0)
                                                .toString()
                                          : 'No Data',
                                    textFieldType: TextFieldType.NUMBER,
                                    decoration: const InputDecoration(
                                      labelText: "Field Days Achieved",
                                      enabled: false,
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
                                      hintText: "Field Days Achieved",
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 30.0),
                            Row(
                              children: [
                                Expanded(
                                  child: AppTextField(
                                    controller: txt_LiqPlanTarget
                                      ..text =
                                          (liquidationPlanController
                                              .kpimasterList
                                              .isNotEmpty)
                                          ? (liquidationPlanController
                                                        .kpimasterList
                                                        .first
                                                        .liquidatioNPLAN ??
                                                    0)
                                                .toString()
                                          : 'No Data',
                                    textFieldType: TextFieldType.NUMBER,
                                    decoration: const InputDecoration(
                                      labelText: "Liquidation Plan Target",
                                      enabled: false,
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
                                      hintText: "Liquidation Plan Target",
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 20.0),
                                Expanded(
                                  child: AppTextField(
                                    controller: txt_LiqPlanAchieved
                                      ..text =
                                          (liquidationPlanController
                                              .liquidationPlanList
                                              .isNotEmpty)
                                          ? (liquidationPlanController
                                                        .liquidationPlanList
                                                        .first
                                                        .liquidatioNPLANACHIEVEMENT ??
                                                    0)
                                                .toString()
                                          : 'No Data',
                                    textFieldType: TextFieldType.NUMBER,
                                    decoration: const InputDecoration(
                                      labelText: "Liquidation Plan Achieved",
                                      enabled: false,
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
                                      hintText: "Liquidation Plan Achieved",
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 30.0),
                            Row(
                              children: [
                                Expanded(
                                  child: AppTextField(
                                    controller: txt_CollPlanTarget
                                      ..text =
                                          (liquidationPlanController
                                              .kpimasterList
                                              .isNotEmpty)
                                          ? (liquidationPlanController
                                                        .kpimasterList
                                                        .first
                                                        .collectioNPLAN ??
                                                    0)
                                                .toString()
                                          : 'No Data',
                                    textFieldType: TextFieldType.NUMBER,
                                    decoration: const InputDecoration(
                                      labelText: "Collection Plan Target",
                                      enabled: false,
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
                                      hintText: "Collection Plan Target",
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 20.0),
                                Expanded(
                                  child: AppTextField(
                                    controller: txt_CollPlanAchieved
                                      ..text =
                                          (collectionPlanController
                                              .collectionPlanAchievementList
                                              .isNotEmpty)
                                          ? (collectionPlanController
                                                        .collectionPlanAchievementList
                                                        .first
                                                        .collectioNPLANACHIEVEMENT ??
                                                    0)
                                                .toString()
                                          : 'No Data',
                                    textFieldType: TextFieldType.NUMBER,
                                    decoration: const InputDecoration(
                                      labelText: "Collection Plan Achieved",
                                      enabled: false,
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
                                      hintText: "Collection Plan Achieved",
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 30.0),
                            Row(
                              children: [
                                Expanded(
                                  child: AppTextField(
                                    controller: txt_farmerVisitTarget
                                      ..text =
                                          (liquidationPlanController
                                              .kpimasterList
                                              .isNotEmpty)
                                          ? (liquidationPlanController
                                                        .kpimasterList
                                                        .first
                                                        .farmeR_CONTACT_PLAN ??
                                                    0)
                                                .toString()
                                          : 'No Data',
                                    textFieldType: TextFieldType.NUMBER,
                                    decoration: const InputDecoration(
                                      labelText: "Farmer Visit Target",
                                      enabled: false,
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
                                      hintText: "Farmer Visit Target",
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 20.0),
                                Expanded(
                                  child: AppTextField(
                                    controller: txt_farmerVisitAchieved
                                      ..text =
                                          (farmerConnectivityController
                                              .farmerVisitAchievementList
                                              .isNotEmpty)
                                          ? (farmerConnectivityController
                                                        .farmerVisitAchievementList
                                                        .first
                                                        .farmeRVISITACHIEVEMENT ??
                                                    0)
                                                .toString()
                                          : 'No Data',
                                    textFieldType: TextFieldType.NUMBER,
                                    decoration: const InputDecoration(
                                      labelText: "Farmer Visit Achieved",
                                      enabled: false,
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
                                      hintText: "Farmer Visit Achieved",
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 30.0),
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
