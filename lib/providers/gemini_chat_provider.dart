import 'dart:async';

import 'package:ai_livestream_chat/providers/screenshot_list_provider.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'gemini_chat_provider.g.dart';

@riverpod
class GeminiChat extends _$GeminiChat {
  static const _delayBetweenSpacedMessages = Duration(milliseconds: 1000);

  Future<void> sendMessage(String message) async {
    final images = ref.read(screenshotListProvider);

    if (message.isEmpty) {
      print("Message is empty, not sending.");
      return;
    }

    if (images.isEmpty) {
      print("Must provide an image. Not sending.");
      return;
    }

    print("Sending a message...");
    final sw = Stopwatch()..start();

    final response = await Gemini.instance.textAndImage(
      text: message,
      images: images,
      generationConfig: GenerationConfig(temperature: 1),
      safetySettings: [
        // mods are in chat
        SafetySetting(
          category: SafetyCategory.sexuallyExplicit,
          threshold: SafetyThreshold.blockLowAndAbove,
        ),
      ],
    );

    sw.stop();
    print("Generation took ${sw.elapsedMilliseconds}ms");

    final responseMessages = response?.content?.parts?.firstOrNull?.text;
    final parsedChatMessages = <String>[];
    if (responseMessages != null) {
      // Get chat messages from the response
      for (var msg in responseMessages.split("\n")) {
        parsedChatMessages.add(msg);
      }
    }

    // Start another Future to slowly add the messages into chat.
    // Don't await the Future so that this function can return, and a new chat can start processing.
    unawaited(_addSpacedMessages(parsedChatMessages));
  }

  void addTestMessage() {
    state = [
      ...state,
      "**testUser${DateTime.now().second}**: Hello world! ${DateTime.now().millisecond}",
    ];
  }

  void reset() {
    state = [];
  }

  Future<void> _addSpacedMessages(List<String> messages) async {
    for (var message in messages) {
      state = [...state, message];
      await Future.delayed(_delayBetweenSpacedMessages);
    }
  }

  @override
  List<String> build() {
    return [];
  }
}
