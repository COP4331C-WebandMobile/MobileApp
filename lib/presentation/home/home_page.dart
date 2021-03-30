import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roomiesMobile/business_logic/landing/cubit/landing_cubit.dart';
import 'package:roomiesMobile/business_logic/roomates/cubit/roomates_cubit.dart';
import 'package:roomiesMobile/business_logic/reminders/cubit/reminders_cubit.dart';
import 'package:roomiesMobile/presentation/themes/primary_theme/colors.dart';
import '../../widgets/home/sidebar.dart';
import 'package:reminder_repository/reminder_repository.dart';
import 'package:roomate_repository/roomate_repository.dart';

class HomePage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute(builder: (_) => HomePage());
  }

  @override
  Widget build(BuildContext context) {
    final _home = context.read<LandingCubit>().state.home;
    final _roomateRepository = RoomateRepository(_home);
    final _reminderRepository = ReminderRepository(_home);
    MediaQueryData mediaQuery = MediaQuery.of(context);

    return Scaffold(
        appBar: Bar(),
        body: Container(
            padding: EdgeInsets.all(32),
            height: mediaQuery.size.height,
            width: mediaQuery.size.width,
            child: Column(children: <Widget>[
              Expanded(
                flex: 3,
                child: HouseInfo(),
              ),
              Expanded(
                  flex: 2,
                  child: BlocProvider(
                    create: (context) =>
                        RoomatesCubit(roomateRepository: _roomateRepository),
                    child: RoomateList(),
                  )),
              Expanded(
                  flex: 8,
                  child: BlocProvider(
                    create: (context) =>
                        ReminderCubit(reminderRepository: _reminderRepository),
                    child: ReminderBox(),
                  )),
            ])),
        drawer: SideBar());
  }
}

class RoomateList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoomatesCubit, RoomatesState>(builder: (context, state) {
      return Container(
          margin: EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: CustomColors.gold,
            border: Border.all(
              color: Colors.black,
              width: 8,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(children: [
            Expanded(
                flex: 1,
                child: Row(children: [
                  Expanded(
                      child: Align(
                          alignment: Alignment.topLeft,
                          child: Text("Roomates",
                              style: TextStyle(
                                fontSize: 20,
                              )))),
                  Expanded(
                      child: Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                              icon:
                                  const Icon(Icons.add_circle_outline_outlined),
                              onPressed: () => {})))
                ])),
            Expanded(
                flex: 4,
                child: Container(
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: state.roomates.length,
                        itemBuilder: (BuildContext context, i) {
                          // TODO: I believe this is null, so maybe its not getting intialized properly.
                          return RoomateIcon(state.roomates[i]);
                        })))
          ]));
    });
  }
}

class HouseInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(children: [
      Align(
          alignment: Alignment.topLeft,
          child: Icon(
            Icons.house_sharp,
            size: 132,
          )),
      Column(
        children: [
          Text(
            "House Name",
            style: TextStyle(
              fontSize: 30,
            ),
          ),
          Text(
            "Address",
            style: TextStyle(
              fontSize: 24,
            ),
          ),
        ],
      )
    ]));
  }
}

class RoomateIcon extends StatelessWidget {
  final Roomate roomate;
  RoomateIcon(this.roomate);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
        child: TextButton(
      child: Text(roomate.firstName[0]),
      onPressed: () => {},
    ));
  }
}

class ReminderText extends StatelessWidget {
  final Reminder reminder;
  ReminderText(this.reminder);

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Column(
      children: [
        Text(reminder.description),
        Row(children: <Widget>[
          ElevatedButton(
              onPressed: () {
                //context.read<RemindersBloc>().add(CompleteChore(chore));
              },
              child: Text("Completed")),
          ElevatedButton(
            onPressed: () {
              //context.read<ChoresBloc>().add(DeleteChore(chore));
            },
            child: Text("Delete"),
          ),
          Text("Frequency")
        ]),
      ],
    ));
  }
}

class ReminderBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReminderCubit, ReminderState>(builder: (context, state) {
      return Container(
          margin: EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: CustomColors.gold,
            border: Border.all(
              color: Colors.black,
              width: 8,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(children: <Widget>[
            Expanded(
                flex: 2,
                child: Row(
                  children: [
                    Expanded(
                        child: Align(
                            alignment: Alignment.topLeft,
                            child: Text("Reminders",
                                style: TextStyle(
                                  fontSize: 28,
                                )))),
                    Expanded(
                        child: Align(
                            alignment: Alignment.topRight,
                            child: IconButton(
                              icon:
                                  const Icon(Icons.add_circle_outline_outlined),
                              onPressed: () => showDialog(
                                  context: context,
                                  builder: (_) =>
                                      BlocProvider<ReminderCubit>.value(
                                          value: BlocProvider.of<ReminderCubit>(
                                              context),
                                          child: CreateReminder())),
                            )))
                  ],
                )),
            Expanded(
                flex: 8,
                child: ListView.builder(
                    itemCount: state.reminders.length,
                    itemBuilder: (BuildContext context, i) {
                      return ReminderText(state.reminders[i]);
                    }))
          ]));
    });
  }
}

class CreateReminder extends StatelessWidget {
  final reminderDescription = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        content: FractionallySizedBox(
      widthFactor: 0.3,
      heightFactor: 0.3,
      child: Container(
          child: Column(children: <Widget>[
        Text("Enter Reminder Description"),
        TextField(
          controller: reminderDescription,
        ),
        MyStatefulWidget(),
        IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context
                .read<ReminderCubit>()
                .createReminder(reminderDescription.text, "Daily")),
      ])),
    ));
  }
}

/// This is the stateful widget that the main application instantiates.
class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  String dropdownValue = 'Daily';

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String newValue) {
        setState(() {
          dropdownValue = newValue;
        });
      },
      items: <String>['Daily', 'Weekly', 'Monthly']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}

class Bar extends StatelessWidget implements PreferredSizeWidget {
  
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      title: const Text('Roomies'),
      actions: <Widget>[
      ]
    );
  }

  Size get preferredSize => Size.fromHeight(60);
}
