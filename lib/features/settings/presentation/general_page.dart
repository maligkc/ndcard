import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';

import '../../../app/general_settings_provider.dart';
import '../../../core/backend_providers.dart';
import '../../../core/widgets/error_dialog.dart';
import '../../../l10n/gen/app_localizations.dart';

class GeneralPage extends HookConsumerWidget {
  const GeneralPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final settings = ref.watch(generalSettingsProvider);
    final notifier = ref.read(generalSettingsProvider.notifier);

    final version = useState<String?>(null);
    final cacheSize = useState<String?>(null);
    final isClearing = useState(false);

    useEffect(() {
      PackageInfo.fromPlatform().then((info) {
        if (context.mounted) {
          version.value = '${info.version} (${info.buildNumber})';
        }
      });
      _calcCacheSize().then((s) {
        if (context.mounted) cacheSize.value = s;
      });
      return null;
    }, const []);

    void push(Widget page) {
      Navigator.of(context).push(CupertinoPageRoute<void>(builder: (_) => page));
    }

    Future<void> clearCache() async {
      final confirmed = await showCupertinoDialog<bool>(
        context: context,
        builder: (ctx) => CupertinoAlertDialog(
          title: Text(l10n.generalClearSpaceConfirmTitle),
          content: Text(l10n.generalClearSpaceConfirmMessage),
          actions: [
            CupertinoDialogAction(
              child: Text(l10n.commonCancel),
              onPressed: () => Navigator.of(ctx).pop(false),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              child: Text(l10n.commonDelete),
              onPressed: () => Navigator.of(ctx).pop(true),
            ),
          ],
        ),
      );
      if (confirmed != true || !context.mounted) return;
      isClearing.value = true;
      try {
        await ref.read(appDatabaseProvider).clearCache();
        final tmp = await getTemporaryDirectory();
        await _deleteDir(tmp);
        final newSize = await _calcCacheSize();
        if (context.mounted) cacheSize.value = newSize;
      } catch (e) {
        if (context.mounted) await showErrorDialog(context, e);
      } finally {
        isClearing.value = false;
      }
    }

    String themeLabel(String v) => switch (v) {
          'light' => l10n.generalThemeLight,
          'dark' => l10n.generalThemeDark,
          _ => l10n.generalThemeSystem,
        };

    String fontLabel(String v) => switch (v) {
          'large' => l10n.generalFontLarge,
          'xlarge' => l10n.generalFontXLarge,
          _ => l10n.generalFontStandard,
        };

