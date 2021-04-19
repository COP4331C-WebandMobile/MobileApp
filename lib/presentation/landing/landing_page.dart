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
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset('assets/house-logo.png'),
                    Container(
                      child: Text(
                        "Welcome to Roomies , either create a home or join an existing home to get started",
                        textAlign: TextAlign.center,
                      ),
                      color: Colors.yellow[200],
                      margin:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 40),
                    ),
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
  final address = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final email = context.read<AuthenticationBloc>().state.user.email;
    return Dialog(
        child: Container(
            decoration: BoxDecoration(
                color: Colors.yellow.shade200,
                border: Border.all(
                    color: Colors.white, width: 5, style: BorderStyle.solid),
                borderRadius: BorderRadius.all(Radius.elliptical(30, 30))),
            height: 400,
            width: 300,
            child: BlocBuilder<LandingCubit, LandingState>(
              builder: (context, state) {
                return Container(
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                    child: Column(children: <Widget>[
                      Column(children: [
                        Text("Enter Name Of Home"),
                        TextField(
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              border: OutlineInputBorder(),
                              filled: true,
                              fillColor: Colors.white,
                              labelText: 'Home',
                              helperText: '',
                              hintText: 'Roomies',
                            ),
                            controller: houseName)
                      ]),
                      Column(children: [
                        Text("Enter Password"),
                        TextField(
                           obscureText: true,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            border: OutlineInputBorder(),
                                       

                            filled: true,
                            fillColor: Colors.white,
                            labelText: 'Password',
                            helperText: '',
                            hintText: 'Password',
                          ),
                          controller: password,
                        ),
                        Text("Enter Address"),
                        TextField(
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            border: OutlineInputBorder(),
                            filled: true,
                            fillColor: Colors.white,
                            labelText: 'Address',
                            helperText: '',
                            hintText: '123 Fake St.',
                          ),
                          controller: address,
                        )
                      ]),
                      FloatingActionButton.extended(
                          heroTag: null,
                          onPressed: () => context.read<LandingCubit>().addHome(
                              houseName.text,
                              password.text,
                              email,
                              address.text),
                          label: Text('Add home')),
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

    return Dialog(
        child: Container(
            height: 400,
            width: 300,
            decoration: BoxDecoration(
                color: Colors.yellow.shade200,
                border: Border.all(
                    color: Colors.white, width: 5, style: BorderStyle.solid),
                borderRadius: BorderRadius.all(Radius.elliptical(30, 30))),
            child: BlocBuilder<LandingCubit, LandingState>(
                builder: (context, state) {
              return Container(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                  child: Column(children: <Widget>[
                    Text("House Name",
                        style: TextStyle(
                          fontSize: 20,
                        )),
                    TextField(
                      textAlign: TextAlign.center,
                      autofocus: true,
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                        labelText: 'Home',
                        helperText: '',
                        hintText: 'Home',
                      ),
                      controller: houseName,
                    ),
                    Text("Password",
                        style: TextStyle(
                          fontSize: 20,
                        )),
                    TextField(
                       obscureText: true,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                        labelText: 'Password',
                        helperText: '',
                        hintText: 'Password',
                      ),
                      controller: password,
                    ),
                    FloatingActionButton.extended(
                        heroTag: null,
                        onPressed: () => context
                            .read<LandingCubit>()
                            .joinHome(houseName.text, password.text, email),
                        label: Text('Join home')),
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
