import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

bool get isBackendConfigured {
  final url = dotenv.env['SUPABASE_URL'];
  final anonKey = dotenv.env['SUPABASE_ANON_KEY'];
  return url != null && url.isNotEmpty && anonKey != null && anonKey.isNotEmpty;
}

Future<void> initSupabaseIfConfigured() async {
  if (!isBackendConfigured) return;
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );
}

SupabaseClient get supabaseClient => Supabase.instance.client;
