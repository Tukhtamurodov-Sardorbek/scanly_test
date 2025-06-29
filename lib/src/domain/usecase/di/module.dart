import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:injectable/injectable.dart';
import 'package:scanly_test/src/domain/usecase/src/impl/pdf_usecase_impl.dart';
import 'package:scanly_test/src/domain/usecase/src/impl/scanner_usecase_impl.dart';
import 'package:scanly_test/src/domain/usecase/src/impl/thumbnail_usecase_impl.dart';
import 'package:scanly_test/src/domain/usecase/usecase.dart';
import 'package:scanly_test/src/domain/repository/repository.dart';
import 'package:scanly_test/src/domain/usecase/src/impl/entry_usecase_impl.dart';

@module
abstract class UsecaseModule {
  EntryUsecase injectEntryUsecase(EntryRepository repository) {
    return EntryUsecaseImpl(repository);
  }

  PdfUsecase injectPdfUsecase() {
    return PdfUsecaseImpl();
  }

  ScannerUsecase injectScannerUsecase(
    CunningDocumentScanner scanner,
    DBRepository database,
  ) {
    return ScannerUsecaseImpl(scanner, database);
  }

  ThumbnailUsecase injectThumbnailUsecase() {
    return ThumbnailUsecaseImpl();
  }
}
