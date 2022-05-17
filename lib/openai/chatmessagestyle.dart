import '../pair.dart';

enum Sender { User, AI }

class ChatMessageStyle {
  ChatMessageStyle({required this.sender, required this.styleToText});

  Sender sender;
  List<Pair> styleToText;
}