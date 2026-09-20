import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:aeon_hrms/GlobalComponents/button_global.dart';
import 'package:aeon_hrms/Screens/KPI/controller/KpiMasterController.dart';

import 'package:aeon_hrms/constant.dart';

import 'package:nb_utils/nb_utils.dart';

class AddKpiHist extends StatefulWidget {
  const AddKpiHist({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AddKpiHistState createState() => _AddKpiHistState();
}

class _AddKpiHistState extends State<AddKpiHist> {
  // String type = '';
  bool selection = false;
  final KpiMasterController kpiMasterController =
      Get.put(KpiMasterController());
  final TextEditingController from_dateController = TextEditingController();
  final TextEditingController actual_fm_planController =
      TextEditingController();
  final TextEditingController actual_fd_planController =
      TextEditingController();
  final TextEditingController actual_demoController = TextEditingController();
  final TextEditingController actual_farmerDataController =
      TextEditingController();
  final TextEditingController actual_liquidationController =
      TextEditingController();
  final TextEditingController actual_collectionController =
      TextEditingController();
  final TextEditingController remarksController = TextEditingController();
  final TextEditingController fmPlan_MasterController = TextEditingController();
  final TextEditingController fdPlan_MasterController = TextEditingController();
  final TextEditingController demo_MasterController = TextEditingController();
  final TextEditingController farmerData_MasterController =
      TextEditingController();
  final TextEditingController liquidation_MasterController =
      TextEditingController();
  final TextEditingController collection_MasterController =
      TextEditingController();
  @override
  void dispose() {
    //from_dateController.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    from_dateController.text = DateTime.now().toString().substring(0, 10);
    GetKpiMasterData(DateTime.now().toString().substring(0, 10));

    super.initState();
  }

  void GetKpiMasterData(String atdate) {
    from_dateController.text = atdate;
    kpiMasterController.GetKpiMasterByEmpCodeandPaydate(atdate);
    kpiMasterController.GetKpiHistByEmpCodeandAtdate(atdate);
  }

  void saveKpiHist() {
    kpiMasterController.saveKpiHist(
        context,
        from_dateController.text,
        actual_fm_planController.text,
        actual_fd_planController.text,
        actual_demoController.text,
        actual_farmerDataController.text,
        actual_liquidationController.text,
        actual_collectionController.text,
        remarksController.text);
  }

  Future alertInfo(BuildContext context, {required String data}) {
    return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(data),
        content: const Icon(Icons.info_outlined),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Ok'),
          ),
        ],
      ),
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
          'KPI Daily Entry',
          style: kTextStyle.copyWith(
              color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: GetBuilder(builder: (KpiMasterController controllerData) {
          return controllerData.isKpiHistLoading == true &&
                  controllerData.isKpiMasterLoading == true
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 20.0,
                    ),
                    Container(
                      //height: context.height(),
                      padding: const EdgeInsets.all(20.0),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30.0),
                            topRight: Radius.circular(30.0)),
                        color: Colors.white,
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 20.0,
                            ),
                            SizedBox(
                              height: 50,
                              child: AppTextField(
                                textFieldType: TextFieldType.NAME,
                                readOnly: true,
                                onTap: () async {
                                  var date = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(1900),
                                      lastDate: DateTime(2100));
                                  GetKpiMasterData(
                                      date.toString().substring(0, 10));
                                  from_dateController.text =
                                      date.toString().substring(0, 10);
                                },
                                controller: from_dateController,
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    suffixIcon: Icon(
                                      Icons.date_range_rounded,
                                      color: kGreyTextColor,
                                    ),
                                    labelText: 'From Date',
                                    hintText: "dd-MMM-yyyy"),
                              ),
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: AppTextField(
                                    controller: fmPlan_MasterController
                                      ..text = controllerData
                                                  .kpiMaterEmpCodeandpaydateModel
                                                  ?.data
                                                  ?.isNotEmpty ==
                                              true
                                          ? '${controllerData.kpiMaterEmpCodeandpaydateModel!.data!.first.fMPLANMASTER ?? ""}'
                                          : '',
                                    textFieldType: TextFieldType.NAME,
                                    decoration: const InputDecoration(
                                      labelText: "FM Plan",
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
                                      hintText: "FM Plan",
                                      enabled: false,
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10.0,
                                ),
                                Expanded(
                                  child: AppTextField(
                                    controller: actual_fm_planController
                                      ..text = controllerData
                                                  .kpiHistByEmpCodeandAtdateModel
                                                  ?.data
                                                  ?.isNotEmpty ==
                                              true
                                          ? '${controllerData.kpiHistByEmpCodeandAtdateModel!.data!.first.actuaLFMPLAN ?? ""}'
                                          : '',
                                    textFieldType: TextFieldType.NUMBER,
                                    decoration: const InputDecoration(
                                      labelText: "Actual",
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
                                      hintText: "Actual",
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: AppTextField(
                                    controller: fdPlan_MasterController
                                      ..text = controllerData
                                                  .kpiMaterEmpCodeandpaydateModel
                                                  ?.data
                                                  ?.isNotEmpty ==
                                              true
                                          ? '${controllerData.kpiMaterEmpCodeandpaydateModel!.data!.first.fDPLANMASTER ?? ""}'
                                          : '',
                                    textFieldType: TextFieldType.NAME,
                                    decoration: const InputDecoration(
                                      labelText: "FD Plan",
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
                                      hintText: "FD Plan",
                                      enabled: false,
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10.0,
                                ),
                                Expanded(
                                  child: AppTextField(
                                    controller: actual_fd_planController
                                      ..text = controllerData
                                                  .kpiHistByEmpCodeandAtdateModel
                                                  ?.data
                                                  ?.isNotEmpty ==
                                              true
                                          ? '${controllerData.kpiHistByEmpCodeandAtdateModel!.data!.first.actuaLFDPLAN ?? ""}'
                                          : '',
                                    textFieldType: TextFieldType.NUMBER,
                                    decoration: const InputDecoration(
                                      labelText: "Actual",
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
                                      hintText: "Actual",
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: AppTextField(
                                    controller: demo_MasterController
                                      ..text = controllerData
                                                  .kpiMaterEmpCodeandpaydateModel
                                                  ?.data
                                                  ?.isNotEmpty ==
                                              true
                                          ? '${controllerData.kpiMaterEmpCodeandpaydateModel!.data!.first.demOMASTER ?? ""}'
                                          : '',
                                    textFieldType: TextFieldType.NAME,
                                    decoration: const InputDecoration(
                                      labelText: "Demo Plan",
                                      enabled: false,
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
                                      hintText: "Demo Plan",
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10.0,
                                ),
                                Expanded(
                                  child: AppTextField(
                                    controller: actual_demoController
                                      ..text = controllerData
                                                  .kpiHistByEmpCodeandAtdateModel
                                                  ?.data
                                                  ?.isNotEmpty ==
                                              true
                                          ? '${controllerData.kpiHistByEmpCodeandAtdateModel!.data!.first.actuaLDEMO ?? ""}'
                                          : '',
                                    textFieldType: TextFieldType.NUMBER,
                                    decoration: const InputDecoration(
                                      labelText: "Actual",
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
                                      hintText: "Actual",
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: AppTextField(
                                    controller: farmerData_MasterController
                                      ..text = controllerData
                                                  .kpiMaterEmpCodeandpaydateModel
                                                  ?.data
                                                  ?.isNotEmpty ==
                                              true
                                          ? '${controllerData.kpiMaterEmpCodeandpaydateModel!.data!.first.farmerdatAMASTER ?? ""}'
                                          : '',
                                    textFieldType: TextFieldType.NAME,
                                    decoration: const InputDecoration(
                                      labelText: "Farmer Data Update Plan",
                                      enabled: false,
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
                                      hintText: "Farmer Data Update Plan",
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10.0,
                                ),
                                Expanded(
                                  child: AppTextField(
                                    controller: actual_farmerDataController
                                      ..text = controllerData
                                                  .kpiHistByEmpCodeandAtdateModel
                                                  ?.data
                                                  ?.isNotEmpty ==
                                              true
                                          ? '${controllerData.kpiHistByEmpCodeandAtdateModel!.data!.first.actuaLFARMERDATA ?? ""}'
                                          : '',
                                    textFieldType: TextFieldType.NUMBER,
                                    decoration: const InputDecoration(
                                      labelText: "Actual",
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
                                      hintText: "Actual",
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: AppTextField(
                                    controller: liquidation_MasterController
                                      ..text = controllerData
                                                  .kpiMaterEmpCodeandpaydateModel
                                                  ?.data
                                                  ?.isNotEmpty ==
                                              true
                                          ? '${controllerData.kpiMaterEmpCodeandpaydateModel!.data!.first.liquidatioNMASTER ?? ""}'
                                          : '',
                                    textFieldType: TextFieldType.NAME,
                                    decoration: const InputDecoration(
                                      labelText: "Liquidation Plan",
                                      enabled: false,
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
                                      hintText: "Liquidation Plan",
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10.0,
                                ),
                                Expanded(
                                  child: AppTextField(
                                    controller: actual_liquidationController
                                      ..text = controllerData
                                                  .kpiHistByEmpCodeandAtdateModel
                                                  ?.data
                                                  ?.isNotEmpty ==
                                              true
                                          ? '${controllerData.kpiHistByEmpCodeandAtdateModel!.data!.first.actuaLLIQUIDATION ?? ""}'
                                          : '',
                                    textFieldType: TextFieldType.NUMBER,
                                    decoration: const InputDecoration(
                                      labelText: "Actual",
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
                                      hintText: "Actual",
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: AppTextField(
                                    controller: collection_MasterController
                                      ..text = controllerData
                                                  .kpiMaterEmpCodeandpaydateModel
                                                  ?.data
                                                  ?.isNotEmpty ==
                                              true
                                          ? '${controllerData.kpiMaterEmpCodeandpaydateModel!.data!.first.collectioNMASTER ?? ""}'
                                          : '',
                                    textFieldType: TextFieldType.NAME,
                                    decoration: const InputDecoration(
                                      labelText: "Collection Plan",
                                      enabled: false,
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
                                      hintText: "Collection Plan",
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10.0,
                                ),
                                Expanded(
                                  child: AppTextField(
                                    controller: actual_collectionController
                                      ..text = controllerData
                                                  .kpiHistByEmpCodeandAtdateModel
                                                  ?.data
                                                  ?.isNotEmpty ==
                                              true
                                          ? '${controllerData.kpiHistByEmpCodeandAtdateModel!.data!.first.actuaLCOLLECTION ?? ""}'
                                          : '',
                                    textFieldType: TextFieldType.NUMBER,
                                    decoration: const InputDecoration(
                                      labelText: "Actual",
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
                                      hintText: "Actual",
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            AppTextField(
                              controller: remarksController
                                ..text = controllerData
                                            .kpiHistByEmpCodeandAtdateModel
                                            ?.data
                                            ?.isNotEmpty ==
                                        true
                                    ? controllerData.kpiHistByEmpCodeandAtdateModel!.data!.first.remarks ?? ""
                                    : '',
                              textFieldType: TextFieldType.MULTILINE,
                              decoration: const InputDecoration(
                                labelText: 'Remarks',
                                enabled: true,
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(
                              height: 5.0,
                            ),
                            ButtonGlobal(
                              buttontext:
                                  controllerData.isSaveKpiHistData == true
                                      ? "Processing"
                                      : 'Save',
                              buttonDecoration:
                                  kButtonDecoration.copyWith(color: kMainColor),
                              onPressed: () {
                                if (controllerData.isSaveKpiHistData == false) {
                                  saveKpiHist();
                                }
                              },
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
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
