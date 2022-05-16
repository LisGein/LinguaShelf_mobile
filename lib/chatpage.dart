import 'package:batut_de/pair.dart';
import 'package:batut_de/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'applicationstate.dart';
import 'opanai.dart';

class ChatPage extends StatefulWidget {
  ChatPage({required this.firstQuestion});

  String firstQuestion;

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final promptController = TextEditingController();
  String generated = "";
  int tokens = 50;

  List<Pair> chat = [];

  Widget userInput(OpenAI openAI) {
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
                var text = promptController.text;

                String complete = await openAI.orderInRestaurant(text);
                setState(() {
                  chat.add(Pair("User", text));
                  promptController.clear();
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
                  child: Text(text, style: Styles.getTextStyle(),),
                ),
                decoration: new BoxDecoration(
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
      _messageRectangle(widget.firstQuestion, Alignment.topLeft)
    ];
    for (var message in chat) {
      var alignment =
      message.left == "AI" ? Alignment.topLeft : Alignment.topRight;
      if (message.right
          .toString()
          .isNotEmpty) {
        w.add(_messageRectangle(message.right, alignment));
      }
    }

    return

      Container(
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
            }

      ,

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
                          Expanded(
                            flex: 10,
                              child: chatViewer()),
                          Expanded(
                              flex: 1,child: userInput(appState.openAI)),
                        ],
                      ),
                    ],
                  ),
                ),
              );},
            );
  }
}
