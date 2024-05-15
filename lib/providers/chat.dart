// ignore_for_file: avoid_print

import '../../models/message.dart';
import 'package:flutter/foundation.dart';

// Provider class to display live messages
class ChatProvider extends ChangeNotifier {
  final List<Message> _messages = [];

  List<Message> get messages => _messages;

  addNewMessage(Message message) {
    print(_messages);
    _messages.add(message);
    notifyListeners();
  }
}
