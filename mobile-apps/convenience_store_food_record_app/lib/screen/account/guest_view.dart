import 'package:convenience_store_food_record_app/screen/account/components/guest_description.dart';
import 'package:convenience_store_food_record_app/theme/main_theme.dart';
import 'package:convenience_store_food_record_app/screen/account/components/auth_toggle_buttons.dart';
import 'package:convenience_store_food_record_app/screen/account/components/login_form.dart';
import 'package:convenience_store_food_record_app/screen/account/components/register_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GuestView extends ConsumerStatefulWidget {
  const GuestView({super.key});

  @override
  ConsumerState<GuestView> createState() => _GuestViewState();
}

class _GuestViewState extends ConsumerState<GuestView> {
  int _selectedIndex = 0; // 0: ログイン, 1: 新規登録

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: AppSizes.spacingS,
      children: [
        Card(
          color: const Color(0xFFFFF3E0),
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              children: [
                const Icon(
                  Icons.person_outline,
                  size: 56,
                  color: Colors.orange,
                ),
                const SizedBox(height: 16),
                Text(
                  "ゲストモードで利用中",
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium!.copyWith(color: Colors.deepOrange),
                ),
                const SizedBox(height: 8),
                Text(
                  "アカウント登録すると、デバイス間でデータを同期できます",
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                // ...既存のボタンは削除...
              ],
            ),
          ),
        ),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              children: [
                Text(
                  "アカウント登録・ログイン",
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium!.copyWith(color: Colors.black),
                ),
                const SizedBox(height: 16),
                // トグルボタン
                AuthToggleButtons(
                  selectedIndex: _selectedIndex,
                  onChanged: (index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                ),
                const SizedBox(height: 24),
                // フォーム切り替え
                if (_selectedIndex == 0)
                  const LoginForm()
                else
                  const RegisterForm(),
              ],
            ),
          ),
        ),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              spacing: AppSizes.spacingM,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "ゲストモードでも利用可能",
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium!.copyWith(color: Colors.black),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: CircleAvatar(
                            radius: 5,
                            backgroundColor: Colors.green,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "すべての機能が利用可能",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              Text(
                                "記録・履歴・統計すべて使えます",
                                style: Theme.of(context).textTheme.bodyMedium!
                                    .copyWith(color: Colors.black87),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: CircleAvatar(
                            radius: 5,
                            backgroundColor: Colors.purple,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "いつでもアカウント作成可能",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              Text(
                                "後からでもデータを引き継げます",
                                style: Theme.of(context).textTheme.bodyMedium!
                                    .copyWith(color: Colors.black87),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
