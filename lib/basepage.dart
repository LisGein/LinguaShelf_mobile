import 'package:flutter/material.dart';

abstract class BasePage extends StatelessWidget {
  Widget buildBody(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Color.fromARGB(250, 0, 87, 183),
                Color.fromARGB(250, 252, 136, 3),
              ],
            )),
        child: buildBody(context)
        //SingleChildScrollView(child: buildBody(context)),,
      ),
    );
  }
}

