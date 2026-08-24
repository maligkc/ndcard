import 'dart:convert';

import '../domain/entities/app_notification.dart';
import '../domain/entities/card_group.dart';
import '../domain/entities/card_note.dart';
import '../domain/entities/card_reminder.dart';
import '../domain/entities/digital_card.dart';
import '../domain/entities/ocr_result.dart';
import '../domain/entities/profile.dart';
import '../domain/entities/scanned_card.dart';
import '../domain/entities/user_settings.dart';

/// Supabase JSON <-> domain entity dönüşümleri. Bu dosya dışında hiçbir
/// katman Postgres'in snake_case alan adlarını bilmemelidir.

DateTime? _parseDate(Object? value) =>
    value == null ? null : DateTime.parse(value as String);

Profile profileFromJson(Map<String, dynamic> json) {
  return Profile(
    id: json['id'] as String,
    fullName: json['full_name'] as String?,
    avatarUrl: json['avatar_url'] as String?,
    phone: json['phone'] as String?,
    language: json['language'] as String?,
  );
}

UserSettings userSettingsFromJson(Map<String, dynamic> json) {
  return UserSettings(
    userId: json['user_id'] as String,
    notificationsEnabled: json['notifications_enabled'] as bool? ?? true,
    sound: json['sound'] as bool? ?? true,
    vibrate: json['vibrate'] as bool? ?? true,
    language: json['language'] as String?,
  );
}

Map<String, dynamic> userSettingsToJson(UserSettings settings) {
  return {
    'user_id': settings.userId,
    'notifications_enabled': settings.notificationsEnabled,
    'sound': settings.sound,
    'vibrate': settings.vibrate,
    'language': settings.language,
  };
}

DigitalCardExperience experienceFromJson(Map<String, dynamic> json) {
  return DigitalCardExperience(
    id: json['id'] as String,
    cardId: json['card_id'] as String,
    company: json['company'] as String,
    title: json['title'] as String,
    startDate: _parseDate(json['start_date']),
    endDate: _parseDate(json['end_date']),
    isCurrent: json['is_current'] as bool? ?? false,
  );
}

Map<String, dynamic> experienceToJson(DigitalCardExperience e) {
  return {
    'id': e.id,
    'card_id': e.cardId,
    'company': e.company,
    'title': e.title,
    'start_date': e.startDate?.toIso8601String(),
    'end_date': e.endDate?.toIso8601String(),
    'is_current': e.isCurrent,
  };
}

DigitalCardExtraKind _extraKindFromString(String value) {
  return DigitalCardExtraKind.values.firstWhere(
    (k) => k.name == value || _extraKindToString(k) == value,
    orElse: () => DigitalCardExtraKind.other,
  );
}

String _extraKindToString(DigitalCardExtraKind kind) {
  switch (kind) {
    case DigitalCardExtraKind.pdf:
      return 'pdf';
    case DigitalCardExtraKind.education:
      return 'education';
    case DigitalCardExtraKind.honorAward:
      return 'honor_award';
    case DigitalCardExtraKind.other:
      return 'other';
    case DigitalCardExtraKind.cardImage:
      return 'card_image';
  }
}

DigitalCardExtra extraFromJson(Map<String, dynamic> json) {
  final rawPayload = json['payload'];
  final payload = rawPayload is String
      ? jsonDecode(rawPayload) as Map<String, dynamic>
      : (rawPayload as Map<String, dynamic>? ?? const {});
  return DigitalCardExtra(
    id: json['id'] as String,
    cardId: json['card_id'] as String,
    kind: _extraKindFromString(json['kind'] as String),
    payload: payload,
  );
}

Map<String, dynamic> extraToJson(DigitalCardExtra e) {
  return {
    'id': e.id,
    'card_id': e.cardId,
    'kind': _extraKindToString(e.kind),
    'payload': e.payload,
  };
}

