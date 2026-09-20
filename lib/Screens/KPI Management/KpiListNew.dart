import 'package:aeon_hrms/Screens/KPI%20Management/Collection%20Plan/view/AddCollectionPlan.dart';
import 'package:aeon_hrms/Screens/KPI%20Management/Demo%20Plan/view/AddDemoPlan.dart';
import 'package:aeon_hrms/Screens/KPI%20Management/Farmer%20Connectivity%20Entry/view/AddFarmerConnectivityEntry.dart';
import 'package:aeon_hrms/Screens/KPI%20Management/FieldDays/view/AddFieldDays.dart';
import 'package:aeon_hrms/Screens/KPI%20Management/LiquidationPlan/view/AddLiquidationPlan.dart';
import 'package:aeon_hrms/Screens/KPI%20Management/Organised%20Farmer/view/AddOrganisedFarmerMeeting.dart';
import 'package:aeon_hrms/Screens/KPI%20Management/Retailer%20Distributor%20Visit%20Entry/view/AddRetailerDistributorVisitEntry.dart';
import 'package:aeon_hrms/Screens/KPI%20Management/Unorganised%20Farmer/view/AddUnorganizedFarmerMeeting.dart';
import 'package:flutter/material.dart';
import 'package:aeon_hrms/constant.dart';
import 'package:nb_utils/nb_utils.dart';

class KpiListNew extends StatefulWidget {
  const KpiListNew({super.key});

  @override
  _KpiListNewState createState() => _KpiListNewState();
}

