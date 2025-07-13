// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class L10nEn extends L10n {
  L10nEn([String locale = 'en']) : super(locale);

  @override
  String get screen_title => 'コンビニ飯記録';

  @override
  String get history_screen_title => '購入履歴';

  @override
  String get record_screen_title => '新しい記録';

  @override
  String get statistic_screen_title => '統計情報';

  @override
  String get history_search_input_hint_text => '商品名やメモで検索...';

  @override
  String get item_name_record_input_hint_text => '例: ツナマヨおにぎり';

  @override
  String get convenience_store_record_input_hint_text => 'コンビニを選択';

  @override
  String get category_record_input_hint_text => 'カテゴリを選択';

  @override
  String get price_record_input_hint_text => '例: 120';

  @override
  String get memo_record_input_hint_text => '味の感想や評価など...';

  @override
  String get item_photo_name => '商品写真';

  @override
  String get item_name => '商品名';

  @override
  String get item_convenience_store_name => 'コンビニ';

  @override
  String get category_name => 'カテゴリ';

  @override
  String get price_name => '金額';

  @override
  String get memo_name => 'メモ';

  @override
  String get description_upload_or_take_a_photo => '写真を撮影またはアップロード';

  @override
  String get record_button_text => '記録する';
}
