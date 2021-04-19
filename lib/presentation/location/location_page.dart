import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_repository/map_repository.dart';
import 'package:roomate_repository/roomate_repository.dart';
import 'package:roomiesMobile/business_logic/authentication/authentication.dart';
import 'package:roomiesMobile/business_logic/landing/cubit/landing_cubit.dart';
import 'package:roomiesMobile/business_logic/location/location.dart';
import 'package:roomiesMobile/business_logic/roomates/cubit/roomates_cubit.dart';
import 'package:roomiesMobile/presentation/themes/primary_theme/colors.dart';
import 'package:roomiesMobile/widgets/home/sidebar.dart';

class NewLocationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String houseName = context.read<LandingCubit>().state.home;
    final MapRepository mapRepository = MapRepository(houseName: houseName);
    final Completer<GoogleMapController> _controller = Completer();

    return MultiBlocProvider(
      providers: [
        BlocProvider<UserLocationBloc>(
          create: (context) => UserLocationBloc(mapRepository: mapRepository),
        ),
        BlocProvider<AddressLocationBloc>(
          create: (context) =>
              AddressLocationBloc(mapRepository: mapRepository),
        ),
        BlocProvider(
          create: (context) => GoogleMapCubit(controller: _controller),
        ),
      ],
      child: _NewLocationPageWrapper(_controller),
    );
  }
}

class _NewLocationPageWrapper extends StatelessWidget {
  final Completer<GoogleMapController> _controller;

  const _NewLocationPageWrapper(this._controller);

