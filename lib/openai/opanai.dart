import 'dart:convert';

import 'package:http/http.dart' as http;

import '../jsonreader.dart';

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
  String apiKey = "";

  Future<String> readKey() async {
    if (apiKey.isNotEmpty){return apiKey;}
    var parsedJson = await JsonReader.loadParsedJson('assets/key.json');
    if (parsedJson != null && parsedJson["key"] != null) {
      apiKey = parsedJson["key"].toString();
      return apiKey;
    }
    return apiKey;
  }



  String getUrl(function, [engine]) {
    List engineList = ['ada', 'babbage', 'curie', 'davinci'];

    String url = 'https://api.openai.com/v1/engines/davinci/$function';

    if (engineList.contains(engine)) {
      url = 'https://api.openai.com/v1/engines/$engine/$function';
    }

    return url;
  }

  Future<String> editMessage(String text) async {
    Map reqData = {
      "input": text,
      "instruction": "Korrigieren Sie die Grammatik und Rechtschreibung"
    };


    var headers = {
      "authorization": "Bearer $apiKey",
      "accept": "application/json",
      "content-type": "application/json",
      "max_tokens": "100"
    };

/*    String engine = await updateListOfEngines("api.openai.com", "v1/engines", {
    "authorization": "Bearer $apiKey",
    "accept": "application/json",
    "content-type": "application/json",
      "max_tokens": "5000"});*/
    return await correctionRequest("api.openai.com", "v1/engines/text-davinci-edit-001/edits", headers, reqData);
  }

  Future<String> orderInRestaurant(
    String question, String context
  ) async {

    Map reqData = {
      "model": "davinci",
      "question": question,
      "examples": [
        ["Ich hätte gern eine Cola.", "Eine Cola kommt gleich."]
      ],
      "examples_context":
          "The following is a conversation with an AI assistant a waitress in a restaurant. The conversation is in German. " + context,
      "documents": []
    };


    var headers = {
      "authorization": "Bearer $apiKey",
      "accept": "application/json",
      "content-type": "application/json",
      "temperature": "0.5",
      "max_tokens": "300"
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
      "max_tokens" : 100
    };

    return QARequest(headers, reqData);
  }


  Future<String> QARequest(Map<String, String> headers, Map reqData) async {
    return await questionRequest("api.openai.com", "v1/answers", headers, reqData);
  }

  Future<String> CompletionsRequest(Map<String, String> headers, Map reqData) async {
    return await correctionRequest("api.openai.com", "v1/engines/text-davinci-002/completions", headers, reqData);
  }

  Future<String> questionRequest(String authority, String unencodedPath,
      Map<String, String> headers, Map reqData) async {

    if (apiKey.isEmpty) {
      return "";
    }
    print("request:");
    print(Uri.https(authority, unencodedPath));
    print(reqData);
    var response = await http
        .post(
      Uri.https(authority, unencodedPath),
      headers: headers,
      body: jsonEncode(reqData),
    )
        .timeout(const Duration(seconds: 120));

    print("response:");
    print(response.body);
    Map<String, dynamic> map = json.decode(response.body);
    List<dynamic> resp = map["answers"];
    return resp[0];
  }

  Future<String> correctionRequest(String authority, String unencodedPath,
      Map<String, String> headers, Map reqData) async {

    if (apiKey.isEmpty) {
      return "";
    }
    print("request:");
    print(Uri.https(authority, unencodedPath));
    print(reqData);
    var response = await http
        .post(
      Uri.https(authority, unencodedPath),
      headers: headers,
      body: jsonEncode(reqData),
    )
        .timeout(const Duration(seconds: 120));

    print("response:");
    print(response.body);
    Map<String, dynamic> map = json.decode(response.body);
    List<dynamic> resp = map["choices"];
    return resp[0]["text"];
  }

  Future<String> updateListOfEngines(String authority, String unencodedPath, Map<String, String> headers) async {
    var response = await http
        .get(
      Uri.https(authority, unencodedPath),
      headers: headers
    )
        .timeout(const Duration(seconds: 120));

    print("response:");
    print(response.body);
    Map<String, dynamic> map = json.decode(response.body);
    List<dynamic> resp = map["data"];

    return resp[0]["id"];
  }
}
