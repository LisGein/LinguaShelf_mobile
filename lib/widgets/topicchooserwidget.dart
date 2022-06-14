import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../applicationstate.dart';
import '../auth/authwidget.dart';
import '../widgets/styledtext.dart';

class TopicChooserWidget extends StatelessWidget {
  const TopicChooserWidget({Key? key, this.divThickness = 5.0})
      : super(key: key);
  final double divThickness;
  final String routeName = 'topic';

  @override
  Widget build(BuildContext context) {
    return Consumer<ApplicationState>(
        builder: (context, appState, _) => FutureBuilder<dynamic>(
            future: appState.jsonReader.loadTopics(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> topics) {
              if (!topics.hasData) {
                return StyledWhiteText("No data in json!");
              }

              return ListView.separated(
                itemCount: topics.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      if (appState.loginState ==
                          ApplicationLoginState.loggedIn) {
                        Navigator.pushNamed(context,
                            "/" + routeName + "/" + topics.data[index].left);
                      } else {
                        Navigator.pushNamed(context, "/login/");
                      }
                    },
                    child: SizedBox(
                        height: 75,
                        child: Center(
                          child: StyledWhiteText.pair(topics.data[index]),
                        )),
                  );
                },
                separatorBuilder: (BuildContext context, int index) =>
                    Divider(thickness: divThickness),
              );
            }));
  }
}
