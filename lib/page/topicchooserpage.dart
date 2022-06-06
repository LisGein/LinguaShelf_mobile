import 'package:flutter/material.dart';

import 'basepage.dart';
import '../widgets/topicchooserwidget.dart';

class TopicChooserPage extends BasePage {
  const TopicChooserPage({Key? key}) : super(key: key);

  @override
  Widget buildBody(BuildContext context) {
    return const TopicChooserWidget();

  }
}
