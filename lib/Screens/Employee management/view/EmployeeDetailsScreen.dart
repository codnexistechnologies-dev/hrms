import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:aeon_hrms/Utility/shared_preferences_service.dart';
import 'package:aeon_hrms/constant.dart';
import 'package:nb_utils/nb_utils.dart';

import '../controller/employee_controller.dart';

class EmployeeDetailsScreen extends StatefulWidget {
  const EmployeeDetailsScreen({super.key});

  @override
  _EmployeeDetailsScreenState createState() => _EmployeeDetailsScreenState();
}

class _EmployeeDetailsScreenState extends State<EmployeeDetailsScreen>
    with TickerProviderStateMixin {
  final EmployeeController employeeController = Get.put(EmployeeController());
  late TabController _controller;
  final List<Tab> topTabs = <Tab>[
    Tab(text: 'General'),
    Tab(text: 'Official'),
    Tab(text: 'Other'),
  ];

  @override
  void initState() {
    super.initState();
    _controller = TabController(vsync: this, length: 3);
    employeeController.getEmployeeDetails();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //var size = MediaQuery.of(context).size;
    //var height = size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: kMainColor,
      appBar: AppBar(
        backgroundColor: kMainColor,
        elevation: 0.0,
        titleSpacing: 0.0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'Employee Details',
          maxLines: 2,
          style: kTextStyle.copyWith(
              color: Colors.white, fontWeight: FontWeight.bold),
        ),
        bottom: TabBar(
            controller: _controller,
            tabs: topTabs,
            labelColor: white,
            unselectedLabelColor: black),
      ),
      body: TabBarView(controller: _controller, children: [
        Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height / 1.15,
          padding: const EdgeInsets.all(12.0),
          color: Colors.white,
          child: GetBuilder(builder: (EmployeeController controller) {
            //int len = controller.attendanceHistModel?.data?.length ?? 0;
            return controller.isempDetailsLoading == true
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    child: Column(children: [
                      const SizedBox(
                        height: 20.0,
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              'Employee Code:-',
                              style: kTextStyle.copyWith(
                                  fontWeight: FontWeight.bold),
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
                                  fontWeight: FontWeight.bold),
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
                              'Date of Joining:-',
                              style: kTextStyle.copyWith(
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              employeeController.employeeDetailsModel?.data?.first.doj?.toString().substring(0, 10) ?? 'N/A',
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
                              'Date of Birth:-',
                              style: kTextStyle.copyWith(
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              employeeController.employeeDetailsModel!.data!.first.dob?.toString().substring(0, 10) ?? 'N/A',
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
                              'Gender:-',
                              style: kTextStyle.copyWith(
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(
                            child: Text(
                                employeeController.employeeDetailsModel!.data!.first.sex == 1 ? "Male" : employeeController.employeeDetailsModel!.data!.first.sex == 2 ? "Female" : ""),
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
                              'Email ID:-',
                              style: kTextStyle.copyWith(
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              '${employeeController.employeeDetailsModel!.data!.first.emailid ?? ""}',
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
                              'Mobile No.:-',
                              style: kTextStyle.copyWith(
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              '${employeeController.employeeDetailsModel!.data!.first.mobileno}',
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
                              'Permanent Address:-',
                              style: kTextStyle.copyWith(
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              '${employeeController.employeeDetailsModel!.data!.first.permanentaddress}',
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
                              'Temporary Address:-',
                              style: kTextStyle.copyWith(
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              '${employeeController.employeeDetailsModel!.data!.first.mailingaddress}',
                            ),
                          ),
                        ],
                      ),
                      const Divider(
                        thickness: 1.0,
                        height: 30,
                      ),
                    ]),
                  );
          }),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12.0),
          color: Colors.white,
          child: GetBuilder(builder: (EmployeeController controller) {
            //int len = controller.attendanceHistModel?.data?.length ?? 0;
            return controller.isempDetailsLoading == true
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    child: Column(children: [
                      const SizedBox(
                        height: 20.0,
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              'Designation:-',
                              style: kTextStyle.copyWith(
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              '${employeeController.employeeDetailsModel!.data!.first.dsGNAME ?? ""}',
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
                              'Department:-',
                              style: kTextStyle.copyWith(
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              '${employeeController.employeeDetailsModel!.data!.first.depTNAME ?? ""}',
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
                              'Location:-',
                              style: kTextStyle.copyWith(
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              '${employeeController.employeeDetailsModel!.data!.first.loCNAME ?? ""}',
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
                              'State:-',
                              style: kTextStyle.copyWith(
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              '${employeeController.employeeDetailsModel!.data!.first.state ?? ""}',
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
                              'Date of Confirmation:-',
                              style: kTextStyle.copyWith(
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              employeeController.employeeDetailsModel!.data!.first.doc?.toString().substring(0, 10) ?? 'N/A',
                            ),
                          ),
                        ],
                      ),
                      const Divider(
                        thickness: 1.0,
                        height: 30,
                      ),
                    ]),
                  );
          }),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12.0),
          color: Colors.white,
          child: GetBuilder(
            builder: (EmployeeController controller) {
              //int len = controller.attendanceHistModel?.data?.length ?? 0;
              return SingleChildScrollView(
                child: controller.isempDetailsLoading == true
                    ? const Center(child: CircularProgressIndicator())
                    : Column(children: [
                        const SizedBox(
                          height: 20.0,
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Text(
                                'Bank Name:-',
                                style: kTextStyle.copyWith(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                '${employeeController.employeeDetailsModel!.data!.first.banKNAME ?? ""}',
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
                                'IFSC Code:-',
                                style: kTextStyle.copyWith(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                '${employeeController.employeeDetailsModel!.data!.first.ifsc ?? ""}',
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
                                'Bank A/C No.:-',
                                style: kTextStyle.copyWith(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                '${employeeController.employeeDetailsModel!.data!.first.bankacno ?? ""}',
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
                                'PF No.:-',
                                style: kTextStyle.copyWith(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                '${employeeController.employeeDetailsModel!.data!.first.pfno ?? ""}',
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
                                'ESI No:-',
                                style: kTextStyle.copyWith(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                '${employeeController.employeeDetailsModel!.data!.first.esino ?? ""}',
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
                                'PAN:-',
                                style: kTextStyle.copyWith(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                '${employeeController.employeeDetailsModel!.data!.first.panno}',
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
                                'Aadhar No.:-',
                                style: kTextStyle.copyWith(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                  '${employeeController.employeeDetailsModel!.data!.first.adhaRNO}'),
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
                                'UANNO:-',
                                style: kTextStyle.copyWith(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                '${employeeController.employeeDetailsModel!.data!.first.uanno}',
                              ),
                            ),
                          ],
                        ),
                        const Divider(
                          thickness: 1.0,
                          height: 30,
                          //color: kGreyTextColor,
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Text(
                                'Voter Id No.-',
                                style: kTextStyle.copyWith(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                '${employeeController.employeeDetailsModel!.data!.first.voteRID}',
                              ),
                            ),
                          ],
                        ),
                        const Divider(
                          thickness: 1.0,
                          height: 30,
                        ),
                      ]),
              );
            },
          ),
        ),
      ]),
    );
  }
}
