
import 'package:chore_repository/chore_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:roomiesMobile/widgets/home/sidebar.dart';
import '../../business_logic/chores/bloc/chores_bloc.dart';

class ChoresPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
          create: (context) {
            return ChoresBloc(
              choresRepository: ChoresRepository(),
            )..add(LoadChores());
          },
          child: Scaffold(

        ),
      );
    }
  }
