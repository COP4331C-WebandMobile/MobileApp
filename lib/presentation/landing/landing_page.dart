import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../business_logic/authentication/authentication.dart';
import '../../business_logic/landing/cubit/landing_cubit.dart';

class LandingPage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute(builder: (_) => LandingPage());
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
        builder: (context) => Scaffold(
                body: Container(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset('assets/house-logo.png'),
                    Text(
                        "Welcome to Roomies , either create a home or join an existing home to get started"),
                    Row(
                      children: [
                        Expanded(
                            child: ElevatedButton(
                                onPressed: () => showDialog(
                                    context: context,
                                    builder: (_) =>
                                        BlocProvider<LandingCubit>.value(
                                            value:
                                                BlocProvider.of<LandingCubit>(
                                                    context),
                                            child: CreateHome())),
                                child: Text("Create Home")))
                      ],
                    ),
                    Row(children: [
                      Expanded(
                        child: ElevatedButton(
                            onPressed: () => showDialog(
                                context: context,
                                builder: (_) =>
                                    BlocProvider<LandingCubit>.value(
                                      value: BlocProvider.of<LandingCubit>(
                                          context),
                                      child: JoinHome(),
                                    )),
                            child: Text("Join Home")),
                      ),
                    ])
                  ]),
            )));
  }
}

class CreateHome extends StatelessWidget {
  final houseName = TextEditingController();
  final password = TextEditingController();
  

  @override
  Widget build(BuildContext context) {
    final email = context.read<AuthenticationBloc>().state.user.email;
    return AlertDialog(
        content: FractionallySizedBox(
            widthFactor: 0.5,
            heightFactor: 0.5,
            child: BlocBuilder<LandingCubit, LandingState>(
              builder: (context, state) {
                return Container(
                    child: Column(children: <Widget>[
                  Column(children: [
                    Text("Enter Name Of Home"),
                    TextField(
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(),
                        ),
                        controller: houseName)
                  ]),
                  Column(children: [
                    Text("Enter Password"),
                    TextField(
                      controller: password,
                    )
                  ]),
                  IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () => context
                          .read<LandingCubit>()
                          .addHome(houseName.text, password.text,email)),
                  Builder(builder: (BuildContext context) {
                    if (state.status == HomeStatus.Error)
                      return Text(state.error);
                    else
                      return Container(width: 0.0, height: 0.0);
                  }),
                ]));
              },
            )));
  }
}

class JoinHome extends StatelessWidget {
  final houseName = TextEditingController();
  final password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    
    final email = context.read<AuthenticationBloc>().state.user.email;

    return AlertDialog(
        content: FractionallySizedBox(
            widthFactor: 0.5,
            heightFactor: 0.5,
            child: BlocBuilder<LandingCubit, LandingState>(
                builder: (context, state) {
              return Container(
                  child: Column(children: <Widget>[
                Row(children: []),
                TextField(
                  controller: houseName,
                ),
                Text("Password"),
                TextField(
                  controller: password,
                ),
                IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () => context
                        .read<LandingCubit>()
                        .joinHome(houseName.text, password.text,email)),
                Builder(builder: (BuildContext context) {
                  if (state.status == HomeStatus.Error)
                    return Text(state.error);
                  else
                    return Container(width: 0.0, height: 0.0);
                }),
              ]));
            })));
  }
}
