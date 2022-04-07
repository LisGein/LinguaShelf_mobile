import 'package:batut_de/basepage.dart';
import 'package:batut_de/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

import 'applicationstate.dart';

class VocabularyPage extends BasePage {
  @override
  Widget buildBody(BuildContext context) {
    return Consumer<ApplicationState>(builder: (context, appState, _) {
      return FutureBuilder <dynamic>(
          future: appState.currentTaskData,

          builder: (BuildContext context, AsyncSnapshot<dynamic> taskData) {
            if (taskData.hasData) {
              List<Text> listOfWords = [];

              for (var item in taskData.data.vocabulary.entries) {
                listOfWords.add(Text(item.key + " - " + item.value,
                    style: Styles.getTextStyle()));
              };
              return Column(children: listOfWords);
            }
            return Column(children: [
              Text("No vocabulary found for this topic",
                  style: Styles.getTextStyle())
            ]);
          });
    });
  }
}
