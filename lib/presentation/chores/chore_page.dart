import 'package:chore_repository/chore_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:roomiesMobile/business_logic/authentication/bloc/authentication_bloc.dart';
import 'package:roomiesMobile/business_logic/landing/cubit/landing_cubit.dart';
import '../../business_logic/chores/bloc/chores_bloc.dart';

class ChoresPage extends StatefulWidget {
  const ChoresPage({Key key}) : super(key: key);

  @override
  _ChoresState createState() => _ChoresState();
}

class ChoresContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: BlocBuilder<ChoresBloc, ChoresState>(builder: (context, state) {
      return Column(
        children: <Widget>[Expanded(child: ChoreWidget(state.props, 0))],
      );
    }));
  }
}

class _ChoresState extends State<ChoresPage> {
  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = <Widget>[
    ChoresContainer(),
    ToDoContainer(),
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final home = context.read<LandingCubit>().state.home;
    print(home);
    return BlocProvider<ChoresBloc>(
        create: (context) => ChoresBloc(
              choresRepository: ChoresRepository(home),
            ),
        child: Builder(builder: (context) {
          return Scaffold(
            appBar: AppBarWidget(),
            body: Center(
              child: _widgetOptions.elementAt(_selectedIndex),
            ),
            bottomNavigationBar: BottomNavigationBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.list),
                  label: 'All',
                  backgroundColor: Colors.red,
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.list),
                  label: 'To do',
                  backgroundColor: Colors.purple,
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.analytics),
                  label: 'Stats',
                  backgroundColor: Colors.pink,
                ),
              ],
              currentIndex: _selectedIndex,
              selectedItemColor: Colors.amber[800],
              onTap: _onItemTapped,
            ),
          );
        }));
  }
}

class ToDoContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(//Based on context of the drop down build certain container
        child: BlocBuilder<ChoresBloc, ChoresState>(builder: (context, state) {
      return Column(
        children: <Widget>[Expanded(child: ChoreWidget(state.props, 1))],
      );
    }));
  }
}

class ChoreStatesContainer {}

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  Size get preferredSize => Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return AppBar(title: Text('Chores'), centerTitle: true, actions: [
      Container(
          decoration: BoxDecoration(
            color: Colors.black,
            shape: BoxShape.circle,
          ),
          child: IconButton(
              key: const Key('messagePage_add_iconButton'),
              icon: const Icon(Icons.add),
              color: Colors.white,
              splashColor: Colors.white,
              splashRadius: 20,
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (_) => BlocProvider<ChoresBloc>.value(
                          value: BlocProvider.of<ChoresBloc>(context),
                          child: AddModal(),
                        ));
              }))
    ]);
  }
}

class ChoreWidget extends StatelessWidget {
    List<Chore> markedList(chores, option) {
    List<Chore> markedList = [];

    if (option == 1) {
      for (int i = 0; i < chores.length; i++) {
        if (chores[i].mark == true) markedList.add(chores[i]);
      }
      return markedList;
    } else
      return chores;
  }

  final String id = "";
  final option;
  final String description = "";
  List<Chore> chores;
  ChoreWidget(chores, this.option) {
    this.chores = markedList(chores, option);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: ListView.builder(
      itemCount: chores.length,
      // ignore: missing_return
      itemBuilder: (BuildContext context, i) {
        return ChoreBox(chores[i]);
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
          child: Column(children: <Widget>[
        Text("Enter Description of Chore"),
        TextField(
          maxLines: null,
          controller: description,
          decoration: InputDecoration(
              
              contentPadding:
                  EdgeInsets.symmetric(vertical: 30, horizontal: 10),
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.white,
              labelText: 'Content',
              helperText: '',
              hintText: 'Wash clothes!',
            ),
        ),
        IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context
                .read<ChoresBloc>()
                .add(AddChore(Chore(email, false, description.text, "test"))))
      ])),
    );
  }
}

class ChoreBox extends StatelessWidget {
  final Chore chore;

  ChoreBox(this.chore);

  @override
  Widget build(BuildContext context) {
    var starColor;
    if (chore.mark == true) {
      starColor = Colors.yellow;
    } else
      starColor = Colors.black;
    return Card(
        child: Container(
      child: Row(children: [
        Expanded(
          child: Text(chore.description),
        ),
        Expanded(
          child: Column(children: <Widget>[
            IconButton(
              icon: Icon(
                Icons.check_box,
                color: Colors.green,
              ),
              onPressed: () {
                context.read<ChoresBloc>().add(CompleteChore(chore));
              },
            ),
            IconButton(
              icon: Icon(
                Icons.delete,
                color: Colors.red,
              ),
              onPressed: () {
                context.read<ChoresBloc>().add(DeleteChore(chore));
              },
            ),
            IconButton(
              icon: Icon(
                Icons.star,
                color: starColor,
              ),
              onPressed: () {
                if(chore.mark == false) context.read<ChoresBloc>().add(MarkChore(chore));
                else context.read<ChoresBloc>().add(UnMarkChore(chore));
              },
            )
          ]),
        )
      ]),
    ));
  }
}
