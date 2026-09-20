// ignore: file_names
import 'package:date_format/date_format.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:aeon_hrms/Screens/Leave%20Management/controller/leaveController.dart';
import 'package:aeon_hrms/constant.dart';

class LeaveStatus extends StatefulWidget {
  const LeaveStatus({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LeaveStatusState createState() => _LeaveStatusState();
}

class _LeaveStatusState extends State<LeaveStatus> {
  String leaveType = '';
  String type = '';
  bool selection = false;
  final LeaveController leaveController = Get.put(LeaveController());

  @override
  void dispose() {
    //leaveController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    getLeaveStatus();
    super.initState();
  }

  String? monthValue = formatDate(DateTime.now(), [MM]).toString();
  String? yearValues = formatDate(DateTime.now(), [yyyy]).toString();
  bool isLoading = false;
  void getLeaveStatus() {
    if (monthValue == "" || monthValue == null) {
      monthValue = formatDate(DateTime.now(), [MM]).toString();
    }
    if (yearValues == "" || yearValues == null) {
      yearValues = formatDate(DateTime.now(), [yyyy]).toString();
    }
    leaveController.getLeaveStatusByEmpcodeMonthandYear(
        monthValue!, yearValues!);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var height = size.height;
    return Scaffold(
      backgroundColor: kMainColor,
      appBar: AppBar(
        backgroundColor: kMainColor,
        elevation: 0.0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'Leave Status',
          style: kTextStyle.copyWith(
              color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: GetBuilder(
          builder: (LeaveController controller) {
            return controller.isLoading == true
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 10.0,
                      ),
                      Container(
                        width: double.infinity,
                        height: 590,
                        padding: const EdgeInsets.all(10.0),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10.0),
                              topRight: Radius.circular(10.0)),
                          color: kBgColor,
                        ),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(5.0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: Colors.white),
                              child: Column(
                                children: [
                                  // const SizedBox(
                                  //   height: 20.0,
                                  // ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Color.fromARGB(
                                                          255, 128, 126, 126),
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
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
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Color.fromARGB(
                                                              255,
                                                              128,
                                                              126,
                                                              126),
                                                        ),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ))
                                                .toList(),
                                            value: monthValue,
                                            onChanged: (String? value) {
                                              setState(() {
                                                monthValue = value;
                                              });
                                              getLeaveStatus();
                                            },
                                            buttonStyleData: ButtonStyleData(
                                              height: 50,
                                              width: double.infinity,
                                              padding: const EdgeInsets.only(
                                                  left: 14, right: 14),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                border: Border.all(
                                                  color: Colors.black26,
                                                ),
                                                color: Colors.white,
                                              ),
                                            ),
                                            iconStyleData: const IconStyleData(
                                              icon: Icon(
                                                Icons
                                                    .arrow_forward_ios_outlined,
                                              ),
                                              iconSize: 14,
                                              iconEnabledColor: Color.fromARGB(
                                                  255, 128, 126, 126),
                                              iconDisabledColor: Color.fromARGB(
                                                  255, 179, 178, 178),
                                            ),
                                            dropdownStyleData:
                                                DropdownStyleData(
                                              maxHeight: 300,
                                              width: 140,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                border: Border.all(
                                                  color: Colors.black26,
                                                ),
                                                color: Colors.white,
                                              ),
                                              offset: const Offset(0, 0),
                                              scrollbarTheme:
                                                  ScrollbarThemeData(
                                                radius:
                                                    const Radius.circular(40),
                                                thickness: WidgetStateProperty
                                                    .all<double>(6),
                                                thumbVisibility:
                                                    WidgetStateProperty.all<
                                                        bool>(true),
                                              ),
                                            ),
                                            menuItemStyleData:
                                                const MenuItemStyleData(
                                              height: 40,
                                              padding: EdgeInsets.only(
                                                  left: 14, right: 14),
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
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Color.fromARGB(
                                                          255, 128, 126, 126),
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
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
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Color.fromARGB(
                                                              255,
                                                              128,
                                                              126,
                                                              126),
                                                        ),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ))
                                                .toList(),
                                            value: yearValues,
                                            onChanged: (String? value) {
                                              setState(() {
                                                yearValues = value;
                                              });
                                              getLeaveStatus();
                                            },
                                            buttonStyleData: ButtonStyleData(
                                              height: 50,
                                              width: 140,
                                              padding: const EdgeInsets.only(
                                                  left: 14, right: 14),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                border: Border.all(
                                                  color: Colors.black26,
                                                ),
                                                color: Colors.white,
                                              ),
                                            ),
                                            iconStyleData: const IconStyleData(
                                              icon: Icon(
                                                Icons
                                                    .arrow_forward_ios_outlined,
                                              ),
                                              iconSize: 14,
                                              iconEnabledColor: Color.fromARGB(
                                                  255, 128, 126, 126),
                                              iconDisabledColor: Color.fromARGB(
                                                  255, 179, 178, 178),
                                            ),
                                            dropdownStyleData:
                                                DropdownStyleData(
                                              maxHeight: 200,
                                              width: 140,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                border: Border.all(
                                                  color: Colors.black26,
                                                ),
                                                color: Colors.white,
                                              ),
                                              offset: const Offset(0, 0),
                                              scrollbarTheme:
                                                  ScrollbarThemeData(
                                                radius:
                                                    const Radius.circular(40),
                                                thickness: WidgetStateProperty
                                                    .all<double>(6),
                                                thumbVisibility:
                                                    WidgetStateProperty.all<
                                                        bool>(true),
                                              ),
                                            ),
                                            menuItemStyleData:
                                                const MenuItemStyleData(
                                              height: 40,
                                              padding: EdgeInsets.only(
                                                  left: 14, right: 14),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 20.0,
                                  ),
                                  controller.leaveStatusModel!.data!.isEmpty
                                      ? SizedBox(
                                          height: height * 0.65,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const Image(
                                                image: AssetImage(
                                                    'images/empty.png'),
                                              ),
                                              const SizedBox(
                                                height: 20.0,
                                              ),
                                              Column(
                                                children: [
                                                  Text(
                                                    'No Data',
                                                    style: kTextStyle.copyWith(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 20.0),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        )
                                      : Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Row(
                                              children: [
                                                SizedBox(
                                                  width: 120,
                                                  child: Text(
                                                    'Leave Type',
                                                    style: kTextStyle.copyWith(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 85,
                                                  child: Text(
                                                    'L. Date',
                                                    style: kTextStyle.copyWith(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 40,
                                                  child: Text(
                                                    'Days',
                                                    style: kTextStyle.copyWith(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 60,
                                                  child: Text(
                                                    'Status',
                                                    style: kTextStyle.copyWith(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const Divider(
                                              thickness: 1.0,
                                              color: kGreyTextColor,
                                            ),
                                            controller.isLoading == true
                                                ? const Center(
                                                    child:
                                                        CircularProgressIndicator())
                                                : SizedBox(
                                                    height: 400,
                                                    child: ListView.builder(
                                                      itemCount: controller
                                                          .leaveStatusModel
                                                          ?.data
                                                          ?.length,
                                                      itemBuilder:
                                                          (BuildContext context,
                                                              int index) {
                                                        return Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  vertical:
                                                                      5.0),
                                                          child: Column(
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  SizedBox(
                                                                    width: 120,
                                                                    child: Text(
                                                                      controller
                                                                              .leaveStatusModel
                                                                              ?.data![index]
                                                                              .lvdesc ??
                                                                          "",
                                                                      style: kTextStyle.copyWith(
                                                                          color:
                                                                              kGreyTextColor),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 85,
                                                                    child: Text(
                                                                      controller
                                                                              .leaveStatusModel
                                                                              ?.data![index]
                                                                              .atdate
                                                                              .toString()
                                                                              .substring(0, 10) ??
                                                                          "",
                                                                      style: kTextStyle.copyWith(
                                                                          color:
                                                                              kGreyTextColor),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 25,
                                                                    // color: Colors.grey,
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Text(
                                                                        controller.leaveStatusModel?.data![index].lvdays ??
                                                                            "",
                                                                        style: kTextStyle.copyWith(
                                                                            color:
                                                                                kGreyTextColor),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 100,
                                                                    // color: Colors.grey,
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Text(
                                                                        controller.leaveStatusModel?.data![index].status ??
                                                                            "",
                                                                        style: kTextStyle.copyWith(
                                                                            color:
                                                                                kGreyTextColor),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              const Divider(
                                                                thickness: 0.3,
                                                                color: Colors
                                                                    .black,
                                                              )
                                                            ],
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  )
                                          ],
                                        ),
                                ],
                              ),
                            )
                            // const SizedBox(
                            //   height: 20.0,
                            // ),
                          ],
                        ),
                      ),
                    ],
                  );
          },
        ),
      ),
    );
  }
}
