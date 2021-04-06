import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messaging_repository/messaging_repository.dart';
import 'package:roomiesMobile/business_logic/authentication/bloc/authentication_bloc.dart';
import 'package:roomiesMobile/business_logic/landing/cubit/landing_cubit.dart';
import 'package:roomiesMobile/business_logic/messages/bloc/messaging_bloc.dart';
import 'package:roomiesMobile/widgets/home/sidebar.dart';
import 'package:roomiesMobile/widgets/messages/message_card.dart';

class TestMessagePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final String houseName = context.read<LandingCubit>().state.home;

    return BlocProvider(
      create: (context) => MessagingBloc(FirebaseMessageRepository(houseName: houseName)),
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

// Going to have to be stateful since it will have different display based on selected type to create.
class CreateMessageModal extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final creator = context.read<AuthenticationBloc>().state.user.email;
    final body = TextEditingController();

    MessageType type = MessageType.invalid;
    String newText = 'Message';
    return StatefulBuilder(
      builder: (context, setState) {
       return AlertDialog(
        content: Container(
          // TODO: Eventually fix any MediaQuery either to be used or finding a better option.
          height: MediaQuery.of(context).size.height / 2,
          child: Column( 
            children: [
              Text('Create New Message'),
              const SizedBox(height: 32,),
              TextField(
                  controller: body,
                  decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                  labelText: 'Content',
                  helperText: '',
                  hintText: 'I have a test today!',
                ),
              ),
              Card(
                margin: EdgeInsets.all(20),
                child: ExpansionTile(
                  title: Text(newText),
                  children: <Widget>[
                    ListTile(
                      title: Text('Alert'),
                      onTap: (){
                        setState((){
                          type = MessageType.alert;
                          newText = 'Alert';
                        });
                      },
                    ),
                    ListTile(
                      title: Text('Question'),
                      onTap: (){
                        setState((){
                          type = MessageType.question;
                          newText = 'Question';
                        });
                      },
                    ),
                    // ListTile(
                    //   title: Text('Purchase'),
                    //   onTap: (){type = MessageType.purchase;},
                    // ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: (){
                  print(type);
                  context.read<MessagingBloc>().add(CreateMessage(Message('NewMessage', creator, body.text, type)));
                }, 
                child: Text('Post')
              ),
            ],),
        ),
      );
      }
    );
  }
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
              onPressed: (){
                showDialog(
                  context: context, 
                  builder: (_) => BlocProvider<MessagingBloc>.value(
                    value: BlocProvider.of<MessagingBloc>(context),
                    child: CreateMessageModal(),));
              },
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

            return Container(
              child: Text('There are no messages for this home.'),
            );
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
    else if(message.type == MessageType.question)
    {
        
        return QuestionWidget(message);
    }
    else if(message.type == MessageType.purchase)
    {
      return PurchaseWidget(message);
    }
    else
    {
      return Text('*Invalid Message type*');
    }

  }

}

// TODO: I plan to better generalize the widgets so its neater.
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
              Expanded(child: Text(message.body)),
              // TODO: Need to figure out why the icons dont align. Wtf?            
              IconButton(
                  icon: Icon(Icons.remove_circle_outline_outlined), 
                  onPressed: (){ context.read<MessagingBloc>().add(DeleteMessage(message));}
                ),    
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

class CreateResponseDialog extends StatelessWidget {
  
  final targetId;

  const CreateResponseDialog(this.targetId);

  @override
  Widget build(BuildContext context) {

    final String creator = context.read<AuthenticationBloc>().state.user.email;

    return AlertDialog(
      title: Text('Replying to Question'),
      content: Container(
        alignment:  Alignment.center,
        height: 200,
        width: 300,
        child: Column(
          children: [
            // TODO: Need to make this textfield more noticable.
            TextField(
              onSubmitted: (body) {
                context.read<MessagingBloc>().add(RespondToQuestion(targetId, creator, body));
                
              },
            ),

          ],
        ),
      ),
    );
  }


}

class QuestionWidget extends StatelessWidget {

  final Message message;

  QuestionWidget(this.message);
    
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
          Text(''),
          // Make button textbox appear and then allow input to submit...
          ElevatedButton(
            onPressed: (){ showDialog(
              context: context, 
              builder: (_) => BlocProvider<MessagingBloc>.value(
                    value: BlocProvider.of<MessagingBloc>(context),
                    child: CreateResponseDialog(message.id),));},

            child: Text('Create Response')),
        ],
      ),
      );
  }

}

// Can have it take fields like 'What was bought:' 'Cost:' 'Who owes'
// Then this will create a message formatted using those fields.
class PurchaseWidget extends StatelessWidget {

  final Message message;

  PurchaseWidget(this.message);

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