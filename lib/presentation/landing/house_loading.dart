import 'package:roomiesMobile/presentation/home/home_page.dart';
import 'package:roomiesMobile/presentation/landing/landing_page.dart';


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../business_logic/authentication/authentication.dart';
import 'package:home_repository/home_repository.dart';
import '../../business_logic/landing/cubit/landing_cubit.dart';


class HouseLoading extends StatelessWidget {
 
  static Route route() {
    return MaterialPageRoute(builder: (_) => HouseLoading());
  }
  @override
  Widget build(BuildContext context) {
  return BlocProvider(
    create: (context) => LandingCubit(homeRepository: HomeRepository(context.read<AuthenticationBloc>().state.user.email)),
    child:  BlocListener <LandingCubit,LandingState>( 
      listener: (context,state) {
        if(state.status == HomeStatus.Loading) { 
        }
        if(state.status==HomeStatus.HomeVerified) {
          Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => BlocProvider<LandingCubit>.value(
                          value: BlocProvider.of<LandingCubit>(context),
                          child: HomePage())),
              );
        }
       if(state.status==HomeStatus.Homeless) {
             Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => BlocProvider<LandingCubit>.value(
                          value: BlocProvider.of<LandingCubit>(context),
                          child: LandingPage())),
              );
        }  
    }));
  }
}

