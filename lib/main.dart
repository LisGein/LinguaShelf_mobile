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
        if (uri.pathSegments.length > 1 && uri.pathSegments.first == 'topic') {
          var topic = uri.pathSegments[1].toString();
          if (uri.pathSegments.length == 2) {
            return MaterialPageRoute(
              builder: (context) => TopicTasksChooserPage(topic:topic),
              settings: settings);
          } else if (uri.pathSegments.length == 3) {


          }
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

