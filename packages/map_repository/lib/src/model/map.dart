import 'dart:html';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

Location location = new Location();

Future<LocationData> data;
Future<PermissionStatus> permission;
Future<bool> service;

void currentLocation() {
  permission = location.requestPermission();
  service = location.serviceEnabled();

  if (service == false) {
    location.requestService();
  }

  if (permission == PermissionStatus.granted && service == true) {
    data = location.getLocation();
  }
}
