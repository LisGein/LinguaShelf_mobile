import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'LsWidgets/lslistwidget.dart';
import 'LsWidgets/lstext.dart';
import 'applicationstate.dart';
import 'basepage.dart';

class DiscussionPage extends BasePage {
  DiscussionPage({required this.topic});
  String topic;

  @override
  Widget buildBody(BuildContext context) {

    return Consumer<ApplicationState>(
        builder: (context, appState, _) =>
            FutureBuilder<dynamic>(
                future: appState.loadTopicsOfDiscussion(),
                builder: (BuildContext context, AsyncSnapshot<dynamic> topics) {
                  if (!topics.hasData) {
                    return LsWhiteText("No connection to the server!");
                  }
                  return LsListWidget(data: topics.data, routeName: 'topic/' + topic + '/chat');
                }));
  }
}
