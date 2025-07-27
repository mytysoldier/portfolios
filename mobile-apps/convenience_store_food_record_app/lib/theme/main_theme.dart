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
  cardTheme: const CardThemeData(
    color: Colors.white,
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
  ),
);
