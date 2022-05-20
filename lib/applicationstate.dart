import 'package:batut_de/tasksdata.dart';
import 'package:batut_de/topic.dart';
import 'package:flutter/cupertino.dart';

import 'jsonreader.dart';
import 'openai/opanai.dart';

class ApplicationState extends ChangeNotifier {
  ApplicationState() {
    _loadOpenAIKey();
  }

  var jsonReader = JsonReader();
  Future<TaskData>? currentTaskData;

  var openAI = OpenAI();
  String apiKey = "";

  void loadDialog(String topic) {
    currentTaskData = jsonReader.loadDialog(topic);
  }

  Future<void> _readKey() async {
    if (apiKey.isNotEmpty) {
      return;
    }
    var parsedJson = await JsonReader.loadParsedJson('assets/key.json');
    if (parsedJson != null && parsedJson["key"] != null) {
      apiKey = parsedJson["key"].toString();
    }
  }

  Future<void> _readRequestsFile() async {
    var parsedJson = await JsonReader.loadParsedJson('assets/requests.json');
    if (parsedJson != null && parsedJson["requests"] != null) {

    }
  }

  Future<void> _loadDataForAI() async {
    _readKey();
    _readRequestsFile();
  }

  void _loadOpenAIKey() async {
    await _loadDataForAI();
    notifyListeners();
  }

  Future<String> loadTopicsOfDiscussion(Topic topic) async {
    String topics = await openAI.startOfDiscussion(topic);
    return topics;
  }
}
