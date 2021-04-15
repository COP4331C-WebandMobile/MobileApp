import 'package:flutter/material.dart';
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