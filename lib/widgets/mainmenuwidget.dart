import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../applicationstate.dart';
import '../limitationerrordialog.dart';
import '../pair.dart';
import '../thema.dart';
import 'styledtext.dart';

class MainMenuWidget extends StatelessWidget {
  MainMenuWidget({Key? key, this.divThickness = 5.0}) : super(key: key);
  final double divThickness;

  List<Pair> tabs = [
    Pair("Chats with AI", "/topics/"),
    Pair("Correct grammar", "/grammar_corrections/")
  ];

  void onTap(ApplicationState appState, BuildContext context, String routeName) async {
    await appState.preloadOpenAI(context, notify: false);
    await appState.onOpenedConversation(notify: false);
    if (!appState.isLimitReached()) {
      Navigator.pushNamed(context, routeName);
    }
    else {
      showDialog<void>(
        context: context,
        builder: (context) {
          return LimitationErrorDialog(title: "The free limit reached", message: "The number of conversations for free accounts is limited");
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ApplicationState>(builder: (context, appState, _) {
      return GridView.builder(
        itemCount: tabs.length,
        itemBuilder: (BuildContext context, int index) {
          return GridTile(
            child: GestureDetector(
              onTap: () {
                onTap(appState, context, tabs[index].right);
              },
              child: Card(
                color: Thema.topBaseColor,
                child: Center(child: StyledWhiteText(tabs[index].left)),
              ),
            ),
          );
        },
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
        ),
      );
    });
  }
}
