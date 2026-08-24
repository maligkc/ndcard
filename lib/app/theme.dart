import 'package:flutter/cupertino.dart';

/// NDCard Cupertino theme: sade, beyaz/gri zemin, sistem temasını takip eder.
class AppTheme {
  AppTheme._();

  static const Color primaryColor = CupertinoColors.activeBlue;

  static const CupertinoThemeData light = CupertinoThemeData(
    brightness: Brightness.light,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: CupertinoColors.systemGroupedBackground,
    barBackgroundColor: CupertinoColors.systemBackground,
  );

  static const CupertinoThemeData dark = CupertinoThemeData(
    brightness: Brightness.dark,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: CupertinoColors.systemGroupedBackground,
    barBackgroundColor: CupertinoColors.systemBackground,
  );

  static CupertinoThemeData resolve(Brightness brightness) {
    return brightness == Brightness.dark ? dark : light;
  }
}
