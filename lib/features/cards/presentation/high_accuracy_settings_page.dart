import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/utils/app_settings.dart';
import '../../../l10n/gen/app_localizations.dart';

class HighAccuracySettingsPage extends HookConsumerWidget {
  const HighAccuracySettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final enabled = useState<bool?>(null);

    useEffect(() {
      getHighAccuracyEnabled().then((value) {
        if (context.mounted) enabled.value = value;
      });
      return null;
    }, const []);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: Text(l10n.manageHighAccuracy)),
      child: SafeArea(
        child: enabled.value == null
            ? const Center(child: CupertinoActivityIndicator())
            : ListView(
                children: [
                  CupertinoListSection.insetGrouped(
                    footer: Text(l10n.highAccuracyDescription),
                    children: [
                      CupertinoListTile(
                        title: Text(l10n.manageHighAccuracy),
                        trailing: CupertinoSwitch(
                          value: enabled.value!,
                          onChanged: (v) async {
                            enabled.value = v;
                            await setHighAccuracyEnabled(v);
                          },
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