    String orderLabel(String v) =>
        v == 'last_first' ? l10n.generalLastFirst : l10n.generalFirstLast;

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: Text(l10n.settingsGeneral)),
      child: SafeArea(
        child: ListView(
          children: [
            // ── Appearance ──────────────────────────────────────────────────
            CupertinoListSection.insetGrouped(
              header: Text(l10n.generalAppearance),
              children: [
                CupertinoListTile(
                  title: Text(l10n.generalTheme),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        themeLabel(settings.theme),
                        style: TextStyle(
                            color: CupertinoColors.secondaryLabel.resolveFrom(context)),
                      ),
                      const SizedBox(width: 4),
                      const CupertinoListTileChevron(),
                    ],
                  ),
                  onTap: () => push(_OptionPage<String>(
                    title: l10n.generalTheme,
                    options: [
                      (value: 'system', label: l10n.generalThemeSystem),
                      (value: 'light', label: l10n.generalThemeLight),
                      (value: 'dark', label: l10n.generalThemeDark),
                    ],
                    current: settings.theme,
                    onSelect: notifier.setTheme,
                  )),
                ),
                CupertinoListTile(
                  title: Text(l10n.generalFontSize),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        fontLabel(settings.fontSize),
                        style: TextStyle(
                            color: CupertinoColors.secondaryLabel.resolveFrom(context)),
                      ),
                      const SizedBox(width: 4),
                      const CupertinoListTileChevron(),
                    ],
                  ),
                  onTap: () => push(_OptionPage<String>(
                    title: l10n.generalFontSize,
                    options: [
                      (value: 'standard', label: l10n.generalFontStandard),
                      (value: 'large', label: l10n.generalFontLarge),
                      (value: 'xlarge', label: l10n.generalFontXLarge),
                    ],
                    current: settings.fontSize,
                    onSelect: notifier.setFontSize,
                  )),
                ),
              ],
            ),

            // ── Card Settings ───────────────────────────────────────────────
            CupertinoListSection.insetGrouped(
              header: Text(l10n.generalCardSettings),
              children: [
                CupertinoListTile(
                  title: Text(l10n.generalAutoSaveContacts),
                  trailing: CupertinoSwitch(
                    value: settings.autoSaveToContacts,
                    onChanged: notifier.setAutoSaveToContacts,
                  ),
                ),
                CupertinoListTile(
                  title: Text(l10n.generalShowGroupOnSave),
                  trailing: CupertinoSwitch(
                    value: settings.showGroupOnSave,
                    onChanged: notifier.setShowGroupOnSave,
                  ),
                ),
                CupertinoListTile(
                  title: Text(l10n.generalSaveCardImage),
                  trailing: CupertinoSwitch(
                    value: settings.saveCardImage,
                    onChanged: notifier.setSaveCardImage,
                  ),
                ),
              ],
            ),

            // ── Name Format ─────────────────────────────────────────────────
            CupertinoListSection.insetGrouped(
              header: Text(l10n.generalNameFormat),
              children: [
                CupertinoListTile(
                  title: Text(l10n.generalSortOrder),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        orderLabel(settings.sortOrder),
                        style: TextStyle(
                            color: CupertinoColors.secondaryLabel.resolveFrom(context)),
                      ),
                      const SizedBox(width: 4),
                      const CupertinoListTileChevron(),
                    ],
                  ),
                  onTap: () => push(_OptionPage<String>(
                    title: l10n.generalSortOrder,
                    options: [
                      (value: 'first_last', label: l10n.generalFirstLast),
                      (value: 'last_first', label: l10n.generalLastFirst),
                    ],
                    current: settings.sortOrder,
                    onSelect: notifier.setSortOrder,
                  )),
                ),
                CupertinoListTile(
                  title: Text(l10n.generalDisplayOrder),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        orderLabel(settings.displayOrder),
                        style: TextStyle(
                            color: CupertinoColors.secondaryLabel.resolveFrom(context)),
                      ),
                      const SizedBox(width: 4),
                      const CupertinoListTileChevron(),
                    ],
                  ),
                  onTap: () => push(_OptionPage<String>(
                    title: l10n.generalDisplayOrder,
                    options: [
                      (value: 'first_last', label: l10n.generalFirstLast),
                      (value: 'last_first', label: l10n.generalLastFirst),
                    ],
                    current: settings.displayOrder,
                    onSelect: notifier.setDisplayOrder,
                  )),
                ),
              ],
            ),

            // ── Recognition Languages ───────────────────────────────────────
            CupertinoListSection.insetGrouped(
              header: Text(l10n.generalRecognitionLangs),
              children: [
                CupertinoListTile(
                  title: Text(l10n.generalRecognitionLangs),
                  subtitle: Text(
                    settings.recognitionLanguages
                        .map((c) => _langName(c, l10n))
                        .join(', '),
                  ),
                  trailing: const CupertinoListTileChevron(),
                  onTap: () => push(_RecognitionLanguagesPage(
                    selected: List.from(settings.recognitionLanguages),
                    onSave: notifier.setRecognitionLanguages,
                  )),
                ),
              ],
            ),

            // ── Storage ─────────────────────────────────────────────────────
            CupertinoListSection.insetGrouped(
              header: Text(l10n.generalStorageSection),
              children: [
                CupertinoListTile(
                  title: Text(l10n.generalClearSpace),
                  subtitle: cacheSize.value != null
                      ? Text(l10n.generalClearSpaceUsed(cacheSize.value!))
                      : null,
                  trailing: isClearing.value
                      ? const CupertinoActivityIndicator()
                      : const Icon(CupertinoIcons.delete),
                  onTap: isClearing.value ? null : clearCache,
                ),
                CupertinoListTile(
                  title: Text(l10n.generalAppVersion),
                  trailing: Text(
                    version.value ?? '…',
                    style: TextStyle(color: CupertinoColors.secondaryLabel.resolveFrom(context)),
                  ),
                ),
              ],
            ),

            // ── Security ────────────────────────────────────────────────────
            CupertinoListSection.insetGrouped(
              header: Text(l10n.generalSecurity),
              children: [
                CupertinoListTile(
                  title: Text(l10n.generalAppLock),
                  subtitle: Text(l10n.generalAppLockSubtitle),
                  trailing: CupertinoSwitch(
                    value: settings.appLock,
                    onChanged: notifier.setAppLock,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Generic Option Selection Page ────────────────────────────────────────────

class _OptionPage<T> extends StatelessWidget {
  const _OptionPage({
    required this.title,
    required this.options,
    required this.current,
    required this.onSelect,
  });

  final String title;
  final List<({T value, String label})> options;
  final T current;
  final Future<void> Function(T) onSelect;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: Text(title)),
      child: SafeArea(
        child: ListView(
          children: [
            CupertinoListSection.insetGrouped(
              children: options
                  .map((opt) => CupertinoListTile(
                        title: Text(opt.label),
                        trailing: opt.value == current
                            ? const Icon(CupertinoIcons.checkmark,
                                color: CupertinoColors.activeBlue, size: 18)
                            : null,
                        onTap: () {
                          onSelect(opt.value);
                          Navigator.of(context).pop();
                        },
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Recognition Languages Page ───────────────────────────────────────────────

class _RecognitionLanguagesPage extends HookWidget {
  const _RecognitionLanguagesPage({
    required this.selected,
    required this.onSave,
  });

  final List<String> selected;
  final Future<void> Function(List<String>) onSave;

  static const _allLanguages = [
    'en', 'tr', 'fr', 'de', 'es', 'it', 'pt',
    'nl', 'ru', 'ar', 'zh', 'ja', 'ko', 'hi',
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final picked = useState(List<String>.from(selected));

    void toggle(String code) {
      final list = List<String>.from(picked.value);
      if (list.contains(code)) {
        if (list.length > 1) list.remove(code);
      } else {
        list.add(code);
      }
      picked.value = list;
    }

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(l10n.generalRecognitionLangs),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            onSave(picked.value);
            Navigator.of(context).pop();
          },
          child: Text(l10n.commonSave),
        ),
      ),
      child: SafeArea(
        child: ListView(
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: CupertinoColors.systemYellow.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: CupertinoColors.systemYellow,
                  width: 1,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    CupertinoIcons.exclamationmark_triangle_fill,
                    color: CupertinoColors.systemYellow,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      l10n.generalRecognitionWarning,
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
            CupertinoListSection.insetGrouped(
              children: _allLanguages
                  .map((code) => CupertinoListTile(
                        title: Text(_langName(code, l10n)),
                        trailing: picked.value.contains(code)
                            ? const Icon(CupertinoIcons.checkmark,
                                color: CupertinoColors.activeBlue, size: 18)
                            : null,
                        onTap: () => toggle(code),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Helpers ──────────────────────────────────────────────────────────────────

String _langName(String code, AppLocalizations l10n) => switch (code) {
      'en' => l10n.langEn,
      'tr' => l10n.langTr,
      'fr' => l10n.langFr,
      'de' => l10n.langDe,
      'es' => l10n.langEs,
      'it' => l10n.langIt,
      'pt' => l10n.langPt,
      'nl' => l10n.langNl,
      'ru' => l10n.langRu,
      'ar' => l10n.langAr,
      'zh' => l10n.langZh,
      'ja' => l10n.langJa,
      'ko' => l10n.langKo,
      'hi' => l10n.langHi,
      _ => code,
    };

Future<String> _calcCacheSize() async {
  try {
    final tmp = await getTemporaryDirectory();
    int total = 0;
    await for (final e in tmp.list(recursive: true, followLinks: false)) {
      if (e is File) total += await e.length();
    }
    return _fmtBytes(total);
  } catch (_) {
    return '—';
  }
}

String _fmtBytes(int bytes) {
  if (bytes < 1024) return '$bytes B';
  if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
  return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
}

Future<void> _deleteDir(Directory dir) async {
  try {
    await for (final e in dir.list(recursive: false)) {
      if (e is File) {
        await e.delete();
      } else if (e is Directory) {
        await e.delete(recursive: true);
      }
    }
  } catch (_) {}
}
