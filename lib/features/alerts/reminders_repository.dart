import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neuraalert/data/db/app_database.dart';
import 'package:neuraalert/main.dart';
import 'package:neuraalert/services/scheduler_service.dart';
import 'package:uuid/uuid.dart';

class ScheduleWithMedicine {
  final Schedule schedule;
  final Medicine? medicine;

  ScheduleWithMedicine({
    required this.schedule,
    this.medicine,
  });
}

class DoseLogWithSchedule {
  final DoseLog log;
  final Schedule? schedule;

  DoseLogWithSchedule({
    required this.log,
    this.schedule,
  });
}

class RemindersRepository {
  final AppDatabase _db;
  final SchedulerService _scheduler;
  final _uuid = const Uuid();

  RemindersRepository(this._db, this._scheduler);

  Stream<List<ScheduleWithMedicine>> watchActiveSchedules() {
    final query = _db.select(_db.schedules).join([
      leftOuterJoin(
          _db.medicines, _db.medicines.id.equalsExp(_db.schedules.medicineId)),
    ])..where(_db.schedules.deletedAt.isNull());

    query.orderBy([
      OrderingTerm.asc(_db.schedules.timeMinutes),
    ]);

    return query.watch().map((rows) {
      return rows.map((row) {
        return ScheduleWithMedicine(
          schedule: row.readTable(_db.schedules),
          medicine: row.readTableOrNull(_db.medicines),
        );
      }).toList();
    });
  }

