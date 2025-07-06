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
}
