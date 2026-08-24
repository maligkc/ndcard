import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'app/app.dart';
import 'app/config_missing_app.dart';
import 'core/supabase/supabase_client_provider.dart';
import 'features/cards/application/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await initSupabaseIfConfigured();
  await initNotifications();

  runApp(
    ProviderScope(
      child: isBackendConfigured ? const NDCardApp() : const ConfigMissingApp(),
    ),
  );
}
