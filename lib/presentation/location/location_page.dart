import 'package:flutter/material.dart';
import 'package:map_repository/map_repository.dart';


class LocationPage extends StatelessWidget {

  static Route route() {
    return MaterialPageRoute(builder: (_) => LocationPage());
  }


  @override
  Widget build(BuildContext context) {
    
    final mapRepo = MapRepository();


    return Container(
      child: ElevatedButton(
        onPressed: () {mapRepo.recordUserLocation();},
        child: Text('Press me'),
      ),
    );

  }

}
