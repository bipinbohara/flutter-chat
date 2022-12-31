import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/components/rounded_button.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'driver_main.dart';
import 'package:shared_preferences/shared_preferences.dart';

final _firestore = FirebaseFirestore.instance;
User loggedInUser;

class DriverDataScreen extends StatefulWidget {
  static String id = "driver_data_screen";

  @override
  _DriverDataScreenState createState() => _DriverDataScreenState();
}

class _DriverDataScreenState extends State<DriverDataScreen> {
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

  TextEditingController _shiftDriverController = TextEditingController();
  TextEditingController _routeDriverController = TextEditingController();

  void _loadUserShiftRoute() async {
    print("Load Route and Shift");
    try {
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      var __shiftDriver = _prefs.getString("shiftDriver") ?? "Regular";
      var __routeDriver =
          _prefs.getString("routeDriver") ?? "Bhaktapur-Hattisar";

      print("Shift: " + __shiftDriver);
      print("Route: " + __routeDriver);

      setState(() {});
      _shiftDriverController.text = __shiftDriver ?? "";
      _routeDriverController.text = __routeDriver ?? "";
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
                      borderSide: BorderSide(color: Colors.white)),
                ),
                items: _routes
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
                onChanged: (selectedUserRoute) {
                  setState(
                    () {
                      selectedRoute = selectedUserRoute;
                    },
                  );
                  SharedPreferences.getInstance().then(
                    (prefs) {
                      prefs.setString('routeDriver', selectedRoute);
                      print("Set Driver Route: " + selectedRoute);
                    },
                  );
                },
                value: _routeDriverController.text,
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
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
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
                      prefs.setString('shiftDriver', selectedShift);
                      print("Set Driver Shift: " + selectedShift);
                    },
                  );
                },
                value: _shiftDriverController.text,
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
