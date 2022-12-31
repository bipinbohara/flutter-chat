import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/components/rounded_button.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'user_main.dart';
import 'package:shared_preferences/shared_preferences.dart';

final _firestore = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;
User loggedInUser;
String userid;

class UserDataScreen extends StatefulWidget {
  static String id = "user_data_screen";

  @override
  _UserDataScreenState createState() => _UserDataScreenState();
}

void getCurrentUser() async {
  try {
    final user = await _auth.currentUser;

    if (user != null) {
      loggedInUser = user;
      print("UserID: " + loggedInUser.uid);
    }
    print("UserID: " + loggedInUser.uid);
    userid = loggedInUser.uid;
    print("this is userid");
    print(userid);
  } catch (e) {
    print(e);
  }
}

class _UserDataScreenState extends State<UserDataScreen> {
  @override
  void initState() {
    _loadUserShiftRoute();
    super.initState();
  }

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

  TextEditingController _shiftUserController = TextEditingController();
  TextEditingController _routeUserController = TextEditingController();

  void _loadUserShiftRoute() async {
    print("Load Route and Shift");
    try {
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      var __shiftUser = _prefs.getString("shiftUser") ?? "Regular";
      var __routeUser = _prefs.getString("routeUser") ?? "Bhaktapur-Hattisar";

      print("Shift: " + __shiftUser);
      print("Route: " + __routeUser);

      setState(() {});
      _shiftUserController.text = __shiftUser ?? "";
      _routeUserController.text = __routeUser ?? "";
    } catch (e) {
      print(e);
    }
  }

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
                  setState(
                    () {
                      selectedRoute = selectedUserRoute;
                    },
                  );
                  SharedPreferences.getInstance().then(
                    (prefs) {
                      prefs.setString('routeUser', selectedRoute);
                      print("Set User Route: " + selectedRoute);
                    },
                  );
                },
                //value: selectedRoute,
                value: _routeUserController.text,
                isExpanded: false,
                hint: Text(
                  'Choose Your Route',
                  style: TextStyle(color: Colors.black),
                ),
              ),

              SizedBox(
                height: 8.0,
              ),
              DropdownButtonFormField(
                decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white))),
                items: _shifts
                    .map(
                      (value) => DropdownMenuItem(
                        child: Text(
                          value,
                          style: TextStyle(color: Colors.black),
                        ),
                        value: value,
                      ),
                    )
                    .toList(),
                onChanged: (selectedUserShift) {
                  setState(
                    () {
                      selectedShift = selectedUserShift;
                    },
                  );
                  SharedPreferences.getInstance().then(
                    (prefs) {
                      prefs.setString('shiftUser', selectedShift);
                      print("Set Shift: " + selectedShift);
                    },
                  );
                },
                //value: selectedShift,
                value: _shiftUserController.text,
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
                  print("Route to save: " + selectedRoute);
                  print("Shift to save: " + selectedShift);
                  _firestore
                      .collection('users')
                      .doc('mWGEkORb1wfqNvzCKEym')
                      .update(dataToUpdate);
                },
              ),
              RoundedButton(
                title: "Back",
                colour: Colors.blueAccent,
                onPressed: () {
                  Navigator.pushNamed(context, UserMain.id);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
