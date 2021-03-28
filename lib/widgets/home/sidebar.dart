
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roomiesMobile/business_logic/landing/cubit/landing_cubit.dart';
import 'package:roomiesMobile/presentation/chores/chore_page.dart';
import 'package:roomiesMobile/presentation/messaging/messages_page.dart';


class SideBar extends StatelessWidget {

@override
  Widget build(BuildContext context) {
    // TODO: implement build
   return Drawer(
  child: Container(
    color: Colors.black,
    child: Column(
    children: <Widget>[
      Expanded(
        flex:4,
        child:DrawerHeader(
        child: Text(
          'Roomies',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            )
          ),
        decoration: BoxDecoration(
          color: Colors.black,
        ),
      )),
      Expanded(
        flex: 8,
        child:Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [ 
        ListTile(
        title: Text(
          'Messages',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            )),
        onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) =>BlocProvider<LandingCubit>.value(
                          value: BlocProvider.of<LandingCubit>(context),
                          child: TestMessagePage()),),
              );
  
        },
      ),
      ListTile(
        title: Text(
          'Chores',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            )),
        onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => BlocProvider<LandingCubit>.value(
                          value: BlocProvider.of<LandingCubit>(context),
                          child: ChoresPage()),
              ));
        
        },
      ),
       ListTile(
        title: Text(
          'Locations',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            )),
        onTap: () {
        
        },
      ),
       ListTile(
        title: Text(
          'Settings',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            )),
        onTap: () {
        
        },
      ),
       ListTile(
        title: Text(
          'Roomies',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            )),
        onTap: () {
       
        },
      ),
       ListTile(
        title: Text(
          'Roomies',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            )),
        onTap: () {
          
        },
      ),
    ],
  )),


    Expanded(
     flex:1,
     child:
     ElevatedButton(),
      )
  
    ])

)
);
    
  
  }






}