// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ProfilesTable extends Profiles
    with TableInfo<$ProfilesTable, ProfileRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fullNameMeta = const VerificationMeta(
    'fullName',
  );
  @override
  late final GeneratedColumn<String> fullName = GeneratedColumn<String>(
    'full_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _avatarUrlMeta = const VerificationMeta(
    'avatarUrl',
  );
  @override
  late final GeneratedColumn<String> avatarUrl = GeneratedColumn<String>(
    'avatar_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _languageMeta = const VerificationMeta(
    'language',
  );
  @override
  late final GeneratedColumn<String> language = GeneratedColumn<String>(
    'language',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    fullName,
    avatarUrl,
    phone,
    language,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProfileRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('full_name')) {
      context.handle(
        _fullNameMeta,
        fullName.isAcceptableOrUnknown(data['full_name']!, _fullNameMeta),
      );
    }
    if (data.containsKey('avatar_url')) {
      context.handle(
        _avatarUrlMeta,
        avatarUrl.isAcceptableOrUnknown(data['avatar_url']!, _avatarUrlMeta),
      );
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('language')) {
      context.handle(
        _languageMeta,
        language.isAcceptableOrUnknown(data['language']!, _languageMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProfileRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProfileRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      fullName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}full_name'],
      ),
      avatarUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}avatar_url'],
      ),
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      ),
      language: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}language'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ProfilesTable createAlias(String alias) {
    return $ProfilesTable(attachedDatabase, alias);
  }
}

