import 'dart:math';

import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

/// A lowercase hex string, used to build collision-free object keys.
String randomHex([int length = 32]) {
  final random = Random.secure();
  const chars = '0123456789abcdef';
  final buffer = StringBuffer();
  for (var i = 0; i < length; i++) {
    buffer.write(chars[random.nextInt(16)]);
  }
  return buffer.toString();
}

/// The authenticated user's id. Only call from endpoints with `requireLogin`.
UuidValue currentUserId(Session session) =>
    UuidValue.fromString(session.authenticated!.userIdentifier);

/// Normalizes a [DateTime] to midnight UTC, so a "date" column compares equal
/// for every time of day.
DateTime dateOnly(DateTime value) =>
    DateTime.utc(value.year, value.month, value.day);

/// First and last day of the `YYYY-MM` [month] string.
(DateTime, DateTime) monthBounds(String month) {
  final parts = month.split('-');
  final year = int.parse(parts[0]);
  final mon = int.parse(parts[1]);
  final first = DateTime.utc(year, mon, 1);
  // Day 0 of the next month is the last day of this one.
  final last = DateTime.utc(year, mon + 1, 0);
  return (first, last);
}

/// Throws a 404-style [ApiException] when a row is not owned by the caller.
void ensureOwned(bool owned) {
  if (!owned) {
    throw ApiException(message: 'Not found', code: 'notFound');
  }
}
