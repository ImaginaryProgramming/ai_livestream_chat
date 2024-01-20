// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auto_chat_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$autoChatHash() => r'18af4b5598650f6255d6f42820371f3a037b660b';

/// When [state] is true, automatically takes screenshots and sends them to Gemini.
///
/// Use [start] and [stop] to toggle.
///
/// Copied from [AutoChat].
@ProviderFor(AutoChat)
final autoChatProvider = AutoDisposeNotifierProvider<AutoChat, bool>.internal(
  AutoChat.new,
  name: r'autoChatProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$autoChatHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AutoChat = AutoDisposeNotifier<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
