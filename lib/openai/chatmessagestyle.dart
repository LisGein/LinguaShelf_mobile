import '../pair.dart';

enum Sender { user, ai }

class ChatMessageStyle {
  ChatMessageStyle({required this.sender, required this.styleToText});

  Sender sender;
  List<Pair> styleToText;
}