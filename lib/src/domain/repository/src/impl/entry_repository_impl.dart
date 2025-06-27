import 'package:scanly_test/src/data/database/database.dart';
import 'package:scanly_test/src/domain/repository/src/entry_repository.dart';

class EntryRepositoryImpl implements EntryRepository {
  final AppStorage _appStorage;

  const EntryRepositoryImpl(this._appStorage);

  @override
  int get runTimes => _appStorage.runTimes;

  @override
  Future<bool> saveRunTimes() => _appStorage.saveRunTimes();

  @override
  Future<bool> clearStorage() => _appStorage.clearStorage();
}
