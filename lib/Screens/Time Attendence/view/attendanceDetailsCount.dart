import 'package:date_format/date_format.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:aeon_hrms/Screens/Time%20Attendence/controller/attendance_controller.dart';
import 'package:aeon_hrms/constant.dart';
import 'package:nb_utils/nb_utils.dart';

class AttendanceDetailsCount extends StatefulWidget {
  const AttendanceDetailsCount({super.key});

  @override
  _AttendanceDetailsCountState createState() => _AttendanceDetailsCountState();
}

class _AttendanceDetailsCountState extends State<AttendanceDetailsCount> {
  final AttendanceController attendanceController =
      Get.put(AttendanceController());
  @override
  void dispose() {
    super.dispose();
  }

  String? monthValue = formatDate(DateTime.now(), [MM]).toString();
  String? yearValues = formatDate(DateTime.now(), [yyyy]).toString();
  @override
  void initState() {
    attendanceController.getAttendanceReportByEmpcodeandMonthWize(
        monthValue!, yearValues!);
    super.initState();
  }

  void changeStatus() {
    attendanceController.getAttendanceReportByEmpcodeandMonthWize(
        monthValue!, yearValues!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: kMainColor,
      appBar: AppBar(
        backgroundColor: kMainColor,
        elevation: 0.0,
        titleSpacing: 0.0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'Attendance Summary',
          maxLines: 2,
          style: kTextStyle.copyWith(
              color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: GetBuilder(builder: (AttendanceController controller) {
        return controller.isSummaryLoading == true
            ? const Center(child: CircularProgressIndicator())
            : Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height / 1.15,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30.0),
                          topRight: Radius.circular(30.0)),
                      color: kBgColor,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 20),
                      child: Column(
                        children: [
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
                                                  255, 128, 126, 126),
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    items: monthName
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
                                    value: monthValue,
                                    onChanged: (String? value) {
                                      setState(() {
                                        monthValue = value;
                                        changeStatus();
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
                                      maxHeight: 300,
                                      width: 140,
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
                                            WidgetStateProperty.all<double>(
                                                6),
                                        thumbVisibility:
                                            WidgetStateProperty.all<bool>(
                                                true),
                                      ),
                                    ),
                                    menuItemStyleData: const MenuItemStyleData(
                                      height: 40,
                                      padding:
                                          EdgeInsets.only(left: 14, right: 14),
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
                                                  255, 128, 126, 126),
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    items: yearList
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
                                    value: yearValues,
                                    onChanged: (String? value) {
                                      setState(() {
                                        yearValues = value;
                                        changeStatus();
                                      });
                                    },
                                    buttonStyleData: ButtonStyleData(
                                      height: 50,
                                      width: 140,
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
                                      width: 140,
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
                                            WidgetStateProperty.all<double>(
                                                6),
                                        thumbVisibility:
                                            WidgetStateProperty.all<bool>(
                                                true),
                                      ),
                                    ),
                                    menuItemStyleData: const MenuItemStyleData(
                                      height: 40,
                                      padding:
                                          EdgeInsets.only(left: 14, right: 14),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: controller.attendanceSummaryModel?.data ==
                                    null
                                ? SizedBox(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Image(
                                          image: AssetImage('images/empty.png'),
                                        ),
                                        const SizedBox(
                                          height: 20.0,
                                        ),
                                        Column(
                                          children: [
                                            Text(
                                              'No Data',
                                              style: kTextStyle.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20.0),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                : Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Container(
                                                padding: const EdgeInsets.only(
                                                    top: 10.0,
                                                    bottom: 10.0,
                                                    left: 10.0,
                                                    right: 20.0),
                                                decoration: BoxDecoration(
                                                  border: const Border(
                                                      top: BorderSide(
                                                    color: kMainColor,
                                                  )),
                                                  color: kMainColor
                                                      .withValues(alpha: 0.1),
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      controller
                                                              .attendanceSummaryModel
                                                              ?.data
                                                              ?.first
                                                              .present ??
                                                          "",
                                                      style:
                                                          kTextStyle.copyWith(
                                                              color: kMainColor,
                                                              fontSize: 18.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                    ),
                                                    Text(
                                                      'Present',
                                                      style: kTextStyle,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Container(
                                                padding: const EdgeInsets.only(
                                                    top: 10.0,
                                                    bottom: 10.0,
                                                    left: 10.0,
                                                    right: 20.0),
                                                decoration: BoxDecoration(
                                                  border: const Border(
                                                      top: BorderSide(
                                                    color: kAlertColor,
                                                  )),
                                                  color: kAlertColor
                                                      .withValues(alpha: 0.1),
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      controller
                                                              .attendanceSummaryModel
                                                              ?.data
                                                              ?.first
                                                              .absent ??
                                                          "",
                                                      style:
                                                          kTextStyle.copyWith(
                                                              color:
                                                                  kAlertColor,
                                                              fontSize: 18.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                    ),
                                                    Text(
                                                      'Absent',
                                                      style: kTextStyle,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Container(
                                                padding: const EdgeInsets.only(
                                                    top: 10.0,
                                                    bottom: 10.0,
                                                    left: 10.0,
                                                    right: 20.0),
                                                decoration: BoxDecoration(
                                                  border: const Border(
                                                      top: BorderSide(
                                                    color: Color(0xFF4CE364),
                                                  )),
                                                  color: const Color(0xFF4CE364)
                                                      .withValues(alpha: 0.1),
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      controller
                                                              .attendanceSummaryModel
                                                              ?.data
                                                              ?.first
                                                              .holidays ??
                                                          "",
                                                      style: kTextStyle.copyWith(
                                                          color: const Color(
                                                              0xFF4CE364),
                                                          fontSize: 18.0,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                      'Holiday',
                                                      style: kTextStyle,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10.0,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Container(
                                                padding: const EdgeInsets.only(
                                                    top: 10.0,
                                                    bottom: 10.0,
                                                    left: 10.0,
                                                    right: 20.0),
                                                decoration: BoxDecoration(
                                                  border: const Border(
                                                      top: BorderSide(
                                                    color: kHalfDay,
                                                  )),
                                                  color:
                                                      kHalfDay.withValues(alpha: 0.1),
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      controller
                                                              .attendanceSummaryModel
                                                              ?.data
                                                              ?.first
                                                              .latecoming ??
                                                          "",
                                                      style:
                                                          kTextStyle.copyWith(
                                                              color: kHalfDay,
                                                              fontSize: 18.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                    ),
                                                    Text(
                                                      'LateCommimg',
                                                      style: kTextStyle,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Container(
                                                padding: const EdgeInsets.only(
                                                    top: 10.0,
                                                    bottom: 10.0,
                                                    left: 10.0,
                                                    right: 15.0),
                                                decoration: BoxDecoration(
                                                  border: const Border(
                                                      top: BorderSide(
                                                    color: Color(0xFF806DF0),
                                                  )),
                                                  color: const Color(0xFF806DF0)
                                                      .withValues(alpha: 0.1),
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      controller
                                                              .attendanceSummaryModel
                                                              ?.data
                                                              ?.first
                                                              .weekoff ??
                                                          "",
                                                      style: kTextStyle.copyWith(
                                                          color: const Color(
                                                              0xFF806DF0),
                                                          fontSize: 18.0,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                      'WeekOff',
                                                      style: kTextStyle,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Container(
                                                padding: const EdgeInsets.only(
                                                    top: 10.0,
                                                    bottom: 10.0,
                                                    left: 10.0,
                                                    right: 15.0),
                                                decoration: BoxDecoration(
                                                  border: const Border(
                                                      top: BorderSide(
                                                    color: Color(0xFF4ACDF9),
                                                  )),
                                                  color: const Color(0xFF4ACDF9)
                                                      .withValues(alpha: 0.1),
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      controller
                                                              .attendanceSummaryModel
                                                              ?.data
                                                              ?.first
                                                              .leave ??
                                                          "",
                                                      style: kTextStyle.copyWith(
                                                          color: const Color(
                                                              0xFF4ACDF9),
                                                          fontSize: 18.0,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                      'Leave',
                                                      style: kTextStyle,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10.0,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Container(
                                                padding: const EdgeInsets.only(
                                                    top: 10.0,
                                                    bottom: 10.0,
                                                    left: 10.0,
                                                    right: 20.0),
                                                decoration: const BoxDecoration(
                                                    border: Border(
                                                        top: BorderSide(
                                                      color: Colors.green,
                                                    )),
                                                    // color:
                                                    //     kHalfDay.withOpacity(0.1),
                                                    color: Color.fromARGB(
                                                        255, 157, 226, 160)),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      'Present:-${controller.attendanceSummaryModel?.data?.first.totaLPresent ?? ""}',
                                                      style:
                                                          kTextStyle.copyWith(
                                                              color: black,
                                                              fontSize: 18.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
      }),
    );
  }
}
