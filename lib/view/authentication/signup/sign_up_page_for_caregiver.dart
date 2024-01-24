// ignore_for_file: avoid_print

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:money_minds/constants/color/color.dart';

import '../login/login_page.dart';

class SignUpPageForCaregiver extends StatefulWidget {
  final String kidId;
  SignUpPageForCaregiver({Key? key, required this.kidId}) : super(key: key);

  @override
  State<SignUpPageForCaregiver> createState() => _SignUpPageForCaregiverState();
}

class _SignUpPageForCaregiverState extends State<SignUpPageForCaregiver> {
  static Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  bool _obscurePasswordText = true;
  bool _obscureConfirmPasswordText = true;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  RegExp regExp = RegExp("key: \\[\\d+\\]");
  get key => null;
  //validation
  TextEditingController userName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController age = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController cPassword = TextEditingController();
  String? gender;

  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();
  // File? _pickedImage;
  String? url;
  // final GlobalMethods _globalMethods = GlobalMethods();
  bool _isLoading = false;
  List<String> validChar = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"];
  RegExp numReg = RegExp(r".*[0-9].*");
  RegExp letterReg = RegExp(r".*[A-Za-z].*");
  void validation() {
    //username validate
    print(email.text);
    print(password.text);
    print("kid ID: ${widget.kidId}");
    if (userName.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: ColorConstants.statusBarColor,
          content: const Text("User name is empty")));
      return;
    }
    if (userName.text.length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: ColorConstants.statusBarColor,
          content: const Text("Username is too short")));
      return;
    }
    for (int i = 0; i < userName.text.length; i++) {
      if (validChar.contains(userName.text[i])) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: ColorConstants.statusBarColor,
            content: const Text("User name is not valid")));
        return;
      }
    }

    if (email.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: ColorConstants.statusBarColor,
          content: const Text("Email is empty")));
      return;
    } else if (!email.text.contains("@") || !email.text.contains(".")) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: ColorConstants.statusBarColor,
          content: const Text("Email is not valid")));
      return;
    }

    //password validate
    if (password.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: ColorConstants.statusBarColor,
          content: const Text("Password is empty")));
      return;
    }
    if (password.text.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: ColorConstants.statusBarColor,
          content: const Text("Password is too short")));
      return;
    }

    if (!letterReg.hasMatch(password.text) || !numReg.hasMatch(password.text)) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: ColorConstants.statusBarColor,
          content: const Text("Password is week")));
      return;
    }
    if (cPassword.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: ColorConstants.statusBarColor,
          content: const Text("Confirm your password first")));
      return;
    }
    if (cPassword.text.trim() != password.text.trim()) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: ColorConstants.statusBarColor,
          content: const Text("Match your password")));
      return;
    }
    // print("success");
    sendData();
  }

  void sendData() async {
    try {
      FocusScope.of(context).unfocus();
      setState(() {
        _isLoading = true;
      });
      var date = DateTime.now().toString();
      var dateparse = DateTime.parse(date);
      var formattedDate =
          "${dateparse.day}-${dateparse.month}-${dateparse.year}";
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: email.text.trim(), password: password.text.trim());
      FirebaseAuth auth = await FirebaseAuth.instance;
      DocumentReference userRef =
          FirebaseFirestore.instance.collection('users').doc(widget.kidId);
      print(widget.kidId);
      // print(userCredential.user?.uid);
      print("Account done");
      var caregiverId = "${widget.kidId}123";
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user?.uid)
          .set({
        "userId": userCredential.user?.uid,
        "name": userName.text,
        "email": email.text,
        "password": password.text,
        'joinedAt': formattedDate,
        'createdAt': Timestamp.now(),
        'image': "",
        "kidId": widget.kidId,
        "type": 'caregiver'
      });

      await _auth.signOut();
      await userRef
          .update({"caregiverId": userCredential.user?.uid, "caregiverName": userName.text, "caregiverEmail": email.text});
      await FirebaseAuth.instance.signOut();
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginPage()),
          (route) => false);
      // Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: ColorConstants.statusBarColor,
            content: const Text("The password provided is too weak.")));
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: ColorConstants.statusBarColor,
            content: const Text("Account already exist for that email")));
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: ColorConstants.statusBarColor,
            content: Text(e.code)));
        print('The account already exists for that email.');
      }
      await FirebaseAuth.instance.currentUser?.delete();
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    double width = size.width;
    double height = size.height;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Caregiver Account"),
          backgroundColor: ColorConstants.appColor,
        ),
        body: SingleChildScrollView(
          child: Container(
            width: width,
            height: height,
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                        child: Image.asset(
                      "assets/images/logo.jpg",
                      width: 200,
                    )),
                    const SizedBox(
                      height: 12,
                    ),
                    const Text(
                      'Let\'s register your caregiver account',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const Text(
                      'Enter your detail below',
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                    Container(
                      constraints: const BoxConstraints(maxHeight: 55),
                      child: TextFormField(
                        controller: userName,
                        decoration: const InputDecoration(
                          hintText: 'Username',
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Container(
                      constraints: const BoxConstraints(maxHeight: 55),
                      child: TextFormField(
                        controller: email,
                        decoration: const InputDecoration(
                          hintText: 'Email',
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Container(
                      constraints: const BoxConstraints(maxHeight: 55),
                      child: TextFormField(
                        toolbarOptions: ToolbarOptions(
                          copy: false,
                          cut: false,
                          paste: false,
                          selectAll: false,
                        ),
                        controller: password,
                        obscureText: _obscurePasswordText,
                        decoration: InputDecoration(
                          hintText: 'Password',
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey,
                            ),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey,
                            ),
                          ),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                _obscurePasswordText = !_obscurePasswordText;
                              });
                            },
                            child: Icon(_obscurePasswordText
                                ? Icons.visibility
                                : Icons.visibility_off),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Container(
                      constraints: const BoxConstraints(maxHeight: 55),
                      child: TextFormField(
                        toolbarOptions: ToolbarOptions(
                          copy: false,
                          cut: false,
                          paste: false,
                          selectAll: false,
                        ),
                        controller: cPassword,
                        obscureText: _obscureConfirmPasswordText,
                        decoration: InputDecoration(
                          hintText: 'Confirm Password',
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey,
                            ),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey,
                            ),
                          ),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                _obscureConfirmPasswordText =
                                    !_obscureConfirmPasswordText;
                              });
                            },
                            child: Icon(_obscureConfirmPasswordText
                                ? Icons.visibility
                                : Icons.visibility_off),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: width,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blue,
                        ),
                        onPressed: validation,
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          child: _isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text(
                                  'Create Caregiver',
                                  style: TextStyle(fontSize: 18),
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
