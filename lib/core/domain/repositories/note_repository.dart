import '../entities/card_note.dart';
import '../entities/card_reminder.dart';

abstract interface class NoteRepository {
  Future<List<CardNote>> getNotesForCard(String cardId);

  Future<CardNote> addNote(CardNote note);

  Future<void> deleteNote(String id);

  Future<List<CardReminder>> getRemindersForCard(String cardId);

  Future<CardReminder> addReminder(CardReminder reminder);

  Future<void> deleteReminder(String id);

  /// Zamanı gelmiş ve henüz bildirim kutusuna eklenmemiş hatırlatıcılar.
  Future<List<CardReminder>> getDueUnnotifiedReminders(String userId);

  /// Hatırlatıcıyı bildirim kutusuna eklenmiş olarak işaretle.
  Future<void> markReminderNotified(String id);
}
