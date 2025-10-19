import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ja.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of L10n
/// returned by `L10n.of(context)`.
///
/// Applications need to include `L10n.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: L10n.localizationsDelegates,
///   supportedLocales: L10n.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the L10n.supportedLocales
/// property.
abstract class L10n {
  L10n(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static L10n of(BuildContext context) {
    return Localizations.of<L10n>(context, L10n)!;
  }

  static const LocalizationsDelegate<L10n> delegate = _L10nDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ja'),
  ];

  /// No description provided for @screen_title.
  ///
  /// In ja, this message translates to:
  /// **'コンビニ飯記録'**
  String get screen_title;

  /// No description provided for @history_screen_title.
  ///
  /// In ja, this message translates to:
  /// **'購入履歴'**
  String get history_screen_title;

  /// No description provided for @record_screen_title.
  ///
  /// In ja, this message translates to:
  /// **'新しい記録'**
  String get record_screen_title;

  /// No description provided for @statistic_screen_title.
  ///
  /// In ja, this message translates to:
  /// **'統計情報'**
  String get statistic_screen_title;

  /// No description provided for @history_search_input_hint_text.
  ///
  /// In ja, this message translates to:
  /// **'商品名やメモで検索...'**
  String get history_search_input_hint_text;

  /// No description provided for @item_name_record_input_hint_text.
  ///
  /// In ja, this message translates to:
  /// **'例: ツナマヨおにぎり'**
  String get item_name_record_input_hint_text;

  /// No description provided for @convenience_store_record_input_hint_text.
  ///
  /// In ja, this message translates to:
  /// **'コンビニを選択'**
  String get convenience_store_record_input_hint_text;

  /// No description provided for @category_record_input_hint_text.
  ///
  /// In ja, this message translates to:
  /// **'カテゴリを選択'**
  String get category_record_input_hint_text;

  /// No description provided for @price_record_input_hint_text.
  ///
  /// In ja, this message translates to:
  /// **'例: 120'**
  String get price_record_input_hint_text;

  /// No description provided for @memo_record_input_hint_text.
  ///
  /// In ja, this message translates to:
  /// **'味の感想や評価など...'**
  String get memo_record_input_hint_text;

  /// No description provided for @item_photo_name.
  ///
  /// In ja, this message translates to:
  /// **'商品写真'**
  String get item_photo_name;

  /// No description provided for @item_name.
  ///
  /// In ja, this message translates to:
  /// **'商品名'**
  String get item_name;

  /// No description provided for @item_convenience_store_name.
  ///
  /// In ja, this message translates to:
  /// **'コンビニ'**
  String get item_convenience_store_name;

  /// No description provided for @category_name.
  ///
  /// In ja, this message translates to:
  /// **'カテゴリ'**
  String get category_name;

  /// No description provided for @price_name.
  ///
  /// In ja, this message translates to:
  /// **'金額'**
  String get price_name;

  /// No description provided for @memo_name.
  ///
  /// In ja, this message translates to:
  /// **'メモ'**
  String get memo_name;

  /// No description provided for @description_upload_or_take_a_photo.
  ///
  /// In ja, this message translates to:
  /// **'写真を撮影またはアップロード'**
  String get description_upload_or_take_a_photo;

  /// No description provided for @record_button_text.
  ///
  /// In ja, this message translates to:
  /// **'記録する'**
  String get record_button_text;

  /// No description provided for @pulldown_convenience_store_all.
  ///
  /// In ja, this message translates to:
  /// **'すべて'**
  String get pulldown_convenience_store_all;

  /// No description provided for @pulldown_convenience_store_seven.
  ///
  /// In ja, this message translates to:
  /// **'セブンイレブン'**
  String get pulldown_convenience_store_seven;

  /// No description provided for @pulldown_convenience_store_rowson.
  ///
  /// In ja, this message translates to:
  /// **'ローソン'**
  String get pulldown_convenience_store_rowson;

  /// No description provided for @pulldown_convenience_store_family_mart.
  ///
  /// In ja, this message translates to:
  /// **'ファミリーマート'**
  String get pulldown_convenience_store_family_mart;

  /// No description provided for @pulldown_convenience_store_other.
  ///
  /// In ja, this message translates to:
  /// **'その他'**
  String get pulldown_convenience_store_other;

