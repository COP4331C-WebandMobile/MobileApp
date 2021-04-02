import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:map_repository/map_repository.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:roomiesMobile/business_logic/location/bloc/location_bloc.dart';

class LocationPage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute(builder: (_) => LocationPage());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LocationBloc>(
      create: (context) => LocationBloc(mapRepository: MapRepository()),
      child: Scaffold (
        body:  BlocConsumer<LocationBloc, LocationState>(
        builder: (context, state) {
          if(state is SuccessfullyRetreivedLocations)
          {
            // Need to build a display here that shows a view of the locations obtained that should be the current house.
            // Im planning to build a page that has the google map sort offset to the left with search results on the right as a list view.
            // Then by tapping the tile you set that location as the house address. Later we can target who can set the address or whatever, but for now keeping it simple.
            return Center(child: Text('I got the locations!'));
            
          }
          else if(state is FailedToRetreiveLocations)
          {
            // Error page when results are not found.
            return Center(child: Text('Failed to find any results, try being more specific'));
          }
          else if(state is LoadingLocations)
          {
            // Loading.
            return Center(child: CircularProgressIndicator(),);
          }
          return Center(child: ElevatedButton(onPressed: (){context.read<LocationBloc>().add(QueryAdresses('1259 Welson Rd'));}, child: Text('Get Addresses'),),);
        },
        listener: (context, event) {
          
        })));
  } }