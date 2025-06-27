import 'package:injectable/injectable.dart';
import 'package:scanly_test/src/data/database/database.dart';
import 'package:scanly_test/src/domain/repository/repository.dart';
import 'package:scanly_test/src/domain/repository/src/impl/entry_repository_impl.dart';

@module
abstract class RepositoryModule {
  EntryRepository injectEntryRepository(AppStorage storage) {
    return EntryRepositoryImpl(storage);
  }
}
