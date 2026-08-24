import 'dart:io';
import 'dart:typed_data';

enum StorageBucket { cardImages, avatars }

abstract interface class StorageRepository {
  /// Dosyayı `{userId}/...` altına yükler, herkese açık URL döner.
  Future<String> uploadFile({
    required StorageBucket bucket,
    required String userId,
    required File file,
    required String fileName,
  });

  /// Ham byte'lardan yükler; VCF'den çıkarılan base64 fotoğraflar için.
  Future<String> uploadBytes({
    required StorageBucket bucket,
    required String userId,
    required Uint8List bytes,
    required String fileName,
    String contentType = 'image/jpeg',
  });

  Future<void> deleteFile({required StorageBucket bucket, required String path});
}
