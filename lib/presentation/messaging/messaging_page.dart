import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roomiesMobile/business_logic/messaging/bloc/messaging_bloc.dart';

import 'package:messaging_repository/messaging_repository.dart';

import '../../../packages/messaging_repository/lib/messaging_repository.dart';
import '../../../packages/messaging_repository/lib/messaging_repository.dart';

class MessagingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<MessagingBloc>(
      create: (context) {
        return MessagingBloc(
          messageRepository: FirebaseMessageRepository(),
        );
      },
      child: Builder(
        builder: (context) {
          return Scaffold(
            body: Column(
              children: <Widget>[
                Container(
                  child: BlocBuilder<MessagingBloc, MessagingState>(
                    builder: (context, state) {
                      return Column(
                        children: <Widget>[
                          SizedBox(
                            height: 64,
                            child: MessageWidget(state.props),
                          )
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class MessageListWidget extends StatelessWidget {
  final List<Message> messages;

  MessageListWidget({
    @required this.messages
  })

  @override
  Widget build(BuildContext context) 
  {
    return ListView.builder(
      itemCount: messages.length,
      itemBuilder: (context, i) {
        return MessageWidget(message: messages[i],);
      },
    )
  }
}

class MessageWidget extends StatelessWidget {

  final message;

  MessageWidget({@required this.message});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}

class AlertWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}

class QuestionWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}

class PurchaseWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}