import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class ChatEditBar extends StatefulWidget {
  final void Function(types.PartialText) onSendPressed;

  const ChatEditBar({
    super.key,
    required this.onSendPressed,
  });

  @override
  State<ChatEditBar> createState() => _ChatEditBarState();
}

class _ChatEditBarState extends State<ChatEditBar> {
  final TextEditingController _editController =
      TextEditingController(text: 'Message?');
  final FocusNode _focusNode = FocusNode();

  void _send(String query) {
    if (query.isEmpty) return;

    widget.onSendPressed(types.PartialText(text: query));

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
                    onPressed: () {
                      // TODO: Implement audio recording functionality
                      // Here we would:
                      // 1. Request microphone permissions
                      // 2. Start/stop audio recording
                      // 3. Save the recorded audio
                      // 4. Send the audio message
                    },
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
