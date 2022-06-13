import 'package:flutter/material.dart';

import '../widgets/mainmenuwidget.dart';
import 'basepage.dart';

class MainMenuPage extends BasePage {
  const MainMenuPage({Key? key}) : super(key: key);

  @override
  Widget buildBody(BuildContext context) {
    return MainMenuWidget();
  }
}
