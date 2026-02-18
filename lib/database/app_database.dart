import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'app_database.g.dart';

// Permit Table - FR-01, FR-02, FR-03, FR-04
class Permits extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get permitNumber => text().withLength(max: 20)();
  TextColumn get fullName => text().withLength(max: 50)();
  TextColumn get permitType => text()(); // 'Hajj' or 'Umrah'
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime()();
  TextColumn get encryptedData => text().nullable()(); // Encrypted permit info
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

// Settings Table (backup for SharedPreferences)
class AppSettings extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get key => text().unique()();
  TextColumn get value => text()();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

// Duas Table - FR-08: Islamic prayers for ritual locations
class Duas extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get locationId => text()(); // Links to GeofenceLocations
  TextColumn get ritualType => text()(); // 'self' or 'proxy'
  TextColumn get arabicText => text()();
  TextColumn get englishTranslation => text()();
  TextColumn get transliteration => text().nullable()();
  TextColumn get audioFileName =>
      text().nullable()(); // For future audio feature
  IntColumn get displayOrder => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

// GeofenceLocations Table - FR-06: Holy site locations
class GeofenceLocations extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get locationId => text().unique()(); // e.g., 'maqam_ibrahim'
  TextColumn get nameEn => text()();
  TextColumn get nameAr => text()();
  TextColumn get description => text()();
  RealColumn get latitude => real()();
  RealColumn get longitude => real()();
  RealColumn get radiusMeters => real()(); // Geofence radius
  TextColumn get ritualName => text()(); // 'tawaf', 'sai', etc.
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

// RitualSettings Table - FR-07: User ritual preferences
class RitualSettings extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get ritualType => text()(); // 'self' or 'proxy'
  TextColumn get selectedRitual => text()(); // 'tawaf', 'sai', 'arafah', etc.
  BoolColumn get audioEnabled => boolean().withDefault(const Constant(false))();
  BoolColumn get hapticEnabled => boolean().withDefault(const Constant(true))();
  IntColumn get audioVolume =>
      integer().withDefault(const Constant(80))(); // 0-100
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

// ChatConversations Table - AI Chatbot conversation threads
class ChatConversations extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(max: 100)();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

// ChatMessages Table - Individual messages in conversations
class ChatMessages extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get conversationId => integer().references(
    ChatConversations,
    #id,
    onDelete: KeyAction.cascade,
  )();
  TextColumn get content => text()();
  BoolColumn get isUser => boolean()();
  DateTimeColumn get timestamp => dateTime().withDefault(currentDateAndTime)();
}

