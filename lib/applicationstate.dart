import 'dart:developer' as developer;

import 'package:flutter/cupertino.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'auth/authwidget.dart';
import 'jsonreader.dart';
import 'openai/opanai.dart';
import 'pair.dart';
import 'requests.dart';
import 'tasksdata.dart';
import 'topic.dart';

class ApplicationState extends ChangeNotifier {
  ApplicationState() {
    init();
    _loadOpenAIKey();
  }


  var jsonReader = JsonReader();
  Future<TaskData>? currentTaskData;

  void loadDialog(String topic) {
    currentTaskData = jsonReader.loadDialog(topic);
  }


  OpenAI? openAI;

  Future<String> _readKey() async {
    var parsedJson = await JsonReader.loadParsedJson('assets/key.json');
    if (parsedJson != null && parsedJson["key"] != null) {
      return parsedJson["key"].toString();
    }
    return "";
  }

  Future<Requests?> _readRequestsFile() async {
    var parsedJson = await JsonReader.loadParsedJson('assets/texts/requests.json');
    if (parsedJson != null && parsedJson["requests"] != null) {
      return Requests(parsedJson["requests"]);
    }
    return null;
  }

  Future<Pair> _loadDataForAI() async {
    String key = await _readKey();
    Requests? requests = await _readRequestsFile();

    return Pair(key, requests);
  }

  void _loadOpenAIKey() async {
    var pair = await _loadDataForAI();
    if (pair.right != null) {
      openAI = OpenAI(apiKey: pair.left, requests: pair.right);
      notifyListeners();
    }
  }

  Future<String> loadTopicsOfDiscussion(Topic topic) async {
    if (openAI != null) {
      return await openAI!.startOfDiscussion(topic);
    }
    return "OpenAI is not loaded!";
  }


  ApplicationLoginState _loginState = ApplicationLoginState.emailAddress;
  ApplicationLoginState get loginState => _loginState;
  String? _email;
  String? get email => _email;

  Future<void> init() async {
    await Firebase.initializeApp();
    if (email != null) {
      bool hasAccess = await _checkAccess(email!);
      if (!hasAccess) {
        _loginState = ApplicationLoginState.loggedOut;
        return;
      }
    }
    if (FirebaseAuth.instance.currentUser != null) {
      //workaround hot reload not triggers update
      _loginState = ApplicationLoginState.loggedIn;
      notifyListeners();
      return;
    }

    FirebaseAuth.instance.userChanges().listen((user) {
      if (user != null) {
        _loginState = ApplicationLoginState.loggedIn;
      } else {
        _loginState = ApplicationLoginState.emailAddress;
      }
      notifyListeners();
    });
  }

  void startLoginFlow() {
    _loginState = ApplicationLoginState.emailAddress;
    notifyListeners();
  }

  void verifyEmail(
      String email,
      void Function(FirebaseAuthException e) errorCallback,
      ) async {
    try {
      var methods =
      await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
      if (methods.contains('password')) {
        _loginState = ApplicationLoginState.password;
      } else {
        _loginState = ApplicationLoginState.register;
      }
      _email = email;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      errorCallback(e);
    }
  }

  Future<bool> _checkAccess(String email) async {
    bool hasAccess = true;

    var ref = FirebaseFirestore.instance.collection('tokens').doc(email);
    var snapshot = await ref.get();
    if (!snapshot.exists) {
      hasAccess = false;
      var wl =
      FirebaseFirestore.instance.collection('tokens').doc('waiting_list');
      var wlref = await wl.get();
      if (wlref.exists) {
        developer.log(wlref.data().toString());
        List<String> emails = [];
        var serializedFieldData = wlref.data()!['emails'];
        if (serializedFieldData == null) {
          emails = [];
        } else {
          emails = List.from(serializedFieldData).cast();
        }
        emails.add(email);

        wl =
            FirebaseFirestore.instance.collection('tokens').doc('waiting_list');
        wlref = await wl.get();
        wl.update({'emails': emails});
      }
    }
    return hasAccess;
  }

  Future<void> signInWithEmailAndPassword(
      String email,
      String password,
      void Function(Exception e) errorCallback,
      ) async {
    try {
      var hasAccess = await _checkAccess(email);
      if (!hasAccess) {
        throw Exception('We will give you access after the release');
      }

      var ref = FirebaseFirestore.instance.collection('tokens').doc(email);
      var snapshot = await ref.get();

      if (snapshot.data()!['sender'] != 'c06mtuOsjBe0pb2sf2zMzcu9jQn2' &&
          snapshot.data()!['sender'] != 'BsFOmiJruhQiWBjYZWJ3ackj28m1' &&
          snapshot.data()!['sender'] != 'BCXqgAgNoxUu10FPeD5cCe7poKt2') {
        var serializedData = snapshot.data()!['attempts'];
        serializedData ??= [];
        List<String> attempts = List.from(serializedData).cast();
        attempts.add("0");
        ref.update({'attemptsData': attempts});
        throw Exception('We will give you access after the release!');
      }

      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on Exception catch (e) {
      errorCallback(e);
    }
  }

  void cancelRegistration() {
    _loginState = ApplicationLoginState.emailAddress;
    notifyListeners();
  }

  void registerAccount(String email, String displayName, String password,
      void Function(Exception e) errorCallback) async {
    try {
      var hasAccess = await _checkAccess(email);
      if (!hasAccess) {
        throw Exception('We will give you access after the release');
      }
      var ref = FirebaseFirestore.instance.collection('tokens').doc(email);
      var snapshot = await ref.get();

      if (snapshot.data()!['sender'] != 'c06mtuOsjBe0pb2sf2zMzcu9jQn2' &&
          snapshot.data()!['sender'] != 'BsFOmiJruhQiWBjYZWJ3ackj28m1' &&
          snapshot.data()!['sender'] != 'BCXqgAgNoxUu10FPeD5cCe7poKt2') {
        var serializedData = snapshot.data()!['attempts'];
        if (serializedData == null) {
          serializedData.set([]);
        }
        List<String> attempts = List.from(serializedData).cast();
        attempts.add("0");
        ref.update({'attemptsData': attempts});
        throw Exception('We will give you access after the release!');
      }

      var credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      await credential.user!.updateDisplayName(displayName);
    } on Exception catch (e) {
      errorCallback(e);
    }
  }

  void signOut() {
    FirebaseAuth.instance.signOut();
    notifyListeners();
  }
}
