import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messaging_repository/messaging_repository.dart';
import 'package:roomiesMobile/business_logic/authentication/bloc/authentication_bloc.dart';
import 'package:roomiesMobile/business_logic/landing/cubit/landing_cubit.dart';
import 'package:roomiesMobile/business_logic/messages/bloc/responses_bloc.dart';
import 'package:roomiesMobile/business_logic/messages/messaging/messaging_bloc.dart';
import 'package:roomiesMobile/presentation/themes/primary_theme/colors.dart';
import 'package:roomiesMobile/utils/utility_functions.dart';
import 'package:roomiesMobile/widgets/home/new_sidebar.dart';
import 'package:roomiesMobile/widgets/messages/message_card.dart';

class TestMessagePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String houseName = context.read<LandingCubit>().state.home;

    final FirebaseMessageRepository messageRepository =
        FirebaseMessageRepository(houseName: houseName);

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => MessagingBloc(messageRepository),
        ),
        BlocProvider(
          create: (context) => ResponsesBloc(messageRepository),
        )
      ],
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
    MessageType type = MessageType.alert;
    String newText = 'Alert';

    return StatefulBuilder(builder: (context, setState) {
      return AlertDialog(
        actions: [
          FloatingActionButton.extended(
            heroTag: null,
            onPressed: () {
              final Message newMessage =
                  Message('Temp', creator, body.text, type);

              context.read<MessagingBloc>().add(CreateMessage(newMessage));
            },
            label: Text('Post'),
          ),
          FloatingActionButton.extended(
            heroTag: null,
            onPressed: () {
              Navigator.pop(context);
            },
            label: Text('Cancel'),
          ),
        ],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: Colors.white,
        title: Center(
            child: Text(
          'Create New Message',
          style: TextStyle(color: Colors.black),
        )),
        titlePadding: EdgeInsets.all(8),
        contentPadding: EdgeInsets.all(0),
        content: Container(
          margin: EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.yellow.shade200,
            //borderRadius: BorderRadius.only(bottomLeft: Radius.circular(32), bottomRight: Radius.circular(32)),
          ),
          //color: Colors.yellow.shade200,
          height: MediaQuery.of(context).size.height / 3,
          child: SingleChildScrollView(
              child: Column(
            children: [
              Container(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: TextField(
                    keyboardType: TextInputType.text,
                    onSubmitted: (value) {},
                    maxLines: 3,
                    maxLength: 150,
                    textAlign: TextAlign.start,
                    textAlignVertical: TextAlignVertical.top,
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    controller: body,
                    decoration: InputDecoration(
                      isDense: true,
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                      labelText: 'Message',
                      helperText: '',
                      hintText: 'I have a test today!',
                    ),
                  )),
              Card(
                margin: EdgeInsets.symmetric(horizontal: 60),
                child: ExpansionTile(
                  title: Text(newText),
                  children: <Widget>[
                    ListTile(
                      title: Text('Alert'),
                      onTap: () {
                        setState(() {
                          type = MessageType.alert;
                          newText = 'Alert';
                        });
                      },
                    ),
                    ListTile(
                      title: Text('Question'),
                      onTap: () {
                        setState(() {
                          type = MessageType.question;
                          newText = 'Question';
                        });
                      },
                    ),
                    ListTile(
                      title: Text('Purchase'),
                      onTap: () {
                        setState(() {
                          type = MessageType.purchase;
                          newText = 'Purchase';
                        });
                      },
                    ),
                  ],
                ),
              ),
              // ElevatedButton(
              //     onPressed: () {
              //       print(type);
              //       context.read<MessagingBloc>().add(CreateMessage(
              //           Message('NewMessage', creator, body.text, type)));
              //     },
              //     child: Text('Post')),
            ],
          )),
        ),
      );
    });
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
            alignment: Alignment.bottomRight,
            padding: EdgeInsets.all(4),
            child: FloatingActionButton(
              key: const Key('messagePage_add_FAB'),
              child: const Icon(
                Icons.add,
                size: 32,
              ),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (_) => BlocProvider<MessagingBloc>.value(
                          value: BlocProvider.of<MessagingBloc>(context),
                          child: CreateMessageModal(),
                        ));
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
          if (state is NoMessages) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(
                content: Text(state.errorMessage),
              ));
          }
        }, builder: (context, state) {
          if (state is MessagingLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is MessagesLoaded) {
            return MessagesList(state.messages);
          }

          return Container(
            child: Text('There are no messages for this home.'),
          );
        }),
      ),
      // Temporarily using SideBar until We decide what will be there.
      drawer: NewSideBar(),
    );
  }
}

class MessagesList extends StatelessWidget {
  final List<Message> messages;

  MessagesList(this.messages);

