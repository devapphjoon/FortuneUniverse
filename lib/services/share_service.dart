import 'dart:io';
import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class ShareService {
  static Future<void> shareScreenshot(ScreenshotController controller, String shareText) async {
    try {
      final image = await controller.capture(pixelRatio: 3.0);
      if (image == null) return;

      final directory = await getTemporaryDirectory();
      final imagePath = await File('${directory.path}/screenshot_${DateTime.now().millisecondsSinceEpoch}.png').create();
      await imagePath.writeAsBytes(image);

      // share_plus >= 7.0.0 version uses shareXFiles
      await Share.shareXFiles([XFile(imagePath.path)], text: shareText);
    } catch (e) {
      debugPrint("Error capturing/sharing screenshot: $e");
    }
  }
}
