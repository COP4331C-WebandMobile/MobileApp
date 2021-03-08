import 'package:flutter/material.dart';
import 'package:roomiesMobile/presentation/screens/home-view.dart';
import 'package:device_preview/device_preview.dart';

void main() {
  runApp(DevicePreview( builder: (context)=> MyApp()));
  //unApp(MyApp());
}



class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp( 
      //builder: DevicePreview.appBuilder,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
      ),
      home: HomeView(),
    );
  }
}