  @override
  Widget build(BuildContext context) {
    final TextEditingController addressController = TextEditingController();

    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: const Text('Location'),
        ),
        body: Row(
          children: [
            Expanded(
                flex: 3,
                child: Padding(
                    padding: EdgeInsets.only(top: 32, left: 8),
                    child: Column(
                      children: [
                        Expanded(
                          child: Container(
                              margin: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.shade700,
                                    offset: Offset(0.0, 3.0),
                                    blurRadius: 6.0,
                                  )
                                ],
                                color: CustomColors.gold,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16)),
                              ),
                              child: Column(
                                children: [
                                  BlocBuilder<GoogleMapCubit, GoogleMapState>(
                                      buildWhen: (previous, current) =>
                                          previous.markers != current.markers,
                                      builder: (context, mapState) {
                                        return BlocConsumer<AddressLocationBloc,
                                                AddressLocationState>(
                                            listener: (context, state) {
                                          if (state
                                              is SuccessfullyRetreievedAddresses) {
                                            state.houseLocations
                                                .forEach((element) {
                                              context
                                                  .read<GoogleMapCubit>()
                                                  .addAddressMarker(
                                                    element.address,
                                                    element.longLat.latitude,
                                                    element.longLat.longitude,
                                                  );
                                            });
                                          }

                                          if (state is HomeAddressUpdated) {
                                            print('Working???');
                                            context
                                                .read<GoogleMapCubit>()
                                                .setHomeMarker(
                                                  state.houseLocation.longLat
                                                      .longitude,
                                                  state.houseLocation.longLat
                                                      .latitude,
                                                  state.houseLocation.address,
                                                );
                                          }
                                        }, builder: (context, state) {
                                          Set<Marker> myMarkers =
                                              mapState.markers.toSet();

                                          return Expanded(
                                            flex: 5,
                                            child: Container(
                                                decoration: BoxDecoration(
                                                  //border: Border.all(),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(16)),
                                                ),
                                                margin: EdgeInsets.all(8),
                                                child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                16)),
                                                    child: GoogleMap(
                                                      markers: myMarkers,
                                                      mapType: MapType.normal,
                                                      initialCameraPosition:
                                                          const CameraPosition(
                                                              target:
                                                                  const LatLng(
                                                                      39.5,
                                                                      -98.35),
                                                              zoom: 3),
                                                      myLocationEnabled: false,
                                                      myLocationButtonEnabled:
                                                          true,
                                                      onMapCreated:
                                                          (mapController) async {
                                                        _controller.complete(
                                                            mapController);
                                                      },
                                                    ))),
                                          );
                                        });
                                      }),
                                  Expanded(
                                    child: Container(
                                      margin: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.shade700,
                                              offset: Offset(0.0, 3.0),
                                              blurRadius: 6.0,
                                            )
                                          ],
                                          color: CustomColors.gold,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(16))),
                                      child: Column(
                                        children: [
                                          Expanded(
                                              child: const Text(
                                                  'Address Search',
                                                  style: TextStyle())),
                                          Expanded(
                                              flex: 3,
                                              child: BlocBuilder<
                                                      AddressLocationBloc,
                                                      AddressLocationState>(
                                                  builder: (context, state) {
                                                return Container(
                                                  margin: EdgeInsets.all(8),
                                                  child: TextField(
                                                      controller:
                                                          addressController,
                                                      decoration: InputDecoration(
                                                          fillColor:
                                                              Colors.white,
                                                          filled: true,
                                                          border:
                                                              OutlineInputBorder())),
                                                );
                                              })),
                                          Expanded(
                                            flex: 2,
                                            child:
                                                FloatingActionButton.extended(
                                              label: const Text('Search'),
                                              onPressed: () {
                                                print('WORK');
                                                print(addressController.text);
                                                context
                                                    .read<AddressLocationBloc>()
                                                    .add(QueryAddresses(
                                                        addressController
                                                            .text));
                                              },
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              )),
                        ),
                      ],
                    ))),
            Expanded(
              child: Padding(
                  padding: EdgeInsets.only(right: 32, top: 32),
                  child: Column(
                    children: [
                      Flexible(
                          child: Column(children: [
                        Stack(
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height / 1.49,
                              margin: EdgeInsets.only(top: 20),
                              padding: EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 8),
                              decoration: BoxDecoration(
                                border: Border.all(),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.shade700,
                                    offset: Offset(0.0, 3.0),
                                    blurRadius: 6.0,
                                  )
                                ],
                                color: CustomColors.gold,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(32)),
                              ),
                              child: RoomateList(),
                            ),
                            Container(
                                alignment: Alignment.topCenter,
                                child: Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.shade700,
                                        offset: Offset(0.0, 3.0),
                                        blurRadius: 6.0,
                                      )
                                    ],
                                    color: Colors.black,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(16)),
                                  ),
                                  child: const Text('Roomates',
                                      style: TextStyle(
                                        color: Colors.white,
                                      )),
                                )),
                          ],
                        ),
                        Container(
                          height: 90,
                          width: 150,
                          margin: EdgeInsets.only(top: 32),
                          child: FloatingActionButton.extended(
                            shape: CircleBorder(),
                            tooltip:
                                'Record your current location for other roomates to view.',
                            heroTag: null,
                            label: const Text('Check In'),
                            onPressed: () {
                              final String id = context
                                  .read<AuthenticationBloc>()
                                  .state
                                  .user
                                  .email;

                              context
                                  .read<UserLocationBloc>()
                                  .add(CheckInUserLocation(id));
                            },
                          ),
                        ),
                      ])),
                    ],
                  )),
            )
          ],
        ));
  }
}

class _LocationPageWrapper extends StatelessWidget {
  final Completer<GoogleMapController> _controller;

  const _LocationPageWrapper(this._controller);

