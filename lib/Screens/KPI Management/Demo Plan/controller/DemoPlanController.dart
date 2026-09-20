import 'dart:convert';
import 'dart:io';

import 'package:aeon_hrms/Screens/KPI%20Management/Demo%20Plan/model/DemoPlanAchievementModel.dart';
import 'package:aeon_hrms/Screens/KPI%20Management/Demo%20Plan/model/DemoPlanHistByEmpCodeAndAtdate.dart';
import 'package:aeon_hrms/Screens/KPI%20Management/Demo%20Plan/model/DistrictMasterModel.dart';
import 'package:aeon_hrms/Screens/KPI%20Management/Demo%20Plan/model/StateMasterModel.dart';
import 'package:aeon_hrms/Screens/KPI%20Management/Demo%20Plan/model/TehsilListModel.dart';
import 'package:aeon_hrms/Screens/KPI%20Management/Demo%20Plan/model/VillageListModel.dart';
import 'package:aeon_hrms/Screens/KPI%20Management/Organised%20Farmer/model/CropMastModel.dart';
import 'package:aeon_hrms/Screens/KPI%20Management/Organised%20Farmer/model/TankMastModel.dart';
import 'package:aeon_hrms/Utility/api_constants.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:http/http.dart' as http;
import 'package:aeon_hrms/Screens/KPI%20Management/Demo%20Plan/model/ProductMasterListModel.dart';
import 'package:aeon_hrms/Utility/MLString.dart';
import 'package:aeon_hrms/Utility/shared_preferences_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:dio/dio.dart' as dio;

class DemoPlanController extends GetxController {
  RxBool isProcuctListLoading = false.obs;
  RxBool isTankLoading = false.obs;
  RxBool isCropLoading = false.obs;
  RxBool isStateListLoading = false.obs;
  RxBool isStateByEmpcodeListLoading = false.obs;
  RxBool isDistrictListLoading = false.obs;
  RxBool isDistrictByEmpcodeListLoading = false.obs;
  RxBool isTehsilByEmpCodeListLoading = false.obs;
  RxBool isVillageByEmpCodeListLoading = false.obs;
  RxList<TankMast> tankList = <TankMast>[].obs; // Observable list
  Rx<TankMast?> selectedtank = Rxn<TankMast>(); // Nullable observab
  //  ProductMasterListModel? productMasterListModel;
  RxList<ProductData> productList = <ProductData>[].obs;
  Rx<ProductData?> productselectedValue = Rx<ProductData?>(null);
  RxList<CropMast> cropList = <CropMast>[].obs;
  Rx<CropMast?> selectedCrop = Rx<CropMast?>(null);
  RxList<StateData> stateList = <StateData>[].obs;
  Rx<StateData?> selectedState = Rx<StateData?>(null);
  RxList<DistrictData> districtList = <DistrictData>[].obs;
  Rx<DistrictData?> selectedDistrict = Rx<DistrictData?>(null);
  RxList<TehsilData> tehsilList = <TehsilData>[].obs;
  Rx<TehsilData?> selectedTehsil = Rx<TehsilData?>(null);
  RxList<VillageData> villageList = <VillageData>[].obs;
  Rx<VillageData?> selectedvillage = Rx<VillageData?>(null);
  DemoPlanHistByEmpCodeAndAtdate? demoPlanHistByEmpCodeAndAtdate;

  var isDemoPlanLoading = false;

  Future<void> getAllProductList() async {
    isProcuctListLoading.value = true; // CORRECT

    try {
      final response = await http.get(
        Uri.parse('${ApiConstant.baseUrl}/api/Kpi/GetAllProductList'),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        ProductMasterListModel productMaster = ProductMasterListModel.fromJson(
          jsonResponse,
        );

        productList.value = productMaster.data ?? [];
      } else {
        throw Exception('Failed to fetch ProductList');
      }
    } catch (e) {
      print('Error fetching product list: $e');
    } finally {
      isProcuctListLoading.value = false; // CORRECT
    }
  }

  Future<void> GetAllCropList() async {
    isCropLoading.value = true; // CORRECT

    try {
      final response = await http.get(
        Uri.parse('${ApiConstant.baseUrl}/api/Kpi/GetAllCropList'),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        CropMastModel cropMaster = CropMastModel.fromJson(jsonResponse);

        cropList.value = cropMaster.data ?? [];
      } else {
        throw Exception('Failed to fetch ProductList');
      }
    } catch (e) {
      print('Error fetching product list: $e');
    } finally {
      isCropLoading.value = false; // CORRECT
    }
  }

  //var isTankLoading = false;
  Future<void> GetAllTankList() async {
    isTankLoading.value = true; // CORRECT

    try {
      final response = await http.get(
        Uri.parse('${ApiConstant.baseUrl}/api/Kpi/GetAllTankList'),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        TankMastModel tankMastModel = TankMastModel.fromJson(jsonResponse);

        tankList.value = tankMastModel.data ?? [];
      } else {
        throw Exception('Failed to fetch ProductList');
      }
    } catch (e) {
      print('Error fetching product list: $e');
    } finally {
      isTankLoading.value = false; // CORRECT
    }
  }

