import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../applicationstate.dart';
import '../openai/chatmessagestyle.dart';
import '../openai/opanai.dart';
import '../styles.dart';
import '../thema.dart';
import '../widgets/chatviewer.dart';

// ignore: must_be_immutable
class ChatPage extends StatefulWidget {
  ChatPage({Key? key, required this.firstQuestion}) : super(key: key) {
    context = firstQuestion;
    addMessage(Sender.ai, Styles.getTextStyle(color: Thema.messageTextColor), firstQuestion);
  }

  List<ChatMessage> messages = [];

  void addMessage(Sender sender, TextStyle style, String text) {
    var message =
    ChatMessage(sender: sender, texts: [Text(text, style: style)]);
    messages.add(message);
  }

  void addCorrectionsToMessage(TextStyle style, String text, int messageIndex) {
    if (messageIndex < 0) {
      developer.log("Trying to add corrections to messages, when there are no messages");
      return;
    }
    messages[messageIndex].addCorrections(Text(text, style: style));
  }

  final String firstQuestion;


  String context = "";

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final promptController = TextEditingController();
  String generated = "";
  int tokens = 50;

  OpenAI? openAi;

  void correctMessage(OpenAI openAI, String text, int messageIndex) async {
    String corrections = await openAI.editMessage(text);

    setState(() {
      var style = Styles.getTextStyle(
          fontStyle: FontStyle.italic,
          color: Thema.messageCorrectionsTextColor);
      widget.addCorrectionsToMessage(style, "\n___________\n''" + corrections + "''", messageIndex);

    });
  }

  Future<void> onEnter(String text) async {
    if (openAi == null) {
      developer.log("OpenAi is not loaded!");
      return;
    }

    widget.context += " Der Benutzer antwortet: \"" + text;
    if (!text.trim().endsWith(".") && (!text.trim().endsWith("?")) &&
        (!text.trim().endsWith("!"))) {
      widget.context += ".";
    }

    widget.context += "\"";
    var answer = await openAi!.completeStoryByContext(widget.context);

    widget.context += answer;

    setState(() {
      widget.addMessage(Sender.user, Styles.getTextStyle(color: Thema.messageTextColor), text);

      int messageIndex = widget.messages.length - 1;

      correctMessage(openAi!, text, messageIndex);
      promptController.clear();
      widget.addMessage(Sender.ai, Styles.getTextStyle(color: Thema.messageTextColor), answer);

    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ApplicationState>(
      builder: (context, appState, _) {
        openAi = appState.openAI;
        return ChatViewer(messages: widget.messages, promptController: promptController, onEnter: onEnter);
      },
    );
  }
}
