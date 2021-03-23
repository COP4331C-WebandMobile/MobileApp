import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../business_logic/authentication/authentication.dart';



class LandingPage extends StatelessWidget {
 
  static Route route() {
    return MaterialPageRoute(builder: (_) => LandingPage());
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
  
  return Scaffold(

    body: Container(
      child:Center(child:Column(
        children: <Widget>[
          ElevatedButton(
            onPressed: () => showDialog(
                  context: context,
                  builder: (context)=>DialogBox()
                ),
            child: Text("Create Home")
          ),
          ElevatedButton(
            onPressed: () => showDialog(
                  context: context,
                  builder: (context)=>DialogBox()
                ),
            child: Text("Join Home")
          ),
           Text(
             BlocProvider.of<AuthenticationBloc>(context)
            .state.user.email
          )

        ]
        )
    ))

  );
  
  }
}

class CreateHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
  return Dialog();
  }
}

class JoinHome extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
  }

}


class DialogBox extends StatelessWidget{

 @override
 Widget build(BuildContext context){
  return Dialog(
  shape: RoundedRectangleBorder(
    //borderRadius: BorderRadius.circular(),
  ),
  elevation: 3,
  backgroundColor: Colors.transparent,

  );
  }
}

