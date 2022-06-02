import 'package:LinguaShelf_mobile/styles.dart';
import 'package:flutter/material.dart';

import 'LsWidgets/lstext.dart';
import 'basepage.dart';

class LoadingPage extends BasePage {
  @override
  Widget buildBody(BuildContext context) {
    return LsText(
      'Loading...',
      style: Styles.getTextStyle(
        fontSize: 15.0,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }
}
