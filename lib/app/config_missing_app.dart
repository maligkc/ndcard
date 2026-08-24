import 'package:flutter/cupertino.dart';

import '../l10n/gen/app_localizations.dart';
import 'theme.dart';

/// SUPABASE_URL / SUPABASE_ANON_KEY .env içinde boşsa gösterilir.
/// Ana uygulama (auth, backend, router) hiç kurulmaz; kullanıcı .env'i
/// doldurup uygulamayı yeniden başlatana kadar bu ekran kalır.
class ConfigMissingApp extends StatelessWidget {
  const ConfigMissingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'NDCard',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Builder(
        builder: (context) {
          final l10n = AppLocalizations.of(context)!;
          return CupertinoPageScaffold(
            child: SafeArea(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        CupertinoIcons.exclamationmark_triangle,
                        size: 56,
                        color: CupertinoColors.systemOrange,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        l10n.configMissingTitle,
                        textAlign: TextAlign.center,
                        style: CupertinoTheme.of(context).textTheme.navTitleTextStyle,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.configMissingMessage,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: CupertinoColors.secondaryLabel),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
