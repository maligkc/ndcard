import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/backend_providers.dart';
import '../../../core/utils/sync_settings.dart';
import '../../../core/widgets/error_dialog.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../../auth/application/auth_controller.dart';
import '../../cards/application/scanned_cards_provider.dart';
import '../../digital_card/application/digital_card_providers.dart';

class AccountSyncPage extends HookConsumerWidget {
  const AccountSyncPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final lastSync = useState<DateTime?>(null);
    final isSyncing = useState(false);
    final loadedOnce = useState(false);
    // auth state değişince identities yenilenir
    ref.watch(authStateChangesProvider);

    if (!loadedOnce.value) {
      loadedOnce.value = true;
      getLastSyncAt().then((value) {
        if (context.mounted) lastSync.value = value;
      });
    }

    Future<void> syncNow() async {
      isSyncing.value = true;
      try {
        await ref.read(syncEngineProvider).syncNow();
        final userId = ref.read(authStateChangesProvider).value?.id;
        if (userId != null) {
          await ref.read(scannedCardRepositoryProvider).pullNow(userId);
        }
        ref.invalidate(digitalCardsProvider);
        ref.invalidate(scannedCardsProvider);
        await setLastSyncAtNow();
        lastSync.value = DateTime.now();
      } catch (e) {
        if (context.mounted) await showErrorDialog(context, e);
      } finally {
        isSyncing.value = false;
      }
    }

