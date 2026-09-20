// ignore: file_names
import 'package:aeon_hrms/Screens/KPI%20Management/Demo%20Plan/controller/DemoPlanController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:aeon_hrms/Screens/Leave%20Management/controller/leaveController.dart';
import 'package:aeon_hrms/constant.dart';
import 'package:nb_utils/nb_utils.dart';

class DemoPlanStatus extends StatefulWidget {
  const DemoPlanStatus({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DemoPlanStatusState createState() => _DemoPlanStatusState();
}

class _DemoPlanStatusState extends State<DemoPlanStatus> {
  String leaveType = '';
  String type = '';
  bool selection = false;
  final DemoPlanController demoplanController = Get.put(DemoPlanController());
  final TextEditingController atdateController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    atdateController.text = DateTime.now().toString().substring(0, 10);
    // attendanceController
    //     .getAttRegProcessDisplay(DateTime.now().toString().substring(0, 10));
  }

  void fillDate(String atdate) {
    atdateController.text = atdate;
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
          'Demo Plan Status',
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
                                      fillDate(
                                          date.toString().substring(0, 10));
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
                                      // hintText:
                                      //     '${controller.attendanceRegModel!.data!.isEmpty ? DateTime.now().toString().substring(0, 10) : controller.attendanceRegModel?.data?.first.atdate.toString().substring(0, 10)}',
                                    ),
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
