import 'package:chore_repository/chore_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:roomate_repository/roomate_repository.dart';
import 'package:roomiesMobile/business_logic/authentication/bloc/authentication_bloc.dart';
import 'package:roomiesMobile/business_logic/landing/cubit/landing_cubit.dart';
import 'package:roomiesMobile/business_logic/roomates/cubit/roomates_cubit.dart';
import 'package:roomiesMobile/business_logic/statistics/cubit/statistics_cubit.dart';
import 'package:roomiesMobile/presentation/themes/primary_theme/colors.dart';
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
    StatContainer(),
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

class StatContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var roomates = context.read<RoomatesCubit>().state.roomates;
    roomates.sort((a, b) => b.totalChores.compareTo(a.totalChores));

    return Container(
        child: ListView.builder(
      itemCount: roomates.length,
      // ignore: missing_return
      itemBuilder: (BuildContext context, i) {
        return StatBox(roomates[i], i + 1);
      }, // Delete Chore
    ));
  }
}

class StatBox extends StatelessWidget {
  final Roomate roomate;
  final int rank;
  const StatBox(this.roomate, this.rank);

  @override
  Widget build(BuildContext context) {
    var home = context.read<LandingCubit>().state.home;
    var firstName = roomate.firstName;
    var lastName = roomate.lastName;
    var totalChores = roomate.totalChores;

    return Card(
        margin: EdgeInsets.all(20),
        child: Column(children: [
          Align(
              alignment: Alignment.topLeft,
              child: Row(children: [
                CircleAvatar(child: Text(rank.toString())),
                Text("  " + firstName + " " + lastName + " Has Completed ",
                    style: TextStyle(
                      fontSize: 20,
                    )),
                Text(totalChores.toString(),
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 20,
                    )),
                Text(" Chores",
                    style: TextStyle(
                      fontSize: 20,
                    ))
              ])),
          ExpansionTile(
              title: Text("Details", style: TextStyle(fontSize: 20)),
              children: <Widget>[
                Container(
                    height: 250,
                    width: 250,
                    child: BlocBuilder(
                        bloc: StatsCubit(home, roomate.email),
                        builder: (context, state) {
                          if (state.status == StatStatus.Loaded) {
                            return ListView.builder(
                                itemCount: state.stats.length,
                                itemBuilder: (BuildContext context, i) {
                                  return StatDescription(state.stats[i]);
                                });
                          }
                          return Text("No Stats Available");
                        }))
              ])
        ]));
  }
}

class StatDescription extends StatelessWidget {
  final Stat stat;
  const StatDescription(this.stat);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: CustomColors.gold,
          border: Border.all(
            color: Colors.black,
            width: 3,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Text(stat.description + "   ", style: TextStyle(fontSize: 20)),
            CircleAvatar(child: Text(stat.completed.toString())),
          ],
        ));
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

    return Dialog(
      child: Container(
          height: 200,
          width: 200,
          child: Column(children: <Widget>[
            Text("Enter Description of Chore",
                style: TextStyle(
                  fontSize: 20,
                )),
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
            Align(
                alignment: Alignment.bottomRight,
                child: IconButton(
                    icon: const Icon(
                      Icons.add_circle_outline_rounded,
                      size: 40,
                      color: Colors.green,
                    ),
                    onPressed: () => context.read<ChoresBloc>().add(AddChore(
                        Chore(email, false, description.text, "test")))))
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
      padding: EdgeInsets.all(10),
      child: Row(children: [
        Expanded(
          flex: 5,
          child: Text(chore.description, style: TextStyle(fontSize: 30)),
        ),
        Expanded(
          flex: 3,
          child: Row(children: <Widget>[
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
                if (chore.mark == false)
                  context.read<ChoresBloc>().add(MarkChore(chore));
                else
                  context.read<ChoresBloc>().add(UnMarkChore(chore));
              },
            ),
            IconButton(
              icon: Icon(
                Icons.check_box,
                color: Colors.green,
              ),
              onPressed: () {
                context.read<ChoresBloc>().add(CompleteChore(chore,
                    context.read<AuthenticationBloc>().state.user.email));
              },
            ),
          ]),
        )
      ]),
    ));
  }
}
