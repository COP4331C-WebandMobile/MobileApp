part of 'roomates_cubit.dart';

enum status {loaded, loading}

class RoomatesState{

  final List<Roomate> roomates;
  final status; 

  RoomatesState(this.roomates,this.status);
  @override
  List<Object> get props => [roomates,status];
}

//const LandingState.loading() : this._();

//const LandingState.homeVerified(String home) : this._(status: HomeStatus.HomeVerified, home: home);

//const LandingState.homeless() : this._(status: HomeStatus.Homeless);