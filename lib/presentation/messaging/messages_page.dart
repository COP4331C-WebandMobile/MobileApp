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
import 'package:roomiesMobile/widgets/ConfirmationDialog.dart';
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
    var creator = context.read<AuthenticationBloc>().state.user.email;
    final body = TextEditingController();
    MessageType type = MessageType.alert;
    String newText = 'Alert';

    return StatefulBuilder(builder: (context, setState) {
      return AlertDialog(
        actions: [
          FloatingActionButton.extended(
            heroTag: null,
            onPressed: () {
              creator = type == MessageType.anonymous ? 'Anonymous' : creator;

              final Message newMessage =
                  Message('', creator, body.text, type);

              context.read<MessagingBloc>().add(CreateMessage(newMessage));
              Navigator.pop(context);
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
                margin: EdgeInsets.symmetric(horizontal: 40),
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
                    ListTile(
                      title: Text('Anonymous'),
                      onTap: () {
                        setState(() {
                          type = MessageType.anonymous;
                          newText = 'Anonymous';
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
                                              ..showSnackBar(const SnackBar(
                                                padding: EdgeInsets.only(
                                                    left: 20, right: 20),
                                                duration: Duration(
                                                    seconds: 1,
                                                    milliseconds: 250),
                                                backgroundColor: Colors.black,
                                                behavior:
                                                    SnackBarBehavior.floating,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.elliptical(
                                                                5, 5))),
                                                content: Text(
                                                  'There are no messages in this house...',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: CustomColors.gold,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
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
            child: Text('There are no messages, try creating one!'),
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
            child: 
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(16)),
              child:
            ExpansionTile(
              title: Text('Responses', style: TextStyle(color: Colors.black),),
              children: [
                BlocBuilder<ResponsesBloc, ResponsesState>(
                  buildWhen: (previous, current) {
                    return current.associatedMessage == message.id;
                  },
                  builder: (context, state) {
                    if (state is SuccessfullyRetreivedResponses && state.associatedMessage == message.id) {
                      
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

                          return ResponseWidget(state.responses[i]);
                        },
                      );
                    }

                    if (state is NoResponsesFound) {
                      return Center(
                          child: Text(
                              'There are no responses to this message...'));
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
            )),
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
    } 
    else if(message.type == MessageType.purchase)
    {
      return AnimatedMessage(
        message: message,

      );
    }
    else if(message.type == MessageType.anonymous)
    {
      return AnimatedMessage(
        message: message,
      );
    }
    else {
      return Container();
    }
  }
}

class ResponseWidget extends StatelessWidget {
  final Response response;

  const ResponseWidget(this.response);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade700,
            offset: Offset(0.0, 3.0),
            blurRadius: 6.0,
          )
        ],
        color: Colors.black,
        borderRadius: BorderRadius.all(Radius.circular(16)),
        border: Border.all(color: CustomColors.gold, width: 2)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(border: Border.all(color: CustomColors.gold)),
          child:Text('${response.body}', style: TextStyle(color: Colors.white),)),
        Text('${response.creator}', style: TextStyle(color: Colors.white),),
        Text('${UtilityFunctions.formatDate(response.postedTime.toDate())} ${UtilityFunctions.formatTime(response.postedTime.toDate())}', style: TextStyle(color: Colors.white),),


        
      ],),
    );
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
    }
    else if (widget.message.type == MessageType.purchase)
    {
      return Icon(Icons.attach_money);
    }
    else if (widget.message.type == MessageType.question)
    {
      return Icon(Icons.question_answer_rounded);
    }
    else
    {
      return Icon(Icons.theater_comedy);
    }
  }

  String _getTypeName() {
    if (widget.message.type == MessageType.alert) {
      return 'Alert';
    } 
    else if(widget.message.type == MessageType.purchase)
    {
      return 'Purchase';
    }
    else if(widget.message.type == MessageType.question){
      return 'Question';
    }
    else
    {
      return 'Anonymous';
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
                                child: Container(
                                    padding: EdgeInsets.only(top: 5, right: 5),
                                    child: Text(
                                      '${widget.message.creator}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ))),
                            Expanded(
                              child: Container(
                                  padding: EdgeInsets.only(top: 5),
                                  child: Text(
                                      '${UtilityFunctions.formatDate(widget.message.date.toDate())} ${UtilityFunctions.formatTime(widget.message.date.toDate())}')),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                      ],
                    )),
                Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipOval(
                            child: Material(
                          color: Colors.black,
                          child: InkWell(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (_) =>
                                      BlocProvider<MessagingBloc>.value(
                                        value: BlocProvider.of<MessagingBloc>(
                                            context),
                                        child: ConfirmationDialog(
                                          snippet: const Text(
                                              'Are you sure you want to delete this message?'),
                                          onConfirm: () {
                                            context.read<MessagingBloc>().add(
                                                DeleteMessage(widget.message));

                                            if(widget.message.type == MessageType.question)
                                            {
                                              context.read<ResponsesBloc>().add(UnsubscribeFromResponses(widget.message.id));
                                            }

                                            Navigator.pop(context);
                                          },
                                        ),
                                      ));
                            },
                            splashColor: Colors.white,
                            child: SizedBox(
                              height: 32,
                              width: 32,
                              child: Stack(
                                alignment: AlignmentDirectional.center,
                                children: [
                                  //const Icon(Icons.circle,),
                                  const Icon(
                                    Icons.close,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )),
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
