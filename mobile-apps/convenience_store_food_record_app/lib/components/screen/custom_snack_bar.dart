import 'package:flutter/material.dart';

class CustomSnackBar {
  static SnackBar show({
    required String message,
    Color? backgroundColor,
    double borderRadius = 16.0,
    Duration duration = const Duration(seconds: 2),
    TextStyle? textStyle,
  }) {
    return SnackBar(
      content: Text(
        message,
        style: textStyle ?? const TextStyle(color: Colors.white, fontSize: 16),
        textAlign: TextAlign.center,
      ),
      backgroundColor: backgroundColor ?? Colors.deepPurple,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      duration: duration,
      elevation: 8,
    );
  }
}
