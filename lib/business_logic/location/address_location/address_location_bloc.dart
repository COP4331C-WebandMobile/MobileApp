import 'dart:async';
import 'dart:html';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:map_repository/map_repository.dart';

part 'address_location_event.dart';
part 'address_location_state.dart';

class AddressLocationBloc
    extends Bloc<AddressLocationEvent, AddressLocationState> {
  final MapRepository _mapRepository;
  StreamSubscription _addressLocation;

  AddressLocationBloc({MapRepository mapRepository})
      : assert(mapRepository != null),
        _mapRepository = mapRepository,
        super(AddressLocationInitial()) {
    // Listen to the changes of the home location.
    _addressLocation = _mapRepository.houseLocation().listen((event) {
      add(GetHomeLocation(event));
    });
  }

  @override
  Stream<AddressLocationState> mapEventToState(
    AddressLocationEvent event,
  ) async* {
    if (event is GetHomeLocation) {
      // yield loadingState
      // Then on success pass the HouseLocation to the state.

    } else if (event is SetHomeAddress) {
      // Access the information from the event and pass it to the map repo set function.
      // yield loading
      // then yield failure or success.
    } else if (event is QueryAddresses) {
      // Same flow as set home address.
    }
  }
}
