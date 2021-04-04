part of 'landing_cubit.dart';

enum HomeStatus {HomeVerified,Loading,Homeless,Error}

class LandingState extends Equatable {

  final status; 
  final String home; 
  final error; 
  
  @override
  List<Object> get props => [status,home,error];

  const LandingState._({
  this.status = HomeStatus.Loading,
  this.home = "",
  this.error ="",
  });
  const LandingState.loading() : this._();

  const LandingState.homeVerified(String home) : this._(status: HomeStatus.HomeVerified, home: home);

  const LandingState.homeless() : this._(status: HomeStatus.Homeless);

  const LandingState.error(String errMsg) : this._(status: HomeStatus.Error,error:errMsg );
}
