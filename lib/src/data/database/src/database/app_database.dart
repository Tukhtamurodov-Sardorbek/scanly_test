import 'package:scanly_test/src/domain/model/model.dart';

abstract class AppDatabase {
  Future<int> insertGroup(Map<String, dynamic> data);

  Future<List<ScanGroup>> getAllGroups();

  Future<ScanGroup?> getGroupById(int id);

  Future<int> updateGroup(ScanGroup group);

  Future<int> deleteGroup(int id);

  Future<void> close();
}
