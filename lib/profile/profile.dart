import 'package:aeon_hrms/constant.dart';
import 'package:aeon_hrms/profile/widgets/profile2.dart';
import 'package:aeon_hrms/profile/widgets/profile3.dart';
import 'package:aeon_hrms/profile/widgets/profiledetails.dart';
import 'package:flutter/material.dart';

import 'package:nb_utils/nb_utils.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final PageController _pageController = PageController(initialPage: 0);
  int indexval = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kMainColor,
        elevation: 0.0,
        titleSpacing: 0.0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'Profile',
          maxLines: 2,
          style: kTextStyle.copyWith(
              color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: kMainColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 30.0,
          ),
          Expanded(
            child: Container(
              width: context.width(),
              padding: const EdgeInsets.all(20.0),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0)),
                color: Colors.white,
              ),
              child: Stack(
                children: [
                  Column(
                    children: [
                      Expanded(
                        child: PageView.builder(
                          controller: _pageController,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: 3,
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              return const ProfileDetails();
                            } else if (index == 1) {
                              return const ProfileSecond();
                            } else {
                              return const ProfileThree();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    bottom: 40,
                    left: 20,
                    right: 20,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                            onTap: () {
                              if (_pageController.page != 0) {
                                setState(() {
                                  indexval--;
                                  // visitController.increse();
                                });
                                _pageController.previousPage(
                                    duration: const Duration(milliseconds: 200),
                                    curve: Curves.easeInOut);
                              }
                              print(
                                  "checking pagecontroller value ${_pageController.page}");
                            },
                            child: Container(
                              height: 50,
                              width: 100,
                              decoration: const BoxDecoration(
                                  color: kMainColor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              child: const Center(
                                  child: Text(
                                "Previous",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 17),
                              )),
                            )),
                        GestureDetector(
                            onTap: () {
                              if (_pageController.page != 2) {
                                setState(() {
                                  indexval++;
                                });
                                _pageController.nextPage(
                                    duration: const Duration(milliseconds: 200),
                                    curve: Curves.easeInOut);
                              } else if (indexval == 2) {}
                              print(
                                  "checking pagecontroller value ${_pageController.page}");
                            },
                            child: Container(
                              height: 50,
                              width: 100,
                              decoration: BoxDecoration(
                                  border: Border.all(color: kMainColor),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10))),
                              child: const Center(
                                  child: Text(
                                "Next",
                                style:
                                    TextStyle(color: kMainColor, fontSize: 17),
                              )),
                            )),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
