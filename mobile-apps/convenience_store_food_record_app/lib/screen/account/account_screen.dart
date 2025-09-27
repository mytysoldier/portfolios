import 'package:convenience_store_food_record_app/screen/account/guest_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:convenience_store_food_record_app/screen/account/components/user_info_view.dart';
import 'package:convenience_store_food_record_app/screen/account/components/logout_button.dart';
import 'package:convenience_store_food_record_app/providers/user_provider.dart';

class AccountScreen extends ConsumerStatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends ConsumerState<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    return SingleChildScrollView(
      child: Column(
        children: [
          // TODO && -> || に戻す
          if (user == null || user.userName == null) ...[
            GuestView(),
            // TODO 以下削除
            // const UserInfoView(),
            // const SizedBox(height: 32),
            // LogoutButton(
            //   onPressed: () {
            //     // TODO: ログアウト処理
            //   },
            // ),
          ] else ...[
            const UserInfoView(),
            const SizedBox(height: 32),
            LogoutButton(
              onPressed: () {
                // TODO: ログアウト処理
              },
            ),
          ],
        ],
      ),
    );
  }
}
