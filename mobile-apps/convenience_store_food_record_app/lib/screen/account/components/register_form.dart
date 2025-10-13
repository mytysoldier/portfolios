import 'package:convenience_store_food_record_app/theme/main_theme.dart';
import 'package:flutter/material.dart';

class RegisterForm extends StatefulWidget {
  final void Function(String userName, String password) onRegisterPressed;
  const RegisterForm({super.key, required this.onRegisterPressed});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmController =
      TextEditingController();

  @override
  void dispose() {
    userNameController.dispose();
    passwordController.dispose();
    passwordConfirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: AppSizes.spacingM,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('ニックネーム', style: Theme.of(context).textTheme.bodyMedium),
        TextField(
          controller: userNameController,
          decoration: InputDecoration(
            hintText: 'タロウ',
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
        Text('パスワード', style: Theme.of(context).textTheme.bodyMedium),
        TextField(
          controller: passwordController,
          decoration: InputDecoration(
            hintText: '8文字以上のパスワード',
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
        Text('パスワード確認用', style: Theme.of(context).textTheme.bodyMedium),
        TextField(
          controller: passwordConfirmController,
          decoration: InputDecoration(
            hintText: 'パスワードを再入力',
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
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              widget.onRegisterPressed(
                userNameController.text,
                passwordController.text,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('アカウント作成'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text.rich(
            TextSpan(
              style: Theme.of(context).textTheme.bodySmall,
              children: [
                const TextSpan(text: 'アカウント作成により、'),
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: GestureDetector(
                    onTap: () {
                      // TODO: 利用規約ページへ遷移
                    },
                    child: Text(
                      '利用規約',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
                const TextSpan(text: 'および'),
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: GestureDetector(
                    onTap: () {
                      // TODO: プライバシーポリシーページへ遷移
                    },
                    child: Text(
                      'プライバシーポリシー',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
                const TextSpan(text: 'に同意したものとさせていただきます。'),
              ],
            ),
            textAlign: TextAlign.left,
          ),
        ),
      ],
    );
  }
}
