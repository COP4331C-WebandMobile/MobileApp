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
      body: Column(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width,
            child: GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition:  CameraPosition(target: LatLng(20, 30), zoom: 5),
            ),
          ),
          Center(child: ElevatedButton(onPressed: (){mapRepo.recordUserLocation();}, child: Text('Get Location'))),
        ],
      ),

  
      );      
  
  }

}
