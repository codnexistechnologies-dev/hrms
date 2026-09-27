import 'package:aeon_hrms/Screens/KPI%20Management/LiquidationPlan/controller/LiquidationPlanController.dart';
import 'package:aeon_hrms/Utility/utility_function.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:aeon_hrms/GlobalComponents/button_global.dart';
import 'package:aeon_hrms/constant.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../widgets/contact_entry_form_support.dart';

class AddLiquidationPlan extends StatefulWidget {
  const AddLiquidationPlan({super.key});

  @override
  _AddLiquidationPlanState createState() => _AddLiquidationPlanState();
}

class _AddLiquidationPlanState
    extends ContactEntryFormState<AddLiquidationPlan> {
  final liquidationPlanController = Get.put(
    LiquidationPlanController(),
    permanent: true,
  );
  final TextEditingController txt_Atdate = TextEditingController();
  final TextEditingController txt_Target = TextEditingController();
  final TextEditingController txt_Achieved = TextEditingController();
  final TextEditingController txt_Remarks = TextEditingController();

  @override
  void dispose() {
    Get.delete<LiquidationPlanController>();
    txt_Atdate.dispose();
    txt_Target.dispose();
    txt_Achieved.dispose();
    txt_Remarks.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    String currentDate = DateTime.now().toString().substring(0, 10);
    liquidationPlanController.GetKpiMasterByUseridandPaydate(currentDate);
    txt_Atdate.text = currentDate;
  }

  bool isLoading = false;
  Future<void> saveLiquidationPlanData() async {
    final productCode =
        demoPlanController.productselectedValue.value?.productCode;
    if (productCode == null) {
      Utility.alertInfo(context, data: 'Please Select Product Name.');
      return;
    }
    if (txt_Achieved.text == "") {
      Utility.alertInfo(context, data: "Achieved Can't be blank.");
      return;
    } else {
      Map<String, dynamic> result = await liquidationPlanController
          .saveLiquidationPlan(
            context,
            productCode,
            int.parse(txt_Achieved.text),
            txt_Remarks.text,
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
    txt_Achieved.clear();
    txt_Remarks.clear();
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
          'Add Liquidation Plan',
          style: kTextStyle.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Obx(() {
          //child: GetBuilder(builder: (LiquidationPlanController controller) {
          return liquidationPlanController.isKpiMasterLoading.value == true
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 20.0),
                    Container(
                      height: MediaQuery.of(context).size.height,
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
                            const SizedBox(height: 20.0),
                            SizedBox(
                              child: AppTextField(
                                controller: txt_Atdate,
                                textFieldType: TextFieldType.NAME,
                                decoration: const InputDecoration(
                                  labelText: "Atdate",
                                  enabled: false,
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  hintText: "Atdate",
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20.0),
                            productDropdown(required: true),
                            const SizedBox(height: 20.0),
                            SizedBox(
                              child: AppTextField(
                                controller: txt_Target
                                  ..text =
                                      liquidationPlanController
                                          .kpimasterList
                                          .isNotEmpty
                                      ? (liquidationPlanController
                                                    .kpimasterList
                                                    .first
                                                    .liquidatioNPLAN ??
                                                0)
                                            .toString()
                                      : "0",
                                textFieldType: TextFieldType.NAME,
                                decoration: const InputDecoration(
                                  labelText: "Target",
                                  enabled: false,
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  hintText: "Target",
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20.0),
                            SizedBox(
                              height: 50,
                              child: AppTextField(
                                controller: txt_Achieved,
                                textFieldType: TextFieldType.NUMBER,
                                decoration: const InputDecoration(
                                  labelText: "Achieved",
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  hintText: "Achieved",
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
                            //const Spacer(),
                            const SizedBox(height: 40.0),
                            ButtonGlobal(
                              buttontext:
                                  liquidationPlanController
                                      .isSaveLiquaidationPlanLoding
                                      .value
                                  ? "Processing"
                                  : 'Save',
                              buttonDecoration: kButtonDecoration.copyWith(
                                color: kMainColor,
                              ),
                              onPressed: () {
                                if (!liquidationPlanController
                                    .isSaveLiquaidationPlanLoding
                                    .value) {
                                  saveLiquidationPlanData();
                                }
                              },
                            ),
                            const SizedBox(height: 20.0),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
        }),
      ),
    );
  }
}
