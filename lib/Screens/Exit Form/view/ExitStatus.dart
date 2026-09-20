// ignore: file_names
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:aeon_hrms/Screens/Exit%20Form/controller/ExitController.dart';
import 'package:aeon_hrms/Utility/shared_preferences_service.dart';
import 'package:aeon_hrms/constant.dart';

class ExitStatus extends StatefulWidget {
  const ExitStatus({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ExitStatusState createState() => _ExitStatusState();
}

class _ExitStatusState extends State<ExitStatus> {
  String leaveType = '';
  String type = '';
  bool selection = false;
  final ExitController exitController = Get.put(ExitController());

  @override
  void dispose() {
    //leaveController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    exitController.GetSeparationFormStatusByEmpCode();
    super.initState();
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
          'Exit Status',
          style: kTextStyle.copyWith(
              color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: GetBuilder(
          builder: (ExitController controller) {
            return controller.isExitFormByEmpCode == true
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 10.0,
                      ),
                      Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height / 1.15,
                        padding: const EdgeInsets.all(10.0),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20.0),
                              topRight: Radius.circular(20.0)),
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
                                  controller.resignationAppStatusByEmpCode!
                                          .data!.isEmpty
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
                                                Expanded(
                                                  flex: 1,
                                                  child: Text(
                                                    'Employee Code:-',
                                                    style: kTextStyle.copyWith(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    SharedPref.getEmpCode(),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const Divider(
                                              thickness: 1.0,
                                              height: 30,
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  flex: 1,
                                                  child: Text(
                                                    'Employee Name:-',
                                                    style: kTextStyle.copyWith(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    SharedPref.getEmpName(),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const Divider(
                                              thickness: 1.0,
                                              height: 30,
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  flex: 1,
                                                  child: Text(
                                                    'Last Working Day:-',
                                                    style: kTextStyle.copyWith(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    exitController.resignationAppStatusByEmpCode!.data!.first.resignationdate.toString().substring(0, 10),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const Divider(
                                              thickness: 1.0,
                                              height: 30,
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  flex: 1,
                                                  child: Text(
                                                    'Notice Period(Days):-',
                                                    style: kTextStyle.copyWith(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    '${exitController.resignationAppStatusByEmpCode!.data!.first.noticeperiodserved ?? ""}',
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const Divider(
                                              thickness: 1.0,
                                              height: 30,
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  flex: 1,
                                                  child: Text(
                                                    'Date of Resignation:-',
                                                    style: kTextStyle.copyWith(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    exitController.resignationAppStatusByEmpCode!.data!.first.releavingdate.toString().substring(0, 10),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const Divider(
                                              thickness: 1.0,
                                              height: 30,
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  flex: 1,
                                                  child: Text(
                                                    'Reason For Leave:-',
                                                    style: kTextStyle.copyWith(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    exitController.resignationAppStatusByEmpCode!.data!.first.emPREMARKS ?? "",
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const Divider(
                                              thickness: 1.0,
                                              height: 30,
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  flex: 1,
                                                  child: Text(
                                                    'Status:-',
                                                    style: kTextStyle.copyWith(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    'Pending',
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const Divider(
                                              thickness: 1.0,
                                              height: 30,
                                            ),
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