DigitalCardField fieldFromJson(Map<String, dynamic> json) {
  return DigitalCardField(
    id: json['id'] as String,
    cardId: json['card_id'] as String,
    platform: json['platform'] as String,
    label: json['label'] as String? ?? '',
    value: json['value'] as String,
    sortOrder: json['sort_order'] as int? ?? 0,
  );
}

Map<String, dynamic> fieldToJson(DigitalCardField f) {
  return {
    'id': f.id,
    'card_id': f.cardId,
    'platform': f.platform,
    'label': f.label,
    'value': f.value,
    'sort_order': f.sortOrder,
  };
}

DigitalCard digitalCardFromJson(
  Map<String, dynamic> json, {
  List<DigitalCardExperience> experiences = const [],
  List<DigitalCardExtra> extras = const [],
  List<DigitalCardField> fields = const [],
}) {
  return DigitalCard(
    id: json['id'] as String,
    userId: json['user_id'] as String,
    firstName: json['first_name'] as String,
    lastName: json['last_name'] as String,
    photoUrl: json['photo_url'] as String?,
    jobTitle: json['job_title'] as String?,
    department: json['department'] as String?,
    company: json['company'] as String?,
    headline: json['headline'] as String?,
    theme: json['theme'] as String? ?? 'classic',
    isDefault: json['is_default'] as bool? ?? false,
    shareSlug: json['share_slug'] as String?,
    experiences: experiences,
    extras: extras,
    fields: fields,
  );
}

Map<String, dynamic> digitalCardToJson(DigitalCard card) {
  return {
    'id': card.id,
    'user_id': card.userId,
    'first_name': card.firstName,
    'last_name': card.lastName,
    'photo_url': card.photoUrl,
    'job_title': card.jobTitle,
    'department': card.department,
    'company': card.company,
    'headline': card.headline,
    'theme': card.theme,
    'is_default': card.isDefault,
    'share_slug': card.shareSlug,
  };
}

AddressDetail addressDetailFromJson(Map<String, dynamic>? json) {
  if (json == null) return const AddressDetail();
  return AddressDetail(
    street: json['street'] as String?,
    city: json['city'] as String?,
    district: json['district'] as String?,
    postalCode: json['postal_code'] as String?,
    country: json['country'] as String?,
  );
}

Map<String, dynamic> addressDetailToJson(AddressDetail a) {
  return {
    'street': a.street,
    'city': a.city,
    'district': a.district,
    'postal_code': a.postalCode,
    'country': a.country,
  };
}

ScannedCardField scannedFieldFromJson(Map<String, dynamic> json) {
  final rawAddress = json['address_detail'];
  final address = rawAddress is String
      ? jsonDecode(rawAddress) as Map<String, dynamic>?
      : rawAddress as Map<String, dynamic>?;
  return ScannedCardField(
    id: json['id'] as String,
    cardId: json['card_id'] as String,
    fieldType: json['field_type'] as String,
    label: json['label'] as String? ?? '',
    value: json['value'] as String,
    addressDetail: address == null ? null : addressDetailFromJson(address),
    sortOrder: json['sort_order'] as int? ?? 0,
  );
}

Map<String, dynamic> scannedFieldToJson(ScannedCardField f) {
  return {
    'id': f.id,
    'card_id': f.cardId,
    'field_type': f.fieldType,
    'label': f.label,
    'value': f.value,
    'address_detail': f.addressDetail == null ? null : addressDetailToJson(f.addressDetail!),
    'sort_order': f.sortOrder,
  };
}

ScannedCard scannedCardFromJson(
  Map<String, dynamic> json, {
  List<ScannedCardField> fields = const [],
}) {
  final rawOcr = json['raw_ocr'];
  return ScannedCard(
    id: json['id'] as String,
    userId: json['user_id'] as String,
    profileImageUrl: json['profile_image_url'] as String?,
    frontImageUrl: json['front_image_url'] as String?,
    backImageUrl: json['back_image_url'] as String?,
    fullName: json['full_name'] as String?,
    company: json['company'] as String?,
    department: json['department'] as String?,
    jobTitle: json['job_title'] as String?,
    sortByCompany: json['sort_by_company'] as bool? ?? false,
    rawOcr: rawOcr is String
        ? jsonDecode(rawOcr) as Map<String, dynamic>?
        : rawOcr as Map<String, dynamic>?,
    lastViewedAt: _parseDate(json['last_viewed_at']),
    deletedAt: _parseDate(json['deleted_at']),
    createdAt: _parseDate(json['created_at']),
    fields: fields,
  );
}

