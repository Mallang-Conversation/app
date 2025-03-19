import 'package:flutter/material.dart';
import 'screens/chat/chat_page.dart';
import 'services/chat.dart';

// For the testing purposes, you should probably use https://pub.dev/packages/uuid.

void main() {
  fetchAlbum();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => const MaterialApp(
        home: ChatPage(),
      );
}
