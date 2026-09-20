import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:aeon_hrms/Screens/Leave%20Management/controller/leaveController.dart';
import 'package:aeon_hrms/Screens/Leave%20Management/view/leaveApprovalforAllDetils.dart';
import 'package:aeon_hrms/constant.dart';
import 'package:nb_utils/nb_utils.dart';

class LeaveApprovalDetails extends StatefulWidget {
  const LeaveApprovalDetails({super.key});

  @override
  _LeaveApprovalDetailsState createState() => _LeaveApprovalDetailsState();
}

class _LeaveApprovalDetailsState extends State<LeaveApprovalDetails> {
  final LeaveController leaveController = Get.put(LeaveController());
  final TextEditingController remarksController = TextEditingController();
  bool isApproved = false;
  bool isCheckbox = false;
  @override
  void dispose() {
    remarksController.text = "";
    leaveController.leaveApprovalDetailsModelList = [];
    super.dispose();
  }

  bool isMasterCheckboxSelected = false;
  @override
  void initState() {
    leaveController.getLeaveApprovelDetailsByMngrCodeandEmpcode();
    super.initState();
  }

  List<Map<String, dynamic>> dataList = [];

  void aprovedAllLeave() {
    dataList.clear();
    for (var element in leaveController.leaveApprovalDetailsModelList) {
      Map<String, dynamic> data = {
        'EMP_CODE': element.emPCode.toString(),
        'ID': element.id.toString(),
        'STATUS': "S",
        'MngrRemarks': remarksController.text,
      };
      dataList.add(data); // Add each data map to the list
    }
    print("Approve: $dataList");
    leaveController.saveLeaveSanctionByEmpCodeandId(context, dataList);
  }