Map<String, dynamic> scannedCardToJson(ScannedCard card) {
  return {
    'id': card.id,
    'user_id': card.userId,
    'profile_image_url': card.profileImageUrl,
    'front_image_url': card.frontImageUrl,
    'back_image_url': card.backImageUrl,
    'full_name': card.fullName,
    'company': card.company,
    'department': card.department,
    'job_title': card.jobTitle,
    'sort_by_company': card.sortByCompany,
    'raw_ocr': card.rawOcr,
    'last_viewed_at': card.lastViewedAt?.toIso8601String(),
    'deleted_at': card.deletedAt?.toIso8601String(),
  };
}

CardGroup cardGroupFromJson(Map<String, dynamic> json, {int cardCount = 0}) {
  return CardGroup(
    id: json['id'] as String,
    userId: json['user_id'] as String,
    name: json['name'] as String,
    cardCount: cardCount,
  );
}

CardNoteType _noteTypeFromString(String value) =>
    value == 'visit_log' ? CardNoteType.visitLog : CardNoteType.note;

String _noteTypeToString(CardNoteType type) =>
    type == CardNoteType.visitLog ? 'visit_log' : 'note';

CardNote cardNoteFromJson(Map<String, dynamic> json) {
  return CardNote(
    id: json['id'] as String,
    userId: json['user_id'] as String,
    cardId: json['card_id'] as String,
    content: json['content'] as String,
    noteType: _noteTypeFromString(json['note_type'] as String? ?? 'note'),
    createdAt: _parseDate(json['created_at']),
  );
}

Map<String, dynamic> cardNoteToJson(CardNote note) {
  return {
    'id': note.id,
    'user_id': note.userId,
    'card_id': note.cardId,
    'content': note.content,
    'note_type': _noteTypeToString(note.noteType),
  };
}

CardReminder cardReminderFromJson(Map<String, dynamic> json) {
  return CardReminder(
    id: json['id'] as String,
    userId: json['user_id'] as String,
    cardId: json['card_id'] as String,
    remindAt: DateTime.parse(json['remind_at'] as String),
    message: json['message'] as String,
    isNotified: json['is_notified'] as bool? ?? false,
  );
}

Map<String, dynamic> cardReminderToJson(CardReminder reminder) {
  return {
    'id': reminder.id,
    'user_id': reminder.userId,
    'card_id': reminder.cardId,
    'remind_at': reminder.remindAt.toIso8601String(),
    'message': reminder.message,
  };
}

AppNotification appNotificationFromJson(Map<String, dynamic> json) {
  return AppNotification(
    id: json['id'] as String,
    userId: json['user_id'] as String,
    title: json['title'] as String,
    body: json['body'] as String,
    isRead: json['is_read'] as bool? ?? false,
    createdAt: _parseDate(json['created_at']),
  );
}

OcrResult ocrResultFromJson(Map<String, dynamic> json) {
  final rawFields = json['fields'] as List<dynamic>? ?? const [];
  return OcrResult(
    fullName: json['full_name'] as String?,
    company: json['company'] as String?,
    department: json['department'] as String?,
    jobTitle: json['job_title'] as String?,
    fields: rawFields.map((f) {
      final map = f as Map<String, dynamic>;
      final address = map['address_detail'] as Map<String, dynamic>?;
      return OcrFieldResult(
        fieldType: map['field_type'] as String? ?? 'other',
        label: map['label'] as String? ?? '',
        value: map['value'] as String? ?? '',
        addressDetail: address?.map((k, v) => MapEntry(k, v.toString())),
      );
    }).toList(),
  );
}
