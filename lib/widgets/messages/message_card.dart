import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:roomiesMobile/presentation/themes/primary_theme/colors.dart';


class MessageCard extends StatefulWidget {

  final Widget child;
  final Border borderStyle;

  MessageCard({Key key, @required this.child, this.borderStyle}) : super(key: key);

  @override
  _MessageCardState createState() => _MessageCardState();

}

class _MessageCardState extends State<MessageCard> {

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          margin: EdgeInsets.all(8),
          child: Container(
            padding: EdgeInsets.all(4),
            child: widget.child,
            decoration: BoxDecoration(
              color: CustomColors.gold,
              border: widget.borderStyle ?? Border.all(),
              borderRadius: BorderRadius.circular(16)
            ),
          ),
        )
      ],

    );
  }

}