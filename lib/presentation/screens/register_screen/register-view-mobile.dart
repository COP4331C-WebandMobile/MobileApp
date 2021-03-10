import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class RegisterViewMobile extends StatelessWidget {
  const RegisterViewMobile({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: <Widget>[
          Container(
            color: Colors.yellow,
            padding: EdgeInsets.all(20),
            child: Text(
              "Roomies",
              style: TextStyle(
                  fontFamily: 'Open Sans', color: Colors.black, fontSize: 40),
            ),
            alignment: Alignment.center,
          ),
          Padding(
            padding: EdgeInsets.only(top: 100),
          ),
          Container(
            
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
                border: Border.all(
                color: Colors.black,
                ),
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.yellow,
            ),
            child: Column(
    
            children: <Widget>[
            InputFields("First Name"),
            InputFields("Last Name"),
            InputFields("Email"),
            InputFields("Password"),
            InputFields("Confirm Password"),
            ],
            ),
          ),
          
        ],
      ),
    );
  }

 Widget InputFields(String type) => TextField(
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: type,
              ),
            );
 
}


