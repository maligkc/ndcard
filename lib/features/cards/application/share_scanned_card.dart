import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:share_plus/share_plus.dart';

import '../../../core/domain/entities/scanned_card.dart';

String _escape(String input) {
  return input
      .replaceAll('\\', '\\\\')
      .replaceAll(',', '\\,')
      .replaceAll(';', '\\;')
      .replaceAll('\n', '\\n');
}

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

/// vCard 3.0 satır katlama — RFC 2426 uyumlu (maks 75 karakter/satır).
void _writeFoldedPhotoLine(StringBuffer buffer, Uint8List bytes) {
  final b64 = base64Encode(bytes);
  const header = 'PHOTO;ENCODING=b;TYPE=JPEG:';
  const maxFirst = 75 - header.length; // ilk satırda b64'ten kaç karakter
  const maxCont = 74; // devam satırlarında (1 boşluk + 74)

  buffer.write(header);
  if (b64.length <= maxFirst) {
    buffer.writeln(b64);
    return;
  }
  buffer.writeln(b64.substring(0, maxFirst));
  var pos = maxFirst;
  while (pos < b64.length) {
    final end = (pos + maxCont).clamp(0, b64.length);
    buffer
      ..write(' ')
      ..writeln(b64.substring(pos, end));
    pos = end;
  }
}

/// vCard metnini üretir; fotoğraf bytes varsa base64 olarak gömer.
/// [photoBytes] null ise PHOTO satırı eklenmez.
String buildScannedCardVCard(ScannedCard card, {Uint8List? photoBytes}) {
  final buffer = StringBuffer()
    ..writeln('BEGIN:VCARD')
    ..writeln('VERSION:3.0');

  final fullName = card.fullName ?? '';
  buffer
    ..writeln('N:;${_escape(fullName)};;;')
    ..writeln('FN:${_escape(fullName)}');

  if (card.company != null && card.company!.isNotEmpty) {
    buffer.writeln('ORG:${_escape(card.company!)};${_escape(card.department ?? '')}');
  }
  if (card.jobTitle != null && card.jobTitle!.isNotEmpty) {
    buffer.writeln('TITLE:${_escape(card.jobTitle!)}');
  }

  if (photoBytes != null) {
    _writeFoldedPhotoLine(buffer, photoBytes);
  }

  for (final field in card.fields) {
    final value = field.value.trim();
    if (value.isEmpty) continue;
    switch (field.fieldType) {
      case 'email':
        buffer.writeln('EMAIL;TYPE=INTERNET:${_escape(value)}');
        break;
      case 'mobile':
        buffer.writeln('TEL;TYPE=CELL:${_escape(value)}');
        break;
      case 'phone':
        buffer.writeln('TEL;TYPE=WORK:${_escape(value)}');
        break;
      case 'fax':
        buffer.writeln('TEL;TYPE=FAX:${_escape(value)}');
        break;
      case 'address':
        buffer.writeln('ADR;TYPE=WORK:;;${_escape(value)};;;;');
        break;
      default:
        buffer.writeln('URL:${_escape(value)}');
    }
  }

  buffer.writeln('END:VCARD');
  return buffer.toString();
}

Future<void> shareScannedCard(ScannedCard card) async {
  // Profil fotoğrafını tercih et, yoksa kartvizit fotoğrafını kullan.
  // base64 gömülü vCard çok daha uyumlu — alıcı URL'den indirme yapmak zorunda kalmaz.
  Uint8List? photoBytes;
  final photoUrl = card.profileImageUrl ?? card.frontImageUrl;
  if (photoUrl != null) {
    photoBytes = await _downloadBytes(photoUrl);
  }

  final vcard = buildScannedCardVCard(card, photoBytes: photoBytes);
  final file = XFile.fromData(
    Uint8List.fromList(utf8.encode(vcard)),
    name: '${card.fullName?.isNotEmpty == true ? card.fullName : 'kartvizit'}.vcf',
    mimeType: 'text/vcard',
  );
  await SharePlus.instance.share(ShareParams(files: [file]));
}
