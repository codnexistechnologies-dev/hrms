import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:aeon_hrms/Screens/Leave%20Management/controller/leaveController.dart';
import 'package:aeon_hrms/Screens/Time%20Attendence/view/attendence_management.dart';
import 'package:aeon_hrms/constant.dart';
import 'package:nb_utils/nb_utils.dart';

class LeaveCancellationEmpDetails extends StatefulWidget {
  const LeaveCancellationEmpDetails({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LeaveCancellationEmpDetailsState createState() =>
      _LeaveCancellationEmpDetailsState();
}

class _LeaveCancellationEmpDetailsState
    extends State<LeaveCancellationEmpDetails> {
  final LeaveController leaveController = Get.put(LeaveController());
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    leaveController.getLeaveApprovelListbyMngrcode();
    super.initState();
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
          'Cancelation Approvel List',
          style: kTextStyle.copyWith(
              color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: GetBuilder(builder: (LeaveController controller) {
          return controller.isLoading == true
              ? const Center(child: CircularProgressIndicator())
              : Column(
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
                        color: Colors.white,
                      ),
                      child: SizedBox(
                        height: 570,
                        child: ListView.builder(
                          itemCount: controller.leaveStatusModel?.data?.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Column(
                              children: [
                                // const SizedBox(
                                //   height: 20.0,
                                // ),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    border: Border.all(
                                        color: kGreyTextColor.withValues(alpha: 0.5)),
                                  ),
                                  child: ListTile(
                                    onTap: () {
                                      const AttendanceManagement()
                                          .launch(context);
                                    },
                                    leading: Image.asset('images/emp1.png'),
                                    title: Text(
                                      controller.leaveStatusModel!.data![index]
                                          .emPName,
                                      style: kTextStyle,
                                    ),
                                    subtitle: Text(
                                      controller.leaveStatusModel!.data![index]
                                          .emPCode,
                                      style: kTextStyle.copyWith(
                                          color: kGreyTextColor),
                                    ),
                                    trailing: const Icon(
                                      Icons.arrow_forward_ios,
                                      color: kGreyTextColor,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                );
        }),
      ),
    );
  }
}
