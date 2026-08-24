class CardReminder {
  const CardReminder({
    required this.id,
    required this.userId,
    required this.cardId,
    required this.remindAt,
    required this.message,
    this.isNotified = false,
  });

  final String id;
  final String userId;
  final String cardId;
  final DateTime remindAt;
  final String message;
  final bool isNotified;

  CardReminder copyWith({DateTime? remindAt, String? message}) {
    return CardReminder(
      id: id,
      userId: userId,
      cardId: cardId,
      remindAt: remindAt ?? this.remindAt,
      message: message ?? this.message,
      isNotified: isNotified,
    );
  }
}
