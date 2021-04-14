
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:map_repository/map_repository.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:roomiesMobile/business_logic/authentication/authentication.dart';
import 'package:roomiesMobile/business_logic/landing/cubit/landing_cubit.dart';
import 'package:roomiesMobile/business_logic/location/OldBloc/location_bloc.dart';
import 'package:roomiesMobile/presentation/location/map_controller.dart';
import 'package:roomiesMobile/widgets/home/sidebar.dart';

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
  Completer<GoogleMapController> _controller = Completer();

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    final MapController temp = MapController(_controller);
    
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text('Location'),
        ),
        drawer: SideBar(),
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
                          height: 300,
                          width: 300,
                          child: MyMap(temp),                         
                        ),
                        // SizedBox(
                        //   height: 500,
                        //   width: 300,
                        //   child: _MyMapState(),
                        // ),
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
                        SizedBox(
                          height: 100,
                          width: 200,
                          child:
                        BlocBuilder<LocationBloc, LocationState>(
                          builder: (context, state) {
                            
                            print(state);

                            if(state is SuccessfulToGetRoomates)
                            {
                              return Container(
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: state.locations.length,
                                  itemBuilder: (context, i) {
                                    final currentUser = state.locations[i];
                                    
                                    return Padding(
                                      padding: EdgeInsets.all(32),
                                      child: IconButton(
                                        icon: const Icon(
                                          Icons.supervised_user_circle_sharp,
                                        ),
                                        onPressed: () { temp.moveCameraTo(currentUser.location.latitude, currentUser.location.longitude, 5);},
                                      ),
                                    );
                                  },
                                ),
                              );
                            }
                            else if(state is FailedToGetLocations)
                            {

                            }
                            
                            return Center(child: Text('Nope'),);
                          },
                        )),
                      ],
                    )
                  ],
                )
              ],
            ))
            );
  }
}

class MapTest extends StatelessWidget
{
  final MapController test;

  MapTest(this.test);

  @override
  Widget build(BuildContext context) 
  {
    return GoogleMap(
      initialCameraPosition: const CameraPosition(target: LatLng(45, 50)),
      onMapCreated: (controller) {
        test.controller.complete(controller);
      },
      
      );

  }
}


class MyMap extends StatelessWidget {

  final MapController test;
  final List<Marker> myMarker = [];

  MyMap(this.test);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LocationBloc, LocationState>(
        listener: (context, state) {},
        builder: (context, state) {
          
          if (state is SuccessfulToGetLocations) {
            state.locations.forEach((element) {
              final Marker newMarker = Marker(
                markerId: MarkerId(element.address.toString()),
                position:
                    LatLng(element.longLat.latitude, element.longLat.longitude),
                icon: BitmapDescriptor.defaultMarker,
                onTap: (){
                  // Pop up dialog to ask if they want to set this address as the new house address.
                  context.read<LocationBloc>().add(SetAddress(element.longLat.longitude, element.longLat.latitude));
                },
              ); 

              myMarker.add(newMarker);
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
                infoWindow: InfoWindow(
                  title: element.id,
                  snippet: 'This is a test.',
                  onTap: (){ print('This could be used to send message to request location update.');},
                ),
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
            return Center(child: Text('Try to be more specific with the address.'),);
          }

          print(Set.from(myMarker));

          final address = context.read<LandingCubit>().state.address;
          
          // if(address != '')
          // {
          //   context.read<LocationBloc>().add(GetAddress());

          //   if(state is SuccessfullyGetAddress)
          //   {
          //     myMarker.add(Marker(
          //       markerId: MarkerId(
          //         'Current_Address',
          //       ),
          //       icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
          //       position: LatLng(state.latitude, state.longitude),
          //       infoWindow: InfoWindow(
          //         title: address,
          //         snippet: "The currently set house address.",
          //         onTap: (){},
          //       ),
          //     ));
          //   }
          // }

          return GoogleMap(
              mapType: MapType.normal,
            initialCameraPosition: const CameraPosition(
                target: const LatLng(39.5, -98.35), zoom: 3),
            markers: Set<Marker>.from(myMarker),
            myLocationEnabled: false,
            myLocationButtonEnabled: true,
            onMapCreated: (mapController) async {
              test.controller.complete(mapController);
            },
          );
        });
  }
}
