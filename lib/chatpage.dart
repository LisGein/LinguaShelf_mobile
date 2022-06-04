import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'applicationstate.dart';
import 'openai/chatmessagestyle.dart';
import 'openai/opanai.dart';
import 'pair.dart';
import 'styles.dart';

// ignore: must_be_immutable
class ChatPage extends StatefulWidget {
  ChatPage({Key? key, required this.firstQuestion}) : super(key: key) {
    context = firstQuestion;
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

  List<ChatMessageStyle> chat = [];

  void correctMessage(OpenAI openAI, String text, int messageIndex) async {
    String corrections = await openAI.editMessage(text);
    var pair = Pair(
        Styles.getTextStyle(
            fontStyle: FontStyle.italic,
            color: const Color.fromARGB(255, 91, 92, 94)),
        "\n___________\n''" + corrections + "''");
    setState(() {
      if (chat[messageIndex].styleToText.length == 2) {
        chat[messageIndex].styleToText[1] = pair;
      } else if (chat[messageIndex].styleToText.length == 1) {
        chat[messageIndex].styleToText.add(pair);
      } else {
        developer.log("Unexpected number of chat messages! Length: " +
            chat[messageIndex].styleToText.length.toString());
      }
    });
  }

  Widget userInput(OpenAI openAI) {
    return Card(
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                  style: Styles.getTextStyle(),
                  autocorrect: false,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  controller: promptController,
                  decoration: const InputDecoration(
                    hintText: "Enter your answer",
                  )),
            ),
          ),
          Expanded(
            flex: 1,
            child: MaterialButton(
              onPressed: () async {
                var text = promptController.text;

                widget.context += " Der Benutzer antwortet: \"" + text;
                if (!text.trim().endsWith(".") && (!text.trim().endsWith("?")) && (!text.trim().endsWith("!"))) {
                  widget.context += ".";
                }

                widget.context += "\"";
                var answer = await openAI.completeStoryByContext(widget.context);

                widget.context += answer;

                setState(() {
                  chat.add(ChatMessageStyle(
                      sender: Sender.user,
                      styleToText: [Pair(Styles.getTextStyle(), text)]));
                  correctMessage(openAI, text, chat.length - 1);
                  promptController.clear();
                  chat.add(ChatMessageStyle(
                      sender: Sender.ai,
                      styleToText: [Pair(Styles.getTextStyle(), answer)]));
                });
              },
              child: const Text('Send'),
              color: Colors.blue,
              textColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _messageRectangle(List<Pair> texts, Sender sender) {
    var alignment =
        sender == Sender.ai ? Alignment.topLeft : Alignment.topRight;

    List<Text> messageParts = [];

    for (var text in texts) {
      messageParts.add(Text(text.right, style: text.left));
      developer.log(text.left);
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
              flex: alignment == Alignment.topRight ? 2 : 0,
              child: Container()),
          Expanded(
            flex: 8,
            child: Container(
                alignment: alignment,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(children: messageParts),
                ),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        Colors.lightBlueAccent,
                        Colors.blueAccent,
                      ]),
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                )),
          ),
          Expanded(
              flex: alignment == Alignment.topRight ? 0 : 2, child: Container())
        ],
      ),
    );
  }

  Widget chatViewer() {
    List<Widget> w = [
      _messageRectangle(
          [Pair(Styles.getTextStyle(), widget.firstQuestion)], Sender.ai)
    ];
    for (var textSettings in chat) {
      if (textSettings.styleToText.isNotEmpty) {
        w.add(_messageRectangle(textSettings.styleToText, textSettings.sender));
      }
    }

    return Container(
      alignment: Alignment.bottomCenter,
      decoration: const BoxDecoration(
          gradient: LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [
          Color.fromARGB(250, 0, 87, 183),
          Color.fromARGB(250, 252, 136, 3),
        ],
      )),
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: w.length,
        itemBuilder: (BuildContext context, int index) {
          return w[index];
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ApplicationState>(
      builder: (context, appState, _) {
        return Container(
          alignment: Alignment.center,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color.fromARGB(250, 0, 87, 183),
              Color.fromARGB(250, 252, 136, 3),
            ],
          )),
          child: Scaffold(
            body: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(flex: 10, child: chatViewer()),
                    if (appState.openAI != null) userInput(appState.openAI!),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
