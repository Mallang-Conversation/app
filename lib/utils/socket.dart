import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '/constants/common.dart';

class GameSocket {
  final String gameType;
  final Function(String) onMessageReceived;

  late WebSocketChannel channel;

  GameSocket({
    required this.gameType,
    required this.onMessageReceived,
  }) {
    connect();
  }

  void connect() async {
    channel = WebSocketChannel.connect(
      Uri.parse('$chatSocketUrl?game=$gameType'),
    );

    try {
      await channel.ready;
    } catch (e) {
      debugPrint('WebSocket connection error: $e');
    }

    debugPrint('WebSocket connected!!');

    channel.stream.listen(
      (message) {
        debugPrint('WebSocket message: $message');
        onMessageReceived(message);
      },
      onError: (error) {
        debugPrint('WebSocket error: $error');
      },
      onDone: () {
        debugPrint('WebSocket connection closed');
      },
    );
  }

  void sendMessage(String msg) {
    channel.sink.add(msg);
  }

  void closeConnect() {
    channel.sink.close();
  }

  void reconnect() {
    closeConnect();
    connect();
  }
}
