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

class SeeMyKidPage extends StatefulWidget {
  const SeeMyKidPage({Key? key}) : super(key: key);
  @override
  State<SeeMyKidPage> createState() => _SeeMyKidPageState();
}

class _SeeMyKidPageState extends State<SeeMyKidPage> {
  Future<Object> getUserData() async {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      var users = await FirebaseFirestore.instance
          .collection('users')
          .where('caregiverId', isEqualTo: auth.currentUser!.uid)
          .get();

      print(users);
      return users;
    } on FirebaseAuthException catch (e) {
      print(e.message);
      return [];
    } catch (e) {
      print(e);
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Kid'),
      ),
      body: FutureBuilder(
        future: getUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            QuerySnapshot querySnapshot = snapshot.data as QuerySnapshot;

            // Iterate through the documents in the result
            // for (QueryDocumentSnapshot doc in querySnapshot.docs) {
            //   // Access the data in each document using doc.data()
            //   Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

            //   // Print or process the data as needed
            //   print(data);
            // }

            QueryDocumentSnapshot doc = querySnapshot.docs[0];
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

            // Access the 'name' field from the data
            String name = data["name"].toString();
            String email = data["email"].toString();
            String gender = data["gender"].toString();
            String age = data["age"].toString();
            String coins = data["coins"].toString();
            String image = data["image"].toString();
            String joinedAt = data["joinedAt"].toString();
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
                              "Kid Information",
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
                    // SizedBox(
                    //   child: SizedBox(
                    //     width: double.infinity,
                    //     height: 100.0,
                    //     child: Column(
                    //       crossAxisAlignment: CrossAxisAlignment.center,
                    //       mainAxisAlignment: MainAxisAlignment.center,
                    //       children: [
                    //         const SizedBox(
                    //           height: 10,
                    //         ),
                    //         Stack(children: [
                    //           image == ""
                    //               ? GestureDetector(
                    //                   // onTap: _pickImageGallery,
                    //                   child: const CircleAvatar(
                    //                     radius: 32.0,
                    //                     backgroundColor: Colors.white,
                    //                     child: CircleAvatar(
                    //                       // backgroundImage: NetworkImage(
                    //                       //   "https://www.rd.com/wp-content/uploads/2017/09/01-shutterstock_476340928-Irina-Bg.jpg",
                    //                       // ),
                    //                       backgroundImage: AssetImage(
                    //                           'assets/images/profile.png'),
                    //                       radius: 28.0,
                    //                     ),
                    //                   ),
                    //                 )
                    //               : GestureDetector(
                    //                   // onTap: _pickImageGallery,
                    //                   child: CircleAvatar(
                    //                     radius: 64.0,
                    //                     backgroundColor: Colors.white,
                    //                     child: CircleAvatar(
                    //                       // backgroundImage: NetworkImage(
                    //                       //   "https://www.rd.com/wp-content/uploads/2017/09/01-shutterstock_476340928-Irina-Bg.jpg",
                    //                       // ),
                    //                       backgroundImage: NetworkImage(image),
                    //                       radius: 60.0,
                    //                     ),
                    //                   ),
                    //                 )
                    //           // Container(
                    //           //   child: Image.network(snapshot.data['image']),
                    //           // )
                    //           // Positioned(
                    //           //   bottom: 0,
                    //           //   right: 4,
                    //           //   child: CircleAvatar(
                    //           //     radius: 15,
                    //           //     // child: Icon(
                    //           //     //   Icons.edit,
                    //           //     //   size: 15,
                    //           //     // ),
                    //           //   ),
                    //           // )
                    //         ]),
                    //       ],
                    //     ),
                    //   ),
                    // ),

                    Card(
                      child: ListTile(
                        dense: true,
                        visualDensity: const VisualDensity(vertical: 3),
                        title: Text(
                          "Name: ${name}",
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 20,
                          ),
                        ),
                        // subtitle: Text('Progress: $progress\nStatus: $status'),
                        // subtitle: Text('Video URL: $videoUrl\nStatus: $status'),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Card(
                      child: ListTile(
                        dense: true,
                        visualDensity: const VisualDensity(vertical: 3),
                        title: Text(
                          "Email: ${email}",
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 20,
                          ),
                        ),
                        // subtitle: Text('Progress: $progress\nStatus: $status'),
                        // subtitle: Text('Video URL: $videoUrl\nStatus: $status'),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Card(
                      child: ListTile(
                        dense: true,
                        visualDensity: const VisualDensity(vertical: 3),
                        title: Text(
                          "Age: ${age}",
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 20,
                          ),
                        ),
                        // subtitle: Text('Progress: $progress\nStatus: $status'),
                        // subtitle: Text('Video URL: $videoUrl\nStatus: $status'),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Card(
                      child: ListTile(
                        dense: true,
                        visualDensity: const VisualDensity(vertical: 3),
                        title: Text(
                          "Gender: ${gender}",
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 20,
                          ),
                        ),
                        // subtitle: Text('Progress: $progress\nStatus: $status'),
                        // subtitle: Text('Video URL: $videoUrl\nStatus: $status'),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Card(
                      child: ListTile(
                        dense: true,
                        visualDensity: const VisualDensity(vertical: 3),
                        title: Text(
                          "Coins: ${coins}",
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 20,
                          ),
                        ),
                        // subtitle: Text('Progress: $progress\nStatus: $status'),
                        // subtitle: Text('Video URL: $videoUrl\nStatus: $status'),
                      ),
                    ),
                    SizedBox(
                      height: 10,
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
