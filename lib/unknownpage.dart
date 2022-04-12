import 'package:batut_de/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../basepage.dart';

class UnknownPage extends BasePage {
  @override
  Widget buildBody(BuildContext context) {
    return Text(
      'This page does not exists!',
      style: Styles.getTextStyle(
        fontSize: 15.0,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }
}