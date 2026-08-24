import 'dart:io';
import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart' as sb;

import '../domain/repositories/storage_repository.dart';
import 'supabase_client_provider.dart';

String _bucketName(StorageBucket bucket) {
  switch (bucket) {
    case StorageBucket.cardImages:
      return 'card-images';
    case StorageBucket.avatars:
      return 'avatars';
  }
}

/// Görsel ölçekleme/sıkıştırma politikası (§9: max 1600px, JPEG %85,
/// yüksek doğrulukta atlanır) çağıran taraf (tarama/kart düzenleme akışı)
/// tarafından uygulanır; bu repository ham dosyayı yükler.
class SupabaseStorageRepository implements StorageRepository {
  @override
  Future<String> uploadFile({
    required StorageBucket bucket,
    required String userId,
    required File file,
    required String fileName,
  }) async {
    final bucketName = _bucketName(bucket);
    final path = '$userId/$fileName';
    await supabaseClient.storage.from(bucketName).upload(
          path,
          file,
          fileOptions: const sb.FileOptions(upsert: true),
        );
    return supabaseClient.storage.from(bucketName).getPublicUrl(path);
  }

  @override
  Future<String> uploadBytes({
    required StorageBucket bucket,
    required String userId,
    required Uint8List bytes,
    required String fileName,
    String contentType = 'image/jpeg',
  }) async {
    final bucketName = _bucketName(bucket);
    final path = '$userId/$fileName';
    await supabaseClient.storage.from(bucketName).uploadBinary(
          path,
          bytes,
          fileOptions: sb.FileOptions(upsert: true, contentType: contentType),
        );
    return supabaseClient.storage.from(bucketName).getPublicUrl(path);
  }

  @override
  Future<void> deleteFile({required StorageBucket bucket, required String path}) async {
    await supabaseClient.storage.from(_bucketName(bucket)).remove([path]);
  }
}
