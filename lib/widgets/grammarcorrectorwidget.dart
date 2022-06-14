import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../applicationstate.dart';
import '../openai/opanai.dart';
import '../styles.dart';
import '../thema.dart';
import '/widgets/styledtext.dart';

class GrammarCorrectorWidget extends StatefulWidget {
  const GrammarCorrectorWidget({Key? key}) : super(key: key);

  @override
  _GrammarCorrectorWidget createState() => _GrammarCorrectorWidget();
}

class _GrammarCorrectorWidget extends State<GrammarCorrectorWidget> {
  final promptController = TextEditingController();

  var correctionsController = TextEditingController();

  void correctMessage(OpenAI? openAI, String text) async {
    if (openAI == null) {
      return;
    }
    correctionsController.text = "";

    var corrections = await openAI.editMessage(text);
    setState(() {
      correctionsController.text = corrections;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ApplicationState>(builder: (context, appState, _) {
      return SingleChildScrollView(
        child: Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                    style: Styles.getTextStyle(),
                    autocorrect: false,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    minLines: 5,
                    controller: promptController,
                    decoration: const InputDecoration(
                      hintText: "Enter your text",
                    ),
                    onEditingComplete: () async {
                      correctMessage(appState.openAI, promptController.text);
                    },
                    onSubmitted: (str) async {
                      correctMessage(appState.openAI, str);
                    }),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: OutlinedButton(
                      onPressed: () async {
                        Clipboard.getData(Clipboard.kTextPlain).then((value) {
                          if (value != null) {
                            setState(() {
                              promptController.text = value.text.toString();
                            });
                          }
                          ;
                        });
                      },
                      child: StyledText.color(
                          'Insert text', Thema.buttonInvertedTextColor),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MaterialButton(
                      onPressed: () async {
                        correctMessage(appState.openAI, promptController.text);
                      },
                      child:
                      StyledText.color('Check grammar', Thema.buttonTextColor),
                      color: Thema.buttonColor,
                    ),
                  ),
                ],
              ),
              const Divider(thickness: 1),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  style: Styles.getTextStyle(),
                  readOnly: true,
                  minLines: 5,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  controller: correctionsController,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: OutlinedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Thema.buttonInvertedColor)),
                      onPressed: () async {
                        Clipboard.setData(
                            ClipboardData(text: promptController.text));
                      },
                      child:
                          StyledText.color('Copy', Thema.buttonInvertedTextColor),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}
