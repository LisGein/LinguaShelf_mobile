import 'package:batut_de/tasksdata.dart';
import 'package:flutter/cupertino.dart';

import 'jsonreader.dart';

class ApplicationState extends ChangeNotifier {

  var jsonReader = JsonReader();
  Future<TaskData>? currentTaskData;

  void loadDialog(String topic) {
    currentTaskData = jsonReader.loadDialog(topic);
    //notifyListeners();
  }
}