import 'package:flutter/material.dart';

import '/widgets/styledtext.dart';

class AccountWidget extends StatelessWidget {
  AccountWidget(String userName, {Key? key, required this.signOut})
      : super(key: key) {
    name.text = userName;
  }

  var name = TextEditingController();
  void Function() signOut;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(children: [
          Expanded(flex: 1, child: StyledText("Name")),
          Expanded(flex: 5, child: TextFormField(controller: name)),
        ]),
        ElevatedButton(
          onPressed: () {
            signOut();
          },
          child: const Text('Sign out'),
        )
      ],
    );
  }
}
