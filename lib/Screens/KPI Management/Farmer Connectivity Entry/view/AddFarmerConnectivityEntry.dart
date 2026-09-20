import 'package:aeon_hrms/constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/FarmerConnectivityEntryController.dart';

class AddFarmerConnectivityEntry extends StatelessWidget {
  const AddFarmerConnectivityEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FarmerConnectivityEntryController>(
      init: FarmerConnectivityEntryController(),
      global: false,
      builder: (controller) => Scaffold(
        backgroundColor: kMainColor,
        appBar: AppBar(
          backgroundColor: kMainColor,
          foregroundColor: Colors.white,
          title: const Text('Farmer Connectivity Entry'),
        ),
        // Add the entry fields here once their requirements are confirmed.
        body: Container(
          width: double.infinity,
          margin: const EdgeInsets.only(top: 20),
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: const SizedBox.expand(),
        ),
      ),
    );
  }
}
