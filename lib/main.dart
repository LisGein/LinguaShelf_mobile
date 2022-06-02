import 'package:LinguaShelf_mobile/applicationstate.dart';
import 'package:LinguaShelf_mobile/topic.dart';
import 'package:LinguaShelf_mobile/topicchooserpage.dart';
import 'package:LinguaShelf_mobile/chatpage.dart';
import 'package:LinguaShelf_mobile/unknownpage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'loadingpage.dart';

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
        if (uri.pathSegments.length == 2 && uri.pathSegments.first == 'topic') {
          return MaterialPageRoute(
              builder: (context) => Consumer<ApplicationState>(
                  builder: (context, appState, _) => FutureBuilder<dynamic>(
                      future: appState.loadTopicsOfDiscussion(
                          strToEnum(uri.pathSegments.last.toString())),
                      builder: (BuildContext context,
                          AsyncSnapshot<dynamic> topics) {
                        if (!topics.hasData) {
                          return LoadingPage();
                        } else {
                          return ChatPage(firstQuestion: topics.data);
                        }
                      })),
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
