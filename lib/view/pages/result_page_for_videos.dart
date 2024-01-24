import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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

class ResultPageForVideos extends StatefulWidget {
  const ResultPageForVideos({Key? key}) : super(key: key);
  @override
  State<ResultPageForVideos> createState() => _ResultPageForVideosState();
}

class _ResultPageForVideosState extends State<ResultPageForVideos> {
  Future getUserData() async {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      var users = await FirebaseFirestore.instance
          .collection('users')
          .doc(auth.currentUser!.uid)
          .get();
      // Access the data using .data()
      var userData = users.data() as Map<String, dynamic>;

// Extract the "videos" field
      List<Map<String, dynamic>> videos =
          List<Map<String, dynamic>>.from(userData['videos'] ?? []);
      // Filter videos based on status
      // List<Map<String, dynamic>> trueStatusVideos =
      //     videos.where((video) => video['status'] == true).toList();

      // Print the filtered videos data
      print(userData);
      print('userData');

      return videos;
      return users;
    } on FirebaseAuthException catch (e) {
      print(e.message);
      return [];
    } catch (e) {
      print(e);
      return [];
    }
  }

  double calculateOverallProgress(List<Map<String, dynamic>> videosData) {
    if (videosData.isEmpty) {
      return 0.0;
    }

    int completedVideos = 0;
    for (var video in videosData) {
      if (video['progress'] == "Completed") {
        completedVideos++;
      }
    }

    return completedVideos / videosData.length;
  }

  @override
  Widget build(BuildContext context) {
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
              List<Map<String, dynamic>> videosData =
                  snapshot.data as List<Map<String, dynamic>>;
              double overallProgress = calculateOverallProgress(videosData);
              return Scaffold(
                appBar: AppBar(
                  title: const Text("Learning Module Result"),
                  backgroundColor: ColorConstants.appColor,
                ),
                body: SizedBox(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 8.0, right: 8.0, top: 2),
                          child: Card(
                            // color: kblue,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  left: BorderSide(
                                    color:
                                        Colors.blue, // Choose your border color
                                    width: 4.0, // Choose your border width
                                  ),
                                ),
                              ),
                              child: ListTile(
                                dense: true,
                                visualDensity: const VisualDensity(vertical: 2),
                                // leading: Icon(
                                //   Icons.person,
                                //   color: ColorConstants.appColor,
                                // ),
                                title: Text(
                                  "Learning Module",
                                  style: const TextStyle(
                                    color: Colors.black87,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold
                                  ),
                                ),

                                // onTap: () => Navigator.push(
                                //   context,
                                //   MaterialPageRoute(builder: (context) => Profile()),
                                // ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Center(
                            child: new LinearPercentIndicator(
                              // width: MediaQuery.of(context).size.width - 50,
                              animation: true,
                              lineHeight: 20.0,
                              animationDuration: 1000,
                              percent: overallProgress,
                              // center: Text("80.0%"),
                              center: Text(
                                "${(overallProgress * 100).toStringAsFixed(1)}%",
                              ),
                              linearStrokeCap: LinearStrokeCap.roundAll,
                              // backgroundColor: Color.fromARGB(255, 255, 250, 235),
                              progressColor: Colors.green,
                            ),
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: videosData.length,
                          itemBuilder: (context, index) {
                            String title = videosData[index]['title'];
                            String videoUrl = videosData[index]['videoUrl'];
                            String progress = videosData[index]['progress'];
                            bool status = videosData[index]['status'];

                            Color progressBarColor = Colors.grey;

                            if (progress == "Completed") {
                              progressBarColor = Colors.green;
                            } else {
                              progressBarColor = Colors.red;
                            }

                            return Padding(
                              padding: const EdgeInsets.only(
                                left: 8.0,
                                right: 8.0,
                                top: 2,
                              ),
                              child: Card(
                                child: ListTile(
                                  dense: true,
                                  visualDensity:
                                      const VisualDensity(vertical: 2),
                                  leading: Icon(
                                    Icons.play_circle,
                                    color: ColorConstants.appColor,
                                  ),
                                  title: Text(
                                    title,
                                    style: const TextStyle(
                                      color: Colors.black87,
                                      fontSize: 20,
                                    ),
                                  ),
                                  trailing: Chip(
                                    // avatar: CircleAvatar(
                                    //   backgroundColor: Colors.grey.shade800,
                                    //   child: const Text('AB'),
                                    // ),
                                    elevation: 2,
                                    backgroundColor:
                                        Color.fromARGB(255, 255, 250, 235),
                                    shadowColor: Colors.black,
                                    label: Text(
                                      "$progress",
                                      style: TextStyle(color: progressBarColor),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.only(
                        //       left: 8.0, right: 8.0, top: 2),
                        //   child: Card(
                        //     // color: kblue,
                        //     child: Container(
                        //       decoration: BoxDecoration(
                        //         border: Border(
                        //           left: BorderSide(
                        //             color:
                        //                 Colors.blue, // Choose your border color
                        //             width: 4.0, // Choose your border width
                        //           ),
                        //         ),
                        //       ),
                        //       child: ListTile(
                        //         dense: true,
                        //         visualDensity: const VisualDensity(vertical: 2),
                        //         // leading: Icon(
                        //         //   Icons.person,
                        //         //   color: ColorConstants.appColor,
                        //         // ),
                        //         title: Text(
                        //           "Practical Module",
                        //           style: const TextStyle(
                        //             color: Colors.black87,
                        //             fontSize: 20,
                        //             fontWeight: FontWeight.bold
                        //           ),
                        //         ),

                        //         // onTap: () => Navigator.push(
                        //         //   context,
                        //         //   MaterialPageRoute(builder: (context) => Profile()),
                        //         // ),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                      
                      ],
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
