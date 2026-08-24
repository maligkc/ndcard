enum DigitalCardExtraKind { pdf, education, honorAward, other, cardImage }

class DigitalCardExperience {
  const DigitalCardExperience({
    required this.id,
    required this.cardId,
    required this.company,
    required this.title,
    this.startDate,
    this.endDate,
    this.isCurrent = false,
  });

  final String id;
  final String cardId;
  final String company;
  final String title;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool isCurrent;

  DigitalCardExperience copyWith({
    String? company,
    String? title,
    DateTime? startDate,
    DateTime? endDate,
    bool? isCurrent,
  }) {
    return DigitalCardExperience(
      id: id,
      cardId: cardId,
      company: company ?? this.company,
      title: title ?? this.title,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isCurrent: isCurrent ?? this.isCurrent,
    );
  }
}

class DigitalCardExtra {
  const DigitalCardExtra({
    required this.id,
    required this.cardId,
    required this.kind,
    required this.payload,
  });

  final String id;
  final String cardId;
  final DigitalCardExtraKind kind;

  /// Türe göre serbest içerik: pdf {url,title}, education {school,department,year},
  /// honorAward {title,year,description}, other {title,text}, cardImage {url}.
  final Map<String, dynamic> payload;

  DigitalCardExtra copyWith({Map<String, dynamic>? payload}) {
    return DigitalCardExtra(
      id: id,
      cardId: cardId,
      kind: kind,
      payload: payload ?? this.payload,
    );
  }
}

class DigitalCardField {
  const DigitalCardField({
    required this.id,
    required this.cardId,
    required this.platform,
    required this.label,
    required this.value,
    this.sortOrder = 0,
  });

  final String id;
  final String cardId;
  final String platform;
  final String label;
  final String value;
  final int sortOrder;

  DigitalCardField copyWith({
    String? platform,
    String? label,
    String? value,
    int? sortOrder,
  }) {
    return DigitalCardField(
      id: id,
      cardId: cardId,
      platform: platform ?? this.platform,
      label: label ?? this.label,
      value: value ?? this.value,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }
}

class DigitalCard {
  const DigitalCard({
    required this.id,
    required this.userId,
    required this.firstName,
    required this.lastName,
    this.photoUrl,
    this.jobTitle,
    this.department,
    this.company,
    this.headline,
    this.theme = 'classic',
    this.isDefault = false,
    this.shareSlug,
    this.deletedAt,
    this.experiences = const [],
    this.extras = const [],
    this.fields = const [],
  });

  final String id;
  final String userId;
  final String firstName;
  final String lastName;
  final String? photoUrl;
  final String? jobTitle;
  final String? department;
  final String? company;
  final String? headline;
  final String theme;
  final bool isDefault;
  final String? shareSlug;
  final DateTime? deletedAt;
  final List<DigitalCardExperience> experiences;
  final List<DigitalCardExtra> extras;
  final List<DigitalCardField> fields;

  String get fullName => '$firstName $lastName'.trim();

  DigitalCard copyWith({
    String? firstName,
    String? lastName,
    String? photoUrl,
    String? jobTitle,
    String? department,
    String? company,
    String? headline,
    String? theme,
    bool? isDefault,
    String? shareSlug,
    DateTime? deletedAt,
    List<DigitalCardExperience>? experiences,
    List<DigitalCardExtra>? extras,
    List<DigitalCardField>? fields,
  }) {
    return DigitalCard(
      id: id,
      userId: userId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      photoUrl: photoUrl ?? this.photoUrl,
      jobTitle: jobTitle ?? this.jobTitle,
      department: department ?? this.department,
      company: company ?? this.company,
      headline: headline ?? this.headline,
      theme: theme ?? this.theme,
      isDefault: isDefault ?? this.isDefault,
      shareSlug: shareSlug ?? this.shareSlug,
      deletedAt: deletedAt ?? this.deletedAt,
      experiences: experiences ?? this.experiences,
      extras: extras ?? this.extras,
      fields: fields ?? this.fields,
    );
  }
}
