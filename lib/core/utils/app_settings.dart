import 'package:shared_preferences/shared_preferences.dart';

const _kHighAccuracyKey = 'scan_high_accuracy_enabled';

/// "Yüksek doğruluk" tarama ayarı: açıkken görüntü sıkıştırılmadan
/// gönderilir (bkz. spec §7.3 Yönet sheet -> Kartvizit Yönetimi).
Future<bool> getHighAccuracyEnabled() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool(_kHighAccuracyKey) ?? false;
}

Future<void> setHighAccuracyEnabled(bool value) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool(_kHighAccuracyKey, value);
}
