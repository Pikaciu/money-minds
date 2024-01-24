// ignore_for_file: avoid_print

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:money_minds/constants/color/color.dart';

import '../login/login_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
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
    print('gender');
    print(gender);
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
    //    if(RegExp(r'^[A-Za-z]+$').hasMatch(userName.text))
    //  {
    //    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //       backgroundColor: ColorConstants.statusBarColor,
    //       content: const Text("User name is not valid")));
    //   return;
    //  }
    //  if(userName.text.contains(new RegExp(r'^[a-z]+$')))
    //    {
    //      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //         backgroundColor: ColorConstants.statusBarColor,
    //         content: const Text("User name is not valid")));
    //     return;
    //    }
    //email validate

    // age validate
    if (age.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: ColorConstants.statusBarColor,
          content: const Text("Age is empty")));
      return;
    }
    // gender validate
    if (gender == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: ColorConstants.statusBarColor,
          content: const Text("Gender is empty")));
      return;
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
      print("Account done");
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user?.uid)
          .set({
        "userId": _auth.currentUser?.uid,
        "name": userName.text,
        "age": age.text,
        "gender": gender,
        "email": email.text,
        "password": password.text,
        'joinedAt': formattedDate,
        'createdAt': Timestamp.now(),
        'image': "",
        "caregiverId": null,
        "caregiverName": null,
        "coins": 0,
        "type": "kid",
        "videos": [
          {
            "title": "Chapter 1 Recognize Money",
            "videoUrl": "https://firebasestorage.googleapis.com/v0/b/money-minds-66b65.appspot.com/o/videos%2FMALAYSIAN%20RINGGIT%20YEAR%201%20TRANSITION%20WEEK.mp4?alt=media&token=0aa687af-443b-47d3-84cc-026ae25f06c4",
            "progress": "Pending",
            "status": true // or false based on the video status
          },
          {
            "title": "Chapter 2 Value of money",
            "videoUrl": "https://firebasestorage.googleapis.com/v0/b/money-minds-66b65.appspot.com/o/videos%2FMalaysian%20Money%20-%20Interactive%20Educational%20video%20for%20kids%20(Ringgit%20Malaysia)%20%23BankNegaraMalaysia.mp4?alt=media&token=c68712fa-9d0e-49e2-ad31-4138d36f254c",
            "progress": "Pending",
            "status": true // or false based on the video status
          },
          {
            "title": "Chapter 3 Spending Money Wisely",
            "videoUrl": "https://firebasestorage.googleapis.com/v0/b/money-minds-66b65.appspot.com/o/videos%2FSpending%20Money%20Wisely%20-%20Money%20Savvy%20For%20Kids.mp4?alt=media&token=e188ce54-bf63-4b39-b782-45549035b5af",
            "progress": "Pending",
            "status": true // or false based on the video status
          },
          {
            "title": "Chapter 4 Saving for something special",
            "videoUrl": "https://firebasestorage.googleapis.com/v0/b/money-minds-66b65.appspot.com/o/videos%2FA%20lesson%20on%20responsible%20saving%20for%20kids%20-%20Smartkids.mp4?alt=media&token=636a0bec-1d65-4fb6-bec3-740d39785ea5",
            "progress": "Pending",
            "status": true // or false based on the video status
          },
          {
            "title": "Chapter 5 Basics of finance and budgeting",
            "videoUrl": "https://firebasestorage.googleapis.com/v0/b/money-minds-66b65.appspot.com/o/videos%2FFinancial%20Literacy%20for%20Kids%20_%20Learn%20the%20basics%20of%20finance%20and%20budgeting.mp4?alt=media&token=879762e5-6947-4512-82e2-64af725d4f16c",
            "progress": "Pending",
            "status": true // or false based on the video status
          },
          {
            "title": "Chapter 6 Ways to Make Money Tips",
            "videoUrl": "https://firebasestorage.googleapis.com/v0/b/money-minds-66b65.appspot.com/o/videos%2FHow%20to%20Make%20Money%20Tips%20-%20Financial%20Education%20for%20Kids%20_%20Financial%20Literacy%20for%20Kids%20_%20Kids%20Money.mp4?alt=media&token=04499c2f-60de-4d7e-aca9-94dda976f662",
            "progress": "Pending",
            "status": true // or false based on the video status
          },
        ],
        "malayvideos": [
          {
            "title": "Bab 1 Mengenal Mata Wang Malaysia",
            "videoUrl": "https://firebasestorage.googleapis.com/v0/b/money-minds-66b65.appspot.com/o/malayvideos%2FMengenal%20Mata%20Wang%20Malaysia%20_%20Bahasa%20Melayu-%20Dadidu%20Kids.mp4?alt=media&token=6f4b875e-3b8c-4537-afb2-845224f951cd",
            "progress": "Pending",
            "status": true // or false based on the video status
          },
          {
            "title": "Bab 2 Penggunaan wang syiling",
            "videoUrl": "https://firebasestorage.googleapis.com/v0/b/money-minds-66b65.appspot.com/o/malayvideos%2FPENGGUNAAN%20WANG%20SYILING.mp4?alt=media&token=8c9389a8-2840-462b-8036-c49c7a3f824a",
            "progress": "Pending",
            "status": true // or false based on the video status
          },
          {
            "title": "Bab 3 Penggunaan wang kertas",
            "videoUrl": "https://firebasestorage.googleapis.com/v0/b/money-minds-66b65.appspot.com/o/malayvideos%2FTahun%202%20_%20Matematik%20_%20Nilai%20Ringgit%20Malaysia.mp4?alt=media&token=dba2da2b-3ebc-4d3c-becb-850165a5da3d",
            "progress": "Pending",
            "status": true // or false based on the video status
          },
          {
            "title": "Bab 4 Menukar Wang dalam Wang Kertas dan Duit Syiling",
            "videoUrl": "https://firebasestorage.googleapis.com/v0/b/money-minds-66b65.appspot.com/o/malayvideos%2FTahun%201_%20Matematik_%20Menukar%20Wang%20dalam%20Wang%20Kertas%20dan%20Duit%20Syiling.mp4?alt=media&token=90309765-0d1e-4837-bcd5-c0a4057856e3",
            "progress": "Pending",
            "status": true // or false based on the video status
          },
          {
            "title": "Bab 5 Tambah Nilai Wang",
            "videoUrl": "https://firebasestorage.googleapis.com/v0/b/money-minds-66b65.appspot.com/o/malayvideos%2FTahun%202%20_%20Matematik%20_%20Tambah%20Nilai%20Wang.mp4?alt=media&token=ab5f70ef-4c03-4eb5-9cb5-367f002c9b0f",
            "progress": "Pending",
            "status": true // or false based on the video status
          },
          {
            "title": "Bab 6 Tolak Nilai Wang",
            "videoUrl": "https://firebasestorage.googleapis.com/v0/b/money-minds-66b65.appspot.com/o/malayvideos%2FTahun%202%20_%20Matematik%20_%20Tolak%20Nilai%20Wang.mp4?alt=media&token=b1f03740-16d0-40cb-b7e4-b4797d9d0a2e",
            "progress": "Pending",
            "status": true // or false based on the video status
          },
          {
            "title": "Bab 7 Penyelesaian Masalah Melibatkan Wang",
            "videoUrl": "https://firebasestorage.googleapis.com/v0/b/money-minds-66b65.appspot.com/o/malayvideos%2FTahun%201_%20Matematik_%20Penyelesaian%20Masalah%20Melibatkan%20Wang.mp4?alt=media&token=34b2ab2a-f638-4b9b-9cda-a48a4ae90feb",
            "progress": "Pending",
            "status": true // or false based on the video status
          },
          {
            "title": "Bab 8 Darab Wang dan Masalah Harian",
            "videoUrl": "https://firebasestorage.googleapis.com/v0/b/money-minds-66b65.appspot.com/o/malayvideos%2FTahun%203%20_%20Matematik%20_%20Darab%20Wang%20dan%20Masalah%20Harian.mp4?alt=media&token=84d578fe-fa48-4aac-b323-75249206152b",
            "progress": "Pending",
            "status": true // or false based on the video status
          },
          {
            "title": "Bab 9 Bahagi Wang dan Masalah Harian",
            "videoUrl": "https://firebasestorage.googleapis.com/v0/b/money-minds-66b65.appspot.com/o/malayvideos%2FTahun%203%20_%20Matematik%20_%20Bahagi%20Wang%20dan%20Masalah%20Harian.mp4?alt=media&token=f39d0086-62ea-4307-87ce-5c5be6211e77",
            "progress": "Pending",
            "status": true // or false based on the video status
          },
        ],
"quizzes": {
    "level1": {
      "status": true,
      "progress": "Pending",
      "marks": 0,
      "questions": [
        {
          "question": "Jason want to buy 6 cookies. 1 cookie price is 1RM?",
          "correctAnswer": "6 RM",
          "wrongAnswers": [ "12 RM", "3 RM"],
        },
        {
          "question": "How many 20 sen coin do you need to make 1 RM?",
          "correctAnswer": "5",
          "wrongAnswers": ["2", "3"],
        },
        {
          "question": "If Nina has 2 RM and Asher has 5 RM, how much do they have altogether?",
          "correctAnswer": "7 RM",
          "wrongAnswers": ["3 RM", "10 RM"],
        },
        {
          "question": "How many 10 sen coin do you need to make 60 sen?",
          "correctAnswer": "6",
          "wrongAnswers": ["3", "8"],
        },
        {
          "question": "How many 5 sen coin do you need to make 60 sen?",
          "correctAnswer": "12",
          "wrongAnswers": ["10",  "60"],
        },
        {
          "question": "A cotton candy cost 4 RM. Lily wants to buy 2 of them. How much will she needs to pay?",
          "correctAnswer": "8",
          "wrongAnswers": ["4", "10"],
        },
        // ... (other questions for level1)
      ],
    },
    "level2": {
      "status": true,
      "progress": "Pending",
      "marks": 0,
      "questions": [
        {
          "question": "Kelvin bought some grapes with 10 RM notes. The grapes cost 8 RM. How much balance should he have left?",
          "correctAnswer": "2",
          "wrongAnswers": ["1",  "5"],
        },
        {
          "question": "Janice wants to buy a pencil case which cost 30 RM. She only have 20 RM. How much more she needs?",
          "correctAnswer": "10",
          "wrongAnswers": ["20", "5"],
        },
        {
          "question": "How many 5 RM notes do you need to make 10 RM?",
          "correctAnswer": "2",
          "wrongAnswers": ["1",  "3"],
        },
        {
          "question": "Bryan has 5 RM. His father give him 1 RM and his mother gives him RM 2. How much does he have in total?",
          "correctAnswer": "8",
          "wrongAnswers": ["6", "7"],
        },
        // ... (other questions for level2)
      ],
    },
    // ... (other quiz levels)
  },
      });
      await _auth.signOut();
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => const LoginPage()));
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
                      'Let\'s register your account',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const Text(
                      'Enter your detail below and free signup now',
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
                        controller: age,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: 'Age',
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
                    Text("Gender", style: TextStyle(fontSize: 18)),
                    Row(
                      children: [
                        Radio(
                          value: "male",
                          groupValue: gender,
                          onChanged: (value) {
                            setState(() {
                              gender = value.toString();
                            });
                          },
                        ),
                        Text("Male"),
                        Radio(
                          value: "female",
                          groupValue: gender,
                          onChanged: (value) {
                            setState(() {
                              gender = value.toString();
                            });
                          },
                        ),
                        Text("Female"),
                        Radio(
                          value: "other",
                          groupValue: gender,
                          onChanged: (value) {
                            setState(() {
                              gender = value.toString();
                            });
                          },
                        ),
                        Text("Other"),
                      ],
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
                                  'Register',
                                  style: TextStyle(fontSize: 18),
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Already have an account? ',
                          style: TextStyle(fontSize: 16),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => const LoginPage()),
                                (route) => false);
                          },
                          child: const Text(
                            'Login Now',
                            style: TextStyle(
                                color: Colors.blue,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
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
