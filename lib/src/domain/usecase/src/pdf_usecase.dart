import 'dart:io' show File;

abstract class PdfUsecase {
  Future<File> generatePdf(List<String> imagePaths, String groupId);
}
