import 'package:scanly_test/src/data/database/database.dart';
import 'package:scanly_test/src/domain/model/model.dart';
import 'package:scanly_test/src/domain/repository/src/db_repository.dart';

final class DBRepositoryImpl implements DBRepository {
  final AppDatabase _database;

  DBRepositoryImpl(this._database);

  @override
  Future<void> close() => _database.close();

  @override
  Future<int> deleteGroup(int id) => _database.deleteGroup(id);

  @override
  Future<List<ScanGroup>> getAllGroups() => _database.getAllGroups();

  @override
  Future<ScanGroup?> getGroupById(int id) => _database.getGroupById(id);

  @override
  Future<int> insertGroup(Map<String, dynamic> data) =>
      _database.insertGroup(data);

  @override
  Future<int> updateGroup(ScanGroup group) => _database.updateGroup(group);
}
