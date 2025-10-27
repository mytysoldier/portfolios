import 'package:convenience_store_food_record_app/providers/upload_daily_usage_provider.dart';
import 'package:convenience_store_food_record_app/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/record_item_model.dart';
import '../models/upload_daily_usage.dart';
import '../components/screen/custom_snack_bar.dart';
import 'package:convenience_store_food_record_app/l10n/app_localizations.dart';
import 'package:convenience_store_food_record_app/providers/image_picker_provider.dart';
import 'package:convenience_store_food_record_app/providers/history_item_provider.dart';

class RecordFormState {
  final String itemName;
  final String? storeId;
  final String? categoryId;
  final String price;
  final String memo;
  final String? imagePath;

  RecordFormState({
    this.itemName = '',
    this.storeId,
    this.categoryId,
    this.price = '',
    this.memo = '',
    this.imagePath,
  });

  RecordFormState copyWith({
    String? itemName,
    String? storeId,
    String? categoryId,
    String? price,
    String? memo,
    String? imagePath,
  }) {
    return RecordFormState(
      itemName: itemName ?? this.itemName,
      storeId: storeId ?? this.storeId,
      categoryId: categoryId ?? this.categoryId,
      price: price ?? this.price,
      memo: memo ?? this.memo,
      imagePath: imagePath ?? this.imagePath,
    );
  }
}

class RecordFormNotifier extends StateNotifier<RecordFormState> {
  RecordFormNotifier() : super(RecordFormState());

  void setItemName(String value) => state = state.copyWith(itemName: value);
  void setStoreId(String? value) => state = state.copyWith(storeId: value);
  void setCategoryId(String? value) =>
      state = state.copyWith(categoryId: value);
  void setPrice(String value) => state = state.copyWith(price: value);
  void setMemo(String value) => state = state.copyWith(memo: value);
  void setImagePath(String? value) => state = state.copyWith(imagePath: value);

  void clear() => state = RecordFormState();

  String? validate(BuildContext context) {
    final l10n = L10n.of(context);

    if (state.itemName.isEmpty) {
      return l10n.required_validation_error_message(l10n.item_name);
    }
    if (state.storeId == null) {
      return l10n.required_validation_error_message(
        l10n.item_convenience_store_name,
      );
    }
    if (state.categoryId == null) {
      return l10n.required_validation_error_message(l10n.category_name);
    }
    if (state.price.isEmpty) {
      return l10n.required_validation_error_message(l10n.price_name);
    }
    if (int.tryParse(state.price) == null) {
      return l10n.invalid_validation_error_message(l10n.price_name);
    }
    return null;
  }

