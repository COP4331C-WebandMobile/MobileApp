
import 'package:chore_repository/chore_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:roomiesMobile/business_logic/authentication/bloc/authentication_bloc.dart';
import 'package:roomiesMobile/business_logic/landing/cubit/landing_cubit.dart';
import 'package:roomiesMobile/widgets/home/sidebar.dart';
import '../../business_logic/chores/bloc/chores_bloc.dart';
import '../../widgets/appbar.dart';

class ChoresPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final home = context.read<LandingCubit>().state.home;

    return BlocProvider<ChoresBloc>(
          create: (context) => ChoresBloc(
            choresRepository: ChoresRepository(home),
            )/*..add(LoadChores())*/,
          child: Builder(
            builder: (context) { 
            return Scaffold(
            appBar: Bar(),
            body: Column(
            children: <Widget>[
              Container( 
                child: BlocBuilder<ChoresBloc,ChoresState>(
                  builder: (context,state){
                    return Column(
                    children:<Widget>[SizedBox(
                      height:500,
                      child: ChoreWidget(state.props))],
                    );
                  }
                ),
              ),
              Container( 
                   child: IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: (){
                      showDialog(context: context, 
                      builder: (_) => BlocProvider<ChoresBloc>.value(
                          value: BlocProvider.of<ChoresBloc>(context),
                          child: AddModal(),
                      )
                      );
                      }      
              ))]
          ),
        );
      }
    )
    );
    }
  }
class ChoreWidget extends StatelessWidget {

  final String id ="";
  final String description="";
  final List<Chore> chores;
  ChoreWidget(this.chores);

  //ChoreWidget(this.id,this.description);
  @override 
  Widget build(BuildContext context){
    return Container(
      child:
      ListView.builder(
    itemCount: chores.length,
    itemBuilder: (BuildContext context, i) {

      return ChoreBox( chores[i]
     
          );
        }, // Delete Chore
      ));
    }
}
class AddModal extends StatelessWidget {

@override
Widget build(BuildContext context) {

  final email = context.read<AuthenticationBloc>().state.user.email;

    
  final description = TextEditingController();
 
  return AlertDialog(
    content: Container(
      child: Column(
        children: <Widget>[ 
        Text("Enter Description of Chore"),
        TextField(
          controller:description,
        ),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () => context.read<ChoresBloc>().add(AddChore(Chore(email,false,description.text,"test")))
          )
        ]
      )
      ),
  );
}}

class ChoreBox extends StatelessWidget {
final Chore chore;

ChoreBox(this.chore);

@override 
Widget build(BuildContext context){
  return Card(
    child: Column (
      children: [
        Text(chore.creator),
        Text(chore.description),
        Row(
        children: <Widget>[ElevatedButton(
          onPressed: () {
            context.read<ChoresBloc>().add(CompleteChore(chore));
            },
          child: Text("Completed")
        ),
        ElevatedButton(
          onPressed: () { 
          context.read<ChoresBloc>().add(DeleteChore(chore));
          },
          child: Text("Delete"),
        ),
        ElevatedButton(
          onPressed: () { 
             context.read<ChoresBloc>().add(MarkChore(chore));
           },
          child: Text("Mark")
        )]),
    ],)
   );


}


}