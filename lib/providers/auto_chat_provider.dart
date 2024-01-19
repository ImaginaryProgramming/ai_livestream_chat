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
  static const _errorDelay = Duration(seconds: 5);

  void start() {
    if (!state) {
      state = true;
      run();
    }
  }

  void stop() {
    state = false;
  }

  Future<void> run() async {
    while (state) {
      try {
        final request = ref.read(geminiRequestProvider);

        await ref.read(screenshotListProvider.notifier).takeScreenshot();
        await ref.read(geminiChatProvider.notifier).sendMessage(request);
      } catch (e) {
        print("_screenshotCycle caught an exception: $e");
        await Future.delayed(_errorDelay);
      } finally {
        ref.read(screenshotListProvider.notifier).resetState();
      }
    }
  }

  @override
  bool build() {
    return false;
  }
}
