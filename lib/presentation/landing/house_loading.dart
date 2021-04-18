import 'package:roomate_repository/roomate_repository.dart';
import 'package:roomiesMobile/business_logic/roomates/cubit/roomates_cubit.dart';
import 'package:roomiesMobile/presentation/home/home_page.dart';
import 'package:roomiesMobile/presentation/landing/landing_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roomiesMobile/presentation/splash_page.dart';
import '../../business_logic/authentication/authentication.dart';
import 'package:home_repository/home_repository.dart';
import '../../business_logic/landing/cubit/landing_cubit.dart';

class HouseLoading extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute(builder: (_) => HouseLoading());
  }

  @override
  Widget build(BuildContext context) {
    return 
    BlocProvider<LandingCubit>(
      create: (context) => LandingCubit(
          homeRepository: HomeRepository(
              context.read<AuthenticationBloc>().state.user.email)),
      child: HouseLoadingWrapper(),
    );
  }
}

class HouseLoadingWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<LandingCubit, LandingState>(
      listener: (context, state) {
        print(state);
        if (state.status == HomeStatus.HomeVerified) {
          final _roomateRepository = RoomateRepository(state.home);
          Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => MultiBlocProvider(providers: [
                    BlocProvider<LandingCubit>.value(
                        value: BlocProvider.of<LandingCubit>(context)),
                    BlocProvider<RoomatesCubit>(
                        create: (context) => RoomatesCubit(
                            roomateRepository: _roomateRepository))
                  ], child: HomePage())),);
        }
        else if (state.status == HomeStatus.Homeless) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => BlocProvider<LandingCubit>.value(
                    value: BlocProvider.of<LandingCubit>(context),
                    child: LandingPage())),
          );
        }
      },
      child: Container(alignment: Alignment.center,color: Colors.white, child: CircularProgressIndicator(),),
    );
  }
}
