import 'package:flutter/material.dart';
import 'package:aeon_hrms/Screens/KPI/view/AddKpiHist.dart';
import 'package:aeon_hrms/Screens/KPI/view/KpiHistStatusMonthly.dart';
import 'package:aeon_hrms/constant.dart';
import 'package:nb_utils/nb_utils.dart';

class KpiList extends StatefulWidget {
  const KpiList({super.key});

  @override
  _KpiListState createState() => _KpiListState();
}

class _KpiListState extends State<KpiList> {
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
          "KPI Daily Details",
          maxLines: 2,
          style: kTextStyle.copyWith(
              color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20.0,
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20.0),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0)),
                color: Colors.white,
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20.0,
                    ),
                    Material(
                      elevation: 2.0,
                      child: GestureDetector(
                        onTap: () {
                          const AddKpiHist().launch(context);
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
                              "Add KPI",
                              maxLines: 2,
                              style: kTextStyle.copyWith(
                                  color: kTitleColor,
                                  fontWeight: FontWeight.bold),
                            ),
                            trailing: const Icon(Icons.arrow_forward_ios),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Material(
                      elevation: 2.0,
                      child: GestureDetector(
                        onTap: () {
                          //const AddKpiMaster().launch(context);
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
                              "Add KPI Master",
                              maxLines: 2,
                              style: kTextStyle.copyWith(
                                  color: kTitleColor,
                                  fontWeight: FontWeight.bold),
                            ),
                            trailing: const Icon(Icons.arrow_forward_ios),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Material(
                      elevation: 2.0,
                      child: GestureDetector(
                        onTap: () {
                          const KpiHistStatusMonthly().launch(context);
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
                              "KPI Status",
                              maxLines: 2,
                              style: kTextStyle.copyWith(
                                  color: kTitleColor,
                                  fontWeight: FontWeight.bold),
                            ),
                            trailing: const Icon(Icons.arrow_forward_ios),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
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
