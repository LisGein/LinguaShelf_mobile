import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../styles.dart';


class LsText extends StatelessWidget {
  LsText(this.text, {this.style});

  String text;
  TextStyle? style;

  @override
  Widget build(BuildContext context) {
    style ??= Styles.getTextStyle();
    return Text(text, style: style);
  }

}


class LsWhiteText extends LsText {
  LsWhiteText(String text) : super(text, style: Styles.getTextStyle(color: Colors.white));

}