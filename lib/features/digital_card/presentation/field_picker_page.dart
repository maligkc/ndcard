import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/utils/supported_platforms.dart';
import '../../../core/widgets/platform_icon.dart';
import '../../../l10n/gen/app_localizations.dart';

class FieldPickerPage extends HookConsumerWidget {
  const FieldPickerPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final query = useState('');
    final filtered = kSupportedPlatforms.where((p) {
      if (query.value.isEmpty) return true;
      final label = platformLabel(l10n, p).toLowerCase();
      return label.contains(query.value.toLowerCase());
    }).toList();

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: Text(l10n.fieldAdd)),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: CupertinoSearchTextField(
                placeholder: l10n.commonSearch,
                onChanged: (v) => query.value = v,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  final platform = filtered[index];
                  return CupertinoListTile(
                    leading: PlatformIcon(platform.key),
                    title: Text(platformLabel(l10n, platform)),
                    onTap: () => Navigator.of(context).pop(platform),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
