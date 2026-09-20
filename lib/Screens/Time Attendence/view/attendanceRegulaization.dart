//import 'dart:html';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:aeon_hrms/GlobalComponents/button_global.dart';
//import 'package:aeon_hrms/Screens/Increment/increment_list.dart';
import 'package:aeon_hrms/Screens/Time%20Attendence/controller/attendance_controller.dart';
import 'package:aeon_hrms/Utility/shared_preferences_service.dart';
import 'package:aeon_hrms/constant.dart';
import 'package:nb_utils/nb_utils.dart';

class AttendanceRegulation extends StatefulWidget {
  const AttendanceRegulation({super.key});

  @override
  _AttendanceRegulationState createState() => _AttendanceRegulationState();
}

class _AttendanceRegulationState extends State<AttendanceRegulation> {
  final AttendanceController attendanceController =
      Get.put(AttendanceController());
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    attendanceController
        .getAttRegProcessDisplay(DateTime.now().toString().substring(0, 10));

    super.initState();
  }

  TimeOfDay selectedTime = TimeOfDay.now();

  final TextEditingController atdateController = TextEditingController();
  final TextEditingController oldInTimeController = TextEditingController();
  final TextEditingController oldOutTimeController = TextEditingController();
  final TextEditingController inTimeController = TextEditingController();
  final TextEditingController outTimeController = TextEditingController();
  final TextEditingController resultController = TextEditingController();
  final TextEditingController daysController = TextEditingController();
  final TextEditingController shiftTimeController = TextEditingController();
  final TextEditingController statusController = TextEditingController();
  final TextEditingController remarksController = TextEditingController();

  Future<void> inTimeSelect(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      initialEntryMode: TimePickerEntryMode.input,
    );

    final formattedTime = formatTimeOfDay(timeOfDay!);
    setState(() {
      selectedTime = timeOfDay;
      inTimeController.text = formattedTime;
    });
  }

  Future<void> outTimeSelect(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      initialEntryMode: TimePickerEntryMode.input,
    );

    final formattedTime = formatTimeOfDay(timeOfDay!);
    setState(() {
      selectedTime = timeOfDay;
      outTimeController.text = formattedTime;
    });
  }

  void fillDate(String atdate) {
    atdateController.text = atdate;
    attendanceController.getAttRegProcessDisplay(atdate);
    setState(() {
      oldInTimeController.text =
          attendanceController.attendanceRegModel!.data!.first.iNTime ?? "";
      oldOutTimeController.text =
          attendanceController.attendanceRegModel!.data!.first.ouTTime ?? "";
      inTimeController.text =
          attendanceController.attendanceRegModel!.data!.first.iNTime ?? "";
      outTimeController.text =
          attendanceController.attendanceRegModel!.data!.first.ouTTime ?? "";
      resultController.text =
          attendanceController.attendanceRegModel!.data!.first.result ?? "";
      daysController.text =
          attendanceController.attendanceRegModel!.data!.first.weekDay ?? "";
      shiftTimeController.text =
          attendanceController.attendanceRegModel!.data!.first.shifttime ?? "";
      statusController.text =
          attendanceController.attendanceRegModel!.data!.first.status ?? "";
    });
  }

  String formatTimeOfDay(TimeOfDay timeOfDay) {
    return '${timeOfDay.hour.toString().padLeft(2, '0')}:${timeOfDay.minute.toString().padLeft(2, '0')}';
  }

  // List<Map<String, dynamic>> dataList = [];
  void saveAttendanceReg() {
    // dataList.clear();
    if (inTimeController.text == "") {
      alertInfo(context, data: "InTime Can't be blanck.");
    } else if (outTimeController.text == "") {
      alertInfo(context, data: "OutTime Can't be blanck..");
    } else if (remarksController.text == "") {
      alertInfo(context, data: "Remarks Can't be blanck..");
    } else {
      final Map<String, dynamic> data = <String, dynamic>{
        'EMP_CODE': SharedPref.getEmpCode(),
        'ATDATE': atdateController.text,
        'oldintime': oldInTimeController.text,
        'oldouttime': oldOutTimeController.text,
        'In_Time': inTimeController.text,
        'Out_Time': outTimeController.text,
        'Result': resultController.text,
        'WeekDay': daysController.text,
        'Remarks': remarksController.text,
      };
      // dataList.add(data);
      attendanceController.saveRegulaizationApplication(context, data);
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
    // var size = MediaQuery.of(context).size;
    // var height = size.height;
    //var width = size.width;
    return Scaffold(
        backgroundColor: kMainColor,
        appBar: AppBar(
          backgroundColor: kMainColor,
          elevation: 0.0,
          iconTheme: const IconThemeData(color: Colors.white),
          title: Text(
            'Attendance Regulaization',
            style: kTextStyle.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        body: SingleChildScrollView(
          child: GetBuilder(builder: (AttendanceController controller) {
            return controller.isAttregprocess == true
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 20.0,
                      ),
                      Container(
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
                            AppTextField(
                              textFieldType: TextFieldType.NAME,
                              readOnly: true,
                              onTap: () async {
                                var date = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime(2100));
                                fillDate(date.toString().substring(0, 10));
                                atdateController.text =
                                    date.toString().substring(0, 10);
                              },
                              controller: atdateController,
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                suffixIcon: const Icon(
                                  Icons.date_range_rounded,
                                  color: kGreyTextColor,
                                ),
                                labelText: 'AtDate',
                                hintText:
                                    '${controller.attendanceRegModel!.data!.isEmpty ? DateTime.now().toString().substring(0, 10) : controller.attendanceRegModel?.data?.first.atdate.toString().substring(0, 10)}',
                              ),
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: AppTextField(
                                    controller: oldInTimeController
                                      ..text = controller
                                              .attendanceRegModel!.data!.isEmpty
                                          ? ""
                                          : controller.attendanceRegModel?.data
                                              ?.first.oldOutTime,
                                    textFieldType: TextFieldType.NAME,
                                    decoration: InputDecoration(
                                      labelText: 'Old InTime',
                                      enabled: false,
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
                                      hintText: "hh:mm",
                                      border: const OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10.0,
                                ),
                                Expanded(
                                  child: AppTextField(
                                    controller: oldOutTimeController
                                      ..text = controller
                                              .attendanceRegModel!.data!.isEmpty
                                          ? ""
                                          : controller.attendanceRegModel?.data
                                                  ?.first.oldOutTime ??
                                              "",
                                    textFieldType: TextFieldType.NAME,
                                    decoration: const InputDecoration(
                                      labelText: 'Old OutTime',
                                      enabled: false,
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
                                      hintText: "hh:mm",
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
                                    controller: inTimeController,
                                    textFieldType: TextFieldType.NAME,
                                    readOnly: true,
                                    onTap: () {
                                      inTimeSelect(context);
                                    },
                                    decoration: const InputDecoration(
                                      labelText: 'In Time',
                                      enabled: true,
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
                                      hintText: "hh:mm",
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10.0,
                                ),
                                Expanded(
                                  child: AppTextField(
                                    controller: outTimeController,
                                    textFieldType: TextFieldType.NAME,
                                    onTap: () {
                                      outTimeSelect(context);
                                    },
                                    decoration: const InputDecoration(
                                      labelText: 'Out Time',
                                      enabled: true,
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
                                      hintText: 'hh:mm',
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
                                    controller: resultController
                                      ..text = controller
                                              .attendanceRegModel!.data!.isEmpty
                                          ? ""
                                          : controller.attendanceRegModel?.data
                                                  ?.first.result ??
                                              "",
                                    textFieldType: TextFieldType.NAME,
                                    decoration: const InputDecoration(
                                      labelText: 'Result',
                                      enabled: false,
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
                                      // hintText:
                                      //     '${controller.employeeDetailsModel?.data?.first.emailId}',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10.0,
                                ),
                                Expanded(
                                  child: AppTextField(
                                    controller: daysController
                                      ..text = controller
                                              .attendanceRegModel!.data!.isEmpty
                                          ? ""
                                          : controller.attendanceRegModel?.data
                                                  ?.first.weekDay ??
                                              "",
                                    textFieldType: TextFieldType.NAME,
                                    decoration: const InputDecoration(
                                      labelText: 'Day',
                                      enabled: false,
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
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
                                    controller: shiftTimeController
                                      ..text = controller
                                              .attendanceRegModel!.data!.isEmpty
                                          ? ""
                                          : controller.attendanceRegModel?.data
                                                  ?.first.shifttime ??
                                              "",
                                    textFieldType: TextFieldType.NAME,
                                    decoration: const InputDecoration(
                                      labelText: 'Shift Time',
                                      enabled: false,
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
                                      // hintText:
                                      //     '${controller.employeeDetailsModel?.data?.first.emailId}',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10.0,
                                ),
                                Expanded(
                                  child: AppTextField(
                                    controller: statusController
                                      ..text = controller
                                              .attendanceRegModel!.data!.isEmpty
                                          ? ""
                                          : controller.attendanceRegModel?.data
                                                  ?.first.status ??
                                              "",
                                    textFieldType: TextFieldType.NAME,
                                    decoration: const InputDecoration(
                                      labelText: 'Status',
                                      enabled: false,
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
                                      // hintText:
                                      //     '${controller.employeeDetailsModel?.data?.first.emailId}',
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
                                ..text =
                                    controller.attendanceRegModel!.data!.isEmpty
                                        ? ""
                                        : controller.attendanceRegModel?.data
                                                ?.first.remarks ??
                                            "",
                              textFieldType: TextFieldType.MULTILINE,
                              decoration: const InputDecoration(
                                labelText: 'Remarks',
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
                              buttontext: 'Save',
                              buttonDecoration:
                                  kButtonDecoration.copyWith(color: kMainColor),
                              onPressed: () {
                                saveAttendanceReg();
                                //const IncrementList().launch(context);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
          }),
        ));
  }
}
