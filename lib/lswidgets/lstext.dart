import 'package:flutter/material.dart';

import '../pair.dart';
import '../styles.dart';


// ignore: must_be_immutable
class LsText extends StatelessWidget {
  LsText(this.text, {Key? key, this.style}) : super(key: key);

  final String text;
  TextStyle? style;

  @override
  Widget build(BuildContext context) {
    style ??= Styles.getTextStyle();
    return Text(text, style: style);
  }

}


// ignore: must_be_immutable
class LsWhiteText extends LsText {
  LsWhiteText.pair(Pair text, {Key? key}) : super(text.right, key: key, style: Styles.getTextStyle(color: Colors.white));
  LsWhiteText(String text, {Key? key}) : super(text, key: key, style: Styles.getTextStyle(color: Colors.white));

}