  /// Watches dose logs whose scheduledAt falls within today [00:00, 24:00)
  Stream<List<DoseLog>> watchTodayDoseLogs() {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day);
    final end = start.add(const Duration(days: 1));
    return (_db.select(_db.doseLogs)
          ..where((t) =>
              t.scheduledAt.isBiggerOrEqualValue(start) &
              t.scheduledAt.isSmallerThanValue(end))
          ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)]))
        .watch();
  }

  /// Watches recent dose logs (last [days] days) joined with schedule metadata
  Stream<List<DoseLogWithSchedule>> watchRecentDoseLogs({int days = 7}) {
    final now = DateTime.now();
    final since = DateTime(now.year, now.month, now.day)
        .subtract(Duration(days: days - 1));

    final query = _db.select(_db.doseLogs).join([
      leftOuterJoin(
          _db.schedules, _db.schedules.id.equalsExp(_db.doseLogs.scheduleId)),
    ])
      ..where(_db.doseLogs.scheduledAt.isBiggerOrEqualValue(since))
      ..orderBy([OrderingTerm.desc(_db.doseLogs.scheduledAt)]);

    return query.watch().map((rows) {
      return rows.map((row) {
        return DoseLogWithSchedule(
          log: row.readTable(_db.doseLogs),
          schedule: row.readTableOrNull(_db.schedules),
        );
      }).toList();
    });
  }

  /// Records a manual dose action from the Today screen (or updates today's latest log)
  Future<void> logManualDose({
    required Schedule schedule,
    required String status, // 'taken' or 'skipped'
  }) async {
    final now = DateTime.now();
    final scheduledAt = DateTime(
      now.year,
      now.month,
      now.day,
      schedule.timeMinutes ~/ 60,
      schedule.timeMinutes % 60,
    );

    final start = DateTime(now.year, now.month, now.day);
    final end = start.add(const Duration(days: 1));

    final existing = await (_db.select(_db.doseLogs)
          ..where((t) =>
              t.scheduleId.equals(schedule.id) &
              t.scheduledAt.isBiggerOrEqualValue(start) &
              t.scheduledAt.isSmallerThanValue(end))
          ..limit(1))
        .getSingleOrNull();

    if (existing != null) {
      await (_db.update(_db.doseLogs)..where((t) => t.id.equals(existing.id)))
          .write(DoseLogsCompanion(
        status: Value(status),
        actedAt: Value(now),
        updatedAt: Value(now),
      ));
    } else {
      await _db.into(_db.doseLogs).insert(
            DoseLogsCompanion(
              id: Value(_uuid.v4()),
              scheduleId: Value(schedule.id),
              scheduledAt: Value(scheduledAt),
              status: Value(status),
              actedAt: Value(now),
              updatedAt: Value(now),
            ),
          );
    }
  }

  static bool isScheduledForDate(Schedule schedule, DateTime day) {
    if (!schedule.enabled || schedule.deletedAt != null) return false;
    final dayStart = DateTime(day.year, day.month, day.day);
    final startDay = DateTime(
        schedule.startDate.year, schedule.startDate.month, schedule.startDate.day);
    if (dayStart.isBefore(startDay)) return false;
    if (schedule.endDate != null) {
      final endDay = DateTime(
          schedule.endDate!.year, schedule.endDate!.month, schedule.endDate!.day);
      if (dayStart.isAfter(endDay)) return false;
    }
    final bit = 1 << (day.weekday - 1);
    return (schedule.daysMask & bit) != 0;
  }

  Future<void> createSchedule({
    required String alertType,
    required String label,
    required int timeMinutes,
    int daysMask = 127,
    String doseNote = '',
    String foodRelation = 'none',
    String voiceLang = 'ta',
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final scheduleId = _uuid.v4();
    String? medicineId;

    if (alertType == 'medicine') {
      medicineId = _uuid.v4();
      await _db.into(_db.medicines).insert(
            MedicinesCompanion(
              id: Value(medicineId),
              name: Value(label),
              doseNote: Value(doseNote),
              foodRelation: Value(foodRelation),
              createdAt: Value(DateTime.now()),
              updatedAt: Value(DateTime.now()),
            ),
          );
    }

    String voicePath = '';
    try {
      voicePath = await _scheduler.ensureVoiceFileForSchedule(
        scheduleId: scheduleId,
        alertType: alertType,
        label: label,
        voiceLang: voiceLang,
        doseNote: doseNote,
        foodRelation: foodRelation,
      );
    } catch (_) {}

    final now = DateTime.now();
    await _db.into(_db.schedules).insert(
          SchedulesCompanion(
            id: Value(scheduleId),
            medicineId: Value(medicineId),
            alertType: Value(alertType),
            label: Value(label),
            timeMinutes: Value(timeMinutes),
            daysMask: Value(daysMask),
            startDate: Value(startDate ?? now),
            endDate: Value(endDate),
            enabled: const Value(true),
            voiceLang: Value(voiceLang),
            voiceFilePath: Value(voicePath),
            updatedAt: Value(now),
          ),
        );

    await _scheduler.topUp();
  }

  Future<void> updateSchedule({
    required String scheduleId,
    required String alertType,
    required String label,
    required int timeMinutes,
    int daysMask = 127,
    String doseNote = '',
    String foodRelation = 'none',
    String voiceLang = 'ta',
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final existingSchedule = await (_db.select(_db.schedules)
          ..where((t) => t.id.equals(scheduleId)))
        .getSingleOrNull();

    if (existingSchedule == null) return;

    if (existingSchedule.medicineId != null) {
      await (_db.update(_db.medicines)
            ..where((t) => t.id.equals(existingSchedule.medicineId!)))
          .write(
        MedicinesCompanion(
          name: Value(label),
          doseNote: Value(doseNote),
          foodRelation: Value(foodRelation),
          updatedAt: Value(DateTime.now()),
        ),
      );
    } else if (alertType == 'medicine') {
      final newMedId = _uuid.v4();
      await _db.into(_db.medicines).insert(
            MedicinesCompanion(
              id: Value(newMedId),
              name: Value(label),
              doseNote: Value(doseNote),
              foodRelation: Value(foodRelation),
              createdAt: Value(DateTime.now()),
              updatedAt: Value(DateTime.now()),
            ),
          );
      await (_db.update(_db.schedules)..where((t) => t.id.equals(scheduleId)))
          .write(SchedulesCompanion(medicineId: Value(newMedId)));
    }

    await _scheduler.cancelScheduleAlarms(scheduleId);

    String voicePath = '';
    try {
      voicePath = await _scheduler.ensureVoiceFileForSchedule(
        scheduleId: scheduleId,
        alertType: alertType,
        label: label,
        voiceLang: voiceLang,
        doseNote: doseNote,
        foodRelation: foodRelation,
      );
    } catch (_) {}

    await (_db.update(_db.schedules)..where((t) => t.id.equals(scheduleId)))
        .write(
      SchedulesCompanion(
        alertType: Value(alertType),
        label: Value(label),
        timeMinutes: Value(timeMinutes),
        daysMask: Value(daysMask),
        startDate:
            startDate != null ? Value(startDate) : const Value.absent(),
        endDate: Value(endDate),
        voiceLang: Value(voiceLang),
        voiceFilePath: Value(voicePath),
        updatedAt: Value(DateTime.now()),
      ),
    );

    await _scheduler.topUp();
  }

  Future<void> toggleScheduleEnabled(String scheduleId, bool enabled) async {
    await (_db.update(_db.schedules)..where((t) => t.id.equals(scheduleId)))
        .write(
      SchedulesCompanion(
        enabled: Value(enabled),
        updatedAt: Value(DateTime.now()),
      ),
    );

    if (!enabled) {
      await _scheduler.cancelScheduleAlarms(scheduleId);
    } else {
      await _scheduler.topUp();
    }
  }

  Future<void> deleteSchedule(String scheduleId) async {
    await _scheduler.cancelScheduleAlarms(scheduleId);

    await (_db.update(_db.schedules)..where((t) => t.id.equals(scheduleId)))
        .write(
      SchedulesCompanion(
        deletedAt: Value(DateTime.now()),
        enabled: const Value(false),
      ),
    );
  }
}

// ── Providers ────────────────────────────────────────────────────────────────

final schedulerServiceProvider = Provider<SchedulerService>((ref) {
  return SchedulerService();
});

final remindersRepositoryProvider = Provider<RemindersRepository>((ref) {
  final scheduler = ref.watch(schedulerServiceProvider);
  return RemindersRepository(db, scheduler);
});

final activeSchedulesStreamProvider =
    StreamProvider<List<ScheduleWithMedicine>>((ref) {
  final repo = ref.watch(remindersRepositoryProvider);
  return repo.watchActiveSchedules();
});

final todayDoseLogsStreamProvider = StreamProvider<List<DoseLog>>((ref) {
  final repo = ref.watch(remindersRepositoryProvider);
  return repo.watchTodayDoseLogs();
});

final recentDoseLogsStreamProvider =
    StreamProvider<List<DoseLogWithSchedule>>((ref) {
  final repo = ref.watch(remindersRepositoryProvider);
  return repo.watchRecentDoseLogs(days: 7);
});
