import 'dart:convert';

import 'package:http/http.dart' as http;

import '../requests.dart';
import '../topic.dart';

class OpenAI {
  OpenAI({required this.apiKey, required this.requests});

  String apiKey;

  Requests requests;

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


  Future<String> callWithPlumber(
      String context
      ) async {

    var headers = {
      "authorization": "Bearer $apiKey",
      "accept": "application/json",
      "content-type": "application/json",
    };

    Map reqData = {
      "prompt": context,
      "max_tokens" : 150,
      "temperature" : 1,
      "presence_penalty" : 0,
      "frequency_penalty" : 0
    };

    return CompletionsRequest(headers, reqData);
  }

  Future<String> startOfDiscussion(Topic topic) async {
    switch (topic) {
      case Topic.CallDoctor:
        return await _startOfCallToDoctor();
      case Topic.CallPlumber:
        return await _startOfCallToPlumber();
      default:
        return await _startOfGeneralConversation();
    }
  }


  Future<String> _startOfGeneralConversation() async {
    var headers = {
      "authorization": "Bearer $apiKey",
      "accept": "application/json",
      "content-type": "application/json",
    };

    Map reqData = {
      "model": "davinci",
      "question": "Generate 5 possible conversation starters when a client calls the clinic to make an appointment.",
      "examples": [
        ["Praxis, guten Tag. Was kann ich für Sie tun?", "Hallo, Praxis XY. Was kann ich für Sie tun?"]
      ],
      "examples_context":
      "I am a highly intelligent question answering bot. The conversation is in German.",
      "documents": [],
      "max_tokens" : 100
    };

    return QARequest(headers, reqData);
  }

  Future<String> _startOfCallToDoctor() async {
    var headers = {
      "authorization": "Bearer $apiKey",
      "accept": "application/json",
      "content-type": "application/json",
    };

    Map reqData = {
      "model": "davinci",
      "question": "Generate 5 possible conversation starters when a client calls the clinic to make an appointment.",
      "examples": [
        ["Praxis, guten Tag. Was kann ich für Sie tun?", "Hallo, Praxis XY. Was kann ich für Sie tun?"]
      ],
      "examples_context":
      "I am a highly intelligent question answering bot. The conversation is in German.",
      "documents": [],
      "max_tokens" : 100
    };

    return QARequest(headers, reqData);
  }

  Future<String> _startOfCallToPlumber() async {
    var headers = {
      "authorization": "Bearer $apiKey",
      "accept": "application/json",
      "content-type": "application/json",
    };
    String str = "Der Nutzer lebt in Deutschland. Der Benutzer hat ein verstopftes Waschbecken. Der Benutzer ruft einen Klempner an. Der Klempner antwortet auf Deutsch:";
    Map reqData = {
      "prompt": str,
      "max_tokens" : 150,
      "temperature" : 0.7,
    };

    str += await CompletionsRequest(headers, reqData);

    return str;
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
    print("question request:");
    print(Uri.https(authority, unencodedPath));
    print(reqData);
    var response = await http
        .post(
      Uri.https(authority, unencodedPath),
      headers: headers,
      body: jsonEncode(reqData),
    )
        .timeout(const Duration(seconds: 120));

    print("question response:");
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
    print("correction request:");
    print(Uri.https(authority, unencodedPath));
    print(reqData);
    var response = await http
        .post(
      Uri.https(authority, unencodedPath),
      headers: headers,
      body: jsonEncode(reqData),
    )
        .timeout(const Duration(seconds: 120));

    print("correction response:");
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

    print("update response:");
    print(response.body);
    Map<String, dynamic> map = json.decode(response.body);
    List<dynamic> resp = map["data"];

    return resp[0]["id"];
  }
}
