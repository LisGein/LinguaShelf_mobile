import 'package:flutter/cupertino.dart';

import 'jsonreader.dart';

class ApplicationState extends ChangeNotifier {
  ApplicationState() {
    init();
  }
  Future<void> init() async {

  }

  var jsonReader = JsonReader();
}