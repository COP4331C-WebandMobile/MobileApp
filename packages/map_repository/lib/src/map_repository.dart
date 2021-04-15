import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';
import 'package:map_repository/map_repository.dart';
import 'package:map_repository/src/entities/user_location_entity.dart';
import 'package:http/http.dart' as http;

import 'entities/house_location_entity.dart';

class NoAddressesFoundException implements Exception {}

class PermissionDeniedException implements Exception {}

class InvalidHouseNameException implements Exception {}

class MapRepository {
  final Location _location;
  final FirebaseFirestore _firestore;
  CollectionReference locationCollection;
  final String houseName;

  MapRepository({String houseName, FirebaseFirestore firestore})
      : this._firestore = firestore ?? FirebaseFirestore.instance,
        this._location = Location.instance,
        this.houseName = houseName {
    try {
      locationCollection = FirebaseFirestore.instance
          .collection('location')
          .doc(houseName)
          .collection('locations');
    } on Exception {
      throw InvalidHouseNameException();
    }
  }

  Future<void> setAddressGeolocation(HouseLocation newLocation) async {
    try {
      await _firestore.collection('location').doc(houseName).get().then((snap) {
        if (snap.exists) {
          _firestore
              .collection('location')
              .doc(houseName)
              .update(newLocation.toEntity().toDocument());
        } else {
          _firestore
              .collection('location')
              .doc(houseName)
              .set(newLocation.toEntity().toDocument());
        }
      });
    } on Exception catch (e, stacktrace) {
      throw Exception();
    }
  }

  //TODO: THIS METHOD WILL BE DELETED SINCE USING A STREAM INSTEAD.
  Future<GeoPoint> getHomeGeoLocation() async {
    try {
      final snap = await _firestore.collection('location').doc(houseName).get();

      return snap.data()["addressGeo"];
    } on Exception catch (e, stacktrace) {
      throw Exception();
    }
  }

  Future<List<HouseLocation>> fetchAdresses(String inputText) async {
    try {
      final Map<String, String> queryParameters = {
        "format": 'json',
        "benchmark": 'Public_AR_Census2020',
        "address": inputText
      };
      const String path = '/geocoder/locations/onelineaddress';
      const String authority = 'geocoding.geo.census.gov';

      final response =
          await http.get(Uri.https(authority, path, queryParameters));

      if (response.statusCode != 200) {
        throw Exception();
      }

      final List<dynamic> matchedAdresses =
          jsonDecode(response.body)['result']['addressMatches'];

      if (matchedAdresses.isEmpty) {
        throw NoAddressesFoundException();
      }

      List<HouseLocation> houseLocations = [];

      // Each element will be an address match, so a Map<String, Object>
      matchedAdresses.forEach((element) {
        houseLocations.add(
            HouseLocation.fromEntity(HouseLocationEntity.fromJson(element)));
      });

      return houseLocations;
    } on Exception catch (exception) {
      print(
          '$exception was thrown because there was no addresses obtained from the query.');
      throw NoAddressesFoundException();
    }
  }

  Future<UserLocationEntity> _getCurrentLocation(String id) async {
    final permission = await _location.requestPermission();
    print("test");

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

  // Record a location.
  Future<void> recordUserLocation(String id) async {
    try {
      final userData = await _getCurrentLocation(id);
      print('House name is: $houseName');
      final docRef = _firestore
          .collection('location')
          .doc(houseName)
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

  // Get all the userlocations
  Stream<List<UserLocation>> userLocations() {
    return locationCollection.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) =>
              UserLocation.fromEntity(UserLocationEntity.fromSnapshot(doc)))
          .toList();
    });
  }

  Stream<HouseLocation> houseLocation() {
    return _firestore.collection('location').doc(houseName).snapshots().map((snapshot) => HouseLocation.fromEntity(HouseLocationEntity.fromSnapshot(snapshot)));
  }
}
