import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:map_repository/map_repository.dart';
import 'package:map_repository/src/entities/user_location_entity.dart';
import 'package:http/http.dart' as http;

import 'entities/house_location_entity.dart';



class NoAddressesFoundException implements Exception {}


class PermissionDeniedException implements Exception {}

class MapRepository {
  final Location _location;
  final FirebaseFirestore _firestore;

  

  MapRepository()
      : this._firestore = FirebaseFirestore.instance,
        this._location = Location.instance;


  Future<List<HouseLocation>> fetchAdresses(String inputText) async {

    try {

      final Map<String, String> queryParameters = {"format": 'json',"benchmark": 'Public_AR_Census2020', "address": inputText};
      const String path = '/geocoder/locations/onelineaddress';
      const String authority = 'geocoding.geo.census.gov';

      final response = await http.get(Uri.https(authority, path, queryParameters));

      if(response.statusCode != 200)
      {
        throw Exception();
      }

      final List<dynamic> matchedAdresses = jsonDecode(response.body)['result']['addressMatches'];

      if(matchedAdresses.isEmpty)
      {
        throw NoAddressesFoundException();
      }
      
      List<HouseLocation> houseLocations = [];

      // Each element will be an address match, so a Map<String, Object>
      matchedAdresses.forEach((element) {
        houseLocations.add(HouseLocation.fromEntity(HouseLocationEntity.fromJson(element)));
      });

      return houseLocations;
    }
    on Exception catch(exception)
    {
      print('$exception was thrown because there was no addresses obtained from the query.');
      throw NoAddressesFoundException();
    }
    
  }


  Future<UserLocationEntity> _getCurrentLocation(String id) async {
    final permission = await _location.requestPermission();
    
    var service = await _location.serviceEnabled();


    // If location is disabled, request it.
    if (service == false) {
      service = await _location.requestService();
    }

    if (permission == PermissionStatus.granted && service == true) {
      LocationData locationData = await _location.getLocation();

      return UserLocationEntity(
        id,
        GeoPoint(locationData.latitude, locationData.longitude),
        Timestamp.now(),
      );
    } else {
      throw PermissionDeniedException();
    }
  }

  Future<void> recordUserLocation(String id) async {
    try {
      final userData = await _getCurrentLocation(id);

      final docRef = _firestore
          .collection('location')
          .doc('Home')
          .collection('locations')
          .doc(userData.id);

      docRef.get().then((snapshot) {
        if (snapshot.exists) {
          docRef.update({
            "location": userData.location,
            "lastKnownTime": userData.recordedTime,
          });
        } else {
          docRef.set({
            "location": userData.location,
            "lastKnownTime": userData.recordedTime,
          });
        }
      });
    } on Exception {
      print('Failed to retreive current location.');
    }
  }
}
