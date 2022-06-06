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

  Future<void> loadOpenAIKey() async {
    String userID = getUserID();
    if (openAI == null || !openAI!.isInitialized()) {
      var pair = await _loadDataForAI();
      if (pair.right != null) {
        openAI = OpenAI(apiKey: pair.left, requests: pair.right, userID: userID);
      }
    }
    openAI!.updateUserID(userID);
    notifyListeners();
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
      var credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      await credential.user!.updateDisplayName(displayName);
    } on Exception catch (e) {
      errorCallback(e);
    }
  }

  String getUserName() {
    String? displayName;
    if (FirebaseAuth.instance.currentUser != null) {
      displayName = FirebaseAuth.instance.currentUser!.displayName;
    }
    return displayName ?? "Guest";
  }

  String getUserID() {
    String? id;
    if (FirebaseAuth.instance.currentUser != null) {
      id = FirebaseAuth.instance.currentUser!.uid;
    }
    return id ?? "Guest";
  }

  void signOut() {
    FirebaseAuth.instance.signOut();
    _loginState = ApplicationLoginState.loggedOut;
    notifyListeners();
  }


  Future<void> loadUserCollection(BuildContext context) async {
    String userID = getUserID();
    final CollectionReference postsRef = FirebaseFirestore.instance.collection('users');
    var documentReference =
    postsRef.doc(userID);

    var snapshotDoc = await documentReference.get();
    if (!snapshotDoc.exists) {
      postsRef.doc(userID).set({
        'account_type' : 'free',
        'conversations': []
      });
    }

    documentReference.snapshots().listen((document) {
      _readFields(snapshotDoc, userID).then((value) => notifyListeners());
    });

  }

  List<Timestamp> conversations = [];
  String accountType = "";

  Future<void> _readFields(dynamic snapshot, String userID) async {
    var document = FirebaseFirestore.instance.collection('users').doc(userID);
    var documentRef = await document.get();
    var type = documentRef.data()?['account_type'];
    if (type == null) {
      accountType = "free";
      document.update({'account_type': accountType});
    }
    else {
      accountType = type.toString();
    }

    await _readConversationsData();
  }

  Future<void> _readConversationsData() async {
    String userID = getUserID();
    var document = FirebaseFirestore.instance.collection('users').doc(userID);
    var documentRef = await document.get();


    var serializedFieldData = documentRef.data()?['conversations'];
    if (serializedFieldData == null) {
      conversations = [];
      document.update({'conversations': conversations});
    } else {
      conversations = List.from(serializedFieldData).cast();
    }
  }

  Future<void> onOpenedConversation() async {
    await _readConversationsData();

    String userID = getUserID();
    var document = FirebaseFirestore.instance.collection('users').doc(userID);


    var now = DateTime.now();

    conversations.removeWhere((stamp) {
      DateTime stampDateTime = stamp.toDate();
      return stampDateTime.day != now.day || stampDateTime.month != now.month || stampDateTime.year != now.year;
    });

    conversations.add(Timestamp.fromDate(now));

    document.update({'conversations': conversations});
    notifyListeners();
  }

  bool isLimitReached() {
    const int limit = 5;

    if (conversations.length < limit) {
      return false;
    }

    int number = 0;
    var now = DateTime.now();
    for (var stamp in conversations) {
      DateTime stampDateTime = stamp.toDate();
      if (stampDateTime.day == now.day && stampDateTime.month == now.month && stampDateTime.year == now.year) {
        ++number;
      }
    }

    return number > limit;
  }
}
