import 'package:injectable/injectable.dart';
import 'package:scanly_test/src/data/database/src/database/app_database.dart';
import 'package:scanly_test/src/data/database/src/database/impl/app_database_impl.dart';
import 'package:scanly_test/src/data/database/src/database/impl/sqflite_initiator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:scanly_test/src/data/database/src/storage/app_storage.dart';
import 'package:scanly_test/src/data/database/src/storage/impl/app_storage_impl.dart';
import 'package:sqflite/sqflite.dart' show Database;

@module
abstract class DatabaseModule {
  @preResolve
  @Order(-1)
  @singleton
  Future<Database> injectSqflite() => SqfliteInitiator().initialize;

  @preResolve
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();

  @lazySingleton
  AppStorage injectAppStorage(SharedPreferences sharedPreferences) =>
      AppStorageImpl(sharedPreferences);

  @lazySingleton
  AppDatabase injectAppDatabase(Database database) => AppDatabaseImpl(database);
}
