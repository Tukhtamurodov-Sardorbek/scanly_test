import 'dart:async';
import 'dart:io';
import 'dart:typed_data' show Uint8List;

import 'package:flutter/foundation.dart' show compute;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:scanly_test/src/domain/core/core.dart';
import 'package:scanly_test/src/domain/model/model.dart';
import 'package:scanly_test/src/domain/repository/repository.dart';

import 'package:scanly_test/src/domain/usecase/src/scanner_usecase.dart';

final class ScannerUsecaseImpl implements ScannerUsecase {
  final CunningDocumentScanner _scanner;
  final DBRepository _repository;

  const ScannerUsecaseImpl(this._scanner, this._repository);

  @override
  Future<List<String>?> get scan async {
    try {
      final cachedPaths = await CunningDocumentScanner.getPictures();
      return cachedPaths;
    } catch (e, s) {
      printException(
        'During CunningDocumentScanner.getPictures() execution',
        exception: e.toString(),
        stack: s.toString(),
      );
    }
    return null;
  }

  @override
  Future<Directory> createGroupDirectory(String groupName) async {
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final Directory groupDir = Directory(path.join(appDocDir.path, groupName));

    if (!await groupDir.exists()) {
      await groupDir.create(recursive: true);
    }
    return groupDir;
  }

  @override
  Future<List<String>> movePicturesFromCacheToPersistentStorage(
    List<String> cachedPaths,
    String directoryPath,
  ) async {
    return await compute(_mover, {
      'cachedPaths': cachedPaths,
      'directoryPath': directoryPath,
    });
  }

  @override
  Future<String?> overwriteImage(
    Uint8List editedImageBytes,
    String originalPath, {
    bool canDelete = true,
  }) async {
    /// Overwriting leads to image caching issue -> UI continues displaying the old version from cache
    /// The following work-around is not that efficient, yet leads to an expected behavior
    ///  final imageFile = File('/data/user/0/.../81389142871292.jpg');
    ///  imageCache.clear();
    ///  imageCache.evict(FileImage(imageFile));
    /// setState(() {});
    // final file = File(originalPath);
    // try {
    //   await file.writeAsBytes(editedImageBytes, flush: true);
    //   return true;
    // } catch (e) {
    //   return false;
    // }

    /// So, I rather opt to save the edited image with a unique name and delete the old image
    try {
      return await compute(_replacer, {
        'bytes': editedImageBytes,
        'originalPath': originalPath,
        'canDelete': canDelete,
      });
    } catch (e, s) {
      printException(
        'Failed to replace image in isolate:',
        exception: e.toString(),
        stack: s.toString(),
      );
      return null;
    }
  }

  @override
  Future<int> saveGroup(Map<String, dynamic> data) =>
      _repository.insertGroup(data);

  @override
  Future<List<ScanGroup>> getAllGroups() => _repository.getAllGroups();

  @override
  Future<int> updateGroup(ScanGroup group) => _repository.updateGroup(group);

  @override
  Future<int> deleteGroup(int id) => _repository.deleteGroup(id);
}

Future<String?> _replacer(Map<String, dynamic> params) async {
  final editedImageBytes = params['bytes'] as Uint8List;
  final originalPath = params['originalPath'] as String;
  final canDelete = params['canDelete'] as bool;

  try {
    final file = File(originalPath);
    final exists = await file.exists();

    final directory = file.parent;
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final extension = path.extension(originalPath);
    final newFileName =
        'edited_${path.basenameWithoutExtension(originalPath)}_$timestamp$extension';
    final newPath = path.join(directory.path, newFileName);

    final newFile = File(newPath);
    await newFile.writeAsBytes(editedImageBytes, flush: true);

    if (canDelete && exists) {
      await file.delete();
    }

    return newPath;
  } catch (_) {
    return null;
  }
}

Future<List<String>> _mover(Map<String, dynamic> params) async {
  final cachedPaths = params['cachedPaths'] as List<String>;
  final directoryPath = params['directoryPath'] as String;

  List<String> savedPaths = [];
  for (String originalPath in cachedPaths) {
    final String fileName = path.basename(originalPath);
    final String newPath = path.join(directoryPath, fileName);

    try {
      final File originalFile = File(originalPath);
      final File newFile = await originalFile.copy(newPath);

      // Delete the original from cache
      await originalFile.delete();

      savedPaths.add(newFile.path);
    } catch (e) {}
  }
  return savedPaths;
}
