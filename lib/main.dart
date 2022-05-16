import 'package:batut_de/applicationstate.dart';
import 'package:batut_de/discussionpage.dart';
import 'package:batut_de/topicchooserpage.dart';
import 'package:batut_de/chatpage.dart';
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
          //colorScheme: ColorScheme(primary: Color.fromARGB(250, 0, 87, 183), onPrimary: Colors.white, brightness: Brightness.light,
          //    secondary: Color.fromARGB(250, 252, 136, 3), onSecondary: Colors.white, ),
          backgroundColor: Colors.red,
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
            primary: mainBlueColor,
          ))),
      onGenerateRoute: (settings) {
        if (settings.name == '/') {
          return MaterialPageRoute(
              builder: (context) => TopicChooserPage(), settings: settings);
        }

        var uri = Uri.parse(settings.name!);
        if (uri.pathSegments.length > 1 && uri.pathSegments.first == 'topic') {
          if (uri.pathSegments.length == 2) {
            return MaterialPageRoute(
                builder: (context) => DiscussionPage(topic: uri.pathSegments.last.toString()),
                settings: settings);
          }
          else {
            return MaterialPageRoute(
                builder: (context) => ChatPage(firstQuestion: uri.pathSegments.last.toString()),
                settings: settings);
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
