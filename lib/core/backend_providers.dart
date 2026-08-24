import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'db/app_database.dart';
import 'db/sync/sync_engine.dart';
import 'domain/entities/auth_user.dart';
import 'domain/repositories/auth_repository.dart';
import 'domain/repositories/digital_card_repository.dart';
import 'domain/repositories/group_repository.dart';
import 'domain/repositories/note_repository.dart';
import 'domain/repositories/notification_repository.dart';
import 'domain/repositories/ocr_repository.dart';
import 'domain/repositories/scanned_card_repository.dart';
import 'domain/repositories/storage_repository.dart';
import 'supabase/supabase_auth_repository.dart';
import 'supabase/supabase_digital_card_repository.dart';
import 'supabase/supabase_group_repository.dart';
import 'supabase/supabase_note_repository.dart';
import 'supabase/supabase_notification_repository.dart';
import 'supabase/supabase_ocr_repository.dart';
import 'supabase/supabase_scanned_card_repository.dart';
import 'supabase/supabase_storage_repository.dart';

/// Backend değişimi (Supabase -> başka bir servis) yalnızca bu dosyadaki
/// implementasyon bağlamalarını değiştirmeyi gerektirir; UI ve iş mantığı
/// katmanı yalnızca `core/domain/repositories` altındaki arayüzleri bilir.

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

final syncEngineProvider = Provider<SyncEngine>((ref) {
  final engine = SyncEngine(ref.watch(appDatabaseProvider));
  engine.start();
  ref.onDispose(engine.dispose);
  return engine;
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return SupabaseAuthRepository();
});

final digitalCardRepositoryProvider = Provider<DigitalCardRepository>((ref) {
  return SupabaseDigitalCardRepository(
    ref.watch(appDatabaseProvider),
    ref.watch(syncEngineProvider),
  );
});

final scannedCardRepositoryProvider = Provider<ScannedCardRepository>((ref) {
  return SupabaseScannedCardRepository(
    ref.watch(appDatabaseProvider),
    ref.watch(syncEngineProvider),
  );
});

final groupRepositoryProvider = Provider<GroupRepository>((ref) {
  return SupabaseGroupRepository();
});

final noteRepositoryProvider = Provider<NoteRepository>((ref) {
  return SupabaseNoteRepository();
});

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  return SupabaseNotificationRepository();
});

final storageRepositoryProvider = Provider<StorageRepository>((ref) {
  return SupabaseStorageRepository();
});

final ocrRepositoryProvider = Provider<OcrRepository>((ref) {
  return SupabaseOcrRepository();
});

/// Router redirect ve genel oturum durumu için.
final authStateChangesProvider = StreamProvider<AuthUser?>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges;
});
