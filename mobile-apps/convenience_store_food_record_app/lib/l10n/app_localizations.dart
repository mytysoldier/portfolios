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
