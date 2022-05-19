import 'package:batut_de/tasksdata.dart';
import 'package:batut_de/topic.dart';
import 'package:flutter/cupertino.dart';

import 'jsonreader.dart';
import 'openai/opanai.dart';

class ApplicationState extends ChangeNotifier {
  ApplicationState(){
    _loadOpenAIKey();
  }

  var jsonReader = JsonReader();
  Future<TaskData>? currentTaskData;

  var openAI = OpenAI();

  void loadDialog(String topic) {
    currentTaskData = jsonReader.loadDialog(topic);
    //notifyListeners();
  }

  void _loadOpenAIKey() async {
    await openAI.readKey();
    notifyListeners();
  }

  Future<String> loadTopicsOfDiscussion(Topic topic) async {
    String topics = await openAI.startOfDiscussion(topic);
    return topics;
  }
}