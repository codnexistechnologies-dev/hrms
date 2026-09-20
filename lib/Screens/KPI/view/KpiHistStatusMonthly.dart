// ignore: file_names
import 'package:date_format/date_format.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:aeon_hrms/Screens/KPI/controller/KpiMasterController.dart';
import 'package:aeon_hrms/constant.dart';

class KpiHistStatusMonthly extends StatefulWidget {
  const KpiHistStatusMonthly({super.key});

  @override
  _KpiHistStatusMonthlyState createState() => _KpiHistStatusMonthlyState();
}

class _KpiHistStatusMonthlyState extends State<KpiHistStatusMonthly> {
  String leaveType = '';
  String type = '';
  bool selection = false;
  final KpiMasterController kpiMasterController =
      Get.put(KpiMasterController());

  @override
  void dispose() {
    //dateController.dispose();
    super.dispose();
  }

  String? monthValue = formatDate(DateTime.now(), [MM]).toString();
  String? yearValues = formatDate(DateTime.now(), [yyyy]).toString();

  @override
  void initState() {
    kpiMasterController.GetKpiMaster_and_Kpihist_Total_By_Emp_code_and_Paydate(
        "$yearValues-$monthValue-01");
    kpiMasterController.GetKpiHistByEmpCodeandPayDate(
        "$yearValues-$monthValue-01");
    super.initState();
  }

