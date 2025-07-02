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
  Future<String?> generate(String imagePath, String directoryPath) async {
    try {
      return await compute(_generator, {
        'imagePath': imagePath,
        'directoryPath': directoryPath,
      });
    } catch (e, stack) {
      printException(
        'Thumbnail generation failed (in isolate)',
        exception: e.toString(),
        stack: stack.toString(),
      );
      return null;
    }
  }

  @override
  Future<String> overwrite(String imagePath, String thumbPath) async {
    final originalFile = File(imagePath);
    final thumbFile = File(thumbPath);

    final exists = await originalFile.exists();
    if (imagePath.isEmpty || !exists) {
      printWarning(
        'During thumbnail overwrite: image not found at [$imagePath]. Cannot replace thumbnail',
      );
      return thumbPath;
    }

    try {
      final imageBytes = await originalFile.readAsBytes();
      final originalImage = img.decodeImage(imageBytes);

      if (originalImage == null) {
        printWarning(
          'Failed to decode original image. Using original file as fallback thumbnail',
        );
        final fallbackThumb = await originalFile.copy(thumbPath);
        return fallbackThumb.path;
      }

      final thumbnail = img.copyResize(originalImage, width: 150);

      await thumbFile.writeAsBytes(
        img.encodeJpg(thumbnail, quality: 80),
        flush: true,
      );
      return thumbPath;
    } catch (e, stack) {
      printException(
        'During thumbnail overwrite',
        exception: e.toString(),
        stack: stack.toString(),
      );
      if (exists) {
        final fallbackThumb = await originalFile.copy(thumbPath);
        return fallbackThumb.path;
      }
      return thumbPath;
    }
  }

  @override
  Future<String> replace(String imagePath, String oldThumbPath) async {
    try {
      return await compute(_replacer, {
        'imagePath': imagePath,
        'oldThumbPath': oldThumbPath,
      });
    } catch (e, stack) {
      printException(
        'Thumbnail replacement failed (in isolate)',
        exception: e.toString(),
        stack: stack.toString(),
      );
      return oldThumbPath;
    }
  }
}

String _generateUniqueThumbPath(String directoryPath) {
  final timestamp = DateTime.now().millisecondsSinceEpoch;
  return path.join(directoryPath, 'edited_thumb_$timestamp.jpg');
}

Future<String> _replacer(Map<String, String> args) async {
  final imagePath = args['imagePath']!;
  final oldThumbPath = args['oldThumbPath']!;
  final originalFile = File(imagePath);
  final thumbFile = File(oldThumbPath);

  final exists = await originalFile.exists();
  final oldExists = await thumbFile.exists();

  if (imagePath.isEmpty || !exists) {
    print('<<<< 1');
    return oldThumbPath;
  }

  try {
    final imageBytes = await originalFile.readAsBytes();
    final originalImage = img.decodeImage(imageBytes);
    if (originalImage == null) {
      print('<<<< 2');
      return oldThumbPath;
    }

    final thumbnail = img.copyResize(originalImage, width: 150);
    final newThumbPath = _generateUniqueThumbPath(thumbFile.parent.path);

    final newThumbFile = File(newThumbPath);
    await newThumbFile.writeAsBytes(
      img.encodeJpg(thumbnail, quality: 80),
      flush: true,
    );

    if (oldExists) {
      await thumbFile.delete();
    }

    return newThumbPath;
  } catch (_) {
    print('<<<< 3');
    return oldThumbPath;
  }
}

Future<String?> _generator(Map<String, String> args) async {
  final imagePath = args['imagePath'] as String;
  final directoryPath = args['directoryPath'] as String;

  final originalFile = File(imagePath);
  final exists = await originalFile.exists();

  if (imagePath.isEmpty || !exists) {
    printWarning(
      'During thumbnail generation: imagePath: $imagePath | exists: $exists',
    );
    return null;
  }

  final thumbName = 'thumb_${path.basenameWithoutExtension(imagePath)}.jpg';
  final thumbPath = path.join(directoryPath, thumbName);

  try {
    final imageBytes = await originalFile.readAsBytes();
    final originalImage = img.decodeImage(imageBytes);

    if (originalImage == null) {
      printWarning(
        'Failed to decode image => Opted to use original as thumbnail',
      );
      final fallbackThumb = await originalFile.copy(thumbPath);
      return fallbackThumb.path;
    }

    final thumbnail = img.copyResize(originalImage, width: 150);
    final File thumbnailFile = File(thumbPath);

    await thumbnailFile.writeAsBytes(
      img.encodeJpg(thumbnail, quality: 80),
      flush: true,
    );

    return thumbnailFile.path;
  } catch (e, stack) {
    printException(
      'During thumbnail generation',
      exception: e.toString(),
      stack: stack.toString(),
    );

    if (exists) {
      final fallbackThumb = await originalFile.copy(thumbPath);
      return fallbackThumb.path;
    }

    return thumbPath;
  }
}
