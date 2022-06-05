import 'dart:developer' as developer;

import 'package:flutter/cupertino.dart';

enum Sender { user, ai }

class ChatMessage {
  ChatMessage({required this.sender, required this.texts});

  void addCorrections(Text text) {
    if (texts.length == 2) {
     texts[1] = text;
    }
    else if (texts.length == 1) {
      texts.add(text);
    } else {
      developer.log("Unexpected number of chat messages! Length: " +
          texts.length.toString());
    }
  }

  Sender sender;
  List<Text> texts;
}