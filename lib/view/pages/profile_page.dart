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

// import '../widgets/change_password.dart';
// import '../widgets/change_email.dart';
// import '../widgets/change_name.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
  var rating = 3.0;
  var pickedImageData;
  void _pickImageGallery() async {
    final picker = ImagePicker();
    try {
      final pickedImage = await picker.pickImage(source: ImageSource.gallery);
      final pickedImageFile = File(pickedImage!.path);
      setState(() {
        pickedImageData = pickedImageFile;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'Your image is selected wait for sometime...',
          style: TextStyle(color: Colors.white),
        ),
        duration: Duration(seconds: 2),
      ));
      print(pickedImageData);
      addDataToDatabase();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          '$e',
          style: TextStyle(color: Colors.white),
        ),
        duration: Duration(seconds: 2),
      ));
    }
    // Navigator.pop(context);
  }

  final picker = ImagePicker();

  Future pickImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      File _imageFile = File(pickedFile!.path);
    });
  }

  // File _imageFile;

  var _pickedImage;

  var imageUrl;
  // FirebaseAuth auth = FirebaseAuth.instance;
  // FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
  addDataToDatabase() async {
    // setState(() {
    //   _isLoading = true;
    // });
    try {
      String time = DateTime.now().toString();
      var name = await firestoreInstance
          .collection('users')
          .doc(auth.currentUser!.uid)
          .get();
      if ((pickedImageData.toString().contains('/'))) {
        print('inside of image function');
        var abc;
        final ref = FirebaseStorage.instance
            .ref()
            .child('usersImages')
            .child(name['name'] + '.jpg');
        await ref.putFile(pickedImageData);
        abc = await ref.getDownloadURL();
        setState(() {
          imageUrl = abc;
          print(abc);
        });
      }
      print('Outside of image url');
      await firestoreInstance
          .collection('users')
          .doc(auth.currentUser!.uid)
          .update({'image': imageUrl});

      //   Navigator.of(context).pushAndRemoveUntil(
      // MaterialPageRoute(builder: (context) => UserInformation()),
      // (route) => false);
    } catch (e) {
      print('$e');
      // setState(() {
      //   _isLoading = false;
      // });
    } finally {
      // setState(() {
      //   _isLoading = false;
      // });
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
              bool isage = snapshot.data['age'] != null;
              return Scaffold(
                // appBar: AppBar(
                //   title: const Text("My Profile"),
                //   backgroundColor: ColorConstants.appColor,
                // ),
                body: SizedBox(
                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            child: SizedBox(
                              width: double.infinity,
                              height: 300.0,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Stack(children: [
                                    snapshot.data['image'] == ""
                                        ? GestureDetector(
                                            onTap: _pickImageGallery,
                                            child: const CircleAvatar(
                                              radius: 64.0,
                                              backgroundColor: Colors.white,
                                              child: CircleAvatar(
                                                // backgroundImage: NetworkImage(
                                                //   "https://www.rd.com/wp-content/uploads/2017/09/01-shutterstock_476340928-Irina-Bg.jpg",
                                                // ),
                                                backgroundImage: AssetImage(
                                                    'assets/images/profile.png'),
                                                radius: 60.0,
                                              ),
                                            ),
                                          )
                                        : GestureDetector(
                                            onTap: _pickImageGallery,
                                            child: CircleAvatar(
                                              radius: 64.0,
                                              backgroundColor: Colors.white,
                                              child: CircleAvatar(
                                                // backgroundImage: NetworkImage(
                                                //   "https://www.rd.com/wp-content/uploads/2017/09/01-shutterstock_476340928-Irina-Bg.jpg",
                                                // ),
                                                backgroundImage: NetworkImage(
                                                    snapshot.data['image']),
                                                radius: 60.0,
                                              ),
                                            ),
                                          )
                                    // Container(
                                    //   child: Image.network(snapshot.data['image']),
                                    // )
                                    // Positioned(
                                    //   bottom: 0,
                                    //   right: 4,
                                    //   child: CircleAvatar(
                                    //     radius: 15,
                                    //     // child: Icon(
                                    //     //   Icons.edit,
                                    //     //   size: 15,
                                    //     // ),
                                    //   ),
                                    // )
                                  ]),
                                  const SizedBox(
                                    height: 20.0,
                                  ),
                                  Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          snapshot.data['name'],
                                          style: TextStyle(
                                              fontSize: 32.0,
                                              color: ColorConstants.appColor,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          snapshot.data['email'],
                                          style: TextStyle(
                                              fontSize: 18.0,
                                              color: ColorConstants.appColor,
                                              fontWeight: FontWeight.normal),
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          "You have ${snapshot.data['coins']} coins",
                                          style: TextStyle(
                                              fontSize: 18.0,
                                              color: ColorConstants.appColor,
                                              fontWeight: FontWeight.normal),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Text("Rate Us"),
                          const SizedBox(
                            height: 20.0,
                          ),

                          Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, right: 8.0, top: 2),
                            child: Card(
                              // color: kblue,
                              child: ListTile(
                                  dense: true,
                                  visualDensity:
                                      const VisualDensity(vertical: 2),
                                  leading: Icon(
                                    Icons.person,
                                    color: ColorConstants.appColor,
                                  ),
                                  title: Text(
                                    snapshot.data['name'],
                                    style: const TextStyle(
                                      color: Colors.black87,
                                      fontSize: 20,
                                    ),
                                  ),
                                  trailing: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ChangeName(
                                                  name: snapshot.data['name'],
                                                )),
                                      );
                                    },
                                    child: Icon(
                                      Icons.arrow_forward_ios,
                                      color: ColorConstants.appColor,
                                    ),
                                  )
                                  // onTap: () => Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(builder: (context) => Profile()),
                                  // ),
                                  ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, right: 8.0, top: 2),
                            child: Card(
                              // color: kblue,
                              child: ListTile(
                                  dense: true,
                                  visualDensity:
                                      const VisualDensity(vertical: 2),
                                  leading: Icon(
                                    Icons.format_list_numbered,
                                    color: ColorConstants.appColor,
                                  ),
                                  title: Text(
                                    '${snapshot.data?['age'] ?? 'age'} Years Old',
                                    style: const TextStyle(
                                      color: Colors.black87,
                                      fontSize: 20,
                                    ),
                                  ),
                                  trailing: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ChangeAge(
                                                  name: snapshot.data['age'],
                                                )),
                                      );
                                    },
                                    child: Icon(
                                      Icons.arrow_forward_ios,
                                      color: ColorConstants.appColor,
                                    ),
                                  )
                                  // onTap: () => Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(builder: (context) => Profile()),
                                  // ),
                                  ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, right: 8.0, top: 2),
                            child: Card(
                              // color: kblue,
                              child: ListTile(
                                  dense: true,
                                  visualDensity:
                                      const VisualDensity(vertical: 2),
                                  leading: Icon(
                                    Icons.info,
                                    color: ColorConstants.appColor,
                                  ),
                                  title: Text(
                                    '${snapshot.data?['gender']}',
                                    style: const TextStyle(
                                      color: Colors.black87,
                                      fontSize: 20,
                                    ),
                                  ),
                                  trailing: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ChangeGender(
                                                  name: snapshot.data['gender'],
                                                )),
                                      );
                                    },
                                    child: Icon(
                                      Icons.arrow_forward_ios,
                                      color: ColorConstants.appColor,
                                    ),
                                  )
                                  // onTap: () => Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(builder: (context) => Profile()),
                                  // ),
                                  ),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, right: 8.0, top: 2),
                            child: Card(
                              // color: kblue,
                              child: ListTile(
                                  dense: true,
                                  visualDensity:
                                      const VisualDensity(vertical: 2),
                                  leading: Icon(
                                    Icons.email,
                                    color: ColorConstants.appColor,
                                  ),
                                  title: Text(
                                    snapshot.data['email'],
                                    style: const TextStyle(
                                      color: Colors.black87,
                                      fontSize: 20,
                                    ),
                                  ),
                                  trailing: GestureDetector(
                                    onTap: () {
                                      // Navigator.push(
                                      //   context,
                                      //   MaterialPageRoute(
                                      //       builder: (context) => ChangeEmail(
                                      //             email: snapshot.data['email'],
                                      //           )),
                                      // );
                                    },
                                    child: Icon(
                                      Icons.arrow_forward_ios,
                                      color: ColorConstants.appColor,
                                    ),
                                  )
                                  // onTap: () => Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(builder: (context) => Profile()),
                                  // ),
                                  ),
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (ctx) => const LoginPage(),
                                ),
                              );
                            },
                            child: Align(
                              alignment: Alignment.center,
                              child: GestureDetector(
                                onTap: (() {
                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginPage()),
                                      (route) => false);
                                }),
                                child: Text(
                                  'Logout',
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: ColorConstants.appColor),
                                ),
                              ),
                            ),
                          ),
                          // if (!_isLoggedIn!)
                          const SizedBox(
                            height: 16,
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

// Alert custom images
_onAlertWithCustomImagePressed(context) {
  Alert(
    context: context,
    title: "Review Submitted",
    desc: "Thanks for your Feedback.",
    image: Image.asset(
      "check.gif",
      width: 100,
    ),
  ).show();
}
