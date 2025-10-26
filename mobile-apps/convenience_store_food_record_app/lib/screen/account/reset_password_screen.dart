import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:convenience_store_food_record_app/providers/login_provider.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  const ResetPasswordScreen({Key? key}) : super(key: key);
  @override
  ConsumerState<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool get isButtonEnabled =>
      userNameController.text.trim().isNotEmpty &&
      passwordController.text.isNotEmpty;

  @override
  void initState() {
    super.initState();
    userNameController.addListener(_onTextChanged);
    passwordController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    userNameController.removeListener(_onTextChanged);
    passwordController.removeListener(_onTextChanged);
    userNameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('パスワード再設定')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ユーザー名', style: Theme.of(context).textTheme.bodyMedium),
            TextField(
              controller: userNameController,
              decoration: InputDecoration(hintText: 'ユーザー名を入力'),
            ),
            SizedBox(height: 16),
            Text('新しいパスワード', style: Theme.of(context).textTheme.bodyMedium),
            TextField(
              controller: passwordController,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                hintText: '新しいパスワードを入力',
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
            SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isButtonEnabled
                    ? () async {
                        final userName = userNameController.text.trim();
                        final newPassword = passwordController.text;
                        try {
                          await ref
                              .read(loginProvider)
                              .resetPassword(
                                userName: userName,
                                newPassword: newPassword,
                              );
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('成功'),
                              content: Text('パスワードを再設定しました'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: Text('OK'),
                                ),
                              ],
                            ),
                          );
                        } catch (e) {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('エラー'),
                              content: Text(e.toString()),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: Text('OK'),
                                ),
                              ],
                            ),
                          );
                        }
                      }
                    : null,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>((
                    states,
                  ) {
                    if (states.contains(MaterialState.disabled)) {
                      return Colors.grey.shade300;
                    }
                    return Colors.black;
                  }),
                  foregroundColor: MaterialStateProperty.resolveWith<Color>((
                    states,
                  ) {
                    if (states.contains(MaterialState.disabled)) {
                      return Colors.grey;
                    }
                    return Colors.white;
                  }),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  padding: MaterialStateProperty.all(
                    const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
                child: Text('パスワードを再設定'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