  Future<void> getAllStateMasterList() async {
    isStateListLoading.value = true;

    try {
      final response = await http.get(
        Uri.parse('${ApiConstant.baseUrl}/api/Kpi/GetAllStateList'),
      );
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        StateMasterModel stateData = StateMasterModel.fromJson(jsonResponse);
        stateList.value = stateData.data ?? [];
      } else {
        throw Exception('Failed to State List');
      }
    } catch (e) {
      print('Error fetching State list: $e');
    } finally {
      isStateListLoading.value = false;
      update();
    }
  }

  Future<void> GetStateListByEmpCode() async {
    isStateByEmpcodeListLoading.value = true;
    String? empCode = SharedPref.getEmpCode();
    try {
      final response = await http.get(
        Uri.parse(
          '${ApiConstant.baseUrl}/api/Kpi/GetStateListByEmpCode?EMP_CODE=$empCode',
        ),
      );
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        StateMasterModel stateData = StateMasterModel.fromJson(jsonResponse);
        stateList.value = stateData.data ?? [];
      } else {
        throw Exception('Failed to State List');
      }
    } catch (e) {
      print('Error fetching State list: $e');
    } finally {
      isStateByEmpcodeListLoading.value = false;
      update();
    }
  }

  Future<void> getDistrictListByStateCode(String stateCode) async {
    isDistrictListLoading.value = true;
    try {
      final response = await http.post(
        Uri.parse(
          '${ApiConstant.baseUrl}/api/Kpi/GetDistrictListByStateCode?STATE_CODE=$stateCode',
        ),
      );
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        DistrictMasterModel districtMasterModel = DistrictMasterModel.fromJson(
          jsonResponse,
        );
        districtList.value = districtMasterModel.data ?? [];
      } else {
        throw Exception('Failed to DistrictList');
      }
    } catch (e) {
      print('Error fetching District list: $e');
    } finally {
      isDistrictListLoading.value = false;
      update();
    }
  }

  Future<void> GetDistrictListByStateCodeandEmpCode(String? stateCode) async {
    isDistrictByEmpcodeListLoading.value = true;
    String? empCode = SharedPref.getEmpCode();
    try {
      final response = await http.post(
        Uri.parse(
          '${ApiConstant.baseUrl}/api/Kpi/GetDistrictListByStateCodeandEmpCode?STATE_CODE=$stateCode&EMP_CODE=$empCode',
        ),
      );
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        DistrictMasterModel districtMasterModel = DistrictMasterModel.fromJson(
          jsonResponse,
        );
        districtList.value = districtMasterModel.data ?? [];
      } else {
        throw Exception('Failed to DistrictList');
      }
    } catch (e) {
      print('Error fetching District list: $e');
    } finally {
      isDistrictByEmpcodeListLoading.value = false;
      update();
    }
  }

  var isTehsilListLoading = false;
  Future<void> getTehsilListByDistrictCode(int? districTCODE) async {
    isTehsilListLoading = true;
    try {
      final response = await http.post(
        Uri.parse(
          '${ApiConstant.baseUrl}/api/Kpi/GetTehsilListByDistrictCode?DISTRICT_CODE=$districTCODE',
        ),
      );
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        TehsilListModel tehsilListModel = TehsilListModel.fromJson(
          jsonResponse,
        );
        tehsilList.value = tehsilListModel.data ?? [];
      } else {
        throw Exception('Failed to TehsilList');
      }
    } catch (e) {
      print('Error fetching Tehsil list: $e');
    } finally {
      isTehsilListLoading = false;
      update();
    }
  }

  Future<void> GetTehsilListByDistrictCodeandEmpCode(int? districTCODE) async {
    isTehsilByEmpCodeListLoading.value = true;
    String? empCode = SharedPref.getEmpCode();
    try {
      final response = await http.post(
        Uri.parse(
          '${ApiConstant.baseUrl}/api/Kpi/GetTehsilListByDistrictCodeandEmpCode?DISTRICT_CODE=$districTCODE&EMP_CODE=$empCode',
        ),
      );
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        TehsilListModel tehsilListModel = TehsilListModel.fromJson(
          jsonResponse,
        );
        tehsilList.value = tehsilListModel.data ?? [];
      } else {
        throw Exception('Failed to TehsilList');
      }
    } catch (e) {
      print('Error fetching Tehsil list: $e');
    } finally {
      isTehsilByEmpCodeListLoading.value = false;
      update();
    }
  }

  var isVillageListLoading = false;
  Future<void> getVillageListByTehsilCode(int? tehsiLCODE) async {
    isVillageListLoading = true;
    try {
      final response = await http.post(
        Uri.parse(
          '${ApiConstant.baseUrl}/api/Kpi/GetVillageListByTehsilCode?TEHSIL_CODE=$tehsiLCODE',
        ),
      );
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        VillageListModel villageListModel = VillageListModel.fromJson(
          jsonResponse,
        );
        villageList.value = villageListModel.data ?? [];
      } else {
        throw Exception('Failed to TehsilList');
      }
    } catch (e) {
      print('Error fetching Tehsil list: $e');
    } finally {
      isVillageListLoading = false;
      update();
    }
  }

  Future<void> GetVillageListByTehsilCodeByEmpCode(int? tehsiLCODE) async {
    isVillageByEmpCodeListLoading.value = true;
    String? empCode = SharedPref.getEmpCode();
    try {
      final response = await http.post(
        Uri.parse(
          '${ApiConstant.baseUrl}/api/Kpi/GetVillageListByTehsilCodeByEmpCode?TEHSIL_CODE=$tehsiLCODE&EMP_CODE=$empCode',
        ),
      );
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        VillageListModel villageListModel = VillageListModel.fromJson(
          jsonResponse,
        );
        villageList.value = villageListModel.data ?? [];
      } else {
        throw Exception('Failed to TehsilList');
      }
    } catch (e) {
      print('Error fetching Tehsil list: $e');
    } finally {
      isVillageByEmpCodeListLoading.value = false;
      update();
    }
  }

  var isSaveDemoPlan = false.obs;
  Future<Map<String, dynamic>> saveDemoPlan(
    BuildContext context,
    int? productCode,
    int? cropCode,
    int? tankCode,
    String? stateCode,
    int? distictCode,
    int? tehsilCode,
    int? villageCode,
    String txtFarmername,
    String txtMobileno,
    String txtRemarks,
    double? txtLat,
    double? txtLong,
    String? txtAddress,
    File? imagesFile,
  ) async {
    isSaveDemoPlan.value = true;
    update();

    String? empCode = SharedPref.getEmpCode();
    String imageFile = imagesFile!.path.split('/').last;

    try {
      if (!imagesFile.existsSync()) {
        throw Exception("Image file not found.");
      }

      dio.FormData formData = dio.FormData.fromMap({
        'EMP_CODE': empCode,
        'PRODUCT_CODE': productCode,
        'CROP_CODE': cropCode,
        'TANK_CODE': tankCode,
        'STATE_CODE': stateCode,
        'DISTRICT_CODE': distictCode,
        'TEHSIL_CODE': tehsilCode,
        'VILLAGE_CODE': villageCode,
        'FARMER_NAME': txtFarmername,
        'MOBILE_NO': txtMobileno,
        'REMARKS': txtRemarks,
        'LATITUDE': txtLat,
        'LONGITUDE': txtLong,
        'ADDRESS': txtAddress,
        'IMAGE_FILE': await dio.MultipartFile.fromFile(
          imagesFile.path,
          filename: imageFile,
        ),
      });

      var myDio = dio.Dio();
      var response = await myDio.post(
        '${ApiConstant.baseUrl}/api/Kpi/AddDemoPlan',
        data: formData,
        options: dio.Options(headers: {'Content-Type': 'multipart/form-data'}),
      );
      if (response.statusCode == 200) {
        return {
          'status': response.statusCode,
          'message': 'Demo Plan saved successfully!',
        };
      } else {
        return {
          'status': response.statusCode,
          'message': 'Server returned status code ${response.statusCode}',
        };
      }
    } catch (e) {
      return {
        'status': 500,
        'message': 'Failed to save Demo Plan. Please try again.',
      };
    } finally {
      isSaveDemoPlan.value = false;
      update();
    }
  }

  var isDemoPlanAchievementLoading = false.obs; // Made observable if using GetX
  RxList<DemoPlanAchievement> demoPlanAchievementList =
      <DemoPlanAchievement>[].obs;

  Future<void> GetDemoPlanAchievementByUseridandPayDate(String atdate) async {
    isDemoPlanAchievementLoading.value =
        true; // Use observable for state management
    try {
      String? empCode = SharedPref.getEmpCode();
      if (empCode == null) {
        throw Exception('Employee code is null');
      }

      final response = await http.post(
        Uri.parse(
          '${ApiConstant.baseUrl}/api/Kpi/GetDemoPlanAchievementByUseridandPayDate?EMP_CODE=$empCode&PAYDATE=$atdate',
        ),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        DemoPlanAchievementModel demoPlanAchievement =
            DemoPlanAchievementModel.fromJson(jsonResponse);
        demoPlanAchievementList.value =
            demoPlanAchievement.data ?? []; // Assign data directly
      } else {
        throw Exception(
          'Failed to load data, status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      isDemoPlanAchievementLoading.value = false;
    }
  }
}
