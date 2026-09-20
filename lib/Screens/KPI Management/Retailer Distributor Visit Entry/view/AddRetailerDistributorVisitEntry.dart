import 'package:aeon_hrms/constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/RetailerDistributorVisitEntryController.dart';

class AddRetailerDistributorVisitEntry extends StatelessWidget {
  const AddRetailerDistributorVisitEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RetailerDistributorVisitEntryController>(
      init: RetailerDistributorVisitEntryController(),
      global: false,
      builder: (controller) => Scaffold(
        backgroundColor: kMainColor,
        appBar: AppBar(
          backgroundColor: kMainColor,
          foregroundColor: Colors.white,
          title: const Text('Retailer / Distributor Visit Entry'),
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
