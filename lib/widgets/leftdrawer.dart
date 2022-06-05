import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../applicationstate.dart';
import '../auth/authwidget.dart';
import '../thema.dart';
import '/widgets/styledtext.dart';

class LeftDrawer extends StatelessWidget {
  LeftDrawer({Key? key}) : super(key: key);

  List<Widget> _buildGuestContent(BuildContext context) {
    return [
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            MaterialButton(
              onPressed: () async {
                Navigator.pushNamed(context, "/login/");
              },
              child: StyledText.color('Sign in', Thema.buttonTextColor),
              color: Thema.buttonColor,
              textColor: Thema.buttonTextColor,
            ),
            MaterialButton(
              onPressed: () async {
                Navigator.pushNamed(context, "/login/");
              },
              child: StyledText.color('Sign up', Thema.buttonInvertedTextColor),
              color: Thema.buttonInvertedColor,
              textColor: Thema.buttonInvertedTextColor,
            )
          ],
        ),
      ),
      const Divider(
        height: 1,
        thickness: 1,
      )
    ];
  }

  List<Widget> _buildUserContent(
      BuildContext context, ApplicationState appState) {
    return [
      Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              StyledText("Hi, " + appState.getUserName() + "!"),
              MaterialButton(
                onPressed: () async {
                  appState.signOut();
                },
                child: StyledText.color('Sign out', Thema.buttonInvertedTextColor),
                color: Thema.buttonInvertedColor,
                textColor: Thema.buttonInvertedTextColor,
              ),
            ],
          ),
        ),
      ),
      const Divider(
        height: 1,
        thickness: 1,
      ),
      ListTile(
        title: StyledText('My account'),
        onTap: () {
          Navigator.pushNamed(context, "/account/");
        },
      )
    ];
  }

  List<Widget> _buildContent(BuildContext context, ApplicationState appState) {
    if (appState.loginState != ApplicationLoginState.loggedIn) {
      return _buildGuestContent(context);
    }
    return _buildUserContent(context, appState);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ApplicationState>(
        builder: (context, appState, _) => Drawer(
                child: Container(
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [
                            Thema.topBaseColor,
                            Thema.bottomBaseColor,
                          ],
                        )),
                    child: ListView(children: _buildContent(context, appState)))));
  }
}
