import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:aeon_hrms/Screens/Time%20Attendence/controller/attendance_controller.dart';
import 'package:aeon_hrms/Screens/Time%20Attendence/view/attendanceApprovalList.dart';
import 'package:aeon_hrms/constant.dart';

class ShowAttendanceRegDetails extends StatefulWidget {
  const ShowAttendanceRegDetails({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ShowAttendanceRegDetailsState createState() =>
      _ShowAttendanceRegDetailsState();
}

class _ShowAttendanceRegDetailsState extends State<ShowAttendanceRegDetails> {
  final AttendanceController attendanceController =
      Get.put(AttendanceController());
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    attendanceController.getAttRegApprovalEmployeeList();
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
            'Show Regulaization Details',
            style: kTextStyle.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        body: GetBuilder(builder: (AttendanceController controller) {
          return controller.isAttShowlist == true
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height / 1.15,
                      padding: const EdgeInsets.all(20.0),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30.0),
                            topRight: Radius.circular(30.0)),
                        color: Colors.white,
                      ),
                      child: controller.attendanceRegModel!.data!.isEmpty
                          ? SizedBox(
                              height: height * 0.8,
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
                          : SizedBox(
                              height: 570,
                              child: ListView.builder(
                                itemCount:
                                    controller.attendanceRegModel?.data?.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Column(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          border: Border.all(
                                              color: kGreyTextColor
                                                  .withValues(alpha: 0.5)),
                                        ),
                                        child: ListTile(
                                          onTap: () {
                                            attendanceController.attEmpcode =
                                                controller.attendanceRegModel!
                                                    .data![index].emPCode;
                                            Get.to(() =>
                                                const AttendanceRegApprovalList());
                                          },
                                          leading:
                                              Image.asset('images/emp1.png'),
                                          title: Text(
                                            controller.attendanceRegModel!
                                                .data![index].emPName,
                                            style: kTextStyle,
                                          ),
                                          subtitle: Text(
                                            controller.attendanceRegModel!
                                                .data![index].emPCode,
                                            style: kTextStyle.copyWith(
                                                color: kGreyTextColor),
                                          ),
                                          trailing: const Icon(
                                            Icons.arrow_forward_ios,
                                            color: kGreyTextColor,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10.0,
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                    ),
                  ],
                );
        }));
  }
}
