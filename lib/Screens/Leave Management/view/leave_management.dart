import 'package:flutter/material.dart';
import 'package:aeon_hrms/Screens/Leave%20Management/view/leaveApply.dart';
import 'package:aeon_hrms/Screens/Leave%20Management/view/leaveApprovel.dart';
import 'package:aeon_hrms/Screens/Leave%20Management/view/leaveBalance.dart';
// import 'package:aeon_hrms/Screens/Leave%20Management/view/leaveCancellation.dart';
// import 'package:aeon_hrms/Screens/Leave%20Management/view/leaveCancellationEmpDetails.dart';
import 'package:aeon_hrms/Screens/Leave%20Management/view/leaveStatus.dart';
import 'package:aeon_hrms/constant.dart';
//import 'package:aeon_hrms/Utility/MLImage.dart';
import 'package:nb_utils/nb_utils.dart';

class LeaveManagement extends StatefulWidget {
  const LeaveManagement({super.key});

  @override
  _LeaveManagementState createState() => _LeaveManagementState();
}

class _LeaveManagementState extends State<LeaveManagement> {
  bool isApproved = false;
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
          "Leave Application",
          maxLines: 2,
          style: kTextStyle.copyWith(
              color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20.0,
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20.0),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0)),
                color: Colors.white,
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20.0,
                    ),
                    Material(
                      elevation: 2.0,
                      child: GestureDetector(
                        onTap: () {
                          const LeaveApply().launch(context);
                        },
                        child: Container(
                          width: context.width(),
                          padding: const EdgeInsets.all(10.0),
                          decoration: const BoxDecoration(
                            border: Border(
                              left: BorderSide(
                                color: Color(0xFF7D6AEF),
                                width: 3.0,
                              ),
                            ),
                            color: Colors.white,
                          ),
                          child: ListTile(
                            // leading: const Image(
                            //     image: AssetImage('images/employeelist.png')),
                            // leading: Image.asset(img_leavApp,
                            //     height: 50, width: 50, fit: BoxFit.fill),
                            title: Text(
                              "Leave Application",
                              maxLines: 2,
                              style: kTextStyle.copyWith(
                                  color: kTitleColor,
                                  fontWeight: FontWeight.bold),
                            ),
                            trailing: const Icon(Icons.arrow_forward_ios),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Material(
                      elevation: 2.0,
                      child: GestureDetector(
                        onTap: () {
                          const LeaveApprovel().launch(context);
                        },
                        child: Container(
                          width: context.width(),
                          padding: const EdgeInsets.all(10.0),
                          decoration: const BoxDecoration(
                            border: Border(
                              left: BorderSide(
                                color: Color(0xFF7D6AEF),
                                width: 3.0,
                              ),
                            ),
                            color: Colors.white,
                          ),
                          child: ListTile(
                            // leading: const Image(
                            //     image: AssetImage('images/employeelist.png')),
                            // leading: Image.asset(img_leavApp,
                            //     height: 50, width: 50, fit: BoxFit.fill),
                            title: Text(
                              "Leave Approval",
                              maxLines: 2,
                              style: kTextStyle.copyWith(
                                  color: kTitleColor,
                                  fontWeight: FontWeight.bold),
                            ),
                            trailing: const Icon(Icons.arrow_forward_ios),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    // Material(
                    //   elevation: 2.0,
                    //   child: GestureDetector(
                    //     onTap: () {
                    //       const LeaveCancellation().launch(context);
                    //     },
                    //     child: Container(
                    //       width: context.width(),
                    //       padding: const EdgeInsets.all(10.0),
                    //       decoration: const BoxDecoration(
                    //         border: Border(
                    //           left: BorderSide(
                    //             color: Color(0xFF7D6AEF),
                    //             width: 3.0,
                    //           ),
                    //         ),
                    //         color: Colors.white,
                    //       ),
                    //       child: ListTile(
                    //         // leading: const Image(
                    //         //     image: AssetImage('images/employeelist.png')),
                    //         // leading: Image.asset(img_leavApp,
                    //         //     height: 50, width: 50, fit: BoxFit.fill),
                    //         title: Text(
                    //           "Leave Cancellation",
                    //           maxLines: 2,
                    //           style: kTextStyle.copyWith(
                    //               color: kTitleColor,
                    //               fontWeight: FontWeight.bold),
                    //         ),
                    //         trailing: const Icon(Icons.arrow_forward_ios),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    // const SizedBox(
                    //   height: 20.0,
                    // ),
                    // Material(
                    //   elevation: 2.0,
                    //   child: GestureDetector(
                    //     onTap: () {
                    //       const LeaveCancellationEmpDetails().launch(context);
                    //     },
                    //     child: Container(
                    //       width: context.width(),
                    //       padding: const EdgeInsets.all(10.0),
                    //       decoration: const BoxDecoration(
                    //         border: Border(
                    //           left: BorderSide(
                    //             color: Color(0xFF7D6AEF),
                    //             width: 3.0,
                    //           ),
                    //         ),
                    //         color: Colors.white,
                    //       ),
                    //       child: ListTile(
                    //         // leading: const Image(
                    //         //     image: AssetImage('images/employeelist.png')),
                    //         // leading: Image.asset(img_leavApp,
                    //         //     height: 50, width: 50, fit: BoxFit.fill),
                    //         title: Text(
                    //           "Leave Cancellation Approver",
                    //           maxLines: 2,
                    //           style: kTextStyle.copyWith(
                    //               color: kTitleColor,
                    //               fontWeight: FontWeight.bold),
                    //         ),
                    //         trailing: const Icon(Icons.arrow_forward_ios),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    // const SizedBox(
                    //   height: 20.0,
                    // ),
                    Material(
                      elevation: 2.0,
                      child: GestureDetector(
                        onTap: () {
                          const LeaveStatus().launch(context);
                        },
                        child: Container(
                          width: context.width(),
                          padding: const EdgeInsets.all(10.0),
                          decoration: const BoxDecoration(
                            border: Border(
                              left: BorderSide(
                                color: Color(0xFF7D6AEF),
                                width: 3.0,
                              ),
                            ),
                            color: Colors.white,
                          ),
                          child: ListTile(
                            title: Text(
                              "Leave Status",
                              maxLines: 2,
                              style: kTextStyle.copyWith(
                                  color: kTitleColor,
                                  fontWeight: FontWeight.bold),
                            ),
                            trailing: const Icon(Icons.arrow_forward_ios),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Material(
                      elevation: 2.0,
                      child: GestureDetector(
                        onTap: () {
                          const LeaveBalance().launch(context);
                        },
                        child: Container(
                          width: context.width(),
                          padding: const EdgeInsets.all(10.0),
                          decoration: const BoxDecoration(
                            border: Border(
                              left: BorderSide(
                                color: Color(0xFF7D6AEF),
                                width: 3.0,
                              ),
                            ),
                            color: Colors.white,
                          ),
                          child: ListTile(
                            title: Text(
                              "Leave Balance",
                              maxLines: 2,
                              style: kTextStyle.copyWith(
                                  color: kTitleColor,
                                  fontWeight: FontWeight.bold),
                            ),
                            trailing: const Icon(Icons.arrow_forward_ios),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
