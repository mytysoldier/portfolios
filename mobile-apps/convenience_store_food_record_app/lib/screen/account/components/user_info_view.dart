import 'package:flutter/material.dart';
import 'package:convenience_store_food_record_app/providers/user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:convenience_store_food_record_app/screen/account/components/user_records_card.dart';

class UserInfoView extends ConsumerStatefulWidget {
  const UserInfoView({Key? key}) : super(key: key);

  @override
  ConsumerState<UserInfoView> createState() => _UserInfoViewState();
}

class _UserInfoViewState extends ConsumerState<UserInfoView> {
  bool _isEditing = false;
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _startEditing(String currentName) {
    _nameController.text = currentName;
    setState(() {
      _isEditing = true;
    });
  }

  void _saveUsername() {
    // TODO: ユーザー名を保存する処理を実装
    // ref.read(userProvider.notifier).updateUserName(_nameController.text);
    setState(() {
      _isEditing = false;
    });
  }

  void _cancelEditing() {
    setState(() {
      _isEditing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final userName = user?.userName ?? 'ユーザー名';
    
    return Column(
      children: [
        // プロフィールカード
        Card(
          margin: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // ユーザーアイコン
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[300],
                  ),
                  child: const Icon(
                    Icons.person,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 16),
                // ユーザー名（編集可能）
                Expanded(
                  child: _isEditing
                      ? Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _nameController,
                                autofocus: true,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                ),
                                onSubmitted: (_) => _saveUsername(),
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              onPressed: _saveUsername,
                              icon: const Icon(Icons.check, color: Colors.green),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(
                                minWidth: 24,
                                minHeight: 24,
                              ),
                            ),
                            IconButton(
                              onPressed: _cancelEditing,
                              icon: const Icon(Icons.close, color: Colors.red),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(
                                minWidth: 24,
                                minHeight: 24,
                              ),
                            ),
                          ],
                        )
                      : GestureDetector(
                          onTap: () => _startEditing(userName),
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              userName,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        const UserRecordsCard(),
      ],
    );
  }
}
