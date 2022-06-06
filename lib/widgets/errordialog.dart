import 'package:flutter/material.dart';

import 'styledtext.dart';

// ignore: must_be_immutable
class ErrorDialog extends StatelessWidget {
  ErrorDialog({Key? key, required this.title, required this.message})
      : super(key: key);

  String title;
  String message;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: StyledText.size(title, 24),

      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            StyledText.size(message, 18)
          ],
        ),
      ),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: StyledText('Ok'),
        ),
      ],
    );
  }
}
