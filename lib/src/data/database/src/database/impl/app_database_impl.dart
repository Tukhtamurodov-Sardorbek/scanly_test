import 'package:flutter/foundation.dart' show compute;
import 'package:scanly_test/src/data/database/src/database/app_database.dart';
import 'package:scanly_test/src/data/database/src/database/impl/sqflite_initiator.dart';
import 'package:scanly_test/src/domain/model/model.dart';
import 'package:sqflite/sqflite.dart';

List<ScanGroup> _parseScanGroups(List<Map<String, dynamic>> jsonList) {
  final groups = jsonList.map((e) => ScanGroup.fromJson(e)).toList();
  groups.sort((a, b) => b.creationTime.compareTo(a.creationTime));

  return groups;
}

class AppDatabaseImpl with TableData implements AppDatabase {
  final Database _database;

  AppDatabaseImpl(this._database) : super();

  @override
  Future<List<ScanGroup>> getAllGroups() async {
    final data = await _database.query(tableName);
    final groups = await compute(_parseScanGroups, data);
    return groups;
  }

  @override
  Future<int> insertGroup(Map<String, dynamic> data) async {
    final id = await _database.insert(
      tableName,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return id;
  }

  @override
  Future<ScanGroup?> getGroupById(int id) async {
    final List<Map<String, dynamic>> maps = await _database.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (maps.isNotEmpty) {
      return ScanGroup.fromJson(maps.first);
    }
    return null;
  }

  @override
  Future<int> updateGroup(ScanGroup group) async {
    final count = await _database.update(
      tableName,
      group.toJson,
      where: 'id = ?',
      whereArgs: [group.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return count;
  }

  @override
  Future<int> deleteGroup(int id) async {
    final count = await _database.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    return count;
  }

  @override
  Future<void> close() async {
    _database.close();
  }
}
