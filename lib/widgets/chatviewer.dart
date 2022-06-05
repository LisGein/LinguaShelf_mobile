import 'package:flutter/material.dart';

import '../openai/chatmessagestyle.dart';
import '../thema.dart';
import '../styles.dart';

// ignore: must_be_immutable
class ChatViewer extends StatelessWidget {
  ChatViewer(
      {Key? key,
      required this.messages,
      required this.promptController,
      required this.onEnter})
      : super(key: key);

  List<ChatMessage> messages;
  TextEditingController promptController;
  Future<void> Function(String text) onEnter;

  Widget _messageRectangle(ChatMessage message) {
    List<Color> messageColors = [];
    var alignment = Alignment.topLeft;
    int topFlex = 0;
    int bottomFlex = 2;

    if (message.sender == Sender.ai) {
      messageColors = [
        Thema.topMessageColorAi,
        Thema.bottomMessageColorAi
      ];
    } else {
      alignment = Alignment.topRight;
      messageColors = [
        Thema.topMessageColorUser,
        Thema.bottomMessageColorUser
      ];

      topFlex = topFlex + bottomFlex;
      bottomFlex = topFlex - bottomFlex;
      topFlex = topFlex - bottomFlex;
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(flex: topFlex, child: Container()),
          Expanded(
            flex: 8,
            child: Container(
                alignment: alignment,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(children: message.texts),
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: messageColors),
                  shape: BoxShape.rectangle,
                  borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                )),
          ),
          Expanded(flex: bottomFlex, child: Container())
        ],
      ),
    );
  }

  Widget _listViewOfMessages() {
    List<Widget> w = [];
    for (var m in messages) {
      w.add(_messageRectangle(m));
    }

    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: w.length,
      itemBuilder: (BuildContext context, int index) {
        return w[index];
      },
    );
  }

  Widget _userInput() {
    return Card(
      child: Row(
        children: [
          Expanded(
            flex: 6,
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: MaterialButton(
              onPressed: () async {
                onEnter(promptController.text);
              },
              child: const Text('Send'),
              color: Thema.buttonColor,
              textColor: Thema.buttonTextColor,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Thema.topBaseColor,
                Thema.bottomBaseColor,
              ],
            )),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(flex: 10, child: _listViewOfMessages()),
            _userInput(),
          ],
        ),
      ),
    );
  }
}
