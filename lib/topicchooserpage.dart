import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../basepage.dart';
import 'applicationstate.dart';
import 'lswidgets/lslistwidget.dart';
import 'lswidgets/lstext.dart';

class TopicChooserPage extends BasePage {
  const TopicChooserPage({Key? key}) : super(key: key);


  @override
  Widget buildBody(BuildContext context) {

    return Consumer<ApplicationState>(
        builder: (context, appState, _) =>
            FutureBuilder<dynamic>(
                future: appState.jsonReader.loadTopics(),
                builder: (BuildContext context, AsyncSnapshot<dynamic> topics) {
                  if (!topics.hasData) {
                    return LsWhiteText("No data in json!");
                  }
                  return LsListWidget(data: topics.data, routeName: 'topic');
                }));
  }
}
