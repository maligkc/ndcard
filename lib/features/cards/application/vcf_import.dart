import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';

import '../../../core/domain/entities/scanned_card.dart';
import '../../../core/domain/repositories/scanned_card_repository.dart';
import '../../../core/domain/repositories/storage_repository.dart';
import '../../../core/utils/vcard_parser.dart';
import '../../scanner/application/qr_handler.dart';

/// VCF dosyasını seçer, ayrıştırır ve tüm kartları toplu olarak kaydeder.
/// Başarıyla kaydedilen kart sayısını döner; kullanıcı iptal ederse -1 döner.
///
/// CamCard'dan gelen fotoğraflar (base64 PHOTO alanı) Supabase storage'a
/// yüklenir ve gerçek URL olarak saklanır.
Future<int> pickAndImportVcf(
  String userId,
  ScannedCardRepository repo,
  StorageRepository storageRepo,
) async {
  final result = await FilePicker.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['vcf'],
  );
  if (result == null || result.files.isEmpty) return -1;

  final path = result.files.first.path;
  if (path == null) return -1;

  final content = await File(path).readAsString();
  final vcards = splitVCards(content);
  if (vcards.isEmpty) return 0;

  final cards = <ScannedCard>[];

  for (final vcard in vcards) {
    var card = buildScannedCardFromVCardText(userId, vcard);

    // VCF'deki base64 fotoğrafı Supabase storage'a yükle.
    final photoData = card.frontImageUrl;
    if (photoData != null && photoData.startsWith('data:')) {
      String? uploadedUrl;
      try {
        final commaIdx = photoData.indexOf(',');
        if (commaIdx != -1) {
          final bytes = base64Decode(photoData.substring(commaIdx + 1));
          final isPng = photoData.startsWith('data:image/png');
          final ext = isPng ? 'png' : 'jpg';
          final contentType = isPng ? 'image/png' : 'image/jpeg';
          uploadedUrl = await storageRepo.uploadBytes(
            bucket: StorageBucket.cardImages,
            userId: userId,
            bytes: bytes,
            fileName: '${card.id}_front.$ext',
            contentType: contentType,
          );
        }
      } catch (_) {
        // Yükleme başarısız → fotoğrafsız kaydet
      }

      // data URI yerine gerçek URL'i (veya null) kullan
      card = ScannedCard(
        id: card.id,
        userId: card.userId,
        frontImageUrl: uploadedUrl,
        fullName: card.fullName,
        company: card.company,
        department: card.department,
        jobTitle: card.jobTitle,
        fields: card.fields,
      );
    }

    cards.add(card);
  }

  // Tek transaction + tek ağ isteği — 9000 kart için ~1s vs eskiden ~9000s.
  await repo.saveCards(cards);
  return cards.length;
}
