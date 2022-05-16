import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'opanai.dart';

class ChatPage extends StatefulWidget {
  var openAI = OpenAI();

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final promptController = TextEditingController();
  String generated = "";
  int tokens = 50;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
        future: widget.openAI.startOfOrderInRestaurant(),
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
                      String complete = await widget.openAI
                          .orderInRestaurant(promptController.text);
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
