import 'package:flutter/material.dart';
import 'package:roomiesMobile/presentation/themes/primary_theme/colors.dart';

class ConfirmationDialog extends StatefulWidget {

  final Widget title;
  final Widget snippet;
  final VoidCallback onConfirm;
  final Widget confirmWidget;
  final Widget cancelWidget;

  ConfirmationDialog({
    Key key,
    @required this.onConfirm,
    this.title = const Text('Confirmation'),
    this.snippet = const Text(''),
    this.confirmWidget = const Text('Confirm', style: const TextStyle(color: Colors.black,)),
    this.cancelWidget = const Text('Cancel', style: const TextStyle(color: Colors.black,)),
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ConfirmationDialogState();
}

class _ConfirmationDialogState extends State<ConfirmationDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      buttonPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      title: Center( child: widget.title),
      content: SingleChildScrollView(
        child: Center(
          child: widget.snippet,
        ),
      ),
      actions: <Widget>[
        FloatingActionButton.extended(
          heroTag: null,
          onPressed: () => widget.onConfirm(),
          label: widget.confirmWidget,
          backgroundColor: CustomColors.gold,
          shape: RoundedRectangleBorder(
            side: BorderSide(),
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
        ),
        FloatingActionButton.extended(
          heroTag: null,
          onPressed: () {
            Navigator.pop(context);
          },
          label: widget.cancelWidget,
          backgroundColor: CustomColors.gold,
          shape: RoundedRectangleBorder(
            side: BorderSide(),
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
        ),
      ],
    );
  }
}
