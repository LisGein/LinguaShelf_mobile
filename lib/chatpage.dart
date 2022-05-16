import 'package:batut_de/pair.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'opanai.dart';

class ChatPage extends StatefulWidget {
  ChatPage({required this.firstQuestion});

  String firstQuestion;
  var openAI = OpenAI();

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final promptController = TextEditingController();
  String generated = "";
  int tokens = 50;

  List<Pair> chat = [];

  Widget userInput() {
    return Card(
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  controller: promptController,
                  decoration: InputDecoration(
                    hintText: "Enter your answer",
                  )),
            ),
          ),
          Expanded(
            flex: 1,
            child: MaterialButton(
              onPressed: () async {
                chat.add(Pair("User", promptController.text));
                promptController.clear();
                String complete =
                    await widget.openAI.orderInRestaurant(promptController.text);
                setState(() {
                  chat.add(Pair("AI", complete));
                });
              },
              child: Text('Send'),
              color: Colors.blue,
              textColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _messageRectangle(String text, Alignment alignment) {
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
                  child: Text(text),
                ),
                decoration: new BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                      colors: [
                        Colors.lightBlueAccent,
                        Colors.blueAccent,
                      ]
                  ),
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                )),
          ),
          Expanded(
              flex: alignment == Alignment.topRight ? 0 : 2,
              child: Container())
        ],
      ),
    );
  }

  Widget chatViewer() {
    List<Widget> w = [_messageRectangle(widget.firstQuestion, Alignment.topLeft)];
    for (var message in chat) {
      var alignment = message.left == "AI" ? Alignment.topLeft : Alignment.topRight;
      if (message.right.toString().isNotEmpty) {
        w.add(_messageRectangle(message.right, alignment));
      }
    }

    return Column(
      children: w,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            chatViewer(),
            userInput(),
            Text(generated),
          ],
        ),
      ),
    );
  }
}
