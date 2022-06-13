import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'applicationstate.dart';
import 'auth/loginpage.dart';
import 'page/chatpage.dart';
import 'page/grammarcorrectorpage.dart';
import 'page/loadingpage.dart';
import 'page/mainmenupage.dart';
import 'page/premiumpage.dart';
import 'page/accountpage.dart';
import 'page/topicchooserpage.dart';
import 'page/unknownpage.dart';
import 'topic.dart';

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
              builder: (context) =>  const MainMenuPage(), settings: settings);
        }

        var uri = Uri.parse(settings.name!);
        if (uri.pathSegments.first == 'topics') {
          return MaterialPageRoute(
              builder: (context) => const TopicChooserPage(), settings: settings);
        }
        if (uri.pathSegments.first == 'login') {
          return MaterialPageRoute(
              builder: (context) => const LoginPage(), settings: settings);
        }
        if (uri.pathSegments.first == 'account') {
          return MaterialPageRoute(
              builder: (context) => AccountPage(), settings: settings);
        }
        if (uri.pathSegments.first == 'premium') {
          return MaterialPageRoute(
              builder: (context) => const PremiumPage(), settings: settings);
        }
        if (uri.pathSegments.first == 'grammar_corrections') {
          return MaterialPageRoute(
              builder: (context) => const GrammarCorrectorPage(), settings: settings);
        }

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
