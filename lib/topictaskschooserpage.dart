import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'applicationstate.dart';
import 'basepage.dart';
import 'LsWidgets/lslistwidget.dart';

class TopicTasksChooserPage extends BasePage {
  TopicTasksChooserPage({required this.topic});

  String topic;
  List<Map<String, String>> trainingParts = [
    {"vocabulary": "Vocabulary"},
    {"dialogs": "Dialogs"}
  ];

  @override
  Widget buildBody(BuildContext context) {
    Provider.of<ApplicationState>(context, listen: true).loadDialog(topic);//listen - rerender
    return LsListWidget(data: trainingParts, routeName: "topic/" + topic);
  }
}
