import 'package:convenience_store_food_record_app/l10n/app_localizations.dart';
import 'package:convenience_store_food_record_app/providers/category_master_provider.dart';
import 'package:convenience_store_food_record_app/providers/image_picker_provider.dart';
import 'package:convenience_store_food_record_app/providers/record_item_provider.dart';
import 'package:convenience_store_food_record_app/providers/store_master_provider.dart';
import 'package:convenience_store_food_record_app/screen/record/record_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

// Providerをモックするための準備
class MockRecordItemNotifier extends RecordItemNotifier {}

class MockImagePickerNotifier extends ImagePickerNotifier {
  @override
  Future<String?> uploadToR2({
    required String filePath,
    required String fileName,
  }) async {
    return '';
  }
}

// Providerの上書き設定
final providerOverrides = [
  recordItemProvider.overrideWith((ref) => MockRecordItemNotifier()),
  storeMasterProvider.overrideWith((ref) {
    final notifier = StoreMasterNotifier();
    notifier.state = {1: 'テストコンビニ', 2: 'コンビニB'};
    return notifier;
  }),
  categoryMasterProvider.overrideWith((ref) {
    final notifier = CategoryMasterNotifier();
    notifier.state = {1: 'テストカテゴリ', 2: 'カテゴリB'};
    return notifier;
  }),
  imagePickerProvider.overrideWith((ref) => MockImagePickerNotifier()),
];

void main() {
  testWidgets('RecordScreen should display correct hint texts and button', (
    WidgetTester tester,
  ) async {
    // ウィジェットを描画
    await tester.pumpWidget(
      ProviderScope(
        overrides: providerOverrides,
        child: MaterialApp(
          localizationsDelegates: L10n.localizationsDelegates,
          supportedLocales: L10n.supportedLocales,
          locale: const Locale('ja'),
          home: Scaffold(body: RecordScreen()),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // arbファイルに基づいた正しいヒントテキストとボタンの文言を検証
    expect(find.text('例: ツナマヨおにぎり'), findsOneWidget);
    expect(find.text('例: 120'), findsOneWidget);
    expect(find.text('味の感想や評価など...'), findsOneWidget);
    expect(find.text('コンビニを選択'), findsOneWidget);
    expect(find.text('カテゴリを選択'), findsOneWidget);
    expect(find.text('写真を撮影またはアップロード'), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, '記録する'), findsOneWidget);
  });
}
