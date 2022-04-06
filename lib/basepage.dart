import 'package:flutter/material.dart';

abstract class BasePage extends StatelessWidget {
  Widget buildBody(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child:  Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Color.fromARGB(250, 0, 87, 183),
                    Color.fromARGB(250, 168, 50, 160),
                  ],
                )),
            child: buildBody(context)
            //SingleChildScrollView(child: buildBody(context)),,
          )),
    );
  }
}
