// ignore: file_names
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:aeon_hrms/Screens/Leave%20Management/controller/leaveController.dart';
import 'package:aeon_hrms/constant.dart';

class LeaveCancellation extends StatefulWidget {
  const LeaveCancellation({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LeaveCancellationState createState() => _LeaveCancellationState();
}

class _LeaveCancellationState extends State<LeaveCancellation> {
  String leaveType = '';
  String type = '';
  bool selection = false;
  final LeaveController leaveController = Get.put(LeaveController());

  @override
  void dispose() {
    //dateController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    leaveController.getLeaveCancelationDetailsByEmpcode();
    super.initState();
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kMainColor,
      appBar: AppBar(
        backgroundColor: kMainColor,
        elevation: 0.0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'Leave Cancellation',
          style: kTextStyle.copyWith(
              color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: GetBuilder(
          builder: (LeaveController controller) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20.0,
                ),
                Container(
                  width: double.infinity,
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
                            const SizedBox(
                              height: 20.0,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 120,
                                      child: Text(
                                        'Leave Type',
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
                                      width: 30,
                                      child: Text(
                                        'Days',
                                        style: kTextStyle.copyWith(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 60,
                                      child: Text(
                                        'Status',
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
                                controller.isLoading == true
                                    ? const Center(
                                        child: CircularProgressIndicator())
                                    : SizedBox(
                                        height: 400,
                                        child: ListView.builder(
                                          itemCount: controller
                                              .leaveStatusModel?.data?.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 5.0),
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
                                                          style: kTextStyle
                                                              .copyWith(
                                                                  color:
                                                                      kGreyTextColor),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 80,
                                                        child: Text(
                                                          controller
                                                                  .leaveStatusModel
                                                                  ?.data![index]
                                                                  .atdate
                                                                  .toString()
                                                                  .substring(
                                                                      0, 10) ??
                                                              "",
                                                          style: kTextStyle
                                                              .copyWith(
                                                                  color:
                                                                      kGreyTextColor),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 30,
                                                        // color: Colors.grey,
                                                        child: Center(
                                                          child: Text(
                                                            controller
                                                                    .leaveStatusModel
                                                                    ?.data![
                                                                        index]
                                                                    .lvdays ??
                                                                "",
                                                            style: kTextStyle
                                                                .copyWith(
                                                                    color:
                                                                        kGreyTextColor),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 60,
                                                        // color: Colors.grey,
                                                        child: Center(
                                                          child: Text(
                                                            controller
                                                                    .leaveStatusModel
                                                                    ?.data![
                                                                        index]
                                                                    .status ??
                                                                "",
                                                            style: kTextStyle
                                                                .copyWith(
                                                                    color:
                                                                        kGreyTextColor),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const Divider(
                                                    thickness: 0.3,
                                                    color: Colors.black,
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
