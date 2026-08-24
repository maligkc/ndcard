import 'package:shared_preferences/shared_preferences.dart';

const _kTheme = 'gen_theme';
const _kFontSize = 'gen_font_size';
const _kRecognitionLangs = 'gen_recognition_langs';
const _kAutoSaveContacts = 'gen_auto_save_contacts';
const _kShowGroupOnSave = 'gen_show_group_on_save';
const _kSaveCardImage = 'gen_save_card_image';
const _kSortOrder = 'gen_sort_order';
const _kDisplayOrder = 'gen_display_order';
const _kAppLock = 'gen_app_lock';

Future<Map<String, dynamic>> loadGeneralSettingsValues() async {
  final prefs = await SharedPreferences.getInstance();
  return {
    'theme': prefs.getString(_kTheme) ?? 'system',
    'fontSize': prefs.getString(_kFontSize) ?? 'standard',
    'recognitionLanguages':
        prefs.getStringList(_kRecognitionLangs) ?? ['en', 'tr'],
    'autoSaveToContacts': prefs.getBool(_kAutoSaveContacts) ?? false,
    'showGroupOnSave': prefs.getBool(_kShowGroupOnSave) ?? false,
    'saveCardImage': prefs.getBool(_kSaveCardImage) ?? true,
    'sortOrder': prefs.getString(_kSortOrder) ?? 'first_last',
    'displayOrder': prefs.getString(_kDisplayOrder) ?? 'first_last',
    'appLock': prefs.getBool(_kAppLock) ?? false,
  };
}

Future<void> setGenTheme(String v) async =>
    (await SharedPreferences.getInstance()).setString(_kTheme, v);

Future<void> setGenFontSize(String v) async =>
    (await SharedPreferences.getInstance()).setString(_kFontSize, v);

Future<void> setGenRecognitionLangs(List<String> v) async =>
    (await SharedPreferences.getInstance()).setStringList(_kRecognitionLangs, v);

Future<void> setGenAutoSaveContacts(bool v) async =>
    (await SharedPreferences.getInstance()).setBool(_kAutoSaveContacts, v);

Future<void> setGenShowGroupOnSave(bool v) async =>
    (await SharedPreferences.getInstance()).setBool(_kShowGroupOnSave, v);

Future<void> setGenSaveCardImage(bool v) async =>
    (await SharedPreferences.getInstance()).setBool(_kSaveCardImage, v);

Future<void> setGenSortOrder(String v) async =>
    (await SharedPreferences.getInstance()).setString(_kSortOrder, v);

Future<void> setGenDisplayOrder(String v) async =>
    (await SharedPreferences.getInstance()).setString(_kDisplayOrder, v);

Future<void> setGenAppLock(bool v) async =>
    (await SharedPreferences.getInstance()).setBool(_kAppLock, v);
