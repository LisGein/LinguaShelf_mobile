import 'dart:convert';

import 'package:batut_de/tasksdata.dart';
import 'package:flutter/services.dart';

class JsonReader {
  List<Map<String, String>> topics = [];

  Future<List<Map<String, String>>> loadTopics() async {
    var parsedJson = await _loadParsedJson('assets/texts/topics.json');

    if (parsedJson != null && parsedJson['topics'] != null) {
      for (var data in parsedJson['topics']) {
        topics.add(Map.from(data).cast());
      }
    }
    return topics;
  }

  Future<TaskData> loadDialog(String topic) async {
    var data = TaskData();

    var parsedJson = await _loadParsedJson('assets/texts/tasks.json');
    if (parsedJson != null && parsedJson[topic] != null
        && parsedJson[topic]["dialogs"] != null) {

      if (parsedJson[topic]["dialogs"]["phrases"] != null) {
        for (var phrase in parsedJson[topic]["dialogs"]["phrases"]) {
          List<String> variants = [];
          for (var variant in phrase) {
            variants.add(variant);
          }
          data.phrases.add(variants);
        }
      }

      if (parsedJson[topic]["dialogs"]["translation"] != null) {
        for (var phrase in parsedJson[topic]["dialogs"]["translation"]) {
          List<String> variants = [];
          for (var variant in phrase) {
            variants.add(variant);
          }
          data.translations.add(variants);
        }
      }

      if (parsedJson[topic]["vocabulary"] != null) {
        Map<String, String> vocabulary = Map.castFrom(parsedJson[topic]["vocabulary"]);
        data.words = vocabulary.keys.map((e) => e).toList();
        data.wordsTranslations = vocabulary.values.map((e) => e).toList();
      }
    }
    return data;
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