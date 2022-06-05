import 'package:flutter/material.dart';

import '../thema.dart';

abstract class BasePage extends StatelessWidget {
  const BasePage({Key? key}) : super(key: key);

  Widget buildBody(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
        child: buildBody(context)
        //SingleChildScrollView(child: buildBody(context)),,
      ),
    );
  }
}