  void GetKpiHistDataMonthly() {
    if (monthValue == "" || monthValue == null) {
      monthValue = formatDate(DateTime.now(), [MM]).toString();
    }
    if (yearValues == "" || yearValues == null) {
      yearValues = formatDate(DateTime.now(), [yyyy]).toString();
    }
    kpiMasterController.GetKpiMaster_and_Kpihist_Total_By_Emp_code_and_Paydate(
        "$yearValues-$monthValue-01");
    kpiMasterController.GetKpiHistByEmpCodeandPayDate(
        "$yearValues-$monthValue-01");
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
          'Kpi Status',
          style: kTextStyle.copyWith(
              color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: GetBuilder(
        builder: (KpiMasterController controller) {
          return controller.isKpiHistMonthlyLoading == true &&
                  controller.isKpiMasterMonthlyTotal == true
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
                            horizontal: 15.0, vertical: 15),
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
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ))
                                          .toList(),
                                      value: monthValue,
                                      onChanged: (String? value) {
                                        setState(() {
                                          monthValue = value;
                                        });
                                        GetKpiHistDataMonthly();
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
                                          borderRadius:
                                              BorderRadius.circular(5),
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
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ))
                                          .toList(),
                                      value: yearValues,
                                      onChanged: (String? value) {
                                        setState(() {
                                          yearValues = value;
                                        });
                                        GetKpiHistDataMonthly();
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
                                          borderRadius:
                                              BorderRadius.circular(5),
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
                              height: 15.0,
                            ),
                            controller.kpiHistByEmpCodeandAtdateModel!.data!
                                        .isEmpty &&
                                    controller.kpiMaterEmpCodeandpaydateModel!
                                        .data!.isEmpty
                                ? SizedBox(
                                    height:
                                        MediaQuery.of(context).size.height / 2,
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
                                      Container(
                                        // decoration: BoxDecoration(
                                        //     border: Border.all(color: Colors.grey)),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  flex: 2,
                                                  child: Text(
                                                    'NAME',
                                                    style: kTextStyle.copyWith(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: Center(
                                                    child: Text(
                                                      'FM',
                                                      style:
                                                          kTextStyle.copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: Center(
                                                    child: Text(
                                                      'FD',
                                                      style:
                                                          kTextStyle.copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: Center(
                                                    child: Text(
                                                      'DEMO',
                                                      style:
                                                          kTextStyle.copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: Center(
                                                    child: Text(
                                                      'FAR',
                                                      style:
                                                          kTextStyle.copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: Center(
                                                    child: Text(
                                                      'LIQ',
                                                      style:
                                                          kTextStyle.copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: Center(
                                                    child: Text(
                                                      'COLL',
                                                      style:
                                                          kTextStyle.copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const Divider(
                                              thickness: 1.0,
                                              color: kGreyTextColor,
                                            ),
                                            controller.isKpiMasterMonthlyTotal ==
                                                    true
                                                ? const Center(
                                                    child:
                                                        CircularProgressIndicator())
                                                : SizedBox(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height /
                                                            6.5,
                                                    child: ListView.builder(
                                                      itemCount: controller
                                                          .kpiMaterEmpCodeandpaydateModel
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
                                                                  Expanded(
                                                                    flex: 2,
                                                                    child: Text(
                                                                      kpiMasterController
                                                                              .kpiMaterEmpCodeandpaydateModel
                                                                              ?.data![index]
                                                                              .kpIMASTERREMARKS
                                                                              .toString() ??
                                                                          "",
                                                                      style: kTextStyle.copyWith(
                                                                          color:
                                                                              kGreyTextColor),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    flex: 1,
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Text(
                                                                        kpiMasterController.kpiMaterEmpCodeandpaydateModel?.data![index].fMPLANMASTER.toString() ??
                                                                            "",
                                                                        style: kTextStyle.copyWith(
                                                                            color:
                                                                                kGreyTextColor),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    flex: 1,
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Text(
                                                                        kpiMasterController.kpiMaterEmpCodeandpaydateModel?.data![index].fDPLANMASTER.toString() ??
                                                                            "",
                                                                        style: kTextStyle.copyWith(
                                                                            color:
                                                                                kGreyTextColor),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    flex: 1,
                                                                    // color: Colors.grey,
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Text(
                                                                        kpiMasterController.kpiMaterEmpCodeandpaydateModel?.data![index].demOMASTER.toString() ??
                                                                            "",
                                                                        style: kTextStyle.copyWith(
                                                                            color:
                                                                                kGreyTextColor),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    flex: 1,
                                                                    // color: Colors.grey,
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Text(
                                                                        kpiMasterController.kpiMaterEmpCodeandpaydateModel?.data![index].farmerdatAMASTER.toString() ??
                                                                            "",
                                                                        style: kTextStyle.copyWith(
                                                                            color:
                                                                                kGreyTextColor),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    flex: 1,
                                                                    // color: Colors.grey,
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Text(
                                                                        kpiMasterController.kpiMaterEmpCodeandpaydateModel?.data![index].liquidatioNMASTER.toString() ??
                                                                            "",
                                                                        style: kTextStyle.copyWith(
                                                                            color:
                                                                                kGreyTextColor),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    flex: 1,
                                                                    // color: Colors.grey,
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Text(
                                                                        kpiMasterController.kpiMaterEmpCodeandpaydateModel?.data![index].collectioNMASTER.toString() ??
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
                                      ),
                                      Container(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  flex: 2,
                                                  child: Text(
                                                    'DATE',
                                                    style: kTextStyle.copyWith(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: Center(
                                                    child: Text(
                                                      'FM',
                                                      style:
                                                          kTextStyle.copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: Center(
                                                    child: Text(
                                                      'FD',
                                                      style:
                                                          kTextStyle.copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: Center(
                                                    child: Text(
                                                      'DEMO',
                                                      style:
                                                          kTextStyle.copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: Center(
                                                    child: Text(
                                                      'FAR',
                                                      style:
                                                          kTextStyle.copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: Center(
                                                    child: Text(
                                                      'LIQ',
                                                      style:
                                                          kTextStyle.copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: Center(
                                                    child: Text(
                                                      'COLL',
                                                      style:
                                                          kTextStyle.copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const Divider(
                                              thickness: 1.0,
                                              color: kGreyTextColor,
                                            ),
                                            controller.isKpiHistMonthlyLoading ==
                                                    true
                                                ? const Center(
                                                    child:
                                                        CircularProgressIndicator())
                                                : SizedBox(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height /
                                                            2.20,
                                                    //height: 800,
                                                    child: ListView.builder(
                                                      itemCount: controller
                                                          .kpiHistByEmpCodeandAtdateModel
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
                                                                  Expanded(
                                                                    flex: 2,
                                                                    child: Text(
                                                                      kpiMasterController
                                                                              .kpiHistByEmpCodeandAtdateModel
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
                                                                  Expanded(
                                                                    flex: 1,
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Text(
                                                                        kpiMasterController.kpiHistByEmpCodeandAtdateModel?.data![index].actuaLFMPLAN.toString() ??
                                                                            "",
                                                                        style: kTextStyle.copyWith(
                                                                            color:
                                                                                kGreyTextColor),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    flex: 1,
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Text(
                                                                        kpiMasterController.kpiHistByEmpCodeandAtdateModel?.data![index].actuaLFDPLAN.toString() ??
                                                                            "",
                                                                        style: kTextStyle.copyWith(
                                                                            color:
                                                                                kGreyTextColor),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    flex: 1,
                                                                    // color: Colors.grey,
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Text(
                                                                        kpiMasterController.kpiHistByEmpCodeandAtdateModel?.data![index].actuaLDEMO.toString() ??
                                                                            "",
                                                                        style: kTextStyle.copyWith(
                                                                            color:
                                                                                kGreyTextColor),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    flex: 1,
                                                                    // color: Colors.grey,
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Text(
                                                                        kpiMasterController.kpiHistByEmpCodeandAtdateModel?.data![index].actuaLFARMERDATA.toString() ??
                                                                            "",
                                                                        style: kTextStyle.copyWith(
                                                                            color:
                                                                                kGreyTextColor),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    flex: 1,
                                                                    // color: Colors.grey,
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Text(
                                                                        kpiMasterController.kpiHistByEmpCodeandAtdateModel?.data![index].actuaLLIQUIDATION.toString() ??
                                                                            "",
                                                                        style: kTextStyle.copyWith(
                                                                            color:
                                                                                kGreyTextColor),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    flex: 1,
                                                                    // color: Colors.grey,
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Text(
                                                                        kpiMasterController.kpiHistByEmpCodeandAtdateModel?.data![index].actuaLCOLLECTION.toString() ??
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
                                      ),
                                    ],
                                  ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
        },
      ),
    );
  }
}
