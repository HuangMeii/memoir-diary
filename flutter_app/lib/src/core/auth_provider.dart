import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'api_client.dart';
import 'config.dart';

/// Persists the JWT in platform-secure storage (never in plain text).
class TokenStorage {
  TokenStorage(this._storage);

  final FlutterSecureStorage _storage;
  static const _key = 'memoir_access_token';

  Future<String?> read() => _storage.read(key: _key);

  Future<void> write(String token) => _storage.write(key: _key, value: token);

  Future<void> clear() => _storage.delete(key: _key);
}

final tokenStorageProvider = Provider<TokenStorage>(
  (ref) => TokenStorage(const FlutterSecureStorage()),
);

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
    _restore();
  }

  final Ref _ref;

  TokenStorage get _tokenStorage => _ref.read(tokenStorageProvider);

TokenHolder get _tokenHolder => _ref.read(tokenHolderProvider);

  /// On startup: read a stored token and validate it via `/auth/me`.
  Future<void> _restore() async {
    final token = await _tokenStorage.read();
    if (token == null) {
      state = const AuthState();
      return;
    }
    try {
      // Publish the token before validating: /auth/me is a protected route,
      // so the request itself needs the Authorization header.
      _tokenHolder.set(token);
      final user = await _ref.read(apiClientProvider).get('/auth/me');
      state = AuthState(token: token, user: user);
    } catch (_) {
      // Token expired or invalid -> clear it and show the login screen.
      _tokenHolder.set(null);
      await _tokenStorage.clear();
      state = const AuthState();
    }
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
      await _tokenStorage.write(token);
      // Publish before /auth/me, which runs before state is updated below.
      _tokenHolder.set(token);
      final user = await _ref.read(apiClientProvider).get('/auth/me');
      state = AuthState(token: token, user: user);
    } catch (_) {
      _tokenHolder.set(null);
      state = const AuthState();
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
      await _tokenStorage.write(token);
      // Register builds the state inline, but the holder must know the token too
      // so later authenticated requests carry it.
      _tokenHolder.set(token);
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
      _tokenHolder.set(null);
      state = const AuthState();
      rethrow;
    }
  }

  Future<void> logout() async {
    _tokenHolder.set(null);
    await _tokenStorage.clear();
    state = const AuthState();
  }
}

/// Debug helper so screens can show which backend they target.
final apiBaseUrlProvider = Provider<String>((ref) => AppConfig.apiBaseUrl);