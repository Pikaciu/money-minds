import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:money_minds/view/pages/result_page_for_practical.dart';
import 'package:money_minds/view/pages/result_page_for_videos.dart';
import 'package:money_minds/view/widgets/change_age.dart';
import 'package:money_minds/view/widgets/change_gender.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../constants/color/color.dart';
import '../authentication/login/login_page.dart';
import '../widgets/change_email.dart';
import '../widgets/change_name.dart';
import 'package:percent_indicator/percent_indicator.dart';

// import '../widgets/change_password.dart';
// import '../widgets/change_email.dart';
// import '../widgets/change_name.dart';

class ResultPage extends StatefulWidget {
  const ResultPage({Key? key}) : super(key: key);
  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    double width = size.width;
    double height = size.height;
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text("My Profile"),
      //   backgroundColor: ColorConstants.appColor,
      // ),
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
                    'Learning Module',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
                          builder: (context) => ResultPageForVideos()),
                    );
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 180,
                    margin: const EdgeInsets.all(10),
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: const AssetImage("assets/images/bg1.jpg"),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(0.3), BlendMode.dstATop),
                      ),
                      borderRadius: BorderRadius.circular(
                          15), // Set rounded corner radius
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Learning Module",
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
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    // 'Hi User',
                    'Practical Module',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
                          builder: (context) => ResultPageForPractical()),
                    );
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 180,
                    margin: const EdgeInsets.all(10),
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: const AssetImage("assets/images/bg1.jpg"),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(0.3), BlendMode.dstATop),
                      ),
                      borderRadius: BorderRadius.circular(
                          15), // Set rounded corner radius
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Practical Module",
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
