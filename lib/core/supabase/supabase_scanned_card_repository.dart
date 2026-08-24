import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

import 'package:drift/drift.dart' as drift;

import '../db/app_database.dart';
import '../db/sync/sync_engine.dart';
import '../domain/entities/scanned_card.dart';
import '../domain/repositories/scanned_card_repository.dart';
import 'mappers.dart';
import 'supabase_client_provider.dart';

const String _table = 'scanned_cards';

/// Tek _pullRemote çağrısında kaç kart sayfalandırılır.
const int _pullPageSize = 500;

/// Toplu push'ta kaç kart tek upsert'e dahil edilir.
const int _pushChunkSize = 200;

class SupabaseScannedCardRepository implements ScannedCardRepository {
  SupabaseScannedCardRepository(this._db, this._syncEngine) {
    _syncEngine.registerHandler(_table, _handleQueuedPush);
  }

  final AppDatabase _db;
  final SyncEngine _syncEngine;

  /// Son başarılı _pullRemote zamanı. 5 dakika geçmeden tekrar çekilmez.
  DateTime? _lastPull;
  static const _pullCooldown = Duration(minutes: 5);

  Map<String, dynamic> _bundleToJson(ScannedCard card) => {
        'card': scannedCardToJson(card),
        'fields': card.fields.map(scannedFieldToJson).toList(),
      };

