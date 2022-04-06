import 'package:batut_de/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../basepage.dart';
import 'applicationstate.dart';

class TopicChooserPage extends BasePage {

  @override
  Widget buildBody(BuildContext context) {

    return Consumer<ApplicationState>(
        builder: (context, appState, _) =>
            FutureBuilder<dynamic>(
                future: appState.jsonReader.loadTopics(),
                builder: (BuildContext context, AsyncSnapshot<dynamic> topics) {
                  if (!topics.hasData) {
                    return const Text("No data in json!");
                  }

                  return ListView.separated(
                    itemCount: topics.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/topic/' + index.toString());
                        },
                        child: SizedBox(
                            height: 150,
                            child: Center(
                              child: Text(topics.data[index].values.first,
                                  style: Styles.getTextStyle(color: Colors.white)),
                            )),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                    const Divider(thickness: 5),

                  );
                }));
  }
}
