import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/widgets/error_dialog.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../application/auth_controller.dart';

class ForgotPasswordPage extends HookConsumerWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final emailController = useTextEditingController();
    final sent = useState(false);
    final authState = ref.watch(authControllerProvider);
    final isLoading = authState.isLoading;

    ref.listen(authControllerProvider, (previous, next) {
      next.when(
        data: (_) {
          if (previous is AsyncLoading) sent.value = true;
        },
        error: (error, _) => showErrorDialog(context, error),
        loading: () {},
      );
    });

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: Text(l10n.authResetPasswordTitle)),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const SizedBox(height: 24),
            Center(
              child: Image.asset(
                'logo/ndcard-logo.png',
                width: 80,
                height: 80,
              ),
            ),
            const SizedBox(height: 24),
            Text(l10n.authResetPasswordMessage),
            const SizedBox(height: 16),
            CupertinoTextField(
              controller: emailController,
              placeholder: l10n.authEmail,
              keyboardType: TextInputType.emailAddress,
              autocorrect: false,
              padding: const EdgeInsets.all(14),
            ),
            const SizedBox(height: 20),
            CupertinoButton.filled(
              onPressed: isLoading
                  ? null
                  : () => ref
                      .read(authControllerProvider.notifier)
                      .resetPassword(email: emailController.text.trim()),
              child: isLoading
                  ? const CupertinoActivityIndicator()
                  : Text(l10n.authResetPasswordButton),
            ),
            if (sent.value) ...[
              const SizedBox(height: 16),
              Text(
                l10n.authResetPasswordSent,
                textAlign: TextAlign.center,
                style: const TextStyle(color: CupertinoColors.activeGreen),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
