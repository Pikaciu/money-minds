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

class ResultPageForPractical extends StatefulWidget {
  const ResultPageForPractical({Key? key}) : super(key: key);
  @override
  State<ResultPageForPractical> createState() => _ResultPageForPracticalState();
}

class _ResultPageForPracticalState extends State<ResultPageForPractical> {
  Future getUserData() async {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      var users = await FirebaseFirestore.instance
          .collection('users')
          .doc(auth.currentUser!.uid)
          .get();

      var userData = users.data() as Map<String, dynamic>;

      // Extract the "quizzes" field
      Map<String, dynamic> quizzes =
          Map<String, dynamic>.from(userData['quizzes'] ?? {});

      // Extract quiz levels
      Map<String, dynamic> level1 = Map<String, dynamic>.from(quizzes['level1']);
      Map<String, dynamic> level2 = Map<String, dynamic>.from(quizzes['level2']);

      // Print the extracted quiz data
      print(userData);
      print('userData');

      return {'level1': level1, 'level2': level2};
    } on FirebaseAuthException catch (e) {
      print(e.message);
      return {'level1': {}, 'level2': {}};
    } catch (e) {
      print(e);
      return {'level1': {}, 'level2': {}};
    }
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
            Map<String, dynamic> quizData =
                snapshot.data as Map<String, dynamic>;
            Map<String, dynamic> level1 = quizData['level1'];
            Map<String, dynamic> level2 = quizData['level2'];

            return Scaffold(
              appBar: AppBar(
                title: const Text("Quiz Module Result"),
                backgroundColor: Colors.blue,
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    // Display quiz data here
                    Padding(padding: const EdgeInsets.only(
                                left: 8.0,
                                right: 8.0,
                                top: 2,
                              ),
                                                            child: Card(
                                child: ListTile(
                                  dense: true,
                                  visualDensity:
                                      const VisualDensity(vertical: 2),
                                  // leading: Icon(
                                  //   Icons.play_circle,
                                  //   color: ColorConstants.appColor,
                                  // ),
                                  title: Text(
                                    "Level 1",
                                    style: const TextStyle(
                                      color: Colors.black87,
                                      fontSize: 20,
                                    ),
                                  ),
                                  subtitle: Text('Marks: ${level1['marks'].toString()}'),
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
                                      level1['progress'],
                                      // style: TextStyle(color: progressBarColor),
                                    ),
                                  ),
                                ),
                              ),
                            
                              ),
                                        Padding(padding: const EdgeInsets.only(
                                left: 8.0,
                                right: 8.0,
                                top: 2,
                              ),
                                                            child: Card(
                                child: ListTile(
                                  dense: true,
                                  visualDensity:
                                      const VisualDensity(vertical: 2),
                                  // leading: Icon(
                                  //   Icons.play_circle,
                                  //   color: ColorConstants.appColor,
                                  // ),
                                  title: Text(
                                    "Level 2",
                                    style: const TextStyle(
                                      color: Colors.black87,
                                      fontSize: 20,
                                    ),
                                  ),
                                  subtitle: Text('Marks: ${level2['marks'].toString()}'),
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
                                      level2['progress'],
                                      // style: TextStyle(color: progressBarColor),
                                    ),
                                  ),
                                ),
                              ),
                            
                              ),
                   
                    
                    // ListTile(
                    //   title: Text("Level 1"),
                    //   subtitle: Column(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: [
                    //       Text("Progress: ${level1['progress']}"),
                    //       Text("Status: ${level1['status']}"),
                    //       Text("Marks: ${level1['marks']}"),
                    //     ],
                    //   ),
                    // ),

                    // ListTile(
                    //   title: Text("Level 2"),
                    //   subtitle: Column(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: [
                    //       Text("Progress: ${level2['progress']}"),
                    //       Text("Status: ${level2['status']}"),
                    //       Text("Marks: ${level2['marks']}"),
                    //     ],
                    //   ),
                    // ),

                    // Add any additional UI elements for other quiz levels, etc.

                    // ... (other UI elements)
                  ],
                ),
              ),
            );
          }
        }
        return const Center(
          child: Text('Something went wrong'),
        );
      },
    );
  }
}
  Future getUserData() async {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      var users = await FirebaseFirestore.instance
          .collection('users')
          .doc(auth.currentUser!.uid)
          .get();

      var userData = users.data() as Map<String, dynamic>;

      // Extract the "quizzes" field
      Map<String, dynamic> quizzes =
          Map<String, dynamic>.from(userData['quizzes'] ?? {});

      // Extract quiz levels and questions
      List<Map<String, dynamic>> level1Questions =
          List<Map<String, dynamic>>.from(
              quizzes['level1']['questions'] ?? []);
      List<Map<String, dynamic>> level2Questions =
          List<Map<String, dynamic>>.from(
              quizzes['level2']['questions'] ?? []);

      // Print the extracted quiz data
      print(userData);
      print('userData');

      return {'level1': level1Questions, 'level2': level2Questions};
    } on FirebaseAuthException catch (e) {
      print(e.message);
      return {'level1': [], 'level2': []};
    } catch (e) {
      print(e);
      return {'level1': [], 'level2': []};
    }
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
            Map<String, dynamic> quizData =
                snapshot.data as Map<String, dynamic>;
            List<Map<String, dynamic>> level1Questions = quizData['level1'];
            List<Map<String, dynamic>> level2Questions = quizData['level2'];

            return Scaffold(
              appBar: AppBar(
                title: const Text("Quiz Result"),
                backgroundColor: Colors.blue,
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    // Display quiz data here using the extracted lists
                    // Example: Display level 1 questions
                    for (var question in level1Questions)
                      ListTile(
                        title: Text(question['question']),
                        // Display other information as needed
                      ),

                    // Add any additional UI elements for level 2 questions, etc.

                    // ... (other UI elements)
                  ],
                ),
              ),
            );
          }
        }
        return const Center(
          child: Text('Something went wrong'),
        );
      },
    );
  }
