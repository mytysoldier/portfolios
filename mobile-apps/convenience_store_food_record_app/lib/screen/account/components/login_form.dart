import 'package:convenience_store_food_record_app/theme/main_theme.dart';
import 'package:flutter/material.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: AppSizes.spacingM,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          spacing: AppSizes.spacingS,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('メールアドレス', style: Theme.of(context).textTheme.bodyMedium),
            TextField(
              decoration: InputDecoration(
                hintText: 'example@gmail.com',
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
              ),
            ),
          ],
        ),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('ログイン'),
          ),
        ),
        TextButton(
          onPressed: () {
            // TODO: パスワード再設定画面へ遷移
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
