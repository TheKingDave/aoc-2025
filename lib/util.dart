import 'dart:io';
import 'package:path/path.dart' as path;

final fileRegex = RegExp(r'day_(?<day>\d+).dart');

File getFile() {
  final fileName = path.basename(Platform.script.path);
  final match = fileRegex.firstMatch(fileName);
  if (match == null) {
    throw Exception("Could not match filename to regex");
  }
  final day = int.parse(match.namedGroup("day")!);
  return File('inp/${day.toString().padLeft(2, '0')}.txt',);
}