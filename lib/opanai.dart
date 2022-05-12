import 'dart:convert';

import 'package:http/http.dart' as http;

class Param {
  String name;
  var value;

  Param(this.name, this.value);

  @override
  String toString() {
    return '{ ${this.name}, ${this.value} }';
  }
}

class OpenAI {
  String apiKey;

  OpenAI({required this.apiKey});

  String getUrl(function, [engine]) {
    List engineList = ['ada', 'babbage', 'curie', 'davinci'];

    String url = 'https://api.openai.com/v1/engines/davinci/$function';

    if (engineList.contains(engine)) {
      url = 'https://api.openai.com/v1/engines/$engine/$function';
    }

    return url;
  }

  //Future<String> edit

  Future<String> orderInRestaurant(
    String prompt,
  ) async {
    String apiKey = this.apiKey;

    Map reqData = {
      "model": "davinci",
      "question": prompt,
      "examples": [
        ["Ich hätte gern eine Cola.", "Eine Cola kommt gleich."]
      ],
      "examples_context":
          "The following is a conversation with an AI assistant a waitress in a restaurant. The conversation is in German.",
      "documents": []
    };

    var headers = {
      "authorization": "Bearer $apiKey",
      "accept": "application/json",
      "content-type": "application/json",
    };

    return QARequest(headers, reqData);
  }

  Future<String> startOfOrderInRestaurant() async {
    var headers = {
      "authorization": "Bearer $apiKey",
      "accept": "application/json",
      "content-type": "application/json",
    };

    Map reqData = {
      "model": "davinci",
      "question": "Generate 5 posible questions that waitresses typically ask customers if they would like something to drink.",
      "examples": [
        ["Guten Tag! Kann ich Ihnen helfen?", "Möchten Sie etwas zu trinken haben?"]
      ],
      "examples_context":
      "I am a highly intelligent question answering bot. The conversation is in German.",
      "documents": [],
      "max_tokens" : 200
    };

    return QARequest(headers, reqData);
  }


  Future<String> QARequest(Map<String, String> headers, Map reqData) async {
    return await request("api.openai.com", "v1/answers", headers, reqData);
  }

  Future<String> request(String authority, String unencodedPath,
      Map<String, String> headers, Map reqData) async {
    var response = await http
        .post(
          Uri.https(authority, unencodedPath),
          headers: headers,
          body: jsonEncode(reqData),
        )
        .timeout(const Duration(seconds: 120));

    print(response.body);
    Map<String, dynamic> map = json.decode(response.body);
    List<dynamic> resp = map["answers"];
    return resp[0];
  }
}
