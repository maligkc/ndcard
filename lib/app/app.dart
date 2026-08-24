import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:local_auth/local_auth.dart';

import '../core/backend_providers.dart';
import '../features/cards/application/notification_service.dart';
import '../l10n/gen/app_localizations.dart';
import 'general_settings_provider.dart';
import 'locale_provider.dart';
import 'router.dart';
import 'theme.dart';

class NDCardApp extends ConsumerWidget {
  const NDCardApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);
    final localeOverride = ref.watch(localeOverrideProvider);
    final locale = switch (localeOverride) {
      'tr' => const Locale('tr'),
      'en' => const Locale('en'),
      _ => null,
    };
    final settings = ref.watch(generalSettingsProvider);

    final brightness = switch (settings.theme) {
      'light' => Brightness.light,
      'dark' => Brightness.dark,
      _ => MediaQuery.platformBrightnessOf(context),
    };

    final fontScale = switch (settings.fontSize) {
      'large' => 1.15,
      'xlarge' => 1.30,
      _ => 1.0,
    };

    return CupertinoApp.router(
      title: 'NDCard',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.resolve(brightness),
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: router,
      builder: (context, child) {
        Widget content = fontScale == 1.0
            ? child!
            : MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(textScaler: TextScaler.linear(fontScale)),
                child: child!,
              );
        if (settings.appLock) {
          content = _AppLockWrapper(child: content);
        }
        return _ReminderChecker(child: content);
      },
    );
  }
}

// ─── Reminder Checker ─────────────────────────────────────────────────────────

/// Uygulama açılınca ve arka plandan dönünce zamanı gelen hatırlatıcıları
/// bildirim kutusuna ekler.
class _ReminderChecker extends ConsumerStatefulWidget {
  const _ReminderChecker({required this.child});
  final Widget child;

  @override
  ConsumerState<_ReminderChecker> createState() => _ReminderCheckerState();
}

class _ReminderCheckerState extends ConsumerState<_ReminderChecker>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _check());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _check();
  }

  Future<void> _check() async {
    final userId = ref.read(authStateChangesProvider).value?.id;
    if (userId == null) return;
    await checkDueReminders(ref, userId);
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

// ─── App Lock Overlay ─────────────────────────────────────────────────────────

class _AppLockWrapper extends StatefulWidget {
  const _AppLockWrapper({required this.child});
  final Widget child;

  @override
  State<_AppLockWrapper> createState() => _AppLockWrapperState();
}

class _AppLockWrapperState extends State<_AppLockWrapper>
    with WidgetsBindingObserver {
  final _auth = LocalAuthentication();
  bool _locked = true;
  bool _authenticating = false;
  AppLifecycleState? _prevState;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _authenticate());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed &&
        _prevState == AppLifecycleState.paused) {
      setState(() => _locked = true);
      _authenticate();
    }
    _prevState = state;
  }

  Future<void> _authenticate() async {
    if (_authenticating) return;
    _authenticating = true;
    try {
      final supported = await _auth.isDeviceSupported();
      if (!supported) {
        if (mounted) setState(() => _locked = false);
        return;
      }
      final success = await _auth.authenticate(
        localizedReason: 'Unlock NDCard',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false,
        ),
      );
      if (success && mounted) setState(() => _locked = false);
    } catch (_) {
      if (mounted) setState(() => _locked = false);
    } finally {
      _authenticating = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_locked) return widget.child;
    final l10n = AppLocalizations.of(context);
    return CupertinoPageScaffold(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(CupertinoIcons.lock_fill, size: 56),
            const SizedBox(height: 24),
            CupertinoButton.filled(
              onPressed: _authenticate,
              child: Text(l10n?.generalAppLockUnlock ?? 'Unlock'),
            ),
          ],
        ),
      ),
    );
  }
}
