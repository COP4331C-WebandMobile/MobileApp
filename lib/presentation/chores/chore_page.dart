import 'package:chore_repository/chore_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:roomate_repository/roomate_repository.dart';
import 'package:roomiesMobile/business_logic/authentication/bloc/authentication_bloc.dart';
import 'package:roomiesMobile/business_logic/landing/cubit/landing_cubit.dart';
import 'package:roomiesMobile/business_logic/roomates/cubit/roomates_cubit.dart';
import 'package:roomiesMobile/business_logic/statistics/cubit/statistics_cubit.dart';
import 'package:roomiesMobile/presentation/themes/primary_theme/colors.dart';
import 'package:roomiesMobile/widgets/home/new_sidebar.dart';
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
            drawer: NewSideBar(),
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
        margin: EdgeInsets.all(10),
        child: Column(children: [
          Align(
              alignment: Alignment.topLeft,
              child: Row(children: [
                CircleAvatar(
                    backgroundColor: CustomColors.gold,
                    foregroundColor: Colors.black,
                    child: Text(rank.toString())),
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
            CircleAvatar(
                backgroundColor: Colors.black,
                child: Text(
                  stat.completed.toString(),
                  style: TextStyle(color: CustomColors.gold),
                )),
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
    final body = TextEditingController();
    return AlertDialog(
      title: Text(
        'Enter Description of Chore',
        textAlign: TextAlign.center,
      ),
      content: Container(
        alignment: Alignment.center,
        height: 300,
        width: 300,
        padding: EdgeInsets.all(0),
        child: Column(
          children: [
            Container(
                padding:
                    EdgeInsets.only(bottom: 100, left: 20, right: 20, top: 40),
                color: Colors.yellow.shade200,
                child: TextField(
                  keyboardType: TextInputType.text,
                  onSubmitted: (value) {},
                  maxLines: 2,
                  maxLength: 150,
                  textAlign: TextAlign.start,
                  controller: body,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: InputDecoration(
                    isDense: true,
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                    labelText: 'Message',
                    helperText: '',
                    hintText: 'Yeah',
                  ),
                )),
            Container(
                padding: EdgeInsets.only(top: 20),
                child: FloatingActionButton.extended(
                  heroTag: null,
                  onPressed: () {
                    context
                        .read<ChoresBloc>()
                        .add(AddChore(Chore(email, false, body.text, "test")));
                    Navigator.pop(context);
                  },
                  label: Text('Post'),
                ))
          ],
        ),
      ),
    );
    //context.read<ChoresBloc>().add(AddChore(
    //    Chore(email, false, description.text, "test"))
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
      padding: EdgeInsets.all(5),
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
                showDialog(
                    context: context,
                    builder: (_) => BlocProvider<ChoresBloc>.value(
                          value: BlocProvider.of<ChoresBloc>(context),
                          child: AlertDialog(
                            title: Text(
                              'Confirmation',
                              textAlign: TextAlign.center,
                            ),
                            content: SingleChildScrollView(
                                child: ListBody(
                              children: <Widget>[
                                Text(
                                  'Do you want to delete this?',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )
                              ],
                            )),
                            actions: <Widget>[
                              Container(
                                  decoration: BoxDecoration(
                                      color: CustomColors.gold,
                                      border: Border.all(color: Colors.black)),
                                  child: TextButton(
                                    child: Text('Confirm'),
                                    onPressed: () {
                                      context
                                          .read<ChoresBloc>()
                                          .add(DeleteChore(chore));

                                      Navigator.of(context).pop();
                                    },
                                  )),
                            ],
                          ),
                        ));

                // context.read<ChoresBloc>().add(DeleteChore(chore));
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
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(const SnackBar(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    duration: Duration(seconds: 1, milliseconds: 500),
                    backgroundColor: Colors.black,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.all(Radius.elliptical(5, 5))),
                    content: Text(
                      'Completed!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: CustomColors.gold,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ));
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
