
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:linguashelf_mobile/widgets/extendederrordialog.dart';

import 'thema.dart';
import 'widgets/styledtext.dart';

class LimitationErrorDialog extends ExtendedErrorDialog {
  LimitationErrorDialog({Key? key, required String title, required String message}) : super(key: key, title: title, message: message);

  List<Widget> actions(BuildContext context) {
    return [
      MaterialButton(
        onPressed: () {
          Navigator.pushNamed(context, "premium");
        },
        child: StyledText.color('Get Premium', Thema.buttonTextColor),
        color: Thema.buttonColor,
        textColor: Thema.buttonTextColor,
      ),
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

}