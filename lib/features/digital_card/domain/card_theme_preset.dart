import 'package:flutter/cupertino.dart';

class CardThemePreset {
  const CardThemePreset({
    required this.key,
    required this.fallbackName,
    required this.background,
    required this.foreground,
    this.gradient,
    this.fontWeight = FontWeight.w600,
  });

  final String key;
  final String fallbackName;
  final Color background;
  final Color foreground;
  final List<Color>? gradient;
  final FontWeight fontWeight;
}

const List<CardThemePreset> kCardThemes = [
  CardThemePreset(
    key: 'classic',
    fallbackName: 'Klasik Beyaz',
    background: CupertinoColors.white,
    foreground: CupertinoColors.black,
  ),
  CardThemePreset(
    key: 'dark',
    fallbackName: 'Koyu',
    background: Color(0xFF1C1C1E),
    foreground: CupertinoColors.white,
  ),
  CardThemePreset(
    key: 'corporate_blue',
    fallbackName: 'Mavi Kurumsal',
    background: Color(0xFF0A2540),
    foreground: CupertinoColors.white,
  ),
  CardThemePreset(
    key: 'gradient',
    fallbackName: 'Degrade',
    background: Color(0xFF6D5BD0),
    foreground: CupertinoColors.white,
    gradient: [Color(0xFF6D5BD0), Color(0xFFFF7AC6)],
  ),
  CardThemePreset(
    key: 'minimal',
    fallbackName: 'Minimal Çizgili',
    background: CupertinoColors.white,
    foreground: Color(0xFF1C1C1E),
    fontWeight: FontWeight.w400,
  ),
  CardThemePreset(
    key: 'nd_group',
    fallbackName: 'ND Group Kurumsal',
    background: Color(0xFF0F1B2B),
    foreground: Color(0xFFE0A93A),
  ),
];

CardThemePreset cardThemeByKey(String key) {
  return kCardThemes.firstWhere((t) => t.key == key, orElse: () => kCardThemes.first);
}
