import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:share_plus/share_plus.dart';

import '../../../core/domain/entities/digital_card.dart';
import '../../../core/utils/vcard_builder.dart';

/// URL'den ham byte'ları indirir; hata durumunda null döner.
Future<Uint8List?> _downloadBytes(String url) async {
  try {
    final client = HttpClient();
    final request = await client.getUrl(Uri.parse(url));
    final response = await request.close();
    client.close();
    if (response.statusCode != 200) return null;
    final chunks = <List<int>>[];
    await for (final chunk in response) {
      chunks.add(chunk);
    }
    return Uint8List.fromList(chunks.expand((x) => x).toList());
  } catch (_) {
    return null;
  }
}

Future<void> shareDigitalCardAsVCard(DigitalCard card) async {
  // Fotoğrafı paylaşmadan önce indir; base64 gömülü vCard çok daha uyumlu.
  Uint8List? photoBytes;
  if (card.photoUrl != null && card.photoUrl!.isNotEmpty) {
    photoBytes = await _downloadBytes(card.photoUrl!);
  }

  final vcard = buildVCard(card, photoBytes: photoBytes);
  final file = XFile.fromData(
    Uint8List.fromList(utf8.encode(vcard)),
    name: '${card.fullName.isEmpty ? 'kartvizit' : card.fullName}.vcf',
    mimeType: 'text/vcard',
  );
  await SharePlus.instance.share(ShareParams(files: [file]));
}
