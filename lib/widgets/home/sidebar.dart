import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roomiesMobile/business_logic/landing/cubit/landing_cubit.dart';
import 'package:roomiesMobile/business_logic/roomates/cubit/roomates_cubit.dart';
import 'package:roomiesMobile/presentation/chores/chore_page.dart';
import 'package:roomiesMobile/presentation/home/home_page.dart';
import 'package:roomiesMobile/presentation/location/location_page.dart';
import 'package:roomiesMobile/presentation/messaging/messages_page.dart';
import 'package:roomiesMobile/presentation/settings/settings_page.dart';
import 'package:roomiesMobile/presentation/themes/primary_theme/colors.dart';
import '../../business_logic/authentication/authentication.dart';
import '../../business_logic/authentication/bloc/authentication_bloc.dart';

class SideBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Container(
            color: Colors.black,
            child: Column(children: <Widget>[
              Expanded(
                  flex: 4,
                  child: DrawerHeader(
                    child: Text('Roomies',
                        style: TextStyle(
                          fontSize: 60,
                          color: CustomColors.gold,
                        )),
                    decoration: BoxDecoration(
                      color: Colors.black,
                    ),
                  )),
              Expanded(
                  flex: 8,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ListTile(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: Colors.white,
                            width: 4,
                          ),
                        ),
                        title: Text('Home',
                            style: TextStyle(
                              fontSize: 30,
                              color: Colors.white,
                            )),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => MultiBlocProvider(providers: [
                                        BlocProvider<LandingCubit>.value(
                                          value: BlocProvider.of<LandingCubit>(
                                              context),
                                        ),
                                        BlocProvider<RoomatesCubit>.value(
                                          value: BlocProvider.of<RoomatesCubit>(
                                              context),
                                        )
                                      ], child: HomePage())));
                        },
                      ),
                      ListTile(
                        title: Text('Messages',
                            style: TextStyle(
                              fontSize: 30,
                              color: Colors.white,
                            )),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => MultiBlocProvider(providers: [
                                        BlocProvider<LandingCubit>.value(
                                          value: BlocProvider.of<LandingCubit>(
                                              context),
                                        ),
                                        BlocProvider<RoomatesCubit>.value(
                                          value: BlocProvider.of<RoomatesCubit>(
                                              context),
                                        )
                                      ], child: TestMessagePage())));
                        },
                      ),
                      ListTile(
                        title: Text('Chores',
                            style: TextStyle(
                              fontSize: 30,
                              color: Colors.white,
                            )),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => MultiBlocProvider(providers: [
                                        BlocProvider<LandingCubit>.value(
                                          value: BlocProvider.of<LandingCubit>(
                                              context),
                                        ),
                                        BlocProvider<RoomatesCubit>.value(
                                          value: BlocProvider.of<RoomatesCubit>(
                                              context),
                                        )
                                      ], child: ChoresPage())));
                        },
                      ),
                      ListTile(
                        title: Text('Locations',
                            style: TextStyle(
                              fontSize: 30,
                              color: Colors.white,
                            )),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => MultiBlocProvider(providers: [
                                        BlocProvider<LandingCubit>.value(
                                          value: BlocProvider.of<LandingCubit>(
                                              context),
                                        ),
                                        BlocProvider<RoomatesCubit>.value(
                                          value: BlocProvider.of<RoomatesCubit>(
                                              context),
                                        )
                                      ], child: NewLocationPage())));
                        },
                      ),
                      ListTile(
                        enableFeedback: true,
                        title: Text('Settings',
                            style: TextStyle(
                              fontSize: 30,
                              color: Colors.white,
                            )),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => MultiBlocProvider(providers: [
                                        BlocProvider<LandingCubit>.value(
                                          value: BlocProvider.of<LandingCubit>(
                                              context),
                                        ),
                                        BlocProvider<RoomatesCubit>.value(
                                          value: BlocProvider.of<RoomatesCubit>(
                                              context),
                                        )
                                      ], child: SettingsPage())));
                        },
                      ),
                    ],
                  )),
              Expanded(
                flex: 1,
                child: ElevatedButton(
                  onPressed: () => context
                      .read<AuthenticationBloc>()
                      .add(AuthenticationLogoutRequested()),
                  child: Text("Logout", style: TextStyle(fontSize: 32)),
                ),
              )
            ])));
  }
}
