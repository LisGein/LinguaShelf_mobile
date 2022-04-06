import 'dart:convert';

import 'package:flutter/services.dart';

class JsonReader {
  List<String> phrases = [];

  Future<List<Map<String, String>>> loadTopics() async {
    var parsedJson = await _loadParsedJson('assets/texts/topics.json');

    List<Map<String, String>> topics = [];
    if (parsedJson != null && parsedJson['topics'] != null) {
      for (var data in parsedJson['topics']) {
        topics.add(Map.from(data).cast());
      }
    }
    return topics;
  }

  String getTopicByIndex(int index) {
    if (phrases.length <= index) {
      return '';
    }
    return phrases[index];
  }

  Future<List<String>> loadDialogs(String topic) async {
    var parsedJson = await _loadParsedJson('assets/texts/tasks.json');

    if (parsedJson != null && parsedJson[topic] != null && parsedJson[topic]["dialogs"] != null) {
      for (var phrase in parsedJson[topic]["dialogs"]) {
        phrases.add(phrase);
      }
    }
    return phrases;
  }

  dynamic _loadParsedJson(String filename) async {
      String data = await rootBundle.loadString(filename);
      dynamic parsedJson;
      try {
        parsedJson = await json.decode(data.toString());
      } on FormatException catch (e) {
        print('The provided string is not valid JSON: ' + e.message);
      }
      return parsedJson;
  }
}