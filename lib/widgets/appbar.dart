import 'package:flutter/material.dart';
import '../business_logic/authentication/authentication.dart';
import '../business_logic/authentication/bloc/authentication_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Bar extends StatelessWidget implements PreferredSizeWidget  {

@override
Widget build(BuildContext context) {


  return PreferredSize(
        preferredSize: Size.fromHeight(100.0), // here the desired height
        child: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Roomies'),
       
      
        ));
}

  Size get preferredSize => Size.fromHeight(60); 

}