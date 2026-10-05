import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'api_client.dart';
import 'config.dart';

/// Holds the current session state and drives navigation guards.
class AuthState {
  const AuthState({this.token, this.user, this.isLoading = false});

  final String? token;
  final Map<String, dynamic>? user;
  final bool isLoading;

  bool get isAuthenticated => token != null;

  AuthState copyWith({
    String? token,
    Map<String, dynamic>? user,
    bool? isLoading,
    bool clearAuth = false,
  }) {
    if (clearAuth) return const AuthState();
    return AuthState(
      token: token ?? this.token,
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

final authProvider =
    StateNotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier(this._ref) : super(const AuthState(isLoading: true)) {
    // The client reports a session it cannot recover; drop straight to the
    // login screen instead of leaving dead buttons that fail one by one.
    _ref.read(sessionStoreProvider).onSessionLost = _handleSessionLost;
    _restore();
  }

  final Ref _ref;

  SessionStore get _session => _ref.read(sessionStoreProvider);

  void _handleSessionLost() {
    if (state.isAuthenticated) logout();
  }

  /// On startup: read the stored tokens and validate via `/auth/me`.
  ///
  /// An expired access token is normal, not a reason to throw the user out:
  /// the refresh token is exchanged first (the client interceptor does it), so
  /// an account that has not logged in for weeks still lands on the home
  /// screen. Only when that also fails is the session discarded.
  Future<void> _restore() async {
    final access = await _session.readAccess();
    final refresh = await _session.readRefresh();
    if (access == null && refresh == null) {
      state = const AuthState();
      return;
    }

    // Publish before /auth/me: that route is protected, so the request
    // itself needs the Authorization header.
    _session.accessToken = access;
    _session.refreshToken = refresh;
    try {
      final user = await _ref.read(apiClientProvider).get('/auth/me');
      state = AuthState(token: access, user: user);
    } catch (_) {
      // The interceptor already tried to refresh; nothing left to recover.
      await _clearSession();
    }
  }

  Future<void> _clearSession() async {
    await _session.clear();
    state = const AuthState();
  }

  Future<void> login(String username, String password) async {
    state = state.copyWith(isLoading: true);
    try {
      final response = await _ref.read(apiClientProvider).post(
        '/auth/login',
        data: {'username': username, 'password': password},
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );
      final token = response['access_token'] as String;
      final refresh = response['refresh_token'] as String?;
      await _session.write(token, refresh);
      // Publish before /auth/me, which runs before state is updated below.
      final user = await _ref.read(apiClientProvider).get('/auth/me');
      state = AuthState(token: token, user: user);
    } catch (_) {
      await _clearSession();
      rethrow;
    }
  }

  Future<void> register({
    required String email,
    required String username,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true);
    try {
      final response = await _ref.read(apiClientProvider).post(
        '/auth/register',
        data: {'email': email, 'username': username, 'password': password},
      );
      final token = response['access_token'] as String;
      final refresh = response['refresh_token'] as String?;
      // Register builds the state inline, but the session must know the
      // token too so later requests carry it.
      await _session.write(token, refresh);
      state = AuthState(
        token: token,
        user: {
          'id': response['id'],
          'email': response['email'],
          'username': response['username'],
          'display_name': response['display_name'],
        },
      );
    } catch (_) {
      await _clearSession();
      rethrow;
    }
  }

  Future<void> logout() => _clearSession();
}

/// Debug helper so screens can show which backend they target.
final apiBaseUrlProvider = Provider<String>((ref) => AppConfig.apiBaseUrl);