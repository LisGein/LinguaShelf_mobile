import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../applicationstate.dart';
import 'authwidget.dart';

class LoginWidget extends StatelessWidget {
  const LoginWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Consumer<ApplicationState>(
            builder: (context, appState, _) {
              return AuthWidget(
                email: appState.email,
                loginState: appState.loginState,
                startLoginFlow: appState.startLoginFlow,
                verifyEmail: appState.verifyEmail,
                signInWithEmailAndPassword: appState.signInWithEmailAndPassword,
                cancelRegistration: appState.cancelRegistration,
                registerAccount: appState.registerAccount,
                signOut: appState.signOut,
                getUserName: appState.getUserName,
              );
            }
        )
      ],
    );
  }
}