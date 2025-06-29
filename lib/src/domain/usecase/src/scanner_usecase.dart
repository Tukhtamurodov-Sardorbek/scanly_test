import 'dart:io' show Directory;

import 'package:scanly_test/src/domain/model/model.dart';

abstract class ScannerUsecase {
  Future<List<String>?> get scan;

  Future<Directory> createGroupDirectory(String groupName);

  Future<List<String>> movePicturesFromCacheToPersistentStorage(
    List<String> cachedPaths,
    String directoryPath,
  );

  Future<int> saveGroup(Map<String, dynamic> data);

  Future<List<ScanGroup>> getAllGroups();

  Future<int> updateGroup(ScanGroup group);
}
