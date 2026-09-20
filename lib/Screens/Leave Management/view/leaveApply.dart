import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:aeon_hrms/GlobalComponents/button_global.dart';
import 'package:aeon_hrms/Screens/Leave%20Management/controller/leaveController.dart';
import 'package:aeon_hrms/Screens/Leave%20Management/model/leaveBalanceModel.dart';
import 'package:aeon_hrms/constant.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

class LeaveApply extends StatefulWidget {
  const LeaveApply({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LeaveApplyState createState() => _LeaveApplyState();
}

class _LeaveApplyState extends State<LeaveApply> {
  // String type = '';
  bool selection = false;
  final LeaveController leaveController = Get.put(LeaveController());
  final TextEditingController fromdateController = TextEditingController();
  final TextEditingController toDateController = TextEditingController();
  final TextEditingController daysController = TextEditingController();
  final TextEditingController approverController = TextEditingController();
  final TextEditingController remarksController = TextEditingController();
  final TextEditingController earnController = TextEditingController();
  final TextEditingController availedController = TextEditingController();
  final TextEditingController balanceController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    leaveTypeList.clear();
    leaveController.selectedValue = null;
    earnController.text = "";
    availedController.text = "";
    balanceController.text = "";
    leaveController.leaveTypeId = null;
  }

  void fillDate() {
    fromdateController.text = DateTime.now().toString().substring(0, 10);
    toDateController.text = DateTime.now().toString().substring(0, 10);
    daysController.text = daysBetween(
            DateFormat('dd-MM-yyyy').parse(fromdateController.text),
            DateFormat('dd-MM-yyyy').parse(toDateController.text))
        .toString();
    leaveController.mngrCode ==
        leaveController.employeeWithManagersModel?.data?.first.mngRCode;
  }

  void changeFromDate() {
    if (selectedType != "Full Day") {
      toDateController.text = fromdateController.text;
    }
    if (DateFormat('dd-MM-yyyy')
            .parse(fromdateController.text)
            .compareTo(DateFormat('dd-MM-yyyy').parse(toDateController.text)) >
        0) {
      toDateController.text = fromdateController.text;
    }
    daysController.text = daysBetween(
            DateFormat('dd-MM-yyyy').parse(fromdateController.text),
            DateFormat('dd-MM-yyyy').parse(toDateController.text))
        .toString();
  }

  void changeToDate() {
    if (selectedType != "Full Day") {
      fromdateController.text = toDateController.text;
    }
    if (balanceController.text == "") {
      alertInfo(context,
          data: "Leave balance is blank Please select Leave Type.");
    } else if (balanceController.text == "0") {
      alertInfo(context, data: "You have no leave balance.");
    } else {
      if (DateFormat('dd-MM-yyyy').parse(toDateController.text).compareTo(
              DateFormat('dd-MM-yyyy').parse(fromdateController.text)) <
          0) {
        fromdateController.text = toDateController.text;
      }
      daysController.text = daysBetween(
              DateFormat('dd-MM-yyyy').parse(fromdateController.text),
              DateFormat('dd-MM-yyyy').parse(toDateController.text))
          .toString();
      if (double.parse(balanceController.text) <
          double.parse(daysController.text)) {
        alertInfo(context, data: "Leave Days Can't be greater then balance.");
      }
    }
  }

  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    //print((daysBetween(from, to)).abs());
    return ((to.difference(from).inDays) ~/ 365) + 1;
  }

