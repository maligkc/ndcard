import 'dart:async';
import 'dart:convert';

import 'package:drift/drift.dart' as drift;

import '../db/app_database.dart';
import '../db/sync/sync_engine.dart';
import '../domain/entities/digital_card.dart';
import '../domain/repositories/digital_card_repository.dart';
import 'mappers.dart';
import 'supabase_client_provider.dart';

const String _table = 'digital_cards';

/// Offline-first: okumalar drift'ten akar, arka planda Supabase'ten çekilip
/// lokale yazılır. Yazmalar önce drift'e, ardından mümkünse hemen Supabase'e,
/// değilse pending_sync kuyruğuna gider.
class SupabaseDigitalCardRepository implements DigitalCardRepository {
  SupabaseDigitalCardRepository(this._db, this._syncEngine) {
    _syncEngine.registerHandler(_table, _handleQueuedPush);
  }

  final AppDatabase _db;
  final SyncEngine _syncEngine;

  Map<String, dynamic> _bundleToJson(DigitalCard card) => {
        'card': digitalCardToJson(card),
        'experiences': card.experiences.map(experienceToJson).toList(),
        'extras': card.extras.map(extraToJson).toList(),
        'fields': card.fields.map(fieldToJson).toList(),
      };

  DigitalCard _bundleFromJson(Map<String, dynamic> json) {
    return digitalCardFromJson(
      json['card'] as Map<String, dynamic>,
      experiences: (json['experiences'] as List<dynamic>)
          .map((e) => experienceFromJson(e as Map<String, dynamic>))
          .toList(),
      extras: (json['extras'] as List<dynamic>)
          .map((e) => extraFromJson(e as Map<String, dynamic>))
          .toList(),
      fields: (json['fields'] as List<dynamic>)
          .map((e) => fieldFromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Future<void> _writeLocal(DigitalCard card) async {
    await _db.transaction(() async {
      await _db.into(_db.digitalCards).insertOnConflictUpdate(
            DigitalCardsCompanion.insert(
              id: card.id,
              userId: card.userId,
              firstName: card.firstName,
              lastName: card.lastName,
              photoUrl: drift.Value(card.photoUrl),
              jobTitle: drift.Value(card.jobTitle),
              department: drift.Value(card.department),
              company: drift.Value(card.company),
              headline: drift.Value(card.headline),
              theme: drift.Value(card.theme),
              isDefault: drift.Value(card.isDefault),
              shareSlug: drift.Value(card.shareSlug),
            ),
          );
      await (_db.delete(_db.digitalCardExperiences)
            ..where((t) => t.cardId.equals(card.id)))
          .go();
      for (final e in card.experiences) {
        await _db.into(_db.digitalCardExperiences).insert(
              DigitalCardExperiencesCompanion.insert(
                id: e.id,
                cardId: card.id,
                company: e.company,
                title: e.title,
                startDate: drift.Value(e.startDate),
                endDate: drift.Value(e.endDate),
                isCurrent: drift.Value(e.isCurrent),
              ),
            );
      }
      await (_db.delete(_db.digitalCardExtras)
            ..where((t) => t.cardId.equals(card.id)))
          .go();
      for (final e in card.extras) {
        await _db.into(_db.digitalCardExtras).insert(
              DigitalCardExtrasCompanion.insert(
                id: e.id,
                cardId: card.id,
                kind: e.kind.name,
                payload: jsonEncode(e.payload),
              ),
            );
      }
      await (_db.delete(_db.digitalCardFields)
            ..where((t) => t.cardId.equals(card.id)))
          .go();
      for (final f in card.fields) {
        await _db.into(_db.digitalCardFields).insert(
              DigitalCardFieldsCompanion.insert(
                id: f.id,
                cardId: card.id,
                platform: f.platform,
                label: f.label,
                value: f.value,
                sortOrder: drift.Value(f.sortOrder),
              ),
            );
      }
    });
  }

  Future<void> _pushRemote(DigitalCard card) async {
    final client = supabaseClient;
    await client.from('digital_cards').upsert(digitalCardToJson(card));
    await client.from('digital_card_experiences').delete().eq('card_id', card.id);
    if (card.experiences.isNotEmpty) {
      await client
          .from('digital_card_experiences')
          .insert(card.experiences.map(experienceToJson).toList());
    }
    await client.from('digital_card_extras').delete().eq('card_id', card.id);
    if (card.extras.isNotEmpty) {
      await client.from('digital_card_extras').insert(card.extras.map(extraToJson).toList());
    }
    await client.from('digital_card_fields').delete().eq('card_id', card.id);
    if (card.fields.isNotEmpty) {
      await client.from('digital_card_fields').insert(card.fields.map(fieldToJson).toList());
    }
  }

  Future<void> _handleQueuedPush(String operation, Map<String, dynamic> payload) async {
    if (operation == 'delete') {
      await supabaseClient.from(_table).delete().eq('id', payload['id'] as String);
      return;
    }
    await _pushRemote(_bundleFromJson(payload));
  }

  Future<void> _pullRemote(String userId) async {
    try {
      final client = supabaseClient;
      final cardsJson = await client.from(_table).select().eq('user_id', userId);
      for (final cardJson in cardsJson as List<dynamic>) {
        final cardMap = cardJson as Map<String, dynamic>;
        final cardId = cardMap['id'] as String;
        final experiencesJson = await client
            .from('digital_card_experiences')
            .select()
            .eq('card_id', cardId);
        final extrasJson =
            await client.from('digital_card_extras').select().eq('card_id', cardId);
        final fieldsJson =
            await client.from('digital_card_fields').select().eq('card_id', cardId);
        final card = digitalCardFromJson(
          cardMap,
          experiences: (experiencesJson as List<dynamic>)
              .map((e) => experienceFromJson(e as Map<String, dynamic>))
              .toList(),
          extras: (extrasJson as List<dynamic>)
              .map((e) => extraFromJson(e as Map<String, dynamic>))
              .toList(),
          fields: (fieldsJson as List<dynamic>)
              .map((e) => fieldFromJson(e as Map<String, dynamic>))
              .toList(),
        );
        await _writeLocal(card);
      }
    } catch (_) {
      // Offline veya erişilemez: lokal veriyle devam edilir.
    }
  }

  Future<DigitalCard> _hydrate(DigitalCardRow row) async {
    final experiences = await (_db.select(_db.digitalCardExperiences)
          ..where((t) => t.cardId.equals(row.id)))
        .get();
    final extras =
        await (_db.select(_db.digitalCardExtras)..where((t) => t.cardId.equals(row.id))).get();
    final fields = await (_db.select(_db.digitalCardFields)
          ..where((t) => t.cardId.equals(row.id))
          ..orderBy([(t) => drift.OrderingTerm.asc(t.sortOrder)]))
        .get();
    return DigitalCard(
      id: row.id,
      userId: row.userId,
      firstName: row.firstName,
      lastName: row.lastName,
      photoUrl: row.photoUrl,
      jobTitle: row.jobTitle,
      department: row.department,
      company: row.company,
      headline: row.headline,
      theme: row.theme,
      isDefault: row.isDefault,
      shareSlug: row.shareSlug,
      deletedAt: row.deletedAt,
      experiences: experiences
          .map((e) => DigitalCardExperience(
                id: e.id,
                cardId: e.cardId,
                company: e.company,
                title: e.title,
                startDate: e.startDate,
                endDate: e.endDate,
                isCurrent: e.isCurrent,
              ))
          .toList(),
      extras: extras
          .map((e) => DigitalCardExtra(
                id: e.id,
                cardId: e.cardId,
                kind: DigitalCardExtraKind.values
                    .firstWhere((k) => k.name == e.kind, orElse: () => DigitalCardExtraKind.other),
                payload: jsonDecode(e.payload) as Map<String, dynamic>,
              ))
          .toList(),
      fields: fields
          .map((f) => DigitalCardField(
                id: f.id,
                cardId: f.cardId,
                platform: f.platform,
                label: f.label,
                value: f.value,
                sortOrder: f.sortOrder,
              ))
          .toList(),
    );
  }

  @override
  Stream<List<DigitalCard>> watchCards(String userId) {
    unawaited(_pullRemote(userId));
    return (_db.select(_db.digitalCards)
          ..where((t) => t.userId.equals(userId) & t.deletedAt.isNull()))
        .watch()
        .asyncMap((rows) => Future.wait(rows.map(_hydrate)));
  }

  @override
  Stream<List<DigitalCard>> watchDeletedCards(String userId) {
    return (_db.select(_db.digitalCards)
          ..where((t) => t.userId.equals(userId) & t.deletedAt.isNotNull())
          ..orderBy([(t) => drift.OrderingTerm.desc(t.deletedAt)]))
        .watch()
        .asyncMap((rows) => Future.wait(rows.map(_hydrate)));
  }

  @override
  Future<DigitalCard?> getCard(String id) async {
    final row = await (_db.select(_db.digitalCards)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    if (row == null) return null;
    return _hydrate(row);
  }

  @override
  Future<DigitalCard?> getCardByShareSlug(String slug) async {
    final client = supabaseClient;
    final rows = await client.from(_table).select().eq('share_slug', slug).limit(1);
    final list = rows as List;
    if (list.isEmpty) return null;
    final cardMap = list.first as Map<String, dynamic>;
    final cardId = cardMap['id'] as String;
    final experiencesJson =
        await client.from('digital_card_experiences').select().eq('card_id', cardId);
    final extrasJson = await client.from('digital_card_extras').select().eq('card_id', cardId);
    final fieldsJson = await client.from('digital_card_fields').select().eq('card_id', cardId);
    return digitalCardFromJson(
      cardMap,
      experiences: (experiencesJson as List)
          .map((e) => experienceFromJson(e as Map<String, dynamic>))
          .toList(),
      extras:
          (extrasJson as List).map((e) => extraFromJson(e as Map<String, dynamic>)).toList(),
      fields:
          (fieldsJson as List).map((e) => fieldFromJson(e as Map<String, dynamic>)).toList(),
    );
  }

  @override
  Future<DigitalCard> saveCard(DigitalCard card) async {
    await _writeLocal(card);
    try {
      await _pushRemote(card);
    } catch (_) {
      await _db.enqueueSync(
        entityTable: _table,
        entityId: card.id,
        operation: 'upsert',
        payloadJson: jsonEncode(_bundleToJson(card)),
      );
    }
    return card;
  }

  @override
  Future<void> deleteCard(String id) async {
    final now = DateTime.now();
    await (_db.update(_db.digitalCards)..where((t) => t.id.equals(id)))
        .write(DigitalCardsCompanion(deletedAt: drift.Value(now)));
    try {
      await supabaseClient
          .from(_table)
          .update({'deleted_at': now.toIso8601String()}).eq('id', id);
    } catch (_) {
      // Senkronizasyon kuyruğuna alındı; bağlantı gelince uygulanır.
    }
  }

  @override
  Future<void> restoreCard(String id) async {
    await (_db.update(_db.digitalCards)..where((t) => t.id.equals(id)))
        .write(const DigitalCardsCompanion(deletedAt: drift.Value(null)));
    try {
      await supabaseClient.from(_table).update({'deleted_at': null}).eq('id', id);
    } catch (_) {
      // Senkronizasyon kuyruğuna alındı; bağlantı gelince uygulanır.
    }
  }

  @override
  Future<void> permanentlyDeleteCard(String id) async {
    await (_db.delete(_db.digitalCards)..where((t) => t.id.equals(id))).go();
    try {
      await supabaseClient.from(_table).delete().eq('id', id);
    } catch (_) {
      await _db.enqueueSync(
        entityTable: _table,
        entityId: id,
        operation: 'delete',
        payloadJson: jsonEncode({'id': id}),
      );
    }
  }

  @override
  Future<void> setDefaultCard({required String userId, required String cardId}) async {
    await _db.transaction(() async {
      await (_db.update(_db.digitalCards)..where((t) => t.userId.equals(userId)))
          .write(const DigitalCardsCompanion(isDefault: drift.Value(false)));
      await (_db.update(_db.digitalCards)..where((t) => t.id.equals(cardId)))
          .write(const DigitalCardsCompanion(isDefault: drift.Value(true)));
    });
    try {
      final client = supabaseClient;
      await client.from(_table).update({'is_default': false}).eq('user_id', userId);
      await client.from(_table).update({'is_default': true}).eq('id', cardId);
    } catch (_) {
      // Bağlantı gelince tam kart senkronu bu farkı da giderir.
    }
  }
}
