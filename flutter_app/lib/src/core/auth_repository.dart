import 'package:dio/dio.dart';

import 'api_client.dart';

class AuthRepository {
  const AuthRepository(this._client);

  final ApiClient _client;

  Future<dynamic> me() => _client.get('/auth/me');

  Future<Map<String, dynamic>> login(String username, String password) async {
    final response = await _client.post(
      '/auth/login',
      data: {'username': username, 'password': password},
      options: Options(contentType: Headers.formUrlEncodedContentType),
    );
    return (response as Map).cast<String, dynamic>();
  }

  Future<Map<String, dynamic>> register({
    required String email,
    required String username,
    required String password,
  }) async {
    final response = await _client.post('/auth/register', data: {
      'email': email,
      'username': username,
      'password': password,
    });
    return (response as Map).cast<String, dynamic>();
  }
}

