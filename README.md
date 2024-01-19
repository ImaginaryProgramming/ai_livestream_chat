# ai_livestream_chat

A desktop app built in Flutter, which uses [Gemini](https://deepmind.google/technologies/gemini/) to make a fake livestream chat.

Intended as a fun project, not as a replacement for a real live chat.

## Setup
1. Get your [Gemini API Key](https://makersuite.google.com/app/apikey).
2. Create a file at `lib/key.dart` (ignored by `.gitignore`).
3. Open `key.dart` and add this line:
```dart
const geminiApiKey = "API_KEY_HERE";`
```
4. Replace `API_KEY_HERE` with your API key.
5. Run the app as a desktop build. ([How to run a Flutter app](https://docs.flutter.dev/get-started/test-drive#run-your-sample-flutter-app))
