import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:map_repository/map_repository.dart';
import 'package:map_repository/src/entities/user_location_entity.dart';

class PermissionDeniedException implements Exception {}

class MapRepository {
  final Location _location;

  final FirebaseFirestore _firestore;

  MapRepository()
      : this._firestore = FirebaseFirestore.instance,
        this._location = Location.instance;

  Future<UserLocationEntity> _getCurrentLocation() async {
    var permission = await _location.requestPermission();
    var service = await _location.serviceEnabled();

    // If location is disabled, request it.
    if (service == false) {
      service = await _location.requestService();
    }

    if (permission == PermissionStatus.granted && service == true) {
      LocationData locationData = await _location.getLocation();

      return UserLocationEntity(
        'gregfreitas1997@gmail.com',
        GeoPoint(locationData.latitude, locationData.longitude),
        Timestamp.now(),
      );
    } else {
      throw PermissionDeniedException();
    }
  }

  Future<void> recordUserLocation() async {
    try {
      var userData = await _getCurrentLocation();

      var docRef = _firestore
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

  Future<List<geo.Location>> getHomeLocation(String address) async {
    List<geo.Location> locations = await geo.locationFromAddress(address);

    // Iterate over locations
    // creating a new List
    List<HouseLocation> houses;

    for (int i = 0; i < locations.length; i++) {
      GeoPoint data = GeoPoint(locations[i].latitude, locations[i].longitude);
      //id, address, Geopoint
      houses.add(HouseLocation('Random', address, data));
    }

    return locations;
  }
}
