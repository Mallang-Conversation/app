import 'dart:convert';
import 'dart:math';
import 'dart:async';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'chat_edit_bar.dart';

// For the testing purposes, you should probably use https://pub.dev/packages/uuid.
String randomString() {
  final random = Random.secure();
  final values = List<int>.generate(16, (i) => random.nextInt(255));
  return base64UrlEncode(values);
}

Future<int> futureNumber() async {
  final number = await Future<int>.delayed(Duration(seconds: 3), () {
    return 100;
  });

  debugPrint(number.toString());
  return number;
}

Future<void> fetchAlbum() async {
  final result =
      await http.get(Uri.parse('https://pokeapi.co/api/v2/pokemon/pikachu'));
  final pikachu = jsonDecode(result.body);
  final id = pikachu['id'];
  debugPrint(id.toString());
}

void main() {
  fetchAlbum();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => const MaterialApp(
        home: MyHomePage(),
      );
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<types.Message> _messages = [];
  final _user = const types.User(id: '82091008-a484-4a89-ae75-a22bf8d6f3ac');

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
                onMicPressed: _handleMicPressed,
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

    _addMessage(textMessage);
  }

  void _handleMicPressed() {}
}
