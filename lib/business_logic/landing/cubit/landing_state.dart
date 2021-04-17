part of 'landing_cubit.dart';

enum HomeStatus {HomeVerified,Loading,Homeless,Error}

class LandingState extends Equatable {

  final status; 
  final String home; 
  final String address;
  final error; 
  
  @override
  List<Object> get props => [status,home,error,address];

  const LandingState._({
  this.status = HomeStatus.Loading,
  this.home = "",
  this.error ="",
  this.address ="",
  });
  
  const LandingState.loading() : this._(status: HomeStatus.Loading);

  LandingState.homeVerified(String homeName,String address) : this._(status: HomeStatus.HomeVerified, home: homeName, address: address);

  const LandingState.homeless() : this._(status: HomeStatus.Homeless);

  const LandingState.error(String errMsg) : this._(status: HomeStatus.Error,error:errMsg );
}
