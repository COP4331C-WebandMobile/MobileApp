
/*import 'dart:html';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:roomiesMobile/widgets/home/sidebar.dart';
import '../../business_logic/authentication/authentication.dart';
import '../../business_logic/authentication/bloc/authentication_bloc.dart';



class Chores extends StatelessWidget {

  @override
  Widget build(BuildContext context){

    final user = context.select((AuthenticationBloc element) => element.state.user);

    
    return BlocListener<ChoreState,ChoreCubit> {
     Scaffold(
        drawer:SideBar(),
        body: Text(user.email),
      );
    };
    


  }

}

class DisplayChore extends StatelessWidget{
  @override
  Widget build(BuildContext context) {

    //Add Modal
   return Text("Testing"); 
  }
}


class AddChore extends StatelessWidget{
  @override
  Widget build(BuildContext context) {

    //Add Modal
   return Text("Testing"); 
  }
}

class DeleteChore extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    //Add Modal
   return Text("Testing"); 
  }
}






//Add Chore
//Delete Chore
// Mark Chore
// Complete Chore
*/