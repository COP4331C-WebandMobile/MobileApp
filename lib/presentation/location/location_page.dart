import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:map_repository/map_repository.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:roomiesMobile/business_logic/authentication/authentication.dart';
import 'package:roomiesMobile/business_logic/location/bloc/location_bloc.dart';

class LocationPage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute(builder: (_) => LocationPage());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LocationBloc>(
        create: (context) => LocationBloc(mapRepository: MapRepository()),
        child: MyWrapper());
  }
}

class MyWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text('Location'),
        ),
        body: Container(
            padding: EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // This is our google map and textfield
                    Column(
                      children: [
                        SizedBox(
                          height: 50,
                          width: 300,
                          child: TextField(
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              fillColor: Colors.white,
                              filled: true,
                              border: OutlineInputBorder(),
                            ),
                            controller: controller,
                            onSubmitted: (value) {
                              context
                                  .read<LocationBloc>()
                                  .add(QueryAdresses(value));
                            },
                          ),
                        ),
                        SizedBox(
                          height: 550,
                          width: 300,
                          child: _MyMapState(),
                        ),
                        ElevatedButton(
                            onPressed: () {
                              context.read<LocationBloc>().add(
                                  RetreieveUserLocation(context
                                      .read<AuthenticationBloc>()
                                      .state
                                      .user
                                      .email));
                            },
                            child: Text('Check In Location')),
                      ],
                    )
                  ],
                )
              ],
            )));
  }
}

// class MyMap extends StatefulWidget {
//   @override
//   _MyMapState createState() => _MyMapState();
// }

class _MyMapState extends StatelessWidget {
  List<Marker> myMarker = [Marker(markerId: MarkerId('New'), position: LatLng(45,45))];
  GoogleMapController controller;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LocationBloc, LocationState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is SuccessfullyRetreivedLocations) {
            // int i = 0;
            // state.locations.forEach((element) {
            //   i++;
            //   myMarker.add(Marker(
            //     markerId: MarkerId(i.toString()),

            //     position:
            //         LatLng(element.longLat.latitude, element.longLat.longitude),
            //   ));
            // });

            print(Set.from(myMarker));

            return GoogleMap(
              mapType: MapType.hybrid,
            initialCameraPosition: const CameraPosition(
                target: const LatLng(39.5, -98.35), zoom: 3),
            markers: Set<Marker>.from(myMarker),
            myLocationEnabled: false,
            myLocationButtonEnabled: true,
          );
          }

          return Container(child: Text('Wtf'),);
        });
  }
}
