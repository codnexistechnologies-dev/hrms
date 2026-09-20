import 'package:aeon_hrms/Screens/Report/view/DownloadPayslip.dart';
import 'package:flutter/material.dart';
import 'package:aeon_hrms/Screens/Report/view/payslip.dart';
import 'package:aeon_hrms/Utility/MLImage.dart';

import 'package:nb_utils/nb_utils.dart';

import '../../../constant.dart';

class MyReportsScreen extends StatefulWidget {
  const MyReportsScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyReportsScreenState createState() => _MyReportsScreenState();
}

class _MyReportsScreenState extends State<MyReportsScreen> {
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
          'Reports',
          maxLines: 2,
          style: kTextStyle.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20.0),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20.0),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  const SizedBox(height: 20.0),
                  Material(
                    elevation: 2.0,
                    child: GestureDetector(
                      onTap: () {
                        const Payslip().launch(context);
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
                          onTap: () {
                            const Payslip().launch(context);
                          },
                          leading: Image.asset(
                            img_Mypayslip,
                            height: 50,
                            width: 50,
                            fit: BoxFit.fill,
                          ),

                          title: Text(
                            'Payslip',
                            maxLines: 2,
                            style: kTextStyle.copyWith(
                              color: kTitleColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          trailing: const Icon(Icons.arrow_forward_ios),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Material(
                    elevation: 2.0,
                    child: GestureDetector(
                      onTap: () {
                        const DownloadPayslip().launch(context);
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
                          onTap: () {
                            const DownloadPayslip().launch(context);
                          },
                          leading: Image.asset(
                            img_Mypayslip,
                            height: 50,
                            width: 50,
                            fit: BoxFit.fill,
                          ),
                          title: Text(
                            'Download Payslip',
                            maxLines: 2,
                            style: kTextStyle.copyWith(
                              color: kTitleColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          trailing: const Icon(Icons.arrow_forward_ios),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