  String? selectedValue;
  List<String> typeList = [
    'Full Day',
    'First Half',
    'Second Half',
  ];
  String? selectedType = "Full Day";

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    leaveController.getLeaveBalancebyEmpcode();
    leaveController.getLeaveManagerslDetailsByEmpCode();
    fillDate();
    super.initState();
  }

  void saveLeaveApplication() {
    if (leaveController.leaveTypeId == null) {
      alertInfo(context, data: "Please Select Leave Type.");
    } else if (daysController.text == "" ||
        int.parse(daysController.text) < 0) {
      alertInfo(context, data: "Days Can't be blank.");
    } else if (balanceController.text == "") {
      alertInfo(context,
          data: "Leave balance is blank Please select Leave Type.");
    } else if (balanceController.text == "0") {
      alertInfo(context, data: "You have no leave balance.");
    } else if (double.parse(balanceController.text) <
        double.parse(daysController.text)) {
      alertInfo(context, data: "Leave Days Can't be greater then balance.");
    } else if (remarksController.text == "") {
      alertInfo(context, data: "Remarks Can't be blank.");
    } else {
      leaveController.saveLeaveApplication(
          context,
          fromdateController.text,
          toDateController.text,
          daysController.text,
          selectedType!,
          leaveController.employeeWithManagersModel?.data?.first.mngRCode,
          remarksController.text);
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
          'Leave Application',
          style: kTextStyle.copyWith(
              color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: GetBuilder(builder: (LeaveController controller) {
          return controller.isLoading == true
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
                            DropdownButtonHideUnderline(
                              child: DropdownButton2<LeaveBalenceData>(
                                isExpanded: true,
                                hint: const Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Select Leave Type',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Color.fromARGB(
                                              255, 128, 126, 126),
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                items: (controller.leaveTypeList).isNotEmpty
                                    ? controller.leaveTypeList
                                        .map((LeaveBalenceData item) =>
                                            DropdownMenuItem<LeaveBalenceData>(
                                              value: item,
                                              child: Text(
                                                item.lvdesc.toString(),
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  color: Color.fromARGB(
                                                      255, 128, 126, 126),
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ))
                                        .toList()
                                    : [],
                                value: controller.selectedValue,
                                onChanged: (LeaveBalenceData? value) {
                                  if (value != null) {
                                    setState(() {
                                      controller.selectedValue = value;
                                      controller.leaveTypeId =
                                          value.lvtype.toString();
                                      controller.earn = value.earned.toString();
                                      controller.availed =
                                          value.availed.toString();
                                      controller.balance =
                                          value.balance.toString();
                                    });
                                  }
                                },
                                buttonStyleData: ButtonStyleData(
                                  height: 50,
                                  width: double.infinity,
                                  padding: const EdgeInsets.only(
                                      left: 14, right: 14),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
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
                                  iconEnabledColor:
                                      Color.fromARGB(255, 128, 126, 126),
                                  iconDisabledColor:
                                      Color.fromARGB(255, 179, 178, 178),
                                ),
                                dropdownStyleData: DropdownStyleData(
                                  maxHeight: 200,
                                  width: 320,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                      color: Colors.black26,
                                    ),
                                    color: Colors.white,
                                  ),
                                  offset: const Offset(0, 0),
                                  scrollbarTheme: ScrollbarThemeData(
                                    radius: const Radius.circular(40),
                                    thickness:
                                        WidgetStateProperty.all<double>(6),
                                    thumbVisibility:
                                        WidgetStateProperty.all<bool>(true),
                                  ),
                                ),
                                menuItemStyleData: const MenuItemStyleData(
                                  height: 40,
                                  padding: EdgeInsets.only(left: 14, right: 14),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            DropdownButtonHideUnderline(
                              child: DropdownButton2<String>(
                                isExpanded: true,
                                hint: const Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Select Type',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Color.fromARGB(
                                              255, 128, 126, 126),
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                items: typeList
                                    .map((String item) =>
                                        DropdownMenuItem<String>(
                                          value: item,
                                          child: Text(
                                            item,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Color.fromARGB(
                                                  255, 128, 126, 126),
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ))
                                    .toList(),
                                value: selectedType,
                                onChanged: (String? value) {
                                  setState(() {
                                    selectedType = value;
                                  });
                                },
                                buttonStyleData: ButtonStyleData(
                                  height: 50,
                                  width: double.infinity,
                                  padding: const EdgeInsets.only(
                                      left: 14, right: 14),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                      color: Colors.black26,
                                    ),
                                    color: Colors.white,
                                  ),
                                  // elevation: 2,
                                ),
                                iconStyleData: const IconStyleData(
                                  icon: Icon(
                                    Icons.arrow_forward_ios_outlined,
                                  ),
                                  iconSize: 14,
                                  iconEnabledColor:
                                      Color.fromARGB(255, 128, 126, 126),
                                  iconDisabledColor:
                                      Color.fromARGB(255, 179, 178, 178),
                                ),
                                dropdownStyleData: DropdownStyleData(
                                  maxHeight: 200,
                                  width: 320,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                      color: Colors.black26,
                                    ),
                                    color: Colors.white,
                                  ),
                                  offset: const Offset(0, 0),
                                  scrollbarTheme: ScrollbarThemeData(
                                    radius: const Radius.circular(40),
                                    thickness:
                                        WidgetStateProperty.all<double>(6),
                                    thumbVisibility:
                                        WidgetStateProperty.all<bool>(true),
                                  ),
                                ),
                                menuItemStyleData: const MenuItemStyleData(
                                  height: 40,
                                  padding: EdgeInsets.only(left: 14, right: 14),
                                ),
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
                                  // List<String> revst = date.toString().split('-');
                                  fromdateController.text =
                                      date.toString().substring(0, 10);
                                  changeFromDate();
                                },
                                controller: fromdateController,
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

                                  toDateController.text =
                                      date.toString().substring(0, 10);
                                  changeToDate();
                                },
                                controller: toDateController,
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    suffixIcon: Icon(
                                      Icons.date_range_rounded,
                                      color: kGreyTextColor,
                                    ),
                                    labelText: 'To Date',
                                    hintText: "dd-MMM-yyyy"),
                              ),
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: AppTextField(
                                    controller: daysController,
                                    textFieldType: TextFieldType.NAME,
                                    decoration: const InputDecoration(
                                      labelText: "Days",
                                      enabled: false,
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
                                      hintText: "1",
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10.0,
                                ),
                                Expanded(
                                  flex: 2,
                                  child: AppTextField(
                                    controller: approverController
                                      ..text = controller
                                              .employeeWithManagersModel
                                              ?.data
                                              ?.first
                                              .mngRName ??
                                          "",
                                    textFieldType: TextFieldType.NAME,
                                    decoration: const InputDecoration(
                                      labelText: "Approver Name",
                                      enabled: false,
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
                                      hintText: "Approver Name",
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
                                    controller: earnController
                                      ..text = controller.earn ?? "",
                                    textFieldType: TextFieldType.NAME,
                                    decoration: const InputDecoration(
                                      labelText: 'Earn',
                                      enabled: false,
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
                                      hintText: "1",
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10.0,
                                ),
                                Expanded(
                                  child: AppTextField(
                                    controller: availedController
                                      ..text = controller.availed ?? "",
                                    textFieldType: TextFieldType.NAME,
                                    decoration: const InputDecoration(
                                      labelText: 'Availed',
                                      enabled: false,
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
                                      hintText: "Availed",
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10.0,
                                ),
                                Expanded(
                                  child: AppTextField(
                                    controller: balanceController
                                      ..text = controller.balance ?? "",
                                    textFieldType: TextFieldType.NAME,
                                    decoration: const InputDecoration(
                                      labelText: 'Balance',
                                      enabled: false,
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
                                      hintText: "Balance",
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
                              controller: remarksController,
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
                              height: 5.0,
                            ),
                            ButtonGlobal(
                              buttontext: controller.issaveLeaveApply == true
                                  ? "Processing"
                                  : 'Apply',
                              buttonDecoration:
                                  kButtonDecoration.copyWith(color: kMainColor),
                              onPressed: () {
                                if (controller.issaveLeaveApply == false) {
                                  saveLeaveApplication();
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
