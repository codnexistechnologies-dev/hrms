import 'package:get/get.dart';

import '../model/RetailerDistributorVisitEntryModel.dart';

/// Holds the entry draft. API methods will follow the confirmed backend contract.
class RetailerDistributorVisitEntryController extends GetxController {
  final entry = RetailerDistributorVisitEntryModel().obs;

  void setEntry(RetailerDistributorVisitEntryModel value) {
    entry.value = value;
  }

  void resetEntry() {
    entry.value = RetailerDistributorVisitEntryModel();
  }
}
