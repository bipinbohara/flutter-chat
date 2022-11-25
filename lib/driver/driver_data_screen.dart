import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/components/rounded_button.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'driver_main.dart';

final _firestore = FirebaseFirestore.instance;
User loggedInUser;

class DriverDataScreen extends StatefulWidget {
  static String id = "driver_data_screen";

  @override
  _DriverDataScreenState createState() => _DriverDataScreenState();
}

class _DriverDataScreenState extends State<DriverDataScreen> {
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  String shift;
  String route;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(
                height: 48.0,
              ),
              TextField(
                keyboardType: TextInputType.text,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  route = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Enter your Route', labelText: "Route"),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                keyboardType: TextInputType.text,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  shift = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Enter your Shift', labelText: "Shift"),
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                title: "Save",
                colour: Colors.blueAccent,
                onPressed: () async {
                  setState(() {
                    showSpinner = false;
                  });

                  /*_firestore.collection('users').doc().add({
                    'shift': shift,
                    'route': route,
                  });*/
                  Map<String, String> dataToUpdate = {
                    'route': route,
                    'shift': shift,
                  };
                  _firestore
                      .collection('users')
                      .doc('OR3Oy9cv1RVd8Jk2lioXMSWJY8z1')
                      .update(dataToUpdate);
                },
              ),
              RoundedButton(
                title: "Back",
                colour: Colors.blueAccent,
                onPressed: () {
                  Navigator.pushNamed(context, DriverMain.id);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
