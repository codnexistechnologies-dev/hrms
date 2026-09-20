import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:aeon_hrms/Screens/Leave%20Management/controller/leaveController.dart';
import 'package:aeon_hrms/Screens/Leave%20Management/view/leaveApprovalDetails.dart';
import 'package:aeon_hrms/constant.dart';

class WhatsAppMessage extends StatefulWidget {
  const WhatsAppMessage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _WhatsAppMessageState createState() => _WhatsAppMessageState();
}

class _WhatsAppMessageState extends State<WhatsAppMessage> {
  final LeaveController leaveController = Get.put(LeaveController());
  @override
  void dispose() {
    //leaveController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    leaveController.getLeaveApprovelListbyMngrcode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var height = size.height;
    //var width = size.width;
    return Scaffold(
      backgroundColor: kMainColor,
      appBar: AppBar(
        backgroundColor: kMainColor,
        elevation: 0.0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'Exit Approval Details',
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
                      child: controller.leaveStatusModel!.data!.isEmpty
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
                              height: height * 0.8,
                              child: ListView.builder(
                                itemCount:
                                    controller.leaveStatusModel?.data?.length,
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
                                            leaveController.levAppEmpcode =
                                                controller.leaveStatusModel!
                                                    .data![index].emPCode;
                                            Get.to(() =>
                                                const LeaveApprovalDetails());
                                          },
                                          leading:
                                              Image.asset('images/emp1.png'),
                                          title: Text(
                                            controller.leaveStatusModel!
                                                .data![index].emPName,
                                            style: kTextStyle,
                                          ),
                                          subtitle: Text(
                                            controller.leaveStatusModel!
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
        }),
      ),
    );
  }
}
