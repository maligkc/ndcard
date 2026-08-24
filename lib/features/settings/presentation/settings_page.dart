import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/backend_providers.dart';
import '../../../l10n/gen/app_localizations.dart';
import 'account_page.dart';
import 'account_sync_page.dart';
import 'camcard_import_page.dart';
import 'coming_soon_page.dart';
import 'general_page.dart';
import 'language_page.dart';
import 'notifications_settings_page.dart';
import 'system_permissions_page.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  void _push(BuildContext context, Widget page) {
    Navigator.of(context).push(CupertinoPageRoute<void>(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final user = ref.watch(authStateChangesProvider).value;

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: Text(l10n.tabSettings)),
      child: SafeArea(
        child: ListView(
          children: [
            CupertinoListSection.insetGrouped(
              header: Text(l10n.settingsAccount),
              children: [
                CupertinoListTile(
                  leading: const Icon(CupertinoIcons.person_crop_circle),
                  title: Text(user?.email ?? l10n.settingsAccount),
                  trailing: const CupertinoListTileChevron(),
                  onTap: () => _push(context, const AccountPage()),
                ),
              ],
            ),
            CupertinoListSection.insetGrouped(
              children: [
                CupertinoListTile(
                  leading: const Icon(CupertinoIcons.square_arrow_down),
                  title: Text(l10n.settingsImportFromCamcard),
                  trailing: const CupertinoListTileChevron(),
                  onTap: () => _push(context, const CamcardImportPage()),
                ),
              ],
            ),
            CupertinoListSection.insetGrouped(
              header: Text(l10n.settingsAppSettings),
              children: [
                CupertinoListTile(
                  title: Text(l10n.settingsAccountSync),
                  trailing: const CupertinoListTileChevron(),
                  onTap: () => _push(context, const AccountSyncPage()),
                ),
                CupertinoListTile(
                  title: Text(l10n.settingsGeneral),
                  trailing: const CupertinoListTileChevron(),
                  onTap: () => _push(context, const GeneralPage()),
                ),
                CupertinoListTile(
                  title: Text(l10n.settingsLanguage),
                  trailing: const CupertinoListTileChevron(),
                  onTap: () => _push(context, const LanguagePage()),
                ),
                CupertinoListTile(
                  title: Text(l10n.settingsNotifications),
                  trailing: const CupertinoListTileChevron(),
                  onTap: () => _push(context, const NotificationsSettingsPage()),
                ),
                CupertinoListTile(
                  title: Text(l10n.settingsPrivacy),
                  trailing: const CupertinoListTileChevron(),
                  onTap: () => _push(context, ComingSoonPage(title: l10n.settingsPrivacy)),
                ),
                CupertinoListTile(
                  title: Text(l10n.settingsSystemPermissions),
                  trailing: const CupertinoListTileChevron(),
                  onTap: () => _push(context, const SystemPermissionsPage()),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Center(
              child: Image.asset(
                'logo/nd-group-logo.png',
                width: 72,
                height: 72,
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
