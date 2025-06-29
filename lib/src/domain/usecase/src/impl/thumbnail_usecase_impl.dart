import 'dart:io';
import 'dart:typed_data';
import 'package:path/path.dart' as path;
import 'package:image/image.dart' as img;
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scanly_test/src/domain/core/core.dart';
import 'package:scanly_test/src/domain/usecase/src/thumbnail_usecase.dart';

final class ThumbnailUsecaseImpl implements ThumbnailUsecase {
  @override
  Future<String> generate(String imagePath, {String? directoryPath}) async {
    final File originalFile = File(imagePath);

    final exists = await originalFile.exists();
    if (imagePath.isEmpty || !exists) {
      throw Exception('Invalid image path: $imagePath');
    }

    String thumbPath;
    final thumbName = 'thumb_${path.basenameWithoutExtension(imagePath)}.jpg';
    if (directoryPath == null || directoryPath.isEmpty) {
      final dir = await getApplicationDocumentsDirectory();
      thumbPath = path.join(dir.path, thumbName);
    } else {
      thumbPath = path.join(directoryPath, thumbName);
    }

    final Uint8List imageBytes = await originalFile.readAsBytes();

    try {
      img.Image? originalImage = img.decodeImage(imageBytes);

      if (originalImage == null) {
        printWarning(
          'Failed to decode image => Opted to use original as thumbnail',
        );
        final fallbackThumb = await originalFile.copy(thumbPath);
        return fallbackThumb.path;
      }

      final thumbnail = img.copyResize(originalImage, width: 150);
      final File thumbnailFile = File(thumbPath);
      await thumbnailFile.writeAsBytes(img.encodeJpg(thumbnail, quality: 80));

      return thumbnailFile.path;
    } catch (e, stack) {
      printException(
        'During thumbnail generation',
        exception: e.toString(),
        stack: stack.toString(),
      );
      final fallbackThumb = await originalFile.copy(thumbPath);
      return fallbackThumb.path;
    }
  }
}
