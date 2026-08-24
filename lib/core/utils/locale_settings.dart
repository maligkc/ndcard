import 'package:shared_preferences/shared_preferences.dart';

const _kLocaleKey = 'app_locale_override';

/// 'system' | 'tr' | 'en'. 'system' -> cihazın dilini takip eder.
Future<String> getLocaleOverride() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString(_kLocaleKey) ?? 'system';
}

Future<void> setLocaleOverride(String value) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(_kLocaleKey, value);
}
