
import 'package:flutter/material.dart';

class SideBar extends StatelessWidget {

@override
  Widget build(BuildContext context) {
    // TODO: implement build
   return Drawer(
  // Add a ListView to the drawer. This ensures the user can scroll
  // through the options in the drawer if there isn't enough vertical
  // space to fit everything.
  child: ListView(
    // Important: Remove any padding from the ListView.
    padding: EdgeInsets.zero,
    children: <Widget>[
      DrawerHeader(
        child: Text('Drawer Header'),
        decoration: BoxDecoration(
          color: Colors.blue,
        ),
      ),
      ListTile(
        title: Text('Messages'),
        onTap: () {
          // Update the state of the app.
          // ...
        },
      ),
      ListTile(
        title: Text('Chores'),
        onTap: () {
          // Update the state of the app.
          // ...
        },
      ),
       ListTile(
        title: Text('Locations'),
        onTap: () {
          // Update the state of the app.
          // ...
        },
      ),
       ListTile(
        title: Text('Calendar'),
        onTap: () {
          // Update the state of the app.
          // ...
        },
      ),
       ListTile(
        title: Text('House Items'),
        onTap: () {
          // Update the state of the app.
          // ...
        },
      ),
       ListTile(
        title: Text('Settings'),
        onTap: () {
          // Update the state of the app.
          // ...
        },
      ),
    ],
  ),
);
    
  
  }






}