  /// No description provided for @pulldown_item_all.
  ///
  /// In ja, this message translates to:
  /// **'すべて'**
  String get pulldown_item_all;

  /// No description provided for @pulldown_item_onigiri.
  ///
  /// In ja, this message translates to:
  /// **'おにぎり'**
  String get pulldown_item_onigiri;

  /// No description provided for @pulldown_item_bread.
  ///
  /// In ja, this message translates to:
  /// **'パン'**
  String get pulldown_item_bread;

  /// No description provided for @pulldown_item_lunch_box.
  ///
  /// In ja, this message translates to:
  /// **'弁当'**
  String get pulldown_item_lunch_box;

  /// No description provided for @pulldown_item_dessert.
  ///
  /// In ja, this message translates to:
  /// **'デザート'**
  String get pulldown_item_dessert;

  /// No description provided for @statistic_screen_all_expenditure.
  ///
  /// In ja, this message translates to:
  /// **'総支出額'**
  String get statistic_screen_all_expenditure;

  /// No description provided for @statistic_screen_number_of_purchase_by_convenience_store.
  ///
  /// In ja, this message translates to:
  /// **'コンビニ別購入回数'**
  String get statistic_screen_number_of_purchase_by_convenience_store;

  /// No description provided for @statistic_screen_expenditure_by_category.
  ///
  /// In ja, this message translates to:
  /// **'カテゴリ別支出'**
  String get statistic_screen_expenditure_by_category;

  /// No description provided for @statistic_screen_recent_trends.
  ///
  /// In ja, this message translates to:
  /// **'最近の傾向'**
  String get statistic_screen_recent_trends;

  /// No description provided for @statistic_screen_total_number_of_records.
  ///
  /// In ja, this message translates to:
  /// **'総記録数'**
  String get statistic_screen_total_number_of_records;

  /// No description provided for @statistic_screen_average_unit_price.
  ///
  /// In ja, this message translates to:
  /// **'平均単価'**
  String get statistic_screen_average_unit_price;

  /// No description provided for @seven_eleven.
  ///
  /// In ja, this message translates to:
  /// **'セブンイレブン'**
  String get seven_eleven;

  /// No description provided for @rowson.
  ///
  /// In ja, this message translates to:
  /// **'ローソン'**
  String get rowson;

  /// No description provided for @family_mart.
  ///
  /// In ja, this message translates to:
  /// **'ファミリーマート'**
  String get family_mart;

  /// No description provided for @seicomart.
  ///
  /// In ja, this message translates to:
  /// **'セイコーマート'**
  String get seicomart;

  /// No description provided for @ministop.
  ///
  /// In ja, this message translates to:
  /// **'ミニストップ'**
  String get ministop;

  /// No description provided for @daily_yamazaki.
  ///
  /// In ja, this message translates to:
  /// **'デイリーヤマザキ'**
  String get daily_yamazaki;

  /// No description provided for @poplar.
  ///
  /// In ja, this message translates to:
  /// **'ポプラ'**
  String get poplar;

  /// No description provided for @other_store.
  ///
  /// In ja, this message translates to:
  /// **'その他'**
  String get other_store;

  /// No description provided for @onigiri.
  ///
  /// In ja, this message translates to:
  /// **'おにぎり'**
  String get onigiri;

  /// No description provided for @bread.
  ///
  /// In ja, this message translates to:
  /// **'パン'**
  String get bread;

  /// No description provided for @soft_drink.
  ///
  /// In ja, this message translates to:
  /// **'ソフトドリンク'**
  String get soft_drink;

  /// No description provided for @lunch_box.
  ///
  /// In ja, this message translates to:
  /// **'弁当'**
  String get lunch_box;

  /// No description provided for @dessert.
  ///
  /// In ja, this message translates to:
  /// **'デザート'**
  String get dessert;

  /// No description provided for @noodle.
  ///
  /// In ja, this message translates to:
  /// **'麺類'**
  String get noodle;

  /// No description provided for @salad.
  ///
  /// In ja, this message translates to:
  /// **'サラダ'**
  String get salad;

  /// No description provided for @side_dish.
  ///
  /// In ja, this message translates to:
  /// **'おかず・惣菜'**
  String get side_dish;

