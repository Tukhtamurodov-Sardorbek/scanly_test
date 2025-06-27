import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:scanly_test/src/data/database/src/storage/app_storage.dart';
import 'package:scanly_test/src/data/database/src/storage/impl/app_storage_impl.dart';

@module
abstract class DatabaseModule {
  @preResolve
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();

  @singleton
  AppStorage injectAppStorage(SharedPreferences sharedPreferences) =>
      AppStorageImpl(sharedPreferences);
}
