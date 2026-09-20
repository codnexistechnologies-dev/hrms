import 'package:flutter/material.dart';
// import 'package:aeon_hrms/Screens/Bonus%20Management/empty_bonus.dart';
import 'package:aeon_hrms/Screens/Client%20Management/client_list.dart';
import 'package:aeon_hrms/Screens/Employee%20Overtime/employee_overtime_list.dart';
import 'package:aeon_hrms/Screens/Employee%20management/view/employee_list.dart';
import 'package:aeon_hrms/Screens/Expense%20Management/expense_list.dart';
import 'package:aeon_hrms/Screens/File%20Management/file_list.dart';
import 'package:aeon_hrms/Screens/Holiday%20Management/holiday_list.dart';
import 'package:aeon_hrms/Screens/Increment/empty_increment.dart';
// import 'package:aeon_hrms/Screens/Payment%20Management/payment_employee_list.dart';
// import 'package:aeon_hrms/Screens/Payroll%20Management/add_salary_sheet.dart';
// import 'package:aeon_hrms/Screens/Provident%20Fund/empty_provident_fund.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../constant.dart';

class settings_screen1Screen extends StatefulWidget {
  const settings_screen1Screen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _settings_screen1ScreenState createState() => _settings_screen1ScreenState();
}

// ignore: camel_case_types
class _settings_screen1ScreenState extends State<settings_screen1Screen> {
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
          'Payroll Management',
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
              child: Column(
                children: [
                  const SizedBox(
                    height: 20.0,
                  ),
                  Material(
                    elevation: 2.0,
                    child: GestureDetector(
                      onTap: () {
                        const ClientList().launch(context);
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
                            const EmptyIncrement().launch(context);
                          },
                          leading: const Image(
                              image: AssetImage('images/increment.png')),
                          title: Text(
                            'Client List',
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
                    child: Container(
                      width: context.width(),
                      padding: const EdgeInsets.all(10.0),
                      decoration: const BoxDecoration(
                        border: Border(
                          left: BorderSide(
                            color: Color(0xFFFD73B0),
                            width: 3.0,
                          ),
                        ),
                        color: Colors.white,
                      ),
                      child: ListTile(
                        onTap: () {
                          const EmployeeList().launch(context);
                        },
                        leading: const Image(
                            image: AssetImage('images/payment.png')),
                        title: Text(
                          'Employee List',
                          maxLines: 2,
                          style: kTextStyle.copyWith(
                              color: kTitleColor, fontWeight: FontWeight.bold),
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Material(
                    elevation: 2.0,
                    child: Container(
                      width: context.width(),
                      padding: const EdgeInsets.all(10.0),
                      decoration: const BoxDecoration(
                        border: Border(
                          left: BorderSide(
                            color: Color(0xFF4CCEFA),
                            width: 3.0,
                          ),
                        ),
                        color: Colors.white,
                      ),
                      child: ListTile(
                        onTap: () {
                          const EmployeeOvertimeList().launch(context);
                        },
                        leading: const Image(
                            image: AssetImage('images/salarysheet.png')),
                        title: Text(
                          'EmployeeOvertime List',
                          maxLines: 2,
                          style: kTextStyle.copyWith(
                              color: kTitleColor, fontWeight: FontWeight.bold),
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Material(
                    elevation: 2.0,
                    child: Container(
                      width: context.width(),
                      padding: const EdgeInsets.all(10.0),
                      decoration: const BoxDecoration(
                        border: Border(
                          left: BorderSide(
                            color: Color(0xFFF4C000),
                            width: 3.0,
                          ),
                        ),
                        color: Colors.white,
                      ),
                      child: ListTile(
                        onTap: () {
                          const ExpenseList().launch(context);
                        },
                        leading:
                            const Image(image: AssetImage('images/bonus.png')),
                        title: Text(
                          'Expense List',
                          maxLines: 2,
                          style: kTextStyle.copyWith(
                              color: kTitleColor, fontWeight: FontWeight.bold),
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Material(
                    elevation: 2.0,
                    child: Container(
                      width: context.width(),
                      padding: const EdgeInsets.all(10.0),
                      decoration: const BoxDecoration(
                        border: Border(
                          left: BorderSide(
                            color: Color(0xFFFD73B0),
                            width: 3.0,
                          ),
                        ),
                        color: Colors.white,
                      ),
                      child: ListTile(
                        onTap: () {
                          const FileList().launch(context);
                        },
                        leading:
                            const Image(image: AssetImage('images/loan.png')),
                        title: Text(
                          'File List',
                          maxLines: 2,
                          style: kTextStyle.copyWith(
                              color: kTitleColor, fontWeight: FontWeight.bold),
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios),
                      ),
                    ),
                  ),
                  Material(
                    elevation: 2.0,
                    child: Container(
                      width: context.width(),
                      padding: const EdgeInsets.all(10.0),
                      decoration: const BoxDecoration(
                        border: Border(
                          left: BorderSide(
                            color: Color(0xFF05B985),
                            width: 3.0,
                          ),
                        ),
                        color: Colors.white,
                      ),
                      child: ListTile(
                        onTap: () {
                          const HolidayList().launch(context);
                        },
                        leading: const Image(
                            image: AssetImage('images/providentfund.png')),
                        title: Text(
                          'Holiday List',
                          maxLines: 2,
                          style: kTextStyle.copyWith(
                              color: kTitleColor, fontWeight: FontWeight.bold),
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios),
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
