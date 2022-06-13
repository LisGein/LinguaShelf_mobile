import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../applicationstate.dart';
import '../openai/opanai.dart';
import '../styles.dart';
import '../thema.dart';

class GrammarCorrectorWidget extends StatefulWidget {
  const GrammarCorrectorWidget({Key? key}) : super(key: key);

  @override
  _GrammarCorrectorWidget createState() => _GrammarCorrectorWidget();
}

class _GrammarCorrectorWidget extends State<GrammarCorrectorWidget> {
  final promptController = TextEditingController();

  var correctionsController = TextEditingController();

  void correctMessage(OpenAI openAI, String text) async {
    var corrections = await openAI.editMessage(text);
    setState(() {
      correctionsController.text = corrections;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ApplicationState>(builder: (context, appState, _) {
      appState.preloadOpenAI(context, notify: false).then((value) => setState((){}));

      return Card(
        child: Column(
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
                      hintText: "Enter your text",
                    )),
              ),
            ),
            if (correctionsController.text.isNotEmpty)
              Expanded(
                flex: 6,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    style: Styles.getTextStyle(),
                    readOnly: true,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    controller: correctionsController,
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: MaterialButton(
                onPressed: () async {
                  if (appState.openAI != null) {
                    correctMessage(appState.openAI!, promptController.text);
                  }
                },
                child: const Text('Check'),
                color: Thema.buttonColor,
                textColor: Thema.buttonTextColor,
              ),
            ),
          ],
        ),
      );
    });
  }
}
