import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'applicationstate.dart';
import 'basepage.dart';
import 'lslistwidget.dart';

class TopicTasksChooserPage extends BasePage {
  TopicTasksChooserPage({required this.topic});

  String topic;
  List<Map<String, String>> trainingParts = [{"vocabulary": "Vocabulary"}, {"dialogs": "Dialogs"}];

  @override
  Widget buildBody(BuildContext context) {
    return Consumer<ApplicationState>(builder: (context, appState, _) {
      return FutureBuilder<dynamic>(
          future: appState.jsonReader.loadDialog(topic),
          builder: (BuildContext context, AsyncSnapshot<dynamic> dialog) {
            if (dialog.hasData) {
                return LsListWidget(data: trainingParts, routeName: "topic/" + topic);
            }
            return Text("No data");
          });
    });
  }
}