  /// No description provided for @snack.
  ///
  /// In ja, this message translates to:
  /// **'スナック'**
  String get snack;

  /// No description provided for @ice_cream.
  ///
  /// In ja, this message translates to:
  /// **'アイスクリーム'**
  String get ice_cream;

  /// No description provided for @hot_snack.
  ///
  /// In ja, this message translates to:
  /// **'ホットスナック'**
  String get hot_snack;

  /// No description provided for @alcohol.
  ///
  /// In ja, this message translates to:
  /// **'アルコール'**
  String get alcohol;

  /// No description provided for @other_category.
  ///
  /// In ja, this message translates to:
  /// **'その他'**
  String get other_category;

  /// No description provided for @required_validation_error_message.
  ///
  /// In ja, this message translates to:
  /// **'{field}は必須項目です'**
  String required_validation_error_message(Object field);

  /// No description provided for @invalid_validation_error_message.
  ///
  /// In ja, this message translates to:
  /// **'{field}の値が不正です'**
  String invalid_validation_error_message(Object field);

  /// No description provided for @photo_from_camera.
  ///
  /// In ja, this message translates to:
  /// **'カメラで撮影'**
  String get photo_from_camera;

  /// No description provided for @photo_from_folder.
  ///
  /// In ja, this message translates to:
  /// **'フォルダから選択'**
  String get photo_from_folder;

  /// No description provided for @alert_text_delete.
  ///
  /// In ja, this message translates to:
  /// **'削除しますか？'**
  String get alert_text_delete;

  /// No description provided for @dialog_select_ok.
  ///
  /// In ja, this message translates to:
  /// **'はい'**
  String get dialog_select_ok;

  /// No description provided for @dialog_select_no.
  ///
  /// In ja, this message translates to:
  /// **'いいえ'**
  String get dialog_select_no;

  /// No description provided for @terms_of_service_title.
  ///
  /// In ja, this message translates to:
  /// **'利用規約'**
  String get terms_of_service_title;

  /// No description provided for @terms_of_service_last_updated.
  ///
  /// In ja, this message translates to:
  /// **'最終更新日: 2025年10月19日'**
  String get terms_of_service_last_updated;

  /// No description provided for @terms_of_service_sentence_one.
  ///
  /// In ja, this message translates to:
  /// **'第1条（適用）'**
  String get terms_of_service_sentence_one;

  /// No description provided for @terms_of_service_sentence_one_content.
  ///
  /// In ja, this message translates to:
  /// **'本規約は、本アプリ「コンビニ飯記録」（以下「本サービス」）の利用に関する条件を、本サービスを利用するすべてのユーザー（以下「ユーザー」）と本サービス提供者（以下「当方」）との間で定めるものです。'**
  String get terms_of_service_sentence_one_content;

  /// No description provided for @terms_of_service_sentence_two.
  ///
  /// In ja, this message translates to:
  /// **'第2条（アカウント登録）'**
  String get terms_of_service_sentence_two;

  /// No description provided for @terms_of_service_sentence_two_content.
  ///
  /// In ja, this message translates to:
  /// **'ユーザーは、本サービスの利用にあたり、正確かつ最新の情報を提供するものとします。虚偽の情報を提供した場合、アカウントの停止または削除を行うことがあります。'**
  String get terms_of_service_sentence_two_content;

  /// No description provided for @terms_of_service_sentence_three.
  ///
  /// In ja, this message translates to:
  /// **'第3条（禁止事項）'**
  String get terms_of_service_sentence_three;

  /// No description provided for @terms_of_service_sentence_three_content.
  ///
  /// In ja, this message translates to:
  /// **'ユーザーは、本サービスの利用にあたり、以下の行為を行ってはなりません。\n・法令または公序良俗に違反する行為\n・犯罪行為に関連する行為\n・他のユーザーまたは第三者の権利を侵害する行為\n・本サービスの運営を妨害する行為\n・不正アクセスまたはこれを試みる行為'**
  String get terms_of_service_sentence_three_content;

  /// No description provided for @terms_of_service_sentence_four.
  ///
  /// In ja, this message translates to:
  /// **'第4条（ユーザーコンテンツ）'**
  String get terms_of_service_sentence_four;

