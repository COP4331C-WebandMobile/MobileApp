import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messaging_repository/messaging_repository.dart';
import 'package:roomiesMobile/business_logic/messages/bloc/messaging_bloc.dart';
import 'package:roomiesMobile/widgets/home/sidebar.dart';
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
      appBar: AppBar(
        title: Text('Messages'),
        centerTitle: true,
        actions: [
          Container(
            decoration: BoxDecoration(
              color: Colors.black,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              key: const Key('messagePage_add_iconButton'),
              icon: const Icon(Icons.add),
              color: Colors.white,
              splashColor: Colors.white,
              splashRadius: 20,
              onPressed: (){print('Test');},
            ),
          ),
        ],

      ),
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
      // Temporarily using SideBar until We decide what will be there.
      drawer: SideBar(),
    );
  }


}

class MessagesList extends StatelessWidget {

  final List<Message> messages;

  MessagesList(this.messages);

  @override
  Widget build(BuildContext context) {
    return 
      ListView.builder(
      itemCount: messages.length,
      itemBuilder: (BuildContext context, i) {
        return Padding(padding: EdgeInsets.all(16),
        child: MessageWidget(messages[i]),
        );
      },
    );
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

// Alert card would simply have the alert logo on the card, the body would then be displayed regularly.
// Question card would have an addition of a button to click on for responding.
// Purchaes would list releavant info on seperate lines or so, such as Price:


class AlertWidget extends StatelessWidget {

  final Message message;

  AlertWidget(this.message);

  @override
  Widget build(BuildContext context) {
    return MessageCard(
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.supervised_user_circle),
              const SizedBox(width: 8,),
              Expanded(child: Text(message.body))
            ],
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Text('- ' + message.creator),
            ),
          Align(
            alignment: Alignment.bottomRight,
            child: Text('Posted date'),
            ),
        ],
      ),
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