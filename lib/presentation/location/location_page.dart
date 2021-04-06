import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:map_repository/map_repository.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:roomiesMobile/business_logic/authentication/authentication.dart';
import 'package:roomiesMobile/business_logic/landing/cubit/landing_cubit.dart';
import 'package:roomiesMobile/business_logic/location/bloc/location_bloc.dart';

class LocationPage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute(builder: (_) => LocationPage());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LocationBloc>(
        create: (context) => LocationBloc(mapRepository: MapRepository(houseName: context.read<LandingCubit>().state.home)),
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
                          height: 500,
                          width: 300,
                          child: _MyMapState(),
                        ),
                        ElevatedButton(
                            onPressed: () {
                              context.read<LocationBloc>().add(
                                  GetUserLocation(context
                                      .read<AuthenticationBloc>()
                                      .state
                                      .user
                                      .email));
                              
                            },
                            child: Text('Check In Location')),
                            // This will have a side scroll view of the roomate logos to get the location of each last known and animate to it in the map
                            //
                        Container(
                          width: 300,
                          height: 50,
                          color: Colors.white,
                          // Each thing built will be an icon/logo for the roomates. Clicking will zoom on the last known location of them.
                          // Need to have access to those locations or query it again.
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, i) {
                              return Container(
                                child: Center(child: Text('$i'),),
                                color: Colors.red,
                              );
                
                            },
                          )                      
                        )
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
  //final List<Marker> myMarker = <Marker>[];
  List<Marker> myMarker = [];
  GoogleMapController controller;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LocationBloc, LocationState>(
        listener: (context, state) {},
        builder: (context, state) {
          
          print(state.toString());

          if (state is SuccessfulToGetLocations) {
            state.locations.forEach((element) {
              myMarker.add(Marker(
                markerId: MarkerId(element.address.toString()),
                position:
                    LatLng(element.longLat.latitude, element.longLat.longitude),
                icon: BitmapDescriptor.defaultMarker,
                onTap: (){
                  print('This should zoom in to the place and then show button to set the house address.');
                },
              ));
            });
          }
          else if(state is LoadingLocations)
          {
            return Center(child: CircularProgressIndicator(),);
          }
          else if(state is SuccessfulToGetRoomates)
          {
            print('Update?');
              state.locations.forEach((element) {

              final Marker newMarker = Marker(
                markerId: MarkerId(element.id.toString()),
                position:
                    LatLng(element.location.latitude, element.location.longitude),
                icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
                onTap: (){
                  print('This should zoom in to the place and then show button to set the house address.');
                },
              );

              if(!myMarker.contains(newMarker))
              {
                myMarker.add(newMarker);
              }
              else
              {
                print('Already contain that marker.');
              }

            });
          }
          else if(state is FailedToGetLocations)
          {
            return Center(child: Text('Why no work.'),);
          }

          print(Set.from(myMarker));

          return GoogleMap(
              mapType: MapType.normal,
            initialCameraPosition: const CameraPosition(
                target: const LatLng(39.5, -98.35), zoom: 3),
            markers: Set<Marker>.from(myMarker),
            myLocationEnabled: false,
            myLocationButtonEnabled: true,
            onMapCreated: (mapController) async {
              controller = mapController;

              await Future.delayed(Duration(milliseconds: 200));

              //await controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: point, zoom: 6)));
            },
          );
        });
  }
}