  /// No description provided for @terms_of_service_sentence_four_content.
  ///
  /// In ja, this message translates to:
  /// **'ユーザーが本サービスに投稿したコンテンツ（写真、テキスト等）の著作権は、ユーザーに帰属します。原則として、当方はこれらのコンテンツを使用しません。'**
  String get terms_of_service_sentence_four_content;

  /// No description provided for @terms_of_service_sentence_five.
  ///
  /// In ja, this message translates to:
  /// **'第5条（個人情報の取扱い）'**
  String get terms_of_service_sentence_five;

  /// No description provided for @terms_of_service_sentence_five_content.
  ///
  /// In ja, this message translates to:
  /// **'当方は、ユーザーの個人情報を適切に管理し、プライバシーポリシーに従い取り扱います。'**
  String get terms_of_service_sentence_five_content;

  /// No description provided for @terms_of_service_sentence_six.
  ///
  /// In ja, this message translates to:
  /// **'第6条（サービスの変更・停止）'**
  String get terms_of_service_sentence_six;

  /// No description provided for @terms_of_service_sentence_six_content.
  ///
  /// In ja, this message translates to:
  /// **'当方は、ユーザーへの事前の通知なく、本サービスの内容を変更、または提供を停止することができるものとします。これによりユーザーに生じた損害について、当方は一切の責任を負いません。'**
  String get terms_of_service_sentence_six_content;

  /// No description provided for @terms_of_service_sentence_seven.
  ///
  /// In ja, this message translates to:
  /// **'第7条（免責事項）'**
  String get terms_of_service_sentence_seven;

  /// No description provided for @terms_of_service_sentence_seven_content.
  ///
  /// In ja, this message translates to:
  /// **'当方は、本サービスにおける情報の正確性や動作の安全性について保証しません。'**
  String get terms_of_service_sentence_seven_content;

  /// No description provided for @terms_of_service_sentence_eight.
  ///
  /// In ja, this message translates to:
  /// **'第8条（利用停止・退会）'**
  String get terms_of_service_sentence_eight;

  /// No description provided for @terms_of_service_sentence_eight_content.
  ///
  /// In ja, this message translates to:
  /// **'ユーザーは、いつでも本サービスの利用を停止し、退会することができます。'**
  String get terms_of_service_sentence_eight_content;

  /// No description provided for @terms_of_service_sentence_nine.
  ///
  /// In ja, this message translates to:
  /// **'第9条（規約の変更）'**
  String get terms_of_service_sentence_nine;

  /// No description provided for @terms_of_service_sentence_nine_content.
  ///
  /// In ja, this message translates to:
  /// **'当方は、必要に応じて本規約を変更することができるものとします。変更後の規約は、本サービス上に掲載した時点から効力を生じるものとします。'**
  String get terms_of_service_sentence_nine_content;

  /// No description provided for @terms_of_service_sentence_ten.
  ///
  /// In ja, this message translates to:
  /// **'第10条（準拠法・裁判管轄）'**
  String get terms_of_service_sentence_ten;

  /// No description provided for @terms_of_service_sentence_ten_content.
  ///
  /// In ja, this message translates to:
  /// **'本規約の解釈・適用は日本法に準拠し、本サービスに関して紛争が生じた場合、当方の所在地を管轄する裁判所を第一審の専属的合意管轄とします。'**
  String get terms_of_service_sentence_ten_content;

  /// No description provided for @privacy_policy_title.
  ///
  /// In ja, this message translates to:
  /// **'プライバシーポリシー'**
  String get privacy_policy_title;

  /// No description provided for @privacy_policy_last_updated.
  ///
  /// In ja, this message translates to:
  /// **'最終更新日: 2025年10月19日'**
  String get privacy_policy_last_updated;

  /// No description provided for @privacy_policy_section_one.
  ///
  /// In ja, this message translates to:
  /// **'1. 収集する情報'**
  String get privacy_policy_section_one;

  /// No description provided for @privacy_policy_section_one_content.
  ///
  /// In ja, this message translates to:
  /// **'当方は、本サービスの提供にあたり、以下の情報を収集します。\n・アカウント情報：ユーザー名、表示名、パスワード\n・利用情報：購入記録、商品情報、価格、メモ、写真\n・デバイス情報：端末の種類、OS、deviceId\n・ログ情報：アクセス日時、IPアドレス、利用状況'**
  String get privacy_policy_section_one_content;

