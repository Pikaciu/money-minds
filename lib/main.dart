
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:money_minds/view/authentication/login/login_page.dart';
import 'package:money_minds/view/authentication/signup/sign_up_page.dart';


bool? isviewed = false;
void main() async {
  // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
  //   systemNavigationBarColor:
  //       ColorConstants.statusBarColor, // navigation bar color
  //   statusBarColor: ColorConstants.statusBarColor, // status bar color
  // ));
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // SharedPreferences prefs = await SharedPreferences.getInstance();
  // isviewed = prefs.getBool('onBoard');
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage() ,
    );
  }
}


