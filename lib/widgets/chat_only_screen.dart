import 'package:ai_livestream_chat/providers/gemini_chat_provider.dart';
import 'package:ai_livestream_chat/widgets/chat_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatOnlyScreen extends ConsumerWidget {
  const ChatOnlyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatMessages = ref.watch(geminiChatProvider);

    return Scaffold(
      backgroundColor: const Color(0xff18181b),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.arrow_back),
            ),
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  final i = chatMessages.length - 1 - index;
                  final msg = chatMessages[i];
                  return ChatMessage(
                    message: msg,
                    key: ValueKey(i),
                  );
                },
                itemCount: chatMessages.length,
                reverse: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
