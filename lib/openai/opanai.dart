import 'dart:convert';
import 'dart:developer' as developer;

import 'package:http/http.dart' as http;

import '../requests.dart';
import '../topic.dart';

class OpenAI {
  OpenAI({required this.apiKey, required this.requests, required this.userID});

  String apiKey;

  Requests requests;

  String userID;

  bool isInitialized() {
    return apiKey.isNotEmpty;
  }

  void updateUserID(String userID) {
    this.userID = userID;
  }

  String getUrl(function, [engine]) {
    List engineList = ['ada', 'babbage', 'curie', 'davinci'];

    String url = 'https://api.openai.com/v1/engines/davinci/$function';

    if (engineList.contains(engine)) {
      url = 'https://api.openai.com/v1/engines/$engine/$function';
    }

    return url;
  }

  Map<String, String> _generateCompletionHeaders({bool isCorrections = true}) {
    var user = userID;
    if (isCorrections) {
      user += "corrections";
    } else {
      user += "story";
    }
    return {
      "authorization": "Bearer $apiKey",
      "accept": "application/json",
      "content-type": "application/json",
      "user": user
    };
  }


  Future<String> editMessage(String text) async {
    /*Map reqData = {
      "input": text,
      "instruction": "Fix the spelling and grammar mistakes, and explain corrections."
    };


    String engine = await updateListOfEngines("api.openai.com", "v1/engines", {
    "authorization": "Bearer $apiKey",
    "accept": "application/json",
    "content-type": "application/json",
      "max_tokens": "5000"});
    return await request("api.openai.com", "v1/engines/text-davinci-edit-001/edits", _generateHeaders(), reqData, false);*/

    Map reqData = {
      "prompt": "Correct all mistakes of this German text to standard German and give an explanation of these corrections:\"" + text + "\". Use only German language and UTF-8.",
      "max_tokens" : text.length*5,
      "temperature" : 1,
      "presence_penalty" : 0,
      "frequency_penalty" : 0
    };

    return await completionsRequest(_generateCompletionHeaders(isCorrections: false), reqData);
  }

  Future<String> completeStoryByContext(
      String context
      ) async {

    Map reqData = {
      "prompt": context,
      "max_tokens" : 150,
      "temperature" : 1,
      "presence_penalty" : 0,
      "frequency_penalty" : 0
    };

    return await completionsRequest(_generateCompletionHeaders(), reqData);
  }

  Future<String> startOfDiscussion(Topic topic) async {

    String str = requests.getRequest(topic);
    Map reqData = {
      "prompt": str,
      "max_tokens" : 150,
      "temperature" : 0.7,
    };

    str += await completionsRequest(_generateCompletionHeaders(), reqData);

    return str;
  }

  Future<String> qaRequest(Map<String, String> headers, Map reqData) async {
    return await request("api.openai.com", "v1/answers", headers, reqData, true);
  }

  Future<String> completionsRequest(Map<String, String> headers, Map reqData) async {
    return await request("api.openai.com", "v1/engines/text-davinci-002/completions", headers, reqData, false);
  }

  Future<String> request(String authority, String unencodedPath,
      Map<String, String> headers, Map reqData, bool isQuestion) async {
    if (apiKey.isEmpty) {
      return "";
    }

    developer.log("request:");
    developer.log(Uri.https(authority, unencodedPath).toString());
    developer.log(reqData.toString());

    var response = await http
        .post(
      Uri.https(authority, unencodedPath),
      headers: headers,
      body: jsonEncode(reqData),
    )
        .timeout(const Duration(seconds: 120));

    developer.log("response:");
    developer.log(response.body);
    Map<String, dynamic> map = json.decode(response.body);


    List<dynamic> resp = isQuestion ? map["answers"] : map["choices"];
    var answer =  isQuestion ? resp[0] : resp[0]["text"];

    var bytes = latin1.encode(answer);
    var utfStr = utf8.decode(bytes);

    developer.log("decoded:" + utfStr);
    return utfStr;
  }

  Future<String> updateListOfEngines(String authority, String unencodedPath, Map<String, String> headers) async {
    var response = await http
        .get(
      Uri.https(authority, unencodedPath),
      headers: headers
    )
        .timeout(const Duration(seconds: 120));

    developer.log("update response:");
    developer.log(response.body);
    Map<String, dynamic> map = json.decode(response.body);
    List<dynamic> resp = map["data"];

    return resp[0]["id"];
  }
}
