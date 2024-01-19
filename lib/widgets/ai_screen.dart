import 'package:ai_livestream_chat/providers/auto_chat_provider.dart';
import 'package:ai_livestream_chat/providers/gemini_chat_provider.dart';
import 'package:ai_livestream_chat/providers/gemini_request_provider.dart';
import 'package:ai_livestream_chat/providers/screenshot_list_provider.dart';
import 'package:ai_livestream_chat/widgets/chat_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AiScreen extends ConsumerStatefulWidget {
  const AiScreen({super.key});

  @override
  ConsumerState<AiScreen> createState() => _AiScreenState();
}

class _AiScreenState extends ConsumerState<AiScreen> {
  final _chatScrollController = ScrollController();
  final _textController = TextEditingController();

  @override
  void initState() {
    _textController.text = ref.read(geminiRequestProvider);
    _textController.addListener(() {
      ref.read(geminiRequestProvider.notifier).setRequest(_textController.text);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final isAutoChatRunning = ref.watch(autoChatProvider);
    final chatMessages = ref.watch(geminiChatProvider);
    final images = ref.watch(screenshotListProvider);

    final imageWidgets = images
        .map(
          (imageBytes) => Image.memory(
            imageBytes,
            height: 100,
            width: 100,
          ),
        )
        .toList();

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          // Note that this widget only seems to listen to the stream.
          Container(
            color: Colors.black12,
            padding: const EdgeInsets.all(8),
            child: SizedBox(
              height: 200,
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
                controller: _chatScrollController,
                reverse: true,
              ),
            ),
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton.filled(
                onPressed: () {
                  if (isAutoChatRunning) {
                    ref.read(autoChatProvider.notifier).stop();
                  } else {
                    ref.read(autoChatProvider.notifier).start();
                  }
                },
                icon: isAutoChatRunning
                    ? const Icon(Icons.stop)
                    : const Icon(Icons.play_arrow),
              ),
              // const SizedBox(width: 8),
              IconButton.filled(
                onPressed: () => ref.read(geminiChatProvider.notifier).reset(),
                icon: const Icon(Icons.clear),
              ),
            ],
          ),
          const SizedBox(height: 32),
          const Text("Images"),
          const SizedBox(height: 4),
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: 100,
                    child: Wrap(
                      children: imageWidgets,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => ref
                            .read(screenshotListProvider.notifier)
                            .takeScreenshot(),
                        icon: const Icon(Icons.camera_alt),
                      ),
                      IconButton(
                        onPressed: () => ref
                            .read(screenshotListProvider.notifier)
                            .openScreenshotFolder(),
                        icon: const Icon(Icons.folder),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _textController,
            maxLines: null,
            style: theme.textTheme.bodyMedium,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Prompt",
            ),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () => ref
                .read(geminiChatProvider.notifier)
                .sendMessage(_textController.text),
            child: const Text("Send"),
          ),
          const SizedBox(height: 8),
          FilledButton(
            onPressed: () =>
                ref.read(geminiChatProvider.notifier).addTestMessage(),
            child: const Text("Send test message"),
          ),
        ],
      ),
    );
  }
}
