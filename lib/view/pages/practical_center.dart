import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:money_minds/view/pages/english_version.dart';
import 'package:money_minds/view/pages/learning_module.dart';
import 'package:money_minds/view/pages/malay_learning_module.dart';
import 'package:money_minds/view/pages/malay_version.dart';
import 'package:money_minds/view/pages/practical_module.dart';
import '../../constants/color/color.dart';
import '../authentication/login/login_page.dart';
// ignore: depend_on_referenced_packages
import 'package:stroke_text/stroke_text.dart';

import '../widgets/Slider.dart';

class PracticalCenter extends StatefulWidget {
  const PracticalCenter({Key? key}) : super(key: key);

  @override
  State<PracticalCenter> createState() =>
      _PracticalCenterState();
}

class _PracticalCenterState extends State<PracticalCenter> {
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
                appBar: AppBar(
                  title: Text('Practical Module'),
                ),
                body: SingleChildScrollView(
                  child: Container(
                    width: width,
                    padding: const EdgeInsets.all(8),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(height: 12),
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
                                  text: "English Version",
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
                                                  const PracticalModule()));
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
                                  text: "Malay Version",
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
                                                  const PracticalModule()));
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
