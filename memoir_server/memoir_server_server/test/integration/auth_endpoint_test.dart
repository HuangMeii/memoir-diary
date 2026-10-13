import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given Auth endpoint', (sessionBuilder, endpoints) {
    test(
      'when registering a new account then a token and the user are returned',
      () async {
        final result = await endpoints.auth.register(
          sessionBuilder,
          email: 'alice@example.com',
          username: 'alice',
          password: 'secret123',
        );

        expect(result.accessToken, isNotEmpty);
        expect(result.user.username, 'alice');
        expect(result.user.email, 'alice@example.com');
      },
    );

    test(
      'when registering a duplicate email then it is rejected',
      () async {
        await endpoints.auth.register(
          sessionBuilder,
          email: 'bob@example.com',
          username: 'bob',
          password: 'secret123',
        );

        await expectLater(
          endpoints.auth.register(
            sessionBuilder,
            email: 'bob@example.com',
            username: 'bob2',
            password: 'secret123',
          ),
          throwsA(isA<Object>()),
        );
      },
    );

    test(
      'when logging in with the wrong password then it fails',
      () async {
        await endpoints.auth.register(
          sessionBuilder,
          email: 'carol@example.com',
          username: 'carol',
          password: 'secret123',
        );

        await expectLater(
          endpoints.auth.login(
            sessionBuilder,
            username: 'carol',
            password: 'wrong-password',
          ),
          throwsA(isA<Object>()),
        );
      },
    );
  });
}
