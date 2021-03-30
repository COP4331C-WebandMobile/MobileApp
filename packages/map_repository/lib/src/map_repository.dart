import 'package:location/location.dart';

class PermissionDeniedException implements Exception {}


class MapRepository {

final Location _location;

MapRepository(this._location);

Future<LocationData> getCurrentLocation() async {

  var permission = await _location.requestPermission();
  var service = await _location.serviceEnabled();

  // If location is disabled, request it.
  if (service == false) {
    service = await _location.requestService();
  }

  
  if (permission == PermissionStatus.granted && service == true) {
    return await _location.getLocation();
  }
  else
  {
    throw PermissionDeniedException();
  }
}

}