import 'dart:async';

import 'package:ai_livestream_chat/providers/gemini_chat_provider.dart';
import 'package:ai_livestream_chat/providers/gemini_request_provider.dart';
import 'package:ai_livestream_chat/providers/screenshot_list_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auto_chat_provider.g.dart';

/// When [state] is true, automatically takes screenshots and sends them to Gemini.
///
/// Use [start] and [stop] to toggle.
@riverpod
class AutoChat extends _$AutoChat {
  static const _loopDelay = Duration(seconds: 3);

  void start() {
    if (!state) {
      state = true;
      _runLoop();
    }
  }

  void stop() {
    state = false;
  }

  Future<void> _runLoop() async {
    while (state) {
      unawaited(_runInternal());
      await Future.delayed(_loopDelay);
    }
  }

  Future<void> _runInternal() async {
    try {
      final request = ref.read(geminiRequestProvider);

      await ref.read(screenshotListProvider.notifier).takeScreenshot();
      final images = ref.read(screenshotListProvider);
      ref.read(screenshotListProvider.notifier).resetState();

      await ref.read(geminiChatProvider.notifier).sendMessage(request, images);
    } catch (e) {
      print("_runInternal caught an exception: $e");
    }
  }

  @override
  bool build() {
    return false;
  }
}
