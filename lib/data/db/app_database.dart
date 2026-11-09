import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'app_database.g.dart';

// ── Tables ──────────────────────────────────────────────────────────────────

class Medicines extends Table {
  TextColumn get id => text()(); // UUID v4
  TextColumn get name => text().withLength(min: 1, max: 120)();
  TextColumn get doseNote => text().withDefault(const Constant(''))();
  TextColumn get foodRelation => text().withDefault(const Constant('none'))(); // none, before, after, with
  IntColumn get stockCount => integer().withDefault(const Constant(-1))(); // -1 = not tracked
  RealColumn get unitsPerDose => real().withDefault(const Constant(1.0))();
  IntColumn get refillThresholdDays => integer().withDefault(const Constant(7))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class Schedules extends Table {
  TextColumn get id => text()(); // UUID v4
  TextColumn get medicineId => text().nullable().references(Medicines, #id)();
  TextColumn get alertType => text().withDefault(const Constant('medicine'))(); // medicine, meeting, alarm, custom
  TextColumn get label => text().withLength(min: 1, max: 120)();
  IntColumn get timeMinutes => integer()(); // minutes since midnight (0..1439)
  IntColumn get daysMask => integer().withDefault(const Constant(127))(); // bit0=Mon..bit6=Sun (127 = every day)
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime().nullable()();
  BoolColumn get enabled => boolean().withDefault(const Constant(true))();
  TextColumn get voiceLang => text().withDefault(const Constant('ta'))(); // ta, en
  TextColumn get voiceFilePath => text().withDefault(const Constant(''))();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class DoseLogs extends Table {
  TextColumn get id => text()(); // UUID v4
  TextColumn get scheduleId => text().references(Schedules, #id)();
  DateTimeColumn get scheduledAt => dateTime()();
  TextColumn get status => text()(); // pending, taken, skipped, missed, snoozed
  DateTimeColumn get actedAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class ScheduledAlarms extends Table {
  IntColumn get alarmId => integer()(); // 31-bit integer for AlarmManager
  TextColumn get scheduleId => text().references(Schedules, #id)();
  DateTimeColumn get fireAt => dateTime()();
  TextColumn get voiceFilePath => text().withDefault(const Constant(''))();

  @override
  Set<Column> get primaryKey => {alarmId};
}

class AppSettings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}

class DigestCache extends Table {
  TextColumn get date => text()(); // YYYY-MM-DD
  TextColumn get json => text()();
  DateTimeColumn get fetchedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {date};
}

// ── Database ─────────────────────────────────────────────────────────────────

@DriftDatabase(tables: [Medicines, Schedules, DoseLogs, ScheduledAlarms, AppSettings, DigestCache])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // Settings helpers
  Future<String?> getSetting(String key) async {
    final row = await (select(appSettings)..where((t) => t.key.equals(key))).getSingleOrNull();
    return row?.value;
  }

  Future<void> setSetting(String key, String value) async {
    await into(appSettings).insertOnConflictUpdate(AppSettingsCompanion(
      key: Value(key),
      value: Value(value),
    ));
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'neuraalert.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
