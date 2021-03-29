import 'dart:html';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

Location location = new Location();

Future<LocationData> data;
Future<PermissionStatus> permission;
Future<bool> service;

//GoogleMap map;
//GoogleMapController mapController;

void currentLocation() {
  permission = location.requestPermission();
  service = location.serviceEnabled();

  if (service == false) {
    service = location.requestService();
  }

  if (permission == PermissionStatus.granted && service == true) {
    data = location.getLocation();
  }

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  GoogleMapController mapController;

  final LatLng _center = const LatLng(45.521563, -122.677433);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Roomie Location'),
          backgroundColor: Colors.yellow[300],
        ),
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 11.0,
          ),
        ),
      ),
    );
  }
}
