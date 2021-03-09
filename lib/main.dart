import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:roomiesMobile/presentation/screens/login_screen/login-view.dart';

void main() {
  runApp(DevicePreview( builder: (context)=> MyApp()));
  //runApp(MyApp());
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
      home: LoginView(),
    );
  }
}


