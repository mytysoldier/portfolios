import 'package:flutter/material.dart';

class GuestDescription extends StatelessWidget {
  const GuestDescription({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('ゲストとしてログインしています', style: Theme.of(context).textTheme.bodyMedium),
        TextButton(
          onPressed: () {
            // TODO: ゲストユーザーの詳細画面へ遷移
          },
          child: Text(
            '詳細を見る',
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
