import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memoir_server_client/memoir_server_client.dart' as sp;
import 'package:serverpod_client/serverpod_client.dart'
    show ClientAuthKeyProvider, wrapAsBearerAuthHeaderValue;

import 'session.dart';
import 'config.dart';

/// Feeds the stored access token to the Serverpod client as a bearer header.
///
/// The token is read live from [SessionStore] on every request, so a login or
/// logout takes effect immediately without rebuilding the client.
class _SessionAuthKeyProvider implements ClientAuthKeyProvider {
  _SessionAuthKeyProvider(this._session);

  final SessionStore _session;

  @override
  Future<String?> get authHeaderValue async {
    final token = _session.accessToken;
    if (token == null || token.isEmpty) return null;
    return wrapAsBearerAuthHeaderValue(token);
  }
}

/// The Serverpod client, pointed at the configured server.
final serverpodClientProvider = Provider<sp.Client>((ref) {
  final session = ref.watch(sessionStoreProvider);
  final client = sp.Client(AppConfig.serverpodUrl);
  client.authKeyProvider = _SessionAuthKeyProvider(session);
  return client;
});
