import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:google_sign_in/google_sign_in.dart';

import '../widgets/accountwidget.dart';
import '../widgets/styledtext.dart';

enum ApplicationLoginState {
  loggedOut,
  emailAddress,
  register,
  password,
  loggedIn,
}

class AuthWidget extends StatelessWidget {
  const AuthWidget({Key? key,
    required this.loginState,
    required this.email,
    required this.startLoginFlow,
    required this.verifyEmail,
    required this.signInWithEmailAndPassword,
    required this.cancelRegistration,
    required this.registerAccount,
    required this.signOut,
    required this.getUserName,
  }): super(key: key);

  final ApplicationLoginState loginState;
  final String? email;
  final void Function() startLoginFlow;
  final void Function(
      String email,
      void Function(Exception e) error,
      ) verifyEmail;
  final Future<void> Function(
      String email,
      String password,
      void Function(Exception e) error,
      ) signInWithEmailAndPassword;
  final void Function() cancelRegistration;
  final void Function(
      String email,
      String displayName,
      String password,
      void Function(Exception e) error,
      ) registerAccount;
  final void Function() signOut;
  final String Function() getUserName;

  @override
  Widget build(BuildContext context) {
    switch (loginState) {
      case ApplicationLoginState.loggedOut:
        return Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 24, bottom: 8),
              child: ElevatedButton(
                onPressed: () {
                  startLoginFlow();
                },
                child: const Text('RSVP'),
              ),
            ),
          ],
        );
      case ApplicationLoginState.emailAddress:
        return EmailForm(
            callback: (email) => verifyEmail(
                email, (e) => _showErrorDialog(context, 'Invalid email', e)));
      case ApplicationLoginState.password:
        return PasswordForm(
          email: email!,
          login: (email, password) {
            signInWithEmailAndPassword(email, password,
                    (e) => _showErrorDialog(context, 'Failed to sign in', e));
          },
        );
      case ApplicationLoginState.register:
        return RegisterForm(
          email: email!,
          cancel: () {
            cancelRegistration();
          },
          registerAccount: (
              email,
              displayName,
              password,
              ) {
            registerAccount(
                email,
                displayName,
                password,
                    (e) =>
                    _showErrorDialog(context, 'Failed to create account', e));
          },
        );
      case ApplicationLoginState.loggedIn:
        return AccountWidget(getUserName(), signOut: signOut);
      default:
        return Row(
          children: const [
            Text("Internal error, this shouldn't happen..."),
          ],
        );
    }
  }

  void _showErrorDialog(BuildContext context, String title, Exception e) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            title,
            style: const TextStyle(fontSize: 24),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  '${(e as dynamic).message}',
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'OK',
                style: TextStyle(color: Colors.deepPurple),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _AuthFormContainer extends StatelessWidget {
  final String title;
  final Widget body;

  const _AuthFormContainer({required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
      constraints: const BoxConstraints(maxWidth: 800, maxHeight: 400),
      child: Card(
          child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: body,
      )),
    ));
  }
}

class EmailForm extends StatefulWidget {
  EmailForm({Key? key, required this.callback}) : super(key: key);

  final void Function(String email) callback;

  @override
  _EmailFormState createState() => _EmailFormState();
}

class _EmailFormState extends State<EmailForm> {
  final _formKey = GlobalKey<FormState>(debugLabel: '_EmailFormState');
  final _controller = TextEditingController();

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  @override
  Widget build(BuildContext context) {
    return _AuthFormContainer(
      title: 'Sign in with email',
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: TextFormField(
                controller: _controller,
                decoration: const InputDecoration(
                  hintText: 'Enter your email',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Enter your email address to continue';
                  }
                  return null;
                },
                onEditingComplete: () {
                  if (_formKey.currentState!.validate()) {
                    widget.callback(_controller.text);
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    widget.callback(_controller.text);
                  }
                },
                child: StyledText('Next'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                  onPressed: () async {
                    signInWithGoogle();
                  },
                  child: StyledText('Sign in with Google')),
            ),
          ],
        ),
      ),
    );
  }
}

class RegisterForm extends StatefulWidget {
  const RegisterForm({
    Key? key,
    required this.registerAccount,
    required this.cancel,
    required this.email,
  }) : super(key: key);

  final String email;
  final void Function(String email, String displayName, String password)
      registerAccount;
  final void Function() cancel;

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>(debugLabel: '_RegisterFormState');
  final _emailController = TextEditingController();
  final _displayNameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _emailController.text = widget.email;
  }

  @override
  Widget build(BuildContext context) {
    return _AuthFormContainer(
      title: 'Create account',
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  hintText: 'Enter your email',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Enter your email address to continue';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: TextFormField(
                controller: _displayNameController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'First & last name',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Enter your account name';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: TextFormField(
                controller: _passwordController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Password',
                ),
                obscureText: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Enter your password';
                  }
                  return null;
                },
                onEditingComplete: () {
                  if (_formKey.currentState!.validate()) {
                    widget.registerAccount(
                      _emailController.text,
                      _displayNameController.text,
                      _passwordController.text,
                    );
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: widget.cancel,
                    child: const Text('CANCEL'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        widget.registerAccount(
                          _emailController.text,
                          _displayNameController.text,
                          _passwordController.text,
                        );
                      }
                    },
                    child: const Text('SAVE'),
                  ),
                  const SizedBox(width: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PasswordForm extends StatefulWidget {
  const PasswordForm({
    Key? key,
    required this.login,
    required this.email,
  }) : super(key: key);

  final String email;
  final void Function(String email, String password) login;

  @override
  _PasswordFormState createState() => _PasswordFormState();
}

class _PasswordFormState extends State<PasswordForm> {
  final _formKey = GlobalKey<FormState>(debugLabel: '_PasswordFormState');
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _emailController.text = widget.email;
  }

  @override
  Widget build(BuildContext context) {
    return _AuthFormContainer(
      title: 'Sign in',
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  hintText: 'Enter your email',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Enter your email address to continue';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: TextFormField(
                controller: _passwordController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Password',
                ),
                obscureText: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Enter your password';
                  }
                  return null;
                },
                onEditingComplete: () {
                  if (_formKey.currentState!.validate()) {
                    widget.login(
                      _emailController.text,
                      _passwordController.text,
                    );
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        widget.login(
                          _emailController.text,
                          _passwordController.text,
                        );
                      }
                    },
                    child: const Text('SIGN IN'),
                  ),
                  const SizedBox(width: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
