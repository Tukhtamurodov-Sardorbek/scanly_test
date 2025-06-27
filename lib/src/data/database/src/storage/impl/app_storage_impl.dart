import 'package:shared_preferences/shared_preferences.dart';
import 'package:scanly_test/src/data/database/database.dart';

class AppStorageImpl implements AppStorage {
  final SharedPreferences _preferences;

  const AppStorageImpl(this._preferences);

  static const String _runTimes = 'RUN_TIMES';

  @override
  Future<bool> saveRunTimes() {
    final result = runTimes + 1;
    return _preferences.setInt(_runTimes, result);
  }

  @override
  int get runTimes {
    int result = 0;
    try {
      result = _preferences.getInt(_runTimes) ?? 0;
    } catch (e) {
      print('Type exception occurred');
    }
    return result;
  }

  @override
  Future<bool> clearStorage() {
    return _preferences.clear();
  }
}
