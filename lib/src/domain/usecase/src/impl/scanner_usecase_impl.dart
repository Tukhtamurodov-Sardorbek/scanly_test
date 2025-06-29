import 'dart:async';
import 'dart:io';

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
    List<String> savedPaths = [];
    for (String originalPath in cachedPaths) {
      final String fileName = path.basename(originalPath);
      final String newPath = path.join(directoryPath, fileName);

      final File originalFile = File(originalPath);
      final File newFile = await originalFile.copy(newPath);

      // Delete the original from cache
      await originalFile.delete();

      savedPaths.add(newFile.path);
    }
    return savedPaths;
  }

  @override
  Future<int> saveGroup(Map<String, dynamic> data) =>
      _repository.insertGroup(data);

  @override
  Future<List<ScanGroup>> getAllGroups() => _repository.getAllGroups();

  @override
  Future<int> updateGroup(ScanGroup group) => _repository.updateGroup(group);
}
