import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:money_minds/view/pages/english_version.dart';
import 'package:money_minds/view/pages/learning_center_videos.dart';
import 'package:money_minds/view/pages/malay_version.dart';
import 'package:money_minds/view/pages/practical_center.dart';
import 'package:money_minds/view/pages/practical_module.dart';
import '../../constants/color/color.dart';
import '../authentication/login/login_page.dart';
// ignore: depend_on_referenced_packages
import 'package:stroke_text/stroke_text.dart';

import '../widgets/Slider.dart';

class LearningCenterPage extends StatefulWidget {
  const LearningCenterPage({Key? key}) : super(key: key);

  @override
  State<LearningCenterPage> createState() => _LearningCenterPageState();
}

class _LearningCenterPageState extends State<LearningCenterPage> {
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
  var _isLoading = false;
  bool? _isLoggedIn = false;
  @override
  void initState() {
    super.initState();
    loadingData();
  }

  void loadingData() async {
    try {
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        // _isLoggedIn = prefs.getBool('isLoggedIn');
      });
    } catch (e) {
      print(e);
    }
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
                          // if (!_isLoggedIn!)
                          // InkWell(
                          //   onTap: () {
                          //     Navigator.of(context).push(
                          //       MaterialPageRoute(
                          //         builder: (ctx) => const LoginPage(),
                          //       ),
                          //     );
                          //   },
                          //   child: Align(
                          //     alignment: Alignment.topRight,
                          //     child: GestureDetector(
                          //       onTap: (() {
                          //         Navigator.of(context).pushAndRemoveUntil(
                          //             MaterialPageRoute(
                          //                 builder: (context) =>
                          //                     const LoginPage()),
                          //             (route) => false);
                          //       }),
                          //       child: Text(
                          //         'Logout',
                          //         style: TextStyle(
                          //             fontSize: 16,
                          //             color: ColorConstants.appColor),
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          // // if (!_isLoggedIn!)
                          // const SizedBox(
                          //   height: 16,
                          // ),
                          //  Align(
                          //   alignment: Alignment.centerLeft,
                          //   child: Text(
                          //     // 'Hi User',
                          //   'Hi ${snapshot.data?['name'] ?? 'User'}',
                          //     style: TextStyle(
                          //         fontSize: 32, fontWeight: FontWeight.bold),
                          //   ),
                          // ),
                          // const SizedBox(
                          //   height: 4,
                          // ),
                          // const Align(
                          //   alignment: Alignment.centerLeft,
                          //   child: Text(
                          //     'Lets find your course here',
                          //     style: TextStyle(
                          //         fontSize: 16,
                          //         fontWeight: FontWeight.bold,
                          //         color: Colors.blue),
                          //   ),
                          // ),
                          // const SizedBox(
                          //   height: 20,
                          // ),
                          // CarouselWithDotsPage(imgList: imgList),
                          // const SizedBox(
                          //   height: 20,
                          // ),
                          // Center(
                          //   child: AnimatedTextKit(
                          //     animatedTexts: [
                          //       TypewriterAnimatedText(
                          //         'Gain Knowledge at your home!',
                          //         textStyle: const TextStyle(
                          //           fontSize: 24.0,
                          //           fontWeight: FontWeight.bold,
                          //           color: Colors.blue,
                          //         ),
                          //         speed: const Duration(milliseconds: 100),
                          //       ),
                          //     ],
                          //     totalRepeatCount: 20,
                          //     pause: const Duration(milliseconds: 150),
                          //     displayFullTextOnTap: true,
                          //     stopPauseOnTap: true,
                          //   ),
                          // ),
                          // Container(
                          //   width: width,
                          //   height: 180,
                          //   decoration: const BoxDecoration(
                          //       image: DecorationImage(
                          //           image: AssetImage('assets/e_learning.jpg'),
                          //           fit: BoxFit.fill)),
                          // ),
                          // const SizedBox(
                          //   height: 20,
                          // ),
                          // Container(
                          //   height: 30,
                          //   color: Colors.blue,
                          //   child: const Align(
                          //     alignment: Alignment.center,
                          //     child: Text(
                          //       'Learning that fits your career',
                          //       textAlign: TextAlign.center,
                          //       style:
                          //           TextStyle(fontSize: 20, color: Colors.white),
                          //     ),
                          //   ),
                          // ),
                          // const SizedBox(
                          //   height: 8,
                          // ),
                          // Container(
                          //   height: 60,
                          //   color: Colors.blue,
                          //   child: const Align(
                          //     alignment: Alignment.centerLeft,
                          //     child: Text(
                          //       'Skills for your present and future to help you grow in your career.',
                          //       textAlign: TextAlign.center,
                          //       style:
                          //           TextStyle(fontSize: 16, color: Colors.white),
                          //     ),
                          //   ),
                          // ),
                          // const SizedBox(
                          //   height: 16,
                          // ),
                          // const Align(
                          //     alignment: Alignment.center,
                          //     child: Text(
                          //       'Courses',
                          //       style: TextStyle(
                          //           fontSize: 24,
                          //           color: Colors.blue,
                          //           fontWeight: FontWeight.bold,
                          //           // decoration: TextDecoration.underline,
                          //           decorationStyle: TextDecorationStyle.double),
                          //     )),
                          // Divider(
                          //   color: Colors.black,
                          // ),
                          // const SizedBox(
                          //   height: 16,
                          // ),
                          // Container(
                          //   width: MediaQuery.of(context).size.width,
                          //   height: 180,
                          //   margin: const EdgeInsets.all(10),
                          //   padding: const EdgeInsets.symmetric(
                          //       vertical: 5, horizontal: 10),
                          //   decoration: BoxDecoration(
                          //     image: DecorationImage(
                          //       image:
                          //           const AssetImage("assets/images/bg3.jpg"),
                          //       fit: BoxFit.cover,
                          //       colorFilter: ColorFilter.mode(
                          //           Colors.black.withOpacity(0.3),
                          //           BlendMode.dstATop),
                          //     ),
                          //     borderRadius: BorderRadius.circular(
                          //         15), // Set rounded corner radius
                          //   ),
                          //   child: Column(
                          //     mainAxisAlignment: MainAxisAlignment.center,
                          //     children: [
                          //       // Text(
                          //       //   "Find Best Course",
                          //       //   style: TextStyle(
                          //       //       color: Colors.blue.withOpacity(0.8),
                          //       //       fontSize: 28.0,
                          //       //       height: 1.4,
                          //       //       fontWeight: FontWeight.w600,
                          //       //       ),
                          //       //   textAlign: TextAlign.center,
                          //       // ),
                          //       StrokeText(
                          //         text: "English Version",
                          //         textStyle: TextStyle(
                          //           fontSize: 28,
                          //           color: Colors.blue,
                          //         ),
                          //         strokeColor: Colors.black,
                          //         strokeWidth: 1,
                          //       ),
                          //       const SizedBox(
                          //         height: 10,
                          //       ),
                          //       OutlinedButton(
                          //           child: Text("START HERE".toUpperCase(),
                          //               style: const TextStyle(fontSize: 14)),
                          //           style: ButtonStyle(
                          //               foregroundColor:
                          //                   MaterialStateProperty.all<Color>(
                          //                       Colors.white),
                          //               backgroundColor:
                          //                   MaterialStateProperty.all<Color>(
                          //                       Colors.blue),
                          //               shape: MaterialStateProperty.all<
                          //                       RoundedRectangleBorder>(
                          //                   RoundedRectangleBorder(
                          //                       borderRadius: BorderRadius.zero,
                          //                       side: BorderSide(
                          //                           color: Colors.blue)))),
                          //           // onPressed: () {},
                          //           onPressed: () {
                          //             Navigator.of(context).push(
                          //                 MaterialPageRoute(
                          //                     builder: (ctx) =>
                          //                         const EnglishVersion()));
                          //           }),
                          //     ],
                          //   ),
                          // ),
                          // const SizedBox(
                          //   height: 16,
                          // ),
                          // Container(
                          //   width: MediaQuery.of(context).size.width,
                          //   height: 180,
                          //   margin: const EdgeInsets.all(10),
                          //   padding: const EdgeInsets.symmetric(
                          //       vertical: 5, horizontal: 10),
                          //   decoration: BoxDecoration(
                          //     image: DecorationImage(
                          //       image:
                          //           const AssetImage("assets/images/bg1.jpg"),
                          //       fit: BoxFit.cover,
                          //       colorFilter: ColorFilter.mode(
                          //           Colors.black.withOpacity(0.3),
                          //           BlendMode.dstATop),
                          //     ),
                          //     borderRadius: BorderRadius.circular(
                          //         15), // Set rounded corner radius
                          //   ),
                          //   child: Column(
                          //     mainAxisAlignment: MainAxisAlignment.center,
                          //     children: [
                          //       // Text(
                          //       //   "Find Best Course",
                          //       //   style: TextStyle(
                          //       //       color: Colors.blue.withOpacity(0.8),
                          //       //       fontSize: 28.0,
                          //       //       height: 1.4,
                          //       //       fontWeight: FontWeight.w600,
                          //       //       ),
                          //       //   textAlign: TextAlign.center,
                          //       // ),
                          //       StrokeText(
                          //         text: "Malay Version",
                          //         textStyle: TextStyle(
                          //           fontSize: 28,
                          //           color: Colors.blue,
                          //         ),
                          //         strokeColor: Colors.black,
                          //         strokeWidth: 1,
                          //       ),
                          //       const SizedBox(
                          //         height: 10,
                          //       ),
                          //       OutlinedButton(
                          //           child: Text("START HERE".toUpperCase(),
                          //               style: const TextStyle(fontSize: 14)),
                          //           style: ButtonStyle(
                          //               foregroundColor:
                          //                   MaterialStateProperty.all<Color>(
                          //                       Colors.white),
                          //               backgroundColor:
                          //                   MaterialStateProperty.all<Color>(
                          //                       Colors.blue),
                          //               shape: MaterialStateProperty.all<
                          //                       RoundedRectangleBorder>(
                          //                   RoundedRectangleBorder(
                          //                       borderRadius: BorderRadius.zero,
                          //                       side: BorderSide(
                          //                           color: Colors.blue)))),
                          //           // onPressed: () {},
                          //           onPressed: () {
                          //             Navigator.of(context).push(
                          //                 MaterialPageRoute(
                          //                     builder: (ctx) =>
                          //                         const MalayVersion()));
                          //           }),
                          //     ],
                          //   ),
                          // ),
                        
                          //                         const SizedBox(
                          //   height: 16,
                          // ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 180,
                            margin: const EdgeInsets.all(10),
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image:
                                    const AssetImage("assets/images/bg3.jpg"),
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
                                // Text(
                                //   "Find Best Course",
                                //   style: TextStyle(
                                //       color: Colors.blue.withOpacity(0.8),
                                //       fontSize: 28.0,
                                //       height: 1.4,
                                //       fontWeight: FontWeight.w600,
                                //       ),
                                //   textAlign: TextAlign.center,
                                // ),
                                StrokeText(
                                  text: "Learning Module",
                                  textStyle: TextStyle(
                                    fontSize: 28,
                                    color: Colors.blue,
                                  ),
                                  strokeColor: Colors.black,
                                  strokeWidth: 1,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                OutlinedButton(
                                    child: Text("START HERE".toUpperCase(),
                                        style: const TextStyle(fontSize: 14)),
                                    style: ButtonStyle(
                                        foregroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.white),
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.blue),
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                                borderRadius: BorderRadius.zero,
                                                side: BorderSide(
                                                    color: Colors.blue)))),
                                    // onPressed: () {},
                                    onPressed: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (ctx) =>
                                                  const LearningCenterPageVideos()));
                                    }),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 180,
                            margin: const EdgeInsets.all(10),
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image:
                                    const AssetImage("assets/images/bg2.jpg"),
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
                                // Text(
                                //   "Find Best Course",
                                //   style: TextStyle(
                                //       color: Colors.blue.withOpacity(0.8),
                                //       fontSize: 28.0,
                                //       height: 1.4,
                                //       fontWeight: FontWeight.w600,
                                //       ),
                                //   textAlign: TextAlign.center,
                                // ),
                                StrokeText(
                                  text: "Practical Module",
                                  textStyle: TextStyle(
                                    fontSize: 28,
                                    color: Colors.blue,
                                  ),
                                  strokeColor: Colors.black,
                                  strokeWidth: 1,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                OutlinedButton(
                                    child: Text("START HERE".toUpperCase(),
                                        style: const TextStyle(fontSize: 14)),
                                    style: ButtonStyle(
                                        foregroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.white),
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.blue),
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                                borderRadius: BorderRadius.zero,
                                                side: BorderSide(
                                                    color: Colors.blue)))),
                                    // onPressed: () {},
                                    onPressed: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (ctx) =>
                                                  const PracticalCenter()));
                                    }),
                              ],
                            ),
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
