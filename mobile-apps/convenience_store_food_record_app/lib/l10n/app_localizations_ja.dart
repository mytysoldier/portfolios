// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class L10nJa extends L10n {
  L10nJa([String locale = 'ja']) : super(locale);

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

  @override
  String get alert_text_delete => '削除しますか？';

  @override
  String get dialog_select_ok => 'はい';

  @override
  String get dialog_select_no => 'いいえ';

  @override
  String get terms_of_service_title => '利用規約';

  @override
  String get terms_of_service_last_updated => '最終更新日: 2025年10月19日';

  @override
  String get terms_of_service_sentence_one => '第1条（適用）';

  @override
  String get terms_of_service_sentence_one_content =>
      '本規約は、本アプリ「コンビニ飯記録」（以下「本サービス」）の利用に関する条件を、本サービスを利用するすべてのユーザー（以下「ユーザー」）と本サービス提供者（以下「当方」）との間で定めるものです。';

  @override
  String get terms_of_service_sentence_two => '第2条（アカウント登録）';

  @override
  String get terms_of_service_sentence_two_content =>
      'ユーザーは、本サービスの利用にあたり、正確かつ最新の情報を提供するものとします。虚偽の情報を提供した場合、アカウントの停止または削除を行うことがあります。';

  @override
  String get terms_of_service_sentence_three => '第3条（禁止事項）';

  @override
  String get terms_of_service_sentence_three_content =>
      'ユーザーは、本サービスの利用にあたり、以下の行為を行ってはなりません。\n・法令または公序良俗に違反する行為\n・犯罪行為に関連する行為\n・他のユーザーまたは第三者の権利を侵害する行為\n・本サービスの運営を妨害する行為\n・不正アクセスまたはこれを試みる行為';

  @override
  String get terms_of_service_sentence_four => '第4条（ユーザーコンテンツ）';

  @override
  String get terms_of_service_sentence_four_content =>
      'ユーザーが本サービスに投稿したコンテンツ（写真、テキスト等）の著作権は、ユーザーに帰属します。原則として、当方はこれらのコンテンツを使用しません。';

  @override
  String get terms_of_service_sentence_five => '第5条（個人情報の取扱い）';

  @override
  String get terms_of_service_sentence_five_content =>
      '当方は、ユーザーの個人情報を適切に管理し、プライバシーポリシーに従い取り扱います。';

  @override
  String get terms_of_service_sentence_six => '第6条（サービスの変更・停止）';

  @override
  String get terms_of_service_sentence_six_content =>
      '当方は、ユーザーへの事前の通知なく、本サービスの内容を変更、または提供を停止することができるものとします。これによりユーザーに生じた損害について、当方は一切の責任を負いません。';

  @override
  String get terms_of_service_sentence_seven => '第7条（免責事項）';

  @override
  String get terms_of_service_sentence_seven_content =>
      '当方は、本サービスにおける情報の正確性や動作の安全性について保証しません。';

  @override
  String get terms_of_service_sentence_eight => '第8条（利用停止・退会）';

  @override
  String get terms_of_service_sentence_eight_content =>
      'ユーザーは、いつでも本サービスの利用を停止し、退会することができます。';

  @override
  String get terms_of_service_sentence_nine => '第9条（規約の変更）';

  @override
  String get terms_of_service_sentence_nine_content =>
      '当方は、必要に応じて本規約を変更することができるものとします。変更後の規約は、本サービス上に掲載した時点から効力を生じるものとします。';

  @override
  String get terms_of_service_sentence_ten => '第10条（準拠法・裁判管轄）';

  @override
  String get terms_of_service_sentence_ten_content =>
      '本規約の解釈・適用は日本法に準拠し、本サービスに関して紛争が生じた場合、当方の所在地を管轄する裁判所を第一審の専属的合意管轄とします。';

  @override
  String get privacy_policy_title => 'プライバシーポリシー';

  @override
  String get privacy_policy_last_updated => '最終更新日: 2025年10月19日';

  @override
  String get privacy_policy_section_one => '1. 収集する情報';

  @override
  String get privacy_policy_section_one_content =>
      '当方は、本サービスの提供にあたり、以下の情報を収集します。\n・アカウント情報：ユーザー名、表示名、パスワード\n・利用情報：購入記録、商品情報、価格、メモ、写真\n・デバイス情報：端末の種類、OS、deviceId\n・ログ情報：アクセス日時、IPアドレス、利用状況';

  @override
  String get privacy_policy_section_two => '2. 情報の利用目的';

  @override
  String get privacy_policy_section_two_content =>
      '収集した情報は、以下の目的で利用します。\n・本サービスの提供、維持、改善\n・ユーザーサポート、問い合わせ対応\n・サービスの不正利用の防止\n・利用状況の分析、統計データの作成\n・新機能や更新情報の通知';

  @override
  String get privacy_policy_section_three => '3. 情報の共有';

  @override
  String get privacy_policy_section_three_content =>
      '当方は、ユーザーの個人情報を第三者に販売、貸与、または共有することはありません。ただし、以下の場合を除きます。\n・ユーザーの同意がある場合\n・法令に基づく場合\n・人の生命、身体または財産の保護のために必要がある場合';

  @override
  String get privacy_policy_section_four => '4. データの保存';

  @override
  String get privacy_policy_section_four_content =>
      'ゲストモードで利用する場合、データはお使いのデバイスにローカル保存されます。アカウント登録した場合、データは暗号化されて当方のサーバーに保存されます。';

  @override
  String get privacy_policy_section_five => '5. データの削除';

  @override
  String get privacy_policy_section_five_content =>
      'ユーザーは、アカウント設定からいつでもアカウントとすべてのデータを削除できます。削除されたデータは、バックアップを除き、速やかに削除されます。';

  @override
  String get privacy_policy_section_six => '6. セキュリティ';

  @override
  String get privacy_policy_section_six_content =>
      '当方は、ユーザーの個人情報を保護するため、適切なセキュリティ対策を実施しています。ただし、インターネット上の通信の完全な安全性を保証するものではありません。';

  @override
  String get privacy_policy_section_seven => '7. プライバシーポリシーの変更';

  @override
  String get privacy_policy_section_seven_content =>
      '当方は、必要に応じて本ポリシーを変更することがあります。変更後のポリシーは、本サービス上に掲載した時点から効力を生じるものとします。';

  @override
  String get privacy_policy_section_eight => '8. お問い合わせ';

  @override
  String get privacy_policy_section_eight_content =>
      '本ポリシーに関するご質問やご不明な点がございましたら、アプリ内のお問い合わせフォームからご連絡ください。';

  @override
  String get error_image_too_large => '画像サイズが大きすぎます。5MB以下の画像を選択してください。';
}