  Future<bool> submit({
    required BuildContext context,
    required WidgetRef ref,
  }) async {
    final error = validate(context);
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        CustomSnackBar.show(message: error, backgroundColor: Colors.red),
      );
      return false;
    }

    final user = ref.read(userProvider);
    if (user == null) return false; // ユーザー未取得時は何もしない
    final defaultDailyLimit = _resolveDailyLimit();
    final usageNotifier = ref.read(uploadDailyUsageProvider.notifier);
    UploadDailyUsage? currentUsage;
    int effectiveLimit = defaultDailyLimit;
    try {
      currentUsage = await usageNotifier.fetch(userId: user.id);
      effectiveLimit = currentUsage?.dailyLimit ?? defaultDailyLimit;

      if ((currentUsage?.currentCount ?? 0) >= effectiveLimit) {
        ScaffoldMessenger.of(context).showSnackBar(
          CustomSnackBar.show(
            message: '1日のアップロード上限に達しました',
            backgroundColor: Colors.red,
          ),
        );
        return false;
      }
    } catch (error, stackTrace) {
      debugPrint('利用状況の取得に失敗: $error');
      debugPrint('$stackTrace');
      ScaffoldMessenger.of(context).showSnackBar(
        CustomSnackBar.show(
          message: 'アップロード状況の確認に失敗しました',
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }

    String imageUrl = '';
    if (state.imagePath != null) {
      final fileName = state.imagePath!.split('/').last;
      await ref
          .read(imagePickerProvider.notifier)
          .uploadToR2(filePath: state.imagePath!, fileName: fileName);
      final idx = state.imagePath!.indexOf('image_picker');
      imageUrl = idx >= 0 ? state.imagePath!.substring(idx) : fileName;
    }
    final supabase = Supabase.instance.client;
    final record = RecordItemModel(
      imageUrl: imageUrl,
      productName: state.itemName,
      storeId: int.tryParse(state.storeId ?? '') ?? 0,
      categoryId: int.tryParse(state.categoryId ?? '') ?? 0,
      memo: state.memo,
      price: int.tryParse(state.price) ?? 0,
      purchaseDate: DateTime.now(),
    );
    try {
      await supabase.from('purchase_history').insert({
        'user_id': user.id,
        'item_img': record.imageUrl,
        'item_name': record.productName,
        'store_id': record.storeId,
        'category_id': record.categoryId,
        'memo': record.memo,
        'price': record.price,
        'purchase_date': record.purchaseDate.toIso8601String(),
      });
      try {
        await usageNotifier.incrementCount(
          userId: user.id,
          dailyLimit: effectiveLimit,
        );
      } on StateError catch (error, stackTrace) {
        debugPrint('利用状況の更新に失敗(上限超過): $error');
        debugPrint('$stackTrace');
        ScaffoldMessenger.of(context).showSnackBar(
          CustomSnackBar.show(
            message: '1日のアップロード上限に達しました',
            backgroundColor: Colors.red,
          ),
        );
        return false;
      } catch (error, stackTrace) {
        debugPrint('利用状況の更新に失敗: $error');
        debugPrint('$stackTrace');
        ScaffoldMessenger.of(context).showSnackBar(
          CustomSnackBar.show(
            message: 'アップロード状況の更新に失敗しました',
            backgroundColor: Colors.red,
          ),
        );
        return false;
      }
      await ref.read(historyItemListProvider.notifier).fetchPurchasedItems(ref);
      clear();
      return true;
    } catch (e, stack) {
      print('登録エラー: $e');
      print(stack);
      ScaffoldMessenger.of(context).showSnackBar(
        CustomSnackBar.show(message: '登録できませんでした', backgroundColor: Colors.red),
      );
      return false;
    }
  }

  int _resolveDailyLimit() {
    const fallbackLimit = 10;
    final envValue = dotenv.env['DAILY_UPLOAD_LIMIT'];
    final parsed = envValue != null ? int.tryParse(envValue) : null;
    if (parsed == null || parsed <= 0) {
      if (envValue != null && envValue.isNotEmpty) {
        debugPrint('Invalid DAILY_UPLOAD_LIMIT value: $envValue');
      }
      return fallbackLimit;
    }
    return parsed;
  }

  Future<bool> deleteRecord({
    required int id,
    required BuildContext context,
    required WidgetRef ref,
  }) async {
    final l10n = L10n.of(context);

    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          // title: const Text('削除確認'),
          content: Padding(
            padding: EdgeInsets.only(top: 16),
            child: Text(l10n.alert_text_delete, textAlign: TextAlign.center),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(l10n.dialog_select_no),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(l10n.dialog_select_ok),
            ),
          ],
        );
      },
    );
    if (result != true) return false;
    final supabase = Supabase.instance.client;
    try {
      await supabase.from('purchase_history').delete().eq('id', id);
      await ref.read(historyItemListProvider.notifier).fetchPurchasedItems(ref);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(CustomSnackBar.show(message: '削除しました'));
      return true;
    } catch (e, stack) {
      print('削除エラー: $e');
      print(stack);
      ScaffoldMessenger.of(context).showSnackBar(
        CustomSnackBar.show(message: '削除できませんでした', backgroundColor: Colors.red),
      );
      return false;
    }
  }
}

final recordFormProvider =
    StateNotifierProvider<RecordFormNotifier, RecordFormState>(
      (ref) => RecordFormNotifier(),
    );
