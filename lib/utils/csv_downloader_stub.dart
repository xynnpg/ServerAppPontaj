import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

Future<void> downloadCsvFile(String content, String fileName) async {
  try {
    // Get temporary directory
    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/$fileName');

    // Write CSV content to file
    await file.writeAsString(content);

    // Share the file
    await Share.shareXFiles([
      XFile(file.path),
    ], subject: 'Professor Statistics');
  } catch (e) {
    print('Error sharing CSV: $e');
  }
}
