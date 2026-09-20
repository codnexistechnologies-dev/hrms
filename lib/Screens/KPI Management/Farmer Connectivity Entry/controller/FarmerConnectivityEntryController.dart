import 'package:get/get.dart';

import '../model/FarmerConnectivityEntryModel.dart';

/// Holds the entry draft. API methods will follow the confirmed backend contract.
class FarmerConnectivityEntryController extends GetxController {
  final entry = FarmerConnectivityEntryModel().obs;

  void setEntry(FarmerConnectivityEntryModel value) {
    entry.value = value;
  }

  void resetEntry() {
    entry.value = FarmerConnectivityEntryModel();
  }
}
