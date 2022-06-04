import 'package:flutter/material.dart';

import 'basepage.dart';
import '../widgets/styledtext.dart';
import '../styles.dart';

class LoadingPage extends BasePage {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  Widget buildBody(BuildContext context) {
    return StyledText(
      'Loading...',
      style: Styles.getTextStyle(
        fontSize: 15.0,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }
}
