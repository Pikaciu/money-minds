// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:money_minds/view/pages/bottom_navigation_bar_for_caregiver.dart';

import '../../../constants/color/color.dart';
import '../../pages/bottom_navigation_bar.dart';
import '../signup/sign_up_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  get key => null;
  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePasswordText = true;
  RegExp regExp = RegExp("key: \\[\\d+\\]");
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // login(BuildContext context)
  login(context) async {
    //email validate

    if (emailController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: ColorConstants.statusBarColor,
          content: const Text("Email is empty")));
      return;
    } else if (!emailController.text.contains("@") ||
        !emailController.text.contains(".")) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: ColorConstants.statusBarColor,
          content: const Text("Email is not valid")));
      return;
    }
    //password validate
    if (passwordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: ColorConstants.statusBarColor,
          content: const Text("Password is empty")));
      return;
    }
    if (passwordController.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: ColorConstants.statusBarColor,
          content: const Text("Password is too short")));
      return;
    }
    try {
      FocusScope.of(context).unfocus();
      setState(() {
        _isLoading = true;
      });
    UserCredential userCredential =  await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      bool isLoggedIn = true;
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // await prefs.setBool('isLoggedIn', isLoggedIn);
      // print(prefs.getBool('isLoggedIn'));
      setState(() {
        _isLoading = false;
      });
      print(userCredential);
      print('userCredential');
      route();
      // Navigator.of(context).pushAndRemoveUntil(
      //     MaterialPageRoute(
      //         builder: (context) => const BottomNavigationBarScreen()),
      //     (route) => false);
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: ColorConstants.appColor,
        content: Text(
          e.message ?? 'Somthing went wrong',
          style: const TextStyle(color: Colors.white),
        ),
        duration: const Duration(seconds: 2),
      ));
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: ColorConstants.appColor,
            content: const Text("No user found for that email")));
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: ColorConstants.appColor,
            content: const Text("Wrong password provided for that user")));
      }
      setState(() {
        _isLoading = false;
      });
    } catch (err) {
      print(err);
      setState(() {
        _isLoading = false;
      });
    }
  }

    void route() {
    User? user = FirebaseAuth.instance.currentUser;
    print(user);
    print('user');
    var kk = FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        if (documentSnapshot.get('type') == "caregiver") {
          print('caregiver login');
          // Navigator.of(context)
          //     .push(MaterialPageRoute(builder: (_) => AdminDashboard()));
                    Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => BottomNavigationBarForCaregiverScreen()));
        } else if (documentSnapshot.get('type') == "kid") {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => BottomNavigationBarScreen()));
        } 
      } else {
        print('Document does not exist on the database');
      }
    });
  }

  var userCus = DateTime.now().toString();

  void validation  () {
    if (emailController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: ColorConstants.statusBarColor,
          content: const Text("Email is empty")));
      return;
    } else if (!emailController.text.contains("@") ||
        !emailController.text.contains(".")) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: ColorConstants.statusBarColor,
          content: const Text("Email is not valid")));
      return;
    } else {

      addRequest();
    }
  }


  addRequest() async{
 try {

      print("request done");
        // var emaildata = await firestore.collection('users').where('userId', isEqualTo: '${emailController.text}').snapshots();

        //  var userdata = await firestore.collection('users').doc().get();
        //  print(userdata.data()!['name']);
          await FirebaseFirestore.instance
          // await firestore
              .collection('forgotRequest')
              .doc(userCus)
              .set({
        "id": userCus,
        "email": emailController.text,
        "requestDate": Timestamp.now(),
      });

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          'Kindly Check Your Mail for Your Password',
          // style: TextStyle(color: Colors.white),
        ),
        duration: Duration(seconds: 5),
      ));
            Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => const LoginPage()));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          e.toString(),
          style: const TextStyle(color: Colors.white),
        ),
        duration: const Duration(seconds: 2),
      ));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    double width = size.width;
    double height = size.height;
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: width,
          height: height,
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(child: Image.asset("assets/images/logo.jpg", width: 200,)),
                  const SizedBox(
                    height: 50,
                  ),
                  const Text(
                    'Let\'s sign you in',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Text(
                    'Welcome back, You have been missed',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  Container(
                    constraints: const BoxConstraints(maxHeight: 55),
                    child: TextFormField(
                      controller: emailController,
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
                      controller: passwordController,
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
                  // const SizedBox(height: 12),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.end,
                  //   children: [
                  //     InkWell(
                  //         onTap: () {
                  //           // addUserCourseData();

                  //           showDialog(
                  //             context: context,
                  //             barrierDismissible: false,
                  //             builder: (context) {
                  //               return AlertDialog(
                  //                 content:
                  //                     Text("Are you sure you want to proceed?"),
                  //                 actions: <Widget>[
                  //                   TextButton(
                  //                     child: const Text('Cancel'),
                  //                     onPressed: () {
                  //                       Navigator.of(context).pop();
                  //                     },
                  //                   ),
                  //                   TextButton(
                  //                     child: const Text('Yes'),
                  //                     onPressed: () async{
                  //                       validation();
                  //                       Navigator.of(context)
                  //                       .push(MaterialPageRoute(builder: (_) => const LoginPage()));
                  //                     },
                  //                   )
                  //                 ],
                  //               );
                  //             },
                  //           );
                  //         },
                  //         child: const Text(
                  //           'Forgot Password?',
                  //           style: TextStyle(
                  //               color: Colors.blue,
                  //               fontSize: 16,
                  //               fontWeight: FontWeight.bold),
                  //         )),
                  //   ],
                  // ),
                  
                  const SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    width: width,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                      ),
                      onPressed: () {
                        login(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                'Login',
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
                      const Text('Didn\'t have an account? ',
                          style: TextStyle(
                            fontSize: 16,
                          )),
                      InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const SignUpPage(),
                              ),
                            );
                          },
                          child: const Text(
                            'Register Now',
                            style: TextStyle(
                                color: Colors.blue,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          )),
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
    );
  }
}
