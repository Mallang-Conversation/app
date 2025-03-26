import 'dart:convert';
import 'dart:math';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';

import '/screens/chat/chat_edit_bar.dart';
import '/utils/socket.dart';
import '/constants/game.dart';
import '/services/chat.dart';

String randomString() {
  final random = Random.secure();
  final values = List<int>.generate(16, (i) => random.nextInt(255));
  return base64UrlEncode(values);
}

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _ai = const types.User(id: 'A1B2C3D4-E5F6-7890-ABCD-EF1234567890');
  final _user = const types.User(id: '82091008-a484-4a89-ae75-a22bf8d6f3ac');
  final List<types.Message> _messages = [];
  late GameSocket socketChannel;

  @override
  void initState() {
    super.initState();
    socketChannel = GameSocket(
      gameType: wordChain,
      onMessageReceived: _handleReceiveMessage,
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Chat(
          messages: _messages,
          onSendPressed: _handleSendPressed,
          user: _user,
          customBottomWidget: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ChatEditBar(
                onSendPressed: _handleSendPressed,
                onStopRecording: _handleStopRecording,
              ),
              SizedBox(height: MediaQuery.of(context).padding.bottom)
            ],
          ),
        ),
      );

  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message);
    });
  }

  void _handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: randomString(),
      text: message.text,
    );

    socketChannel.sendMessage(message.text);
    _addMessage(textMessage);
  }

  void _handleReceiveMessage(String msg) {
    final textMessage = types.TextMessage(
      author: _ai,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: randomString(),
      text: msg,
    );

    _addMessage(textMessage);
  }

  void _handleStopRecording(File audioFile) async {
    final String res = await fetchSpeechToText(audioFile);
    if (res.isNotEmpty) {
      _handleSendPressed(types.PartialText(text: res));
    }
  }
}
