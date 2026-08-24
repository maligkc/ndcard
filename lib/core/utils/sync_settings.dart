import 'package:shared_preferences/shared_preferences.dart';

const _kLastSyncKey = 'last_full_sync_at';

Future<DateTime?> getLastSyncAt() async {
  final prefs = await SharedPreferences.getInstance();
  final iso = prefs.getString(_kLastSyncKey);
  return iso == null ? null : DateTime.tryParse(iso);
}

Future<void> setLastSyncAtNow() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(_kLastSyncKey, DateTime.now().toIso8601String());
}
