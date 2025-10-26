import 'package:convenience_store_food_record_app/theme/main_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:convenience_store_food_record_app/providers/login_provider.dart';
import 'package:convenience_store_food_record_app/providers/user_provider.dart';
import 'package:convenience_store_food_record_app/models/user.dart';
import 'package:go_router/go_router.dart';

class LoginForm extends ConsumerStatefulWidget {
  const LoginForm({super.key});

  @override
  ConsumerState<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<LoginForm> {
  final _userNameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _userNameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future<void> handleLogin() async {
      setState(() => _isLoading = true);
      try {
        final user = await ref
            .read(loginProvider)
            .login(
              userName: _userNameController.text,
              password: _passwordController.text,
            );
        ref.read(userProvider.notifier).setUser(user);
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('ログインエラー'),
            content: Text("ログインに失敗しました。ユーザー名もしくはパスワードを確認してください"),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }

    return Column(
      spacing: AppSizes.spacingM,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          spacing: AppSizes.spacingS,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ユーザー名', style: Theme.of(context).textTheme.bodyMedium),
            TextField(
              controller: _userNameController,
              decoration: InputDecoration(
                hintText: 'ユーザー名を入力',
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
        Column(
          spacing: AppSizes.spacingS,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('パスワード', style: Theme.of(context).textTheme.bodyMedium),
            TextField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                hintText: 'パスワードを入力',
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isLoading ? null : handleLogin,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text('ログイン'),
          ),
        ),
        TextButton(
          onPressed: () {
            context.push('/reset_password');
          },
          child: Text(
            'パスワードを忘れた方',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.blue,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }
}
