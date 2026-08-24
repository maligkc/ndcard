class AddressDetail {
  const AddressDetail({
    this.street,
    this.city,
    this.district,
    this.postalCode,
    this.country,
  });

  final String? street;
  final String? city;
  final String? district;
  final String? postalCode;
  final String? country;

  AddressDetail copyWith({
    String? street,
    String? city,
    String? district,
    String? postalCode,
    String? country,
  }) {
    return AddressDetail(
      street: street ?? this.street,
      city: city ?? this.city,
      district: district ?? this.district,
      postalCode: postalCode ?? this.postalCode,
      country: country ?? this.country,
    );
  }
}

class ScannedCardField {
  const ScannedCardField({
    required this.id,
    required this.cardId,
    required this.fieldType,
    required this.label,
    required this.value,
    this.addressDetail,
    this.sortOrder = 0,
  });

  final String id;
  final String cardId;

  /// 'mobile','email','url','address','phone','fax',...
  final String fieldType;
  final String label;
  final String value;
  final AddressDetail? addressDetail;
  final int sortOrder;

  ScannedCardField copyWith({
    String? fieldType,
    String? label,
    String? value,
    AddressDetail? addressDetail,
    int? sortOrder,
  }) {
    return ScannedCardField(
      id: id,
      cardId: cardId,
      fieldType: fieldType ?? this.fieldType,
      label: label ?? this.label,
      value: value ?? this.value,
      addressDetail: addressDetail ?? this.addressDetail,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }
}

class ScannedCard {
  const ScannedCard({
    required this.id,
    required this.userId,
    this.profileImageUrl,
    this.frontImageUrl,
    this.backImageUrl,
    this.fullName,
    this.company,
    this.department,
    this.jobTitle,
    this.sortByCompany = false,
    this.rawOcr,
    this.lastViewedAt,
    this.deletedAt,
    this.createdAt,
    this.fields = const [],
  });

  final String id;
  final String userId;
  final String? profileImageUrl;
  final String? frontImageUrl;
  final String? backImageUrl;
  final String? fullName;
  final String? company;
  final String? department;
  final String? jobTitle;
  final bool sortByCompany;
  final Map<String, dynamic>? rawOcr;
  final DateTime? lastViewedAt;
  final DateTime? deletedAt;
  final DateTime? createdAt;
  final List<ScannedCardField> fields;

  bool get isDeleted => deletedAt != null;

  ScannedCard copyWith({
    String? profileImageUrl,
    String? frontImageUrl,
    String? backImageUrl,
    String? fullName,
    String? company,
    String? department,
    String? jobTitle,
    bool? sortByCompany,
    Map<String, dynamic>? rawOcr,
    DateTime? lastViewedAt,
    DateTime? deletedAt,
    List<ScannedCardField>? fields,
  }) {
    return ScannedCard(
      id: id,
      userId: userId,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      frontImageUrl: frontImageUrl ?? this.frontImageUrl,
      backImageUrl: backImageUrl ?? this.backImageUrl,
      fullName: fullName ?? this.fullName,
      company: company ?? this.company,
      department: department ?? this.department,
      jobTitle: jobTitle ?? this.jobTitle,
      sortByCompany: sortByCompany ?? this.sortByCompany,
      rawOcr: rawOcr ?? this.rawOcr,
      lastViewedAt: lastViewedAt ?? this.lastViewedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      createdAt: createdAt,
      fields: fields ?? this.fields,
    );
  }
}
