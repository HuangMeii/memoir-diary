import 'dart:math';

import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../shared/session_utils.dart';

/// Below this many saved self messages the pairing shows two library quotes
/// instead, so the day is never half empty. Mirrors `quote_service.py`.
const int _minSelfMessagesToPair = 10;

/// Daily quote pair, mirroring FastAPI `/daily-quotes`.
class DailyQuotesEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  Future<DailyQuotePair> today(Session session) async {
    final userId = currentUserId(session);
    final row = await _getOrCreate(session, userId, dateOnly(DateTime.now()));
    return _expand(session, row);
  }

  Future<List<DailyQuotePair>> history(
    Session session, {
    required String month,
  }) async {
    final userId = currentUserId(session);
    final (first, last) = monthBounds(month);
    final rows = await DailyQuote.db.find(
      session,
      where: (t) =>
          t.userId.equals(userId) &
          (t.quoteDate >= first) &
          (t.quoteDate <= last),
      orderBy: (t) => t.quoteDate.desc(),
    );
    final result = <DailyQuotePair>[];
    for (final row in rows) {
      result.add(await _expand(session, row));
    }
    return result;
  }

  /// Drops the stored pair for the day and draws a new one.
  Future<DailyQuotePair> reshuffle(Session session, UuidValue id) async {
    final userId = currentUserId(session);
    final row = await DailyQuote.db.findById(session, id);
    ensureOwned(row != null && row.userId == userId);
    await DailyQuote.db.deleteRow(session, row!);
    final recreated = await _getOrCreate(
      session,
      userId,
      dateOnly(row.quoteDate),
    );
    return _expand(session, recreated);
  }

  Future<DailyQuote> _getOrCreate(
    Session session,
    UuidValue userId,
    DateTime day,
  ) async {
    final existing = await _find(session, userId, day);
    if (existing != null) return existing;

    final selfCount = await SelfMessage.db.count(
      session,
      where: (t) => t.userId.equals(userId),
    );

    Quote? quote;
    Quote? quote2;
    SelfMessage? selfMessage;
    if (selfCount >= _minSelfMessagesToPair) {
      quote = await _randomQuote(session, userId);
      selfMessage = await _randomSelfMessage(session, userId);
    } else {
      quote = await _randomQuote(session, userId);
      if (quote != null) {
        quote2 = await _randomQuote(session, userId, exclude: quote.id);
      }
    }

    try {
      await DailyQuote.db.insertRow(
        session,
        DailyQuote(
          userId: userId,
          quoteDate: day,
          quoteId: quote?.id,
          quoteId2: quote2?.id,
          selfMessageId: selfMessage?.id,
        ),
      );
    } catch (_) {
      // Lost the race: the unique (userId, quoteDate) row already exists.
    }

    final stored = await _find(session, userId, day);
    return stored!;
  }

  Future<DailyQuote?> _find(
    Session session,
    UuidValue userId,
    DateTime day,
  ) {
    return DailyQuote.db.findFirstRow(
      session,
      where: (t) => t.userId.equals(userId) & t.quoteDate.equals(day),
    );
  }

  Future<Quote?> _randomQuote(
    Session session,
    UuidValue userId, {
    UuidValue? exclude,
  }) async {
    final all = await Quote.db.find(
      session,
      where: (t) => t.isActive.equals(true),
    );
    final visible = all
        .where(
          (q) =>
              (q.userId == null || q.userId == userId) &&
              (exclude == null || q.id != exclude),
        )
        .toList();
    if (visible.isEmpty) return null;
    return visible[Random().nextInt(visible.length)];
  }

  Future<SelfMessage?> _randomSelfMessage(
    Session session,
    UuidValue userId,
  ) async {
    final all = await SelfMessage.db.find(
      session,
      where: (t) => t.userId.equals(userId),
    );
    if (all.isEmpty) return null;
    return all[Random().nextInt(all.length)];
  }

  Future<DailyQuotePair> _expand(Session session, DailyQuote row) async {
    final quote = row.quoteId == null
        ? null
        : await Quote.db.findById(session, row.quoteId!);
    final quote2 = row.quoteId2 == null
        ? null
        : await Quote.db.findById(session, row.quoteId2!);
    final selfMessage = row.selfMessageId == null
        ? null
        : await SelfMessage.db.findById(session, row.selfMessageId!);
    return DailyQuotePair(
      id: row.id!,
      quoteDate: row.quoteDate,
      quote: quote,
      quote2: quote2,
      selfMessage: selfMessage,
    );
  }
}
