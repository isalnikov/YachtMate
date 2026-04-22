import 'dart:io';

Future<void> ensureDirectoryRecursive(String path) =>
    Directory(path).create(recursive: true);

Future<void> deleteFileIfExists(String path) async {
  final f = File(path);
  if (await f.exists()) await f.delete();
}
