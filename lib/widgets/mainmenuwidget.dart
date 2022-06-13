import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: tabs.length,
      itemBuilder: (BuildContext context, int index) {
        return GridTile(
          child: GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, tabs[index].right);
            },
            child: Card(
              color: Thema.topBaseColor,
              child: Center(child: StyledWhiteText(tabs[index].left)),
            ),
          ),
        );
      },
       gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,),
    );
  }
}