  /// No description provided for @privacy_policy_section_two.
  ///
  /// In ja, this message translates to:
  /// **'2. 情報の利用目的'**
  String get privacy_policy_section_two;

  /// No description provided for @privacy_policy_section_two_content.
  ///
  /// In ja, this message translates to:
  /// **'収集した情報は、以下の目的で利用します。\n・本サービスの提供、維持、改善\n・ユーザーサポート、問い合わせ対応\n・サービスの不正利用の防止\n・利用状況の分析、統計データの作成\n・新機能や更新情報の通知'**
  String get privacy_policy_section_two_content;

  /// No description provided for @privacy_policy_section_three.
  ///
  /// In ja, this message translates to:
  /// **'3. 情報の共有'**
  String get privacy_policy_section_three;

  /// No description provided for @privacy_policy_section_three_content.
  ///
  /// In ja, this message translates to:
  /// **'当方は、ユーザーの個人情報を第三者に販売、貸与、または共有することはありません。ただし、以下の場合を除きます。\n・ユーザーの同意がある場合\n・法令に基づく場合\n・人の生命、身体または財産の保護のために必要がある場合'**
  String get privacy_policy_section_three_content;

  /// No description provided for @privacy_policy_section_four.
  ///
  /// In ja, this message translates to:
  /// **'4. データの保存'**
  String get privacy_policy_section_four;

  /// No description provided for @privacy_policy_section_four_content.
  ///
  /// In ja, this message translates to:
  /// **'ゲストモードで利用する場合、データはお使いのデバイスにローカル保存されます。アカウント登録した場合、データは暗号化されて当方のサーバーに保存されます。'**
  String get privacy_policy_section_four_content;

  /// No description provided for @privacy_policy_section_five.
  ///
  /// In ja, this message translates to:
  /// **'5. データの削除'**
  String get privacy_policy_section_five;

  /// No description provided for @privacy_policy_section_five_content.
  ///
  /// In ja, this message translates to:
  /// **'ユーザーは、アカウント設定からいつでもアカウントとすべてのデータを削除できます。削除されたデータは、バックアップを除き、速やかに削除されます。'**
  String get privacy_policy_section_five_content;

  /// No description provided for @privacy_policy_section_six.
  ///
  /// In ja, this message translates to:
  /// **'6. セキュリティ'**
  String get privacy_policy_section_six;

  /// No description provided for @privacy_policy_section_six_content.
  ///
  /// In ja, this message translates to:
  /// **'当方は、ユーザーの個人情報を保護するため、適切なセキュリティ対策を実施しています。ただし、インターネット上の通信の完全な安全性を保証するものではありません。'**
  String get privacy_policy_section_six_content;

  /// No description provided for @privacy_policy_section_seven.
  ///
  /// In ja, this message translates to:
  /// **'7. プライバシーポリシーの変更'**
  String get privacy_policy_section_seven;

  /// No description provided for @privacy_policy_section_seven_content.
  ///
  /// In ja, this message translates to:
  /// **'当方は、必要に応じて本ポリシーを変更することがあります。変更後のポリシーは、本サービス上に掲載した時点から効力を生じるものとします。'**
  String get privacy_policy_section_seven_content;

  /// No description provided for @privacy_policy_section_eight.
  ///
  /// In ja, this message translates to:
  /// **'8. お問い合わせ'**
  String get privacy_policy_section_eight;

  /// No description provided for @privacy_policy_section_eight_content.
  ///
  /// In ja, this message translates to:
  /// **'本ポリシーに関するご質問やご不明な点がございましたら、アプリ内のお問い合わせフォームからご連絡ください。'**
  String get privacy_policy_section_eight_content;
}

class _L10nDelegate extends LocalizationsDelegate<L10n> {
  const _L10nDelegate();

  @override
  Future<L10n> load(Locale locale) {
    return SynchronousFuture<L10n>(lookupL10n(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ja'].contains(locale.languageCode);

  @override
  bool shouldReload(_L10nDelegate old) => false;
}

L10n lookupL10n(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return L10nEn();
    case 'ja':
      return L10nJa();
  }

  throw FlutterError(
    'L10n.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
