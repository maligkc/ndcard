import 'package:flutter_contacts/flutter_contacts.dart';

import '../../../core/domain/entities/scanned_card.dart';

/// [ScannedCard] verisini telefon rehberine kaydeder. İzin reddedilirse
/// false döner, çağıran taraf kullanıcıya uygun bir mesaj gösterir.
Future<bool> saveScannedCardToContacts(ScannedCard card) async {
  final status = await FlutterContacts.permissions.request(PermissionType.readWrite);
  if (status != PermissionStatus.granted && status != PermissionStatus.limited) {
    return false;
  }

  final phones = <Phone>[];
  final emails = <Email>[];
  final addresses = <Address>[];
  final websites = <Website>[];

  for (final field in card.fields) {
    final value = field.value.trim();
    if (value.isEmpty) continue;
    switch (field.fieldType) {
      case 'mobile':
        phones.add(Phone(number: value, label: const Label(PhoneLabel.mobile)));
        break;
      case 'phone':
        phones.add(Phone(number: value, label: const Label(PhoneLabel.work)));
        break;
      case 'fax':
        phones.add(Phone(number: value, label: const Label(PhoneLabel.workFax)));
        break;
      case 'email':
        emails.add(Email(address: value, label: const Label(EmailLabel.work)));
        break;
      case 'address':
        addresses.add(Address(formatted: value, label: const Label(AddressLabel.work)));
        break;
      case 'url':
        websites.add(Website(url: value));
        break;
    }
  }

  final contact = Contact(
    name: Name(first: card.fullName ?? ''),
    phones: phones,
    emails: emails,
    addresses: addresses,
    websites: websites,
    organizations: (card.company != null && card.company!.isNotEmpty) || card.jobTitle != null
        ? [Organization(name: card.company ?? '', jobTitle: card.jobTitle ?? '')]
        : const [],
  );

  await FlutterContacts.create(contact);
  return true;
}
