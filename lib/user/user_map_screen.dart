import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import "package:flutter_map/flutter_map.dart";
import "package:latlong2/latlong.dart";
import "package:http/http.dart" as http;
import "dart:convert" as convert;
import 'package:location/location.dart';

User loggedin;

class UserMapScreen extends StatefulWidget {
  static String id = "map_view_for_user";
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<UserMapScreen> {
  //final String apiKey = "8YO7lZRPUyq5TY9Lx1hufSLsGmn1gWUe";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Map",
      home: Scaffold(
        body: Column(
          children: <Widget>[
            Expanded(
                child: StreamBuilder(
                    stream: Stream.periodic(const Duration(seconds: 5)),
                    builder: (context, snapshot) {
                      return GetCurrentLocation();
                    }))
          ],
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
        final latLongValue =
            new LatLng(currentLocation.latitude, currentLocation.longitude);

        return FlutterMap(
          options: new MapOptions(center: latLongValue, zoom: 13.0),
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
            new PolylineLayer(
              polylineCulling: false,
              polylines: [
                Polyline(
                  points: [
                    LatLng(27.688300, 85.335585),
                    LatLng(27.694767, 85.320774),
                    LatLng(27.711656, 85.322068),
                  ],
                  color: Colors.blue,
                  strokeWidth: 4,
                )
              ],
            ),
            new MarkerLayer(
              markers: [
                new Marker(
                  width: 80.0,
                  height: 80.0,
                  point: latLongUserValue,
                  builder: (BuildContext context) => const Icon(
                      Icons.location_on,
                      size: 60.0,
                      color: Colors.lightBlue),
                ),
              ],
            ),
            new MarkerLayer(
              markers: [
                new Marker(
                  width: 80.0,
                  height: 80.0,
                  point: latLongValue,
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
  print("Here!!!!!!!!!!!!!!!");
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
