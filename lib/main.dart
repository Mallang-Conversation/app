import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';

// For the testing purposes, you should probably use https://pub.dev/packages/uuid.
String randomString() {
  final random = Random.secure();
  final values = List<int>.generate(16, (i) => random.nextInt(255));
  return base64UrlEncode(values);
}

void main() {
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
        body: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const ChatEditBar(),
            SizedBox(height: MediaQuery.of(context).padding.bottom)
          ],
        ),
      );

  // @override
  // Widget build(BuildContext context) => Scaffold(
  //       body: Chat(
  //         messages: _messages,
  //         onSendPressed: _handleSendPressed,
  //         user: _user,
  //       ),
  //     );

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
}

class ChatEditBar extends StatefulWidget {
  const ChatEditBar({super.key});

  @override
  State<ChatEditBar> createState() => _ChatEditBarState();
}

class _ChatEditBarState extends State<ChatEditBar> {
  final TextEditingController _editController =
      TextEditingController(text: 'Message?');
  final FocusNode _focusNode = FocusNode();

  void _send(String query) {
    if (query.isEmpty) return;

    // context.read(chatListProvider.notifier).add(
    //       Chat(
    //         request: ChatRequest(
    //           model: dotenv.env['CHAT_MODEL']!,
    //           messages: [Message(content: query)],
    //         ),
    //       ),
    //     );

    _editController.clear();
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _editController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      height: 48,
      child: Row(
        children: [
          Expanded(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28.0),
                boxShadow: const [
                  BoxShadow(
                    offset: Offset(0, 2),
                    blurRadius: 4,
                    color: Colors.grey,
                  )
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 12.0),
                        hintText: "Message?",
                        border: InputBorder.none,
                      ),
                      textInputAction: TextInputAction.send,
                      focusNode: _focusNode,
                      controller: _editController,
                      onSubmitted: _send,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.graphic_eq),
                  ),
                  const SizedBox(width: 8.0),
                ],
              ),
            ),
          ),
          IconButton(
            padding: EdgeInsets.zero,
            alignment: Alignment.centerRight,
            iconSize: 32.0,
            onPressed: () => _send(_editController.text),
            icon: const Icon(Icons.arrow_circle_up_rounded),
          ),
        ],
      ),
    );
  }
}