  void rejectAllLeave() {
    for (var element in leaveController.leaveApprovalDetailsModelList) {
      Map<String, dynamic> data = {
        'EMP_CODE': element.emPCode.toString(),
        'ID': element.id.toString(),
        'STATUS': "R",
        'MngrRemarks': remarksController.text,
      };
      dataList.add(data); // Add each data map to the list
    }
    print("reject:$dataList");
    leaveController.saveLeaveSanctionByEmpCodeandId(context, dataList);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var height = size.height;
    var width = size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: kMainColor,
      appBar: AppBar(
        backgroundColor: kMainColor,
        elevation: 0.0,
        titleSpacing: 0.0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'Leave Approval List',
          maxLines: 2,
          style: kTextStyle.copyWith(
              color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
          child: GetBuilder(builder: (LeaveController controller) {
        for (int i = 0;
            i < (controller.leaveApprovalDetailsModel?.data?.length ?? 0);
            i++) {
          controller.ckeckBoxStatusList.add(false);
        }
        return controller.isMngrCodeandEmpcode == true
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
                        child: controller
                                .leaveApprovalDetailsModel!.data!.isEmpty
                            ? SizedBox(
                                height: height * 0.65,
                                width: width * 1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
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
                                  ListTile(
                                    onTap: () {},
                                    leading: Image.asset('images/emp1.png'),
                                    title: Text(
                                      controller.leaveApprovalDetailsModel!
                                              .data!.first.emPName ??
                                          "",
                                      style: kTextStyle,
                                    ),
                                    subtitle: Text(
                                      controller.leaveApprovalDetailsModel!
                                              .data!.first.emPCode ??
                                          "",
                                      style: kTextStyle.copyWith(
                                          color: kGreyTextColor),
                                    ),
                                    trailing: Checkbox(
                                      value: isCheckbox,
                                      onChanged: (value) {
                                        if (value == true) {
                                          for (int i = 0;
                                              i <
                                                  controller.ckeckBoxStatusList
                                                      .length;
                                              i++) {
                                            controller.ckeckBoxStatusList[i] =
                                                true;
                                          }
                                        } else {
                                          for (int i = 0;
                                              i <
                                                  controller.ckeckBoxStatusList
                                                      .length;
                                              i++) {
                                            controller.ckeckBoxStatusList[i] =
                                                false;
                                          }
                                        }
                                        isCheckbox = value!;
                                        setState(() {});
                                      },
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 130,
                                            child: Text(
                                              'L. Type',
                                              style: kTextStyle.copyWith(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 80,
                                            child: Text(
                                              'L. Date',
                                              style: kTextStyle.copyWith(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 50,
                                            child: Text(
                                              'Days',
                                              style: kTextStyle.copyWith(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          SizedBox(
                                            //width: 80,
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
                                      SizedBox(
                                        height: height * 0.425,
                                        child: ListView.builder(
                                          itemCount: controller
                                                  .leaveApprovalDetailsModel
                                                  ?.data
                                                  ?.length ??
                                              0,
                                          itemBuilder: (context, index) {
                                            return Row(
                                              children: [
                                                SizedBox(
                                                  child: Text(
                                                    controller
                                                            .leaveApprovalDetailsModel
                                                            ?.data?[index]
                                                            .lvdesc ??
                                                        "",
                                                    textAlign: TextAlign.start,
                                                    style: kTextStyle.copyWith(
                                                        color: kGreyTextColor),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 100,
                                                  child: Center(
                                                    child: Text(
                                                      "${controller.leaveApprovalDetailsModel?.data![index].atdate.toString().substring(0, 10)}",
                                                      style: kTextStyle.copyWith(
                                                          color:
                                                              kGreyTextColor),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 20,
                                                  child: Center(
                                                    child: Text(
                                                      controller
                                                              .leaveApprovalDetailsModel
                                                              ?.data![index]
                                                              .lvdays ??
                                                          "",
                                                      style: kTextStyle.copyWith(
                                                          color:
                                                              kGreyTextColor),
                                                    ),
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    leaveController.leavid =
                                                        controller
                                                            .leaveApprovalDetailsModel!
                                                            .data![index]
                                                            .id;
                                                    leaveController
                                                            .levAppEmpcode =
                                                        controller
                                                            .leaveApprovalDetailsModel!
                                                            .data![index]
                                                            .emPCode;
                                                    Get.to(() =>
                                                        const LeaveApprovalForEmpDetails());
                                                  },
                                                  child: const SizedBox(
                                                      width: 40,
                                                      child: Icon(
                                                          Icons.visibility)),
                                                ),
                                                Checkbox(
                                                  value: controller
                                                          .ckeckBoxStatusList[
                                                      index],
                                                  onChanged: (value) {
                                                    controller
                                                            .ckeckBoxStatusList[
                                                        index] = value!;
                                                    // setState(() {
                                                    if (controller
                                                        .leaveApprovalDetailsModelList
                                                        .contains(controller
                                                            .leaveApprovalDetailsModel!
                                                            .data![index])) {
                                                      controller
                                                          .leaveApprovalDetailsModelList
                                                          .remove(controller
                                                              .leaveApprovalDetailsModel!
                                                              .data![index]);
                                                    } else {
                                                      controller
                                                          .leaveApprovalDetailsModelList
                                                          .add(controller
                                                              .leaveApprovalDetailsModel!
                                                              .data![index]);
                                                    }

                                                    isCheckbox = controller
                                                        .ckeckBoxStatusList
                                                        .every(
                                                            (status) => status);
                                                    // isCheckbox = false;
                                                    // });4
                                                    // bool allTrue = false;

                                                    // for (int i = 0;
                                                    //     i <
                                                    //         controller
                                                    //             .ckeckBoxStatusList
                                                    //             .length;
                                                    //     i++) {
                                                    //   if (controller
                                                    //               .ckeckBoxStatusList[
                                                    //           i] ==
                                                    //       true) {
                                                    //     allTrue = true;
                                                    //   } else {
                                                    //     allTrue = false;
                                                    //   }
                                                    // }

                                                    // if (allTrue == true) {
                                                    //   isCheckbox = true;
                                                    //   // setState(() {});
                                                    // } else {
                                                    //   isCheckbox = false;
                                                    // }

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
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5.0,
                                  ),
                                  Visibility(
                                    visible: !isApproved,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                            onTap: () {
                                              aprovedAllLeave();
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
                                              rejectAllLeave();
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
                                                color: kAlertColor
                                                    .withValues(alpha: 0.1),
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
