
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
          create: (context){
            return ChoresBloc(
              choresRepository: ChoresRepository(),
            )..add(LoadChores());
          },
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
                      height:700,
                      child: ChoreWidget(state.props))],
                    );
                  }
                ),
              ),
              Container( 
                child: BlocBuilder<ChoresBloc,ChoresState>(
                  builder: (context,state){
                return IconButton(
                key: const Key('homePage_logout_iconButton'),
                icon: const Icon(Icons.add),
                onPressed: (){
                   BlocProvider.of<ChoresBloc>(context)
                  .add(AddChore(Chore("testing")));
                  showDialog(
                  context: context,
                  builder: (context)=>AddModal()
                );
                }
              );}))]
      
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
      return ListTile(
        title: Text(chores[i].id),
        onTap: () {
          BlocProvider.of<ChoresBloc>(context)
                .add(DeleteChore(chores[i]));
        }, // Delete Chore
      );
    },
  );

  }
}

class AddModal extends StatelessWidget {

@override
Widget build(BuildContext context) {
          
final ChoresBloc bloc = BlocProvider.of<ChoresBloc>(context);

return Dialog(
  shape: RoundedRectangleBorder(
    //borderRadius: BorderRadius.circular(),
  ),
  elevation: 3,
  backgroundColor: Colors.transparent,
  child:  Builder(builder: (context) =>MyCustomForm()) 
);
}
}

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

        //final ChoresBloc bloc = BlocProvider.of<ChoresBloc>(context);

        return Column (
        children: [ Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          controller: description,
        ),
        ),
        Container( 
                child: Builder(builder: (context) =>IconButton(
                key: const Key('homePage_logout_iconButton'),
                icon: const Icon(Icons.add),
                onPressed: () =>
                  BlocProvider.of<ChoresBloc>(context)
                  .add(AddChore(Chore("testing"))),
                )))]
      );
  }
}
