

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messaging_repository/messaging_repository.dart';
import 'package:roomiesMobile/business_logic/messaging/bloc/messaging_bloc.dart';

class MessagingPage extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MessagingBloc(messageRepository: FirebaseMessageRepository()),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(title: Text('Messages'),),
            body: Column(
              children: <Widget>[
                BlocBuilder<MessagingBloc, MessagingState>(
                  builder: (context, state) {
                    if(state.status == MessageStatus.updated)
                    {
                      return MessagesList(state.messages);
                    }
                    else
                    {
                      return Container();
                    }
                  },
                ),
              ],
            ),
          );
        },
      ),
      );
  }

}

class MessagesList extends StatelessWidget {

  final List<Message> messages;

  MessagesList(this.messages);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child:ListView.builder(
      itemCount: messages.length,
      itemBuilder: (BuildContext context, i) {
        return Padding(padding: EdgeInsets.all(16),
        child: MessageWidget(messages[i]),
        );
      },
    ),);
  }

}

class MessageWidget extends StatelessWidget {

  final Message message;

  MessageWidget(this.message);

  @override
  Widget build(BuildContext context) {
    
    if(message.type == MessageType.alert)
    {
        return AlertWidget(message);
    }
    else
    {
        return Container();
    }

  }

}

class AlertWidget extends StatelessWidget {

  final Message message;

  AlertWidget(this.message);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomBoxWidget(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.account_circle_rounded),
                Expanded(child: Text("This is just a sample text to see how the wrapping would occur and it looks like its good.")),
                Icon(Icons.pets_outlined),
              ],
            ),
            ElevatedButton(onPressed: (){}, child: Text('Press me'),),
          ],
        )
      ],
    );
  }

}


class CustomBoxWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return Container(
      height: size.height / 10,
      decoration: BoxDecoration(
        color: Colors.yellow,
        border:  Border.all(
          color: Colors.black,
        ),
      ),
    );
  }

}

// So if I can build a custom widget with this kind of format
// It can be reused and altered for each message type.
// Which will be returned accordingly.
// So modifying each look would be easier.