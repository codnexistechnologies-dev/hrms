import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:aeon_hrms/Screens/Time%20Attendence/controller/attendance_controller.dart';
import 'package:aeon_hrms/constant.dart';
import 'package:nb_utils/nb_utils.dart';
// import 'package:nb_utils/nb_utils.dart';
// import 'package:percent_indicator/circular_percent_indicator.dart';

class AttendanceRegApprovalList extends StatefulWidget {
  const AttendanceRegApprovalList({super.key});

  @override
  _AttendanceRegApprovalListState createState() =>
      _AttendanceRegApprovalListState();
}

class _AttendanceRegApprovalListState extends State<AttendanceRegApprovalList> {
  final AttendanceController attendanceController =
      Get.put(AttendanceController());
  final TextEditingController remarksController = TextEditingController();
  bool isApproved = false;
  bool isCheckbox = false;
  @override
  void dispose() {
    remarksController.text = "";
    attendanceController.attendanceApprovalDetailsModelList = [];
    super.dispose();
    super.dispose();
  }

  bool isMasterCheckboxSelected = false;

  @override
  void initState() {
    attendanceController.getAttRegApprovalListByEmpcode();
    super.initState();
  }

  List<Map<String, dynamic>> dataList = [];
  void aprovedAllAttendanceApproval() {
    dataList.clear();
    for (var element
        in attendanceController.AttendanceApprovalDetailsModelList) {
      Map<String, dynamic> data = {
        'EMP_CODE': element.emPCode.toString(),
        'ATDATE': element.atdate.toString(),
        'Status': "S",
        'IN_TIME': element.iNTime,
        'OUT_TIME': element.ouTTime,
        'Mngr_code': element.mngrCode
        //'MngrRemarks': remarksController.text,
      };
      dataList.add(data); // Add each data map to the list
    }
    print("Approve: $dataList");
    attendanceController.SaveAttendandanceApprovalByEmpCodeandAtdate(
        context, dataList);
  }

  void rejectAllAttendanceApproval() {
    for (var element
        in attendanceController.attendanceApprovalDetailsModelList) {
      Map<String, dynamic> data = {
        'EMP_CODE': element.emPCode.toString(),
        'ATDATE': element.atdate.toString(),
        'Status': "R",
        'IN_TIME': element.iNTime,
        'OUT_TIME': element.ouTTime,
        'Mngr_code': element.mngrCode,
      };
      dataList.add(data); // Add each data map to the list
    }
    print("reject:$dataList");
    attendanceController.SaveAttendandanceApprovalByEmpCodeandAtdate(
        context, dataList);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var height = size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: kMainColor,
      appBar: AppBar(
        backgroundColor: kMainColor,
        elevation: 0.0,
        titleSpacing: 0.0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'Attendance Approval List',
          maxLines: 2,
          style: kTextStyle.copyWith(
              color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
          child: GetBuilder(builder: (AttendanceController controller) {
        return controller.isApprovalListLoading == true
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
                      // const SizedBox(
                      //   height: 20.0,
                      // ),
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
                                controller.attendanceRegApprovelListModel!.data!
                                        .first.emPName ??
                                    "",
                                style: kTextStyle,
                              ),
                              subtitle: Text(
                                controller.attendanceRegApprovelListModel!.data!
                                        .first.emPCode ??
                                    "",
                                style:
                                    kTextStyle.copyWith(color: kGreyTextColor),
                              ),
                              trailing: Checkbox(
                                value: isCheckbox,
                                onChanged: (value) {
                                  setState(() {
                                    isCheckbox = value!;
                                  });
                                  controller.updateCheckBox(value);
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 100,
                                      child: Text(
                                        'Atdate',
                                        style: kTextStyle.copyWith(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 70,
                                      child: Text(
                                        'InTime',
                                        style: kTextStyle.copyWith(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 80,
                                      child: Text(
                                        'OutTime',
                                        style: kTextStyle.copyWith(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    SizedBox(
                                      // width: 80,
                                      child: Text(
                                        'Action',
                                        style: kTextStyle.copyWith(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(
                                  thickness: 1.0,
                                  color: kGreyTextColor,
                                ),
                                // const SizedBox(
                                //   height: .0,
                                // ),
                                SizedBox(
                                  height: height * 0.425,
                                  child: ListView.builder(
                                    itemCount: controller
                                            .attendanceRegApprovelListModel
                                            ?.data
                                            ?.length ??
                                        0,
                                    itemBuilder: (context, index) {
                                      return Row(
                                        children: [
                                          SizedBox(
                                            width: 90,
                                            child: Text(
                                              controller
                                                      .attendanceRegApprovelListModel
                                                      ?.data?[index]
                                                      .atdate
                                                      .toString()
                                                      .substring(0, 10) ??
                                                  "",
                                              textAlign: TextAlign.start,
                                              style: kTextStyle.copyWith(
                                                  color: kGreyTextColor),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 75,
                                            child: Center(
                                              child: Text(
                                                "${controller.attendanceRegApprovelListModel?.data![index].iNTime}",
                                                style: kTextStyle.copyWith(
                                                    color: kGreyTextColor),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 60,
                                            child: Center(
                                              child: Text(
                                                controller
                                                        .attendanceRegApprovelListModel
                                                        ?.data![index]
                                                        .ouTTime ??
                                                    "",
                                                style: kTextStyle.copyWith(
                                                    color: kGreyTextColor),
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              // leaveController.leavid = controller
                                              //     .leaveApprovelDetailsModel!
                                              //     .data![index]
                                              //     .id;
                                              // leaveController.levAppEmpcode =
                                              //     controller
                                              //         .leaveApprovelDetailsModel!
                                              //         .data![index]
                                              //         .emPCode;
                                              // Get.to(() =>
                                              //     LeaveApprovelForEmpDetails());
                                              // Get.back();
                                              //print("index${index}");
                                            },
                                            child: const SizedBox(
                                                width: 40,
                                                child: Icon(Icons.visibility)),
                                          ),
                                          Checkbox(
                                            value: controller
                                                .ckeckBoxStatusList[index],
                                            onChanged: (value) {
                                              controller.ckeckBoxStatusList[
                                                  index] = value!;
                                              setState(() {});
                                            },
                                          )
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            AppTextField(
                              controller: remarksController,
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
                              height: 5.0,
                            ),
                            Visibility(
                              visible: !isApproved,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                      onTap: () {
                                        aprovedAllAttendanceApproval();
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
                                          color: kMainColor,
                                        ),
                                        child: Text(
                                          'Approve',
                                          style: kTextStyle.copyWith(
                                            color: Colors.white,
                                          ),
                                        ),
                                      )),
                                  const SizedBox(
                                    width: 10.0,
                                  ),
                                  GestureDetector(
                                      onTap: () {
                                        rejectAllAttendanceApproval();
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
