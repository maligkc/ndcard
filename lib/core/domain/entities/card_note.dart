enum CardNoteType { note, visitLog }

class CardNote {
  const CardNote({
    required this.id,
    required this.userId,
    required this.cardId,
    required this.content,
    required this.noteType,
    this.createdAt,
    this.contactDate,
    this.contactTarget,
    this.wayOfContact,
    this.contactContent,
    this.contactResult,
    this.contactReminder,
  });

  final String id;
  final String userId;
  final String cardId;
  final String content;
  final CardNoteType noteType;
  final DateTime? createdAt;
  final DateTime? contactDate;
  final String? contactTarget;
  final String? wayOfContact;
  final String? contactContent;
  final String? contactResult;
  final String? contactReminder;

  CardNote copyWith({
    String? content,
    CardNoteType? noteType,
    DateTime? contactDate,
    String? contactTarget,
    String? wayOfContact,
    String? contactContent,
    String? contactResult,
    String? contactReminder,
  }) {
    return CardNote(
      id: id,
      userId: userId,
      cardId: cardId,
      content: content ?? this.content,
      noteType: noteType ?? this.noteType,
      createdAt: createdAt,
      contactDate: contactDate ?? this.contactDate,
      contactTarget: contactTarget ?? this.contactTarget,
      wayOfContact: wayOfContact ?? this.wayOfContact,
      contactContent: contactContent ?? this.contactContent,
      contactResult: contactResult ?? this.contactResult,
      contactReminder: contactReminder ?? this.contactReminder,
    );
  }
}
