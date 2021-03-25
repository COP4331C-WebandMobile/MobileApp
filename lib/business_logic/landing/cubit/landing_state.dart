part of 'landing_cubit.dart';

enum status {HomeVerified, Loading, Homeless}

class LandingState extends Equatable {

  final String home; 
  const LandingState(this.home);
  @override
  List<Object> get props => [home];
}
