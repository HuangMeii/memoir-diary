import 'dart:convert';
import 'dart:io';

import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

/// Static lookup rows, matching the five-level mood scale of the Figma design
/// (`heatmap.mood.*` tokens). The retired `bored` / `angry` rows are remapped by
/// the mood migration, not seeded again.
const List<List<String>> _moodRows = [
  ['very-sad', 'Rất buồn', '#F4F4EE', '😢', '1'],
  ['sad', 'Buồn', '#ECEEE7', '🙁', '2'],
  ['neutral', 'Bình thường', '#E9EDE3', '😐', '3'],
  ['happy', 'Vui', '#D5E1CD', '🙂', '4'],
  ['very-happy', 'Rất vui', '#A8BE9C', '😄', '5'],
];

const List<List<String>> _weatherRows = [
  ['sunny', 'Nắng', '#FFB300', '☀️', '1'],
  ['cloudy', 'Râm', '#90A4AE', '⛅', '2'],
  ['rainy', 'Mưa', '#5C9EDB', '🌧️', '3'],
  ['storm', 'Bão', '#37474F', '⛈️', '4'],
  ['other', 'Khác', '#78909C', '❔', '5'],
];

/// Idempotent reference-data seeding, replacing `python -m app.seed.seed`.
///
/// It only inserts missing rows, so it is safe to call repeatedly. A production
/// deployment should lock this down (admin scope) or run it once and remove it.
class SeedEndpoint extends Endpoint {
  @override
  bool get requireLogin => false;

  Future<String> run(Session session) async {
    var moods = 0;
    for (final row in _moodRows) {
      final code = row[0];
      final exists = await Mood.db.findFirstRow(
        session,
        where: (t) => t.code.equals(code),
      );
      if (exists != null) continue;
      await Mood.db.insertRow(
        session,
        Mood(
          code: code,
          labelVi: row[1],
          colorHex: row[2],
          icon: row[3],
          sortOrder: int.parse(row[4]),
        ),
      );
      moods++;
    }

    var weathers = 0;
    for (final row in _weatherRows) {
      final code = row[0];
      final exists = await Weather.db.findFirstRow(
        session,
        where: (t) => t.code.equals(code),
      );
      if (exists != null) continue;
      await Weather.db.insertRow(
        session,
        Weather(
          code: code,
          labelVi: row[1],
          colorHex: row[2],
          icon: row[3],
          sortOrder: int.parse(row[4]),
        ),
      );
      weathers++;
    }

    final quotes = await _seedQuotes(session);
    return 'moods=$moods weathers=$weathers quotes=$quotes';
  }

  Future<int> _seedQuotes(Session session) async {
    final file = File('assets/quotes_100.json');
    if (!file.existsSync()) return 0;
    final raw = await file.readAsString();
    var inserted = 0;
    for (final line in const LineSplitter().convert(raw)) {
      final stripped = line.trim().replaceAll(RegExp(r',$'), '');
      if (stripped.isEmpty ||
          stripped.startsWith('#') ||
          stripped == '[' ||
          stripped == ']') {
        continue;
      }
      final item = jsonDecode(stripped) as Map<String, dynamic>;
      final text = item['text'] as String;
      final existing = await Quote.db.findFirstRow(
        session,
        where: (t) => t.text.equals(text),
      );
      if (existing != null) continue;
      await Quote.db.insertRow(
        session,
        Quote(
          text: text,
          author: item['author'] as String?,
          category: item['category'] as String?,
        ),
      );
      inserted++;
    }
    return inserted;
  }
}
