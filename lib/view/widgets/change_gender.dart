// import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
// ignore: unnecessary_import
import 'package:flutter/cupertino.dart';

import '../../constants/color/color.dart';




// import 'package:flutter_ecommerce_app/widgets/TextFieldWidget.dart';
//import 'package:geolocator/geolocator.dart';

// ignore: must_be_immutable
class ChangeGender extends StatefulWidget {
  String name;
  ChangeGender({Key? key, required this.name}) : super(key: key);
  @override
  _ChangeGenderState createState() => _ChangeGenderState();
}

class _ChangeGenderState extends State<ChangeGender> {
  TextEditingController nameField = new TextEditingController();
  // final _preferenceService = SharedPref();
  Future getUserData() async {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      var users = await FirebaseFirestore.instance
          .collection('userinfo')
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

  //Position _currentPosition;
  String date = "";
  DateTime selectedDate = DateTime.now();

  var userCus = DateTime.now().toString();
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
  @override
  void initState() {
    ename.text = widget.name;
    super.initState();
  }

  void saveCustomization() {
    // final dataView = Data(guid: "2321312312321", isCustomized: true);
    print("Save Customization");
    // _preferenceService.saveCustomization(dataView);
  }
//edit name

  final ename = TextEditingController();

  editName() async {
    try {
      await firestoreInstance
          .collection('users')
          .doc(auth.currentUser!.uid)
          .update({
        'gender': ename.text,
      });
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    } catch (e) {
      print(e);
    }
  }

  // @override
  void dispose() {
    super.dispose();
    // addressController.dispose();
    ename.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: buildAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: size.width,
            height: size.height,
            child: Card(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Changing your gender"),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      keyboardType: TextInputType.text,
                      controller: ename,
                      decoration: InputDecoration(
                        fillColor: Colors.blue.shade100,
                        border: OutlineInputBorder(),
                        labelText: 'Gender',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      leading: BackButton(),
      backgroundColor: ColorConstants.appColor,
      elevation: 0,
      centerTitle: true,
      title: Text(
        "Change Gender",
        // style: TextStyle(color: Colors.black),
      ),
      actions: [
        GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return AlertDialog(
                  content: Text("Are you sure you want to proceed?"),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('Cancel'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: const Text('Yes'),
                      onPressed: () {
                        editName();
                      },
                    )
                  ],
                );
              },
            );
          },
          child: Icon(
            Icons.check,
            size: 26.0,
          ),
        ),
        SizedBox(width: 10),
      ],
    );
  }
}
