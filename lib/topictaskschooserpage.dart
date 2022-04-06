import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'applicationstate.dart';
import 'basepage.dart';

class TopicTasksChooserPage extends BasePage {
  TopicTasksChooserPage({required this.topicID});
  int topicID;

  @override
  Widget buildBody(BuildContext context) {
   return Consumer<ApplicationState>(
       builder: (context, appState, _) =>
           Text("TopicTasksChooserPage" + topicID.toString())

   );
  }
}