    Future<void> deleteAccount() async {
      final confirmed = await showCupertinoDialog<bool>(
        context: context,
        builder: (ctx) => CupertinoAlertDialog(
          title: Text(l10n.accountDeleteTitle),
          content: Text(l10n.accountDeleteMessage),
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
      if (confirmed != true) return;
      try {
        await ref.read(authRepositoryProvider).deleteAccount();
        if (context.mounted) context.go('/auth/login');
      } catch (e) {
        if (context.mounted) await showErrorDialog(context, e);
      }
    }

    Future<void> signOut() async {
      try {
        await ref.read(authControllerProvider.notifier).signOut();
        if (context.mounted) context.go('/auth/login');
      } catch (e) {
        if (context.mounted) await showErrorDialog(context, e);
      }
    }

    final repo = ref.read(authRepositoryProvider);
    final identities = repo.linkedIdentities;
    final linkedProviders = identities.map((i) => i.provider).toSet();

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: Text(l10n.settingsAccountSync)),
      child: SafeArea(
        child: ListView(
          children: [
            CupertinoListSection.insetGrouped(
              header: Text(l10n.accountLinkProviders),
              children: [
                _ProviderTile(
                  label: l10n.accountLinkEmail,
                  icon: const Icon(CupertinoIcons.mail_solid, size: 22),
                  isLinked: linkedProviders.contains('email'),
                  identityId: identities.where((i) => i.provider == 'email').firstOrNull?.id,
                  onLink: () async => _showEmailSheet(context, ref, l10n),
                  onUnlink: (id) => _unlink(context, ref, l10n, id),
                ),
                _ProviderTile(
                  label: 'Google',
                  icon: const _GoogleIcon(),
                  isLinked: linkedProviders.contains('google'),
                  identityId: identities.where((i) => i.provider == 'google').firstOrNull?.id,
                  onLink: () => _linkOAuth(context, ref, l10n, 'google'),
                  onUnlink: (id) => _unlink(context, ref, l10n, id),
                ),
                _ProviderTile(
                  label: 'LinkedIn',
                  icon: const _LinkedInIcon(),
                  isLinked: linkedProviders.contains('linkedin_oidc'),
                  identityId:
                      identities.where((i) => i.provider == 'linkedin_oidc').firstOrNull?.id,
                  onLink: () => _linkOAuth(context, ref, l10n, 'linkedin_oidc'),
                  onUnlink: (id) => _unlink(context, ref, l10n, id),
                ),
              ],
            ),
            CupertinoListSection.insetGrouped(
              children: [
                CupertinoListTile(
                  title: Text(l10n.accountSyncCards),
                  subtitle: Text(
                    lastSync.value == null
                        ? l10n.accountNeverSynced
                        : l10n.accountLastSynced(lastSync.value!.toString()),
                  ),
                  trailing: isSyncing.value
                      ? const CupertinoActivityIndicator()
                      : const Icon(CupertinoIcons.refresh),
                  onTap: isSyncing.value ? null : syncNow,
                ),
              ],
            ),
            CupertinoListSection.insetGrouped(
              header: Text(l10n.accountManagement),
              children: [
                CupertinoListTile(
                  title: Text(
                    l10n.accountDeleteTitle,
                    style: const TextStyle(color: CupertinoColors.destructiveRed),
                  ),
                  onTap: deleteAccount,
                ),
              ],
            ),
            CupertinoListSection.insetGrouped(
              children: [
                CupertinoListTile(
                  title: Text(
                    l10n.settingsSignOut,
                    style: const TextStyle(color: CupertinoColors.destructiveRed),
                  ),
                  onTap: signOut,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _linkOAuth(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    String provider,
  ) async {
    try {
      await ref.read(authRepositoryProvider).linkOAuthProvider(provider);
      await ref.read(authRepositoryProvider).refreshSession();
      if (!context.mounted) return;
      // Gerçekten bağlandığını doğrula — kullanıcı giriş yapmadan çıkmış olabilir.
      final isLinked = ref
          .read(authRepositoryProvider)
          .linkedIdentities
          .any((i) => i.provider == provider);
      if (isLinked) {
        _showSuccess(context, l10n.accountLinkSuccess);
      }
      // Bağlanmadıysa kullanıcı iptal etti, sessizce geçiyoruz.
    } catch (e) {
      if (context.mounted) await showErrorDialog(context, e);
    }
  }

  Future<void> _unlink(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    String identityId,
  ) async {
    final repo = ref.read(authRepositoryProvider);
    if (repo.linkedIdentities.length <= 1) {
      await showErrorDialog(context, StateError(l10n.accountUnlinkLastError));
      return;
    }
    final confirmed = await showCupertinoDialog<bool>(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: Text(l10n.accountUnlinkConfirmTitle),
        content: Text(l10n.accountUnlinkConfirmMessage),
        actions: [
          CupertinoDialogAction(
            child: Text(l10n.commonCancel),
            onPressed: () => Navigator.of(ctx).pop(false),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: Text(l10n.accountUnlink),
            onPressed: () => Navigator.of(ctx).pop(true),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    try {
      await repo.unlinkIdentity(identityId);
      await repo.refreshSession();
    } catch (e) {
      if (context.mounted) await showErrorDialog(context, e);
    }
  }

  void _showSuccess(BuildContext context, String message) {
    showCupertinoDialog<void>(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        content: Text(message),
        actions: [
          CupertinoDialogAction(
            child: const Text('Tamam'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
        ],
      ),
    );
  }

  void _showEmailSheet(BuildContext context, WidgetRef ref, AppLocalizations l10n) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (_) => _EmailLinkSheet(ref: ref, l10n: l10n),
    );
  }
}

// ─── Provider Tile ────────────────────────────────────────────────────────────

class _ProviderTile extends StatefulWidget {
  const _ProviderTile({
    required this.label,
    required this.icon,
    required this.isLinked,
    required this.identityId,
    required this.onLink,
    required this.onUnlink,
  });

  final String label;
  final Widget icon;
  final bool isLinked;
  final String? identityId;
  final Future<void> Function() onLink;
  final Future<void> Function(String id) onUnlink;

  @override
  State<_ProviderTile> createState() => _ProviderTileState();
}

class _ProviderTileState extends State<_ProviderTile> {
  bool _loading = false;

  Future<void> _handle(Future<void> Function() action) async {
    setState(() => _loading = true);
    try {
      await action();
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoListTile(
      leading: widget.icon,
      title: Text(widget.label),
      trailing: _loading
          ? const CupertinoActivityIndicator()
          : widget.isLinked
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Bağlı',
                      style: TextStyle(
                        color: CupertinoColors.systemGreen.resolveFrom(context),
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(width: 8),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      minSize: 0,
                      onPressed: () => _handle(() => widget.onUnlink(widget.identityId!)),
                      child: Text(
                        'Kaldır',
                        style: TextStyle(
                          color: CupertinoColors.destructiveRed.resolveFrom(context),
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                )
              : CupertinoButton(
                  padding: EdgeInsets.zero,
                  minSize: 0,
                  onPressed: () => _handle(widget.onLink),
                  child: const Text('Bağla', style: TextStyle(fontSize: 14)),
                ),
    );
  }
}

// ─── Email Link Sheet ─────────────────────────────────────────────────────────

class _EmailLinkSheet extends HookWidget {
  const _EmailLinkSheet({required this.ref, required this.l10n});

  final WidgetRef ref;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final loading = useState(false);

    Future<void> link() async {
      loading.value = true;
      try {
        await ref.read(authRepositoryProvider).linkEmail(
              email: emailController.text.trim(),
              password: passwordController.text,
            );
        await ref.read(authRepositoryProvider).refreshSession();
        if (context.mounted) Navigator.of(context).pop();
      } catch (e) {
        if (context.mounted) await showErrorDialog(context, e);
      } finally {
        loading.value = false;
      }
    }

    return CupertinoActionSheet(
      title: Text(l10n.accountLinkEmail),
      message: Column(
        children: [
          CupertinoTextField(
            controller: emailController,
            placeholder: l10n.authEmail,
            keyboardType: TextInputType.emailAddress,
            autocorrect: false,
            padding: const EdgeInsets.all(12),
          ),
          const SizedBox(height: 8),
          CupertinoTextField(
            controller: passwordController,
            placeholder: l10n.accountLinkEmailPassword,
            obscureText: true,
            padding: const EdgeInsets.all(12),
          ),
        ],
      ),
      actions: [
        CupertinoActionSheetAction(
          onPressed: () { if (!loading.value) link(); },
          child: loading.value
              ? const CupertinoActivityIndicator()
              : Text(l10n.accountLinkEmailConfirm),
        ),
      ],
      cancelButton: CupertinoActionSheetAction(
        isDestructiveAction: true,
        onPressed: () => Navigator.of(context).pop(),
        child: Text(l10n.commonCancel),
      ),
    );
  }
}

// ─── Brand Icons ──────────────────────────────────────────────────────────────

class _GoogleIcon extends StatelessWidget {
  const _GoogleIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFF4285F4),
      ),
      alignment: Alignment.center,
      child: const Text(
        'G',
        style: TextStyle(
          color: CupertinoColors.white,
          fontSize: 14,
          fontWeight: FontWeight.bold,
          height: 1,
        ),
      ),
    );
  }
}

class _LinkedInIcon extends StatelessWidget {
  const _LinkedInIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: const Color(0xFF0A66C2),
      ),
      alignment: Alignment.center,
      child: const Text(
        'in',
        style: TextStyle(
          color: CupertinoColors.white,
          fontSize: 13,
          fontWeight: FontWeight.bold,
          height: 1,
        ),
      ),
    );
  }
}
