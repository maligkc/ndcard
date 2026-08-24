class Profile {
  const Profile({
    required this.id,
    this.fullName,
    this.avatarUrl,
    this.phone,
    this.language,
  });

  final String id;
  final String? fullName;
  final String? avatarUrl;
  final String? phone;
  final String? language;

  Profile copyWith({
    String? fullName,
    String? avatarUrl,
    String? phone,
    String? language,
  }) {
    return Profile(
      id: id,
      fullName: fullName ?? this.fullName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      phone: phone ?? this.phone,
      language: language ?? this.language,
    );
  }
}
