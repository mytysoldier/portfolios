import 'package:flutter/material.dart';
import 'package:convenience_store_food_record_app/providers/user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserInfoView extends ConsumerWidget {
  const UserInfoView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    return Column(
      children: [
        const Icon(Icons.account_circle, size: 80, color: Colors.grey),
        const SizedBox(height: 16),
        Text(user?.userName ?? 'ユーザー名', style: const TextStyle(fontSize: 20)),
        const SizedBox(height: 8),
        Text(
          user?.deviceId ?? 'メールアドレス',
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ],
    );
  }
}
