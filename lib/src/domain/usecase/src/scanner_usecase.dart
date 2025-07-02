import 'dart:io' show Directory;
import 'dart:typed_data' show Uint8List;

import 'package:scanly_test/src/domain/model/model.dart';

abstract class ScannerUsecase {
  Future<List<String>?> get scan;

  Future<Directory> createGroupDirectory(String groupName);

  Future<List<String>> movePicturesFromCacheToPersistentStorage(
    List<String> cachedPaths,
    String directoryPath,
  );

  Future<String?> overwriteImage(
    Uint8List editedImageBytes,
    String originalPath, {
    bool canDelete = true,
  });

  Future<int> saveGroup(Map<String, dynamic> data);

  Future<List<ScanGroup>> getAllGroups();

  Future<int> updateGroup(ScanGroup group);

  Future<int> deleteGroup(ScanGroup group);
}
