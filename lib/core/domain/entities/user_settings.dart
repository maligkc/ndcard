class UserSettings {
  const UserSettings({
    required this.userId,
    this.notificationsEnabled = true,
    this.sound = true,
    this.vibrate = true,
    this.language,
  });

  final String userId;
  final bool notificationsEnabled;
  final bool sound;
  final bool vibrate;
  final String? language;

  UserSettings copyWith({
    bool? notificationsEnabled,
    bool? sound,
    bool? vibrate,
    String? language,
  }) {
    return UserSettings(
      userId: userId,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      sound: sound ?? this.sound,
      vibrate: vibrate ?? this.vibrate,
      language: language ?? this.language,
    );
  }
}
