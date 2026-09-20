import 'dart:io';

import 'package:aeon_hrms/constant.dart';
import 'package:aeon_hrms/profile/controller/visit_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';

class ProfileDetails extends StatefulWidget {
  const ProfileDetails({super.key});

  @override
  State<ProfileDetails> createState() => _ProfileDetailsState();
}

class _ProfileDetailsState extends State<ProfileDetails> {
  final VisitController visitController = Get.put(VisitController());
  final TextEditingController addresstextfieldcontroller =
      TextEditingController();
  final TextEditingController addresstextfieldcontroller2 =
      TextEditingController();
  final TextEditingController addresstextfieldcontroller3 =
      TextEditingController();
  final TextEditingController addresstextfieldcontroller4 =
      TextEditingController();
  final TextEditingController addresstextfieldcontroller5 =
      TextEditingController();

  final ImagePicker picker = ImagePicker();
  File? file;
  String? imagename;

  Future<void> getImage(ImageSource source) async {
    final response = await picker.pickImage(source: source);
    file = File(response!.path);
    setState(() {
      imagename = file!.path;
    });
    print("selected image name $imagename");
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      getImage(ImageSource.camera);
                    },
                    child: const CircleAvatar(
                      radius: 50.0,
                      backgroundColor: kMainColor,
                      backgroundImage: AssetImage(
                        'images/emp1.png',
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Row(
                    children: [
                      Text(
                        "Address",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  SizedBox(
                    height: 60.0,
                    child: AppTextField(
                      textFieldType: TextFieldType.USERNAME,
                      controller: addresstextfieldcontroller,
                      enabled: false,
                      decoration: const InputDecoration(
                        labelText: 'User Id',
                        hintText: 'User Id',
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  const Row(
                    children: [
                      Text(
                        "Address",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  SizedBox(
                    height: 60.0,
                    child: AppTextField(
                      textFieldType: TextFieldType.USERNAME,
                      controller: addresstextfieldcontroller,
                      enabled: false,
                      decoration: const InputDecoration(
                        labelText: 'User Id',
                        hintText: 'User Id',
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  const Row(
                    children: [
                      Text(
                        "Address",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  SizedBox(
                    height: 60.0,
                    child: AppTextField(
                      textFieldType: TextFieldType.USERNAME,
                      controller: addresstextfieldcontroller,
                      enabled: false,
                      decoration: const InputDecoration(
                        labelText: 'User Id',
                        hintText: 'User Id',
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  const Row(
                    children: [
                      Text(
                        "Address",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  SizedBox(
                    height: 60.0,
                    child: AppTextField(
                      textFieldType: TextFieldType.USERNAME,
                      controller: addresstextfieldcontroller,
                      enabled: false,
                      decoration: const InputDecoration(
                        labelText: 'User Id',
                        hintText: 'User Id',
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  const Row(
                    children: [
                      Text(
                        "Address",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  SizedBox(
                    height: 60.0,
                    child: AppTextField(
                      textFieldType: TextFieldType.USERNAME,
                      controller: addresstextfieldcontroller,
                      enabled: false,
                      decoration: const InputDecoration(
                        labelText: 'User Id',
                        hintText: 'User Id',
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
