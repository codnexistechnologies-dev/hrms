import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:aeon_hrms/GlobalComponents/button_global.dart';
import 'package:aeon_hrms/Screens/Exit%20Form/controller/ExitController.dart';
import 'package:aeon_hrms/Utility/shared_preferences_service.dart';
import 'package:aeon_hrms/constant.dart';
import 'package:nb_utils/nb_utils.dart';

class ExitFormByEmployee extends StatefulWidget {
  const ExitFormByEmployee({super.key});

  @override
  _ExitFormByEmployeeState createState() => _ExitFormByEmployeeState();
}

class _ExitFormByEmployeeState extends State<ExitFormByEmployee> {
  final ExitController exitController = Get.put(ExitController());
  final lastWorkingDaysController = TextEditingController();
  final TextEditingController dateofResignationController =
      TextEditingController();
  final TextEditingController remarksController = TextEditingController();
  final TextEditingController pemailidController = TextEditingController();
  final TextEditingController noticesPeriodController = TextEditingController();
  @override
  void dispose() {
    lastWorkingDaysController.dispose();
    dateofResignationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    fillDate();
    super.initState();
  }

  void fillDate() {
    lastWorkingDaysController.text = DateTime.now().toString().substring(0, 10);
    dateofResignationController.text =
        DateTime.now().toString().substring(0, 10);
  }

  //List<Map<String, dynamic>> dataList = [];
  void saveExitForm() {
    if (noticesPeriodController.text == "") {
      alertInfo(context, data: "Notice Period Days Cannot be blank.");
    } else if (pemailidController.text == "") {
      alertInfo(context, data: "Personal Email ID Cannot be blank.");
    } else if (remarksController.text == "") {
      alertInfo(context, data: "Reason For Leave Cannot be blank.");
    } else {
      Map<String, dynamic> data = {
        'EMP_CODE': SharedPref.getEmpCode(),
        'RESIGNATIONDATE': dateofResignationController.text,
        'SETTLEMENTRELIEVINGDATE': dateofResignationController.text,
        'RELEAVINGDATE': lastWorkingDaysController.text,
        'NOTICEPERIODSERVED': noticesPeriodController.text,
        'PEMAILID': pemailidController.text,
        'EMP_REMARKS': remarksController.text,
      };
      exitController.saveExitApplication(context, data);
    }
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
          'Separation Form',
          style: kTextStyle.copyWith(
              color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: GetBuilder(builder: (ExitController controller) {
          return controller.issaveExitForm == true
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
                                // List<String> revst = date.toString().split('-');
                                lastWorkingDaysController.text =
                                    date.toString().substring(0, 10);
                              },
                              controller: lastWorkingDaysController,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  suffixIcon: Icon(
                                    Icons.date_range_rounded,
                                    color: kGreyTextColor,
                                  ),
                                  labelText: 'Last Working Day',
                                  hintText: "dd-MMM-yyyy"),
                            ),
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          AppTextField(
                            controller: noticesPeriodController,
                            textFieldType: TextFieldType.NUMBER,
                            decoration: InputDecoration(
                              labelText: 'Notice Period(Days)',
                              // hintText:
                              //     '${controller.employeeDetailsModel?.data?.first.emPName}',
                              labelStyle: kTextStyle,
                              enabled: true,
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              border: const OutlineInputBorder(),
                            ),
                          ),
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

                                dateofResignationController.text =
                                    date.toString().substring(0, 10);
                              },
                              controller: dateofResignationController,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  suffixIcon: Icon(
                                    Icons.date_range_rounded,
                                    color: kGreyTextColor,
                                  ),
                                  labelText: 'Date of Resignation',
                                  hintText: "dd-MMM-yyyy"),
                            ),
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          AppTextField(
                            controller: pemailidController,
                            textFieldType: TextFieldType.EMAIL,
                            decoration: InputDecoration(
                              labelText: 'Personal Email ID',
                              // hintText:
                              //     '${controller.employeeDetailsModel?.data?.first.emPName}',
                              labelStyle: kTextStyle,
                              enabled: true,
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              border: const OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          AppTextField(
                            controller: remarksController,
                            textFieldType: TextFieldType.MULTILINE,
                            decoration: const InputDecoration(
                              labelText: 'Reason For Leave',
                              enabled: true,
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              // hintText:
                              //     '${controller.employeeDetailsModel?.data?.first.emailId}',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          ButtonGlobal(
                              buttontext: controller.issaveExitForm == true
                                  ? "Processing"
                                  : 'Save',
                              //buttontext: 'Save',
                              buttonDecoration:
                                  kButtonDecoration.copyWith(color: kMainColor),
                              onPressed: () {
                                saveExitForm();
                              }),
                        ],
                      ),
                    ),
                  ],
                );
        }),
      ),
    );
  }
}
