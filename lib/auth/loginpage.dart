import 'package:flutter/cupertino.dart';

import '../page/basepage.dart';
import 'loginwidget.dart';

class LoginPage extends BasePage {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget buildBody(BuildContext context) {
    return const LoginWidget();
  }
}