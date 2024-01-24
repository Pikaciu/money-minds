import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:money_minds/view/pages/bottom_navigation_bar_for_caregiver.dart';
import 'package:money_minds/view/pages/main_page_for_caregiver.dart';
import 'package:money_minds/view/widgets/change_age.dart';
import 'package:money_minds/view/widgets/change_gender.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../constants/color/color.dart';
import '../authentication/login/login_page.dart';
import '../widgets/change_email.dart';
import '../widgets/change_name.dart';
import 'package:percent_indicator/percent_indicator.dart';

class MonitorPage extends StatefulWidget {
  const MonitorPage({Key? key}) : super(key: key);
  @override
  State<MonitorPage> createState() => _MonitorPageState();
}

class _MonitorPageState extends State<MonitorPage> {
  late Future<List<Map<String, dynamic>>> userVideosFuture;
  @override
  void initState() {
    super.initState();
    userVideosFuture = getUserData();
  }

  Future<List<Map<String, dynamic>>> getUserData() async {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      var users = await FirebaseFirestore.instance
          .collection('users')
          .where('caregiverId', isEqualTo: auth.currentUser!.uid)
          .get();

      List<Map<String, dynamic>> videos = [];

      users.docs.forEach((doc) {
        var userData = doc.data() as Map<String, dynamic>;
        List<Map<String, dynamic>> userVideos =
            List<Map<String, dynamic>>.from(userData['videos'] ?? []);
        videos.addAll(userVideos);
      });

      return videos;
    } on FirebaseAuthException catch (e) {
      print(e.message);
      return [];
    } catch (e) {
      print(e);
      return [];
    }
  }

//   Future getUserData() async {
//     try {
//       FirebaseAuth auth = FirebaseAuth.instance;
//       var users = await FirebaseFirestore.instance
//           .collection('users')
//           // .doc(auth.currentUser!.uid)
//           .where('caregiverId', isEqualTo: auth.currentUser!.uid)
//           .get();

// // Loop through the documents in the result
//       // users.docs.forEach((doc) {
//       //   // Access the data in each document using doc.data()
//       //   var data = doc.data();
//       //   print(data);
//       // });
//       List<Map<String, dynamic>> videos = [];

// // Loop through the documents in the result
//       users.docs.forEach((doc) {
//         // Access the data in each document using doc.data()
//         var userData = doc.data() as Map<String, dynamic>;

//         // Extract the "videos" field
//         List<Map<String, dynamic>> userVideos =
//             List<Map<String, dynamic>>.from(userData['videos'] ?? []);

//         // Add the user's videos to the main list
//         videos.addAll(userVideos);
//       });
//       print(videos);
//       return videos;
//       // return users.docs;
//     } on FirebaseAuthException catch (e) {
//       print(e.message);
//       return [];
//     } catch (e) {
//       print(e);
//       return [];
//     }
//   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Monitor'),
      ),
      body: FutureBuilder(
        future: userVideosFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            print(snapshot.data);
            List<Map<String, dynamic>> userVideos =
                snapshot.data as List<Map<String, dynamic>>;

            return SizedBox(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 8.0, right: 8.0, top: 2),
                      child: Card(
                        // color: kblue,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border(
                              left: BorderSide(
                                color: Colors.blue, // Choose your border color
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
                                  fontWeight: FontWeight.bold),
                            ),

                            // onTap: () => Navigator.push(
                            //   context,
                            //   MaterialPageRoute(builder: (context) => Profile()),
                            // ),
                          ),
                        ),
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true, // Added this line
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: userVideos.length,
                      itemBuilder: (context, index) {
                        String title = userVideos[index]['title'];
                        String videoUrl = userVideos[index]['videoUrl'];
                        String progress = userVideos[index]['progress'];
                        bool status = userVideos[index]['status'];

                        return Card(
                          child: ListTile(
                            dense: true,
                            visualDensity: const VisualDensity(vertical: 3),
                            title: Text(
                              title,
                              style: const TextStyle(
                                color: Colors.black87,
                                fontSize: 20,
                              ),
                            ),
                            // subtitle: Text('Progress: $progress\nStatus: $status'),
                            // subtitle: Text('Video URL: $videoUrl\nStatus: $status'),
                            trailing: Checkbox(
                              value: status,
                              onChanged: (value) async {
                                // Update the status in Firestore when the checkbox is changed.
                                // You need to implement this part based on your Firestore structure.
                                // For example: firestoreInstance.collection('videos').doc(video['videoId']).update({'status': value});
                                setState(() {
                                  status = value!;
                                });
                                try {
                                  FirebaseAuth auth = FirebaseAuth.instance;
                                  await FirebaseFirestore.instance
                                      .collection('users')
                                      .where('caregiverId',
                                          isEqualTo: auth.currentUser!.uid)
                                      .get()
                                      .then((querySnapshot) {
                                    querySnapshot.docs.forEach((doc) {
                                      var userData =
                                          doc.data() as Map<String, dynamic>;
                                      var userVideos =
                                          List<Map<String, dynamic>>.from(
                                              userData['videos'] ?? []);

                                      for (var i = 0;
                                          i < userVideos.length;
                                          i++) {
                                        if (userVideos[i]['title'] == title) {
                                          userVideos[i]['status'] = status;
                                          break;
                                        }
                                      }

                                      // Update the document with the modified videos
                                      FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(doc.id)
                                          .update({'videos': userVideos});
                                      showDialog(
                                        context: context,
                                        builder: (_) => AlertDialog(
                                          title: Text('Updated!'),
                                          content: Text(
                                              'You have updated the record...'),
                                          actions: [
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                primary: Colors
                                                    .blue, // Background color
                                              ),
                                              onPressed: () async {
                                                Navigator.pop(context);
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(builder: (context) => BottomNavigationBarForCaregiverScreen()),
                                                );

                                                print('hello');
                                              },
                                              child: Text('OK'),
                                            ),
                                          ],
                                        ),
                                      );
                                    });
                                  });
                                } catch (e) {
                                  print('Error updating status: $e');
                                }
                              },
                            ),
                            onTap: () {
                              // Navigate to VideoPlayerPage
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) => VideoPlayerPage(
                              //       title: title,
                              //       videoUrl: videoUrl,
                              //     ),
                              //   ),
                              // );

                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) => YouTubePlayerPage(
                              //       videoUrl: videoUrl,
                              //     ),
                              //   ),
                              // );
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
