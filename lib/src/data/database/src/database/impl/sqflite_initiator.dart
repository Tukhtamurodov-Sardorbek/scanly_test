import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart'
    show Database, getDatabasesPath, openDatabase, onDatabaseDowngradeDelete;

mixin TableData {
  final String tableName = 'ScanGroup';
}

class SqfliteInitiator with TableData {
  Future<Database> get initialize async {
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, 'scanly.db');

    final database = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE $tableName(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            thumbnailPath TEXT,
            imagesPath TEXT,
            creationTime TEXT NOT NULL
          )
        ''');
      },
      onDowngrade: onDatabaseDowngradeDelete,
      onUpgrade: (Database db, int oldVersion, int newVersion) async {},
    );
    return database;
  }
}
