import 'package:authentication_repository/authentication_repository.dart';
import 'package:roomiesMobile/presentation/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../business_logic/authentication/authentication.dart';
import 'package:home_repository/home_repository.dart';
import '../../business_logic/landing/cubit/landing_cubit.dart';


class LandingPage extends StatelessWidget {
 
  static Route route() {
    return MaterialPageRoute(builder: (_) => LandingPage());
  }

 @override 
 Widget build(BuildContext context){
 return Builder(
   builder: (context) =>
   Scaffold(
    body: Container(
      child: Column (
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
          'assets/house-logo.png'),
          ElevatedButton(
            onPressed: () => showDialog(
                  context: context,
                  builder: (_) => BlocProvider<LandingCubit>.value(
                          value: BlocProvider.of<LandingCubit>(context),
                          child: CreateHome())
                ),
            child: Text("Create Home")
          ),
          ElevatedButton(
            onPressed: () => showDialog(
                  context: context,
                  //builder: (context)=>DialogBox()
                ),
            child: Text("Join Home")
          ),
           Text(
             BlocProvider.of<AuthenticationBloc>(context)
            .state.user.email
          )
        ]
        ),
    )));
  } 
}
class CreateHome extends StatelessWidget {
  
  final houseName = TextEditingController();

  @override
  Widget build(BuildContext context) {
  return AlertDialog(
    content: FractionallySizedBox(
      widthFactor: 0.3,
      heightFactor: 0.3,
      child:Container(
      child: Column(
        children: <Widget>[ 
        Text("Enter Name Of Home"),
        TextField(
          controller: houseName,
        ),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () => context.read<LandingCubit>().AddHome(houseName.text)
          )
        ]
      )
      ),

  ));
  }
}

class JoinHome extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
  }

}



