import 'topic.dart';

class Requests {
  Requests(Map<dynamic, dynamic> json) {
    for (var request in json.keys) {
      var topic = strToEnum(request.toString());
      data[topic] = Map.from(json[request]).cast<String, String>();
    }
  }

  Map<Topic, Map<String, String>> data = {};

  String getRequest(Topic t) {
    if (!data.containsKey(t)) {
      return "";
    }

    Map<String, String> callInfo = data[t]!;

    if (!callInfo.containsKey("prompt")) {
      return "";
    }

    return callInfo["prompt"]!;
  }
}