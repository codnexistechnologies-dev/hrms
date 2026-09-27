import 'dart:io';

import 'package:aeon_hrms/Screens/KPI%20Management/Demo%20Plan/controller/DemoPlanController.dart';
import 'package:aeon_hrms/Screens/KPI%20Management/Demo%20Plan/model/DistrictMasterModel.dart';
import 'package:aeon_hrms/Screens/KPI%20Management/Demo%20Plan/model/ProductMasterListModel.dart';
import 'package:aeon_hrms/Screens/KPI%20Management/Demo%20Plan/model/StateMasterModel.dart';
import 'package:aeon_hrms/Screens/KPI%20Management/Demo%20Plan/model/TehsilListModel.dart';
import 'package:aeon_hrms/Screens/KPI%20Management/Demo%20Plan/model/VillageListModel.dart';
import 'package:aeon_hrms/Screens/KPI%20Management/Organised%20Farmer/controller/OrganisedFarmerMeetingController.dart';
import 'package:aeon_hrms/Screens/KPI%20Management/Organised%20Farmer/model/CropMastModel.dart';
import 'package:aeon_hrms/Utility/utility_function.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:aeon_hrms/GlobalComponents/button_global.dart';
import 'package:aeon_hrms/constant.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';

class AddOrganisedFarmerMeeting extends StatefulWidget {
  final Function(ImageAndLocationData) onImageCaptured;

  const AddOrganisedFarmerMeeting({super.key, required this.onImageCaptured});

  @override
  // ignore: library_private_types_in_public_api
  _AddOrganisedFarmerMeetingState createState() =>
      _AddOrganisedFarmerMeetingState();
}

class _AddOrganisedFarmerMeetingState extends State<AddOrganisedFarmerMeeting> {
  File? _image;
  double? _latitude;
  double? _longitude;
  String? _address;
  DateTime? _capturedDateTime;
  bool _isImagesLoading = false; // State to track loading status
  final ImagePicker _picker = ImagePicker();
  final demoPlanController = Get.put(DemoPlanController()); // GetX Control
  final organisedplanController = Get.put(
    OrganisedFarmerMeetingController(),
  ); // GetX Control
  final TextEditingController txt_PinCode = TextEditingController();
  final TextEditingController txt_NoOfFarmerattendance =
      TextEditingController();
  final TextEditingController txt_VillageName = TextEditingController();
  final TextEditingController txt_FarmerName = TextEditingController();
  final TextEditingController txt_MobileNumber = TextEditingController();
  final TextEditingController txt_Remarks = TextEditingController();

  @override
  void dispose() {
    txt_NoOfFarmerattendance.dispose();
    txt_VillageName.dispose();
    txt_Remarks.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();

  DropdownButton<ProductData> getProductData() {
    return DropdownButton<ProductData>(
      // ignore: invalid_use_of_protected_member
      items: demoPlanController.productList.value.map((product) {
        return DropdownMenuItem<ProductData>(
          value: product,
          child: Text(product.productName ?? "Unknown"),
        );
      }).toList(),
      value: demoPlanController.productselectedValue.value,
      onChanged: (value) {
        demoPlanController.productselectedValue.value = value;
      },
    );
  }

  @override
  void initState() {
    super.initState();
    demoPlanController.isDemoPlanLoading = true;
    bindLocatation();
    demoPlanController.getAllProductList();
    demoPlanController.GetAllCropList();
    demoPlanController.GetAllTankList();
    if (demoPlanController.productList.isNotEmpty) {
      demoPlanController.productselectedValue.value =
          demoPlanController.productList.first;
    }

    if (demoPlanController.stateList.isNotEmpty) {
      demoPlanController.selectedState.value =
          demoPlanController.stateList.first;
    }
    if (demoPlanController.tankList.isNotEmpty &&
        demoPlanController.selectedtank.value == null) {
      demoPlanController.selectedtank.value = demoPlanController.tankList.first;
    }

    if (demoPlanController.cropList.isNotEmpty &&
        demoPlanController.selectedCrop.value == null) {
      demoPlanController.selectedCrop.value = demoPlanController.cropList.first;
    }
    demoPlanController.GetStateListByEmpCode();
    demoPlanController.isDemoPlanLoading = false;
  }

  Future<void> bindLocatation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    _latitude = position.latitude;
    _longitude = position.longitude;

    // Get address from coordinates
    List<Placemark> placemarks = await placemarkFromCoordinates(
      _latitude!,
      _longitude!,
    );

    if (placemarks.isNotEmpty) {
      _address =
          "${placemarks[0].street!} ${placemarks[0].subLocality!} ${placemarks[0].subAdministrativeArea!} ${placemarks[0].locality!} ${placemarks[0].country!} ${placemarks[0].postalCode!}";
    }
  }

