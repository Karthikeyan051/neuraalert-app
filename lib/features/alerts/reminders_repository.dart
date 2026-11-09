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

class RemindersRepository {
  final AppDatabase _db;
  final SchedulerService _scheduler;
  final _uuid = const Uuid();

  RemindersRepository(this._db, this._scheduler);

  Stream<List<ScheduleWithMedicine>> watchActiveSchedules() {
    final query = _db.select(_db.schedules).join([
      leftOuterJoin(_db.medicines, _db.medicines.id.equalsExp(_db.schedules.medicineId)),
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

    // Synthesize voice file
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

    // Schedule alarms
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

    // Update medicine if applicable
    if (existingSchedule.medicineId != null) {
      await (_db.update(_db.medicines)..where((t) => t.id.equals(existingSchedule.medicineId!)))
          .write(
        MedicinesCompanion(
          name: Value(label),
          doseNote: Value(doseNote),
          foodRelation: Value(foodRelation),
          updatedAt: Value(DateTime.now()),
        ),
      );
    }

    // Cancel old alarms before updating
    await _scheduler.cancelScheduleAlarms(scheduleId);

    // Regenerate voice file
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

    await (_db.update(_db.schedules)..where((t) => t.id.equals(scheduleId))).write(
      SchedulesCompanion(
        alertType: Value(alertType),
        label: Value(label),
        timeMinutes: Value(timeMinutes),
        daysMask: Value(daysMask),
        startDate: startDate != null ? Value(startDate) : const Value.absent(),
        endDate: Value(endDate),
        voiceLang: Value(voiceLang),
        voiceFilePath: Value(voicePath),
        updatedAt: Value(DateTime.now()),
      ),
    );

    await _scheduler.topUp();
  }

  Future<void> toggleScheduleEnabled(String scheduleId, bool enabled) async {
    await (_db.update(_db.schedules)..where((t) => t.id.equals(scheduleId))).write(
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

    // Soft delete
    await (_db.update(_db.schedules)..where((t) => t.id.equals(scheduleId))).write(
      SchedulesCompanion(
        deletedAt: Value(DateTime.now()),
        enabled: const Value(false),
      ),
    );
  }
}

// ── Providers ───────────────────────────────────────────────────────────────

final schedulerServiceProvider = Provider<SchedulerService>((ref) {
  return SchedulerService();
});

final remindersRepositoryProvider = Provider<RemindersRepository>((ref) {
  final scheduler = ref.watch(schedulerServiceProvider);
  return RemindersRepository(db, scheduler);
});

final activeSchedulesStreamProvider = StreamProvider<List<ScheduleWithMedicine>>((ref) {
  final repo = ref.watch(remindersRepositoryProvider);
  return repo.watchActiveSchedules();
});

