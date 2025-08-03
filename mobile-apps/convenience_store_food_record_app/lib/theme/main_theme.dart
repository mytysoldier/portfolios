import 'package:flutter/material.dart';

class AppTextStyles {
  static const sampleTextStyle = TextStyle(fontSize: 14, color: Colors.black54);
  static const bodyHeadTextStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 16,
    color: Colors.black,
  );
  static const bodyLarge = TextStyle(fontSize: 16, color: Colors.black);
  static const bodySmall = TextStyle(fontSize: 12, color: Colors.grey);
  static const titleMedium = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 18,
    color: Colors.deepPurple,
  );
  // 他にもfigmaのデザイントークン名に合わせて追加可能
}

extension CustomTextTheme on TextTheme {
  TextStyle get sampleTextStyle => AppTextStyles.sampleTextStyle;
  TextStyle get bodyHeadTextStyle => AppTextStyles.bodyHeadTextStyle;
}

class AppSizes {
  static const double cardRadius = 12.0;
  static const double buttonRadius = 8.0;
  static const double imageRadius = 8.0;
  static const double iconSize = 16.0;
  static const double avatarSize = 40.0;
  static const double spacingXxxs = 1.0;
  static const double spacingXxs = 2.0;
  static const double spacingXS = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 16.0;
  static const double spacingL = 24.0;
  static const double spacingXL = 32.0;
  // 他にも必要に応じて追加可能
}

final mainThemeData = ThemeData(
  primaryColor: Colors.deepPurple,
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.deepPurple,
    foregroundColor: Colors.white,
    titleTextStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
  ),
  textTheme: const TextTheme(
    bodyLarge: AppTextStyles.bodyLarge,
    bodySmall: AppTextStyles.bodySmall,
    titleMedium: AppTextStyles.titleMedium,
    // 独自スタイルはTextThemeには追加せず、AppTextStyles経由で利用
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStatePropertyAll(Colors.deepPurple),
      foregroundColor: WidgetStatePropertyAll(Colors.white),
      textStyle: WidgetStatePropertyAll(TextStyle(fontWeight: FontWeight.bold)),
    ),
  ),
  cardTheme: CardThemeData(
    color: Colors.white,
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(AppSizes.cardRadius)),
    ),
  ),
);
