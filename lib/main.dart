import 'package:flutter/material.dart';
//import 'package:device_preview/device_preview.dart';
import 'package:roomiesMobile/presentation/screens/login_screen/login-view-mobile.dart';
import 'package:roomiesMobile/presentation/screens/register_screen/register-view-mobile.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
  //final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  runApp(MyApp());
 
}

class MyApp extends StatelessWidget {


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp( 
      //builder: DevicePreview.appBuilder,
      title: 'Roomies',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
      ),
      initialRoute:'/',
      routes:{
        '/': (context) => LoginViewMobile(),
        '/register': (context) => RegisterViewMobile(),
      },
      //home: LoginViewMobile(),
    );
  }
  
}