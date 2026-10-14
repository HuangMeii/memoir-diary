import 'dart:convert';
import 'dart:io';
import 'package:bcrypt/bcrypt.dart';

const int _bcryptMaxBytes = 72;

String _truncate(String password) {
  final bytes = utf8.encode(password);
  if (bytes.length <= _bcryptMaxBytes) return password;
  return utf8.decode(bytes.sublist(0, _bcryptMaxBytes), allowMalformed: true);
}

void main(List<String> args) {
  final password = args.isEmpty ? 'admin' : args.first;
  final hash = BCrypt.hashpw(_truncate(password), BCrypt.gensalt());
  stdout.writeln(hash);
}
