import 'package:flutter/material.dart';

extension CustomTextTheme on TextTheme {
  TextStyle get headlineLargeBold {
    return headlineLarge?.copyWith(fontWeight: FontWeight.bold) ??
        const TextStyle(fontWeight: FontWeight.bold);
  }
}
