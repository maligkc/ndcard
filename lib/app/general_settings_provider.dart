import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/utils/general_settings_storage.dart';

class GeneralSettings {
  const GeneralSettings({
    this.theme = 'system',
    this.fontSize = 'standard',
    this.recognitionLanguages = const ['en', 'tr'],
    this.autoSaveToContacts = false,
    this.showGroupOnSave = false,
    this.saveCardImage = true,
    this.sortOrder = 'first_last',
    this.displayOrder = 'first_last',
    this.appLock = false,
  });

  final String theme; // 'system' | 'light' | 'dark'
  final String fontSize; // 'standard' | 'large' | 'xlarge'
  final List<String> recognitionLanguages;
  final bool autoSaveToContacts;
  final bool showGroupOnSave;
  final bool saveCardImage;
  final String sortOrder; // 'first_last' | 'last_first'
  final String displayOrder; // 'first_last' | 'last_first'
  final bool appLock;

  GeneralSettings copyWith({
    String? theme,
    String? fontSize,
    List<String>? recognitionLanguages,
    bool? autoSaveToContacts,
    bool? showGroupOnSave,
    bool? saveCardImage,
    String? sortOrder,
    String? displayOrder,
    bool? appLock,
  }) {
    return GeneralSettings(
      theme: theme ?? this.theme,
      fontSize: fontSize ?? this.fontSize,
      recognitionLanguages: recognitionLanguages ?? this.recognitionLanguages,
      autoSaveToContacts: autoSaveToContacts ?? this.autoSaveToContacts,
      showGroupOnSave: showGroupOnSave ?? this.showGroupOnSave,
      saveCardImage: saveCardImage ?? this.saveCardImage,
      sortOrder: sortOrder ?? this.sortOrder,
      displayOrder: displayOrder ?? this.displayOrder,
      appLock: appLock ?? this.appLock,
    );
  }
}

class GeneralSettingsNotifier extends Notifier<GeneralSettings> {
  @override
  GeneralSettings build() {
    _load();
    return const GeneralSettings();
  }

  Future<void> _load() async {
    final v = await loadGeneralSettingsValues();
    state = GeneralSettings(
      theme: v['theme'] as String,
      fontSize: v['fontSize'] as String,
      recognitionLanguages: List<String>.from(v['recognitionLanguages'] as List),
      autoSaveToContacts: v['autoSaveToContacts'] as bool,
      showGroupOnSave: v['showGroupOnSave'] as bool,
      saveCardImage: v['saveCardImage'] as bool,
      sortOrder: v['sortOrder'] as String,
      displayOrder: v['displayOrder'] as String,
      appLock: v['appLock'] as bool,
    );
  }

  Future<void> setTheme(String value) async {
    state = state.copyWith(theme: value);
    await setGenTheme(value);
  }

  Future<void> setFontSize(String value) async {
    state = state.copyWith(fontSize: value);
    await setGenFontSize(value);
  }

  Future<void> setRecognitionLanguages(List<String> value) async {
    state = state.copyWith(recognitionLanguages: value);
    await setGenRecognitionLangs(value);
  }

  Future<void> setAutoSaveToContacts(bool value) async {
    state = state.copyWith(autoSaveToContacts: value);
    await setGenAutoSaveContacts(value);
  }

  Future<void> setShowGroupOnSave(bool value) async {
    state = state.copyWith(showGroupOnSave: value);
    await setGenShowGroupOnSave(value);
  }

  Future<void> setSaveCardImage(bool value) async {
    state = state.copyWith(saveCardImage: value);
    await setGenSaveCardImage(value);
  }

  Future<void> setSortOrder(String value) async {
    state = state.copyWith(sortOrder: value);
    await setGenSortOrder(value);
  }

  Future<void> setDisplayOrder(String value) async {
    state = state.copyWith(displayOrder: value);
    await setGenDisplayOrder(value);
  }

  Future<void> setAppLock(bool value) async {
    state = state.copyWith(appLock: value);
    await setGenAppLock(value);
  }
}

final generalSettingsProvider =
    NotifierProvider<GeneralSettingsNotifier, GeneralSettings>(
  GeneralSettingsNotifier.new,
);
