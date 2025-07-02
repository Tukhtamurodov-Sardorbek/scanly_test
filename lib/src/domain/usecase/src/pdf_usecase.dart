import 'package:scanly_test/src/domain/model/model.dart';

abstract class PdfUsecase {
  Future<String> generatePdf(ScanGroup group);
}
