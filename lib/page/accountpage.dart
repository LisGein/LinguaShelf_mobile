import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:provider/provider.dart';

import '../applicationstate.dart';
import '../widgets/accountwidget.dart';
import '/page/basepage.dart';

// ignore: must_be_immutable
class AccountPage extends BasePage {
  AccountPage({Key? key}) : super(key: key);

  var name = TextEditingController();

  @override
  Widget buildBody(BuildContext context) {
    return Consumer<ApplicationState>(builder: (context, appState, _) {
      name.text = appState.getUserName();
      return AccountWidget(appState.getUserName(), signOut: appState.signOut);
    });
  }
}
