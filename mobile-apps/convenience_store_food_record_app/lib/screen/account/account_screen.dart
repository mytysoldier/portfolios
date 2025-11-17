import 'package:convenience_store_food_record_app/providers/history_item_provider.dart';
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
    if (user != null && user.userName != null) {
      Future.microtask(() {
        ref.read(historyItemListProvider.notifier).fetchPurchasedItems(ref);
      });
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          if (user == null || user.userName == null) ...[
            GuestView(),
          ] else ...[
            const UserInfoView(),
            const SizedBox(height: 32),
            LogoutButton(
              onPressed: () {
                ref.read(userProvider.notifier).logout();
                // ログアウトしたら履歴もクリアする（ここで再取得すると、ログアウトしても同一デバイスIDの履歴が表示され続けてしまうため）
                ref.read(historyItemListProvider.notifier).clear();
                setState(() {});
              },
            ),
          ],
        ],
      ),
    );
  }
}
