import '../domain/entities/card_note.dart';
import '../domain/entities/card_reminder.dart';
import '../domain/repositories/note_repository.dart';
import 'mappers.dart';
import 'supabase_client_provider.dart';

class SupabaseNoteRepository implements NoteRepository {
  @override
  Future<List<CardNote>> getNotesForCard(String cardId) async {
    final rows = await supabaseClient
        .from('card_notes')
        .select()
        .eq('card_id', cardId)
        .order('created_at', ascending: false);
    return (rows as List).map((r) => cardNoteFromJson(r as Map<String, dynamic>)).toList();
  }

  @override
  Future<CardNote> addNote(CardNote note) async {
    final row = await supabaseClient
        .from('card_notes')
        .insert(cardNoteToJson(note)..remove('id'))
        .select()
        .single();
    return cardNoteFromJson(row);
  }

  @override
  Future<void> deleteNote(String id) async {
    await supabaseClient.from('card_notes').delete().eq('id', id);
  }

  @override
  Future<List<CardReminder>> getRemindersForCard(String cardId) async {
    final rows = await supabaseClient
        .from('card_reminders')
        .select()
        .eq('card_id', cardId)
        .order('remind_at');
    return (rows as List)
        .map((r) => cardReminderFromJson(r as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<CardReminder> addReminder(CardReminder reminder) async {
    final row = await supabaseClient
        .from('card_reminders')
        .insert(cardReminderToJson(reminder)..remove('id'))
        .select()
        .single();
    return cardReminderFromJson(row);
  }

  @override
  Future<void> deleteReminder(String id) async {
    await supabaseClient.from('card_reminders').delete().eq('id', id);
  }

  @override
  Future<List<CardReminder>> getDueUnnotifiedReminders(String userId) async {
    final now = DateTime.now().toUtc().toIso8601String();
    final rows = await supabaseClient
        .from('card_reminders')
        .select()
        .eq('user_id', userId)
        .eq('is_notified', false)
        .lte('remind_at', now)
        .order('remind_at');
    return (rows as List)
        .map((r) => cardReminderFromJson(r as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> markReminderNotified(String id) async {
    await supabaseClient
        .from('card_reminders')
        .update({'is_notified': true})
        .eq('id', id);
  }
}
