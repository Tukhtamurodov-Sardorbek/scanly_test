import 'dart:io' show File, Directory;
import 'package:pdf/widgets.dart' as pw;

import 'package:scanly_test/src/domain/usecase/src/pdf_usecase.dart';

final class PdfUsecaseImpl implements PdfUsecase {
  @override
  Future<File> generatePdf(List<String> imagePaths, String groupId) async {
    final pdf = pw.Document();
    for (final path in imagePaths) {
      final image = pw.MemoryImage(await File(path).readAsBytes());
      pdf.addPage(
        pw.Page(build: (context) => pw.Center(child: pw.Image(image))),
      );
    }

    final outputDir = Directory('/storage/emulated/0/Documents');
    final file = File('${outputDir.path}/$groupId.pdf');
    await file.writeAsBytes(await pdf.save());
    return file;
  }
}
