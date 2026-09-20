import 'package:flutter/material.dart';
import 'package:aeon_hrms/Utility/customShap.dart';

class Dashbord extends StatefulWidget {
  const Dashbord({super.key});

  @override
  State<Dashbord> createState() => _DashbordState();
}

class _DashbordState extends State<Dashbord> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 55, 82, 202),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
        elevation: 0,
      ),
      backgroundColor: const Color.fromARGB(255, 213, 225, 234),
      body: Stack(
        children: [
          Column(
            children: [
              ClipPath(
                clipper: Customshape(),
                child: Container(
                  height: 260,
                  color: const Color.fromARGB(255, 55, 82, 202),
                  child: const Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            backgroundImage: AssetImage(""),
                          ),
                          SizedBox(width: 15),
                          Column(
                            children: [
                              Text(
                                "Good Afternoon,",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 17),
                              ),
                              Text(
                                "JATIN PATEL",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 28),
                              )
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        height: 45,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Thu, 12 Dec 2022",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18)),
                            Text("Thu, 12 Dec 2022",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18))
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.22,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                height: 90,
                width: double.infinity,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }
}