class _KpiListNewState extends State<KpiListNew> {
  bool isApproved = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: kMainColor,
      appBar: AppBar(
        backgroundColor: kMainColor,
        elevation: 0.0,
        titleSpacing: 0.0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          "KPI List Details",
          maxLines: 2,
          style: kTextStyle.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20.0),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20.0),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
                color: Colors.white,
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 20.0),
                    Material(
                      elevation: 2.0,
                      child: GestureDetector(
                        onTap: () {
                          //DemoPlanDetails().launch(context);
                          AddDemoPlan(
                            onImageCaptured: (ImageAndLocationData) {},
                          ).launch(context);
                        },
                        child: Container(
                          width: context.width(),
                          padding: const EdgeInsets.all(10.0),
                          decoration: const BoxDecoration(
                            border: Border(
                              left: BorderSide(
                                color: Color(0xFF7D6AEF),
                                width: 3.0,
                              ),
                            ),
                            color: Colors.white,
                          ),
                          child: ListTile(
                            title: Text(
                              "Demo Plan",
                              maxLines: 2,
                              style: kTextStyle.copyWith(
                                color: kTitleColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            trailing: const Icon(Icons.arrow_forward_ios),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Material(
                      elevation: 2.0,
                      child: GestureDetector(
                        onTap: () {
                          //const OrganisedPlanDetails().launch(context);
                          AddOrganisedFarmerMeeting(
                            onImageCaptured: (ImageAndLocationData) {},
                          ).launch(context);
                        },
                        child: Container(
                          width: context.width(),
                          padding: const EdgeInsets.all(10.0),
                          decoration: const BoxDecoration(
                            border: Border(
                              left: BorderSide(
                                color: Color(0xFF7D6AEF),
                                width: 3.0,
                              ),
                            ),
                            color: Colors.white,
                          ),
                          child: ListTile(
                            title: Text(
                              "Organized Farmer Meeting",
                              maxLines: 2,
                              style: kTextStyle.copyWith(
                                color: kTitleColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            trailing: const Icon(Icons.arrow_forward_ios),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Material(
                      elevation: 2.0,
                      child: GestureDetector(
                        onTap: () {
                          AddUnorganizedFarmerMeeting(
                            onImageCaptured: (ImageAndLocationData) {},
                          ).launch(context);
                        },
                        child: Container(
                          width: context.width(),
                          padding: const EdgeInsets.all(10.0),
                          decoration: const BoxDecoration(
                            border: Border(
                              left: BorderSide(
                                color: Color(0xFF7D6AEF),
                                width: 3.0,
                              ),
                            ),
                            color: Colors.white,
                          ),
                          child: ListTile(
                            title: Text(
                              "Unorganized Farmer Meeting",
                              maxLines: 2,
                              style: kTextStyle.copyWith(
                                color: kTitleColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            trailing: const Icon(Icons.arrow_forward_ios),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Material(
                      elevation: 2.0,
                      child: GestureDetector(
                        onTap: () {
                          AddFieldDays(
                            onImageCaptured: (ImageAndLocationData) {},
                          ).launch(context);
                        },
                        child: Container(
                          width: context.width(),
                          padding: const EdgeInsets.all(10.0),
                          decoration: const BoxDecoration(
                            border: Border(
                              left: BorderSide(
                                color: Color(0xFF7D6AEF),
                                width: 3.0,
                              ),
                            ),
                            color: Colors.white,
                          ),
                          child: ListTile(
                            title: Text(
                              "Field Days",
                              maxLines: 2,
                              style: kTextStyle.copyWith(
                                color: kTitleColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            trailing: const Icon(Icons.arrow_forward_ios),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Material(
                      elevation: 2.0,
                      child: GestureDetector(
                        onTap: () {
                          const AddLiquidationPlan().launch(context);
                        },
                        child: Container(
                          width: context.width(),
                          padding: const EdgeInsets.all(10.0),
                          decoration: const BoxDecoration(
                            border: Border(
                              left: BorderSide(
                                color: Color(0xFF7D6AEF),
                                width: 3.0,
                              ),
                            ),
                            color: Colors.white,
                          ),
                          child: ListTile(
                            title: Text(
                              "Liquidation Plan",
                              maxLines: 2,
                              style: kTextStyle.copyWith(
                                color: kTitleColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            trailing: const Icon(Icons.arrow_forward_ios),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Material(
                      elevation: 2.0,
                      child: GestureDetector(
                        onTap: () {
                          const AddCollectionPlan().launch(context);
                        },
                        child: Container(
                          width: context.width(),
                          padding: const EdgeInsets.all(10.0),
                          decoration: const BoxDecoration(
                            border: Border(
                              left: BorderSide(
                                color: Color(0xFF7D6AEF),
                                width: 3.0,
                              ),
                            ),
                            color: Colors.white,
                          ),
                          child: ListTile(
                            title: Text(
                              "Collection Plan",
                              maxLines: 2,
                              style: kTextStyle.copyWith(
                                color: kTitleColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            trailing: const Icon(Icons.arrow_forward_ios),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Material(
                      elevation: 2.0,
                      child: GestureDetector(
                        onTap: () {
                          const AddFarmerConnectivityEntry().launch(context);
                        },
                        child: Container(
                          width: context.width(),
                          padding: const EdgeInsets.all(10.0),
                          decoration: const BoxDecoration(
                            border: Border(
                              left: BorderSide(
                                color: Color(0xFF7D6AEF),
                                width: 3.0,
                              ),
                            ),
                            color: Colors.white,
                          ),
                          child: ListTile(
                            title: Text(
                              "Farmer Connectivity Entry",
                              maxLines: 2,
                              style: kTextStyle.copyWith(
                                color: kTitleColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            trailing: const Icon(Icons.arrow_forward_ios),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Material(
                      elevation: 2.0,
                      child: GestureDetector(
                        onTap: () {
                          const AddRetailerDistributorVisitEntry().launch(
                            context,
                          );
                        },
                        child: Container(
                          width: context.width(),
                          padding: const EdgeInsets.all(10.0),
                          decoration: const BoxDecoration(
                            border: Border(
                              left: BorderSide(
                                color: Color(0xFF7D6AEF),
                                width: 3.0,
                              ),
                            ),
                            color: Colors.white,
                          ),
                          child: ListTile(
                            title: Text(
                              "Retailer / Distributor Visit Entry",
                              maxLines: 2,
                              style: kTextStyle.copyWith(
                                color: kTitleColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            trailing: const Icon(Icons.arrow_forward_ios),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
