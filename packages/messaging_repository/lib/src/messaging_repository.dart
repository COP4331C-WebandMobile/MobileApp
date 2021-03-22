
import 'dart:async';
import 'models/models.dart';

abstract class MessagingRepository {

  Future<void> createNewMessage(Message message);

  Future<void> deleteMessage(Message message);

  Stream<List<Message>> messages();

  Future<void> editMessage(Message message);

}