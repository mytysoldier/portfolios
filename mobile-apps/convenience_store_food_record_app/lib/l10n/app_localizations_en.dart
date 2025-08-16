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

  @override
  String get pulldown_convenience_store_all => 'すべて';

  @override
  String get pulldown_convenience_store_seven => 'セブンイレブン';

  @override
  String get pulldown_convenience_store_rowson => 'ローソン';

  @override
  String get pulldown_convenience_store_family_mart => 'ファミリーマート';

  @override
  String get pulldown_convenience_store_other => 'その他';

  @override
  String get pulldown_item_all => 'すべて';

  @override
  String get pulldown_item_onigiri => 'おにぎり';

  @override
  String get pulldown_item_bread => 'パン';

  @override
  String get pulldown_item_lunch_box => '弁当';

  @override
  String get pulldown_item_dessert => 'デザート';

  @override
  String get statistic_screen_all_expenditure => '総支出額';

  @override
  String get statistic_screen_number_of_purchase_by_convenience_store =>
      'コンビニ別購入回数';

  @override
  String get statistic_screen_expenditure_by_category => 'カテゴリ別支出';

  @override
  String get statistic_screen_recent_trends => '最近の傾向';

  @override
  String get statistic_screen_total_number_of_records => '総記録数';

  @override
  String get statistic_screen_average_unit_price => '平均単価';

  @override
  String get seven_eleven => 'セブンイレブン';

  @override
  String get rowson => 'ローソン';

  @override
  String get family_mart => 'ファミリーマート';

  @override
  String get seicomart => 'セイコーマート';

  @override
  String get ministop => 'ミニストップ';

  @override
  String get daily_yamazaki => 'デイリーヤマザキ';

  @override
  String get poplar => 'ポプラ';

  @override
  String get other_store => 'その他';

  @override
  String get onigiri => 'おにぎり';

  @override
  String get bread => 'パン';

  @override
  String get soft_drink => 'ソフトドリンク';

  @override
  String get lunch_box => '弁当';

  @override
  String get dessert => 'デザート';

  @override
  String get noodle => '麺類';

  @override
  String get salad => 'サラダ';

  @override
  String get side_dish => 'おかず・惣菜';

  @override
  String get snack => 'スナック';

  @override
  String get ice_cream => 'アイスクリーム';

  @override
  String get hot_snack => 'ホットスナック';

  @override
  String get alcohol => 'アルコール';

  @override
  String get other_category => 'その他';

  @override
  String required_validation_error_message(Object field) {
    return '$fieldは必須項目です';
  }

  @override
  String invalid_validation_error_message(Object field) {
    return '$fieldの値が不正です';
  }

  @override
  String get photo_from_camera => 'カメラで撮影';

  @override
  String get photo_from_folder => 'フォルダから選択';
}
