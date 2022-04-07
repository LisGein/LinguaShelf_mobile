import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../basepage.dart';
import 'applicationstate.dart';
import 'lslistwidget.dart';

class TopicChooserPage extends BasePage {

  @override
  Widget buildBody(BuildContext context) {

    return Consumer<ApplicationState>(
        builder: (context, appState, _) =>
            FutureBuilder<dynamic>(
                future: appState.jsonReader.loadTopics(),
                builder: (BuildContext context, AsyncSnapshot<dynamic> topics) {
                  if (!topics.hasData) {
                    return const Text("No data in json!");
                  }
                  return LsListWidget(data: topics.data, routeName: 'topic');
                }));
  }
}
