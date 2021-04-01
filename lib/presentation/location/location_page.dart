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
<<<<<<< HEAD
      body: Padding (
        padding: EdgeInsets.only(bottom: 12, top: 12,right: 6, left: 6),
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
=======
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
>>>>>>> 99e970174e053c43b8bbbdc4646c3cbd87372440
      ),

  
      );      
  
  }

}
