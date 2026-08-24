import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/utils/locale_settings.dart';

/// 'system' | 'tr' | 'en'. Açılışta persisted değerden yüklenir; Ayarlar ->
/// Dil Ayarı sayfasından değiştirildiğinde hem state hem disk güncellenir.
class LocaleOverrideNotifier extends Notifier<String> {
  @override
  String build() {
    _loadPersisted();
    return 'system';
  }

  Future<void> _loadPersisted() async {
    final value = await getLocaleOverride();
    state = value;
  }

  Future<void> setLocale(String value) async {
    state = value;
    await setLocaleOverride(value);
  }
}

final localeOverrideProvider = NotifierProvider<LocaleOverrideNotifier, String>(
  LocaleOverrideNotifier.new,
);
