import 'package:flutter/material.dart';

import 'basepage.dart';
import '../styles.dart';
import '../widgets/styledtext.dart';

class UnknownPage extends BasePage {
  const UnknownPage({Key? key}) : super(key: key);

  @override
  Widget buildBody(BuildContext context) {
    return StyledText(
      'This page does not exists!',
      style: Styles.getTextStyle(
        fontSize: 15.0,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }
}
