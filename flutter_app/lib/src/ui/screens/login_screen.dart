import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/auth_provider.dart';
import '../auth/auth_widgets.dart';
import '../theme.dart';
import '../tokens.dart';

/// Login / register screen (Figma `AUTH-01` / `AUTH-02`).
///
/// The five frames of the design map onto states this screen already had:
/// default, loading, invalid-credentials, network-error and session-expired.
/// Wording, type and colour come from the design tokens.
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _username = TextEditingController();
  final _password = TextEditingController();

  bool _isRegister = false;
  bool _obscure = true;
  String? _error;

  @override
  void dispose() {
    _email.dispose();
    _username.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _error = null);
    try {
      final auth = ref.read(authProvider.notifier);
      if (_isRegister) {
        await auth.register(
          email: _email.text.trim(),
          username: _username.text.trim(),
          password: _password.text,
        );
      } else {
        await auth.login(_username.text.trim(), _password.text);
      }
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    }
  }

  String? _validateEmail(String? v) {
    final value = v?.trim() ?? '';
    if (!_isRegister) return null;
    if (value.isEmpty) return 'Nhập email';
    return value.contains('@') ? null : 'Email không hợp lệ';
  }

  String? _validateUsername(String? v) {
    final value = v?.trim() ?? '';
    if (value.isEmpty) return 'Nhập tên đăng nhập';
    if (_isRegister && value.length < 3) return 'Tối thiểu 3 ký tự';
    return null;
  }

  String? _validatePassword(String? v) {
    if (v == null || v.isEmpty) return 'Nhập mật khẩu';
    if (_isRegister && v.length < 6) return 'Mật khẩu tối thiểu 6 ký tự';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLoading = ref.watch(authProvider).isLoading;
    final serif = TextStyle(fontFamily: serifFamily, color: theme.colorScheme.onSurface);

    return AuthScaffold(
      card: Card(
        child: Padding(
          padding: const EdgeInsets.all(MemoirSpace.s6),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _isRegister ? 'Tạo tài khoản' : 'Chào bạn trở lại',
                  style: serif.copyWith(
                    fontSize: MemoirType.heading1,
                    height: MemoirType.heading1LineHeight / MemoirType.heading1,
                  ),
                ),
                const SizedBox(height: MemoirSpace.s2),
                Text(
                  _isRegister
                      ? 'Bắt đầu cuốn nhật ký của bạn.'
                      : 'Đăng nhập để tiếp tục câu chuyện của bạn.',
                  style: TextStyle(
                    fontSize: MemoirType.bodyMeta,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: MemoirSpace.s6),
                if (_isRegister) ...[
                  TextFormField(
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      hintText: 'ban@example.com',
                    ),
                    validator: _validateEmail,
                  ),
                  const SizedBox(height: MemoirSpace.s3),
                ],
                TextFormField(
                  controller: _username,
                  decoration: const InputDecoration(
                    labelText: 'Tên đăng nhập',
                    hintText: 'Tên đăng nhập của bạn',
                  ),
                  validator: _validateUsername,
                ),
                const SizedBox(height: MemoirSpace.s3),
                TextFormField(
                  controller: _password,
                  obscureText: _obscure,
                  decoration: InputDecoration(
                    labelText: 'Mật khẩu',
                    hintText: 'Nhập mật khẩu',
                    suffixIcon: IconButton(
                      icon: Icon(_obscure
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined),
                      onPressed: () => setState(() => _obscure = !_obscure),
                    ),
                  ),
                  validator: _validatePassword,
                ),
                if (_error != null) ...[
                  const SizedBox(height: MemoirSpace.s4),
                  AuthErrorBanner(message: _error!),
                ],
                const SizedBox(height: MemoirSpace.s6),
                // `filledButtonTheme` only pins the height, so a button that
                // must fill its column asks for it explicitly.
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: isLoading ? null : _submit,
                    child: isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(_isRegister ? 'Đăng ký' : 'Đăng nhập'),
                  ),
                ),
                const SizedBox(height: MemoirSpace.s2),
                TextButton(
                  onPressed: isLoading
                      ? null
                      : () => setState(() {
                            _isRegister = !_isRegister;
                            _error = null;
                          }),
                  child: Text(_isRegister
                      ? 'Đã có tài khoản? Đăng nhập'
                      : 'Chưa có tài khoản? Đăng ký'),
                ),
                const SizedBox(height: MemoirSpace.s2),
                Text(
                  'Một không gian riêng, dành cho bạn.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: MemoirType.caption,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

