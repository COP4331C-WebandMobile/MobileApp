import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messaging_repository/messaging_repository.dart';
import 'package:roomiesMobile/business_logic/Test/bloc/messaging_bloc.dart';
import 'package:roomiesMobile/widgets/messages/message_card.dart';

class TestMessagePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MessagingBloc(FirebaseMessageRepository()),
      child: Scaffold(
        body: MyMessagePage(),
      ),
    );
  }
}

class MyMessagePage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _MyMessagePageState();
}

class _MyMessagePageState extends State<MyMessagePage> {


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 16),
        alignment: Alignment.center,
        child: BlocConsumer<MessagingBloc, MessagingState>(
          listener: (context, state) {
            if(state is NoMessages)
            {
              ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(
                content: Text(state.errorMessage),
              ));
            }
          },
          builder: (context, state) {
            if (state is MessagingLoading)
            {
              return Center(child: CircularProgressIndicator(),);
            }
            else if(state is MessagesLoaded)
            {
              return MessagesList(state.messages);
            }
            return Container();
          }

        ),
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
        return MessageCard(
          child: Column(
            children: [
              
            ],
          ),
        );
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
                Expanded(child: Text(message.creator)),
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