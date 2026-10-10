import 'package:dio/dio.dart';

import 'api_client.dart';
import 'auth_gateway.dart';

class AuthRepository implements AuthGateway {
  const AuthRepository(this._client);

  final ApiClient _client;

  @override
  Future<dynamic> me() => _client.get('/auth/me');

  @override
  Future<Map<String, dynamic>> login(String username, String password) async {
    final response = await _client.post(
      '/auth/login',
      data: {'username': username, 'password': password},
      options: Options(contentType: Headers.formUrlEncodedContentType),
    );
    return (response as Map).cast<String, dynamic>();
  }

  @override
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

