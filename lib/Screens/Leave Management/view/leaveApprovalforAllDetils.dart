import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:aeon_hrms/Screens/Leave%20Management/controller/leaveController.dart';
import 'package:aeon_hrms/constant.dart';
import 'package:nb_utils/nb_utils.dart';
// import 'package:nb_utils/nb_utils.dart';
// import 'package:percent_indicator/circular_percent_indicator.dart';

class LeaveApprovalForEmpDetails extends StatefulWidget {
  const LeaveApprovalForEmpDetails({
    super.key,
  });

  @override
  _LeaveApprovalForEmpDetailsState createState() =>
      _LeaveApprovalForEmpDetailsState();
}

class _LeaveApprovalForEmpDetailsState
    extends State<LeaveApprovalForEmpDetails> {
  final LeaveController leaveController = Get.put(LeaveController());
  final TextEditingController leaveTypeController = TextEditingController();
  final TextEditingController leaveDateController = TextEditingController();
  final TextEditingController appDateController = TextEditingController();
  final TextEditingController daysController = TextEditingController();
  final TextEditingController statusController = TextEditingController();
  final TextEditingController reasionController = TextEditingController();
  final TextEditingController halfDayController = TextEditingController();
  final TextEditingController mngrRemarksController = TextEditingController();

  @override
  void dispose() {
    leaveTypeController.text = "";
    leaveDateController.text = "";
    appDateController.text = "";
    statusController.text = "";
    reasionController.text = "";
    halfDayController.text = "";
    mngrRemarksController.text = "";
    leaveController.leavid = "";
    //leaveController.levAppEmpcode = "";
    super.dispose();
  }

// List<bool> ckeckBoxStatusList = [];
  @override
  void initState() {
    leaveController.getLeaveApprovelDetailsByEmpcodeandId();
    super.initState();
  }

  List<Map<String, dynamic>> dataList = [];
  void approveLeave() {
    final Map<String, dynamic> data = <String, dynamic>{
      'EMP_CODE': leaveController.levAppEmpcode,
      'ID': leaveController.leavid,
      'STATUS': "S",
      'MngrRemarks': mngrRemarksController.text,
    };
    dataList.add(data);
    leaveController.saveLeaveSanctionByEmpCodeandIdByDetails(context, dataList);
  }

  void rejectLeave() {
    final Map<String, dynamic> data = <String, dynamic>{
      'EMP_CODE': leaveController.levAppEmpcode,
      'ID': leaveController.leaveTypeId,
      'STATUS': "R",
      'MngrRemarks': mngrRemarksController.text,
    };
    dataList.add(data);
    leaveController.saveLeaveSanctionByEmpCodeandIdByDetails(context, dataList);
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
          'Leave Approval Details',
          maxLines: 2,
          style: kTextStyle.copyWith(
              color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
          child: GetBuilder(builder: (LeaveController controller) {
        return controller.isLeaveapprovelid == true
            ? const Center(child: CircularProgressIndicator())
            : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const SizedBox(
                  height: 10.0,
                ),
                Container(
                  //width: context.width(),
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
                            ListTile(
                              onTap: () {},
                              leading: Image.asset('images/emp1.png'),
                              title: Text(
                                controller.leaveApprovalEmpModel!.data!.first
                                        .emPName ??
                                    "",
                                style: kTextStyle,
                              ),
                              subtitle: Text(
                                controller.leaveApprovalEmpModel!.data!.first
                                        .emPCode ??
                                    "",
                                style:
                                    kTextStyle.copyWith(color: kGreyTextColor),
                              ),
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            Row(children: [
                              Expanded(
                                child: AppTextField(
                                  controller: leaveDateController
                                    ..text = controller.leaveApprovalEmpModel!
                                        .data!.first.atdate
                                        .toString()
                                        .substring(0, 10),
                                  textFieldType: TextFieldType.NAME,
                                  decoration: const InputDecoration(
                                    labelText: 'Leave Date',
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
                                  controller: appDateController
                                    ..text = controller.leaveApprovalEmpModel!
                                        .data!.first.appdate
                                        .toString()
                                        .substring(0, 10),
                                  textFieldType: TextFieldType.NAME,
                                  decoration: const InputDecoration(
                                    labelText: 'Application Date',
                                    enabled: false,
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    // hintText:
                                    //     '${controller.employeeDetailsModel?.data?.first.emailId}',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                            ]),
                            const SizedBox(
                              height: 20.0,
                            ),
                            Row(children: [
                              Expanded(
                                flex: 2,
                                child: AppTextField(
                                  controller: leaveTypeController
                                    ..text = controller.leaveApprovalEmpModel!
                                        .data!.first.lvdesc,
                                  textFieldType: TextFieldType.NAME,
                                  decoration: const InputDecoration(
                                    labelText: 'Leave Type',
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
                                flex: 1,
                                child: AppTextField(
                                  controller: halfDayController
                                    ..text = controller.leaveApprovalEmpModel!
                                        .data!.first.halFDay,
                                  textFieldType: TextFieldType.NAME,
                                  decoration: const InputDecoration(
                                    labelText: 'Type',
                                    enabled: false,
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    // hintText:
                                    //     '${controller.employeeDetailsModel?.data?.first.emailId}',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              )
                            ]),
                            const SizedBox(
                              height: 20.0,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: AppTextField(
                                    controller: statusController
                                      ..text = controller.leaveApprovalEmpModel
                                              ?.data?.first.status ??
                                          "",
                                    textFieldType: TextFieldType.NAME,
                                    decoration: const InputDecoration(
                                      labelText: "Status",
                                      enabled: false,
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
                                      hintText: "Status",
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10.0,
                                ),
                                Expanded(
                                  flex: 1,
                                  child: AppTextField(
                                    controller: daysController
                                      ..text = controller.leaveApprovalEmpModel
                                              ?.data?.first.lvdays ??
                                          "",
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
                              ],
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            AppTextField(
                              controller: reasionController
                                ..text = controller
                                    .leaveApprovalEmpModel?.data?.first.reason,
                              textFieldType: TextFieldType.MULTILINE,
                              decoration: const InputDecoration(
                                labelText: 'Reason',
                                enabled: false,
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
                            AppTextField(
                              controller: mngrRemarksController,
                              textFieldType: TextFieldType.MULTILINE,
                              decoration: const InputDecoration(
                                labelText: 'Mngr Remarks',
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    approveLeave();
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                      left: 30.0,
                                      right: 30.0,
                                      top: 10.0,
                                      bottom: 10.0,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: kMainColor,
                                    ),
                                    child: Text(
                                      'Approve',
                                      style: kTextStyle.copyWith(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10.0,
                                ),
                                GestureDetector(
                                    onTap: () {
                                      rejectLeave();
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.only(
                                          left: 30.0,
                                          right: 30.0,
                                          top: 10.0,
                                          bottom: 10.0),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        color: kAlertColor.withValues(alpha: 0.1),
                                      ),
                                      child: Text(
                                        'Reject',
                                        style: kTextStyle.copyWith(
                                          color: kAlertColor,
                                        ),
                                      ),
                                    ))
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ]);
      })),
    );
  }
}
