import 'package:flutter/material.dart';

import '../thema.dart';
import '../widgets/leftdrawer.dart';

abstract class BasePage extends StatelessWidget {
  const BasePage({Key? key}) : super(key: key);

  Widget buildBody(BuildContext context);

  AppBar _appBar() {
    return AppBar(
      backgroundColor: Thema.topBaseColor,
    );
  }

  Widget _body(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Thema.topBaseColor,
            Thema.bottomBaseColor,
          ],
        )),
        child: buildBody(context));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      drawer: LeftDrawer(),
      body: _body(context),
    );
  }
}
