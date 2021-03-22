import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../business_logic/authentication/authentication.dart';
import '../../business_logic/authentication/bloc/authentication_bloc.dart';
import '../../widgets/home/sidebar.dart';
import '../../widgets/appbar.dart';
import 'package:home_repository/home_repository.dart';

class HomePage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute(builder: (_) => HomePage());
  }
  @override
  Widget build(BuildContext context) {
    final user =
        context.select((AuthenticationBloc element) => element.state.user);
    return Scaffold(
      appBar: Bar(),
      body: Align(
        alignment: const Alignment(0, -1 / 3),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(user.email),
            const SizedBox(height: 4.0),
            Text(user.name ?? ''),
          ],
        ),
        
      ),
      drawer: SideBar()
    );
  }
}
