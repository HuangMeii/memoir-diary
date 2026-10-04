import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'src/core/auth_provider.dart';
import 'src/ui/screens/home_screen.dart';
import 'src/ui/screens/login_screen.dart';
import 'src/ui/theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MemoirApp()));
}

class MemoirApp extends ConsumerStatefulWidget {
  const MemoirApp({super.key});

  @override
  ConsumerState<MemoirApp> createState() => _MemoirAppState();
}

class _MemoirAppState extends ConsumerState<MemoirApp> {
  // Created once and kept across rebuilds so the router does not reset state.
  late final GoRouter _router = _buildRouter();

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Memoir',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(Brightness.light),
      darkTheme: buildTheme(Brightness.dark),
      routerConfig: _router,
    );
  }

  /// Auth guard: no valid token -> always land on /login.
  GoRouter _buildRouter() {
    return GoRouter(
      initialLocation: '/',
      refreshListenable: _AuthListenable(ref),
      redirect: (context, state) {
        final auth = ref.read(authProvider);
        // While restoring a stored token, stay put instead of redirecting.
        if (auth.isLoading) return null;
        final atLogin = state.matchedLocation == '/login';
        if (!auth.isAuthenticated && !atLogin) return '/login';
        if (auth.isAuthenticated && atLogin) return '/';
        return null;
      },
      routes: [
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/',
          builder: (context, state) => const HomeScreen(),
        ),
      ],
    );
  }
}

/// Tells go_router to re-evaluate the guard when the session changes.
class _AuthListenable extends ChangeNotifier {
  _AuthListenable(WidgetRef ref) {
    ref.listen<AuthState>(authProvider, (previous, next) {
      final wasAuthed = previous?.isAuthenticated ?? false;
      if (wasAuthed != next.isAuthenticated) notifyListeners();
    });
  }
}
