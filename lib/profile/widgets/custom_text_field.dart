// import 'package:flutter/material.dart';
//import 'package:flutter_screenutil/flutter_screenutil.dart';

// class CustomTextField extends StatelessWidget {
//   CustomTextField({
//     Key? key,
//     required this.hintText,
//     this.prefix,
//     this.suffix,
//     this.controller,
//     this.data,
//     this.textInputType = TextInputType.text,
//     this.textInputAction = TextInputAction.next,
//     this.textCapitalization = TextCapitalization.none,
//     this.maxLength = 100,
//   }) : super(key: key);
//   final String hintText;
//   final Widget? prefix;
//   final Widget? suffix;
//   final TextEditingController? controller;
//   final String? data;
//   final TextInputType textInputType;
//   final TextInputAction textInputAction;
//   final TextCapitalization textCapitalization;
//   final int maxLength;

//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       maxLength: maxLength,
//       cursorColor: Colors.grey,
//       style: TextStyle(
//         fontFamily: 'Heebo',
//         color: Colors.grey,
//         fontWeight: FontWeight.w400,
//         fontSize: 16.sp,
//       ),
//       controller: controller,
//       textInputAction: textInputAction,
//       keyboardType: textInputType,
//       textCapitalization: textCapitalization,
//       validator: (value) {
//         if (value!.length == 0) {
//           return "";
//         }
//         if (data == 'email') {
//           String pattern =
//               r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
//               r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
//               r"{0,253}[a-zA-Z0-9])?)*$";
//           // r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
//           RegExp regex = RegExp(pattern);
//           if (!regex.hasMatch(value)) {
//             return '';
//           }
//         }
//         if (data == '') {
//           String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
//           RegExp regExp = new RegExp(pattern);
//           if (value.length < 10 || !regExp.hasMatch(value)) {
//             return " $data";
//           }
//         }
//         return null;
//       },
//       decoration: InputDecoration(
//         counterText: "",
//         prefixIcon: prefix,
//         suffix: suffix,
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(10.r),
//             topRight: Radius.circular(10.r),
//             bottomLeft: Radius.circular(10.r),
//             bottomRight: Radius.circular(10.r),
//           ),
//           borderSide: BorderSide(
//             color: const Color.fromARGB(255, 190, 190, 190),
//             width: 1.w,
//           ),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(10.r),
//             topRight: Radius.circular(10.r),
//             bottomLeft: Radius.circular(10.r),
//             bottomRight: Radius.circular(10.r),
//           ),
//           borderSide: BorderSide(
//             color: const Color.fromARGB(255, 190, 190, 190),
//             width: 1.w,
//           ),
//         ),
//         hintText: hintText,
//         contentPadding: const EdgeInsets.all(7.0),
//         hintStyle: TextStyle(
//           fontFamily: 'Heebo',
//           color: Colors.grey,
//           fontWeight: FontWeight.w400,
//           fontSize: 16.sp,
//         ),
//       ),
//     );
//   }
// }
