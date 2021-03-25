part of 'landing_cubit.dart';

enum HomeStatus {HomeVerified, Loading, Homeless}

class LandingState extends Equatable {

  final status; 
  final String home; 
  
  @override
  List<Object> get props => [status];

  const LandingState._({
  this.status = HomeStatus.Loading,
  this.home = "",
  });
  const LandingState.loading() : this._();

  const LandingState.homeVerified(String home) : this._(status: HomeStatus.HomeVerified, home: home);

  const LandingState.homeless() : this._(status: HomeStatus.Homeless);
}
