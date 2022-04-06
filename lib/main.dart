import 'package:batut_de/applicationstate.dart';
import 'package:batut_de/topicchooserpage.dart';
import 'package:batut_de/topictaskschooserpage.dart';
import 'package:batut_de/unknownpage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    const mainBlueColor = Color.fromARGB(255, 135, 174, 207);
    return MaterialApp(
      title: 'Batut.de',
      theme: ThemeData(
          backgroundColor: Colors.red,
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                primary: mainBlueColor,
              ))),
      onGenerateRoute: (settings)
      {
        if (settings.name == '/') {
          return MaterialPageRoute(
              builder: (context) => TopicChooserPage(), settings: settings);
        }

        var uri = Uri.parse(settings.name!);
        if (uri.pathSegments.length == 2 && uri.pathSegments.first == 'topic') {
          var topicID = int.parse(uri.pathSegments[1]);
          return MaterialPageRoute(
              builder: (context) => TopicTasksChooserPage(topicID:topicID),
              settings: settings);
        }

        return MaterialPageRoute(

            builder: (context) => UnknownPage(), settings: settings);
      },
    );
  }
}


void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ApplicationState(),
      builder: (context, _) => MainWidget(),
    ),
  );
}

