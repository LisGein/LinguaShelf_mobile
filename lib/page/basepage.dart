import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../applicationstate.dart';
import '../auth/authwidget.dart';
import '../thema.dart';

abstract class BasePage extends StatelessWidget {
  const BasePage({Key? key}) : super(key: key);

  Widget buildBody(BuildContext context);

  AppBar _appBar() {
    return AppBar(
      backgroundColor: Thema.topBaseColor,
    );
  }

  Drawer _drawer(BuildContext context, ApplicationState appState) {
    return Drawer(
        child: ListView(children: [
      if (appState.loginState != ApplicationLoginState.loggedIn)
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MaterialButton(
                onPressed: () async {
                  Navigator.pushNamed(context, "/login/");
                },
                child: const Text('Sign in'),
                color: Thema.buttonColor,
                textColor: Thema.buttonTextColor,
              ),
              MaterialButton(
                onPressed: () async {
                  Navigator.pushNamed(context, "/login/");
                },
                child: const Text('Sign up'),
                color: Thema.buttonInvertedColor,
                textColor: Thema.buttonInvertedTextColor,
              )
            ],
          ),
        ),
      if (appState.loginState == ApplicationLoginState.loggedIn)
        Padding(
            padding: const EdgeInsets.all(16.0),
            child: MaterialButton(
              onPressed: () async {
                appState.signOut();
              },
              child: const Text('Sign out'),
              color: Thema.buttonInvertedColor,
              textColor: Thema.buttonInvertedTextColor,
            )),
      const Divider(
        height: 1,
        thickness: 1,
      ),
      /*ListTile(
            leading: Icon(Icons.favorite),
            title: Text('Item 1'),
            //selected: _selectedDestination == 0,
            //onTap: () => selectDestination(0),
          )*/
    ]));
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
        child: buildBody(context)
        //SingleChildScrollView(child: buildBody(context)),,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ApplicationState>(
        builder: (context, appState, _) => Scaffold(
              appBar: _appBar(),
              drawer: _drawer(context, appState),
              body: _body(context),
            ));
  }
}
