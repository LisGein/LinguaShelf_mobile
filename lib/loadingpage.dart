import 'package:flutter/material.dart';

import 'basepage.dart';
import 'lswidgets/lstext.dart';
import 'styles.dart';

class LoadingPage extends BasePage {
  const LoadingPage({Key? key}) : super(key: key);

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