  @override
  Widget build(BuildContext context) {
    final TextEditingController addressController = TextEditingController();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Location'),
      ),
      body: BlocBuilder<GoogleMapCubit, GoogleMapState>(
        buildWhen: (previous, current) => previous.markers != current.markers,
        builder: (context, googleState) {
          return BlocConsumer<AddressLocationBloc, AddressLocationState>(
            listener: (context, addressState) {
              if (addressState is SuccessfullyRetreievedAddresses) {
                addressState.houseLocations.forEach((element) {
                  context.read<GoogleMapCubit>().addAddressMarker(
                      element.address,
                      element.longLat.latitude,
                      element.longLat.longitude, onTap: () {
                    context
                        .read<AddressLocationBloc>()
                        .add(SetHomeAddress(element));
                  });
                });
              }

              if (addressState is HomeAddressUpdated) {
                print(addressState.houseLocation.longLat);

                context.read<GoogleMapCubit>().setHomeMarker(
                    addressState.houseLocation.longLat.longitude,
                    addressState.houseLocation.longLat.latitude,
                    addressState.houseLocation.address);
              }
            },
            builder: (context, addressState) {
              Set<Marker> myMarkers = googleState.markers.toSet();

              return Container(
                padding: EdgeInsets.all(32),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    //   Expanded(
                    //     child: RoomateList(),
                    //   ),
                    Flexible(
                      flex: 5,
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: TextField(
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10),
                                fillColor: Colors.white,
                                filled: true,
                                border: OutlineInputBorder(),
                              ),
                              controller: addressController,
                              onSubmitted: (value) {
                                context
                                    .read<AddressLocationBloc>()
                                    .add(QueryAddresses(value));
                              },
                            ),
                          ),
                          Expanded(
                            flex: 8,
                            child: GoogleMap(
                              mapType: MapType.normal,
                              markers: myMarkers,
                              initialCameraPosition: const CameraPosition(
                                  target: const LatLng(39.5, -98.35), zoom: 3),
                              myLocationEnabled: false,
                              myLocationButtonEnabled: true,
                              onMapCreated: (mapController) async {
                                _controller.complete(mapController);
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Expanded(
                            flex: 0,
                            child: FloatingActionButton.extended(
                              tooltip:
                                  'Record your current location for other roomates to view.',
                              heroTag: null,
                              label: const Text('Check In'),
                              onPressed: () {
                                final String id = context
                                    .read<AuthenticationBloc>()
                                    .state
                                    .user
                                    .email;

                                context
                                    .read<UserLocationBloc>()
                                    .add(CheckInUserLocation(id));
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                        child: Container(
                            color: Colors.red,
                            child: Flexible(child: RoomateList()))),
                  ],
                ),
              );
            },
          );
        },
      ),
      drawer: SideBar(),
    );
  }
}

class RoomateList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserLocationBloc, UserLocationState>(
      builder: (context, state) {
        if (state is SuccessfulOnRetrievedLocations) {
          return ListView.separated(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: state.locations.length,
            separatorBuilder: (context, i) {
              return const SizedBox(
                height: 8,
              );
            },
            itemBuilder: (context, i) {
              context.read<GoogleMapCubit>().addRoomateMarker(
                    state.locations[i].id,
                    state.locations[i].location.longitude,
                    state.locations[i].location.latitude,
                    state.locations[i].recordedTime.toDate(),
                  );

              return RoomateButton(state.locations[i]);
            },
          );
        }

        return Container();
      },
    );
  }
}

class RoomateButton extends StatelessWidget {
  final UserLocation userLocation;

  RoomateButton(this.userLocation);

  @override
  Widget build(BuildContext context) {
    final Roomate roomate = context
        .read<RoomatesCubit>()
        .state
        .roomates
        .firstWhere((element) => element.email == userLocation.id);

    return Container(
        child: Center(
      child: CircleAvatar(
        radius: 32,
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        child: Column(
          children: [
            Expanded(
                child: IconButton(
              splashColor: Colors.yellow.shade300,
              icon: Icon(
                Icons.person,
                size: 32,
              ),
              onPressed: () async {
                await context.read<GoogleMapCubit>().moveCameraTo(
                    userLocation.location.latitude,
                    userLocation.location.longitude);

                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(SnackBar(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    duration: Duration(seconds: 1, milliseconds: 250),
                    backgroundColor: Colors.black,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.all(Radius.elliptical(5, 5))),
                    content: Text(
                      'Moving to ${roomate.firstName} ${roomate.lastName}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: CustomColors.gold,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ));
              },
            )),
            Expanded(
                flex: 1,
                child: Container(
                    margin: EdgeInsets.only(top: 8),
                    child: Text(
                      '${roomate.firstName[0]}.${roomate.lastName[0]}',
                      style: TextStyle(fontSize: 12),
                    ))),
          ],
        ),
      ),
    ));
  }
}
