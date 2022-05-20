import 'package:batut_de/pair.dart';
import 'package:batut_de/requests.dart';
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

  OpenAI? openAI;

  void loadDialog(String topic) {
    currentTaskData = jsonReader.loadDialog(topic);
  }

  Future<String> _readKey() async {
    var parsedJson = await JsonReader.loadParsedJson('assets/key.json');
    if (parsedJson != null && parsedJson["key"] != null) {
      return parsedJson["key"].toString();
    }
    return "";
  }

  Future<Requests?> _readRequestsFile() async {
    var parsedJson = await JsonReader.loadParsedJson('assets/texts/requests.json');
    if (parsedJson != null && parsedJson["requests"] != null) {
      return Requests(parsedJson["requests"]);
    }
    return null;
  }

  Future<Pair> _loadDataForAI() async {
    String key = await _readKey();
    Requests? requests = await _readRequestsFile();

    return Pair(key, requests);
  }

  void _loadOpenAIKey() async {
    var pair = await _loadDataForAI();
    if (pair.right != null) {
      openAI = OpenAI(apiKey: pair.left, requests: pair.right);
      notifyListeners();
    }
  }

  Future<String> loadTopicsOfDiscussion(Topic topic) async {
    if (openAI != null) {
      return await openAI!.startOfDiscussion(topic);
    }
    return "OpenAI is not loaded!";
  }
}
