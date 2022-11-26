import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat/components/rounded_button.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import "package:flutter_map/flutter_map.dart";
import "package:latlong2/latlong.dart";
import "package:http/http.dart" as http;
import "dart:convert" as convert;
import 'package:location/location.dart';

final _firestore = FirebaseFirestore.instance;
User loggedInUser;

class DriverMapScreen extends StatefulWidget {
  static String id = "driver_map_screen";
  @override
  _DriverMapScreenState createState() => _DriverMapScreenState();
}

class _DriverMapScreenState extends State<DriverMapScreen> {
  final _auth = FirebaseAuth.instance;
  final _employeeDetails =
      _firestore.collection('users').doc('EQeXR1MUMDQ23gDQBqj7zgdfqe03');

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

  /* void getEmployee() async {
    _firestore.collection('users').doc("");
  }
*/
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Map",
      home: Scaffold(
        body: Center(
          child: Stack(
            children: <Widget>[
              StreamBuilder(
                  stream: Stream.periodic(const Duration(seconds: 5)),
                  builder: (context, snapshot) {
                    return GetCurrentLocation();
                  }),
            ],
          ),
        ),
      ),
    );
  }
}

// Get Real-Time Location
class GetCurrentLocation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<LocationData>(
      future: _currentLocation(),
      builder: (context, AsyncSnapshot<dynamic> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        print(snapshot.data);
        final LocationData currentLocation = snapshot.data;

        final latLongUserValue = new LatLng(27.688300,
            85.335585 /*currentLocation.latitude, currentLocation.longitude*/
            );
        final latLongDriverValue =
            new LatLng(currentLocation.latitude, currentLocation.longitude);
        return FlutterMap(
          options: new MapOptions(center: latLongUserValue, zoom: 13.0),
          nonRotatedChildren: [
            AttributionWidget.defaultWidget(
              source: 'OpenStreetMap',
              onSourceTapped: null,
            ),
          ],
          children: [
            new TileLayer(
              /*urlTemplate: "https://api.tomtom.com/map/1/tile/basic/main/"
                          "{z}/{x}/{y}.png?key=${apiKey}",
                      userAgentPackageName: 'co.appbrewery.flash_chat',*/
              urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
              subdomains: ['a', 'b', 'c'],
            ),
            new MarkerLayer(
              markers: [
                new Marker(
                  width: 80.0,
                  height: 80.0,
                  point: latLongUserValue,
                  builder: (BuildContext context) => const Icon(Icons.man,
                      size: 60.0, color: Colors.lightBlue),
                ),
              ],
            ),
            new MarkerLayer(
              markers: [
                new Marker(
                  width: 80.0,
                  height: 80.0,
                  point: latLongDriverValue,
                  builder: (BuildContext context) => const Icon(Icons.train,
                      size: 60.0, color: Colors.lightBlue),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

//Location Permission
Future<LocationData> _currentLocation() async {
  bool serviceEnabled;
  PermissionStatus permissionGranted;
  Location location = new Location();

  serviceEnabled = await location.serviceEnabled();
  if (!serviceEnabled) {
    serviceEnabled = await location.requestService();
    if (!serviceEnabled) {
      return null;
    }
  }
  permissionGranted = await location.hasPermission();
  if (permissionGranted == PermissionStatus.denied) {
    permissionGranted = await location.requestPermission();
    if (permissionGranted != PermissionStatus.granted) {
      return null;
    }
  }
  return await location.getLocation();
}
