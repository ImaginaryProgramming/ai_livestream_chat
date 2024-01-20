import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class ChatMessage extends StatefulWidget {
  final String message;

  const ChatMessage({
    required this.message,
    super.key,
  });

  @override
  State<ChatMessage> createState() => _ChatMessageState();
}

class _ChatMessageState extends State<ChatMessage> {
  late final Color usernameColor;
  static final usernameColorMap = {};

  @override
  void initState() {
    usernameColor = _getRandomColor();
    super.initState();
  }

  Color _getRandomColor() {
    // Check if we've saved a color for this user
    final usernameRegex = RegExp(r'\*\*(.+)\*\*');
    final username = usernameRegex
        .matchAsPrefix(widget.message.trim())
        ?.group(1)
        ?.toLowerCase();
    if (username != null) {
      final saved = usernameColorMap[username];
      if (saved != null) {
        return saved;
      }
    }

    // Get a random color for the username
    final rand = Random();
    // Hue 0-360
    final hue = rand.nextDouble() * 360;
    // Saturation 0.5-1.0
    final sat = rand.nextDouble() * 0.5 + 0.5;
    // Value 0.5-1.0
    final val = rand.nextDouble() * 0.5 + 0.5;
    final randomColor = HSVColor.fromAHSV(1, hue, sat, val).toColor();

    // Save color for user
    if (username != null) {
      usernameColorMap[username] = randomColor;
    }
    return randomColor;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: MarkdownBody(
        data: widget.message,
        styleSheet: MarkdownStyleSheet(
          strong: TextStyle(color: usernameColor),
        ),
      ),
    );
  }
}
