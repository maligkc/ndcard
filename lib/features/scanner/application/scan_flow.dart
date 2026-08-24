import 'dart:convert';
import 'dart:io';

import 'package:uuid/uuid.dart';

import '../../../core/domain/entities/scanned_card.dart';
import '../../../core/domain/repositories/ocr_repository.dart';
import '../../../core/domain/repositories/storage_repository.dart';
import '../../../core/utils/app_settings.dart';
import '../../../core/utils/image_compression.dart';

/// Taranan görüntüyü yükler, scan-card Edge Function'a gönderir ve
/// OCR sonucundan önceden doldurulmuş bir [ScannedCard] taslağı üretir.
/// Kaydetme işlemi bu fonksiyonda yapılmaz; kullanıcı düzenleme ekranında
/// kontrol edip Kaydet'e bastığında repository'ye yazılır.
///
/// Repository'ler doğrudan parametre olarak alınır (Riverpod'un `Ref`/
/// `WidgetRef` ayrımından bağımsız kalması için — bu fonksiyon hem widget
/// hem de Notifier bağlamından çağrılır).
Future<ScannedCard> runScanFlow({
  required StorageRepository storageRepository,
  required OcrRepository ocrRepository,
  required String userId,
  required File croppedImage,
  String language = 'tr',
}) async {
  final id = const Uuid().v4();
  final highAccuracy = await getHighAccuracyEnabled();
  final uploadFile = await compressForUpload(croppedImage, highAccuracy: highAccuracy);

  final frontUrl = await storageRepository.uploadFile(
    bucket: StorageBucket.cardImages,
    userId: userId,
    file: uploadFile,
    fileName: '$id-front.jpg',
  );

  final bytes = await uploadFile.readAsBytes();
  final imageBase64 = base64Encode(bytes);
  final ocrResult =
      await ocrRepository.scanCard(imageBase64: imageBase64, language: language);

  final fields = ocrResult.fields.map((f) {
    final address = f.addressDetail;
    return ScannedCardField(
      id: const Uuid().v4(),
      cardId: id,
      fieldType: f.fieldType,
      label: f.label,
      value: f.value,
      addressDetail: address == null
          ? null
          : AddressDetail(
              street: address['street'],
              city: address['city'],
              district: address['district'],
              postalCode: address['postal_code'],
              country: address['country'],
            ),
    );
  }).toList();

  return ScannedCard(
    id: id,
    userId: userId,
    frontImageUrl: frontUrl,
    fullName: ocrResult.fullName,
    company: ocrResult.company,
    department: ocrResult.department,
    jobTitle: ocrResult.jobTitle,
    rawOcr: const {},
    fields: fields,
  );
}
