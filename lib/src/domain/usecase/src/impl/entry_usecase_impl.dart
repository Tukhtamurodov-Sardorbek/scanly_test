import 'package:scanly_test/src/domain/repository/repository.dart';
import 'package:scanly_test/src/domain/usecase/src/entry_usecase.dart';

class EntryUsecaseImpl implements EntryUsecase {
  final EntryRepository _repository;

  const EntryUsecaseImpl(this._repository);

  @override
  int get runTimes => _repository.runTimes;

  @override
  Future<bool> saveRunTimes() => _repository.saveRunTimes();

  @override
  Future<bool> clearStorage() => _repository.clearStorage();
}