class ProfileRow extends DataClass implements Insertable<ProfileRow> {
  final String id;
  final String? fullName;
  final String? avatarUrl;
  final String? phone;
  final String? language;
  final DateTime updatedAt;
  const ProfileRow({
    required this.id,
    this.fullName,
    this.avatarUrl,
    this.phone,
    this.language,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || fullName != null) {
      map['full_name'] = Variable<String>(fullName);
    }
    if (!nullToAbsent || avatarUrl != null) {
      map['avatar_url'] = Variable<String>(avatarUrl);
    }
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || language != null) {
      map['language'] = Variable<String>(language);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ProfilesCompanion toCompanion(bool nullToAbsent) {
    return ProfilesCompanion(
      id: Value(id),
      fullName: fullName == null && nullToAbsent
          ? const Value.absent()
          : Value(fullName),
      avatarUrl: avatarUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(avatarUrl),
      phone: phone == null && nullToAbsent
          ? const Value.absent()
          : Value(phone),
      language: language == null && nullToAbsent
          ? const Value.absent()
          : Value(language),
      updatedAt: Value(updatedAt),
    );
  }

  factory ProfileRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProfileRow(
      id: serializer.fromJson<String>(json['id']),
      fullName: serializer.fromJson<String?>(json['fullName']),
      avatarUrl: serializer.fromJson<String?>(json['avatarUrl']),
      phone: serializer.fromJson<String?>(json['phone']),
      language: serializer.fromJson<String?>(json['language']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'fullName': serializer.toJson<String?>(fullName),
      'avatarUrl': serializer.toJson<String?>(avatarUrl),
      'phone': serializer.toJson<String?>(phone),
      'language': serializer.toJson<String?>(language),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ProfileRow copyWith({
    String? id,
    Value<String?> fullName = const Value.absent(),
    Value<String?> avatarUrl = const Value.absent(),
    Value<String?> phone = const Value.absent(),
    Value<String?> language = const Value.absent(),
    DateTime? updatedAt,
  }) => ProfileRow(
    id: id ?? this.id,
    fullName: fullName.present ? fullName.value : this.fullName,
    avatarUrl: avatarUrl.present ? avatarUrl.value : this.avatarUrl,
    phone: phone.present ? phone.value : this.phone,
    language: language.present ? language.value : this.language,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ProfileRow copyWithCompanion(ProfilesCompanion data) {
    return ProfileRow(
      id: data.id.present ? data.id.value : this.id,
      fullName: data.fullName.present ? data.fullName.value : this.fullName,
      avatarUrl: data.avatarUrl.present ? data.avatarUrl.value : this.avatarUrl,
      phone: data.phone.present ? data.phone.value : this.phone,
      language: data.language.present ? data.language.value : this.language,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProfileRow(')
          ..write('id: $id, ')
          ..write('fullName: $fullName, ')
          ..write('avatarUrl: $avatarUrl, ')
          ..write('phone: $phone, ')
          ..write('language: $language, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, fullName, avatarUrl, phone, language, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProfileRow &&
          other.id == this.id &&
          other.fullName == this.fullName &&
          other.avatarUrl == this.avatarUrl &&
          other.phone == this.phone &&
          other.language == this.language &&
          other.updatedAt == this.updatedAt);
}

class ProfilesCompanion extends UpdateCompanion<ProfileRow> {
  final Value<String> id;
  final Value<String?> fullName;
  final Value<String?> avatarUrl;
  final Value<String?> phone;
  final Value<String?> language;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const ProfilesCompanion({
    this.id = const Value.absent(),
    this.fullName = const Value.absent(),
    this.avatarUrl = const Value.absent(),
    this.phone = const Value.absent(),
    this.language = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProfilesCompanion.insert({
    required String id,
    this.fullName = const Value.absent(),
    this.avatarUrl = const Value.absent(),
    this.phone = const Value.absent(),
    this.language = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id);
  static Insertable<ProfileRow> custom({
    Expression<String>? id,
    Expression<String>? fullName,
    Expression<String>? avatarUrl,
    Expression<String>? phone,
    Expression<String>? language,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (fullName != null) 'full_name': fullName,
      if (avatarUrl != null) 'avatar_url': avatarUrl,
      if (phone != null) 'phone': phone,
      if (language != null) 'language': language,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProfilesCompanion copyWith({
    Value<String>? id,
    Value<String?>? fullName,
    Value<String?>? avatarUrl,
    Value<String?>? phone,
    Value<String?>? language,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return ProfilesCompanion(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      phone: phone ?? this.phone,
      language: language ?? this.language,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (fullName.present) {
      map['full_name'] = Variable<String>(fullName.value);
    }
    if (avatarUrl.present) {
      map['avatar_url'] = Variable<String>(avatarUrl.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (language.present) {
      map['language'] = Variable<String>(language.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProfilesCompanion(')
          ..write('id: $id, ')
          ..write('fullName: $fullName, ')
          ..write('avatarUrl: $avatarUrl, ')
          ..write('phone: $phone, ')
          ..write('language: $language, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DigitalCardsTable extends DigitalCards
    with TableInfo<$DigitalCardsTable, DigitalCardRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DigitalCardsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _firstNameMeta = const VerificationMeta(
    'firstName',
  );
  @override
  late final GeneratedColumn<String> firstName = GeneratedColumn<String>(
    'first_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastNameMeta = const VerificationMeta(
    'lastName',
  );
  @override
  late final GeneratedColumn<String> lastName = GeneratedColumn<String>(
    'last_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _photoUrlMeta = const VerificationMeta(
    'photoUrl',
  );
  @override
  late final GeneratedColumn<String> photoUrl = GeneratedColumn<String>(
    'photo_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _jobTitleMeta = const VerificationMeta(
    'jobTitle',
  );
  @override
  late final GeneratedColumn<String> jobTitle = GeneratedColumn<String>(
    'job_title',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _departmentMeta = const VerificationMeta(
    'department',
  );
  @override
  late final GeneratedColumn<String> department = GeneratedColumn<String>(
    'department',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _companyMeta = const VerificationMeta(
    'company',
  );
  @override
  late final GeneratedColumn<String> company = GeneratedColumn<String>(
    'company',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _headlineMeta = const VerificationMeta(
    'headline',
  );
  @override
  late final GeneratedColumn<String> headline = GeneratedColumn<String>(
    'headline',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _themeMeta = const VerificationMeta('theme');
  @override
  late final GeneratedColumn<String> theme = GeneratedColumn<String>(
    'theme',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('classic'),
  );
  static const VerificationMeta _isDefaultMeta = const VerificationMeta(
    'isDefault',
  );
  @override
  late final GeneratedColumn<bool> isDefault = GeneratedColumn<bool>(
    'is_default',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_default" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _shareSlugMeta = const VerificationMeta(
    'shareSlug',
  );
  @override
  late final GeneratedColumn<String> shareSlug = GeneratedColumn<String>(
    'share_slug',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    firstName,
    lastName,
    photoUrl,
    jobTitle,
    department,
    company,
    headline,
    theme,
    isDefault,
    shareSlug,
    deletedAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'digital_cards';
  @override
  VerificationContext validateIntegrity(
    Insertable<DigitalCardRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('first_name')) {
      context.handle(
        _firstNameMeta,
        firstName.isAcceptableOrUnknown(data['first_name']!, _firstNameMeta),
      );
    } else if (isInserting) {
      context.missing(_firstNameMeta);
    }
    if (data.containsKey('last_name')) {
      context.handle(
        _lastNameMeta,
        lastName.isAcceptableOrUnknown(data['last_name']!, _lastNameMeta),
      );
    } else if (isInserting) {
      context.missing(_lastNameMeta);
    }
    if (data.containsKey('photo_url')) {
      context.handle(
        _photoUrlMeta,
        photoUrl.isAcceptableOrUnknown(data['photo_url']!, _photoUrlMeta),
      );
    }
    if (data.containsKey('job_title')) {
      context.handle(
        _jobTitleMeta,
        jobTitle.isAcceptableOrUnknown(data['job_title']!, _jobTitleMeta),
      );
    }
    if (data.containsKey('department')) {
      context.handle(
        _departmentMeta,
        department.isAcceptableOrUnknown(data['department']!, _departmentMeta),
      );
    }
    if (data.containsKey('company')) {
      context.handle(
        _companyMeta,
        company.isAcceptableOrUnknown(data['company']!, _companyMeta),
      );
    }
    if (data.containsKey('headline')) {
      context.handle(
        _headlineMeta,
        headline.isAcceptableOrUnknown(data['headline']!, _headlineMeta),
      );
    }
    if (data.containsKey('theme')) {
      context.handle(
        _themeMeta,
        theme.isAcceptableOrUnknown(data['theme']!, _themeMeta),
      );
    }
    if (data.containsKey('is_default')) {
      context.handle(
        _isDefaultMeta,
        isDefault.isAcceptableOrUnknown(data['is_default']!, _isDefaultMeta),
      );
    }
    if (data.containsKey('share_slug')) {
      context.handle(
        _shareSlugMeta,
        shareSlug.isAcceptableOrUnknown(data['share_slug']!, _shareSlugMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DigitalCardRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DigitalCardRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      firstName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}first_name'],
      )!,
      lastName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_name'],
      )!,
      photoUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}photo_url'],
      ),
      jobTitle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}job_title'],
      ),
      department: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}department'],
      ),
      company: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}company'],
      ),
      headline: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}headline'],
      ),
      theme: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}theme'],
      )!,
      isDefault: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_default'],
      )!,
      shareSlug: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}share_slug'],
      ),
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $DigitalCardsTable createAlias(String alias) {
    return $DigitalCardsTable(attachedDatabase, alias);
  }
}

class DigitalCardRow extends DataClass implements Insertable<DigitalCardRow> {
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
  final DateTime updatedAt;
  const DigitalCardRow({
    required this.id,
    required this.userId,
    required this.firstName,
    required this.lastName,
    this.photoUrl,
    this.jobTitle,
    this.department,
    this.company,
    this.headline,
    required this.theme,
    required this.isDefault,
    this.shareSlug,
    this.deletedAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['first_name'] = Variable<String>(firstName);
    map['last_name'] = Variable<String>(lastName);
    if (!nullToAbsent || photoUrl != null) {
      map['photo_url'] = Variable<String>(photoUrl);
    }
    if (!nullToAbsent || jobTitle != null) {
      map['job_title'] = Variable<String>(jobTitle);
    }
    if (!nullToAbsent || department != null) {
      map['department'] = Variable<String>(department);
    }
    if (!nullToAbsent || company != null) {
      map['company'] = Variable<String>(company);
    }
    if (!nullToAbsent || headline != null) {
      map['headline'] = Variable<String>(headline);
    }
    map['theme'] = Variable<String>(theme);
    map['is_default'] = Variable<bool>(isDefault);
    if (!nullToAbsent || shareSlug != null) {
      map['share_slug'] = Variable<String>(shareSlug);
    }
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  DigitalCardsCompanion toCompanion(bool nullToAbsent) {
    return DigitalCardsCompanion(
      id: Value(id),
      userId: Value(userId),
      firstName: Value(firstName),
      lastName: Value(lastName),
      photoUrl: photoUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(photoUrl),
      jobTitle: jobTitle == null && nullToAbsent
          ? const Value.absent()
          : Value(jobTitle),
      department: department == null && nullToAbsent
          ? const Value.absent()
          : Value(department),
      company: company == null && nullToAbsent
          ? const Value.absent()
          : Value(company),
      headline: headline == null && nullToAbsent
          ? const Value.absent()
          : Value(headline),
      theme: Value(theme),
      isDefault: Value(isDefault),
      shareSlug: shareSlug == null && nullToAbsent
          ? const Value.absent()
          : Value(shareSlug),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory DigitalCardRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DigitalCardRow(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      firstName: serializer.fromJson<String>(json['firstName']),
      lastName: serializer.fromJson<String>(json['lastName']),
      photoUrl: serializer.fromJson<String?>(json['photoUrl']),
      jobTitle: serializer.fromJson<String?>(json['jobTitle']),
      department: serializer.fromJson<String?>(json['department']),
      company: serializer.fromJson<String?>(json['company']),
      headline: serializer.fromJson<String?>(json['headline']),
      theme: serializer.fromJson<String>(json['theme']),
      isDefault: serializer.fromJson<bool>(json['isDefault']),
      shareSlug: serializer.fromJson<String?>(json['shareSlug']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'firstName': serializer.toJson<String>(firstName),
      'lastName': serializer.toJson<String>(lastName),
      'photoUrl': serializer.toJson<String?>(photoUrl),
      'jobTitle': serializer.toJson<String?>(jobTitle),
      'department': serializer.toJson<String?>(department),
      'company': serializer.toJson<String?>(company),
      'headline': serializer.toJson<String?>(headline),
      'theme': serializer.toJson<String>(theme),
      'isDefault': serializer.toJson<bool>(isDefault),
      'shareSlug': serializer.toJson<String?>(shareSlug),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  DigitalCardRow copyWith({
    String? id,
    String? userId,
    String? firstName,
    String? lastName,
    Value<String?> photoUrl = const Value.absent(),
    Value<String?> jobTitle = const Value.absent(),
    Value<String?> department = const Value.absent(),
    Value<String?> company = const Value.absent(),
    Value<String?> headline = const Value.absent(),
    String? theme,
    bool? isDefault,
    Value<String?> shareSlug = const Value.absent(),
    Value<DateTime?> deletedAt = const Value.absent(),
    DateTime? updatedAt,
  }) => DigitalCardRow(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    firstName: firstName ?? this.firstName,
    lastName: lastName ?? this.lastName,
    photoUrl: photoUrl.present ? photoUrl.value : this.photoUrl,
    jobTitle: jobTitle.present ? jobTitle.value : this.jobTitle,
    department: department.present ? department.value : this.department,
    company: company.present ? company.value : this.company,
    headline: headline.present ? headline.value : this.headline,
    theme: theme ?? this.theme,
    isDefault: isDefault ?? this.isDefault,
    shareSlug: shareSlug.present ? shareSlug.value : this.shareSlug,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  DigitalCardRow copyWithCompanion(DigitalCardsCompanion data) {
    return DigitalCardRow(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      firstName: data.firstName.present ? data.firstName.value : this.firstName,
      lastName: data.lastName.present ? data.lastName.value : this.lastName,
      photoUrl: data.photoUrl.present ? data.photoUrl.value : this.photoUrl,
      jobTitle: data.jobTitle.present ? data.jobTitle.value : this.jobTitle,
      department: data.department.present
          ? data.department.value
          : this.department,
      company: data.company.present ? data.company.value : this.company,
      headline: data.headline.present ? data.headline.value : this.headline,
      theme: data.theme.present ? data.theme.value : this.theme,
      isDefault: data.isDefault.present ? data.isDefault.value : this.isDefault,
      shareSlug: data.shareSlug.present ? data.shareSlug.value : this.shareSlug,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DigitalCardRow(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('firstName: $firstName, ')
          ..write('lastName: $lastName, ')
          ..write('photoUrl: $photoUrl, ')
          ..write('jobTitle: $jobTitle, ')
          ..write('department: $department, ')
          ..write('company: $company, ')
          ..write('headline: $headline, ')
          ..write('theme: $theme, ')
          ..write('isDefault: $isDefault, ')
          ..write('shareSlug: $shareSlug, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    firstName,
    lastName,
    photoUrl,
    jobTitle,
    department,
    company,
    headline,
    theme,
    isDefault,
    shareSlug,
    deletedAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DigitalCardRow &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.firstName == this.firstName &&
          other.lastName == this.lastName &&
          other.photoUrl == this.photoUrl &&
          other.jobTitle == this.jobTitle &&
          other.department == this.department &&
          other.company == this.company &&
          other.headline == this.headline &&
          other.theme == this.theme &&
          other.isDefault == this.isDefault &&
          other.shareSlug == this.shareSlug &&
          other.deletedAt == this.deletedAt &&
          other.updatedAt == this.updatedAt);
}

class DigitalCardsCompanion extends UpdateCompanion<DigitalCardRow> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> firstName;
  final Value<String> lastName;
  final Value<String?> photoUrl;
  final Value<String?> jobTitle;
  final Value<String?> department;
  final Value<String?> company;
  final Value<String?> headline;
  final Value<String> theme;
  final Value<bool> isDefault;
  final Value<String?> shareSlug;
  final Value<DateTime?> deletedAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const DigitalCardsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.firstName = const Value.absent(),
    this.lastName = const Value.absent(),
    this.photoUrl = const Value.absent(),
    this.jobTitle = const Value.absent(),
    this.department = const Value.absent(),
    this.company = const Value.absent(),
    this.headline = const Value.absent(),
    this.theme = const Value.absent(),
    this.isDefault = const Value.absent(),
    this.shareSlug = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DigitalCardsCompanion.insert({
    required String id,
    required String userId,
    required String firstName,
    required String lastName,
    this.photoUrl = const Value.absent(),
    this.jobTitle = const Value.absent(),
    this.department = const Value.absent(),
    this.company = const Value.absent(),
    this.headline = const Value.absent(),
    this.theme = const Value.absent(),
    this.isDefault = const Value.absent(),
    this.shareSlug = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       firstName = Value(firstName),
       lastName = Value(lastName);
  static Insertable<DigitalCardRow> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? firstName,
    Expression<String>? lastName,
    Expression<String>? photoUrl,
    Expression<String>? jobTitle,
    Expression<String>? department,
    Expression<String>? company,
    Expression<String>? headline,
    Expression<String>? theme,
    Expression<bool>? isDefault,
    Expression<String>? shareSlug,
    Expression<DateTime>? deletedAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (firstName != null) 'first_name': firstName,
      if (lastName != null) 'last_name': lastName,
      if (photoUrl != null) 'photo_url': photoUrl,
      if (jobTitle != null) 'job_title': jobTitle,
      if (department != null) 'department': department,
      if (company != null) 'company': company,
      if (headline != null) 'headline': headline,
      if (theme != null) 'theme': theme,
      if (isDefault != null) 'is_default': isDefault,
      if (shareSlug != null) 'share_slug': shareSlug,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DigitalCardsCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<String>? firstName,
    Value<String>? lastName,
    Value<String?>? photoUrl,
    Value<String?>? jobTitle,
    Value<String?>? department,
    Value<String?>? company,
    Value<String?>? headline,
    Value<String>? theme,
    Value<bool>? isDefault,
    Value<String?>? shareSlug,
    Value<DateTime?>? deletedAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return DigitalCardsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
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
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (firstName.present) {
      map['first_name'] = Variable<String>(firstName.value);
    }
    if (lastName.present) {
      map['last_name'] = Variable<String>(lastName.value);
    }
    if (photoUrl.present) {
      map['photo_url'] = Variable<String>(photoUrl.value);
    }
    if (jobTitle.present) {
      map['job_title'] = Variable<String>(jobTitle.value);
    }
    if (department.present) {
      map['department'] = Variable<String>(department.value);
    }
    if (company.present) {
      map['company'] = Variable<String>(company.value);
    }
    if (headline.present) {
      map['headline'] = Variable<String>(headline.value);
    }
    if (theme.present) {
      map['theme'] = Variable<String>(theme.value);
    }
    if (isDefault.present) {
      map['is_default'] = Variable<bool>(isDefault.value);
    }
    if (shareSlug.present) {
      map['share_slug'] = Variable<String>(shareSlug.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DigitalCardsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('firstName: $firstName, ')
          ..write('lastName: $lastName, ')
          ..write('photoUrl: $photoUrl, ')
          ..write('jobTitle: $jobTitle, ')
          ..write('department: $department, ')
          ..write('company: $company, ')
          ..write('headline: $headline, ')
          ..write('theme: $theme, ')
          ..write('isDefault: $isDefault, ')
          ..write('shareSlug: $shareSlug, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DigitalCardExperiencesTable extends DigitalCardExperiences
    with TableInfo<$DigitalCardExperiencesTable, DigitalCardExperienceRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DigitalCardExperiencesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cardIdMeta = const VerificationMeta('cardId');
  @override
  late final GeneratedColumn<String> cardId = GeneratedColumn<String>(
    'card_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _companyMeta = const VerificationMeta(
    'company',
  );
  @override
  late final GeneratedColumn<String> company = GeneratedColumn<String>(
    'company',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
    'start_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _endDateMeta = const VerificationMeta(
    'endDate',
  );
  @override
  late final GeneratedColumn<DateTime> endDate = GeneratedColumn<DateTime>(
    'end_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isCurrentMeta = const VerificationMeta(
    'isCurrent',
  );
  @override
  late final GeneratedColumn<bool> isCurrent = GeneratedColumn<bool>(
    'is_current',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_current" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    cardId,
    company,
    title,
    startDate,
    endDate,
    isCurrent,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'digital_card_experiences';
  @override
  VerificationContext validateIntegrity(
    Insertable<DigitalCardExperienceRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('card_id')) {
      context.handle(
        _cardIdMeta,
        cardId.isAcceptableOrUnknown(data['card_id']!, _cardIdMeta),
      );
    } else if (isInserting) {
      context.missing(_cardIdMeta);
    }
    if (data.containsKey('company')) {
      context.handle(
        _companyMeta,
        company.isAcceptableOrUnknown(data['company']!, _companyMeta),
      );
    } else if (isInserting) {
      context.missing(_companyMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    }
    if (data.containsKey('end_date')) {
      context.handle(
        _endDateMeta,
        endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta),
      );
    }
    if (data.containsKey('is_current')) {
      context.handle(
        _isCurrentMeta,
        isCurrent.isAcceptableOrUnknown(data['is_current']!, _isCurrentMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DigitalCardExperienceRow map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DigitalCardExperienceRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      cardId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}card_id'],
      )!,
      company: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}company'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_date'],
      ),
      endDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end_date'],
      ),
      isCurrent: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_current'],
      )!,
    );
  }

  @override
  $DigitalCardExperiencesTable createAlias(String alias) {
    return $DigitalCardExperiencesTable(attachedDatabase, alias);
  }
}

class DigitalCardExperienceRow extends DataClass
    implements Insertable<DigitalCardExperienceRow> {
  final String id;
  final String cardId;
  final String company;
  final String title;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool isCurrent;
  const DigitalCardExperienceRow({
    required this.id,
    required this.cardId,
    required this.company,
    required this.title,
    this.startDate,
    this.endDate,
    required this.isCurrent,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['card_id'] = Variable<String>(cardId);
    map['company'] = Variable<String>(company);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || startDate != null) {
      map['start_date'] = Variable<DateTime>(startDate);
    }
    if (!nullToAbsent || endDate != null) {
      map['end_date'] = Variable<DateTime>(endDate);
    }
    map['is_current'] = Variable<bool>(isCurrent);
    return map;
  }

  DigitalCardExperiencesCompanion toCompanion(bool nullToAbsent) {
    return DigitalCardExperiencesCompanion(
      id: Value(id),
      cardId: Value(cardId),
      company: Value(company),
      title: Value(title),
      startDate: startDate == null && nullToAbsent
          ? const Value.absent()
          : Value(startDate),
      endDate: endDate == null && nullToAbsent
          ? const Value.absent()
          : Value(endDate),
      isCurrent: Value(isCurrent),
    );
  }

  factory DigitalCardExperienceRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DigitalCardExperienceRow(
      id: serializer.fromJson<String>(json['id']),
      cardId: serializer.fromJson<String>(json['cardId']),
      company: serializer.fromJson<String>(json['company']),
      title: serializer.fromJson<String>(json['title']),
      startDate: serializer.fromJson<DateTime?>(json['startDate']),
      endDate: serializer.fromJson<DateTime?>(json['endDate']),
      isCurrent: serializer.fromJson<bool>(json['isCurrent']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'cardId': serializer.toJson<String>(cardId),
      'company': serializer.toJson<String>(company),
      'title': serializer.toJson<String>(title),
      'startDate': serializer.toJson<DateTime?>(startDate),
      'endDate': serializer.toJson<DateTime?>(endDate),
      'isCurrent': serializer.toJson<bool>(isCurrent),
    };
  }

  DigitalCardExperienceRow copyWith({
    String? id,
    String? cardId,
    String? company,
    String? title,
    Value<DateTime?> startDate = const Value.absent(),
    Value<DateTime?> endDate = const Value.absent(),
    bool? isCurrent,
  }) => DigitalCardExperienceRow(
    id: id ?? this.id,
    cardId: cardId ?? this.cardId,
    company: company ?? this.company,
    title: title ?? this.title,
    startDate: startDate.present ? startDate.value : this.startDate,
    endDate: endDate.present ? endDate.value : this.endDate,
    isCurrent: isCurrent ?? this.isCurrent,
  );
  DigitalCardExperienceRow copyWithCompanion(
    DigitalCardExperiencesCompanion data,
  ) {
    return DigitalCardExperienceRow(
      id: data.id.present ? data.id.value : this.id,
      cardId: data.cardId.present ? data.cardId.value : this.cardId,
      company: data.company.present ? data.company.value : this.company,
      title: data.title.present ? data.title.value : this.title,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      isCurrent: data.isCurrent.present ? data.isCurrent.value : this.isCurrent,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DigitalCardExperienceRow(')
          ..write('id: $id, ')
          ..write('cardId: $cardId, ')
          ..write('company: $company, ')
          ..write('title: $title, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('isCurrent: $isCurrent')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, cardId, company, title, startDate, endDate, isCurrent);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DigitalCardExperienceRow &&
          other.id == this.id &&
          other.cardId == this.cardId &&
          other.company == this.company &&
          other.title == this.title &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.isCurrent == this.isCurrent);
}

class DigitalCardExperiencesCompanion
    extends UpdateCompanion<DigitalCardExperienceRow> {
  final Value<String> id;
  final Value<String> cardId;
  final Value<String> company;
  final Value<String> title;
  final Value<DateTime?> startDate;
  final Value<DateTime?> endDate;
  final Value<bool> isCurrent;
  final Value<int> rowid;
  const DigitalCardExperiencesCompanion({
    this.id = const Value.absent(),
    this.cardId = const Value.absent(),
    this.company = const Value.absent(),
    this.title = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.isCurrent = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DigitalCardExperiencesCompanion.insert({
    required String id,
    required String cardId,
    required String company,
    required String title,
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.isCurrent = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       cardId = Value(cardId),
       company = Value(company),
       title = Value(title);
  static Insertable<DigitalCardExperienceRow> custom({
    Expression<String>? id,
    Expression<String>? cardId,
    Expression<String>? company,
    Expression<String>? title,
    Expression<DateTime>? startDate,
    Expression<DateTime>? endDate,
    Expression<bool>? isCurrent,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (cardId != null) 'card_id': cardId,
      if (company != null) 'company': company,
      if (title != null) 'title': title,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (isCurrent != null) 'is_current': isCurrent,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DigitalCardExperiencesCompanion copyWith({
    Value<String>? id,
    Value<String>? cardId,
    Value<String>? company,
    Value<String>? title,
    Value<DateTime?>? startDate,
    Value<DateTime?>? endDate,
    Value<bool>? isCurrent,
    Value<int>? rowid,
  }) {
    return DigitalCardExperiencesCompanion(
      id: id ?? this.id,
      cardId: cardId ?? this.cardId,
      company: company ?? this.company,
      title: title ?? this.title,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isCurrent: isCurrent ?? this.isCurrent,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (cardId.present) {
      map['card_id'] = Variable<String>(cardId.value);
    }
    if (company.present) {
      map['company'] = Variable<String>(company.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<DateTime>(endDate.value);
    }
    if (isCurrent.present) {
      map['is_current'] = Variable<bool>(isCurrent.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DigitalCardExperiencesCompanion(')
          ..write('id: $id, ')
          ..write('cardId: $cardId, ')
          ..write('company: $company, ')
          ..write('title: $title, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('isCurrent: $isCurrent, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DigitalCardExtrasTable extends DigitalCardExtras
    with TableInfo<$DigitalCardExtrasTable, DigitalCardExtraRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DigitalCardExtrasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cardIdMeta = const VerificationMeta('cardId');
  @override
  late final GeneratedColumn<String> cardId = GeneratedColumn<String>(
    'card_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, cardId, kind, payload];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'digital_card_extras';
  @override
  VerificationContext validateIntegrity(
    Insertable<DigitalCardExtraRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('card_id')) {
      context.handle(
        _cardIdMeta,
        cardId.isAcceptableOrUnknown(data['card_id']!, _cardIdMeta),
      );
    } else if (isInserting) {
      context.missing(_cardIdMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DigitalCardExtraRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DigitalCardExtraRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      cardId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}card_id'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      )!,
    );
  }

  @override
  $DigitalCardExtrasTable createAlias(String alias) {
    return $DigitalCardExtrasTable(attachedDatabase, alias);
  }
}

class DigitalCardExtraRow extends DataClass
    implements Insertable<DigitalCardExtraRow> {
  final String id;
  final String cardId;
  final String kind;
  final String payload;
  const DigitalCardExtraRow({
    required this.id,
    required this.cardId,
    required this.kind,
    required this.payload,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['card_id'] = Variable<String>(cardId);
    map['kind'] = Variable<String>(kind);
    map['payload'] = Variable<String>(payload);
    return map;
  }

  DigitalCardExtrasCompanion toCompanion(bool nullToAbsent) {
    return DigitalCardExtrasCompanion(
      id: Value(id),
      cardId: Value(cardId),
      kind: Value(kind),
      payload: Value(payload),
    );
  }

  factory DigitalCardExtraRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DigitalCardExtraRow(
      id: serializer.fromJson<String>(json['id']),
      cardId: serializer.fromJson<String>(json['cardId']),
      kind: serializer.fromJson<String>(json['kind']),
      payload: serializer.fromJson<String>(json['payload']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'cardId': serializer.toJson<String>(cardId),
      'kind': serializer.toJson<String>(kind),
      'payload': serializer.toJson<String>(payload),
    };
  }

  DigitalCardExtraRow copyWith({
    String? id,
    String? cardId,
    String? kind,
    String? payload,
  }) => DigitalCardExtraRow(
    id: id ?? this.id,
    cardId: cardId ?? this.cardId,
    kind: kind ?? this.kind,
    payload: payload ?? this.payload,
  );
  DigitalCardExtraRow copyWithCompanion(DigitalCardExtrasCompanion data) {
    return DigitalCardExtraRow(
      id: data.id.present ? data.id.value : this.id,
      cardId: data.cardId.present ? data.cardId.value : this.cardId,
      kind: data.kind.present ? data.kind.value : this.kind,
      payload: data.payload.present ? data.payload.value : this.payload,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DigitalCardExtraRow(')
          ..write('id: $id, ')
          ..write('cardId: $cardId, ')
          ..write('kind: $kind, ')
          ..write('payload: $payload')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, cardId, kind, payload);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DigitalCardExtraRow &&
          other.id == this.id &&
          other.cardId == this.cardId &&
          other.kind == this.kind &&
          other.payload == this.payload);
}

class DigitalCardExtrasCompanion extends UpdateCompanion<DigitalCardExtraRow> {
  final Value<String> id;
  final Value<String> cardId;
  final Value<String> kind;
  final Value<String> payload;
  final Value<int> rowid;
  const DigitalCardExtrasCompanion({
    this.id = const Value.absent(),
    this.cardId = const Value.absent(),
    this.kind = const Value.absent(),
    this.payload = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DigitalCardExtrasCompanion.insert({
    required String id,
    required String cardId,
    required String kind,
    required String payload,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       cardId = Value(cardId),
       kind = Value(kind),
       payload = Value(payload);
  static Insertable<DigitalCardExtraRow> custom({
    Expression<String>? id,
    Expression<String>? cardId,
    Expression<String>? kind,
    Expression<String>? payload,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (cardId != null) 'card_id': cardId,
      if (kind != null) 'kind': kind,
      if (payload != null) 'payload': payload,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DigitalCardExtrasCompanion copyWith({
    Value<String>? id,
    Value<String>? cardId,
    Value<String>? kind,
    Value<String>? payload,
    Value<int>? rowid,
  }) {
    return DigitalCardExtrasCompanion(
      id: id ?? this.id,
      cardId: cardId ?? this.cardId,
      kind: kind ?? this.kind,
      payload: payload ?? this.payload,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (cardId.present) {
      map['card_id'] = Variable<String>(cardId.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DigitalCardExtrasCompanion(')
          ..write('id: $id, ')
          ..write('cardId: $cardId, ')
          ..write('kind: $kind, ')
          ..write('payload: $payload, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DigitalCardFieldsTable extends DigitalCardFields
    with TableInfo<$DigitalCardFieldsTable, DigitalCardFieldRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DigitalCardFieldsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cardIdMeta = const VerificationMeta('cardId');
  @override
  late final GeneratedColumn<String> cardId = GeneratedColumn<String>(
    'card_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _platformMeta = const VerificationMeta(
    'platform',
  );
  @override
  late final GeneratedColumn<String> platform = GeneratedColumn<String>(
    'platform',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    cardId,
    platform,
    label,
    value,
    sortOrder,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'digital_card_fields';
  @override
  VerificationContext validateIntegrity(
    Insertable<DigitalCardFieldRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('card_id')) {
      context.handle(
        _cardIdMeta,
        cardId.isAcceptableOrUnknown(data['card_id']!, _cardIdMeta),
      );
    } else if (isInserting) {
      context.missing(_cardIdMeta);
    }
    if (data.containsKey('platform')) {
      context.handle(
        _platformMeta,
        platform.isAcceptableOrUnknown(data['platform']!, _platformMeta),
      );
    } else if (isInserting) {
      context.missing(_platformMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DigitalCardFieldRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DigitalCardFieldRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      cardId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}card_id'],
      )!,
      platform: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}platform'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $DigitalCardFieldsTable createAlias(String alias) {
    return $DigitalCardFieldsTable(attachedDatabase, alias);
  }
}

class DigitalCardFieldRow extends DataClass
    implements Insertable<DigitalCardFieldRow> {
  final String id;
  final String cardId;
  final String platform;
  final String label;
  final String value;
  final int sortOrder;
  const DigitalCardFieldRow({
    required this.id,
    required this.cardId,
    required this.platform,
    required this.label,
    required this.value,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['card_id'] = Variable<String>(cardId);
    map['platform'] = Variable<String>(platform);
    map['label'] = Variable<String>(label);
    map['value'] = Variable<String>(value);
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  DigitalCardFieldsCompanion toCompanion(bool nullToAbsent) {
    return DigitalCardFieldsCompanion(
      id: Value(id),
      cardId: Value(cardId),
      platform: Value(platform),
      label: Value(label),
      value: Value(value),
      sortOrder: Value(sortOrder),
    );
  }

  factory DigitalCardFieldRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DigitalCardFieldRow(
      id: serializer.fromJson<String>(json['id']),
      cardId: serializer.fromJson<String>(json['cardId']),
      platform: serializer.fromJson<String>(json['platform']),
      label: serializer.fromJson<String>(json['label']),
      value: serializer.fromJson<String>(json['value']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'cardId': serializer.toJson<String>(cardId),
      'platform': serializer.toJson<String>(platform),
      'label': serializer.toJson<String>(label),
      'value': serializer.toJson<String>(value),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  DigitalCardFieldRow copyWith({
    String? id,
    String? cardId,
    String? platform,
    String? label,
    String? value,
    int? sortOrder,
  }) => DigitalCardFieldRow(
    id: id ?? this.id,
    cardId: cardId ?? this.cardId,
    platform: platform ?? this.platform,
    label: label ?? this.label,
    value: value ?? this.value,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  DigitalCardFieldRow copyWithCompanion(DigitalCardFieldsCompanion data) {
    return DigitalCardFieldRow(
      id: data.id.present ? data.id.value : this.id,
      cardId: data.cardId.present ? data.cardId.value : this.cardId,
      platform: data.platform.present ? data.platform.value : this.platform,
      label: data.label.present ? data.label.value : this.label,
      value: data.value.present ? data.value.value : this.value,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DigitalCardFieldRow(')
          ..write('id: $id, ')
          ..write('cardId: $cardId, ')
          ..write('platform: $platform, ')
          ..write('label: $label, ')
          ..write('value: $value, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, cardId, platform, label, value, sortOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DigitalCardFieldRow &&
          other.id == this.id &&
          other.cardId == this.cardId &&
          other.platform == this.platform &&
          other.label == this.label &&
          other.value == this.value &&
          other.sortOrder == this.sortOrder);
}

class DigitalCardFieldsCompanion extends UpdateCompanion<DigitalCardFieldRow> {
  final Value<String> id;
  final Value<String> cardId;
  final Value<String> platform;
  final Value<String> label;
  final Value<String> value;
  final Value<int> sortOrder;
  final Value<int> rowid;
  const DigitalCardFieldsCompanion({
    this.id = const Value.absent(),
    this.cardId = const Value.absent(),
    this.platform = const Value.absent(),
    this.label = const Value.absent(),
    this.value = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DigitalCardFieldsCompanion.insert({
    required String id,
    required String cardId,
    required String platform,
    required String label,
    required String value,
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       cardId = Value(cardId),
       platform = Value(platform),
       label = Value(label),
       value = Value(value);
  static Insertable<DigitalCardFieldRow> custom({
    Expression<String>? id,
    Expression<String>? cardId,
    Expression<String>? platform,
    Expression<String>? label,
    Expression<String>? value,
    Expression<int>? sortOrder,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (cardId != null) 'card_id': cardId,
      if (platform != null) 'platform': platform,
      if (label != null) 'label': label,
      if (value != null) 'value': value,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DigitalCardFieldsCompanion copyWith({
    Value<String>? id,
    Value<String>? cardId,
    Value<String>? platform,
    Value<String>? label,
    Value<String>? value,
    Value<int>? sortOrder,
    Value<int>? rowid,
  }) {
    return DigitalCardFieldsCompanion(
      id: id ?? this.id,
      cardId: cardId ?? this.cardId,
      platform: platform ?? this.platform,
      label: label ?? this.label,
      value: value ?? this.value,
      sortOrder: sortOrder ?? this.sortOrder,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (cardId.present) {
      map['card_id'] = Variable<String>(cardId.value);
    }
    if (platform.present) {
      map['platform'] = Variable<String>(platform.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DigitalCardFieldsCompanion(')
          ..write('id: $id, ')
          ..write('cardId: $cardId, ')
          ..write('platform: $platform, ')
          ..write('label: $label, ')
          ..write('value: $value, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ScannedCardsTable extends ScannedCards
    with TableInfo<$ScannedCardsTable, ScannedCardRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ScannedCardsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _profileImageUrlMeta = const VerificationMeta(
    'profileImageUrl',
  );
  @override
  late final GeneratedColumn<String> profileImageUrl = GeneratedColumn<String>(
    'profile_image_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _frontImageUrlMeta = const VerificationMeta(
    'frontImageUrl',
  );
  @override
  late final GeneratedColumn<String> frontImageUrl = GeneratedColumn<String>(
    'front_image_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _backImageUrlMeta = const VerificationMeta(
    'backImageUrl',
  );
  @override
  late final GeneratedColumn<String> backImageUrl = GeneratedColumn<String>(
    'back_image_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fullNameMeta = const VerificationMeta(
    'fullName',
  );
  @override
  late final GeneratedColumn<String> fullName = GeneratedColumn<String>(
    'full_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _companyMeta = const VerificationMeta(
    'company',
  );
  @override
  late final GeneratedColumn<String> company = GeneratedColumn<String>(
    'company',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _departmentMeta = const VerificationMeta(
    'department',
  );
  @override
  late final GeneratedColumn<String> department = GeneratedColumn<String>(
    'department',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _jobTitleMeta = const VerificationMeta(
    'jobTitle',
  );
  @override
  late final GeneratedColumn<String> jobTitle = GeneratedColumn<String>(
    'job_title',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sortByCompanyMeta = const VerificationMeta(
    'sortByCompany',
  );
  @override
  late final GeneratedColumn<bool> sortByCompany = GeneratedColumn<bool>(
    'sort_by_company',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("sort_by_company" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _rawOcrMeta = const VerificationMeta('rawOcr');
  @override
  late final GeneratedColumn<String> rawOcr = GeneratedColumn<String>(
    'raw_ocr',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastViewedAtMeta = const VerificationMeta(
    'lastViewedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastViewedAt = GeneratedColumn<DateTime>(
    'last_viewed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    profileImageUrl,
    frontImageUrl,
    backImageUrl,
    fullName,
    company,
    department,
    jobTitle,
    sortByCompany,
    rawOcr,
    lastViewedAt,
    deletedAt,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'scanned_cards';
  @override
  VerificationContext validateIntegrity(
    Insertable<ScannedCardRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('profile_image_url')) {
      context.handle(
        _profileImageUrlMeta,
        profileImageUrl.isAcceptableOrUnknown(
          data['profile_image_url']!,
          _profileImageUrlMeta,
        ),
      );
    }
    if (data.containsKey('front_image_url')) {
      context.handle(
        _frontImageUrlMeta,
        frontImageUrl.isAcceptableOrUnknown(
          data['front_image_url']!,
          _frontImageUrlMeta,
        ),
      );
    }
    if (data.containsKey('back_image_url')) {
      context.handle(
        _backImageUrlMeta,
        backImageUrl.isAcceptableOrUnknown(
          data['back_image_url']!,
          _backImageUrlMeta,
        ),
      );
    }
    if (data.containsKey('full_name')) {
      context.handle(
        _fullNameMeta,
        fullName.isAcceptableOrUnknown(data['full_name']!, _fullNameMeta),
      );
    }
    if (data.containsKey('company')) {
      context.handle(
        _companyMeta,
        company.isAcceptableOrUnknown(data['company']!, _companyMeta),
      );
    }
    if (data.containsKey('department')) {
      context.handle(
        _departmentMeta,
        department.isAcceptableOrUnknown(data['department']!, _departmentMeta),
      );
    }
    if (data.containsKey('job_title')) {
      context.handle(
        _jobTitleMeta,
        jobTitle.isAcceptableOrUnknown(data['job_title']!, _jobTitleMeta),
      );
    }
    if (data.containsKey('sort_by_company')) {
      context.handle(
        _sortByCompanyMeta,
        sortByCompany.isAcceptableOrUnknown(
          data['sort_by_company']!,
          _sortByCompanyMeta,
        ),
      );
    }
    if (data.containsKey('raw_ocr')) {
      context.handle(
        _rawOcrMeta,
        rawOcr.isAcceptableOrUnknown(data['raw_ocr']!, _rawOcrMeta),
      );
    }
    if (data.containsKey('last_viewed_at')) {
      context.handle(
        _lastViewedAtMeta,
        lastViewedAt.isAcceptableOrUnknown(
          data['last_viewed_at']!,
          _lastViewedAtMeta,
        ),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ScannedCardRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ScannedCardRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      profileImageUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}profile_image_url'],
      ),
      frontImageUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}front_image_url'],
      ),
      backImageUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}back_image_url'],
      ),
      fullName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}full_name'],
      ),
      company: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}company'],
      ),
      department: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}department'],
      ),
      jobTitle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}job_title'],
      ),
      sortByCompany: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}sort_by_company'],
      )!,
      rawOcr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}raw_ocr'],
      ),
      lastViewedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_viewed_at'],
      ),
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ScannedCardsTable createAlias(String alias) {
    return $ScannedCardsTable(attachedDatabase, alias);
  }
}

class ScannedCardRow extends DataClass implements Insertable<ScannedCardRow> {
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
  final String? rawOcr;
  final DateTime? lastViewedAt;
  final DateTime? deletedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  const ScannedCardRow({
    required this.id,
    required this.userId,
    this.profileImageUrl,
    this.frontImageUrl,
    this.backImageUrl,
    this.fullName,
    this.company,
    this.department,
    this.jobTitle,
    required this.sortByCompany,
    this.rawOcr,
    this.lastViewedAt,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    if (!nullToAbsent || profileImageUrl != null) {
      map['profile_image_url'] = Variable<String>(profileImageUrl);
    }
    if (!nullToAbsent || frontImageUrl != null) {
      map['front_image_url'] = Variable<String>(frontImageUrl);
    }
    if (!nullToAbsent || backImageUrl != null) {
      map['back_image_url'] = Variable<String>(backImageUrl);
    }
    if (!nullToAbsent || fullName != null) {
      map['full_name'] = Variable<String>(fullName);
    }
    if (!nullToAbsent || company != null) {
      map['company'] = Variable<String>(company);
    }
    if (!nullToAbsent || department != null) {
      map['department'] = Variable<String>(department);
    }
    if (!nullToAbsent || jobTitle != null) {
      map['job_title'] = Variable<String>(jobTitle);
    }
    map['sort_by_company'] = Variable<bool>(sortByCompany);
    if (!nullToAbsent || rawOcr != null) {
      map['raw_ocr'] = Variable<String>(rawOcr);
    }
    if (!nullToAbsent || lastViewedAt != null) {
      map['last_viewed_at'] = Variable<DateTime>(lastViewedAt);
    }
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ScannedCardsCompanion toCompanion(bool nullToAbsent) {
    return ScannedCardsCompanion(
      id: Value(id),
      userId: Value(userId),
      profileImageUrl: profileImageUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(profileImageUrl),
      frontImageUrl: frontImageUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(frontImageUrl),
      backImageUrl: backImageUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(backImageUrl),
      fullName: fullName == null && nullToAbsent
          ? const Value.absent()
          : Value(fullName),
      company: company == null && nullToAbsent
          ? const Value.absent()
          : Value(company),
      department: department == null && nullToAbsent
          ? const Value.absent()
          : Value(department),
      jobTitle: jobTitle == null && nullToAbsent
          ? const Value.absent()
          : Value(jobTitle),
      sortByCompany: Value(sortByCompany),
      rawOcr: rawOcr == null && nullToAbsent
          ? const Value.absent()
          : Value(rawOcr),
      lastViewedAt: lastViewedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastViewedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory ScannedCardRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ScannedCardRow(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      profileImageUrl: serializer.fromJson<String?>(json['profileImageUrl']),
      frontImageUrl: serializer.fromJson<String?>(json['frontImageUrl']),
      backImageUrl: serializer.fromJson<String?>(json['backImageUrl']),
      fullName: serializer.fromJson<String?>(json['fullName']),
      company: serializer.fromJson<String?>(json['company']),
      department: serializer.fromJson<String?>(json['department']),
      jobTitle: serializer.fromJson<String?>(json['jobTitle']),
      sortByCompany: serializer.fromJson<bool>(json['sortByCompany']),
      rawOcr: serializer.fromJson<String?>(json['rawOcr']),
      lastViewedAt: serializer.fromJson<DateTime?>(json['lastViewedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'profileImageUrl': serializer.toJson<String?>(profileImageUrl),
      'frontImageUrl': serializer.toJson<String?>(frontImageUrl),
      'backImageUrl': serializer.toJson<String?>(backImageUrl),
      'fullName': serializer.toJson<String?>(fullName),
      'company': serializer.toJson<String?>(company),
      'department': serializer.toJson<String?>(department),
      'jobTitle': serializer.toJson<String?>(jobTitle),
      'sortByCompany': serializer.toJson<bool>(sortByCompany),
      'rawOcr': serializer.toJson<String?>(rawOcr),
      'lastViewedAt': serializer.toJson<DateTime?>(lastViewedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ScannedCardRow copyWith({
    String? id,
    String? userId,
    Value<String?> profileImageUrl = const Value.absent(),
    Value<String?> frontImageUrl = const Value.absent(),
    Value<String?> backImageUrl = const Value.absent(),
    Value<String?> fullName = const Value.absent(),
    Value<String?> company = const Value.absent(),
    Value<String?> department = const Value.absent(),
    Value<String?> jobTitle = const Value.absent(),
    bool? sortByCompany,
    Value<String?> rawOcr = const Value.absent(),
    Value<DateTime?> lastViewedAt = const Value.absent(),
    Value<DateTime?> deletedAt = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => ScannedCardRow(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    profileImageUrl: profileImageUrl.present
        ? profileImageUrl.value
        : this.profileImageUrl,
    frontImageUrl: frontImageUrl.present
        ? frontImageUrl.value
        : this.frontImageUrl,
    backImageUrl: backImageUrl.present ? backImageUrl.value : this.backImageUrl,
    fullName: fullName.present ? fullName.value : this.fullName,
    company: company.present ? company.value : this.company,
    department: department.present ? department.value : this.department,
    jobTitle: jobTitle.present ? jobTitle.value : this.jobTitle,
    sortByCompany: sortByCompany ?? this.sortByCompany,
    rawOcr: rawOcr.present ? rawOcr.value : this.rawOcr,
    lastViewedAt: lastViewedAt.present ? lastViewedAt.value : this.lastViewedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ScannedCardRow copyWithCompanion(ScannedCardsCompanion data) {
    return ScannedCardRow(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      profileImageUrl: data.profileImageUrl.present
          ? data.profileImageUrl.value
          : this.profileImageUrl,
      frontImageUrl: data.frontImageUrl.present
          ? data.frontImageUrl.value
          : this.frontImageUrl,
      backImageUrl: data.backImageUrl.present
          ? data.backImageUrl.value
          : this.backImageUrl,
      fullName: data.fullName.present ? data.fullName.value : this.fullName,
      company: data.company.present ? data.company.value : this.company,
      department: data.department.present
          ? data.department.value
          : this.department,
      jobTitle: data.jobTitle.present ? data.jobTitle.value : this.jobTitle,
      sortByCompany: data.sortByCompany.present
          ? data.sortByCompany.value
          : this.sortByCompany,
      rawOcr: data.rawOcr.present ? data.rawOcr.value : this.rawOcr,
      lastViewedAt: data.lastViewedAt.present
          ? data.lastViewedAt.value
          : this.lastViewedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ScannedCardRow(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('profileImageUrl: $profileImageUrl, ')
          ..write('frontImageUrl: $frontImageUrl, ')
          ..write('backImageUrl: $backImageUrl, ')
          ..write('fullName: $fullName, ')
          ..write('company: $company, ')
          ..write('department: $department, ')
          ..write('jobTitle: $jobTitle, ')
          ..write('sortByCompany: $sortByCompany, ')
          ..write('rawOcr: $rawOcr, ')
          ..write('lastViewedAt: $lastViewedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    profileImageUrl,
    frontImageUrl,
    backImageUrl,
    fullName,
    company,
    department,
    jobTitle,
    sortByCompany,
    rawOcr,
    lastViewedAt,
    deletedAt,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ScannedCardRow &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.profileImageUrl == this.profileImageUrl &&
          other.frontImageUrl == this.frontImageUrl &&
          other.backImageUrl == this.backImageUrl &&
          other.fullName == this.fullName &&
          other.company == this.company &&
          other.department == this.department &&
          other.jobTitle == this.jobTitle &&
          other.sortByCompany == this.sortByCompany &&
          other.rawOcr == this.rawOcr &&
          other.lastViewedAt == this.lastViewedAt &&
          other.deletedAt == this.deletedAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ScannedCardsCompanion extends UpdateCompanion<ScannedCardRow> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String?> profileImageUrl;
  final Value<String?> frontImageUrl;
  final Value<String?> backImageUrl;
  final Value<String?> fullName;
  final Value<String?> company;
  final Value<String?> department;
  final Value<String?> jobTitle;
  final Value<bool> sortByCompany;
  final Value<String?> rawOcr;
  final Value<DateTime?> lastViewedAt;
  final Value<DateTime?> deletedAt;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const ScannedCardsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.profileImageUrl = const Value.absent(),
    this.frontImageUrl = const Value.absent(),
    this.backImageUrl = const Value.absent(),
    this.fullName = const Value.absent(),
    this.company = const Value.absent(),
    this.department = const Value.absent(),
    this.jobTitle = const Value.absent(),
    this.sortByCompany = const Value.absent(),
    this.rawOcr = const Value.absent(),
    this.lastViewedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ScannedCardsCompanion.insert({
    required String id,
    required String userId,
    this.profileImageUrl = const Value.absent(),
    this.frontImageUrl = const Value.absent(),
    this.backImageUrl = const Value.absent(),
    this.fullName = const Value.absent(),
    this.company = const Value.absent(),
    this.department = const Value.absent(),
    this.jobTitle = const Value.absent(),
    this.sortByCompany = const Value.absent(),
    this.rawOcr = const Value.absent(),
    this.lastViewedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId);
  static Insertable<ScannedCardRow> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? profileImageUrl,
    Expression<String>? frontImageUrl,
    Expression<String>? backImageUrl,
    Expression<String>? fullName,
    Expression<String>? company,
    Expression<String>? department,
    Expression<String>? jobTitle,
    Expression<bool>? sortByCompany,
    Expression<String>? rawOcr,
    Expression<DateTime>? lastViewedAt,
    Expression<DateTime>? deletedAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (profileImageUrl != null) 'profile_image_url': profileImageUrl,
      if (frontImageUrl != null) 'front_image_url': frontImageUrl,
      if (backImageUrl != null) 'back_image_url': backImageUrl,
      if (fullName != null) 'full_name': fullName,
      if (company != null) 'company': company,
      if (department != null) 'department': department,
      if (jobTitle != null) 'job_title': jobTitle,
      if (sortByCompany != null) 'sort_by_company': sortByCompany,
      if (rawOcr != null) 'raw_ocr': rawOcr,
      if (lastViewedAt != null) 'last_viewed_at': lastViewedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ScannedCardsCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<String?>? profileImageUrl,
    Value<String?>? frontImageUrl,
    Value<String?>? backImageUrl,
    Value<String?>? fullName,
    Value<String?>? company,
    Value<String?>? department,
    Value<String?>? jobTitle,
    Value<bool>? sortByCompany,
    Value<String?>? rawOcr,
    Value<DateTime?>? lastViewedAt,
    Value<DateTime?>? deletedAt,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return ScannedCardsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
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
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (profileImageUrl.present) {
      map['profile_image_url'] = Variable<String>(profileImageUrl.value);
    }
    if (frontImageUrl.present) {
      map['front_image_url'] = Variable<String>(frontImageUrl.value);
    }
    if (backImageUrl.present) {
      map['back_image_url'] = Variable<String>(backImageUrl.value);
    }
    if (fullName.present) {
      map['full_name'] = Variable<String>(fullName.value);
    }
    if (company.present) {
      map['company'] = Variable<String>(company.value);
    }
    if (department.present) {
      map['department'] = Variable<String>(department.value);
    }
    if (jobTitle.present) {
      map['job_title'] = Variable<String>(jobTitle.value);
    }
    if (sortByCompany.present) {
      map['sort_by_company'] = Variable<bool>(sortByCompany.value);
    }
    if (rawOcr.present) {
      map['raw_ocr'] = Variable<String>(rawOcr.value);
    }
    if (lastViewedAt.present) {
      map['last_viewed_at'] = Variable<DateTime>(lastViewedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ScannedCardsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('profileImageUrl: $profileImageUrl, ')
          ..write('frontImageUrl: $frontImageUrl, ')
          ..write('backImageUrl: $backImageUrl, ')
          ..write('fullName: $fullName, ')
          ..write('company: $company, ')
          ..write('department: $department, ')
          ..write('jobTitle: $jobTitle, ')
          ..write('sortByCompany: $sortByCompany, ')
          ..write('rawOcr: $rawOcr, ')
          ..write('lastViewedAt: $lastViewedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ScannedCardFieldsTable extends ScannedCardFields
    with TableInfo<$ScannedCardFieldsTable, ScannedCardFieldRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ScannedCardFieldsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cardIdMeta = const VerificationMeta('cardId');
  @override
  late final GeneratedColumn<String> cardId = GeneratedColumn<String>(
    'card_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fieldTypeMeta = const VerificationMeta(
    'fieldType',
  );
  @override
  late final GeneratedColumn<String> fieldType = GeneratedColumn<String>(
    'field_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _addressDetailMeta = const VerificationMeta(
    'addressDetail',
  );
  @override
  late final GeneratedColumn<String> addressDetail = GeneratedColumn<String>(
    'address_detail',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    cardId,
    fieldType,
    label,
    value,
    addressDetail,
    sortOrder,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'scanned_card_fields';
  @override
  VerificationContext validateIntegrity(
    Insertable<ScannedCardFieldRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('card_id')) {
      context.handle(
        _cardIdMeta,
        cardId.isAcceptableOrUnknown(data['card_id']!, _cardIdMeta),
      );
    } else if (isInserting) {
      context.missing(_cardIdMeta);
    }
    if (data.containsKey('field_type')) {
      context.handle(
        _fieldTypeMeta,
        fieldType.isAcceptableOrUnknown(data['field_type']!, _fieldTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_fieldTypeMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('address_detail')) {
      context.handle(
        _addressDetailMeta,
        addressDetail.isAcceptableOrUnknown(
          data['address_detail']!,
          _addressDetailMeta,
        ),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ScannedCardFieldRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ScannedCardFieldRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      cardId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}card_id'],
      )!,
      fieldType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}field_type'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
      addressDetail: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address_detail'],
      ),
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $ScannedCardFieldsTable createAlias(String alias) {
    return $ScannedCardFieldsTable(attachedDatabase, alias);
  }
}

class ScannedCardFieldRow extends DataClass
    implements Insertable<ScannedCardFieldRow> {
  final String id;
  final String cardId;
  final String fieldType;
  final String label;
  final String value;
  final String? addressDetail;
  final int sortOrder;
  const ScannedCardFieldRow({
    required this.id,
    required this.cardId,
    required this.fieldType,
    required this.label,
    required this.value,
    this.addressDetail,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['card_id'] = Variable<String>(cardId);
    map['field_type'] = Variable<String>(fieldType);
    map['label'] = Variable<String>(label);
    map['value'] = Variable<String>(value);
    if (!nullToAbsent || addressDetail != null) {
      map['address_detail'] = Variable<String>(addressDetail);
    }
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  ScannedCardFieldsCompanion toCompanion(bool nullToAbsent) {
    return ScannedCardFieldsCompanion(
      id: Value(id),
      cardId: Value(cardId),
      fieldType: Value(fieldType),
      label: Value(label),
      value: Value(value),
      addressDetail: addressDetail == null && nullToAbsent
          ? const Value.absent()
          : Value(addressDetail),
      sortOrder: Value(sortOrder),
    );
  }

  factory ScannedCardFieldRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ScannedCardFieldRow(
      id: serializer.fromJson<String>(json['id']),
      cardId: serializer.fromJson<String>(json['cardId']),
      fieldType: serializer.fromJson<String>(json['fieldType']),
      label: serializer.fromJson<String>(json['label']),
      value: serializer.fromJson<String>(json['value']),
      addressDetail: serializer.fromJson<String?>(json['addressDetail']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'cardId': serializer.toJson<String>(cardId),
      'fieldType': serializer.toJson<String>(fieldType),
      'label': serializer.toJson<String>(label),
      'value': serializer.toJson<String>(value),
      'addressDetail': serializer.toJson<String?>(addressDetail),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  ScannedCardFieldRow copyWith({
    String? id,
    String? cardId,
    String? fieldType,
    String? label,
    String? value,
    Value<String?> addressDetail = const Value.absent(),
    int? sortOrder,
  }) => ScannedCardFieldRow(
    id: id ?? this.id,
    cardId: cardId ?? this.cardId,
    fieldType: fieldType ?? this.fieldType,
    label: label ?? this.label,
    value: value ?? this.value,
    addressDetail: addressDetail.present
        ? addressDetail.value
        : this.addressDetail,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  ScannedCardFieldRow copyWithCompanion(ScannedCardFieldsCompanion data) {
    return ScannedCardFieldRow(
      id: data.id.present ? data.id.value : this.id,
      cardId: data.cardId.present ? data.cardId.value : this.cardId,
      fieldType: data.fieldType.present ? data.fieldType.value : this.fieldType,
      label: data.label.present ? data.label.value : this.label,
      value: data.value.present ? data.value.value : this.value,
      addressDetail: data.addressDetail.present
          ? data.addressDetail.value
          : this.addressDetail,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ScannedCardFieldRow(')
          ..write('id: $id, ')
          ..write('cardId: $cardId, ')
          ..write('fieldType: $fieldType, ')
          ..write('label: $label, ')
          ..write('value: $value, ')
          ..write('addressDetail: $addressDetail, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    cardId,
    fieldType,
    label,
    value,
    addressDetail,
    sortOrder,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ScannedCardFieldRow &&
          other.id == this.id &&
          other.cardId == this.cardId &&
          other.fieldType == this.fieldType &&
          other.label == this.label &&
          other.value == this.value &&
          other.addressDetail == this.addressDetail &&
          other.sortOrder == this.sortOrder);
}

class ScannedCardFieldsCompanion extends UpdateCompanion<ScannedCardFieldRow> {
  final Value<String> id;
  final Value<String> cardId;
  final Value<String> fieldType;
  final Value<String> label;
  final Value<String> value;
  final Value<String?> addressDetail;
  final Value<int> sortOrder;
  final Value<int> rowid;
  const ScannedCardFieldsCompanion({
    this.id = const Value.absent(),
    this.cardId = const Value.absent(),
    this.fieldType = const Value.absent(),
    this.label = const Value.absent(),
    this.value = const Value.absent(),
    this.addressDetail = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ScannedCardFieldsCompanion.insert({
    required String id,
    required String cardId,
    required String fieldType,
    required String label,
    required String value,
    this.addressDetail = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       cardId = Value(cardId),
       fieldType = Value(fieldType),
       label = Value(label),
       value = Value(value);
  static Insertable<ScannedCardFieldRow> custom({
    Expression<String>? id,
    Expression<String>? cardId,
    Expression<String>? fieldType,
    Expression<String>? label,
    Expression<String>? value,
    Expression<String>? addressDetail,
    Expression<int>? sortOrder,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (cardId != null) 'card_id': cardId,
      if (fieldType != null) 'field_type': fieldType,
      if (label != null) 'label': label,
      if (value != null) 'value': value,
      if (addressDetail != null) 'address_detail': addressDetail,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ScannedCardFieldsCompanion copyWith({
    Value<String>? id,
    Value<String>? cardId,
    Value<String>? fieldType,
    Value<String>? label,
    Value<String>? value,
    Value<String?>? addressDetail,
    Value<int>? sortOrder,
    Value<int>? rowid,
  }) {
    return ScannedCardFieldsCompanion(
      id: id ?? this.id,
      cardId: cardId ?? this.cardId,
      fieldType: fieldType ?? this.fieldType,
      label: label ?? this.label,
      value: value ?? this.value,
      addressDetail: addressDetail ?? this.addressDetail,
      sortOrder: sortOrder ?? this.sortOrder,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (cardId.present) {
      map['card_id'] = Variable<String>(cardId.value);
    }
    if (fieldType.present) {
      map['field_type'] = Variable<String>(fieldType.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (addressDetail.present) {
      map['address_detail'] = Variable<String>(addressDetail.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ScannedCardFieldsCompanion(')
          ..write('id: $id, ')
          ..write('cardId: $cardId, ')
          ..write('fieldType: $fieldType, ')
          ..write('label: $label, ')
          ..write('value: $value, ')
          ..write('addressDetail: $addressDetail, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CardGroupsTable extends CardGroups
    with TableInfo<$CardGroupsTable, CardGroupRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CardGroupsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, userId, name];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'card_groups';
  @override
  VerificationContext validateIntegrity(
    Insertable<CardGroupRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CardGroupRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CardGroupRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
    );
  }

  @override
  $CardGroupsTable createAlias(String alias) {
    return $CardGroupsTable(attachedDatabase, alias);
  }
}

class CardGroupRow extends DataClass implements Insertable<CardGroupRow> {
  final String id;
  final String userId;
  final String name;
  const CardGroupRow({
    required this.id,
    required this.userId,
    required this.name,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['name'] = Variable<String>(name);
    return map;
  }

  CardGroupsCompanion toCompanion(bool nullToAbsent) {
    return CardGroupsCompanion(
      id: Value(id),
      userId: Value(userId),
      name: Value(name),
    );
  }

  factory CardGroupRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CardGroupRow(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'name': serializer.toJson<String>(name),
    };
  }

  CardGroupRow copyWith({String? id, String? userId, String? name}) =>
      CardGroupRow(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        name: name ?? this.name,
      );
  CardGroupRow copyWithCompanion(CardGroupsCompanion data) {
    return CardGroupRow(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      name: data.name.present ? data.name.value : this.name,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CardGroupRow(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, userId, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CardGroupRow &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.name == this.name);
}

class CardGroupsCompanion extends UpdateCompanion<CardGroupRow> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> name;
  final Value<int> rowid;
  const CardGroupsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.name = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CardGroupsCompanion.insert({
    required String id,
    required String userId,
    required String name,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       name = Value(name);
  static Insertable<CardGroupRow> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? name,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (name != null) 'name': name,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CardGroupsCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<String>? name,
    Value<int>? rowid,
  }) {
    return CardGroupsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CardGroupsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('name: $name, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CardGroupMembersTable extends CardGroupMembers
    with TableInfo<$CardGroupMembersTable, CardGroupMemberRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CardGroupMembersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _groupIdMeta = const VerificationMeta(
    'groupId',
  );
  @override
  late final GeneratedColumn<String> groupId = GeneratedColumn<String>(
    'group_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cardIdMeta = const VerificationMeta('cardId');
  @override
  late final GeneratedColumn<String> cardId = GeneratedColumn<String>(
    'card_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [groupId, cardId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'card_group_members';
  @override
  VerificationContext validateIntegrity(
    Insertable<CardGroupMemberRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('group_id')) {
      context.handle(
        _groupIdMeta,
        groupId.isAcceptableOrUnknown(data['group_id']!, _groupIdMeta),
      );
    } else if (isInserting) {
      context.missing(_groupIdMeta);
    }
    if (data.containsKey('card_id')) {
      context.handle(
        _cardIdMeta,
        cardId.isAcceptableOrUnknown(data['card_id']!, _cardIdMeta),
      );
    } else if (isInserting) {
      context.missing(_cardIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {groupId, cardId};
  @override
  CardGroupMemberRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CardGroupMemberRow(
      groupId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}group_id'],
      )!,
      cardId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}card_id'],
      )!,
    );
  }

  @override
  $CardGroupMembersTable createAlias(String alias) {
    return $CardGroupMembersTable(attachedDatabase, alias);
  }
}

class CardGroupMemberRow extends DataClass
    implements Insertable<CardGroupMemberRow> {
  final String groupId;
  final String cardId;
  const CardGroupMemberRow({required this.groupId, required this.cardId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['group_id'] = Variable<String>(groupId);
    map['card_id'] = Variable<String>(cardId);
    return map;
  }

  CardGroupMembersCompanion toCompanion(bool nullToAbsent) {
    return CardGroupMembersCompanion(
      groupId: Value(groupId),
      cardId: Value(cardId),
    );
  }

  factory CardGroupMemberRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CardGroupMemberRow(
      groupId: serializer.fromJson<String>(json['groupId']),
      cardId: serializer.fromJson<String>(json['cardId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'groupId': serializer.toJson<String>(groupId),
      'cardId': serializer.toJson<String>(cardId),
    };
  }

  CardGroupMemberRow copyWith({String? groupId, String? cardId}) =>
      CardGroupMemberRow(
        groupId: groupId ?? this.groupId,
        cardId: cardId ?? this.cardId,
      );
  CardGroupMemberRow copyWithCompanion(CardGroupMembersCompanion data) {
    return CardGroupMemberRow(
      groupId: data.groupId.present ? data.groupId.value : this.groupId,
      cardId: data.cardId.present ? data.cardId.value : this.cardId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CardGroupMemberRow(')
          ..write('groupId: $groupId, ')
          ..write('cardId: $cardId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(groupId, cardId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CardGroupMemberRow &&
          other.groupId == this.groupId &&
          other.cardId == this.cardId);
}

class CardGroupMembersCompanion extends UpdateCompanion<CardGroupMemberRow> {
  final Value<String> groupId;
  final Value<String> cardId;
  final Value<int> rowid;
  const CardGroupMembersCompanion({
    this.groupId = const Value.absent(),
    this.cardId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CardGroupMembersCompanion.insert({
    required String groupId,
    required String cardId,
    this.rowid = const Value.absent(),
  }) : groupId = Value(groupId),
       cardId = Value(cardId);
  static Insertable<CardGroupMemberRow> custom({
    Expression<String>? groupId,
    Expression<String>? cardId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (groupId != null) 'group_id': groupId,
      if (cardId != null) 'card_id': cardId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CardGroupMembersCompanion copyWith({
    Value<String>? groupId,
    Value<String>? cardId,
    Value<int>? rowid,
  }) {
    return CardGroupMembersCompanion(
      groupId: groupId ?? this.groupId,
      cardId: cardId ?? this.cardId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (groupId.present) {
      map['group_id'] = Variable<String>(groupId.value);
    }
    if (cardId.present) {
      map['card_id'] = Variable<String>(cardId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CardGroupMembersCompanion(')
          ..write('groupId: $groupId, ')
          ..write('cardId: $cardId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CardNotesTable extends CardNotes
    with TableInfo<$CardNotesTable, CardNoteRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CardNotesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cardIdMeta = const VerificationMeta('cardId');
  @override
  late final GeneratedColumn<String> cardId = GeneratedColumn<String>(
    'card_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteTypeMeta = const VerificationMeta(
    'noteType',
  );
  @override
  late final GeneratedColumn<String> noteType = GeneratedColumn<String>(
    'note_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    cardId,
    content,
    noteType,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'card_notes';
  @override
  VerificationContext validateIntegrity(
    Insertable<CardNoteRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('card_id')) {
      context.handle(
        _cardIdMeta,
        cardId.isAcceptableOrUnknown(data['card_id']!, _cardIdMeta),
      );
    } else if (isInserting) {
      context.missing(_cardIdMeta);
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('note_type')) {
      context.handle(
        _noteTypeMeta,
        noteType.isAcceptableOrUnknown(data['note_type']!, _noteTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_noteTypeMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CardNoteRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CardNoteRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      cardId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}card_id'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
      noteType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note_type'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $CardNotesTable createAlias(String alias) {
    return $CardNotesTable(attachedDatabase, alias);
  }
}

class CardNoteRow extends DataClass implements Insertable<CardNoteRow> {
  final String id;
  final String userId;
  final String cardId;
  final String content;
  final String noteType;
  final DateTime createdAt;
  const CardNoteRow({
    required this.id,
    required this.userId,
    required this.cardId,
    required this.content,
    required this.noteType,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['card_id'] = Variable<String>(cardId);
    map['content'] = Variable<String>(content);
    map['note_type'] = Variable<String>(noteType);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  CardNotesCompanion toCompanion(bool nullToAbsent) {
    return CardNotesCompanion(
      id: Value(id),
      userId: Value(userId),
      cardId: Value(cardId),
      content: Value(content),
      noteType: Value(noteType),
      createdAt: Value(createdAt),
    );
  }

  factory CardNoteRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CardNoteRow(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      cardId: serializer.fromJson<String>(json['cardId']),
      content: serializer.fromJson<String>(json['content']),
      noteType: serializer.fromJson<String>(json['noteType']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'cardId': serializer.toJson<String>(cardId),
      'content': serializer.toJson<String>(content),
      'noteType': serializer.toJson<String>(noteType),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  CardNoteRow copyWith({
    String? id,
    String? userId,
    String? cardId,
    String? content,
    String? noteType,
    DateTime? createdAt,
  }) => CardNoteRow(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    cardId: cardId ?? this.cardId,
    content: content ?? this.content,
    noteType: noteType ?? this.noteType,
    createdAt: createdAt ?? this.createdAt,
  );
  CardNoteRow copyWithCompanion(CardNotesCompanion data) {
    return CardNoteRow(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      cardId: data.cardId.present ? data.cardId.value : this.cardId,
      content: data.content.present ? data.content.value : this.content,
      noteType: data.noteType.present ? data.noteType.value : this.noteType,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CardNoteRow(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('cardId: $cardId, ')
          ..write('content: $content, ')
          ..write('noteType: $noteType, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, userId, cardId, content, noteType, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CardNoteRow &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.cardId == this.cardId &&
          other.content == this.content &&
          other.noteType == this.noteType &&
          other.createdAt == this.createdAt);
}

class CardNotesCompanion extends UpdateCompanion<CardNoteRow> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> cardId;
  final Value<String> content;
  final Value<String> noteType;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const CardNotesCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.cardId = const Value.absent(),
    this.content = const Value.absent(),
    this.noteType = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CardNotesCompanion.insert({
    required String id,
    required String userId,
    required String cardId,
    required String content,
    required String noteType,
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       cardId = Value(cardId),
       content = Value(content),
       noteType = Value(noteType);
  static Insertable<CardNoteRow> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? cardId,
    Expression<String>? content,
    Expression<String>? noteType,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (cardId != null) 'card_id': cardId,
      if (content != null) 'content': content,
      if (noteType != null) 'note_type': noteType,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CardNotesCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<String>? cardId,
    Value<String>? content,
    Value<String>? noteType,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return CardNotesCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      cardId: cardId ?? this.cardId,
      content: content ?? this.content,
      noteType: noteType ?? this.noteType,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (cardId.present) {
      map['card_id'] = Variable<String>(cardId.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (noteType.present) {
      map['note_type'] = Variable<String>(noteType.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CardNotesCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('cardId: $cardId, ')
          ..write('content: $content, ')
          ..write('noteType: $noteType, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CardRemindersTable extends CardReminders
    with TableInfo<$CardRemindersTable, CardReminderRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CardRemindersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cardIdMeta = const VerificationMeta('cardId');
  @override
  late final GeneratedColumn<String> cardId = GeneratedColumn<String>(
    'card_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _remindAtMeta = const VerificationMeta(
    'remindAt',
  );
  @override
  late final GeneratedColumn<DateTime> remindAt = GeneratedColumn<DateTime>(
    'remind_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _messageMeta = const VerificationMeta(
    'message',
  );
  @override
  late final GeneratedColumn<String> message = GeneratedColumn<String>(
    'message',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, userId, cardId, remindAt, message];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'card_reminders';
  @override
  VerificationContext validateIntegrity(
    Insertable<CardReminderRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('card_id')) {
      context.handle(
        _cardIdMeta,
        cardId.isAcceptableOrUnknown(data['card_id']!, _cardIdMeta),
      );
    } else if (isInserting) {
      context.missing(_cardIdMeta);
    }
    if (data.containsKey('remind_at')) {
      context.handle(
        _remindAtMeta,
        remindAt.isAcceptableOrUnknown(data['remind_at']!, _remindAtMeta),
      );
    } else if (isInserting) {
      context.missing(_remindAtMeta);
    }
    if (data.containsKey('message')) {
      context.handle(
        _messageMeta,
        message.isAcceptableOrUnknown(data['message']!, _messageMeta),
      );
    } else if (isInserting) {
      context.missing(_messageMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CardReminderRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CardReminderRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      cardId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}card_id'],
      )!,
      remindAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}remind_at'],
      )!,
      message: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}message'],
      )!,
    );
  }

  @override
  $CardRemindersTable createAlias(String alias) {
    return $CardRemindersTable(attachedDatabase, alias);
  }
}

class CardReminderRow extends DataClass implements Insertable<CardReminderRow> {
  final String id;
  final String userId;
  final String cardId;
  final DateTime remindAt;
  final String message;
  const CardReminderRow({
    required this.id,
    required this.userId,
    required this.cardId,
    required this.remindAt,
    required this.message,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['card_id'] = Variable<String>(cardId);
    map['remind_at'] = Variable<DateTime>(remindAt);
    map['message'] = Variable<String>(message);
    return map;
  }

  CardRemindersCompanion toCompanion(bool nullToAbsent) {
    return CardRemindersCompanion(
      id: Value(id),
      userId: Value(userId),
      cardId: Value(cardId),
      remindAt: Value(remindAt),
      message: Value(message),
    );
  }

  factory CardReminderRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CardReminderRow(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      cardId: serializer.fromJson<String>(json['cardId']),
      remindAt: serializer.fromJson<DateTime>(json['remindAt']),
      message: serializer.fromJson<String>(json['message']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'cardId': serializer.toJson<String>(cardId),
      'remindAt': serializer.toJson<DateTime>(remindAt),
      'message': serializer.toJson<String>(message),
    };
  }

  CardReminderRow copyWith({
    String? id,
    String? userId,
    String? cardId,
    DateTime? remindAt,
    String? message,
  }) => CardReminderRow(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    cardId: cardId ?? this.cardId,
    remindAt: remindAt ?? this.remindAt,
    message: message ?? this.message,
  );
  CardReminderRow copyWithCompanion(CardRemindersCompanion data) {
    return CardReminderRow(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      cardId: data.cardId.present ? data.cardId.value : this.cardId,
      remindAt: data.remindAt.present ? data.remindAt.value : this.remindAt,
      message: data.message.present ? data.message.value : this.message,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CardReminderRow(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('cardId: $cardId, ')
          ..write('remindAt: $remindAt, ')
          ..write('message: $message')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, userId, cardId, remindAt, message);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CardReminderRow &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.cardId == this.cardId &&
          other.remindAt == this.remindAt &&
          other.message == this.message);
}

class CardRemindersCompanion extends UpdateCompanion<CardReminderRow> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> cardId;
  final Value<DateTime> remindAt;
  final Value<String> message;
  final Value<int> rowid;
  const CardRemindersCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.cardId = const Value.absent(),
    this.remindAt = const Value.absent(),
    this.message = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CardRemindersCompanion.insert({
    required String id,
    required String userId,
    required String cardId,
    required DateTime remindAt,
    required String message,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       cardId = Value(cardId),
       remindAt = Value(remindAt),
       message = Value(message);
  static Insertable<CardReminderRow> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? cardId,
    Expression<DateTime>? remindAt,
    Expression<String>? message,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (cardId != null) 'card_id': cardId,
      if (remindAt != null) 'remind_at': remindAt,
      if (message != null) 'message': message,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CardRemindersCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<String>? cardId,
    Value<DateTime>? remindAt,
    Value<String>? message,
    Value<int>? rowid,
  }) {
    return CardRemindersCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      cardId: cardId ?? this.cardId,
      remindAt: remindAt ?? this.remindAt,
      message: message ?? this.message,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (cardId.present) {
      map['card_id'] = Variable<String>(cardId.value);
    }
    if (remindAt.present) {
      map['remind_at'] = Variable<DateTime>(remindAt.value);
    }
    if (message.present) {
      map['message'] = Variable<String>(message.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CardRemindersCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('cardId: $cardId, ')
          ..write('remindAt: $remindAt, ')
          ..write('message: $message, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AppNotificationsTable extends AppNotifications
    with TableInfo<$AppNotificationsTable, AppNotificationRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppNotificationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
    'body',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isReadMeta = const VerificationMeta('isRead');
  @override
  late final GeneratedColumn<bool> isRead = GeneratedColumn<bool>(
    'is_read',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_read" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    title,
    body,
    isRead,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_notifications';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppNotificationRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('body')) {
      context.handle(
        _bodyMeta,
        body.isAcceptableOrUnknown(data['body']!, _bodyMeta),
      );
    } else if (isInserting) {
      context.missing(_bodyMeta);
    }
    if (data.containsKey('is_read')) {
      context.handle(
        _isReadMeta,
        isRead.isAcceptableOrUnknown(data['is_read']!, _isReadMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AppNotificationRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppNotificationRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      body: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}body'],
      )!,
      isRead: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_read'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $AppNotificationsTable createAlias(String alias) {
    return $AppNotificationsTable(attachedDatabase, alias);
  }
}

class AppNotificationRow extends DataClass
    implements Insertable<AppNotificationRow> {
  final String id;
  final String userId;
  final String title;
  final String body;
  final bool isRead;
  final DateTime createdAt;
  const AppNotificationRow({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    required this.isRead,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['title'] = Variable<String>(title);
    map['body'] = Variable<String>(body);
    map['is_read'] = Variable<bool>(isRead);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  AppNotificationsCompanion toCompanion(bool nullToAbsent) {
    return AppNotificationsCompanion(
      id: Value(id),
      userId: Value(userId),
      title: Value(title),
      body: Value(body),
      isRead: Value(isRead),
      createdAt: Value(createdAt),
    );
  }

  factory AppNotificationRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppNotificationRow(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      title: serializer.fromJson<String>(json['title']),
      body: serializer.fromJson<String>(json['body']),
      isRead: serializer.fromJson<bool>(json['isRead']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'title': serializer.toJson<String>(title),
      'body': serializer.toJson<String>(body),
      'isRead': serializer.toJson<bool>(isRead),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  AppNotificationRow copyWith({
    String? id,
    String? userId,
    String? title,
    String? body,
    bool? isRead,
    DateTime? createdAt,
  }) => AppNotificationRow(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    title: title ?? this.title,
    body: body ?? this.body,
    isRead: isRead ?? this.isRead,
    createdAt: createdAt ?? this.createdAt,
  );
  AppNotificationRow copyWithCompanion(AppNotificationsCompanion data) {
    return AppNotificationRow(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      title: data.title.present ? data.title.value : this.title,
      body: data.body.present ? data.body.value : this.body,
      isRead: data.isRead.present ? data.isRead.value : this.isRead,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppNotificationRow(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('isRead: $isRead, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, userId, title, body, isRead, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppNotificationRow &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.title == this.title &&
          other.body == this.body &&
          other.isRead == this.isRead &&
          other.createdAt == this.createdAt);
}

class AppNotificationsCompanion extends UpdateCompanion<AppNotificationRow> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> title;
  final Value<String> body;
  final Value<bool> isRead;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const AppNotificationsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.title = const Value.absent(),
    this.body = const Value.absent(),
    this.isRead = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppNotificationsCompanion.insert({
    required String id,
    required String userId,
    required String title,
    required String body,
    this.isRead = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       title = Value(title),
       body = Value(body);
  static Insertable<AppNotificationRow> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? title,
    Expression<String>? body,
    Expression<bool>? isRead,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (title != null) 'title': title,
      if (body != null) 'body': body,
      if (isRead != null) 'is_read': isRead,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppNotificationsCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<String>? title,
    Value<String>? body,
    Value<bool>? isRead,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return AppNotificationsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      body: body ?? this.body,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (isRead.present) {
      map['is_read'] = Variable<bool>(isRead.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppNotificationsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('isRead: $isRead, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UserSettingsTableTable extends UserSettingsTable
    with TableInfo<$UserSettingsTableTable, UserSettingsRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserSettingsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notificationsEnabledMeta =
      const VerificationMeta('notificationsEnabled');
  @override
  late final GeneratedColumn<bool> notificationsEnabled = GeneratedColumn<bool>(
    'notifications_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("notifications_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _soundMeta = const VerificationMeta('sound');
  @override
  late final GeneratedColumn<bool> sound = GeneratedColumn<bool>(
    'sound',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("sound" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _vibrateMeta = const VerificationMeta(
    'vibrate',
  );
  @override
  late final GeneratedColumn<bool> vibrate = GeneratedColumn<bool>(
    'vibrate',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("vibrate" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _languageMeta = const VerificationMeta(
    'language',
  );
  @override
  late final GeneratedColumn<String> language = GeneratedColumn<String>(
    'language',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    userId,
    notificationsEnabled,
    sound,
    vibrate,
    language,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_settings_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserSettingsRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('notifications_enabled')) {
      context.handle(
        _notificationsEnabledMeta,
        notificationsEnabled.isAcceptableOrUnknown(
          data['notifications_enabled']!,
          _notificationsEnabledMeta,
        ),
      );
    }
    if (data.containsKey('sound')) {
      context.handle(
        _soundMeta,
        sound.isAcceptableOrUnknown(data['sound']!, _soundMeta),
      );
    }
    if (data.containsKey('vibrate')) {
      context.handle(
        _vibrateMeta,
        vibrate.isAcceptableOrUnknown(data['vibrate']!, _vibrateMeta),
      );
    }
    if (data.containsKey('language')) {
      context.handle(
        _languageMeta,
        language.isAcceptableOrUnknown(data['language']!, _languageMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {userId};
  @override
  UserSettingsRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserSettingsRow(
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      notificationsEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}notifications_enabled'],
      )!,
      sound: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}sound'],
      )!,
      vibrate: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}vibrate'],
      )!,
      language: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}language'],
      ),
    );
  }

  @override
  $UserSettingsTableTable createAlias(String alias) {
    return $UserSettingsTableTable(attachedDatabase, alias);
  }
}

class UserSettingsRow extends DataClass implements Insertable<UserSettingsRow> {
  final String userId;
  final bool notificationsEnabled;
  final bool sound;
  final bool vibrate;
  final String? language;
  const UserSettingsRow({
    required this.userId,
    required this.notificationsEnabled,
    required this.sound,
    required this.vibrate,
    this.language,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['user_id'] = Variable<String>(userId);
    map['notifications_enabled'] = Variable<bool>(notificationsEnabled);
    map['sound'] = Variable<bool>(sound);
    map['vibrate'] = Variable<bool>(vibrate);
    if (!nullToAbsent || language != null) {
      map['language'] = Variable<String>(language);
    }
    return map;
  }

  UserSettingsTableCompanion toCompanion(bool nullToAbsent) {
    return UserSettingsTableCompanion(
      userId: Value(userId),
      notificationsEnabled: Value(notificationsEnabled),
      sound: Value(sound),
      vibrate: Value(vibrate),
      language: language == null && nullToAbsent
          ? const Value.absent()
          : Value(language),
    );
  }

  factory UserSettingsRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserSettingsRow(
      userId: serializer.fromJson<String>(json['userId']),
      notificationsEnabled: serializer.fromJson<bool>(
        json['notificationsEnabled'],
      ),
      sound: serializer.fromJson<bool>(json['sound']),
      vibrate: serializer.fromJson<bool>(json['vibrate']),
      language: serializer.fromJson<String?>(json['language']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'userId': serializer.toJson<String>(userId),
      'notificationsEnabled': serializer.toJson<bool>(notificationsEnabled),
      'sound': serializer.toJson<bool>(sound),
      'vibrate': serializer.toJson<bool>(vibrate),
      'language': serializer.toJson<String?>(language),
    };
  }

  UserSettingsRow copyWith({
    String? userId,
    bool? notificationsEnabled,
    bool? sound,
    bool? vibrate,
    Value<String?> language = const Value.absent(),
  }) => UserSettingsRow(
    userId: userId ?? this.userId,
    notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    sound: sound ?? this.sound,
    vibrate: vibrate ?? this.vibrate,
    language: language.present ? language.value : this.language,
  );
  UserSettingsRow copyWithCompanion(UserSettingsTableCompanion data) {
    return UserSettingsRow(
      userId: data.userId.present ? data.userId.value : this.userId,
      notificationsEnabled: data.notificationsEnabled.present
          ? data.notificationsEnabled.value
          : this.notificationsEnabled,
      sound: data.sound.present ? data.sound.value : this.sound,
      vibrate: data.vibrate.present ? data.vibrate.value : this.vibrate,
      language: data.language.present ? data.language.value : this.language,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserSettingsRow(')
          ..write('userId: $userId, ')
          ..write('notificationsEnabled: $notificationsEnabled, ')
          ..write('sound: $sound, ')
          ..write('vibrate: $vibrate, ')
          ..write('language: $language')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(userId, notificationsEnabled, sound, vibrate, language);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserSettingsRow &&
          other.userId == this.userId &&
          other.notificationsEnabled == this.notificationsEnabled &&
          other.sound == this.sound &&
          other.vibrate == this.vibrate &&
          other.language == this.language);
}

class UserSettingsTableCompanion extends UpdateCompanion<UserSettingsRow> {
  final Value<String> userId;
  final Value<bool> notificationsEnabled;
  final Value<bool> sound;
  final Value<bool> vibrate;
  final Value<String?> language;
  final Value<int> rowid;
  const UserSettingsTableCompanion({
    this.userId = const Value.absent(),
    this.notificationsEnabled = const Value.absent(),
    this.sound = const Value.absent(),
    this.vibrate = const Value.absent(),
    this.language = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UserSettingsTableCompanion.insert({
    required String userId,
    this.notificationsEnabled = const Value.absent(),
    this.sound = const Value.absent(),
    this.vibrate = const Value.absent(),
    this.language = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : userId = Value(userId);
  static Insertable<UserSettingsRow> custom({
    Expression<String>? userId,
    Expression<bool>? notificationsEnabled,
    Expression<bool>? sound,
    Expression<bool>? vibrate,
    Expression<String>? language,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (userId != null) 'user_id': userId,
      if (notificationsEnabled != null)
        'notifications_enabled': notificationsEnabled,
      if (sound != null) 'sound': sound,
      if (vibrate != null) 'vibrate': vibrate,
      if (language != null) 'language': language,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UserSettingsTableCompanion copyWith({
    Value<String>? userId,
    Value<bool>? notificationsEnabled,
    Value<bool>? sound,
    Value<bool>? vibrate,
    Value<String?>? language,
    Value<int>? rowid,
  }) {
    return UserSettingsTableCompanion(
      userId: userId ?? this.userId,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      sound: sound ?? this.sound,
      vibrate: vibrate ?? this.vibrate,
      language: language ?? this.language,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (notificationsEnabled.present) {
      map['notifications_enabled'] = Variable<bool>(notificationsEnabled.value);
    }
    if (sound.present) {
      map['sound'] = Variable<bool>(sound.value);
    }
    if (vibrate.present) {
      map['vibrate'] = Variable<bool>(vibrate.value);
    }
    if (language.present) {
      map['language'] = Variable<String>(language.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserSettingsTableCompanion(')
          ..write('userId: $userId, ')
          ..write('notificationsEnabled: $notificationsEnabled, ')
          ..write('sound: $sound, ')
          ..write('vibrate: $vibrate, ')
          ..write('language: $language, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PendingSyncQueueTable extends PendingSyncQueue
    with TableInfo<$PendingSyncQueueTable, PendingSyncQueueData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PendingSyncQueueTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _entityTableMeta = const VerificationMeta(
    'entityTable',
  );
  @override
  late final GeneratedColumn<String> entityTable = GeneratedColumn<String>(
    'entity_table',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityIdMeta = const VerificationMeta(
    'entityId',
  );
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
    'entity_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _operationMeta = const VerificationMeta(
    'operation',
  );
  @override
  late final GeneratedColumn<String> operation = GeneratedColumn<String>(
    'operation',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    entityTable,
    entityId,
    operation,
    payload,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pending_sync_queue';
  @override
  VerificationContext validateIntegrity(
    Insertable<PendingSyncQueueData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('entity_table')) {
      context.handle(
        _entityTableMeta,
        entityTable.isAcceptableOrUnknown(
          data['entity_table']!,
          _entityTableMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_entityTableMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(
        _entityIdMeta,
        entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('operation')) {
      context.handle(
        _operationMeta,
        operation.isAcceptableOrUnknown(data['operation']!, _operationMeta),
      );
    } else if (isInserting) {
      context.missing(_operationMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PendingSyncQueueData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PendingSyncQueueData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      entityTable: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_table'],
      )!,
      entityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_id'],
      )!,
      operation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}operation'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $PendingSyncQueueTable createAlias(String alias) {
    return $PendingSyncQueueTable(attachedDatabase, alias);
  }
}

class PendingSyncQueueData extends DataClass
    implements Insertable<PendingSyncQueueData> {
  final int id;
  final String entityTable;
  final String entityId;
  final String operation;
  final String payload;
  final DateTime createdAt;
  const PendingSyncQueueData({
    required this.id,
    required this.entityTable,
    required this.entityId,
    required this.operation,
    required this.payload,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['entity_table'] = Variable<String>(entityTable);
    map['entity_id'] = Variable<String>(entityId);
    map['operation'] = Variable<String>(operation);
    map['payload'] = Variable<String>(payload);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  PendingSyncQueueCompanion toCompanion(bool nullToAbsent) {
    return PendingSyncQueueCompanion(
      id: Value(id),
      entityTable: Value(entityTable),
      entityId: Value(entityId),
      operation: Value(operation),
      payload: Value(payload),
      createdAt: Value(createdAt),
    );
  }

  factory PendingSyncQueueData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PendingSyncQueueData(
      id: serializer.fromJson<int>(json['id']),
      entityTable: serializer.fromJson<String>(json['entityTable']),
      entityId: serializer.fromJson<String>(json['entityId']),
      operation: serializer.fromJson<String>(json['operation']),
      payload: serializer.fromJson<String>(json['payload']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'entityTable': serializer.toJson<String>(entityTable),
      'entityId': serializer.toJson<String>(entityId),
      'operation': serializer.toJson<String>(operation),
      'payload': serializer.toJson<String>(payload),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  PendingSyncQueueData copyWith({
    int? id,
    String? entityTable,
    String? entityId,
    String? operation,
    String? payload,
    DateTime? createdAt,
  }) => PendingSyncQueueData(
    id: id ?? this.id,
    entityTable: entityTable ?? this.entityTable,
    entityId: entityId ?? this.entityId,
    operation: operation ?? this.operation,
    payload: payload ?? this.payload,
    createdAt: createdAt ?? this.createdAt,
  );
  PendingSyncQueueData copyWithCompanion(PendingSyncQueueCompanion data) {
    return PendingSyncQueueData(
      id: data.id.present ? data.id.value : this.id,
      entityTable: data.entityTable.present
          ? data.entityTable.value
          : this.entityTable,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      operation: data.operation.present ? data.operation.value : this.operation,
      payload: data.payload.present ? data.payload.value : this.payload,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PendingSyncQueueData(')
          ..write('id: $id, ')
          ..write('entityTable: $entityTable, ')
          ..write('entityId: $entityId, ')
          ..write('operation: $operation, ')
          ..write('payload: $payload, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, entityTable, entityId, operation, payload, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PendingSyncQueueData &&
          other.id == this.id &&
          other.entityTable == this.entityTable &&
          other.entityId == this.entityId &&
          other.operation == this.operation &&
          other.payload == this.payload &&
          other.createdAt == this.createdAt);
}

class PendingSyncQueueCompanion extends UpdateCompanion<PendingSyncQueueData> {
  final Value<int> id;
  final Value<String> entityTable;
  final Value<String> entityId;
  final Value<String> operation;
  final Value<String> payload;
  final Value<DateTime> createdAt;
  const PendingSyncQueueCompanion({
    this.id = const Value.absent(),
    this.entityTable = const Value.absent(),
    this.entityId = const Value.absent(),
    this.operation = const Value.absent(),
    this.payload = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  PendingSyncQueueCompanion.insert({
    this.id = const Value.absent(),
    required String entityTable,
    required String entityId,
    required String operation,
    required String payload,
    this.createdAt = const Value.absent(),
  }) : entityTable = Value(entityTable),
       entityId = Value(entityId),
       operation = Value(operation),
       payload = Value(payload);
  static Insertable<PendingSyncQueueData> custom({
    Expression<int>? id,
    Expression<String>? entityTable,
    Expression<String>? entityId,
    Expression<String>? operation,
    Expression<String>? payload,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (entityTable != null) 'entity_table': entityTable,
      if (entityId != null) 'entity_id': entityId,
      if (operation != null) 'operation': operation,
      if (payload != null) 'payload': payload,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  PendingSyncQueueCompanion copyWith({
    Value<int>? id,
    Value<String>? entityTable,
    Value<String>? entityId,
    Value<String>? operation,
    Value<String>? payload,
    Value<DateTime>? createdAt,
  }) {
    return PendingSyncQueueCompanion(
      id: id ?? this.id,
      entityTable: entityTable ?? this.entityTable,
      entityId: entityId ?? this.entityId,
      operation: operation ?? this.operation,
      payload: payload ?? this.payload,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (entityTable.present) {
      map['entity_table'] = Variable<String>(entityTable.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (operation.present) {
      map['operation'] = Variable<String>(operation.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PendingSyncQueueCompanion(')
          ..write('id: $id, ')
          ..write('entityTable: $entityTable, ')
          ..write('entityId: $entityId, ')
          ..write('operation: $operation, ')
          ..write('payload: $payload, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ProfilesTable profiles = $ProfilesTable(this);
  late final $DigitalCardsTable digitalCards = $DigitalCardsTable(this);
  late final $DigitalCardExperiencesTable digitalCardExperiences =
      $DigitalCardExperiencesTable(this);
  late final $DigitalCardExtrasTable digitalCardExtras =
      $DigitalCardExtrasTable(this);
  late final $DigitalCardFieldsTable digitalCardFields =
      $DigitalCardFieldsTable(this);
  late final $ScannedCardsTable scannedCards = $ScannedCardsTable(this);
  late final $ScannedCardFieldsTable scannedCardFields =
      $ScannedCardFieldsTable(this);
  late final $CardGroupsTable cardGroups = $CardGroupsTable(this);
  late final $CardGroupMembersTable cardGroupMembers = $CardGroupMembersTable(
    this,
  );
  late final $CardNotesTable cardNotes = $CardNotesTable(this);
  late final $CardRemindersTable cardReminders = $CardRemindersTable(this);
  late final $AppNotificationsTable appNotifications = $AppNotificationsTable(
    this,
  );
  late final $UserSettingsTableTable userSettingsTable =
      $UserSettingsTableTable(this);
  late final $PendingSyncQueueTable pendingSyncQueue = $PendingSyncQueueTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    profiles,
    digitalCards,
    digitalCardExperiences,
    digitalCardExtras,
    digitalCardFields,
    scannedCards,
    scannedCardFields,
    cardGroups,
    cardGroupMembers,
    cardNotes,
    cardReminders,
    appNotifications,
    userSettingsTable,
    pendingSyncQueue,
  ];
}

typedef $$ProfilesTableCreateCompanionBuilder =
    ProfilesCompanion Function({
      required String id,
      Value<String?> fullName,
      Value<String?> avatarUrl,
      Value<String?> phone,
      Value<String?> language,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$ProfilesTableUpdateCompanionBuilder =
    ProfilesCompanion Function({
      Value<String> id,
      Value<String?> fullName,
      Value<String?> avatarUrl,
      Value<String?> phone,
      Value<String?> language,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$ProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $ProfilesTable> {
  $$ProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fullName => $composableBuilder(
    column: $table.fullName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get avatarUrl => $composableBuilder(
    column: $table.avatarUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get language => $composableBuilder(
    column: $table.language,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $ProfilesTable> {
  $$ProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fullName => $composableBuilder(
    column: $table.fullName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get avatarUrl => $composableBuilder(
    column: $table.avatarUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get language => $composableBuilder(
    column: $table.language,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProfilesTable> {
  $$ProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get fullName =>
      $composableBuilder(column: $table.fullName, builder: (column) => column);

  GeneratedColumn<String> get avatarUrl =>
      $composableBuilder(column: $table.avatarUrl, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get language =>
      $composableBuilder(column: $table.language, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ProfilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProfilesTable,
          ProfileRow,
          $$ProfilesTableFilterComposer,
          $$ProfilesTableOrderingComposer,
          $$ProfilesTableAnnotationComposer,
          $$ProfilesTableCreateCompanionBuilder,
          $$ProfilesTableUpdateCompanionBuilder,
          (
            ProfileRow,
            BaseReferences<_$AppDatabase, $ProfilesTable, ProfileRow>,
          ),
          ProfileRow,
          PrefetchHooks Function()
        > {
  $$ProfilesTableTableManager(_$AppDatabase db, $ProfilesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> fullName = const Value.absent(),
                Value<String?> avatarUrl = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> language = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProfilesCompanion(
                id: id,
                fullName: fullName,
                avatarUrl: avatarUrl,
                phone: phone,
                language: language,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> fullName = const Value.absent(),
                Value<String?> avatarUrl = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> language = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProfilesCompanion.insert(
                id: id,
                fullName: fullName,
                avatarUrl: avatarUrl,
                phone: phone,
                language: language,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProfilesTable,
      ProfileRow,
      $$ProfilesTableFilterComposer,
      $$ProfilesTableOrderingComposer,
      $$ProfilesTableAnnotationComposer,
      $$ProfilesTableCreateCompanionBuilder,
      $$ProfilesTableUpdateCompanionBuilder,
      (ProfileRow, BaseReferences<_$AppDatabase, $ProfilesTable, ProfileRow>),
      ProfileRow,
      PrefetchHooks Function()
    >;
typedef $$DigitalCardsTableCreateCompanionBuilder =
    DigitalCardsCompanion Function({
      required String id,
      required String userId,
      required String firstName,
      required String lastName,
      Value<String?> photoUrl,
      Value<String?> jobTitle,
      Value<String?> department,
      Value<String?> company,
      Value<String?> headline,
      Value<String> theme,
      Value<bool> isDefault,
      Value<String?> shareSlug,
      Value<DateTime?> deletedAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$DigitalCardsTableUpdateCompanionBuilder =
    DigitalCardsCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<String> firstName,
      Value<String> lastName,
      Value<String?> photoUrl,
      Value<String?> jobTitle,
      Value<String?> department,
      Value<String?> company,
      Value<String?> headline,
      Value<String> theme,
      Value<bool> isDefault,
      Value<String?> shareSlug,
      Value<DateTime?> deletedAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$DigitalCardsTableFilterComposer
    extends Composer<_$AppDatabase, $DigitalCardsTable> {
  $$DigitalCardsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get firstName => $composableBuilder(
    column: $table.firstName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastName => $composableBuilder(
    column: $table.lastName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get photoUrl => $composableBuilder(
    column: $table.photoUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get jobTitle => $composableBuilder(
    column: $table.jobTitle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get department => $composableBuilder(
    column: $table.department,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get company => $composableBuilder(
    column: $table.company,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get headline => $composableBuilder(
    column: $table.headline,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get theme => $composableBuilder(
    column: $table.theme,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDefault => $composableBuilder(
    column: $table.isDefault,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get shareSlug => $composableBuilder(
    column: $table.shareSlug,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DigitalCardsTableOrderingComposer
    extends Composer<_$AppDatabase, $DigitalCardsTable> {
  $$DigitalCardsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get firstName => $composableBuilder(
    column: $table.firstName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastName => $composableBuilder(
    column: $table.lastName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get photoUrl => $composableBuilder(
    column: $table.photoUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get jobTitle => $composableBuilder(
    column: $table.jobTitle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get department => $composableBuilder(
    column: $table.department,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get company => $composableBuilder(
    column: $table.company,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get headline => $composableBuilder(
    column: $table.headline,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get theme => $composableBuilder(
    column: $table.theme,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDefault => $composableBuilder(
    column: $table.isDefault,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get shareSlug => $composableBuilder(
    column: $table.shareSlug,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DigitalCardsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DigitalCardsTable> {
  $$DigitalCardsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get firstName =>
      $composableBuilder(column: $table.firstName, builder: (column) => column);

  GeneratedColumn<String> get lastName =>
      $composableBuilder(column: $table.lastName, builder: (column) => column);

  GeneratedColumn<String> get photoUrl =>
      $composableBuilder(column: $table.photoUrl, builder: (column) => column);

  GeneratedColumn<String> get jobTitle =>
      $composableBuilder(column: $table.jobTitle, builder: (column) => column);

  GeneratedColumn<String> get department => $composableBuilder(
    column: $table.department,
    builder: (column) => column,
  );

  GeneratedColumn<String> get company =>
      $composableBuilder(column: $table.company, builder: (column) => column);

  GeneratedColumn<String> get headline =>
      $composableBuilder(column: $table.headline, builder: (column) => column);

  GeneratedColumn<String> get theme =>
      $composableBuilder(column: $table.theme, builder: (column) => column);

  GeneratedColumn<bool> get isDefault =>
      $composableBuilder(column: $table.isDefault, builder: (column) => column);

  GeneratedColumn<String> get shareSlug =>
      $composableBuilder(column: $table.shareSlug, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$DigitalCardsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DigitalCardsTable,
          DigitalCardRow,
          $$DigitalCardsTableFilterComposer,
          $$DigitalCardsTableOrderingComposer,
          $$DigitalCardsTableAnnotationComposer,
          $$DigitalCardsTableCreateCompanionBuilder,
          $$DigitalCardsTableUpdateCompanionBuilder,
          (
            DigitalCardRow,
            BaseReferences<_$AppDatabase, $DigitalCardsTable, DigitalCardRow>,
          ),
          DigitalCardRow,
          PrefetchHooks Function()
        > {
  $$DigitalCardsTableTableManager(_$AppDatabase db, $DigitalCardsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DigitalCardsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DigitalCardsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DigitalCardsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> firstName = const Value.absent(),
                Value<String> lastName = const Value.absent(),
                Value<String?> photoUrl = const Value.absent(),
                Value<String?> jobTitle = const Value.absent(),
                Value<String?> department = const Value.absent(),
                Value<String?> company = const Value.absent(),
                Value<String?> headline = const Value.absent(),
                Value<String> theme = const Value.absent(),
                Value<bool> isDefault = const Value.absent(),
                Value<String?> shareSlug = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DigitalCardsCompanion(
                id: id,
                userId: userId,
                firstName: firstName,
                lastName: lastName,
                photoUrl: photoUrl,
                jobTitle: jobTitle,
                department: department,
                company: company,
                headline: headline,
                theme: theme,
                isDefault: isDefault,
                shareSlug: shareSlug,
                deletedAt: deletedAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                required String firstName,
                required String lastName,
                Value<String?> photoUrl = const Value.absent(),
                Value<String?> jobTitle = const Value.absent(),
                Value<String?> department = const Value.absent(),
                Value<String?> company = const Value.absent(),
                Value<String?> headline = const Value.absent(),
                Value<String> theme = const Value.absent(),
                Value<bool> isDefault = const Value.absent(),
                Value<String?> shareSlug = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DigitalCardsCompanion.insert(
                id: id,
                userId: userId,
                firstName: firstName,
                lastName: lastName,
                photoUrl: photoUrl,
                jobTitle: jobTitle,
                department: department,
                company: company,
                headline: headline,
                theme: theme,
                isDefault: isDefault,
                shareSlug: shareSlug,
                deletedAt: deletedAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DigitalCardsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DigitalCardsTable,
      DigitalCardRow,
      $$DigitalCardsTableFilterComposer,
      $$DigitalCardsTableOrderingComposer,
      $$DigitalCardsTableAnnotationComposer,
      $$DigitalCardsTableCreateCompanionBuilder,
      $$DigitalCardsTableUpdateCompanionBuilder,
      (
        DigitalCardRow,
        BaseReferences<_$AppDatabase, $DigitalCardsTable, DigitalCardRow>,
      ),
      DigitalCardRow,
      PrefetchHooks Function()
    >;
typedef $$DigitalCardExperiencesTableCreateCompanionBuilder =
    DigitalCardExperiencesCompanion Function({
      required String id,
      required String cardId,
      required String company,
      required String title,
      Value<DateTime?> startDate,
      Value<DateTime?> endDate,
      Value<bool> isCurrent,
      Value<int> rowid,
    });
typedef $$DigitalCardExperiencesTableUpdateCompanionBuilder =
    DigitalCardExperiencesCompanion Function({
      Value<String> id,
      Value<String> cardId,
      Value<String> company,
      Value<String> title,
      Value<DateTime?> startDate,
      Value<DateTime?> endDate,
      Value<bool> isCurrent,
      Value<int> rowid,
    });

class $$DigitalCardExperiencesTableFilterComposer
    extends Composer<_$AppDatabase, $DigitalCardExperiencesTable> {
  $$DigitalCardExperiencesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cardId => $composableBuilder(
    column: $table.cardId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get company => $composableBuilder(
    column: $table.company,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCurrent => $composableBuilder(
    column: $table.isCurrent,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DigitalCardExperiencesTableOrderingComposer
    extends Composer<_$AppDatabase, $DigitalCardExperiencesTable> {
  $$DigitalCardExperiencesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cardId => $composableBuilder(
    column: $table.cardId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get company => $composableBuilder(
    column: $table.company,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCurrent => $composableBuilder(
    column: $table.isCurrent,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DigitalCardExperiencesTableAnnotationComposer
    extends Composer<_$AppDatabase, $DigitalCardExperiencesTable> {
  $$DigitalCardExperiencesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get cardId =>
      $composableBuilder(column: $table.cardId, builder: (column) => column);

  GeneratedColumn<String> get company =>
      $composableBuilder(column: $table.company, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<bool> get isCurrent =>
      $composableBuilder(column: $table.isCurrent, builder: (column) => column);
}

class $$DigitalCardExperiencesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DigitalCardExperiencesTable,
          DigitalCardExperienceRow,
          $$DigitalCardExperiencesTableFilterComposer,
          $$DigitalCardExperiencesTableOrderingComposer,
          $$DigitalCardExperiencesTableAnnotationComposer,
          $$DigitalCardExperiencesTableCreateCompanionBuilder,
          $$DigitalCardExperiencesTableUpdateCompanionBuilder,
          (
            DigitalCardExperienceRow,
            BaseReferences<
              _$AppDatabase,
              $DigitalCardExperiencesTable,
              DigitalCardExperienceRow
            >,
          ),
          DigitalCardExperienceRow,
          PrefetchHooks Function()
        > {
  $$DigitalCardExperiencesTableTableManager(
    _$AppDatabase db,
    $DigitalCardExperiencesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DigitalCardExperiencesTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$DigitalCardExperiencesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$DigitalCardExperiencesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> cardId = const Value.absent(),
                Value<String> company = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<DateTime?> startDate = const Value.absent(),
                Value<DateTime?> endDate = const Value.absent(),
                Value<bool> isCurrent = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DigitalCardExperiencesCompanion(
                id: id,
                cardId: cardId,
                company: company,
                title: title,
                startDate: startDate,
                endDate: endDate,
                isCurrent: isCurrent,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String cardId,
                required String company,
                required String title,
                Value<DateTime?> startDate = const Value.absent(),
                Value<DateTime?> endDate = const Value.absent(),
                Value<bool> isCurrent = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DigitalCardExperiencesCompanion.insert(
                id: id,
                cardId: cardId,
                company: company,
                title: title,
                startDate: startDate,
                endDate: endDate,
                isCurrent: isCurrent,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DigitalCardExperiencesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DigitalCardExperiencesTable,
      DigitalCardExperienceRow,
      $$DigitalCardExperiencesTableFilterComposer,
      $$DigitalCardExperiencesTableOrderingComposer,
      $$DigitalCardExperiencesTableAnnotationComposer,
      $$DigitalCardExperiencesTableCreateCompanionBuilder,
      $$DigitalCardExperiencesTableUpdateCompanionBuilder,
      (
        DigitalCardExperienceRow,
        BaseReferences<
          _$AppDatabase,
          $DigitalCardExperiencesTable,
          DigitalCardExperienceRow
        >,
      ),
      DigitalCardExperienceRow,
      PrefetchHooks Function()
    >;
typedef $$DigitalCardExtrasTableCreateCompanionBuilder =
    DigitalCardExtrasCompanion Function({
      required String id,
      required String cardId,
      required String kind,
      required String payload,
      Value<int> rowid,
    });
typedef $$DigitalCardExtrasTableUpdateCompanionBuilder =
    DigitalCardExtrasCompanion Function({
      Value<String> id,
      Value<String> cardId,
      Value<String> kind,
      Value<String> payload,
      Value<int> rowid,
    });

class $$DigitalCardExtrasTableFilterComposer
    extends Composer<_$AppDatabase, $DigitalCardExtrasTable> {
  $$DigitalCardExtrasTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cardId => $composableBuilder(
    column: $table.cardId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DigitalCardExtrasTableOrderingComposer
    extends Composer<_$AppDatabase, $DigitalCardExtrasTable> {
  $$DigitalCardExtrasTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cardId => $composableBuilder(
    column: $table.cardId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DigitalCardExtrasTableAnnotationComposer
    extends Composer<_$AppDatabase, $DigitalCardExtrasTable> {
  $$DigitalCardExtrasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get cardId =>
      $composableBuilder(column: $table.cardId, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);
}

class $$DigitalCardExtrasTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DigitalCardExtrasTable,
          DigitalCardExtraRow,
          $$DigitalCardExtrasTableFilterComposer,
          $$DigitalCardExtrasTableOrderingComposer,
          $$DigitalCardExtrasTableAnnotationComposer,
          $$DigitalCardExtrasTableCreateCompanionBuilder,
          $$DigitalCardExtrasTableUpdateCompanionBuilder,
          (
            DigitalCardExtraRow,
            BaseReferences<
              _$AppDatabase,
              $DigitalCardExtrasTable,
              DigitalCardExtraRow
            >,
          ),
          DigitalCardExtraRow,
          PrefetchHooks Function()
        > {
  $$DigitalCardExtrasTableTableManager(
    _$AppDatabase db,
    $DigitalCardExtrasTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DigitalCardExtrasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DigitalCardExtrasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DigitalCardExtrasTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> cardId = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<String> payload = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DigitalCardExtrasCompanion(
                id: id,
                cardId: cardId,
                kind: kind,
                payload: payload,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String cardId,
                required String kind,
                required String payload,
                Value<int> rowid = const Value.absent(),
              }) => DigitalCardExtrasCompanion.insert(
                id: id,
                cardId: cardId,
                kind: kind,
                payload: payload,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DigitalCardExtrasTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DigitalCardExtrasTable,
      DigitalCardExtraRow,
      $$DigitalCardExtrasTableFilterComposer,
      $$DigitalCardExtrasTableOrderingComposer,
      $$DigitalCardExtrasTableAnnotationComposer,
      $$DigitalCardExtrasTableCreateCompanionBuilder,
      $$DigitalCardExtrasTableUpdateCompanionBuilder,
      (
        DigitalCardExtraRow,
        BaseReferences<
          _$AppDatabase,
          $DigitalCardExtrasTable,
          DigitalCardExtraRow
        >,
      ),
      DigitalCardExtraRow,
      PrefetchHooks Function()
    >;
typedef $$DigitalCardFieldsTableCreateCompanionBuilder =
    DigitalCardFieldsCompanion Function({
      required String id,
      required String cardId,
      required String platform,
      required String label,
      required String value,
      Value<int> sortOrder,
      Value<int> rowid,
    });
typedef $$DigitalCardFieldsTableUpdateCompanionBuilder =
    DigitalCardFieldsCompanion Function({
      Value<String> id,
      Value<String> cardId,
      Value<String> platform,
      Value<String> label,
      Value<String> value,
      Value<int> sortOrder,
      Value<int> rowid,
    });

class $$DigitalCardFieldsTableFilterComposer
    extends Composer<_$AppDatabase, $DigitalCardFieldsTable> {
  $$DigitalCardFieldsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cardId => $composableBuilder(
    column: $table.cardId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get platform => $composableBuilder(
    column: $table.platform,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DigitalCardFieldsTableOrderingComposer
    extends Composer<_$AppDatabase, $DigitalCardFieldsTable> {
  $$DigitalCardFieldsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cardId => $composableBuilder(
    column: $table.cardId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get platform => $composableBuilder(
    column: $table.platform,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DigitalCardFieldsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DigitalCardFieldsTable> {
  $$DigitalCardFieldsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get cardId =>
      $composableBuilder(column: $table.cardId, builder: (column) => column);

  GeneratedColumn<String> get platform =>
      $composableBuilder(column: $table.platform, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);
}

class $$DigitalCardFieldsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DigitalCardFieldsTable,
          DigitalCardFieldRow,
          $$DigitalCardFieldsTableFilterComposer,
          $$DigitalCardFieldsTableOrderingComposer,
          $$DigitalCardFieldsTableAnnotationComposer,
          $$DigitalCardFieldsTableCreateCompanionBuilder,
          $$DigitalCardFieldsTableUpdateCompanionBuilder,
          (
            DigitalCardFieldRow,
            BaseReferences<
              _$AppDatabase,
              $DigitalCardFieldsTable,
              DigitalCardFieldRow
            >,
          ),
          DigitalCardFieldRow,
          PrefetchHooks Function()
        > {
  $$DigitalCardFieldsTableTableManager(
    _$AppDatabase db,
    $DigitalCardFieldsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DigitalCardFieldsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DigitalCardFieldsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DigitalCardFieldsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> cardId = const Value.absent(),
                Value<String> platform = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DigitalCardFieldsCompanion(
                id: id,
                cardId: cardId,
                platform: platform,
                label: label,
                value: value,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String cardId,
                required String platform,
                required String label,
                required String value,
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DigitalCardFieldsCompanion.insert(
                id: id,
                cardId: cardId,
                platform: platform,
                label: label,
                value: value,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DigitalCardFieldsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DigitalCardFieldsTable,
      DigitalCardFieldRow,
      $$DigitalCardFieldsTableFilterComposer,
      $$DigitalCardFieldsTableOrderingComposer,
      $$DigitalCardFieldsTableAnnotationComposer,
      $$DigitalCardFieldsTableCreateCompanionBuilder,
      $$DigitalCardFieldsTableUpdateCompanionBuilder,
      (
        DigitalCardFieldRow,
        BaseReferences<
          _$AppDatabase,
          $DigitalCardFieldsTable,
          DigitalCardFieldRow
        >,
      ),
      DigitalCardFieldRow,
      PrefetchHooks Function()
    >;
typedef $$ScannedCardsTableCreateCompanionBuilder =
    ScannedCardsCompanion Function({
      required String id,
      required String userId,
      Value<String?> profileImageUrl,
      Value<String?> frontImageUrl,
      Value<String?> backImageUrl,
      Value<String?> fullName,
      Value<String?> company,
      Value<String?> department,
      Value<String?> jobTitle,
      Value<bool> sortByCompany,
      Value<String?> rawOcr,
      Value<DateTime?> lastViewedAt,
      Value<DateTime?> deletedAt,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$ScannedCardsTableUpdateCompanionBuilder =
    ScannedCardsCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<String?> profileImageUrl,
      Value<String?> frontImageUrl,
      Value<String?> backImageUrl,
      Value<String?> fullName,
      Value<String?> company,
      Value<String?> department,
      Value<String?> jobTitle,
      Value<bool> sortByCompany,
      Value<String?> rawOcr,
      Value<DateTime?> lastViewedAt,
      Value<DateTime?> deletedAt,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$ScannedCardsTableFilterComposer
    extends Composer<_$AppDatabase, $ScannedCardsTable> {
  $$ScannedCardsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get profileImageUrl => $composableBuilder(
    column: $table.profileImageUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get frontImageUrl => $composableBuilder(
    column: $table.frontImageUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get backImageUrl => $composableBuilder(
    column: $table.backImageUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fullName => $composableBuilder(
    column: $table.fullName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get company => $composableBuilder(
    column: $table.company,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get department => $composableBuilder(
    column: $table.department,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get jobTitle => $composableBuilder(
    column: $table.jobTitle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get sortByCompany => $composableBuilder(
    column: $table.sortByCompany,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rawOcr => $composableBuilder(
    column: $table.rawOcr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastViewedAt => $composableBuilder(
    column: $table.lastViewedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ScannedCardsTableOrderingComposer
    extends Composer<_$AppDatabase, $ScannedCardsTable> {
  $$ScannedCardsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get profileImageUrl => $composableBuilder(
    column: $table.profileImageUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get frontImageUrl => $composableBuilder(
    column: $table.frontImageUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get backImageUrl => $composableBuilder(
    column: $table.backImageUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fullName => $composableBuilder(
    column: $table.fullName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get company => $composableBuilder(
    column: $table.company,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get department => $composableBuilder(
    column: $table.department,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get jobTitle => $composableBuilder(
    column: $table.jobTitle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get sortByCompany => $composableBuilder(
    column: $table.sortByCompany,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rawOcr => $composableBuilder(
    column: $table.rawOcr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastViewedAt => $composableBuilder(
    column: $table.lastViewedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ScannedCardsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ScannedCardsTable> {
  $$ScannedCardsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get profileImageUrl => $composableBuilder(
    column: $table.profileImageUrl,
    builder: (column) => column,
  );

  GeneratedColumn<String> get frontImageUrl => $composableBuilder(
    column: $table.frontImageUrl,
    builder: (column) => column,
  );

  GeneratedColumn<String> get backImageUrl => $composableBuilder(
    column: $table.backImageUrl,
    builder: (column) => column,
  );

  GeneratedColumn<String> get fullName =>
      $composableBuilder(column: $table.fullName, builder: (column) => column);

  GeneratedColumn<String> get company =>
      $composableBuilder(column: $table.company, builder: (column) => column);

  GeneratedColumn<String> get department => $composableBuilder(
    column: $table.department,
    builder: (column) => column,
  );

  GeneratedColumn<String> get jobTitle =>
      $composableBuilder(column: $table.jobTitle, builder: (column) => column);

  GeneratedColumn<bool> get sortByCompany => $composableBuilder(
    column: $table.sortByCompany,
    builder: (column) => column,
  );

  GeneratedColumn<String> get rawOcr =>
      $composableBuilder(column: $table.rawOcr, builder: (column) => column);

  GeneratedColumn<DateTime> get lastViewedAt => $composableBuilder(
    column: $table.lastViewedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ScannedCardsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ScannedCardsTable,
          ScannedCardRow,
          $$ScannedCardsTableFilterComposer,
          $$ScannedCardsTableOrderingComposer,
          $$ScannedCardsTableAnnotationComposer,
          $$ScannedCardsTableCreateCompanionBuilder,
          $$ScannedCardsTableUpdateCompanionBuilder,
          (
            ScannedCardRow,
            BaseReferences<_$AppDatabase, $ScannedCardsTable, ScannedCardRow>,
          ),
          ScannedCardRow,
          PrefetchHooks Function()
        > {
  $$ScannedCardsTableTableManager(_$AppDatabase db, $ScannedCardsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ScannedCardsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ScannedCardsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ScannedCardsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String?> profileImageUrl = const Value.absent(),
                Value<String?> frontImageUrl = const Value.absent(),
                Value<String?> backImageUrl = const Value.absent(),
                Value<String?> fullName = const Value.absent(),
                Value<String?> company = const Value.absent(),
                Value<String?> department = const Value.absent(),
                Value<String?> jobTitle = const Value.absent(),
                Value<bool> sortByCompany = const Value.absent(),
                Value<String?> rawOcr = const Value.absent(),
                Value<DateTime?> lastViewedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ScannedCardsCompanion(
                id: id,
                userId: userId,
                profileImageUrl: profileImageUrl,
                frontImageUrl: frontImageUrl,
                backImageUrl: backImageUrl,
                fullName: fullName,
                company: company,
                department: department,
                jobTitle: jobTitle,
                sortByCompany: sortByCompany,
                rawOcr: rawOcr,
                lastViewedAt: lastViewedAt,
                deletedAt: deletedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                Value<String?> profileImageUrl = const Value.absent(),
                Value<String?> frontImageUrl = const Value.absent(),
                Value<String?> backImageUrl = const Value.absent(),
                Value<String?> fullName = const Value.absent(),
                Value<String?> company = const Value.absent(),
                Value<String?> department = const Value.absent(),
                Value<String?> jobTitle = const Value.absent(),
                Value<bool> sortByCompany = const Value.absent(),
                Value<String?> rawOcr = const Value.absent(),
                Value<DateTime?> lastViewedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ScannedCardsCompanion.insert(
                id: id,
                userId: userId,
                profileImageUrl: profileImageUrl,
                frontImageUrl: frontImageUrl,
                backImageUrl: backImageUrl,
                fullName: fullName,
                company: company,
                department: department,
                jobTitle: jobTitle,
                sortByCompany: sortByCompany,
                rawOcr: rawOcr,
                lastViewedAt: lastViewedAt,
                deletedAt: deletedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ScannedCardsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ScannedCardsTable,
      ScannedCardRow,
      $$ScannedCardsTableFilterComposer,
      $$ScannedCardsTableOrderingComposer,
      $$ScannedCardsTableAnnotationComposer,
      $$ScannedCardsTableCreateCompanionBuilder,
      $$ScannedCardsTableUpdateCompanionBuilder,
      (
        ScannedCardRow,
        BaseReferences<_$AppDatabase, $ScannedCardsTable, ScannedCardRow>,
      ),
      ScannedCardRow,
      PrefetchHooks Function()
    >;
typedef $$ScannedCardFieldsTableCreateCompanionBuilder =
    ScannedCardFieldsCompanion Function({
      required String id,
      required String cardId,
      required String fieldType,
      required String label,
      required String value,
      Value<String?> addressDetail,
      Value<int> sortOrder,
      Value<int> rowid,
    });
typedef $$ScannedCardFieldsTableUpdateCompanionBuilder =
    ScannedCardFieldsCompanion Function({
      Value<String> id,
      Value<String> cardId,
      Value<String> fieldType,
      Value<String> label,
      Value<String> value,
      Value<String?> addressDetail,
      Value<int> sortOrder,
      Value<int> rowid,
    });

class $$ScannedCardFieldsTableFilterComposer
    extends Composer<_$AppDatabase, $ScannedCardFieldsTable> {
  $$ScannedCardFieldsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cardId => $composableBuilder(
    column: $table.cardId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fieldType => $composableBuilder(
    column: $table.fieldType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get addressDetail => $composableBuilder(
    column: $table.addressDetail,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ScannedCardFieldsTableOrderingComposer
    extends Composer<_$AppDatabase, $ScannedCardFieldsTable> {
  $$ScannedCardFieldsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cardId => $composableBuilder(
    column: $table.cardId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fieldType => $composableBuilder(
    column: $table.fieldType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get addressDetail => $composableBuilder(
    column: $table.addressDetail,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ScannedCardFieldsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ScannedCardFieldsTable> {
  $$ScannedCardFieldsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get cardId =>
      $composableBuilder(column: $table.cardId, builder: (column) => column);

  GeneratedColumn<String> get fieldType =>
      $composableBuilder(column: $table.fieldType, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<String> get addressDetail => $composableBuilder(
    column: $table.addressDetail,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);
}

class $$ScannedCardFieldsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ScannedCardFieldsTable,
          ScannedCardFieldRow,
          $$ScannedCardFieldsTableFilterComposer,
          $$ScannedCardFieldsTableOrderingComposer,
          $$ScannedCardFieldsTableAnnotationComposer,
          $$ScannedCardFieldsTableCreateCompanionBuilder,
          $$ScannedCardFieldsTableUpdateCompanionBuilder,
          (
            ScannedCardFieldRow,
            BaseReferences<
              _$AppDatabase,
              $ScannedCardFieldsTable,
              ScannedCardFieldRow
            >,
          ),
          ScannedCardFieldRow,
          PrefetchHooks Function()
        > {
  $$ScannedCardFieldsTableTableManager(
    _$AppDatabase db,
    $ScannedCardFieldsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ScannedCardFieldsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ScannedCardFieldsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ScannedCardFieldsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> cardId = const Value.absent(),
                Value<String> fieldType = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<String?> addressDetail = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ScannedCardFieldsCompanion(
                id: id,
                cardId: cardId,
                fieldType: fieldType,
                label: label,
                value: value,
                addressDetail: addressDetail,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String cardId,
                required String fieldType,
                required String label,
                required String value,
                Value<String?> addressDetail = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ScannedCardFieldsCompanion.insert(
                id: id,
                cardId: cardId,
                fieldType: fieldType,
                label: label,
                value: value,
                addressDetail: addressDetail,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ScannedCardFieldsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ScannedCardFieldsTable,
      ScannedCardFieldRow,
      $$ScannedCardFieldsTableFilterComposer,
      $$ScannedCardFieldsTableOrderingComposer,
      $$ScannedCardFieldsTableAnnotationComposer,
      $$ScannedCardFieldsTableCreateCompanionBuilder,
      $$ScannedCardFieldsTableUpdateCompanionBuilder,
      (
        ScannedCardFieldRow,
        BaseReferences<
          _$AppDatabase,
          $ScannedCardFieldsTable,
          ScannedCardFieldRow
        >,
      ),
      ScannedCardFieldRow,
      PrefetchHooks Function()
    >;
typedef $$CardGroupsTableCreateCompanionBuilder =
    CardGroupsCompanion Function({
      required String id,
      required String userId,
      required String name,
      Value<int> rowid,
    });
typedef $$CardGroupsTableUpdateCompanionBuilder =
    CardGroupsCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<String> name,
      Value<int> rowid,
    });

class $$CardGroupsTableFilterComposer
    extends Composer<_$AppDatabase, $CardGroupsTable> {
  $$CardGroupsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CardGroupsTableOrderingComposer
    extends Composer<_$AppDatabase, $CardGroupsTable> {
  $$CardGroupsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CardGroupsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CardGroupsTable> {
  $$CardGroupsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);
}

class $$CardGroupsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CardGroupsTable,
          CardGroupRow,
          $$CardGroupsTableFilterComposer,
          $$CardGroupsTableOrderingComposer,
          $$CardGroupsTableAnnotationComposer,
          $$CardGroupsTableCreateCompanionBuilder,
          $$CardGroupsTableUpdateCompanionBuilder,
          (
            CardGroupRow,
            BaseReferences<_$AppDatabase, $CardGroupsTable, CardGroupRow>,
          ),
          CardGroupRow,
          PrefetchHooks Function()
        > {
  $$CardGroupsTableTableManager(_$AppDatabase db, $CardGroupsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CardGroupsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CardGroupsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CardGroupsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CardGroupsCompanion(
                id: id,
                userId: userId,
                name: name,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                required String name,
                Value<int> rowid = const Value.absent(),
              }) => CardGroupsCompanion.insert(
                id: id,
                userId: userId,
                name: name,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CardGroupsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CardGroupsTable,
      CardGroupRow,
      $$CardGroupsTableFilterComposer,
      $$CardGroupsTableOrderingComposer,
      $$CardGroupsTableAnnotationComposer,
      $$CardGroupsTableCreateCompanionBuilder,
      $$CardGroupsTableUpdateCompanionBuilder,
      (
        CardGroupRow,
        BaseReferences<_$AppDatabase, $CardGroupsTable, CardGroupRow>,
      ),
      CardGroupRow,
      PrefetchHooks Function()
    >;
typedef $$CardGroupMembersTableCreateCompanionBuilder =
    CardGroupMembersCompanion Function({
      required String groupId,
      required String cardId,
      Value<int> rowid,
    });
typedef $$CardGroupMembersTableUpdateCompanionBuilder =
    CardGroupMembersCompanion Function({
      Value<String> groupId,
      Value<String> cardId,
      Value<int> rowid,
    });

class $$CardGroupMembersTableFilterComposer
    extends Composer<_$AppDatabase, $CardGroupMembersTable> {
  $$CardGroupMembersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get groupId => $composableBuilder(
    column: $table.groupId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cardId => $composableBuilder(
    column: $table.cardId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CardGroupMembersTableOrderingComposer
    extends Composer<_$AppDatabase, $CardGroupMembersTable> {
  $$CardGroupMembersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get groupId => $composableBuilder(
    column: $table.groupId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cardId => $composableBuilder(
    column: $table.cardId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CardGroupMembersTableAnnotationComposer
    extends Composer<_$AppDatabase, $CardGroupMembersTable> {
  $$CardGroupMembersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get groupId =>
      $composableBuilder(column: $table.groupId, builder: (column) => column);

  GeneratedColumn<String> get cardId =>
      $composableBuilder(column: $table.cardId, builder: (column) => column);
}

class $$CardGroupMembersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CardGroupMembersTable,
          CardGroupMemberRow,
          $$CardGroupMembersTableFilterComposer,
          $$CardGroupMembersTableOrderingComposer,
          $$CardGroupMembersTableAnnotationComposer,
          $$CardGroupMembersTableCreateCompanionBuilder,
          $$CardGroupMembersTableUpdateCompanionBuilder,
          (
            CardGroupMemberRow,
            BaseReferences<
              _$AppDatabase,
              $CardGroupMembersTable,
              CardGroupMemberRow
            >,
          ),
          CardGroupMemberRow,
          PrefetchHooks Function()
        > {
  $$CardGroupMembersTableTableManager(
    _$AppDatabase db,
    $CardGroupMembersTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CardGroupMembersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CardGroupMembersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CardGroupMembersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> groupId = const Value.absent(),
                Value<String> cardId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CardGroupMembersCompanion(
                groupId: groupId,
                cardId: cardId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String groupId,
                required String cardId,
                Value<int> rowid = const Value.absent(),
              }) => CardGroupMembersCompanion.insert(
                groupId: groupId,
                cardId: cardId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CardGroupMembersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CardGroupMembersTable,
      CardGroupMemberRow,
      $$CardGroupMembersTableFilterComposer,
      $$CardGroupMembersTableOrderingComposer,
      $$CardGroupMembersTableAnnotationComposer,
      $$CardGroupMembersTableCreateCompanionBuilder,
      $$CardGroupMembersTableUpdateCompanionBuilder,
      (
        CardGroupMemberRow,
        BaseReferences<
          _$AppDatabase,
          $CardGroupMembersTable,
          CardGroupMemberRow
        >,
      ),
      CardGroupMemberRow,
      PrefetchHooks Function()
    >;
typedef $$CardNotesTableCreateCompanionBuilder =
    CardNotesCompanion Function({
      required String id,
      required String userId,
      required String cardId,
      required String content,
      required String noteType,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$CardNotesTableUpdateCompanionBuilder =
    CardNotesCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<String> cardId,
      Value<String> content,
      Value<String> noteType,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$CardNotesTableFilterComposer
    extends Composer<_$AppDatabase, $CardNotesTable> {
  $$CardNotesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cardId => $composableBuilder(
    column: $table.cardId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get noteType => $composableBuilder(
    column: $table.noteType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CardNotesTableOrderingComposer
    extends Composer<_$AppDatabase, $CardNotesTable> {
  $$CardNotesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cardId => $composableBuilder(
    column: $table.cardId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get noteType => $composableBuilder(
    column: $table.noteType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CardNotesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CardNotesTable> {
  $$CardNotesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get cardId =>
      $composableBuilder(column: $table.cardId, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<String> get noteType =>
      $composableBuilder(column: $table.noteType, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$CardNotesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CardNotesTable,
          CardNoteRow,
          $$CardNotesTableFilterComposer,
          $$CardNotesTableOrderingComposer,
          $$CardNotesTableAnnotationComposer,
          $$CardNotesTableCreateCompanionBuilder,
          $$CardNotesTableUpdateCompanionBuilder,
          (
            CardNoteRow,
            BaseReferences<_$AppDatabase, $CardNotesTable, CardNoteRow>,
          ),
          CardNoteRow,
          PrefetchHooks Function()
        > {
  $$CardNotesTableTableManager(_$AppDatabase db, $CardNotesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CardNotesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CardNotesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CardNotesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> cardId = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<String> noteType = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CardNotesCompanion(
                id: id,
                userId: userId,
                cardId: cardId,
                content: content,
                noteType: noteType,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                required String cardId,
                required String content,
                required String noteType,
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CardNotesCompanion.insert(
                id: id,
                userId: userId,
                cardId: cardId,
                content: content,
                noteType: noteType,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CardNotesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CardNotesTable,
      CardNoteRow,
      $$CardNotesTableFilterComposer,
      $$CardNotesTableOrderingComposer,
      $$CardNotesTableAnnotationComposer,
      $$CardNotesTableCreateCompanionBuilder,
      $$CardNotesTableUpdateCompanionBuilder,
      (
        CardNoteRow,
        BaseReferences<_$AppDatabase, $CardNotesTable, CardNoteRow>,
      ),
      CardNoteRow,
      PrefetchHooks Function()
    >;
typedef $$CardRemindersTableCreateCompanionBuilder =
    CardRemindersCompanion Function({
      required String id,
      required String userId,
      required String cardId,
      required DateTime remindAt,
      required String message,
      Value<int> rowid,
    });
typedef $$CardRemindersTableUpdateCompanionBuilder =
    CardRemindersCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<String> cardId,
      Value<DateTime> remindAt,
      Value<String> message,
      Value<int> rowid,
    });

class $$CardRemindersTableFilterComposer
    extends Composer<_$AppDatabase, $CardRemindersTable> {
  $$CardRemindersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cardId => $composableBuilder(
    column: $table.cardId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get remindAt => $composableBuilder(
    column: $table.remindAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get message => $composableBuilder(
    column: $table.message,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CardRemindersTableOrderingComposer
    extends Composer<_$AppDatabase, $CardRemindersTable> {
  $$CardRemindersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cardId => $composableBuilder(
    column: $table.cardId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get remindAt => $composableBuilder(
    column: $table.remindAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get message => $composableBuilder(
    column: $table.message,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CardRemindersTableAnnotationComposer
    extends Composer<_$AppDatabase, $CardRemindersTable> {
  $$CardRemindersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get cardId =>
      $composableBuilder(column: $table.cardId, builder: (column) => column);

  GeneratedColumn<DateTime> get remindAt =>
      $composableBuilder(column: $table.remindAt, builder: (column) => column);

  GeneratedColumn<String> get message =>
      $composableBuilder(column: $table.message, builder: (column) => column);
}

class $$CardRemindersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CardRemindersTable,
          CardReminderRow,
          $$CardRemindersTableFilterComposer,
          $$CardRemindersTableOrderingComposer,
          $$CardRemindersTableAnnotationComposer,
          $$CardRemindersTableCreateCompanionBuilder,
          $$CardRemindersTableUpdateCompanionBuilder,
          (
            CardReminderRow,
            BaseReferences<_$AppDatabase, $CardRemindersTable, CardReminderRow>,
          ),
          CardReminderRow,
          PrefetchHooks Function()
        > {
  $$CardRemindersTableTableManager(_$AppDatabase db, $CardRemindersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CardRemindersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CardRemindersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CardRemindersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> cardId = const Value.absent(),
                Value<DateTime> remindAt = const Value.absent(),
                Value<String> message = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CardRemindersCompanion(
                id: id,
                userId: userId,
                cardId: cardId,
                remindAt: remindAt,
                message: message,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                required String cardId,
                required DateTime remindAt,
                required String message,
                Value<int> rowid = const Value.absent(),
              }) => CardRemindersCompanion.insert(
                id: id,
                userId: userId,
                cardId: cardId,
                remindAt: remindAt,
                message: message,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CardRemindersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CardRemindersTable,
      CardReminderRow,
      $$CardRemindersTableFilterComposer,
      $$CardRemindersTableOrderingComposer,
      $$CardRemindersTableAnnotationComposer,
      $$CardRemindersTableCreateCompanionBuilder,
      $$CardRemindersTableUpdateCompanionBuilder,
      (
        CardReminderRow,
        BaseReferences<_$AppDatabase, $CardRemindersTable, CardReminderRow>,
      ),
      CardReminderRow,
      PrefetchHooks Function()
    >;
typedef $$AppNotificationsTableCreateCompanionBuilder =
    AppNotificationsCompanion Function({
      required String id,
      required String userId,
      required String title,
      required String body,
      Value<bool> isRead,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$AppNotificationsTableUpdateCompanionBuilder =
    AppNotificationsCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<String> title,
      Value<String> body,
      Value<bool> isRead,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$AppNotificationsTableFilterComposer
    extends Composer<_$AppDatabase, $AppNotificationsTable> {
  $$AppNotificationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isRead => $composableBuilder(
    column: $table.isRead,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppNotificationsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppNotificationsTable> {
  $$AppNotificationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isRead => $composableBuilder(
    column: $table.isRead,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppNotificationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppNotificationsTable> {
  $$AppNotificationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => column);

  GeneratedColumn<bool> get isRead =>
      $composableBuilder(column: $table.isRead, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$AppNotificationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppNotificationsTable,
          AppNotificationRow,
          $$AppNotificationsTableFilterComposer,
          $$AppNotificationsTableOrderingComposer,
          $$AppNotificationsTableAnnotationComposer,
          $$AppNotificationsTableCreateCompanionBuilder,
          $$AppNotificationsTableUpdateCompanionBuilder,
          (
            AppNotificationRow,
            BaseReferences<
              _$AppDatabase,
              $AppNotificationsTable,
              AppNotificationRow
            >,
          ),
          AppNotificationRow,
          PrefetchHooks Function()
        > {
  $$AppNotificationsTableTableManager(
    _$AppDatabase db,
    $AppNotificationsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppNotificationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppNotificationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppNotificationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> body = const Value.absent(),
                Value<bool> isRead = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppNotificationsCompanion(
                id: id,
                userId: userId,
                title: title,
                body: body,
                isRead: isRead,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                required String title,
                required String body,
                Value<bool> isRead = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppNotificationsCompanion.insert(
                id: id,
                userId: userId,
                title: title,
                body: body,
                isRead: isRead,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppNotificationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppNotificationsTable,
      AppNotificationRow,
      $$AppNotificationsTableFilterComposer,
      $$AppNotificationsTableOrderingComposer,
      $$AppNotificationsTableAnnotationComposer,
      $$AppNotificationsTableCreateCompanionBuilder,
      $$AppNotificationsTableUpdateCompanionBuilder,
      (
        AppNotificationRow,
        BaseReferences<
          _$AppDatabase,
          $AppNotificationsTable,
          AppNotificationRow
        >,
      ),
      AppNotificationRow,
      PrefetchHooks Function()
    >;
typedef $$UserSettingsTableTableCreateCompanionBuilder =
    UserSettingsTableCompanion Function({
      required String userId,
      Value<bool> notificationsEnabled,
      Value<bool> sound,
      Value<bool> vibrate,
      Value<String?> language,
      Value<int> rowid,
    });
typedef $$UserSettingsTableTableUpdateCompanionBuilder =
    UserSettingsTableCompanion Function({
      Value<String> userId,
      Value<bool> notificationsEnabled,
      Value<bool> sound,
      Value<bool> vibrate,
      Value<String?> language,
      Value<int> rowid,
    });

class $$UserSettingsTableTableFilterComposer
    extends Composer<_$AppDatabase, $UserSettingsTableTable> {
  $$UserSettingsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get notificationsEnabled => $composableBuilder(
    column: $table.notificationsEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get sound => $composableBuilder(
    column: $table.sound,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get vibrate => $composableBuilder(
    column: $table.vibrate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get language => $composableBuilder(
    column: $table.language,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UserSettingsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $UserSettingsTableTable> {
  $$UserSettingsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get notificationsEnabled => $composableBuilder(
    column: $table.notificationsEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get sound => $composableBuilder(
    column: $table.sound,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get vibrate => $composableBuilder(
    column: $table.vibrate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get language => $composableBuilder(
    column: $table.language,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserSettingsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserSettingsTableTable> {
  $$UserSettingsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<bool> get notificationsEnabled => $composableBuilder(
    column: $table.notificationsEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get sound =>
      $composableBuilder(column: $table.sound, builder: (column) => column);

  GeneratedColumn<bool> get vibrate =>
      $composableBuilder(column: $table.vibrate, builder: (column) => column);

  GeneratedColumn<String> get language =>
      $composableBuilder(column: $table.language, builder: (column) => column);
}

class $$UserSettingsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserSettingsTableTable,
          UserSettingsRow,
          $$UserSettingsTableTableFilterComposer,
          $$UserSettingsTableTableOrderingComposer,
          $$UserSettingsTableTableAnnotationComposer,
          $$UserSettingsTableTableCreateCompanionBuilder,
          $$UserSettingsTableTableUpdateCompanionBuilder,
          (
            UserSettingsRow,
            BaseReferences<
              _$AppDatabase,
              $UserSettingsTableTable,
              UserSettingsRow
            >,
          ),
          UserSettingsRow,
          PrefetchHooks Function()
        > {
  $$UserSettingsTableTableTableManager(
    _$AppDatabase db,
    $UserSettingsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserSettingsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserSettingsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserSettingsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> userId = const Value.absent(),
                Value<bool> notificationsEnabled = const Value.absent(),
                Value<bool> sound = const Value.absent(),
                Value<bool> vibrate = const Value.absent(),
                Value<String?> language = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserSettingsTableCompanion(
                userId: userId,
                notificationsEnabled: notificationsEnabled,
                sound: sound,
                vibrate: vibrate,
                language: language,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String userId,
                Value<bool> notificationsEnabled = const Value.absent(),
                Value<bool> sound = const Value.absent(),
                Value<bool> vibrate = const Value.absent(),
                Value<String?> language = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserSettingsTableCompanion.insert(
                userId: userId,
                notificationsEnabled: notificationsEnabled,
                sound: sound,
                vibrate: vibrate,
                language: language,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UserSettingsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserSettingsTableTable,
      UserSettingsRow,
      $$UserSettingsTableTableFilterComposer,
      $$UserSettingsTableTableOrderingComposer,
      $$UserSettingsTableTableAnnotationComposer,
      $$UserSettingsTableTableCreateCompanionBuilder,
      $$UserSettingsTableTableUpdateCompanionBuilder,
      (
        UserSettingsRow,
        BaseReferences<_$AppDatabase, $UserSettingsTableTable, UserSettingsRow>,
      ),
      UserSettingsRow,
      PrefetchHooks Function()
    >;
typedef $$PendingSyncQueueTableCreateCompanionBuilder =
    PendingSyncQueueCompanion Function({
      Value<int> id,
      required String entityTable,
      required String entityId,
      required String operation,
      required String payload,
      Value<DateTime> createdAt,
    });
typedef $$PendingSyncQueueTableUpdateCompanionBuilder =
    PendingSyncQueueCompanion Function({
      Value<int> id,
      Value<String> entityTable,
      Value<String> entityId,
      Value<String> operation,
      Value<String> payload,
      Value<DateTime> createdAt,
    });

class $$PendingSyncQueueTableFilterComposer
    extends Composer<_$AppDatabase, $PendingSyncQueueTable> {
  $$PendingSyncQueueTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityTable => $composableBuilder(
    column: $table.entityTable,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get operation => $composableBuilder(
    column: $table.operation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PendingSyncQueueTableOrderingComposer
    extends Composer<_$AppDatabase, $PendingSyncQueueTable> {
  $$PendingSyncQueueTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityTable => $composableBuilder(
    column: $table.entityTable,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get operation => $composableBuilder(
    column: $table.operation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PendingSyncQueueTableAnnotationComposer
    extends Composer<_$AppDatabase, $PendingSyncQueueTable> {
  $$PendingSyncQueueTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get entityTable => $composableBuilder(
    column: $table.entityTable,
    builder: (column) => column,
  );

  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get operation =>
      $composableBuilder(column: $table.operation, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$PendingSyncQueueTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PendingSyncQueueTable,
          PendingSyncQueueData,
          $$PendingSyncQueueTableFilterComposer,
          $$PendingSyncQueueTableOrderingComposer,
          $$PendingSyncQueueTableAnnotationComposer,
          $$PendingSyncQueueTableCreateCompanionBuilder,
          $$PendingSyncQueueTableUpdateCompanionBuilder,
          (
            PendingSyncQueueData,
            BaseReferences<
              _$AppDatabase,
              $PendingSyncQueueTable,
              PendingSyncQueueData
            >,
          ),
          PendingSyncQueueData,
          PrefetchHooks Function()
        > {
  $$PendingSyncQueueTableTableManager(
    _$AppDatabase db,
    $PendingSyncQueueTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PendingSyncQueueTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PendingSyncQueueTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PendingSyncQueueTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> entityTable = const Value.absent(),
                Value<String> entityId = const Value.absent(),
                Value<String> operation = const Value.absent(),
                Value<String> payload = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => PendingSyncQueueCompanion(
                id: id,
                entityTable: entityTable,
                entityId: entityId,
                operation: operation,
                payload: payload,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String entityTable,
                required String entityId,
                required String operation,
                required String payload,
                Value<DateTime> createdAt = const Value.absent(),
              }) => PendingSyncQueueCompanion.insert(
                id: id,
                entityTable: entityTable,
                entityId: entityId,
                operation: operation,
                payload: payload,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PendingSyncQueueTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PendingSyncQueueTable,
      PendingSyncQueueData,
      $$PendingSyncQueueTableFilterComposer,
      $$PendingSyncQueueTableOrderingComposer,
      $$PendingSyncQueueTableAnnotationComposer,
      $$PendingSyncQueueTableCreateCompanionBuilder,
      $$PendingSyncQueueTableUpdateCompanionBuilder,
      (
        PendingSyncQueueData,
        BaseReferences<
          _$AppDatabase,
          $PendingSyncQueueTable,
          PendingSyncQueueData
        >,
      ),
      PendingSyncQueueData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ProfilesTableTableManager get profiles =>
      $$ProfilesTableTableManager(_db, _db.profiles);
  $$DigitalCardsTableTableManager get digitalCards =>
      $$DigitalCardsTableTableManager(_db, _db.digitalCards);
  $$DigitalCardExperiencesTableTableManager get digitalCardExperiences =>
      $$DigitalCardExperiencesTableTableManager(
        _db,
        _db.digitalCardExperiences,
      );
  $$DigitalCardExtrasTableTableManager get digitalCardExtras =>
      $$DigitalCardExtrasTableTableManager(_db, _db.digitalCardExtras);
  $$DigitalCardFieldsTableTableManager get digitalCardFields =>
      $$DigitalCardFieldsTableTableManager(_db, _db.digitalCardFields);
  $$ScannedCardsTableTableManager get scannedCards =>
      $$ScannedCardsTableTableManager(_db, _db.scannedCards);
  $$ScannedCardFieldsTableTableManager get scannedCardFields =>
      $$ScannedCardFieldsTableTableManager(_db, _db.scannedCardFields);
  $$CardGroupsTableTableManager get cardGroups =>
      $$CardGroupsTableTableManager(_db, _db.cardGroups);
  $$CardGroupMembersTableTableManager get cardGroupMembers =>
      $$CardGroupMembersTableTableManager(_db, _db.cardGroupMembers);
  $$CardNotesTableTableManager get cardNotes =>
      $$CardNotesTableTableManager(_db, _db.cardNotes);
  $$CardRemindersTableTableManager get cardReminders =>
      $$CardRemindersTableTableManager(_db, _db.cardReminders);
  $$AppNotificationsTableTableManager get appNotifications =>
      $$AppNotificationsTableTableManager(_db, _db.appNotifications);
  $$UserSettingsTableTableTableManager get userSettingsTable =>
      $$UserSettingsTableTableTableManager(_db, _db.userSettingsTable);
  $$PendingSyncQueueTableTableManager get pendingSyncQueue =>
      $$PendingSyncQueueTableTableManager(_db, _db.pendingSyncQueue);
}
