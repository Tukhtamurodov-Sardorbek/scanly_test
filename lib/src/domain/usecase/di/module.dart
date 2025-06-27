import 'package:injectable/injectable.dart';
import 'package:scanly_test/src/domain/repository/repository.dart';
import 'package:scanly_test/src/domain/usecase/src/entry_usecase.dart';
import 'package:scanly_test/src/domain/usecase/src/impl/entry_usecase_impl.dart';

@module
abstract class UsecaseModule {
  EntryUsecase injectEntryUsecase(EntryRepository repository) {
    return EntryUsecaseImpl(repository);
  }
}
