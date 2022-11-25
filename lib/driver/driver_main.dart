import 'package:firebase_core/firebase_core.dart';
import 'package:flash_chat/driver/driver_data_screen.dart';
import 'package:flash_chat/driver/driver_map_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat/components/rounded_button.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import '../screens/login_screen.dart';
import '../screens/registration_screen.dart';

final _firestore = FirebaseFirestore.instance;
User loggedInUser;

class DriverMain extends StatefulWidget {
  static String id = "driver_main";
  @override
  _DriverMainState createState() => _DriverMainState();
}

class _DriverMainState extends State<DriverMain> {
  final _auth = FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;

      if (user != null) {
        loggedInUser = user;
        print("UserID: " + loggedInUser.uid);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: 60,
                    alignment: Alignment.center,
                  ),
                ),
                AnimatedTextKit(animatedTexts: [
                  WavyAnimatedText(
                    'HackFest',
                    textStyle: TextStyle(
                      fontSize: 45.0,
                      fontWeight: FontWeight.w900,
                      color: Colors.grey,
                    ),
                  ),
                ]),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            RoundedButton(
              title: "Enter Data",
              colour: Colors.lightBlueAccent,
              onPressed: () {
                Navigator.pushNamed(context, DriverDataScreen.id);
              },
            ),
            RoundedButton(
              title: "Map View",
              colour: Colors.blueAccent,
              onPressed: () {
                Navigator.pushNamed(context, DriverMapScreen.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}
