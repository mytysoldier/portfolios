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
