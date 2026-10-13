import 'dart:io';

/// Reads a file from disk (mobile/desktop).
Future<List<int>> readFileBytes(String path) => File(path).readAsBytes();
