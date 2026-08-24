import 'dart:convert';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../core/domain/entities/scanned_card.dart';
import 'contacts_helper.dart';
import 'share_scanned_card.dart';

String _csvEscape(String value) {
  if (value.contains(',') || value.contains('"') || value.contains('\n')) {
    return '"${value.replaceAll('"', '""')}"';
  }
  return value;
}

String _fieldValue(ScannedCard card, String type) {
  final match = card.fields.where((f) => f.fieldType == type);
  return match.isEmpty ? '' : match.first.value;
}

String buildCardsCsv(List<ScannedCard> cards) {
  final buffer = StringBuffer()
    ..writeln('Ad Soyad,Şirket,Departman,Unvan,Telefon,E-posta,Adres');
  for (final card in cards) {
    final row = [
      card.fullName ?? '',
      card.company ?? '',
      card.department ?? '',
      card.jobTitle ?? '',
      _fieldValue(card, 'mobile').isNotEmpty ? _fieldValue(card, 'mobile') : _fieldValue(card, 'phone'),
      _fieldValue(card, 'email'),
      _fieldValue(card, 'address'),
    ].map(_csvEscape).join(',');
    buffer.writeln(row);
  }
  return buffer.toString();
}

Future<void> exportCardsAsCsv(List<ScannedCard> cards) async {
  final csv = buildCardsCsv(cards);
  final file = XFile.fromData(
    Uint8List.fromList(utf8.encode(csv)),
    name: 'kartvizitler.csv',
    mimeType: 'text/csv',
  );
  await SharePlus.instance.share(ShareParams(files: [file]));
}

Future<void> exportCardsAsVCardZip(List<ScannedCard> cards) async {
  final archive = Archive();
  for (final card in cards) {
    final vcard = buildScannedCardVCard(card);
    final bytes = utf8.encode(vcard);
    final name = (card.fullName?.isNotEmpty == true ? card.fullName! : card.id)
        .replaceAll(RegExp(r'[\\/:*?"<>|]'), '_');
    archive.addFile(ArchiveFile('$name.vcf', bytes.length, bytes));
  }
  final zipData = ZipEncoder().encode(archive);
  final file = XFile.fromData(
    Uint8List.fromList(zipData),
    name: 'kartvizitler.zip',
    mimeType: 'application/zip',
  );
  await SharePlus.instance.share(ShareParams(files: [file]));
}

Future<void> shareCardsBulk(List<ScannedCard> cards) async {
  final files = cards.map((card) {
    final vcard = buildScannedCardVCard(card);
    return XFile.fromData(
      Uint8List.fromList(utf8.encode(vcard)),
      name: '${card.fullName?.isNotEmpty == true ? card.fullName : card.id}.vcf',
      mimeType: 'text/vcard',
    );
  }).toList();
  await SharePlus.instance.share(ShareParams(files: files));
}

/// Her kart için ayrı ayrı rehbere kaydeder; kaç tanesinin başarılı olduğunu döner.
Future<int> saveCardsToContactsBulk(List<ScannedCard> cards) async {
  var saved = 0;
  for (final card in cards) {
    final ok = await saveScannedCardToContacts(card);
    if (ok) saved++;
  }
  return saved;
}

String _summaryLine(ScannedCard card) {
  final phone = _fieldValue(card, 'mobile').isNotEmpty
      ? _fieldValue(card, 'mobile')
      : _fieldValue(card, 'phone');
  return [card.fullName, card.company, phone].where((s) => s != null && s.isNotEmpty).join(' - ');
}

Future<void> composeBulkSms(List<ScannedCard> cards) async {
  final body = cards.map(_summaryLine).join('\n');
  await launchUrlString('sms:?body=${Uri.encodeComponent(body)}');
}

Future<void> composeBulkEmail(List<ScannedCard> cards) async {
  final body = cards.map(_summaryLine).join('\n');
  final subject = Uri.encodeComponent('Kartvizitler');
  await launchUrlString('mailto:?subject=$subject&body=${Uri.encodeComponent(body)}');
}
