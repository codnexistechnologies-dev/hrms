// // ignore_for_file: library_private_types_in_public_api

// import 'package:aeon_hrms/Screens/Employee%20management/view/edit_profile.dart';
// import 'package:aeon_hrms/Screens/Employee%20management/controller/employee_controller.dart';
// import 'package:aeon_hrms/Screens/Employee%20management/view/employee_card_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:nb_utils/nb_utils.dart';
// import '../../constant.dart';

// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({super.key});

//   @override
//   _ProfileScreenState createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   final EmployeeController employeeController = Get.put(EmployeeController());

//   @override
//   void initState() {
//     super.initState();
//     employeeController.getEmployeeDetails();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       backgroundColor: kMainColor,
//       appBar: AppBar(
//         backgroundColor: kMainColor,
//         elevation: 0.0,
//         titleSpacing: 0.0,
//         iconTheme: const IconThemeData(color: Colors.white),
//         title: Text(
//           'Profile',
//           maxLines: 2,
//           style: kTextStyle.copyWith(
//               color: Colors.white, fontWeight: FontWeight.bold),
//         ),
//         actions: [
//           const Image(
//             image: AssetImage('images/editprofile.png'),
//           ).onTap(() {
//             const EditProfile().launch(context);
//           }),
//         ],
//       ),
//       body: GetBuilder<EmployeeController>(
//         builder: (controller) {
//           final employee = controller.employeeDetailsModel?.data?.firstOrNull;
//           return Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const SizedBox(
//             height: 20.0,
//           ),
//           Expanded(
//             child: Container(
//               // width: 2,
//               padding: const EdgeInsets.all(20.0),
//               decoration: const BoxDecoration(
//                 borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(30.0),
//                     topRight: Radius.circular(30.0)),
//                 color: Colors.white,
//               ),
//               child: Column(
//                 children: [
//                   const SizedBox(
//                     height: 20.0,
//                   ),
//                   const CircleAvatar(
//                     radius: 60.0,
//                     backgroundColor: kMainColor,
//                     backgroundImage: AssetImage(
//                       'images/emp1.png',
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 20.0,
//                   ),
//                   AppTextField(
//                     readOnly: true,
//                     textFieldType: TextFieldType.NAME,
//                     decoration: InputDecoration(
//                       labelText: 'Company Name',
//                       hintText: employee?.company?.toString() ?? 'Agrisolutions Private Limited',
//                       floatingLabelBehavior: FloatingLabelBehavior.always,
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 20.0,
//                   ),
//                   AppTextField(
//                     readOnly: true,
//                     textFieldType: TextFieldType.NAME,
//                     decoration: InputDecoration(
//                       labelText: 'Owner/Admin name',
//                       hintText: employee?.emPNAME?.toString() ?? 'Employee',
//                       floatingLabelBehavior: FloatingLabelBehavior.always,
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 20.0,
//                   ),
//                   AppTextField(
//                     readOnly: true,
//                     textFieldType: TextFieldType.EMAIL,
//                     decoration: InputDecoration(
//                       labelText: 'Email Address',
//                       floatingLabelBehavior: FloatingLabelBehavior.always,
//                       hintText: employee?.emailid?.toString() ?? '',
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 20.0,
//                   ),
//                   AppTextField(
//                     textFieldType: TextFieldType.PHONE,
//                     controller: TextEditingController(),
//                     readOnly: true,
//                     decoration: InputDecoration(
//                       labelText: 'Phone Number',
//                       hintText: employee?.mobileno?.toString() ?? '',
//                       labelStyle: kTextStyle,
//                       border: const OutlineInputBorder(),
//                       floatingLabelBehavior: FloatingLabelBehavior.always,
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 20.0,
//                   ),
//                   AppTextField(
//                     readOnly: true,
//                     textFieldType: TextFieldType.MULTILINE,
//                     decoration: InputDecoration(
//                       labelText: 'Company Address',
//                       floatingLabelBehavior: FloatingLabelBehavior.always,
//                       hintText: employee?.mailingaddress?.toString() ?? '',
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 20.0,
//                   ),
//                   AppTextField(
//                     textFieldType: TextFieldType.NAME,
//                     readOnly: true,
//                     decoration: InputDecoration(
//                       labelText: 'Gender',
//                       floatingLabelBehavior: FloatingLabelBehavior.always,
//                       hintText: employee?.sex == 2 ? 'Female' : 'Male',
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                   if (employee != null) ...[
//                     const SizedBox(height: 28),
//                     SizedBox(
//                       width: double.infinity,
//                       height: 60,
//                       child: ElevatedButton(
//                         onPressed: () =>
//                             EmployeeCardScreen(employee: employee).launch(context),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: kMainColor,
//                           foregroundColor: Colors.white,
//                           elevation: 0,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(14),
//                           ),
//                           padding: const EdgeInsets.symmetric(horizontal: 18),
//                         ),
//                         child: Row(
//                           children: [
//                             const Icon(Icons.badge_outlined, size: 29),
//                             const SizedBox(width: 18),
//                             Text(
//                               'View Employee Card',
//                               style: kTextStyle.copyWith(
//                                 color: Colors.white,
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             const Spacer(),
//                             const Icon(Icons.chevron_right, size: 32),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ],
//               ),
//             ),
//           ),
//         ],
//       );
//         },
//       ),
//     );
//   }
// }
