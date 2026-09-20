import 'dart:convert';
import 'dart:io';

import 'package:aeon_hrms/Utility/api_constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:aeon_hrms/Screens/Employee%20management/model/employeeDetailsModel.dart';
import 'package:aeon_hrms/Utility/MLString.dart';
import 'package:aeon_hrms/Utility/shared_preferences_service.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart' as dio;

class EmployeeController extends GetxController {
  EmployeeDetailsModel? employeeDetailsModel;
  var isempDetailsLoading = false;
  Future<void> getEmployeeDetails() async {
    isempDetailsLoading = true;
    update();
    String? empCode = SharedPref.getEmpCode();
    final response = await http.post(
      Uri.parse(
        '${ApiConstant.baseUrl}/api/MobileApi/GetEmployeeDetailsByEmpcode?EMP_CODE=$empCode',
      ),
    );

    if (response.statusCode == 200) {
      employeeDetailsModel = EmployeeDetailsModel.fromJson(
        jsonDecode(response.body),
      );

      isempDetailsLoading = false;
      update();
    } else {
      isempDetailsLoading = false;
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
    isempDetailsLoading = false;
    update();
  }

  File? pickedFile;
  bool isImageUpdating = false;
  Future<void> updateImage(BuildContext context) async {
    isImageUpdating = true;
    update();

    String? empCode = SharedPref.getEmpCode();

    // Dio dio = Dio();
    String imageFile = pickedFile!.path.split('/').last;
    try {
      // Prepare the file as MultipartFile
      // String fileName = basename(imageFile);
      dio.FormData formData = dio.FormData.fromMap({
        'EMP_CODE': empCode,
        'ImageFile': await dio.MultipartFile.fromFile(
          pickedFile!.path,
          filename: imageFile,
        ),
      });
      var myDio = dio.Dio();
      // Send the POST request
      await myDio
          .post(
            '${ApiConstant.baseUrl}/api/MobileApi/UploadImage',
            data: formData,
            options: Options(headers: {'Content-Type': 'multipart/form-data'}),
          )
          .then((value) async {
            if (value.statusCode == 200) {
              isImageUpdating = false;
              update();
              const snackBar = SnackBar(content: Text('Yay! A SnackBar!'));

              // Find the ScaffoldMessenger in the widget tree
              // and use it to show a SnackBar.
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              print('image uploaded successfully');
            }
          });
    } catch (e) {
      isImageUpdating = false;
      update();
      print('Error occurred: $e');
      throw Exception('Error uploading image');
    } finally {
      isImageUpdating = false;
      update();
    }
  }

  final ImagePicker picker = ImagePicker();
  Future<void> getImage(BuildContext context, ImageSource source) async {
    final response = await picker.pickImage(source: source);
    if (response == null) {
      return;
    }

    isImageUpdating = true;
    update();
    pickedFile = File(response.path);
    isImageUpdating = false;
    print('selected image in camera $pickedFile');
    update();
    await updateImage(context);
  }
}
