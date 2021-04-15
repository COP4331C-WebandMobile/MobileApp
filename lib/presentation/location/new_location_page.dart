import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_repository/map_repository.dart';
import 'package:roomate_repository/roomate_repository.dart';
import 'package:roomiesMobile/business_logic/landing/cubit/landing_cubit.dart';
import 'package:roomiesMobile/business_logic/location/user_location/user_location_bloc.dart';
import 'package:roomiesMobile/business_logic/roomates/cubit/roomates_cubit.dart';
import 'package:roomiesMobile/widgets/home/sidebar.dart';

class NewLocationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String houseName = context.read<LandingCubit>().state.home;
    final MapRepository mapRepository = MapRepository(houseName: houseName);

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => UserLocationBloc(mapRepository: mapRepository),
        ),
      ],
      child: _LocationPageWrapper(),
    );
  }
}

class _LocationPageWrapper extends StatelessWidget {
  final Completer<GoogleMapController> _controller = Completer();

  Future<void> moveCameraTo(
      double latitude, double longitude, double zoomAmount) async {
    final GoogleMapController myController = await _controller.future;

    final LatLng newPosition = LatLng(latitude, longitude);

    final CameraPosition newCameraPosition =
        CameraPosition(target: newPosition, zoom: zoomAmount);

    myController
        .animateCamera(CameraUpdate.newCameraPosition(newCameraPosition));
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController addressController = TextEditingController();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Location'),
      ),  drawer: SideBar(),
      body: Container(
        padding: EdgeInsets.all(32),
        child: Center(
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: TextField(
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(),
                  ),
                  controller: addressController,
                  onSubmitted: (value) {},
                ),
              ),
              Expanded(
                flex: 8,
                child: 
            GoogleMap(
              mapType: MapType.normal,
            initialCameraPosition: const CameraPosition(
                target: const LatLng(39.5, -98.35), zoom: 3),
            myLocationEnabled: false,
            myLocationButtonEnabled: true,
            onMapCreated: (mapController) async {
              _controller.complete(mapController);
            },
          ),
              ),
          Expanded(
            flex: 0,
            child: ElevatedButton(
              child: Text('Press me'),
              onPressed: (){},
            ),
          ),
          Expanded(
            child: RoomateList(),
          ),
              ],
          ),
        ),
      ),
    );
  }
}

class RoomateList extends StatelessWidget {

  
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserLocationBloc, UserLocationState>(
      builder: (context, state) {
        
        if(state is SuccessfulOnRetrievedLocations)
        {
          
          return ListView.separated(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: state.locations.length,
            separatorBuilder: (context, i) {
              return const SizedBox(width: 16,);
            },
            itemBuilder: (context, i) {
              return RoomateButton(state.locations[i]);
            },
          );
        }
        

        return Container();
      },
    );
  }
}

class RoomateButton extends StatelessWidget
{
  final UserLocation userLocation;
  

  RoomateButton(this.userLocation);

  @override
  Widget build(BuildContext context) 
  {
    final Roomate roomate = context.read<RoomatesCubit>().state.roomates.firstWhere((element) => element.email == userLocation.id);

    return Container(
      child: Column(
        children: <Widget>[
          Expanded(child:
          IconButton(
            icon: Icon(Icons.supervised_user_circle_sharp),
            onPressed: () async { },
          )),
          Expanded(child:
          Text('${roomate.firstName} ${roomate.lastName}')),
        ],
      ),
      
    );

  }
}