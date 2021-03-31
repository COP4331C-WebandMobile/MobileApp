import 'package:flutter/material.dart';
import 'package:map_repository/map_repository.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationPage extends StatelessWidget {

  static Route route() {
    return MaterialPageRoute(builder: (_) => LocationPage());
  }


  @override
  Widget build(BuildContext context) {
    
    final mapRepo = MapRepository();

    
    
    return Scaffold(
      body: Padding (
        padding: EdgeInsets.only(bottom: 128, top: 128,right: 64, left: 64),
        child:  GoogleMap(
        myLocationButtonEnabled: true,
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
          bearing: 192.8334901395799,
          target: LatLng(28.3886683, -81.3926717),
          tilt: 59.440717697143555,
          zoom: 19.151926040649414
        ),
      ),
      ),

    
    );

  }

}
