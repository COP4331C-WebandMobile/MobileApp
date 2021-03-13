import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class LoginViewMobile extends StatelessWidget {
  const LoginViewMobile({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: <Widget>[
          Container(
            color: Colors.yellow,
            padding: EdgeInsets.all(60),
            child: Text(
              "ROOMIES",
              style: TextStyle(
                  fontFamily: 'Open Sans', color: Colors.black, fontSize: 40),
            ),
            alignment: Alignment.center,
          ),
          Padding(
            padding: EdgeInsets.only(top: 100),
          ),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(top: 32, left: 32, right: 32),
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Username',
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 32, left: 32, right: 32),
            child: TextField(
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 32),
            child: SizedBox(
              height: 50,
              width: 300,
              child: ElevatedButton(
                child: Text("Continue"),
                style: ButtonStyle(

                ),
                onPressed: () {},
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 16),
            child: RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(text: 'Dont have an account? ', style: TextStyle(color: Colors.black)),
                  TextSpan(
                    text: 'Sign up here.',
                    style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.pushNamed(context, '/register');
                        print('Create an account!');
                      }
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
