// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:aeon_hrms/Screens/Time%20Attendence/controller/attendance_controller.dart';
// import 'package:aeon_hrms/Utility/shared_preferences_service.dart';
// import 'package:aeon_hrms/Utility/DatabaseHelper.dart';
// import 'package:aeon_hrms/constant.dart';

// class ShowlatlongList extends StatefulWidget {
//   const ShowlatlongList({Key? key}) : super(key: key);

//   @override
//   _ShowlatlongListState createState() => _ShowlatlongListState();
// }

// class _ShowlatlongListState extends State<ShowlatlongList> {
//   bool isApproved = false;
//   List<Map<String, dynamic>> _journals = [];
//   // final AttendanceController attendanceController =
//   //     Get.put(AttendanceController());

//   @override
//   void initState() {
//     // TODO: implement initState
//     _refreshJournals();
//     //attendanceController.getAttendencestatus();
//     super.initState();
//   }

//   void _refreshJournals() async {
//     final data = await SQLHelper.getLatlongByempcode(SharedPref.getEmpCode());
//     setState(() {
//       _journals = data;
//     });
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
//           'latlong Status',
//           maxLines: 2,
//           style: kTextStyle.copyWith(
//               color: Colors.white, fontWeight: FontWeight.bold),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const SizedBox(
//               height: 20.0,
//             ),
//             Container(
//               width: double.infinity,
//               padding: const EdgeInsets.all(20.0),
//               decoration: const BoxDecoration(
//                 borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(30.0),
//                     topRight: Radius.circular(30.0)),
//                 color: kBgColor,
//               ),
//               child: Column(
//                 children: [
//                   GetBuilder(
//                     builder: (AttendanceController controller) {
//                       int len = 100;
//                       // int intLen = int.parse(len)
//                       return Container(
//                         padding: const EdgeInsets.all(10.0),
//                         decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(10.0),
//                             color: Colors.white),
//                         child: Column(
//                           children: [
//                             const SizedBox(
//                               height: 20.0,
//                             ),
//                             Row(
//                               children: [
//                                 Expanded(
//                                   child: GestureDetector(
//                                     onTap: () {
//                                       setState(() {
//                                         isApproved = !isApproved;
//                                       });
//                                     },
//                                     child: Container(
//                                       padding: const EdgeInsets.all(20),
//                                       decoration: BoxDecoration(
//                                         borderRadius:
//                                             BorderRadius.circular(10.0),
//                                         color: !isApproved
//                                             ? kMainColor
//                                             : kMainColor.withOpacity(0.1),
//                                       ),
//                                       child: Center(
//                                         child: Text(
//                                           'Request (4)',
//                                           style: kTextStyle.copyWith(
//                                               color: !isApproved
//                                                   ? Colors.white
//                                                   : kTitleColor),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 const SizedBox(
//                                   width: 10.0,
//                                 ),
//                                 Expanded(
//                                   child: GestureDetector(
//                                     onTap: () {
//                                       setState(() {
//                                         isApproved = !isApproved;
//                                       });
//                                     },
//                                     child: Container(
//                                       padding: const EdgeInsets.all(20),
//                                       decoration: BoxDecoration(
//                                         borderRadius:
//                                             BorderRadius.circular(10.0),
//                                         color: isApproved
//                                             ? kMainColor
//                                             : kMainColor.withOpacity(0.1),
//                                       ),
//                                       child: Center(
//                                         child: Text(
//                                           'Approved',
//                                           style: kTextStyle.copyWith(
//                                               color: isApproved
//                                                   ? Colors.white
//                                                   : kTitleColor),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             const SizedBox(
//                               height: 20.0,
//                             ),
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               children: [
//                                 Row(
//                                   children: [
//                                     Expanded(
//                                       child: Text(
//                                         'Emp_code',
//                                         style: kTextStyle.copyWith(
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                     ),
//                                     SizedBox(
//                                       width: 75,
//                                       child: Text(
//                                         'Lat',
//                                         style: kTextStyle.copyWith(
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                     ),
//                                     SizedBox(
//                                       width: 75,
//                                       child: Text(
//                                         'long',
//                                         style: kTextStyle.copyWith(
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                     ),
//                                     SizedBox(
//                                       width: 50,
//                                       child: Text(
//                                         'Distance',
//                                         style: kTextStyle.copyWith(
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 const Divider(
//                                   thickness: 1.0,
//                                   color: kGreyTextColor,
//                                 ),
//                                 SizedBox(
//                                   height: 16 * len.toDouble(),
//                                   child: ListView.builder(
//                                     itemCount: _journals.length,
//                                     itemBuilder:
//                                         (BuildContext context, int index) {
//                                       return Padding(
//                                         padding: const EdgeInsets.symmetric(
//                                             vertical: 5.0),
//                                         child: Column(
//                                           children: [
//                                             Row(
//                                               children: [
//                                                 Expanded(
//                                                   child: Text(
//                                                     _journals[index]['EMP_CODE']
//                                                         .toString(),
//                                                     style: kTextStyle.copyWith(
//                                                         color: kGreyTextColor),
//                                                   ),
//                                                 ),
//                                                 SizedBox(
//                                                   width: 75,
//                                                   child: Text(
//                                                     _journals[index]['Latitude']
//                                                         .toString(),
//                                                     style: kTextStyle.copyWith(
//                                                         color: kGreyTextColor),
//                                                   ),
//                                                 ),
//                                                 SizedBox(
//                                                   width: 75,
//                                                   // color: Colors.grey,
//                                                   child: Center(
//                                                     child: Text(
//                                                       _journals[index]
//                                                               ['Longitude']
//                                                           .toString(),
//                                                       style: kTextStyle.copyWith(
//                                                           color:
//                                                               kGreyTextColor),
//                                                     ),
//                                                   ),
//                                                 ),
//                                                 Container(
//                                                   // height: 40.0,
//                                                   width: 55.0,
//                                                   padding: const EdgeInsets.all(
//                                                       10.0),
//                                                   decoration: BoxDecoration(
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                             2.0),
//                                                     color: kGreenColor
//                                                         .withOpacity(0.08),
//                                                   ),
//                                                   child: Center(
//                                                     child: Text(
//                                                       _journals[index]
//                                                               ['DISTANCE']
//                                                           .toString(),
//                                                       style:
//                                                           kTextStyle.copyWith(
//                                                               color:
//                                                                   kGreenColor,
//                                                               fontSize: 14.0,
//                                                               fontWeight:
//                                                                   FontWeight
//                                                                       .bold),
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                             const Divider(
//                                               thickness: 0.3,
//                                               color: Colors.black,
//                                             )
//                                           ],
//                                         ),
//                                       );
//                                     },
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       );
//                     },
//                   ),
//                   // const SizedBox(
//                   //   height: 20.0,
//                   // ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
