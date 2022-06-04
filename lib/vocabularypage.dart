import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'applicationstate.dart';
import 'basepage.dart';
import 'lswidgets/lstext.dart';
import 'words/writewordpage.dart';

class VocabularyPage extends BasePage {
  const VocabularyPage({Key? key}) : super(key: key);

  @override
  Widget buildBody(BuildContext context) {
    return Consumer<ApplicationState>(builder: (context, appState, _) {
      return FutureBuilder <dynamic>(
          future: appState.currentTaskData,

          builder: (BuildContext context, AsyncSnapshot<dynamic> taskData) {
            if (taskData.hasData) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: WriteWordWidget(translations: taskData.data.wordsTranslations, words: taskData.data.words),
              );
            }
            return Column(children: [
              LsWhiteText("No vocabulary found for this topic")
            ]);
          });
    });
  }
}
