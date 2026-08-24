import 'package:app_settings/app_settings.dart';
import 'package:flutter/cupertino.dart';

import '../../../l10n/gen/app_localizations.dart';

class SystemPermissionsPage extends StatelessWidget {
  const SystemPermissionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: Text(l10n.settingsSystemPermissions)),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.systemPermissionsDescription),
              const SizedBox(height: 20),
              CupertinoButton.filled(
                onPressed: () => AppSettings.openAppSettings(),
                child: Text(l10n.systemPermissionsOpenSettings),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
