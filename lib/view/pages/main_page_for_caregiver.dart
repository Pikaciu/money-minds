import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:money_minds/view/pages/leaderboard_page.dart';
import 'package:money_minds/view/pages/monitor_page.dart';
import 'package:money_minds/view/pages/see_my_kid_page.dart';
import '../../constants/color/color.dart';
import '../authentication/login/login_page.dart';
// ignore: depend_on_referenced_packages
import 'package:stroke_text/stroke_text.dart';

import '../widgets/Slider.dart';

class MainPageForCaregiver extends StatefulWidget {
  const MainPageForCaregiver({Key? key}) : super(key: key);

  @override
  State<MainPageForCaregiver> createState() => _MainPageForCaregiverState();
}

class _MainPageForCaregiverState extends State<MainPageForCaregiver> {
//fetch user date
  Future getUserData() async {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      var users = await FirebaseFirestore.instance
          .collection('users')
          .doc(auth.currentUser!.uid)
          .get();
      return users;
    } on FirebaseAuthException catch (e) {
      print(e.message);
      return [];
    } catch (e) {
      print(e);
      return [];
    }
  }

//fetch user date

  final FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    double width = size.width;
    double height = size.height;

    return FutureBuilder(
        future: getUserData(),
        builder: (BuildContext ctx, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return const Center(
                child: Text('Something went wrong'),
              );
            }
            if (snapshot.hasData) {
              print(snapshot.data['name']);
              return Scaffold(
                body: SingleChildScrollView(
                  child: Container(
                    width: width,
                    padding: const EdgeInsets.all(8),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(height: 12),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              // 'Hi User',
                              'Hi ${snapshot.data?['name'] ?? 'User'},',
                              style: TextStyle(
                                  fontSize: 32, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Divider(
                            color: Colors.black,
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          GestureDetector(
                            onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LeaderboardPage()),
                                    );
                                  },
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 180,
                              margin: const EdgeInsets.all(10),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image:
                                      const AssetImage("assets/images/bg1.jpg"),
                                  fit: BoxFit.cover,
                                  colorFilter: ColorFilter.mode(
                                      Colors.black.withOpacity(0.3),
                                      BlendMode.dstATop),
                                ),
                                borderRadius: BorderRadius.circular(
                                    15), // Set rounded corner radius
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Leaderboard",
                                    style: TextStyle(
                                        fontSize: 28,
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SeeMyKidPage()),
                                    );
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 180,
                                    margin: const EdgeInsets.all(10),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 10),
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: const AssetImage(
                                            "assets/images/bg3.jpg"),
                                        fit: BoxFit.cover,
                                        colorFilter: ColorFilter.mode(
                                            Colors.black.withOpacity(0.3),
                                            BlendMode.dstATop),
                                      ),
                                      borderRadius: BorderRadius.circular(
                                          15), // Set rounded corner radius
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "My Kid",
                                          style: TextStyle(
                                              fontSize: 28,
                                              color: Colors.blue,
                                              fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => MonitorPage()),
                                    );
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 180,
                                    margin: const EdgeInsets.all(10),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 10),
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: const AssetImage(
                                            "assets/images/bg2.jpg"),
                                        fit: BoxFit.cover,
                                        colorFilter: ColorFilter.mode(
                                            Colors.black.withOpacity(0.3),
                                            BlendMode.dstATop),
                                      ),
                                      borderRadius: BorderRadius.circular(
                                          15), // Set rounded corner radius
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Monitor",
                                          style: TextStyle(
                                              fontSize: 28,
                                              color: Colors.blue,
                                              fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.center,
                                        ),

                                        // const SizedBox(
                                        //   height: 10,
                                        // ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }
          }
          return const Center(
            child: Text('Something went wrong'),
          );
        });
  }
}