@DriftDatabase(
  tables: [
    Permits,
    AppSettings,
    Duas,
    GeofenceLocations,
    RitualSettings,
    ChatConversations,
    ChatMessages,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 3; // Incremented for chat tables

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
    },
    onUpgrade: (Migrator m, int from, int to) async {
      if (from < 2) {
        // Add new tables for ritual guidance
        await m.createTable(duas);
        await m.createTable(geofenceLocations);
        await m.createTable(ritualSettings);
      }
      if (from < 3) {
        // Add chat tables
        await m.createTable(chatConversations);
        await m.createTable(chatMessages);
      }
    },
  );

  // Permit CRUD Operations
  Future<List<Permit>> getAllPermits() => select(permits).get();

  Future<Permit?> getPermit() => select(permits).getSingleOrNull();

  Stream<Permit?> watchPermit() => select(permits).watchSingleOrNull();

  Future<int> insertPermit(PermitsCompanion permit) =>
      into(permits).insert(permit);

  Future<bool> updatePermit(PermitsCompanion permit) =>
      update(permits).replace(permit);

  Future<int> deletePermit(int id) =>
      (delete(permits)..where((t) => t.id.equals(id))).go();

  Future<void> deleteAllPermits() => delete(permits).go();

  // Settings CRUD Operations
  Future<String?> getSetting(String key) async {
    final result = await (select(
      appSettings,
    )..where((t) => t.key.equals(key))).getSingleOrNull();
    return result?.value;
  }

  Future<void> saveSetting(String key, String value) async {
    await into(appSettings).insertOnConflictUpdate(
      AppSettingsCompanion.insert(
        key: key,
        value: value,
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  // Duas CRUD Operations
  Future<List<Dua>> getDuasForLocation(String locationId, String ritualType) =>
      (select(duas)
            ..where(
              (t) =>
                  t.locationId.equals(locationId) &
                  t.ritualType.equals(ritualType),
            )
            ..orderBy([(t) => OrderingTerm(expression: t.displayOrder)]))
          .get();

  Future<int> insertDua(DuasCompanion dua) => into(duas).insert(dua);

  Future<void> insertMultipleDuas(List<DuasCompanion> duasList) async {
    await batch((batch) {
      batch.insertAll(duas, duasList);
    });
  }

  Future<void> clearAllDuas() => delete(duas).go();

  // GeofenceLocations CRUD Operations
  Future<List<GeofenceLocation>> getAllLocations() =>
      (select(geofenceLocations)..where((t) => t.isActive.equals(true))).get();

  Future<GeofenceLocation?> getLocationById(String locationId) => (select(
    geofenceLocations,
  )..where((t) => t.locationId.equals(locationId))).getSingleOrNull();

  Future<List<GeofenceLocation>> getLocationsByRitual(String ritualName) =>
      (select(geofenceLocations)..where(
            (t) => t.ritualName.equals(ritualName) & t.isActive.equals(true),
          ))
          .get();

  Future<int> insertLocation(GeofenceLocationsCompanion location) =>
      into(geofenceLocations).insert(location);

  Future<void> insertMultipleLocations(
    List<GeofenceLocationsCompanion> locationsList,
  ) async {
    await batch((batch) {
      batch.insertAll(geofenceLocations, locationsList);
    });
  }

  Future<void> clearAllLocations() => delete(geofenceLocations).go();

  // RitualSettings CRUD Operations
  Future<RitualSetting?> getRitualSettings() =>
      select(ritualSettings).getSingleOrNull();

  Future<void> saveRitualSettings(RitualSettingsCompanion settings) async {
    final existing = await getRitualSettings();
    if (existing == null) {
      await into(ritualSettings).insert(settings);
    } else {
      await (update(
        ritualSettings,
      )..where((t) => t.id.equals(existing.id))).write(settings);
    }
  }

  // ChatConversations CRUD Operations
  Future<List<ChatConversation>> getAllConversations() =>
      (select(chatConversations)..orderBy([
            (t) =>
                OrderingTerm(expression: t.updatedAt, mode: OrderingMode.desc),
          ]))
          .get();

  Stream<List<ChatConversation>> watchAllConversations() =>
      (select(chatConversations)..orderBy([
            (t) =>
                OrderingTerm(expression: t.updatedAt, mode: OrderingMode.desc),
          ]))
          .watch();

  Future<ChatConversation?> getConversation(int id) => (select(
    chatConversations,
  )..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<int> createConversation(String title) async {
    return await into(chatConversations).insert(
      ChatConversationsCompanion.insert(
        title: title,
        createdAt: Value(DateTime.now()),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> updateConversationTitle(int id, String title) async {
    await (update(chatConversations)..where((t) => t.id.equals(id))).write(
      ChatConversationsCompanion(
        title: Value(title),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> updateConversationTimestamp(int id) async {
    await (update(chatConversations)..where((t) => t.id.equals(id))).write(
      ChatConversationsCompanion(updatedAt: Value(DateTime.now())),
    );
  }

  Future<void> deleteConversation(int id) async {
    await (delete(chatConversations)..where((t) => t.id.equals(id))).go();
  }

  // ChatMessages CRUD Operations
  Future<List<ChatMessage>> getMessagesForConversation(int conversationId) =>
      (select(chatMessages)
            ..where((t) => t.conversationId.equals(conversationId))
            ..orderBy([(t) => OrderingTerm(expression: t.timestamp)]))
          .get();

  Stream<List<ChatMessage>> watchMessagesForConversation(int conversationId) =>
      (select(chatMessages)
            ..where((t) => t.conversationId.equals(conversationId))
            ..orderBy([(t) => OrderingTerm(expression: t.timestamp)]))
          .watch();

  Future<int> insertMessage(ChatMessagesCompanion message) async {
    final id = await into(chatMessages).insert(message);
    // Update conversation timestamp
    if (message.conversationId.present) {
      await updateConversationTimestamp(message.conversationId.value);
    }
    return id;
  }

  Future<void> deleteMessagesForConversation(int conversationId) async {
    await (delete(
      chatMessages,
    )..where((t) => t.conversationId.equals(conversationId))).go();
  }

  Future<void> clearAllConversations() async {
    await delete(chatMessages).go();
    await delete(chatConversations).go();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'hajj_companion.db'));
    return NativeDatabase.createInBackground(file);
  });
}
