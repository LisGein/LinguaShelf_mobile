import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../applicationstate.dart';
import '../thema.dart';
import '../styles.dart';
import '../widgets/styledtext.dart';
import 'basepage.dart';

class PremiumPage extends BasePage {
  const PremiumPage({Key? key}) : super(key: key);

  @override
  Widget buildBody(BuildContext context) {
    return Consumer<ApplicationState>(builder: (context, appState, _) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: StyledText(
              'Thank you for your interest in our premium subscription! The app is under development.',
              style: Styles.getTextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: StyledText(
              'We can notify you soon as the premium is available:',
              style: Styles.getTextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          if (!appState.isPremiumNotificationOn())
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: MaterialButton(
                onPressed: () {
                  appState.updateNotificationSettings(true);
                },
                child: StyledText.color('Notify me', Thema.buttonTextColor),
                color: Thema.buttonColor,
                textColor: Thema.buttonTextColor,
              ),
            ),
          if (appState.isPremiumNotificationOn())
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: MaterialButton(
                onPressed: () {
                  appState.updateNotificationSettings(false);
                },
                child: StyledText.color('Don\'t notify me', Thema.buttonInvertedTextColor),
                color: Thema.buttonInvertedColor,
                textColor: Thema.buttonInvertedTextColor,
              ),
            )
        ],
      );
    });
  }
}
