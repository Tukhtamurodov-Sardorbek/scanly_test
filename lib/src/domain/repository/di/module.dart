import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:injectable/injectable.dart';
import 'package:scanly_test/src/data/database/database.dart';
import 'package:scanly_test/src/domain/repository/repository.dart';
import 'package:scanly_test/src/domain/repository/src/impl/entry_repository_impl.dart';
import 'package:scanly_test/src/domain/repository/src/impl/db_repository_impl.dart';

@module
abstract class RepositoryModule {
  @singleton
  CunningDocumentScanner injectCunningDocumentScanner() =>
      CunningDocumentScanner();

  EntryRepository injectEntryRepository(AppStorage storage) {
    return EntryRepositoryImpl(storage);
  }

  DBRepository injectDBRepository(AppDatabase database) {
    return DBRepositoryImpl(database);
  }
}
