import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../app/locale_provider.dart';
import '../../../l10n/gen/app_localizations.dart';

class LanguagePage extends ConsumerWidget {
  const LanguagePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final current = ref.watch(localeOverrideProvider);

    Widget row(String value, String label) {
      return CupertinoListTile(
        title: Text(label),
        trailing: current == value
            ? const Icon(CupertinoIcons.check_mark, color: CupertinoColors.activeBlue)
            : null,
        onTap: () => ref.read(localeOverrideProvider.notifier).setLocale(value),
      );
    }

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: Text(l10n.settingsLanguage)),
      child: SafeArea(
        child: ListView(
          children: [
            CupertinoListSection.insetGrouped(
              children: [
                row('system', l10n.languageSystem),
                row('tr', 'Türkçe'),
                row('en', 'English'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
