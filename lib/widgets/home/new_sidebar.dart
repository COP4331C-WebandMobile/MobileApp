
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roomiesMobile/business_logic/authentication/authentication.dart';
import 'package:roomiesMobile/business_logic/landing/cubit/landing_cubit.dart';
import 'package:roomiesMobile/business_logic/roomates/cubit/roomates_cubit.dart';
import 'package:roomiesMobile/presentation/chores/chore_page.dart';
import 'package:roomiesMobile/presentation/home/home_page.dart';
import 'package:roomiesMobile/presentation/location/location_page.dart';
import 'package:roomiesMobile/presentation/messaging/messages_page.dart';
import 'package:roomiesMobile/presentation/settings/settings_page.dart';
import 'package:roomiesMobile/presentation/themes/primary_theme/colors.dart';
import 'package:roomiesMobile/widgets/home/drawer_tile.dart';

class NewSideBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final List<Map<String, dynamic>> _menuItem = [
      {
        "title": const Text('Home', style: TextStyle(color: Colors.black,),),
        "icon": Icons.house,
        "page": HomePage(),
        "selected": true,
      },
      {
        "title": const Text('Messages', style: TextStyle(color: Colors.black),),
        "icon": Icons.mail,
        "page": TestMessagePage(),
        "selected": true,
      },
      {
        "title": const Text('Chores', style: TextStyle(color: Colors.black),),
        "icon": Icons.flag,
        "page": ChoresPage(),
        "selected": true,
      },
      {
        "title": const Text('Locations', style: TextStyle(color: Colors.black),),
        "icon": Icons.location_history,
        "page": NewLocationPage(),
        "selected": true,
      },
      {
        "title": const Text('Settings', style: TextStyle(color: Colors.black),),
        "icon": Icons.settings,
        "page": SettingsPage(),
        "selected": true,
      },
    ];

    return Drawer(
      child: MediaQuery.removePadding(
          removeTop: true,
          context: context,
          child: Container(
            color: Colors.black,
              child: ListView(
            children: <Widget>[
              DrawerHeader(
                child: Center(
                  child: Text(
                    'Roomies',
                    style: TextStyle(
                      letterSpacing: 3,
                      fontSize: 72,
                      color: CustomColors.gold,
                    ),
                  ),
                ),
                decoration: BoxDecoration(
                  color: Colors.black,
                ),
              ),
              ListView.separated(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemCount: _menuItem.length,
                separatorBuilder: (context, i) {return const SizedBox(height: 32,);},
                itemBuilder: (context, i) {
                  return 
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 32,),
                    child:
                  DrawerTile(
                    title: _menuItem[i]["title"],
                    icon: _menuItem[i]["icon"],
                    selected: _menuItem[i]["selected"],
                    onTap: () {
                      print('Work');
                      if(!_menuItem[i]['selected'])
                      {
                      }
                      Navigator.push(context, generateRoute(context, _menuItem[i]["page"]));
                    },
                  ));
                },
              ),
              const SizedBox(height: 128,),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child:
              FloatingActionButton.extended(
                heroTag: null,
                splashColor: Colors.yellow,
                backgroundColor: CustomColors.gold,
                icon: const Text(
                  'Logout',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 36,
                  ),            
                ),          
                label: Icon(Icons.logout, size: 40, color: Colors.black,),
                onPressed: () {
                  context.read<AuthenticationBloc>().add(AuthenticationLogoutRequested());
                },
              )),
            ],
          ))),
      elevation: 64,
    );
  }

  MaterialPageRoute generateRoute(BuildContext context, Widget targetPage)
  {
    return MaterialPageRoute(
      builder: (_) =>
        MultiBlocProvider(
          providers: [
            BlocProvider<LandingCubit>.value(
              value: BlocProvider.of<LandingCubit>(context),
            ),
            BlocProvider<RoomatesCubit>.value(
              value: BlocProvider.of<RoomatesCubit>(context),
            ),
          ],
          child: targetPage,
        ),
    );
  }

}

