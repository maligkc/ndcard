import '../domain/entities/scanned_card.dart';

class ParsedVCard {
  const ParsedVCard({
    this.fullName,
    this.company,
    this.jobTitle,
    this.photoUrl,
    this.fields = const [],
  });

  final String? fullName;
  final String? company;
  final String? jobTitle;

  /// URI veya `data:image/jpeg;base64,...` formatında olabilir.
  /// Null ise fotoğraf yok.
  final String? photoUrl;

  final List<ScannedCardField> fields;
}

String _unescape(String value) {
  return value
      .replaceAll(r'\n', '\n')
      .replaceAll(r'\,', ',')
      .replaceAll(r'\;', ';')
      .replaceAll(r'\\', '\\');
}

/// vCard satır katlamayı açar.
/// RFC 6350: Boşluk veya tab ile başlayan satır bir önceki satırın devamıdır.
String _unfoldLines(String text) {
  return text.replaceAll(RegExp(r'\r\n[ \t]|\n[ \t]|\r[ \t]'), '');
}

/// Bir VCF dosyasındaki birden fazla vCard bloğunu ayrıştırır.
List<String> splitVCards(String text) {
  final result = <String>[];
  final regex = RegExp(r'BEGIN:VCARD[\s\S]*?END:VCARD', caseSensitive: false);
  for (final match in regex.allMatches(text)) {
    result.add(match.group(0)!);
  }
  return result;
}

/// QR'dan veya VCF'den okunan vCard 2.1/3.0 metnini ayrıştırır.
/// N/FN, ORG, TITLE, TEL, EMAIL, ADR, URL ve PHOTO alanlarını destekler.
ParsedVCard parseVCard(String text) {
  // Satır katlamayı aç; CamCard ve bazı uygulamalar uzun alanları katlar.
  final unfolded = _unfoldLines(text);
  final lines = unfolded.split(RegExp(r'\r\n|\n|\r'));

  String? fullName;
  String? company;
  String? jobTitle;
  String? photoUrl;
  final fields = <ScannedCardField>[];
  var index = 0;

  for (final rawLine in lines) {
    final line = rawLine.trim();
    if (line.isEmpty) continue;
    final colonIndex = line.indexOf(':');
    if (colonIndex == -1) continue;
    final keyPart = line.substring(0, colonIndex);
    final value = _unescape(line.substring(colonIndex + 1));
    final keySegments = keyPart.split(';');
    final key = keySegments.first.toUpperCase();
    final params = keySegments.skip(1).map((s) => s.toUpperCase()).toList();

    switch (key) {
      case 'FN':
        fullName = value;
        break;
      case 'N':
        if (fullName == null) {
          final parts = value.split(';');
          final last = parts.isNotEmpty ? parts[0] : '';
          final first = parts.length > 1 ? parts[1] : '';
          fullName = '$first $last'.trim();
        }
        break;
      case 'ORG':
        company = value.split(';').first;
        break;
      case 'TITLE':
        jobTitle = value;
        break;
      case 'PHOTO':
        final isUri = params.any((p) => p == 'VALUE=URI' || p.startsWith('VALUE=URI'));
        if (isUri) {
          // Doğrudan URL — frontImageUrl olarak kullanılabilir.
          final uri = value.trim();
          if (uri.isNotEmpty) photoUrl = uri;
        } else {
          // Base64 gömülü fotoğraf (CamCard varsayılanı).
          // MIME tipini belirle (TYPE= parametresinden).
          String mimeType = 'image/jpeg';
          for (final p in params) {
            if (p.startsWith('TYPE=')) {
              final type = p.substring(5).toLowerCase();
              if (type == 'png') mimeType = 'image/png';
              if (type == 'gif') mimeType = 'image/gif';
            }
          }
          // Olası boşlukları temizle; base64 verisinin içinde olmamalı.
          final cleaned = value.replaceAll(RegExp(r'\s'), '');
          if (cleaned.isNotEmpty) {
            photoUrl = 'data:$mimeType;base64,$cleaned';
          }
        }
        break;
      case 'TEL':
        final isMobile = params.any((p) => p.contains('CELL'));
        final isFax = params.any((p) => p.contains('FAX'));
        fields.add(ScannedCardField(
          id: 'vcard-${index++}',
          cardId: '',
          fieldType: isFax ? 'fax' : (isMobile ? 'mobile' : 'phone'),
          label: '',
          value: value,
        ));
        break;
      case 'EMAIL':
        fields.add(ScannedCardField(
          id: 'vcard-${index++}',
          cardId: '',
          fieldType: 'email',
          label: '',
          value: value,
        ));
        break;
      case 'ADR':
        final parts = value.split(';');
        final street = parts.length > 2 ? parts[2] : '';
        final city = parts.length > 3 ? parts[3] : '';
        fields.add(ScannedCardField(
          id: 'vcard-${index++}',
          cardId: '',
          fieldType: 'address',
          label: '',
          value: value.replaceAll(';', ' ').trim(),
          addressDetail: AddressDetail(street: street, city: city),
        ));
        break;
      case 'URL':
        fields.add(ScannedCardField(
          id: 'vcard-${index++}',
          cardId: '',
          fieldType: 'url',
          label: '',
          value: value,
        ));
        break;
    }
  }

  return ParsedVCard(
    fullName: fullName,
    company: company,
    jobTitle: jobTitle,
    photoUrl: photoUrl,
    fields: fields,
  );
}
