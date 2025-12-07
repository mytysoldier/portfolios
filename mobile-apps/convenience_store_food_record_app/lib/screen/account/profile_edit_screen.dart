import 'package:flutter/material.dart';
import 'package:convenience_store_food_record_app/providers/user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ProfileEditScreen extends ConsumerStatefulWidget {
  const ProfileEditScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends ConsumerState<ProfileEditScreen> {
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();

    // 現在のユーザー名を初期値として設定
    final user = ref.read(userProvider);
    _nameController.text = user?.userName ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _selectImage() {
    // TODO: 写真フォルダまたはライブラリから画像選択の処理を実装
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('画像選択機能は実装予定です')));
  }

  void _saveProfile() {
    ref.read(userProvider.notifier).updateUserName(_nameController.text);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('プロフィールを保存しました')));
    Navigator.pop(context);
  }

  void _changePassword() {
    // TODO: パスワード変更画面に遷移
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('パスワード変更画面は実装予定です')));
  }

  void _deleteAccount(BuildContext ctx) {
    // TODO: アカウント削除の確認ダイアログと削除処理を実装
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('アカウント削除'),
        content: const Text('アカウントを削除しますか？この操作は取り消せません。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('キャンセル'),
          ),
          TextButton(
            onPressed: () async {
              await ref.read(userProvider.notifier).deleteAccount();
              if (!mounted) return;
              Navigator.pop(context);
              Future.microtask(() => Navigator.pop(ctx));
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('アカウントを削除しました')));
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('削除'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('プロフィール編集'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // プロフィール情報カード
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // TODO 機能拡張
                    // ユーザーアイコン
                    // GestureDetector(
                    //   onTap: _selectImage,
                    //   child: Stack(
                    //     children: [
                    //       Container(
                    //         width: 100,
                    //         height: 100,
                    //         decoration: BoxDecoration(
                    //           shape: BoxShape.circle,
                    //           color: Colors.grey[300],
                    //         ),
                    //         child: const Icon(
                    //           Icons.person,
                    //           size: 50,
                    //           color: Colors.white,
                    //         ),
                    //       ),
                    //       Positioned(
                    //         bottom: 0,
                    //         right: 0,
                    //         child: Container(
                    //           width: 32,
                    //           height: 32,
                    //           decoration: BoxDecoration(
                    //             shape: BoxShape.circle,
                    //             color: Theme.of(context).primaryColor,
                    //             border: Border.all(
                    //               color: Colors.white,
                    //               width: 2,
                    //             ),
                    //           ),
                    //           child: const Icon(
                    //             Icons.edit,
                    //             size: 16,
                    //             color: Colors.white,
                    //           ),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    // const SizedBox(height: 24),

                    // ユーザー名入力フィールド
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'ユーザー名',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // 保存ボタン
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _saveProfile,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text('保存', style: TextStyle(fontSize: 16)),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // アカウント設定セクション
            const Text(
              'アカウント設定',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 12),

            // アカウント設定カード
            Card(
              child: Column(
                children: [
                  // TODO 機能拡張
                  // パスワードを変更ボタン
                  // ListTile(
                  //   leading: const Icon(Icons.lock_outline),
                  //   title: const Text('パスワードを変更'),
                  //   trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  //   onTap: _changePassword,
                  // ),

                  // const Divider(height: 1),

                  // アカウントを削除ボタン
                  ListTile(
                    leading: const Icon(
                      Icons.delete_outline,
                      color: Colors.red,
                    ),
                    title: const Text(
                      'アカウントを削除',
                      style: TextStyle(color: Colors.red),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Colors.red,
                    ),
                    onTap: () => _deleteAccount(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
