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
  var selectedShift;
  var selectedRoute;

  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  String shift;
  String route;

  List<String> _shifts = <String>['Regular', 'Evening'];
  List<String> _routes = <String>[
    'Bhaktapur-Hattisar',
    'Lalitpur-Hattisar',
    'Kirtipur-Hattisar'
  ];

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
              /*TextField(
                keyboardType: TextInputType.text,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  route = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Enter your Route', labelText: "Route"),
              ),*/
              //Dropdown for Routes
              DropdownButtonFormField(
                decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white))),
                items: _routes
                    .map((value) => DropdownMenuItem(
                          child: Text(
                            value,
                            style: TextStyle(color: Colors.black),
                          ),
                          value: value,
                        ))
                    .toList(),
                onChanged: (selectedUserRoute) {
                  setState(() {
                    selectedRoute = selectedUserRoute;
                  });
                },
                value: selectedRoute,
                isExpanded: false,
                hint: Text(
                  'Choose Your Route',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              /*TextField(
                keyboardType: TextInputType.text,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  shift = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Enter your Shift', labelText: "Shift"),
              ),*/
              DropdownButtonFormField(
                decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white))),
                items: _shifts
                    .map((value) => DropdownMenuItem(
                          child: Text(
                            value,
                            style: TextStyle(color: Colors.black),
                          ),
                          value: value,
                        ))
                    .toList(),
                onChanged: (selectedUserShift) {
                  setState(() {
                    selectedShift = selectedUserShift;
                  });
                },
                value: selectedShift,
                isExpanded: false,
                hint: Text(
                  'Choose Your Shift',
                  style: TextStyle(color: Colors.black),
                ),
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
                    'route': selectedRoute,
                    'shift': selectedShift,
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
