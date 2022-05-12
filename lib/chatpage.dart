import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'opanai.dart';

class ChatPage extends StatefulWidget {
  final OpenAI openAI;

  ChatPage(this.openAI);

  @override
  _ChatPageState createState() => _ChatPageState(openAI: openAI);
}

class _ChatPageState extends State<ChatPage> {
  _ChatPageState({required this.openAI});

  OpenAI openAI;

  final promptController = TextEditingController();
  String generated = "";
  int tokens = 50;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
        future: openAI.startOfOrderInRestaurant(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> firstQuestion) {
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      controller: promptController,
                      decoration: InputDecoration(
                        hintText: "Enter prompt",
                      )),
                  MaterialButton(
                    onPressed: () async {
                      String complete =
                      await openAI.orderInRestaurant(promptController.text);
                      setState(() {
                        generated = complete;
                        print(generated);
                      });
                    },
                    child: Text('Generate'),
                    color: Colors.blue,
                    textColor: Colors.white,
                  ),

                  Text(firstQuestion.data.toString()),
                  Text(generated),
                ],
              ),
            ),
          );
        });
  }
}
