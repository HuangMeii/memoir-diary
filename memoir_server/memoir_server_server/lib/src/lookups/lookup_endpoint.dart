import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

/// Mood and weather lookups. Public: the login screen needs them too.
class LookupsEndpoint extends Endpoint {
  @override
  bool get requireLogin => false;

  Future<List<Mood>> moods(Session session) =>
      Mood.db.find(session, orderBy: (t) => t.sortOrder);

  Future<List<Weather>> weathers(Session session) =>
      Weather.db.find(session, orderBy: (t) => t.sortOrder);
}
