import "package:flutter/material.dart";
import "package:flutter_map/flutter_map.dart";
import "package:latlong2/latlong.dart";
import "package:http/http.dart" as http;
import "dart:convert" as convert;

class MapScreen extends StatefulWidget {
  static String id = "map_view";
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final String apiKey = "8YO7lZRPUyq5TY9Lx1hufSLsGmn1gWUe";

  @override
  Widget build(BuildContext context) {
    final tomtomHQ = new LatLng(52.376372, 4.908066);
    return MaterialApp(
      title: "TomTom Map",
      home: Scaffold(
        body: Center(
            child: Stack(
          children: <Widget>[
            FlutterMap(
              options: new MapOptions(center: tomtomHQ, zoom: 13.0),
              /*layers: [
                new TileLayerOptions(
                  urlTemplate: "https://api.tomtom.com/map/1/tile/basic/main/"
                      "{z}/{x}/{y}.png?key={apiKey}",
                  additionalOptions: {"apiKey": apiKey},
                )
              ],*/
          layers: [
          ],
        )),
      ),
    );
  }
}
