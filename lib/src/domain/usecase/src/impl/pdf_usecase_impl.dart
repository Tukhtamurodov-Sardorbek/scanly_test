import 'dart:io' show File;
import 'package:file_saver/file_saver.dart' show FileSaver;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:scanly_test/src/domain/model/model.dart';

import 'package:scanly_test/src/domain/usecase/src/pdf_usecase.dart';

import '../../../core/core.dart';

final class PdfUsecaseImpl implements PdfUsecase {
  @override
  Future<String> generatePdf(ScanGroup group) async {
    final pdf = pw.Document();
    final name =
        '${group.title ?? '${LocaleKeys.document.tr()} ${group.id}'}.pdf';

    for (final path in group.imagesPath) {
      final image = pw.MemoryImage(await File(path).readAsBytes());
      pdf.addPage(
        pw.Page(build: (context) => pw.Center(child: pw.Image(image))),
      );
    }

    // final outputDir = await getApplicationDocumentsDirectory();
    // final bytes = await pdf.save();

    final record = await getTemporaryDirectory().zipWith(pdf.save());
    final file = File('${record.$1.path}/$name');

    await Future.wait([
      file.writeAsBytes(await pdf.save()),
      FileSaver.saveFileToDownloadFolder(record.$2, name, 'application/pdf'),
    ]);

    return file.path;
  }
}
