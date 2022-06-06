import 'package:flutter/material.dart';

import '../pair.dart';
import '../styles.dart';
import '../thema.dart';


// ignore: must_be_immutable
class StyledText extends StatelessWidget {
  StyledText(this.text, {Key? key, this.style}) : super(key: key);
  StyledText.color(this.text, Color color, {Key? key}) : super(key: key) {
    style = Styles.getTextStyle(color: color);
  }
  StyledText.size(this.text, double fontSize, {Key? key}) : super(key: key) {
    style = Styles.getTextStyle(fontSize: fontSize);
  }

  final String text;
  TextStyle? style;

  @override
  Widget build(BuildContext context) {
    style ??= Styles.getTextStyle(color: Thema.appTextColor);
    return Text(text, style: style);
  }

}


// ignore: must_be_immutable
class StyledWhiteText extends StyledText {
  StyledWhiteText.pair(Pair text, {Key? key}) : super(text.right, key: key, style: Styles.getTextStyle(color: Colors.white));
  StyledWhiteText(String text, {Key? key}) : super(text, key: key, style: Styles.getTextStyle(color: Colors.white));

}