  @override
  Widget build(BuildContext context) {
    // ignore: missing_return
    messages.sort((m1, m2) {
      int compare = m1.date.compareTo(m2.date);

      if (compare < 0) return 1;

      if (compare > 0) return -1;

      if (compare == 0) {
        if (m1.type.index < m2.type.index) {
          return -1;
        } else if (m1.type == m2.type) {
          return 0;
        }

        return 1;
      }
    });

    return ListView.builder(
      itemCount: messages.length,
      itemBuilder: (BuildContext context, i) {
        return Padding(
          padding: EdgeInsets.all(16),
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
    if (message.type == MessageType.alert) {
      return AnimatedMessage(
        message: message,
      );
    } else if (message.type == MessageType.question) {
      return AnimatedMessage(
        message: message,
        child: Column(children: [
          Card(
            margin: EdgeInsets.symmetric(
              vertical: 16,
            ),
            child: ExpansionTile(
              title: Text('Responses'),
              children: [
                BlocBuilder<ResponsesBloc, ResponsesState>(
                  buildWhen: (previous, current) {
                    return current.associatedMessage == message.id;
                  },
                  builder: (context, state) {
                    if (state is NoResponsesFound) {
                      return Center(
                          child: Text(
                              'There are no responses to this message...'));
                    }
                    if (state is SuccessfullyRetreivedResponses) {
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: state.responses.length,
                        itemBuilder: (context, i) {
                          state.responses.sort((r1, r2) {
                            if (r1.postedTime.millisecondsSinceEpoch <
                                r2.postedTime.millisecondsSinceEpoch) {
                              return 1;
                            } else if (r1.postedTime == r2.postedTime) {
                              return 0;
                            } else {
                              return -1;
                            }
                          });

                          return ListTile(
                            leading: Text('${state.responses[i].creator}'),
                            title: Text('${state.responses[i].body}'),
                          );
                        },
                      );
                    }

                    return Container();
                  },
                )
              ],
              onExpansionChanged: (opened) {
                if (opened) {
                  context
                      .read<ResponsesBloc>()
                      .add(SubsribedToResponses(message.id));
                } else {
                  context
                      .read<ResponsesBloc>()
                      .add(UnsubscribeFromResponses(message.id));
                }
              },
            ),
          ),
          FloatingActionButton.extended(
            label: const Text('Respond'),
            heroTag: null,
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => BlocProvider<MessagingBloc>.value(
                  value: BlocProvider.of<MessagingBloc>(context),
                  child: CreateResponseDialog(message.id),
                ),
              );
            },
          ),
        ]),
      );
    } else if (message.type == MessageType.purchase) {
      return PurchaseWidget(message);
    } else {
      return Container();
    }
  }
}

class CreateResponseDialog extends StatelessWidget {
  final targetId;

  const CreateResponseDialog(this.targetId);

  @override
  Widget build(BuildContext context) {
    final String creator = context.read<AuthenticationBloc>().state.user.email;
    final body = TextEditingController();
    return AlertDialog(
      title: Text(
        'Replying to Question',
        textAlign: TextAlign.center,
      ),
      content: Container(
        alignment: Alignment.center,
        height: 300,
        width: 300,
        padding: EdgeInsets.all(0),
        child: Column(
          children: [
            Container(
                padding:
                    EdgeInsets.only(bottom: 100, left: 20, right: 20, top: 40),
                color: Colors.yellow.shade200,
                child: TextField(
                  keyboardType: TextInputType.text,
                  onSubmitted: (value) {},
                  maxLines: 2,
                  maxLength: 150,
                  textAlign: TextAlign.start,
                  controller: body,
                  textAlignVertical: TextAlignVertical.top,
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  decoration: InputDecoration(
                    isDense: true,
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                    labelText: 'Message',
                    helperText: '',
                    hintText: 'Yeah',
                  ),
                )),
            Container(
                padding: EdgeInsets.only(top: 20),
                child: FloatingActionButton.extended(
                  heroTag: null,
                  onPressed: () {
                    context
                        .read<MessagingBloc>()
                        .add(RespondToQuestion(targetId, creator, body.text));
                    Navigator.pop(context);
                  },
                  label: Text('Post'),
                ))
          ],
        ),
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
              const SizedBox(
                width: 8,
              ),
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
        border: Border.all(
          color: Colors.black,
        ),
      ),
    );
  }
}

class AnimatedMessage extends StatefulWidget {
  final Message message;
  final Widget child;

  AnimatedMessage({
    this.message,
    this.child = const Text(''),
  });

  State<StatefulWidget> createState() => AnimatedMessageState();
}

class AnimatedMessageState extends State<AnimatedMessage> {
  Icon _setProperIcon() {
    if (widget.message.type == MessageType.alert) {
      return Icon(Icons.notification_important);
    } else {
      return Icon(Icons.read_more);
    }
  }

  String _getTypeName() {
    if (widget.message.type == MessageType.alert) {
      return 'Alert';
    } else {
      return 'Question';
    }
  }

  @override
  Widget build(BuildContext context) {
    Icon icon = _setProperIcon();

    return Stack(children: [
      Card(
        color: CustomColors.gold,
        elevation: 8,
        margin: EdgeInsets.all(16),
        child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.black,
                            radius: 16,
                            child: icon),
                      ],
                    )),
                Expanded(
                    flex: 6,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                    
                        const SizedBox(
                          height: 16,
                        ),
                        Container(
                          padding: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          child: Text('${widget.message.body}'),
                        ),
                        widget.child,
                            Row(
                          children: [
                            Expanded(
                                flex: 2,
                                child: Text(
                                  '${widget.message.creator}',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                            Expanded(
                                flex: 0,
                                child: Text(
                                    '${UtilityFunctions.formatDate(widget.message.date.toDate())} ${UtilityFunctions.formatTime(widget.message.date.toDate())}')),
                          ],
                        ),
<<<<<<< HEAD
=======
                        const SizedBox(
                          height: 16,
                        ),
                        Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          child: Text('${widget.message.body}'),
                        ),
                        widget.child
>>>>>>> 787fea6cca66b153bc23ae98ed4f2bcbf08799e7
                      ],
                    )),
              ],
            )),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(36))),
      ),
      Align(
        alignment: Alignment.topCenter,
        child: Container(
            height: 40,
            width: MediaQuery.of(context).size.width / 3,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade700,
                  offset: Offset(0.0, 3.0),
                  blurRadius: 6.0,
                )
              ],
              color: Colors.black,
              borderRadius: BorderRadius.all(Radius.circular(36)),
            ),
            child: Center(
              child: Text(
                '${_getTypeName()}',
                style: TextStyle(
                    color: Colors.white, fontSize: 18, letterSpacing: 1),
              ),
            )),
      ),
    ]);
  }
}
