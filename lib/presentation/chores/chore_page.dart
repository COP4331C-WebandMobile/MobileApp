
import 'package:chore_repository/chore_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:roomiesMobile/widgets/home/sidebar.dart';
import '../../business_logic/chores/bloc/chores_bloc.dart';
import '../../widgets/appbar.dart';

class ChoresPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ChoresBloc>(
          create: (context) => ChoresBloc(
            choresRepository: ChoresRepository(),
            )..add(LoadChores()),
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
    return ListView.builder(
    itemCount: chores.length,
    itemBuilder: (BuildContext context, i) {
      return ChoreBox(
        /*title: Text(chores[i].id),
        onTap: () {
          BlocProvider.of<ChoresBloc>(context)
                .add(DeleteChore(chores[i]));
                */
          );
        }, // Delete Chore
      );
    }
}

class AddModal extends StatelessWidget {

@override
Widget build(BuildContext context) {
          
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
          onPressed: () => context.read<ChoresBloc>().add(AddChore(Chore(description.text)))
          )
        ]
      )
      ),
  );
}}
class MyCustomForm extends StatefulWidget {
  @override
  _MyCustomFormState createState() => _MyCustomFormState();
}
class _MyCustomFormState extends State<MyCustomForm> {
 
  final description = TextEditingController();

  @override
  void dispose() {
    description.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
        return Column(
          children: [ 
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: description,
                ),
              ),
              Container( 
                child: Builder(builder: (context) =>IconButton(
                icon: const Icon(Icons.add),
                onPressed: () =>
                  context.read<ChoresBloc>()
                  .add(AddChore(Chore(description.text))),
                 )
                 )
                )
                ]
      );
  }
}


class ChoreBox extends StatelessWidget {


@override 
Widget build(BuildContext context){

  return Card(
    child: Column (
      
      children: [
        Text("Testing"),
    ],)
   );


}




}