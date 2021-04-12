part of 'user_location_bloc.dart';

abstract class UserLocationEvent extends Equatable {
  const UserLocationEvent();

  @override
  List<Object> get props => [];
}

class CheckInUserLocation extends UserLocationEvent 
{
  final String id;

  const CheckInUserLocation(this.id);

  @override
  List<Object> get props => [id];  
}

class GetRoomateLocations extends UserLocationEvent
{
  final List<UserLocation> roomateLocations;

  const GetRoomateLocations(this.roomateLocations);

  @override
  List<Object> get props => [roomateLocations];
}




