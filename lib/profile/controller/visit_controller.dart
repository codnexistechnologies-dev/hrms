import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;

class VisitController extends GetxController {
  var indexvaldata = 0.obs;
  var isLastPage = false.obs;
  Dio dio = Dio();
  var isImageSelected = false.obs;
  var pickedImage = "".obs;
  var isFirstPicUpdated = false.obs;
  var pickedImage2 = "".obs;
  var isSecondPicUpdated = false.obs;
  var pickedImage3 = "".obs;
  var isThirdPicUpdated = false.obs;
  var pickedImage4 = "".obs;
  var isFourthPicUpdated = false.obs;
  var gstPicImage = "".obs;
  var isGstPicUpdated = false.obs;
  var aadharPicImage = "".obs;
  var isAadharPicUpdated = false.obs;
  var panPicImage = "".obs;
  var isPanPicUpdated = false.obs;
  var attendentPicImage = "".obs;
  var shopPicImage = "".obs;
  var outsideShopImage = "".obs;
  var insideShopPickedImage = "".obs;
  var customerImage = "".obs;
  var customerImageUpdated = false.obs;
  File? finalPickedImage;
  File? gstPickedImage;
  File? panPickedImage;
  File? addharPickedImage;
  File? shopPickedImage;
  File? insidePicImage;
  File? outsidePicImage;
  File? attendentPickedImage;
  File? customerPickedImage;

  void checkLastPage() {
    isLastPage.value = true;
  }

  void checknotLastPage() {
    isLastPage.value = false;
  }

  void changeIndexVal({required int indexval}) {
    indexvaldata.value = indexval;
  }

  var isEnterAccepted = false.obs;
  var isImageUploading = false.obs;

  var isCustomerImageUploaded = false.obs;
  var isFirstImageUploaded = false.obs;
  var isSecondImageUploaded = false.obs;
  var isThirdImageUploaded = false.obs;
  var isForthImageUploaded = false.obs;
  var isAadharImageUploaded = false.obs;
  var isPanImageUploaded = false.obs;
  var isGstImageUploaded = false.obs;

  List<String> imageList = [];

  var aadharPhoto = ''.obs;
  var gstPhoto = ''.obs;
  var panPhoto = ''.obs;
  var shopboardPhoto = ''.obs;
  var insideshopboardPhoto = ''.obs;
  var outSideshopboardPhoto = ''.obs;
  var attendentPhoto = ''.obs;
  var customerPicValue = ''.obs;

  List<String> outSideImage = [];
  RxBool isText = true.obs;

  final TextEditingController nametextfieldcontroller = TextEditingController();
  final TextEditingController emailtextfieldcontroller =
      TextEditingController();
  final TextEditingController mobiletextfieldcontroller =
      TextEditingController();
  final TextEditingController addresstextfieldcontroller =
      TextEditingController();
  final TextEditingController citytextfieldcontroller = TextEditingController();
  final TextEditingController pincodetextfieldcontroller =
      TextEditingController();
  final TextEditingController aadhartextfieldcontroller =
      TextEditingController();
  final TextEditingController pantextfieldcontroller = TextEditingController();
  final TextEditingController gsttextfieldcontroller = TextEditingController();

  RxInt indexval = 0.obs;
  void increse() {
    indexval.value++;
  }

  void decrease() {
    indexval.value--;
  }

  var name = "".obs;
  var email = "".obs;
  var number = "".obs;
  var address = "".obs;
  var state = "".obs;
  var city = "".obs;
  var district = "".obs;
  var pincode = "".obs;
  var gst = "".obs;
  var aadharnumber = "".obs;
  var pannumber = "".obs;
  var partytype = "".obs;
  var password = "".obs;

  Future<void> saveClient() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    print("name data ${nametextfieldcontroller.text}");
    print("email data ${email.value}");
    print("mobile data ${number.value}");
    print("address data ${address.value}");
    print("city data ${city.value}");
    print("pincode data ${pincode.value}");
    print("aadhar data ${aadharnumber.value}");
    print("pan data ${pannumber.value}");
    print("gst data ${gst.value}");
    try {
      List<Map<String, dynamic>> imagedataList = [];
      for (String imageData in imageList) {
        imagedataList.add({
          "outsideshoppic": imageData,
        });
      }

      String selfieValue = "";
      var userId = prefs.getString("userId");
      print("userid data $userId");
      selfieValue = prefs.getString("imageValue").toString();
      print("image recieve data $selfieValue");
      // dio.options.headers["Content-Type"] = "application/json";

      final response = await dio.post('', data: {
        'name': name.toString(),
        'number': number.toString(),
        'address': address.toString(),
        'state': state.toString(),
        'district': district.toString(),
        "customerimage": customerPicValue.toString(),
        'city': city.toString(),
        'pincode': pincode.toString(),
        'gst': gst.toString(),
        'gstphoto': gstPhoto.toString(),
        'userid': userId.toString(),
        'aadhaarnumber': aadharnumber.toString(),
        'aadhaarphoto': aadharPhoto.toString(),
        'pannumber': pannumber.toString(),
        'panphoto': panPhoto.toString(),
        'shopboardpic': shopboardPhoto.toString(),
        'insideshoppic': insideshopboardPhoto.toString(),
        'outsideshoppic': imagedataList,
        'attendentpic': attendentPhoto.toString(),
        'email': email.toString(),
        'partyType': "client".toString(),
        'password': password.toString(),
      });

      if (response.statusCode == 200) {
        // getParty();
        Get.back();
        Get.snackbar(
          "Client added successfully.",
          "",
          colorText: Colors.white,
          backgroundColor: const Color.fromARGB(255, 201, 57, 226),
          icon: const Icon(Icons.add_alert),
        );

        print('Video uploaded successfully ${response.data}');
      } else {
        print('Error uploading video. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error sending data: $error');
    }
  }
}
