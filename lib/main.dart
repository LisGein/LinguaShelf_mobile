import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'applicationstate.dart';
import 'page/chatpage.dart';
import 'page/loadingpage.dart';
import 'topic.dart';
import 'page/topicchooserpage.dart';
import 'page/unknownpage.dart';

class MainWidget extends StatelessWidget {
  const MainWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LinguaShelf_mobile',
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.purple[200],
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
            primary: Colors.blueAccent,
          ))),
      onGenerateRoute: (settings) {
        if (settings.name == '/') {
          return MaterialPageRoute(
              builder: (context) =>  const TopicChooserPage(), settings: settings);
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
                          return const LoadingPage();
                        } else {
                          return ChatPage(firstQuestion: topics.data);
                        }
                      })),
              settings: settings);
        }

        return MaterialPageRoute(
            builder: (context) => const UnknownPage(), settings: settings);
      },
    );
  }
}

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ApplicationState(),
      builder: (context, _) => const MainWidget(),
    ),
  );
}
