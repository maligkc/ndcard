import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

@DataClassName('ProfileRow')
class Profiles extends Table {
  TextColumn get id => text()();
  TextColumn get fullName => text().nullable()();
  TextColumn get avatarUrl => text().nullable()();
  TextColumn get phone => text().nullable()();
  TextColumn get language => text().nullable()();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('DigitalCardRow')
class DigitalCards extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get firstName => text()();
  TextColumn get lastName => text()();
  TextColumn get photoUrl => text().nullable()();
  TextColumn get jobTitle => text().nullable()();
  TextColumn get department => text().nullable()();
  TextColumn get company => text().nullable()();
  TextColumn get headline => text().nullable()();
  TextColumn get theme => text().withDefault(const Constant('classic'))();
  BoolColumn get isDefault => boolean().withDefault(const Constant(false))();
  TextColumn get shareSlug => text().nullable()();
  DateTimeColumn get deletedAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('DigitalCardExperienceRow')
class DigitalCardExperiences extends Table {
  TextColumn get id => text()();
  TextColumn get cardId => text()();
  TextColumn get company => text()();
  TextColumn get title => text()();
  DateTimeColumn get startDate => dateTime().nullable()();
  DateTimeColumn get endDate => dateTime().nullable()();
  BoolColumn get isCurrent => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('DigitalCardExtraRow')
class DigitalCardExtras extends Table {
  TextColumn get id => text()();
  TextColumn get cardId => text()();
  TextColumn get kind => text()();
  TextColumn get payload => text()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('DigitalCardFieldRow')
class DigitalCardFields extends Table {
  TextColumn get id => text()();
  TextColumn get cardId => text()();
  TextColumn get platform => text()();
  TextColumn get label => text()();
  TextColumn get value => text()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('ScannedCardRow')
class ScannedCards extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get profileImageUrl => text().nullable()();
  TextColumn get frontImageUrl => text().nullable()();
  TextColumn get backImageUrl => text().nullable()();
  TextColumn get fullName => text().nullable()();
  TextColumn get company => text().nullable()();
  TextColumn get department => text().nullable()();
  TextColumn get jobTitle => text().nullable()();
  BoolColumn get sortByCompany => boolean().withDefault(const Constant(false))();
  TextColumn get rawOcr => text().nullable()();
  DateTimeColumn get lastViewedAt => dateTime().nullable()();
  DateTimeColumn get deletedAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('ScannedCardFieldRow')
class ScannedCardFields extends Table {
  TextColumn get id => text()();
  TextColumn get cardId => text()();
  TextColumn get fieldType => text()();
  TextColumn get label => text()();
  TextColumn get value => text()();
  TextColumn get addressDetail => text().nullable()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('CardGroupRow')
class CardGroups extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get name => text()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('CardGroupMemberRow')
class CardGroupMembers extends Table {
  TextColumn get groupId => text()();
  TextColumn get cardId => text()();

  @override
  Set<Column> get primaryKey => {groupId, cardId};
}

@DataClassName('CardNoteRow')
class CardNotes extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get cardId => text()();
  TextColumn get content => text()();
  TextColumn get noteType => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('CardReminderRow')
class CardReminders extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get cardId => text()();
  DateTimeColumn get remindAt => dateTime()();
  TextColumn get message => text()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('AppNotificationRow')
class AppNotifications extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get title => text()();
  TextColumn get body => text()();
  BoolColumn get isRead => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('UserSettingsRow')
class UserSettingsTable extends Table {
  TextColumn get userId => text()();
  BoolColumn get notificationsEnabled =>
      boolean().withDefault(const Constant(true))();
  BoolColumn get sound => boolean().withDefault(const Constant(true))();
  BoolColumn get vibrate => boolean().withDefault(const Constant(true))();
  TextColumn get language => text().nullable()();

  @override
  Set<Column> get primaryKey => {userId};
}

/// Offline-first yazma kuyruğu: bağlantı yokken yapılan değişiklikler burada
/// birikir, bağlantı gelince [SyncEngine] tarafından sırayla uzak backend'e
/// gönderilir. `entityTable` hedef Postgres tablosunun adıdır.
@DataClassName('PendingSyncQueueData')
class PendingSyncQueue extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get entityTable => text()();
  TextColumn get entityId => text()();
  TextColumn get operation => text()();
  TextColumn get payload => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

@DriftDatabase(tables: [
  Profiles,
  DigitalCards,
  DigitalCardExperiences,
  DigitalCardExtras,
  DigitalCardFields,
  ScannedCards,
  ScannedCardFields,
  CardGroups,
  CardGroupMembers,
  CardNotes,
  CardReminders,
  AppNotifications,
  UserSettingsTable,
  PendingSyncQueue,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.addColumn(digitalCards, digitalCards.deletedAt);
          }
          if (from < 3) {
            await m.addColumn(scannedCards, scannedCards.profileImageUrl);
          }
        },
      );

  Future<void> enqueueSync({
    required String entityTable,
    required String entityId,
    required String operation,
    required String payloadJson,
  }) {
    return into(pendingSyncQueue).insert(
      PendingSyncQueueCompanion.insert(
        entityTable: entityTable,
        entityId: entityId,
        operation: operation,
        payload: payloadJson,
      ),
    );
  }

  Future<List<PendingSyncQueueData>> pendingSyncItems() {
    return (select(pendingSyncQueue)..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
        .get();
  }

  Future<void> removeSyncItem(int id) {
    return (delete(pendingSyncQueue)..where((t) => t.id.equals(id))).go();
  }

  /// Ayarlar -> Genel -> "Önbelleği Temizle". Yalnızca lokal drift önbelleğini
  /// boşaltır; sunucudaki veriyi etkilemez, sonraki açılışta yeniden çekilir.
  /// Henüz gönderilmemiş [pendingSyncQueue] öğeleri korunur.
  Future<void> clearCache() async {
    await batch((b) {
      b.deleteAll(digitalCards);
      b.deleteAll(digitalCardExperiences);
      b.deleteAll(digitalCardExtras);
      b.deleteAll(digitalCardFields);
      b.deleteAll(scannedCards);
      b.deleteAll(scannedCardFields);
      b.deleteAll(profiles);
    });
  }
}

QueryExecutor _openConnection() {
  return driftDatabase(name: 'ndcard_db');
}
