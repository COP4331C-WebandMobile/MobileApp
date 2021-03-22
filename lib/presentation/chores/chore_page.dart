
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
                child: IconButton(
                key: const Key('homePage_logout_iconButton'),
                icon: const Icon(Icons.add),
                onPressed: () => BlocProvider.of<ChoresBloc>(context)
                .add(AddChore(Chore("testing"))),
             ),
            )]
          ),
        );
      }
    )
    );
    }
  }

/*class  {

 

  void createWidget(){
  for(var i = 0; i<chores.length;i++){
    ChoreWidget(chores[i].id,chores[i].id);
  }
  }

}
*/


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
        //subtitle: Text("\$${chores[i].id}"),
        //trailing: IconButton(
          //icon: Icon(Icons.remove_shopping_cart),
          //onPressed: () {
           // bloc.removeFromCart(cartList[i]);
          //},
        //),
        onTap: () {},
      );
    },
  );

  }


}