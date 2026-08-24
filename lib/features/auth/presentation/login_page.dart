import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/widgets/error_dialog.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../application/auth_controller.dart';
import 'google_sign_in_button.dart';

class LoginPage extends HookConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final authState = ref.watch(authControllerProvider);
    final isLoading = authState.isLoading;

    ref.listen(authControllerProvider, (previous, next) {
      next.whenOrNull(error: (error, _) => showErrorDialog(context, error));
    });

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: Text(l10n.authLoginTitle)),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const SizedBox(height: 24),
            Center(
              child: Image.asset(
                'logo/ndcard-logo.png',
                width: 100,
                height: 100,
              ),
            ),
            const SizedBox(height: 32),
            CupertinoTextField(
              controller: emailController,
              placeholder: l10n.authEmail,
              keyboardType: TextInputType.emailAddress,
              autocorrect: false,
              padding: const EdgeInsets.all(14),
            ),
            const SizedBox(height: 12),
            CupertinoTextField(
              controller: passwordController,
              placeholder: l10n.authPassword,
              obscureText: true,
              padding: const EdgeInsets.all(14),
            ),
            const SizedBox(height: 20),
            CupertinoButton.filled(
              onPressed: isLoading
                  ? null
                  : () => ref.read(authControllerProvider.notifier).signIn(
                        email: emailController.text.trim(),
                        password: passwordController.text,
                      ),
              child: isLoading
                  ? const CupertinoActivityIndicator()
                  : Text(l10n.authLoginButton),
            ),
            const SizedBox(height: 12),
            GoogleSignInButton(
              isLoading: isLoading,
              onPressed: () => ref.read(authControllerProvider.notifier).signInWithGoogle(),
              label: l10n.authSignInWithGoogle,
            ),
            const SizedBox(height: 8),
            CupertinoButton(
              onPressed: () => context.push('/auth/forgot-password'),
              child: Text(l10n.authForgotPassword),
            ),
            CupertinoButton(
              onPressed: () => context.push('/auth/register'),
              child: Text(l10n.authNoAccount),
            ),
          ],
        ),
      ),
    );
  }
}
