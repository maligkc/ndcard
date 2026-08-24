import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/backend_providers.dart';
import '../../../core/domain/entities/scanned_card.dart';
import '../../../core/utils/vcard_parser.dart';

/// bkz. digital_card_view.dart -> shareUrlForSlug (aynı domain'i paylaşır).
const _ndcardSharePrefix = 'https://ndcard.app/c/';

enum QrContentType { ndcardShare, vcard, url, unknown }

QrContentType classifyQrContent(String data) {
  final trimmed = data.trim();
  if (trimmed.startsWith('BEGIN:VCARD')) return QrContentType.vcard;
  if (trimmed.startsWith(_ndcardSharePrefix)) return QrContentType.ndcardShare;
  if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) return QrContentType.url;
  return QrContentType.unknown;
}

String? extractShareSlug(String url) {
  if (!url.startsWith(_ndcardSharePrefix)) return null;
  final slug = url.substring(_ndcardSharePrefix.length);
  return slug.isEmpty ? null : slug;
}

String _mapPlatformToFieldType(String platform) {
  switch (platform) {
    case 'email':
      return 'email';
    case 'phone_mobile':
      return 'mobile';
    case 'phone_landline':
      return 'phone';
    case 'fax':
      return 'fax';
    case 'address':
      return 'address';
    default:
      return 'url';
  }
}

/// Bir NDCard paylaşım linkinden (QR) okunan dijital kartı, taranan kart
/// olarak içe aktarmak üzere [ScannedCard] taslağına çevirir.
Future<ScannedCard?> importDigitalCardByShareUrl(WidgetRef ref, String url) async {
  final slug = extractShareSlug(url);
  if (slug == null) return null;
  final userId = ref.read(authStateChangesProvider).value?.id;
  if (userId == null) return null;

  final digitalCard = await ref.read(digitalCardRepositoryProvider).getCardByShareSlug(slug);
  if (digitalCard == null) return null;

  final newId = const Uuid().v4();
  final fields = digitalCard.fields
      .map((f) => ScannedCardField(
            id: const Uuid().v4(),
            cardId: newId,
            fieldType: _mapPlatformToFieldType(f.platform),
            label: f.label,
            value: f.value,
          ))
      .toList();

  return ScannedCard(
    id: newId,
    userId: userId,
    frontImageUrl: digitalCard.photoUrl,
    fullName: digitalCard.fullName,
    company: digitalCard.company,
    department: digitalCard.department,
    jobTitle: digitalCard.jobTitle,
    fields: fields,
  );
}

/// vCard metnini (QR) taranan kart taslağına çevirir.
ScannedCard buildScannedCardFromVCardText(String userId, String vcardText) {
  final parsed = parseVCard(vcardText);
  final newId = const Uuid().v4();
  final fields = parsed.fields
      .map((f) => ScannedCardField(
            id: const Uuid().v4(),
            cardId: newId,
            fieldType: f.fieldType,
            label: f.label,
            value: f.value,
            addressDetail: f.addressDetail,
          ))
      .toList();

  // QR kodlar genellikle base64 fotoğraf taşıyamaz (boyut sınırı).
  // Yalnızca gerçek URI'leri kullan; data URI'lerini yoksay.
  final photoUrl = parsed.photoUrl?.startsWith('data:') == true ? null : parsed.photoUrl;

  return ScannedCard(
    id: newId,
    userId: userId,
    frontImageUrl: photoUrl,
    fullName: parsed.fullName,
    company: parsed.company,
    jobTitle: parsed.jobTitle,
    fields: fields,
  );
}