  void bindDistrict(String? StateCode) {
    demoPlanController.isDemoPlanLoading = true;
    demoPlanController.GetDistrictListByStateCodeandEmpCode(StateCode);
    demoPlanController.isDemoPlanLoading = false;
  }

  void bindTehsil(int? DistrictCode) {
    demoPlanController.isDemoPlanLoading = true;
    demoPlanController.GetTehsilListByDistrictCodeandEmpCode(DistrictCode);
    demoPlanController.isDemoPlanLoading = false;
  }

  void bindVillage(int? TehsilCode) {
    demoPlanController.isDemoPlanLoading = true;
    txt_PinCode.text = "";
    demoPlanController.getVillageListByTehsilCode(TehsilCode);
    demoPlanController.isDemoPlanLoading = false;
  }

  bool isLoading = false;
  Future<void> saveDemoPlanData() async {
    if (demoPlanController.productselectedValue.value == null) {
      Utility.alertInfo(context, data: "Please Select Product Name.");
      return;
    } else if (demoPlanController.selectedCrop.value == null) {
      Utility.alertInfo(context, data: "Please Select Crop Name.");
    } else if (demoPlanController.selectedState.value == null) {
      Utility.alertInfo(context, data: "Please Select State Name.");
    } else if (demoPlanController.selectedDistrict.value == null) {
      Utility.alertInfo(context, data: "Please Select District Name.");
    } else if (demoPlanController.selectedTehsil.value == null) {
      Utility.alertInfo(context, data: "Please Select Tehsil Name.");
      return;
    } else if (demoPlanController.selectedvillage.value == null) {
      Utility.alertInfo(context, data: "Please Select Village Name.");
      return;
    } else if (txt_NoOfFarmerattendance.text == "") {
      Utility.alertInfo(context, data: "Farmer Name Can't be blank.");
      return;
    } else if (_address == null || _latitude == null || _longitude == null) {
      Utility.alertInfo(
        context,
        data:
            "Please ensure the following:\n\n"
            "1. GPS/Location services are turned on.\n"
            "2. Location permissions are granted to the app.\n"
            "3. Internet connectivity is enabled for address detection.",
      );
      return;
    } else if (_image == null || !_image!.existsSync()) {
      Utility.alertInfo(context, data: "Image file is missing or invalid.");
      return;
    } else {
      Map<String, dynamic> result = await organisedplanController
          .saveOrganisedFarmerMeeting(
            context,
            demoPlanController.productselectedValue.value?.productCode,
            demoPlanController.selectedCrop.value?.croPCODE,
            demoPlanController.selectedState.value?.statECODE,
            demoPlanController.selectedDistrict.value?.districTCODE,
            demoPlanController.selectedTehsil.value?.tehsiLCODE,
            demoPlanController.selectedvillage.value?.villagECODE,
            int.parse(txt_NoOfFarmerattendance.text),
            txt_Remarks.text,
            _latitude,
            _longitude,
            _address,
            _image,
            txt_FarmerName.text,
            txt_MobileNumber.text,
          );
      if (result['status'] == 200) {
        // Check for success (status code 200)
        Utility.alertSucess(context, data: result['message']);
        crearData();
      } else {
        Utility.alertInfo(context, data: result['message']);
      }
    }
  }

  void crearData() {
    txt_NoOfFarmerattendance.clear();
    txt_VillageName.clear();
    txt_Remarks.clear();
    txt_PinCode.clear();
    demoPlanController.productselectedValue.value = null;
    demoPlanController.selectedtank.value = null;
    demoPlanController.selectedCrop.value = null;
    demoPlanController.selectedState.value = null;
    demoPlanController.selectedDistrict.value = null;
    demoPlanController.selectedTehsil.value = null;
    demoPlanController.selectedvillage.value = null;
    _image = null; // Reset image
    setState(() {
      _latitude = null;
      _longitude = null;
      _address = null;
      _capturedDateTime = null;
    });
  }

