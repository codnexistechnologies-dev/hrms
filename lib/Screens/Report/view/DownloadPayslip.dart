// ignore: file_names
import 'package:date_format/date_format.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:aeon_hrms/GlobalComponents/button_global.dart';
import 'package:aeon_hrms/Screens/Report/controller/ReportController.dart';
import 'package:aeon_hrms/constant.dart';

class DownloadPayslip extends StatefulWidget {
  const DownloadPayslip({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DownloadPayslipState createState() => _DownloadPayslipState();
}

class _DownloadPayslipState extends State<DownloadPayslip> {
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
    //changeMonthAndyear();
    super.initState();
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
              color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: GetBuilder(
          builder: (ReportController controller) {
            return controller.isnetpayLoding == true
                ? const Center(child: CircularProgressIndicator())
                : Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                    Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height / 1.10,
                        padding: const EdgeInsets.all(20.0),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30.0),
                              topRight: Radius.circular(30.0)),
                          color: kBgColor,
                        ),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: Colors.white),
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
                                  Obx(
                                    () => ButtonGlobal(
                                      buttontext: reportController
                                                  .ispayslipLoding.value ==
                                              true
                                          ? "Processing..."
                                          : 'Download',
                                      buttonDecoration: kButtonDecoration
                                          .copyWith(color: kMainColor),
                                      onPressed: () async {
                                        if (controller.ispayslipLoding.value ==
                                            false) {
                                          await reportController
                                              .getPaySlipDetailsByEmpCodeMonthYear(
                                                  context,
                                                  monthValue!,
                                                  yearValues!);
                                        }
                                      },
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20.0,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ))
                  ]);
          },
        ),
      ),
    );
  }
}
