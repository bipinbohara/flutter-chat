import 'package:firebase_core/firebase_core.dart';
import 'package:flash_chat/driver/driver_data_screen.dart';
import 'package:flash_chat/driver/driver_map_screen.dart';
import 'package:flash_chat/screens/chat_screen.dart';
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

class EmployeeDetail extends StatefulWidget {
  static String id = "employee_detail_screen";
  @override
  _EmployeeDetailState createState() => _EmployeeDetailState();
}

class _EmployeeDetailState extends State<EmployeeDetail> {
  final messageTextController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
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

  final driverUsername = DataUser().getLoggedInUserName();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User: " + driverUsername),
        leading: null,
        actions: <Widget>[
          StreamBuilder(
            stream: _firestore.collection('users').snapshots(),
            builder: (context, snapshot) {
              final _employeeData = snapshot.data.docs;
              List<DataUser> dataUsers = [];
              final _loggedInUserName = '';
              final countData = _employeeData.length;
              for (var employee in _employeeData) {
                final employeeData = employee.data();
                final employeeName = employeeData['name'];
                //print("Name: " + employeeName);
                final employeePhoneNumber = employeeData['phone_number'];
                //print("Number: " + employeePhoneNumber);
                final employeeLocation = employeeData['location'];
                final employeeRoute = employeeData['route'];
                //print("Route: " + employeeRoute);
                final employeeShift = employeeData['shift'];
                //print("Shift: " + employeeShift);
                final employeeUid = employeeData['uid'];
                //print("UID: " + employeeUid);
                final employeeRole = employeeData['role'];
                //print("Role: " + employeeRole);

                final dataUser = DataUser(
                  name: employeeName,
                  phoneNumber: employeePhoneNumber,
                  location: employeeLocation,
                  shift: employeeShift,
                  route: employeeRoute,
                  uid: employeeUid,
                  role: employeeRole,
                  loggedInUserUid: loggedInUser.uid,
                  count: countData,
                );
                dataUsers.add(dataUser);
                /*if (loggedInUser.uid == employeeUid &&
                    employeeRole == "Driver") {
                  print(employeeName);
                  final _loggedInDriverUsername = employeeName;
                }*/
              }
              return Center(
                  child: Text(
                "" /*driverUsername.toString()*/,
              ));
            },
          )
        ],
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            EmployeeStream(),
          ],
        ),
      ),
    );
  }
}

class EmployeeStream extends StatelessWidget {
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _firestore.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        final _employeeData = snapshot.data.docs;
        List<EmployeeBubble> employeeBubbles = [];
        for (var employee in _employeeData) {
          final employeeData = employee.data();
          // Check route
          String driverRoute;

          final employeeName = employeeData['name'];
          //print("Name: " + employeeName);
          final employeePhoneNumber = employeeData['phone_number'];
          //print("Number: " + employeePhoneNumber);
          final employeeLocation = employeeData['location'];
          final employeeRoute = employeeData['route'];
          //print("Route: " + employeeRoute);
          final employeeShift = employeeData['shift'];
          //print("Shift: " + employeeShift);
          final employeeUid = employeeData['uid'];
          //print("UID: " + employeeUid);
          final employeeRole = employeeData['role'];
          //print("Role: " + employeeRole);

          if (employeeData['role'] == "driver") {
            driverRoute = employeeData['route'];
            print("Driver Route: " + driverRoute);
            print("Employee Route: " + employeeData['route']);
            continue;
          }

          /*if (driverRoute != employeeData['route']) {
            print("Driver Route: " + driverRoute);
            continue;
          }*/

          final currentUser = loggedInUser.email;
          final employeeBubble = EmployeeBubble(
            name: employeeName,
            phoneNumber: employeePhoneNumber,
            location: employeeLocation,
            shift: employeeShift,
            route: employeeRoute,
            uid: employeeUid,
            role: employeeRole,
          );
          employeeBubbles.add(employeeBubble);
        }
        return Expanded(
          child: ListView(
            reverse: true,
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            children: employeeBubbles,
          ),
        );
      },
    );
  }
}

class EmployeeBubble extends StatelessWidget {
  EmployeeBubble({
    this.name,
    this.phoneNumber,
    this.location,
    this.shift,
    this.route,
    this.uid,
    this.role,
  });

  final String name;
  final String phoneNumber;
  final GeoPoint location;
  final String shift;
  final String route;
  final String uid;
  final String role;

  //List<DataUser> dataUsers = [];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          /*Text(
            name,
            style: TextStyle(
              fontSize: 12.0,
              color: Colors.black54,
            ),
          ),*/
          Material(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(30.0),
              topLeft: Radius.circular(30.0),
              bottomLeft: Radius.circular(30.0),
              bottomRight: Radius.circular(30.0),
            ),
            elevation: 5.0,
            color: Colors.lightBlueAccent,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Text(
                name + ": " + phoneNumber,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DataUser {
  final String name;
  final String phoneNumber;
  final GeoPoint location;
  final String shift;
  final String route;
  final String uid;
  final String role;
  final String loggedInUserUid;
  final int count;

  DataUser({
    this.name,
    this.phoneNumber,
    this.location,
    this.shift,
    this.route,
    this.uid,
    this.role,
    this.loggedInUserUid,
    this.count,
  });

  /*for(int i=0; i<count; i++){
    if(i==0){
      print(i);
  }*/
  String getLoggedInUserName() {
    if (loggedInUserUid == uid && role == "Driver") {
      print(name);
      return name;
    } else
      return "Jack Sparrow";
  }
}