  ScannedCard _bundleFromJson(Map<String, dynamic> json) {
    return scannedCardFromJson(
      json['card'] as Map<String, dynamic>,
      fields: (json['fields'] as List<dynamic>)
          .map((e) => scannedFieldFromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  ScannedCardsCompanion _cardCompanion(ScannedCard card) =>
      ScannedCardsCompanion.insert(
        id: card.id,
        userId: card.userId,
        profileImageUrl: drift.Value(card.profileImageUrl),
        frontImageUrl: drift.Value(card.frontImageUrl),
        backImageUrl: drift.Value(card.backImageUrl),
        fullName: drift.Value(card.fullName),
        company: drift.Value(card.company),
        department: drift.Value(card.department),
        jobTitle: drift.Value(card.jobTitle),
        sortByCompany: drift.Value(card.sortByCompany),
        rawOcr: drift.Value(card.rawOcr == null ? null : jsonEncode(card.rawOcr)),
        lastViewedAt: drift.Value(card.lastViewedAt),
        deletedAt: drift.Value(card.deletedAt),
      );

  ScannedCardFieldsCompanion _fieldCompanion(ScannedCardField f, String cardId) =>
      ScannedCardFieldsCompanion.insert(
        id: f.id,
        cardId: cardId,
        fieldType: f.fieldType,
        label: f.label,
        value: f.value,
        addressDetail: drift.Value(
          f.addressDetail == null ? null : jsonEncode(addressDetailToJson(f.addressDetail!)),
        ),
        sortOrder: drift.Value(f.sortOrder),
      );

  /// Transaction sarmalamadan tekil kart yazma (saveCard için).
  Future<void> _writeLocalInTx(ScannedCard card) async {
    await _db.into(_db.scannedCards).insertOnConflictUpdate(_cardCompanion(card));
    await (_db.delete(_db.scannedCardFields)..where((t) => t.cardId.equals(card.id))).go();
    if (card.fields.isNotEmpty) {
      await _db.batch((b) {
        b.insertAll(_db.scannedCardFields,
            card.fields.map((f) => _fieldCompanion(f, card.id)).toList());
      });
    }
  }

  /// Çok sayıda kartı tek transaction + Drift batch ile yazar.
  /// N kart için: 1 batch upsert (kartlar) + ceil(N/999) DELETE + 1 batch insert (field'lar).
  Future<void> _writeBatch(List<ScannedCard> cards) async {
    if (cards.isEmpty) return;
    await _db.transaction(() async {
      // 1. Kartları toplu upsert
      await _db.batch((b) {
        b.insertAllOnConflictUpdate(
            _db.scannedCards, cards.map(_cardCompanion).toList());
      });

      // 2. Mevcut field'ları toplu sil (999 değişken sınırı)
      final ids = cards.map((c) => c.id).toList();
      for (var i = 0; i < ids.length; i += 999) {
        final chunk = ids.sublist(i, min(i + 999, ids.length));
        await (_db.delete(_db.scannedCardFields)
              ..where((t) => t.cardId.isIn(chunk)))
            .go();
      }

      // 3. Yeni field'ları toplu insert
      final allFields = [
        for (final c in cards)
          for (final f in c.fields) _fieldCompanion(f, c.id),
      ];
      if (allFields.isNotEmpty) {
        await _db.batch((b) => b.insertAll(_db.scannedCardFields, allFields));
      }
    });
  }

  Future<void> _writeLocal(ScannedCard card) async {
    await _db.transaction(() => _writeLocalInTx(card));
  }

  Future<void> _pushRemote(ScannedCard card) async {
    final client = supabaseClient;
    await client.from(_table).upsert(scannedCardToJson(card));
    await client.from('scanned_card_fields').delete().eq('card_id', card.id);
    if (card.fields.isNotEmpty) {
      await client.from('scanned_card_fields').insert(card.fields.map(scannedFieldToJson).toList());
    }
  }

  Future<void> _handleQueuedPush(String operation, Map<String, dynamic> payload) async {
    if (operation == 'delete') {
      await supabaseClient.from(_table).delete().eq('id', payload['id'] as String);
      return;
    }
    if (operation == 'patch') {
      await supabaseClient
          .from(_table)
          .update(payload['changes'] as Map<String, dynamic>)
          .eq('id', payload['id'] as String);
      return;
    }
    await _pushRemote(_bundleFromJson(payload));
  }

  /// Tüm kartları Supabase'den tek JOIN sorgusuyla çeker; sayfalandırma uygular.
  /// Eskiden: N kart → N+1 API çağrısı (her kart için ayrı fields sorgusu).
  /// Şimdi: ceil(N/500) sayfa × 1 çağrı + 1 _writeBatch çağrısı.
  /// 5 dakika geçmeden tekrar çekilmez (pull cooldown).
  Future<void> _pullRemote(String userId) async {
    final now = DateTime.now();
    if (_lastPull != null && now.difference(_lastPull!) < _pullCooldown) return;

    // Bağlantı yoksa atla — bir sonraki watchCards çağrısında retry edilir.
    final connectivity = await Connectivity().checkConnectivity();
    if (connectivity.contains(ConnectivityResult.none)) return;

    debugPrint('[pullRemote] başladı — userId: $userId');

    try {
      final client = supabaseClient;
      final allCards = <ScannedCard>[];
      int offset = 0;

      while (true) {
        final page = await client
            .from(_table)
            .select('*, scanned_card_fields(*)')
            .eq('user_id', userId)
            .range(offset, offset + _pullPageSize - 1) as List<dynamic>;

        for (final row in page) {
          final cardMap = row as Map<String, dynamic>;
          final fieldsJson = (cardMap['scanned_card_fields'] as List<dynamic>?) ?? [];
          allCards.add(scannedCardFromJson(
            cardMap,
            fields: fieldsJson
                .map((e) => scannedFieldFromJson(e as Map<String, dynamic>))
                .toList(),
          ));
        }

        if (page.length < _pullPageSize) break;
        offset += _pullPageSize;
      }

      debugPrint('[pullRemote] ${allCards.length} kart çekildi');

      // Yerel olarak soft-delete edilmiş kartların deletedAt değerini koru:
      // Remote'dan null gelen deletedAt, yerel set edilmiş değerin üzerine yazmamalı.
      final localDeletedRows = await (_db.select(_db.scannedCards)
            ..where((t) => t.userId.equals(userId) & t.deletedAt.isNotNull()))
          .get();
      final localDeletedAt = {
        for (final r in localDeletedRows) r.id: r.deletedAt!,
      };

      final mergedCards = allCards.map((card) {
        if (card.deletedAt == null && localDeletedAt.containsKey(card.id)) {
          return ScannedCard(
            id: card.id,
            userId: card.userId,
            profileImageUrl: card.profileImageUrl,
            frontImageUrl: card.frontImageUrl,
            backImageUrl: card.backImageUrl,
            fullName: card.fullName,
            company: card.company,
            department: card.department,
            jobTitle: card.jobTitle,
            sortByCompany: card.sortByCompany,
            rawOcr: card.rawOcr,
            lastViewedAt: card.lastViewedAt,
            deletedAt: localDeletedAt[card.id], // yerel değeri koru
            createdAt: card.createdAt,
            fields: card.fields,
          );
        }
        return card;
      }).toList();

      // Tüm kartları tek batch işlemle yaz → stream yalnızca 1 kez tetiklenir.
      await _writeBatch(mergedCards);
      _lastPull = now;
    } catch (e, st) {
      // Offline veya auth hatası — lokal veriyle devam edilir.
      // Debug modunda hatayı göster.
      debugPrint('[pullRemote] hata: $e\n$st');
    }
  }

  ScannedCard _rowToCard(ScannedCardRow row, List<ScannedCardFieldRow> fields) => ScannedCard(
        id: row.id,
        userId: row.userId,
        profileImageUrl: row.profileImageUrl,
        frontImageUrl: row.frontImageUrl,
        backImageUrl: row.backImageUrl,
        fullName: row.fullName,
        company: row.company,
        department: row.department,
        jobTitle: row.jobTitle,
        sortByCompany: row.sortByCompany,
        rawOcr: row.rawOcr == null ? null : jsonDecode(row.rawOcr!) as Map<String, dynamic>,
        lastViewedAt: row.lastViewedAt,
        deletedAt: row.deletedAt,
        createdAt: row.createdAt,
        fields: fields
            .map((f) => ScannedCardField(
                  id: f.id,
                  cardId: f.cardId,
                  fieldType: f.fieldType,
                  label: f.label,
                  value: f.value,
                  addressDetail: f.addressDetail == null
                      ? null
                      : addressDetailFromJson(
                          jsonDecode(f.addressDetail!) as Map<String, dynamic>),
                  sortOrder: f.sortOrder,
                ))
            .toList(),
      );

  /// Tek kart için (getCard, saveCard dönüşü).
  Future<ScannedCard> _hydrate(ScannedCardRow row) async {
    final fields = await (_db.select(_db.scannedCardFields)
          ..where((t) => t.cardId.equals(row.id))
          ..orderBy([(t) => drift.OrderingTerm.asc(t.sortOrder)]))
        .get();
    return _rowToCard(row, fields);
  }

  /// N kart için ceil(N/999) SQLite sorgusuyla tüm field'ları toplu çeker.
  /// Eskiden: N sorgu (her kart için 1). Şimdi: en fazla ceil(N/999) sorgu.
  Future<List<ScannedCard>> _hydrateAll(List<ScannedCardRow> rows) async {
    if (rows.isEmpty) return [];

    // Tüm field'ları chunked IN sorgusuyla çek
    final allFields = <ScannedCardFieldRow>[];
    for (var i = 0; i < rows.length; i += 999) {
      final chunk = rows.sublist(i, min(i + 999, rows.length));
      final chunkIds = chunk.map((r) => r.id).toList();
      final fields = await (_db.select(_db.scannedCardFields)
            ..where((t) => t.cardId.isIn(chunkIds))
            ..orderBy([(t) => drift.OrderingTerm.asc(t.sortOrder)]))
          .get();
      allFields.addAll(fields);
    }

    // cardId → field listesi haritası
    final fieldsByCard = <String, List<ScannedCardFieldRow>>{};
    for (final f in allFields) {
      fieldsByCard.putIfAbsent(f.cardId, () => []).add(f);
    }

    return rows.map((r) => _rowToCard(r, fieldsByCard[r.id] ?? [])).toList();
  }

  @override
  Stream<List<ScannedCard>> watchCards(
    String userId, {
    ScannedCardSort sort = ScannedCardSort.date,
    bool includeDeleted = false,
  }) {
    unawaited(_pullRemote(userId));
    final query = _db.select(_db.scannedCards)..where((t) => t.userId.equals(userId));
    if (!includeDeleted) {
      query.where((t) => t.deletedAt.isNull());
    }
    switch (sort) {
      case ScannedCardSort.date:
        query.orderBy([(t) => drift.OrderingTerm.desc(t.createdAt)]);
        break;
      case ScannedCardSort.name:
        query.orderBy([(t) => drift.OrderingTerm.asc(t.fullName)]);
        break;
      case ScannedCardSort.company:
        query.orderBy([(t) => drift.OrderingTerm.asc(t.company)]);
        break;
    }
    return query.watch().asyncMap(_hydrateAll);
  }

  @override
  Future<ScannedCard?> getCard(String id) async {
    final row =
        await (_db.select(_db.scannedCards)..where((t) => t.id.equals(id))).getSingleOrNull();
    if (row == null) return null;
    return _hydrate(row);
  }

  @override
  Stream<ScannedCard?> watchCard(String id) {
    return (_db.select(_db.scannedCards)..where((t) => t.id.equals(id)))
        .watchSingleOrNull()
        .asyncMap((row) async => row == null ? null : await _hydrate(row));
  }

  @override
  Future<ScannedCard> saveCard(ScannedCard card) async {
    await _writeLocal(card);
    try {
      await _pushRemote(card);
    } catch (e) {
      debugPrint('[saveCard] push hatası, kuyruğa ekleniyor: $e');
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
  Future<void> pullNow(String userId) async {
    _lastPull = null;
    await _pullRemote(userId);
  }

  @override
  Future<void> saveCards(List<ScannedCard> cards) async {
    if (cards.isEmpty) return;

    // 1. Tüm kartları tek batch işlemle yerel DB'ye yaz.
    //    Stream yalnızca 1 kez tetiklenir; UI tüm kartları aynı anda görür.
    await _writeBatch(cards);

    // 2. Supabase'e toplu yükle; _pushChunkSize'lı parçalar halinde.
    try {
      for (var i = 0; i < cards.length; i += _pushChunkSize) {
        final chunk = cards.sublist(i, min(i + _pushChunkSize, cards.length));

        await supabaseClient.from(_table).upsert(
              chunk.map(scannedCardToJson).toList(),
            );

        await supabaseClient
            .from('scanned_card_fields')
            .delete()
            .inFilter('card_id', chunk.map((c) => c.id).toList());

        final allFields =
            chunk.expand((c) => c.fields).map(scannedFieldToJson).toList();
        if (allFields.isNotEmpty) {
          await supabaseClient.from('scanned_card_fields').insert(allFields);
        }
      }
    } catch (_) {
      // Ağ başarısız → her kartı sync kuyruğuna ekle
      for (final card in cards) {
        await _db.enqueueSync(
          entityTable: _table,
          entityId: card.id,
          operation: 'upsert',
          payloadJson: jsonEncode(_bundleToJson(card)),
        );
      }
    }
  }

  Future<void> _patch(String id, Map<String, dynamic> changes) async {
    try {
      await supabaseClient.from(_table).update(changes).eq('id', id);
    } catch (_) {
      await _db.enqueueSync(
        entityTable: _table,
        entityId: id,
        operation: 'patch',
        payloadJson: jsonEncode({'id': id, 'changes': changes}),
      );
    }
  }

  @override
  Future<void> softDeleteCard(String id) async {
    final now = DateTime.now();
    await (_db.update(_db.scannedCards)..where((t) => t.id.equals(id)))
        .write(ScannedCardsCompanion(deletedAt: drift.Value(now)));
    await _patch(id, {'deleted_at': now.toIso8601String()});
  }

  @override
  Future<void> restoreCard(String id) async {
    await (_db.update(_db.scannedCards)..where((t) => t.id.equals(id)))
        .write(const ScannedCardsCompanion(deletedAt: drift.Value(null)));
    await _patch(id, {'deleted_at': null});
  }

  @override
  Future<void> permanentlyDeleteCard(String id) async {
    await (_db.delete(_db.scannedCards)..where((t) => t.id.equals(id))).go();
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
  Future<void> markViewed(String id) async {
    final now = DateTime.now();
    await (_db.update(_db.scannedCards)..where((t) => t.id.equals(id)))
        .write(ScannedCardsCompanion(lastViewedAt: drift.Value(now)));
    await _patch(id, {'last_viewed_at': now.toIso8601String()});
  }
}
