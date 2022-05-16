import 'package:batut_de/tasksdata.dart';
import 'package:flutter/cupertino.dart';

import 'jsonreader.dart';
import 'opanai.dart';

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

  Future<List<Map<String, String>>> loadTopicsOfDiscussion() async {
    String topics = await openAI.startOfOrderInRestaurant();
    List<String> listOfTopics = topics.split("\n");
    List<Map<String, String>> data = [];
    for (var topic in listOfTopics) {
      data.add({listOfTopics.indexOf(topic).toString(): topic});
    }

    return data;
  }
}