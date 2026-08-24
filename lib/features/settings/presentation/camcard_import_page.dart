import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/backend_providers.dart';
import '../../../core/widgets/error_dialog.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../../cards/application/vcf_import.dart';

class CamcardImportPage extends ConsumerStatefulWidget {
  const CamcardImportPage({super.key});

  @override
  ConsumerState<CamcardImportPage> createState() => _CamcardImportPageState();
}

class _CamcardImportPageState extends ConsumerState<CamcardImportPage> {
  bool _isLoading = false;

  Future<void> _import() async {
    final l10n = AppLocalizations.of(context)!;
    final userId = ref.read(authStateChangesProvider).value?.id;
    if (userId == null) return;

    setState(() => _isLoading = true);
    try {
      final count = await pickAndImportVcf(
        userId,
        ref.read(scannedCardRepositoryProvider),
        ref.read(storageRepositoryProvider),
      );
      if (!mounted) return;
      if (count == -1) return; // iptal
      if (count == 0) {
        await showErrorDialog(context, StateError(l10n.importVcfEmpty));
        return;
      }
      await showCupertinoDialog<void>(
        context: context,
        builder: (ctx) => CupertinoAlertDialog(
          title: Text(l10n.importSuccess(count)),
          actions: [
            CupertinoDialogAction(
              child: Text(l10n.commonOk),
              onPressed: () => Navigator.of(ctx).pop(),
            ),
          ],
        ),
      );
    } catch (e) {
      if (mounted) await showErrorDialog(context, e);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: Text(l10n.camcardImportTitle)),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              l10n.camcardImportDescription,
              style: const TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 24),
            CupertinoListSection.insetGrouped(
              children: [
                _StepTile(l10n.camcardImportStep1),
                _StepTile(l10n.camcardImportStep2),
                _StepTile(l10n.camcardImportStep3),
                _StepTile(l10n.camcardImportStep4),
              ],
            ),
            const SizedBox(height: 8),
            CupertinoButton.filled(
              onPressed: _isLoading ? null : _import,
              child: _isLoading
                  ? const CupertinoActivityIndicator()
                  : Text(l10n.camcardImportButton),
            ),
          ],
        ),
      ),
    );
  }
}

class _StepTile extends StatelessWidget {
  const _StepTile(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return CupertinoListTile(
      title: Text(text, style: const TextStyle(fontSize: 14)),
    );
  }
}
