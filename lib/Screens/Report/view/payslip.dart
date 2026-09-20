// ignore: file_names
import 'package:date_format/date_format.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:aeon_hrms/Screens/Report/controller/ReportController.dart';
import 'package:aeon_hrms/constant.dart';

class Payslip extends StatefulWidget {
  const Payslip({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PayslipState createState() => _PayslipState();
}

class _PayslipState extends State<Payslip> {
  String leaveType = '';
  String type = '';
  bool selection = false;
  final ReportController reportController = Get.put(ReportController());
  final TextEditingController grosspayController = TextEditingController();
  final TextEditingController grossdedController = TextEditingController();
  @override
  void dispose() {
    //dateController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    changeMonthAndyear();
    super.initState();
  }

  void changeMonthAndyear() {
    reportController.getGrossEarnDetailsByEmpCodeMonthYear(
      monthValue!,
      yearValues!,
    );
    reportController.getGrossDedDetailsByEmpCodeMonthYear(
      monthValue!,
      yearValues!,
    );
    reportController.getNetPayDetailsByEmpCodeMonthYear(
      monthValue!,
      yearValues!,
    );
  }

  String GetMonthvalue(String monthValue) {
    String Month = "";
    switch (monthValue) {
      case "January":
        Month = "01";
        break;
      case "February":
        Month = "02";
        break;
      case "March":
        Month = "03";
        break;
      case "April":
        Month = "04";
        break;
      case "May":
        Month = "05";
        break;
      case "June":
        Month = "06";
        break;
      case "July":
        Month = "07";
        break;
      case "August":
        Month = "08";
        break;
      case "September":
        Month = "09";
        break;
      case "October":
        Month = "10";
        break;
      case "November":
        Month = "11";
        break;
      case "December":
        Month = "12";
    }
    return Month;
  }

  //List<String> monthList = monthName.Select((name, index) => new { value = index + 1, text = name }).ToList();
  String? monthValue = formatDate(DateTime.now(), [MM]).toString();
  String? yearValues = formatDate(DateTime.now(), [yyyy]).toString();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var height = size.height;
    //var width = size.width;
    return Scaffold(
      backgroundColor: kMainColor,
      appBar: AppBar(
        backgroundColor: kMainColor,
        elevation: 0.0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'Payslip',
          style: kTextStyle.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: GetBuilder(
          builder: (ReportController controller) {
            return controller.isnetpayLoding == true
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height / 1.10,
                        padding: const EdgeInsets.all(20.0),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30.0),
                            topRight: Radius.circular(30.0),
                          ),
                          color: kBgColor,
                        ),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Colors.white,
                              ),
                              child: Column(
                                children: [
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
                                                        255,
                                                        128,
                                                        126,
                                                        126,
                                                      ),
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
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
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Color.fromARGB(
                                                          255,
                                                          128,
                                                          126,
                                                          126,
                                                        ),
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                )
                                                .toList(),
                                            value: monthValue,
                                            onChanged: (String? value) {
                                              setState(() {
                                                monthValue = value;
                                              });
                                              changeMonthAndyear();
                                            },
                                            buttonStyleData: ButtonStyleData(
                                              height: 50,
                                              width: double.infinity,
                                              padding: const EdgeInsets.only(
                                                left: 14,
                                                right: 14,
                                              ),
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
                                                        const Radius.circular(
                                                          40,
                                                        ),
                                                    thickness:
                                                        WidgetStateProperty.all<
                                                          double
                                                        >(6),
                                                    thumbVisibility:
                                                        WidgetStateProperty.all<
                                                          bool
                                                        >(true),
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
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Color.fromARGB(
                                                        255,
                                                        128,
                                                        126,
                                                        126,
                                                      ),
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
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
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Color.fromARGB(
                                                          255,
                                                          128,
                                                          126,
                                                          126,
                                                        ),
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                )
                                                .toList(),
                                            value: yearValues,
                                            onChanged: (String? value) {
                                              setState(() {
                                                yearValues = value;
                                              });
                                              changeMonthAndyear();
                                            },
                                            buttonStyleData: ButtonStyleData(
                                              height: 50,
                                              width: 140,
                                              padding: const EdgeInsets.only(
                                                left: 14,
                                                right: 14,
                                              ),
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
                                                        const Radius.circular(
                                                          40,
                                                        ),
                                                    thickness:
                                                        WidgetStateProperty.all<
                                                          double
                                                        >(6),
                                                    thumbVisibility:
                                                        WidgetStateProperty.all<
                                                          bool
                                                        >(true),
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
                                  const SizedBox(height: 20.0),
                                  controller.earnFiledModel!.data!.isEmpty
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
                                                  'images/empty.png',
                                                ),
                                              ),
                                              const SizedBox(height: 20.0),
                                              Column(
                                                children: [
                                                  Text(
                                                    'No Data',
                                                    style: kTextStyle.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20.0,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        )
                                      : SizedBox(
                                          height: height * 0.65,
                                          child: SingleChildScrollView(
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    SizedBox(
                                                      // width: 120,
                                                      child: Text(
                                                        'Earning Heads',
                                                        style: kTextStyle
                                                            .copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      // width: 80,
                                                      child: Text(
                                                        'Amount',
                                                        style: kTextStyle
                                                            .copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const Divider(
                                                  thickness: 1.0,
                                                  color: kGreyTextColor,
                                                ),
                                                controller.isEarnLoding == true
                                                    ? const Center(
                                                        child:
                                                            CircularProgressIndicator(),
                                                      )
                                                    : SizedBox(
                                                        height:
                                                            height *
                                                            0.035 *
                                                            controller
                                                                .earnFiledModel!
                                                                .data!
                                                                .length,
                                                        child: ListView.builder(
                                                          itemCount: controller
                                                              .earnFiledModel
                                                              ?.data
                                                              ?.length,
                                                          itemBuilder: (context, index) {
                                                            return Column(
                                                              children: [
                                                                Padding(
                                                                  padding: EdgeInsets.symmetric(
                                                                    vertical:
                                                                        height *
                                                                        0.0015,
                                                                  ),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Text(
                                                                        controller.earnFiledModel?.data![index].prinTName ??
                                                                            "",
                                                                      ),
                                                                      Text(
                                                                        controller.earnFiledModel?.data![index].amount ??
                                                                            "",
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                const Divider(
                                                  thickness: 1.0,
                                                  color: kGreyTextColor,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    const Text(
                                                      "Gross Earnings",
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w800,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    Text(
                                                      controller
                                                              .netPayModel!
                                                              .data!
                                                              .isNotEmpty
                                                          ? controller
                                                                .netPayModel!
                                                                .data!
                                                                .first
                                                                .grosspay
                                                          : "",
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w800,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 20.0),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    SizedBox(
                                                      // width: 120,
                                                      child: Text(
                                                        'Deductions Heads',
                                                        style: kTextStyle
                                                            .copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      // width: 80,
                                                      child: Text(
                                                        'Amount',
                                                        style: kTextStyle
                                                            .copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const Divider(
                                                  thickness: 1.0,
                                                  color: kGreyTextColor,
                                                ),
                                                controller.isDedLoding == true
                                                    ? const Center(
                                                        child:
                                                            CircularProgressIndicator(),
                                                      )
                                                    : SizedBox(
                                                        height:
                                                            height *
                                                            0.04 *
                                                            controller
                                                                .dedFiledModel!
                                                                .data!
                                                                .length,
                                                        child: ListView.builder(
                                                          itemCount: controller
                                                              .dedFiledModel
                                                              ?.data
                                                              ?.length,
                                                          itemBuilder: (context, index) {
                                                            return Column(
                                                              children: [
                                                                Padding(
                                                                  padding: EdgeInsets.symmetric(
                                                                    vertical:
                                                                        height *
                                                                        0.0015,
                                                                  ),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Text(
                                                                        controller.dedFiledModel?.data![index].prinTName ??
                                                                            "",
                                                                      ),
                                                                      Text(
                                                                        controller.dedFiledModel?.data![index].amount ??
                                                                            "",
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                const Divider(
                                                  thickness: 1.0,
                                                  color: kGreyTextColor,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    const Text(
                                                      "Gross Deductions",
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w800,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    Text(
                                                      controller
                                                              .netPayModel!
                                                              .data!
                                                              .isNotEmpty
                                                          ? controller
                                                                .netPayModel!
                                                                .data!
                                                                .first
                                                                .grossded
                                                          : "",
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w800,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 20.0),
                                                const Divider(
                                                  thickness: 1.0,
                                                  color: kGreyTextColor,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    const Text(
                                                      "Net Payable",
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w800,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    Text(
                                                      controller
                                                              .netPayModel!
                                                              .data!
                                                              .isNotEmpty
                                                          ? controller
                                                                .netPayModel!
                                                                .data!
                                                                .first
                                                                .netpay
                                                          : "",
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w800,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 20.0),
                                              ],
                                            ),
                                          ),
                                        ),
                                ],
                              ),
                            ),
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
