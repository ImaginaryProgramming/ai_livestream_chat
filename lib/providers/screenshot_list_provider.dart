import 'dart:io';
import 'dart:typed_data';

import 'package:image_compression/image_compression.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:screen_capturer/screen_capturer.dart';
import 'package:url_launcher/url_launcher.dart';

part 'screenshot_list_provider.g.dart';

@riverpod
class ScreenshotList extends _$ScreenshotList {
  Future<void> takeScreenshot({
    CaptureMode captureMode = CaptureMode.screen,
  }) async {
    final folderPath = await _getFolderPath();
    final imageName = "Screenshot-${DateTime.now().millisecondsSinceEpoch}.jpg";
    final imagePath = "$folderPath/$imageName";

    final sw = Stopwatch()..start();

    final capturedData = await screenCapturer.capture(
      mode: captureMode,
      imagePath: imagePath,
      copyToClipboard: true,
    );

    // Get bytes
    var rawBytes = capturedData?.imageBytes;
    if (captureMode == CaptureMode.screen && rawBytes == null) {
      // Screen capture does not return bytes, so load them from the file
      rawBytes = await File(imagePath).readAsBytes();
    }

    if (rawBytes != null) {
      final fileToCompress = ImageFile(
        filePath: imagePath,
        rawBytes: rawBytes,
      );
      final compressedImage = await compressInQueue(ImageFileConfiguration(
        input: fileToCompress,
        config: const Configuration(jpgQuality: 50),
      ));
      final compressedBytes = compressedImage.rawBytes;

      print(
          "Compressed from ${fileToCompress.sizeInBytes} bytes to ${compressedImage.sizeInBytes} bytes");

      state = [...state, compressedBytes];
    }

    sw.stop();
    print("Saving and compressing image took ${sw.elapsedMilliseconds}ms");
  }

  void resetState() {
    state = [];
  }

  Future<void> openScreenshotFolder() async {
    final path = await _getFolderPath();
    launchUrl(Uri.file(path));
  }

  Future<String> _getFolderPath() async {
    final directory = await getTemporaryDirectory();
    return "${directory.path}/AILiveChat/Screenshots";
  }

  @override
  List<Uint8List> build() {
    return [];
  }
}
