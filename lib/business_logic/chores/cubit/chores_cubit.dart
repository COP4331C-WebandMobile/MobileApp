/*import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:roomiesMobile/presentation/chores/chore_page.dart';
import 'package:chores_repository/chores_repository.dart';

part 'chores_state.dart';

class ChoresCubit extends Cubit<ChoresState> {

    ChoresCubit({
    @required choresRepository ChoreRepository,
  })  : assert(ChoreRepository != null),
        _choreRepository = choreRepository,
        super(const ChoresState.unkown()) {
    _choreSubscription = _choreRepository.chores.listen( //will return a stream subsription from (get user) 
      (chores) => ChoresUpdated(chores)), //add is a bloc event will mapevent ot state
    );
  }

}
*/