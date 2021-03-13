import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'register_bloc_event.dart';
part 'register_bloc_state.dart';

class RegisterBlocBloc extends Bloc<RegisterBlocEvent, RegisterBlocState> {
  RegisterBlocBloc() : super(RegisterBlocInitial());

  @override
  Stream<RegisterBlocState> mapEventToState(
    RegisterBlocEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
