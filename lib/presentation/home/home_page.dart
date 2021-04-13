import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roomiesMobile/business_logic/authentication/bloc/authentication_bloc.dart';
import 'package:roomiesMobile/business_logic/landing/cubit/landing_cubit.dart';
import 'package:roomiesMobile/business_logic/roomates/cubit/roomates_cubit.dart';
import 'package:roomiesMobile/business_logic/reminders/cubit/reminders_cubit.dart';
import 'package:roomiesMobile/presentation/roomate_profile/roomate_profile_page.dart';
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

    final _address = context.read<LandingCubit>().state.address;
    final _roomateRepository = RoomateRepository(_home);
    final _reminderRepository = ReminderRepository(_home);

    MediaQueryData mediaQuery = MediaQuery.of(context);

    return Scaffold(
        appBar: Bar(),
        body: Container(
            padding: EdgeInsets.all(5),
            height: mediaQuery.size.height,
            width: mediaQuery.size.width,
            child: Column(children: <Widget>[
              Expanded(
                flex: 2,
                child: HouseInfo(_home, _address),
              ),
              Expanded(
                  flex: 2,
                  child: BlocProvider(
                    create: (context) =>
                        RoomatesCubit(roomateRepository: _roomateRepository),
                    child: RoomateList(),
                  )),
              Expanded(
                  flex: 7,
                  child: BlocProvider(
                    create: (context) =>
                        ReminderCubit(reminderRepository: _reminderRepository),
                    child: ReminderList(),
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
          margin: EdgeInsets.all(3),
          padding: EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: CustomColors.gold,
            border: Border.all(
              color: Colors.black,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(children: [
            Expanded(
                flex: 3,
                child: Row(children: [
                  Expanded(
                      child: Row(children: [
                    Icon(Icons.people),
                    Text(" Roomies",
                        style: TextStyle(
                          fontSize: 20,
                        ))
                  ])),
                ])),
            Expanded(
                flex: 4,
                child: Builder(

                    // ignore: missing_return
                    builder: (context) {
                  if (state.status == RoomateStatus.Loaded) {
                    return Container(
                        padding: EdgeInsets.all(5),
                        child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: state.roomates.length,
                            separatorBuilder: (context, i) { return const SizedBox(width: 16,);},
                            itemBuilder: (BuildContext context, i) {
                              return NewRoomateIcon(state.roomates[i]);
                            }));
                  } else
                    return Text("Loading");
                })),
          ]));
    });
  }
}

class HouseInfo extends StatelessWidget {
  final home;
  final address;
  const HouseInfo(this.home, this.address);
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(children: [
      Align(
          alignment: Alignment.topLeft,
          child: Icon(
            Icons.house_sharp,
            size: 132,
            color: Colors.black,
          )),
      Column(
        children: [
          Text(
            home,
            style: TextStyle(
              fontSize: 30,
            ),
          ),
          Text(
            address,
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
    return Container(
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Colors.black,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(12)),
        margin: EdgeInsets.all(3),
        height: 100,
        width: 80,
        child: Column(children: [
          Expanded(
              child: IconButton(
                  icon: Icon(Icons.face_sharp, size: 30),
                  onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => ProfilePage(roomate)),
                        //Navigate to profile page
                      ))),
          Padding(padding: EdgeInsets.all(5)),
          Expanded(
              child: Text(
            roomate.firstName + " " + roomate.lastName,
            textAlign: TextAlign.center,
          )),
        ]));
  }
}

class NewRoomateIcon extends StatelessWidget {

  final Roomate roomate;
  NewRoomateIcon(this.roomate);
  
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){print('Thing');},
      child: CircleAvatar(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      radius: 24,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Align(
            alignment: Alignment.topCenter,
            child: Icon(Icons.face),
          ),
          Text('G.F'),
        ],
      ),
    ));

  }



}

class ReminderText extends StatelessWidget {
  final Reminder reminder;
  ReminderText(this.reminder);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(5),
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Colors.black,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(12)),
        child: Column(children: [
          Row(children: [
            Expanded(
                child: Text(
              reminder.description,
              style: TextStyle(fontSize: 30),
            ))
          ]),
          Row(children: [
            Icon(Icons.calendar_today_outlined, color: Colors.blue),
            Text(reminder.frequency),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              alignment: Alignment.bottomRight,
              onPressed: () {
                context.read<ReminderCubit>().deleteReminder(reminder);
              },
            ),
            IconButton(
              icon: Icon(Icons.check, color: Colors.green),
              onPressed: () {
                context.read<ReminderCubit>().completeReminder(
                    context.read<AuthenticationBloc>().state.user.email,
                    reminder);
              },
            ),
          ])
        ]));
  }
}

class ReminderList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(2),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: CustomColors.gold,
          border: Border.all(
            color: Colors.black,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: BlocBuilder<ReminderCubit, ReminderState>(
            builder: (context, state) {
          return Column(children: <Widget>[
            Expanded(
                flex: 1,
                child: Row(
                  children: [
                    Expanded(
                        child: Align(
                            alignment: Alignment.topLeft,
                            child: Row(children: [
                              Icon(Icons.calendar_today_rounded, size: 30),
                              Text("Reminders",
                                  style: TextStyle(
                                    fontSize: 20,
                                  )),
                            ]))),
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
            // ignore: missing_return
            Builder(builder: (context) {
              if (state.status == ReminderStatus.Loaded) {
                return Expanded(
                    flex: 8,
                    child: Container(
                        child: ListView.builder(
                            itemCount: state.reminders.length,
                            itemBuilder: (BuildContext context, i) {
                              return ReminderText(state.reminders[i]);
                            })));
              } else
                return Text("");
            }),
          ]);
        }));
  }
}

class CreateReminder extends StatefulWidget {
  const CreateReminder({Key key}) : super(key: key);

  @override
  _CreateReminderState createState() => _CreateReminderState();
}

class _CreateReminderState extends State<CreateReminder> {
  String dropdownValue = 'Daily';
  final reminderDescription = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
          height: 450,
          width: 350,
          color: Colors.yellow.shade200,
          child: Column(children: <Widget>[
            Text("Enter Reminder Description",
                style: TextStyle(
                  fontSize: 20,
                )),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: TextField(
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 30, horizontal: 10),
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                  labelText: 'Reminder',
                  helperText: '',
                  hintText: 'Turn Off Lights!',
                ),
                controller: reminderDescription,
              ),
            ),
            Text("How Often ?",
                style: TextStyle(
                  fontSize: 20,
                )),
            DropdownButton<String>(
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
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: IconButton(
                  icon: const Icon(
                    Icons.add_circle_outline_rounded,
                    size: 40,
                    color: Colors.black,
                  ),
                  onPressed: () => context
                      .read<ReminderCubit>()
                      .createReminder(reminderDescription.text, dropdownValue)),
            )
          ])),
    );
  }
}

/// This is the stateful widget that the main application instantiates.

//

class Bar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
        backgroundColor: Colors.white,
        title: const Text('Roomies'),
        actions: <Widget>[]);
  }

  Size get preferredSize => Size.fromHeight(60);
}
