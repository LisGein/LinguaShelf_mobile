import 'package:flutter/material.dart';

import '../thema.dart';
import 'styledtext.dart';

// ignore: must_be_immutable
class ExtendedErrorDialog extends StatelessWidget {
  ExtendedErrorDialog({Key? key, required this.title, required this.message})
      : super(key: key);

  String title;
  String message;

  List<Widget> actions(BuildContext context) {
    return [
      MaterialButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: StyledText.color('Ok', Thema.buttonInvertedTextColor),
        color: Thema.buttonInvertedColor,
        textColor: Thema.buttonInvertedTextColor,
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: StyledText.size(title, 24),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[StyledText.size(message, 18)],
        ),
      ),
      actions: actions(context),
    );
  }
}