  Future<void> _captureImageAndLocation() async {
    setState(() {
      _isImagesLoading = true; // Start loading
    });
    try {
      // Capture image from camera
      final pickedFile = (await _picker.pickImage(source: ImageSource.camera));

      if (pickedFile != null) {
        _image = File(pickedFile.path);

        // Get current date-time
        _capturedDateTime = DateTime.now();
        await bindLocatation();
        // Callback with image and location data
        widget.onImageCaptured(
          ImageAndLocationData(
            imagePath: _image!.path,
            latitude: _latitude!,
            longitude: _longitude!,
            locationName: _address ?? "Unknown",
            capturedDateTime: _capturedDateTime!,
          ),
        );
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Image capture canceled.")));
      }
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to capture image and location.")),
      );
    } finally {
      setState(() {
        _isImagesLoading = false; // Stop loading
      });
    }
  }

  Widget getProductMast() {
    return Obx(() {
      if (demoPlanController.isProcuctListLoading.value) {
        return const CircularProgressIndicator(); // Show loading indicator
      }

      if (demoPlanController.productList.isEmpty) {
        return const Text('No Product available'); // Show empty state
      }

      return DropdownButton<ProductData>(
        value: demoPlanController.productselectedValue.value,
        onChanged: (ProductData? value) {
          demoPlanController.productselectedValue.value =
              value; // Update selected product
        },
        items: [
          // Add a placeholder item with a null value
          DropdownMenuItem<ProductData>(
            value: null,
            child: Text(
              "Select Product Name",
              style: TextStyle(color: Colors.grey),
            ),
          ),
          ...demoPlanController.productList.map((product) {
            return DropdownMenuItem<ProductData>(
              value: product,
              child: Text(product.productName.toString()),
            );
          }),
        ],
        isExpanded: true,
      );
    });
  }

  Widget getCropMast() {
    return Obx(() {
      if (demoPlanController.isCropLoading.value) {
        return const CircularProgressIndicator(); // Show loading indicator
      }

      if (demoPlanController.cropList.isEmpty) {
        return const Text('No crops available'); // Show empty state
      }

      return DropdownButton<CropMast>(
        value: demoPlanController.selectedCrop.value, // Bind to selected crop
        onChanged: (CropMast? value) {
          demoPlanController.selectedCrop.value = value; // Update selected crop
        },
        items: [
          // Add a placeholder item with a null value
          DropdownMenuItem<CropMast>(
            value: null,
            child: Text(
              "Select Crop Name",
              style: TextStyle(color: Colors.grey),
            ),
          ),
          ...demoPlanController.cropList.map((crop) {
            return DropdownMenuItem<CropMast>(
              value: crop,
              child: Text(crop.croPNAME.toString()),
            );
          }),
        ],
        isExpanded: true,
      );
    });
  }

  Widget getStateMast() {
    return Obx(() {
      if (demoPlanController.isStateByEmpcodeListLoading.value) {
        return const CircularProgressIndicator(); // Show loading indicator
      }

      if (demoPlanController.stateList.isEmpty) {
        return const Text('No State available'); // Show empty state
      }

      return DropdownButton<StateData>(
        value: demoPlanController.selectedState.value, // Bind to selected crop
        onChanged: (StateData? value) {
          demoPlanController.selectedState.value =
              value; // Update selected crop
          bindDistrict(value!.statECODE);
        },
        items: [
          // Add a placeholder item with a null value
          DropdownMenuItem<StateData>(
            value: null,
            child: Text(
              "Select State Name",
              style: TextStyle(color: Colors.grey),
            ),
          ),
          ...demoPlanController.stateList.map((state) {
            return DropdownMenuItem<StateData>(
              value: state,
              child: Text(state.statENAME.toString()),
            );
          }),
        ],
        isExpanded: true,
      );
    });
  }

  Widget getDistrictMast() {
    return Obx(() {
      if (demoPlanController.isDistrictByEmpcodeListLoading.value) {
        return const CircularProgressIndicator(); // Show loading indicator
      }

      if (demoPlanController.districtList.isEmpty) {
        return const Text('No District available'); // Show empty state
      }

      return DropdownButton<DistrictData>(
        value:
            demoPlanController.selectedDistrict.value, // Bind to selected crop
        onChanged: (DistrictData? value) {
          demoPlanController.selectedDistrict.value =
              value; // Update selected crop
          bindTehsil(value!.districTCODE);
        },
        items: [
          // Add a placeholder item with a null value
          DropdownMenuItem<DistrictData>(
            value: null,
            child: Text(
              "Select District Name",
              style: TextStyle(color: Colors.grey),
            ),
          ),
          ...demoPlanController.districtList.map((district) {
            return DropdownMenuItem<DistrictData>(
              value: district,
              child: Text(district.districTNAME.toString()),
            );
          }),
        ],
        isExpanded: true,
      );
    });
  }

  Widget getTehsilMast() {
    return Obx(() {
      if (demoPlanController.isTehsilByEmpCodeListLoading.value) {
        return const CircularProgressIndicator(); // Show loading indicator
      }

      if (demoPlanController.districtList.isEmpty) {
        return const Text('No Tehsil available'); // Show empty state
      }

      return DropdownButton<TehsilData>(
        value: demoPlanController.selectedTehsil.value, // Bind to selected crop
        onChanged: (TehsilData? value) {
          demoPlanController.selectedTehsil.value =
              value; // Update selected crop
          bindVillage(value!.tehsiLCODE);
        },
        items: [
          // Add a placeholder item with a null value
          DropdownMenuItem<TehsilData>(
            value: null,
            child: Text(
              "Select Tehsil Name",
              style: TextStyle(color: Colors.grey),
            ),
          ),
          ...demoPlanController.tehsilList.map((tehsil) {
            return DropdownMenuItem<TehsilData>(
              value: tehsil,
              child: Text(tehsil.tehsiLNAME.toString()),
            );
          }),
        ],
        isExpanded: true,
      );
    });
  }

  Widget getVillageMast() {
    return Obx(() {
      if (demoPlanController.isVillageByEmpCodeListLoading.value) {
        return const CircularProgressIndicator(); // Show loading indicator
      }

      if (demoPlanController.villageList.isEmpty) {
        return const Text('No Village available'); // Show empty state
      }

      return DropdownButton<VillageData>(
        value:
            demoPlanController.selectedvillage.value, // Bind to selected crop
        onChanged: (VillageData? value) {
          demoPlanController.selectedvillage.value =
              value; // Update selected crop
          txt_PinCode.text = value!.piNCODE.toString();
        },
        items: [
          // Add a placeholder item with a null value
          DropdownMenuItem<VillageData>(
            value: null,
            child: Text(
              "Select Village Name",
              style: TextStyle(color: Colors.grey),
            ),
          ),
          ...demoPlanController.villageList.map((village) {
            return DropdownMenuItem<VillageData>(
              value: village,
              child: Text(village.villagENAME.toString()),
            );
          }),
        ],
        isExpanded: true,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kMainColor,
      appBar: AppBar(
        backgroundColor: kMainColor,
        elevation: 0.0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'Add Organized Farmer Meeting',
          style: kTextStyle.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: GetBuilder(
          builder: (DemoPlanController controller) {
            return controller.isDemoPlanLoading == true
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20.0),
                      Container(
                        //height: context.height(),
                        padding: const EdgeInsets.all(20.0),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30.0),
                            topRight: Radius.circular(30.0),
                          ),
                          color: Colors.white,
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              const SizedBox(height: 15.0),
                              SizedBox(
                                height: 55.0,
                                child: FormField(
                                  builder: (FormFieldState<dynamic> field) {
                                    return InputDecorator(
                                      decoration: InputDecoration(
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.always,
                                        labelText: 'Select Product Name',
                                        labelStyle: kTextStyle,
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            5.0,
                                          ),
                                        ),
                                      ),
                                      child: DropdownButtonHideUnderline(
                                        child: getProductMast(),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 15.0),
                              SizedBox(
                                height: 55.0,
                                child: FormField(
                                  builder: (FormFieldState<dynamic> field) {
                                    return InputDecorator(
                                      decoration: InputDecoration(
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.always,
                                        labelText: 'Select Crop',
                                        labelStyle: kTextStyle,
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            5.0,
                                          ),
                                        ),
                                      ),
                                      child: DropdownButtonHideUnderline(
                                        child: getCropMast(),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 15.0),
                              SizedBox(
                                height: 55.0,
                                child: FormField(
                                  builder: (FormFieldState<dynamic> field) {
                                    return InputDecorator(
                                      decoration: InputDecoration(
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.always,
                                        labelText: 'Select State',
                                        labelStyle: kTextStyle,
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            5.0,
                                          ),
                                        ),
                                      ),
                                      child: DropdownButtonHideUnderline(
                                        child: getStateMast(),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 15.0),
                              SizedBox(
                                height: 55.0,
                                child: FormField(
                                  builder: (FormFieldState<dynamic> field) {
                                    return InputDecorator(
                                      decoration: InputDecoration(
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.always,
                                        labelText: 'Select District',
                                        labelStyle: kTextStyle,
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            5.0,
                                          ),
                                        ),
                                      ),
                                      child: DropdownButtonHideUnderline(
                                        child: getDistrictMast(),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 15.0),
                              SizedBox(
                                height: 55.0,
                                child: FormField(
                                  builder: (FormFieldState<dynamic> field) {
                                    return InputDecorator(
                                      decoration: InputDecoration(
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.always,
                                        labelText: 'Select Tehsil',
                                        labelStyle: kTextStyle,
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            5.0,
                                          ),
                                        ),
                                      ),
                                      child: DropdownButtonHideUnderline(
                                        child: getTehsilMast(),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 15.0),
                              SizedBox(
                                height: 55.0,
                                child: FormField(
                                  builder: (FormFieldState<dynamic> field) {
                                    return InputDecorator(
                                      decoration: InputDecoration(
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.always,
                                        labelText: 'Select Village',
                                        labelStyle: kTextStyle,
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            5.0,
                                          ),
                                        ),
                                      ),
                                      child: DropdownButtonHideUnderline(
                                        child: getVillageMast(),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 15.0),
                              SizedBox(
                                child: AppTextField(
                                  controller: txt_PinCode,
                                  textFieldType: TextFieldType.NAME,
                                  decoration: const InputDecoration(
                                    labelText: "Pincode",
                                    enabled: false,
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    hintText: "Pincode",
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20.0),
                              SizedBox(
                                height: 50,
                                child: TextFormField(
                                  controller: txt_FarmerName,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: const InputDecoration(
                                    labelText: "Farmers Name",
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    hintText: "Farmers Name",
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20.0),
                              SizedBox(
                                child: TextFormField(
                                  controller: txt_MobileNumber,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter
                                        .digitsOnly, // Allow only digits
                                  ],
                                  maxLength: 10,
                                  // Limit to 10 digits
                                  decoration: const InputDecoration(
                                    labelText: "Mobile No.",
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    hintText: "Mobile No.",
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20.0),
                              SizedBox(
                                height: 50,
                                child: TextFormField(
                                  controller: txt_NoOfFarmerattendance,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter
                                        .digitsOnly, // Allow only digits
                                  ],
                                  decoration: const InputDecoration(
                                    labelText: "No. of farmers attended",
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    hintText: "No. of farmers attended",
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20.0),
                              AppTextField(
                                controller: txt_Remarks,
                                textFieldType: TextFieldType.MULTILINE,
                                decoration: const InputDecoration(
                                  labelText: 'Remarks',
                                  enabled: true,
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              const SizedBox(height: 10.0),
                              ElevatedButton.icon(
                                onPressed: _isImagesLoading
                                    ? null
                                    : _captureImageAndLocation, // Disable button while loading
                                icon: Icon(Icons.camera),
                                label: Text("Capture Image with Location"),
                              ),
                              SizedBox(height: 20),
                              if (_isImagesLoading)
                                Center(
                                  child: CircularProgressIndicator(), // Show loading indicator
                                ),
                              if (!_isImagesLoading && _image != null)
                                Column(
                                  children: [
                                    Stack(
                                      alignment: Alignment.bottomCenter,
                                      children: [
                                        Image.file(
                                          _image!,
                                          height: 400,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                        ),
                                        Container(
                                          width: double.infinity,
                                          color: Colors.black.withValues(
                                            alpha: 0.5,
                                          ),
                                          padding: EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                "Latitude: $_latitude",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                              Text(
                                                "Longitude: $_longitude",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                              Text(
                                                "Address: $_address",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                              Text(
                                                "Captured Date-Time: $_capturedDateTime",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              if (!_isImagesLoading && _image == null)
                                Text("No image captured yet."),
                              SizedBox(height: 20),
                              Center(
                                child: Obx(
                                  () => ButtonGlobal(
                                    buttontext:
                                        organisedplanController
                                                .isSaveOrganisedFarmerLoding ==
                                            true
                                        ? "Processing"
                                        : 'Save',
                                    buttonDecoration: kButtonDecoration
                                        .copyWith(color: kMainColor),
                                    onPressed: () {
                                      if (organisedplanController
                                              .isSaveOrganisedFarmerLoding ==
                                          false) {
                                        saveDemoPlanData();
                                      }
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20.0),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
          },
        ),
      ),
    );
  }
}

class ImageAndLocationData {
  final String imagePath;
  final double latitude;
  final double longitude;
  final String locationName;
  final DateTime capturedDateTime;

  ImageAndLocationData({
    required this.imagePath,
    required this.latitude,
    required this.longitude,
    required this.locationName,
    required this.capturedDateTime,
  });
}
