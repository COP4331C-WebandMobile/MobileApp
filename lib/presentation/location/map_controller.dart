import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapController
{
  
  Completer<GoogleMapController> controller = Completer();

  MapController(this.controller);


  Future<void> moveCameraTo(double latitude, double longitude, double zoomAmount) async
  {
    final GoogleMapController myController = await controller.future;

    final LatLng newPosition = LatLng(latitude, longitude);

    final CameraPosition newCameraPosition = CameraPosition(target: newPosition, zoom: zoomAmount);

    myController.animateCamera(CameraUpdate.newCameraPosition(newCameraPosition));
  }

} 