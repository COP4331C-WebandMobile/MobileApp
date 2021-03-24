import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'create_message_state.dart';

class CreateMessageCubit extends Cubit<CreateMessageState> {
  CreateMessageCubit() : super(CreateMessageInitial());
}
