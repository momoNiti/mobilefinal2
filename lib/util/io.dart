import 'package:path_provider/path_provider.dart';
import 'dart:io';

class IoProvider {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/quotes.txt');
  }

  Future<File> writeQuotes(String quotes) async {
    final file = await _localFile;
    return file.writeAsString('$quotes');
  }

  Future<int> readQuotes() async {
    try {
      final file = await _localFile;
      String contents = await file.readAsString();
      return int.parse(contents);
    } catch (e) {
      return 0;
    }
  }
}
