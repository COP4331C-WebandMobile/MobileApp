import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'address_location_event.dart';
part 'address_location_state.dart';

class AddressLocationBloc extends Bloc<AddressLocationEvent, AddressLocationState> {
  AddressLocationBloc() : super(AddressLocationInitial());

  @override
  Stream<AddressLocationState> mapEventToState(
    AddressLocationEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
