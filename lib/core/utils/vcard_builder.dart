import 'dart:convert';
import 'dart:typed_data';

import '../domain/entities/digital_card.dart';
import 'supported_platforms.dart';

/// vCard 3.0 metnini elle üretir (paket bağımlılığı yerine tam kontrol için).
///
/// [photoBytes] sağlanırsa fotoğraf base64 olarak gömülür (PHOTO;ENCODING=b).
/// Yoksa fotoğraf alanı hiç eklenmez — alıcı uygulama URI'den indirme yapmaz.
String buildVCard(DigitalCard card, {Uint8List? photoBytes}) {
  final buffer = StringBuffer()
    ..writeln('BEGIN:VCARD')
    ..writeln('VERSION:3.0')
    ..writeln('N:${_escape(card.lastName)};${_escape(card.firstName)};;;')
    ..writeln('FN:${_escape(card.fullName)}');

  if (card.company != null && card.company!.isNotEmpty) {
    final department = card.department ?? '';
    buffer.writeln('ORG:${_escape(card.company!)};${_escape(department)}');
  }
  if (card.jobTitle != null && card.jobTitle!.isNotEmpty) {
    buffer.writeln('TITLE:${_escape(card.jobTitle!)}');
  }

  if (photoBytes != null) {
    _writeFoldedPhotoLine(buffer, photoBytes);
  }

  for (final field in card.fields) {
    final platform = platformByKey(field.platform);
    final value = field.value.trim();
    if (value.isEmpty) continue;
    switch (platform.vcardType) {
      case 'EMAIL':
        buffer.writeln('EMAIL;TYPE=INTERNET:${_escape(value)}');
        break;
      case 'TEL':
        final type = platform.vcardTypeLabel ?? 'VOICE';
        buffer.writeln('TEL;TYPE=$type:${_escape(value)}');
        break;
      case 'ADR':
        buffer.writeln('ADR;TYPE=WORK:;;${_escape(value)};;;;');
        break;
      default:
        final resolved = _resolveUrl(platform, value);
        final label = field.label.isNotEmpty
            ? field.label.toUpperCase()
            : (platform.vcardTypeLabel ?? platform.fallbackName.toUpperCase());
        buffer.writeln('URL;TYPE=$label:${_escape(resolved)}');
    }
  }

  buffer.writeln('END:VCARD');
  return buffer.toString();
}

/// vCard 3.0 satır katlama — RFC 2426 uyumlu (maks 75 karakter/satır).
void _writeFoldedPhotoLine(StringBuffer buffer, Uint8List bytes) {
  final b64 = base64Encode(bytes);
  const header = 'PHOTO;ENCODING=b;TYPE=JPEG:';
  const maxFirst = 75 - header.length;
  const maxCont = 74;

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

String _resolveUrl(SupportedPlatform platform, String value) {
  if (value.startsWith('http://') || value.startsWith('https://')) return value;
  if (platform.urlTemplate != null) {
    return platform.urlTemplate!.replaceFirst('{value}', value);
  }
  return value;
}

String _escape(String input) {
  return input
      .replaceAll('\\', '\\\\')
      .replaceAll(',', '\\,')
      .replaceAll(';', '\\;')
      .replaceAll('\n', '\\n');
}
