import 'package:batut_de/topic.dart';

class Requests {
  Requests(Map<dynamic, dynamic> json) {
    for (var request in json.keys) {
      var topic = strToEnum(request.toString());
      data[topic] = Map.from(json[request]).cast<String, String>();
    }
  }

  Map<Topic, Map<String, String>> data = {};
}