import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Styles {

  static TextStyle getTextStyle({Color color = Colors.black, double fontSize = 15.0, double height = 1.0,
    FontWeight fontWeight = FontWeight.normal, Color backgroundColor = Colors.transparent, TextDecoration decoration = TextDecoration.none, FontStyle fontStyle = FontStyle.normal})
  {
    return GoogleFonts.openSans(fontSize: fontSize, color: color, fontWeight: fontWeight, backgroundColor: backgroundColor, decoration: decoration, fontStyle: fontStyle);
  }
}