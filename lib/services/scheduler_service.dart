import 'dart:io';
import 'package:drift/drift.dart';
import 'package:neuraalert/data/db/app_database.dart';
import 'package:neuraalert/main.dart';
import 'package:neuraalert/services/alarm_service.dart';
import 'package:neuraalert/services/voice_service.dart';

class SchedulerService {
  final VoiceService _voiceService = VoiceService();

  /// Pure function: computes next occurrences for a schedule within [days] days from [from].
  static List<DateTime> nextOccurrences(Schedule schedule, DateTime from, {int days = 14}) {
    if (!schedule.enabled || schedule.deletedAt != null) {
      return [];
    }

    final occurrences = <DateTime>[];
    final hour = schedule.timeMinutes ~/ 60;
    final minute = schedule.timeMinutes % 60;

    final startDate = schedule.startDate;
    final endDate = schedule.endDate;

    for (int i = 0; i < days; i++) {
      final dayCandidate = DateTime(from.year, from.month, from.day + i, hour, minute);

      // Check if candidate is strictly after "from"
      if (dayCandidate.isBefore(from)) {
        continue;
      }

      // Check start date (day-level comparison)
      final startDay = DateTime(startDate.year, startDate.month, startDate.day);
      if (dayCandidate.isBefore(startDay)) {
        continue;
      }

      // Check end date if set
      if (endDate != null) {
        final endDay = DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59);
        if (dayCandidate.isAfter(endDay)) {
          continue;
        }
      }

      // Check daysMask: bit0=Mon(1), bit1=Tue(2), bit2=Wed(4), bit3=Thu(8), bit4=Fri(16), bit5=Sat(32), bit6=Sun(64)
      final weekday = dayCandidate.weekday; // 1 = Monday ... 7 = Sunday
      final dayBit = 1 << (weekday - 1);
      if ((schedule.daysMask & dayBit) != 0) {
        occurrences.add(dayCandidate);
      }
    }

    return occurrences;
  }

  /// Generates a deterministic positive 31-bit integer for AlarmManager
  static int stable31BitAlarmId(String scheduleId, DateTime fireAt) {
    final yyyymmddhhmm = '${fireAt.year}'
        '${fireAt.month.toString().padLeft(2, '0')}'
        '${fireAt.day.toString().padLeft(2, '0')}'
        '${fireAt.hour.toString().padLeft(2, '0')}'
        '${fireAt.minute.toString().padLeft(2, '0')}';
    final key = '$scheduleId-$yyyymmddhhmm';
    return key.hashCode.abs() & 0x7FFFFFFF;
  }

  /// Builds the spoken sentence for TTS based on language and alert type
  static String buildSpokenPhrase({
    required String alertType,
    required String label,
    required String voiceLang,
    String doseNote = '',
    String foodRelation = 'none',
  }) {
    final isTamil = voiceLang == 'ta';

    if (alertType == 'medicine') {
      if (isTamil) {
        String foodText = '';
        if (foodRelation == 'before') {
          foodText = ' உணவுக்கு முன் எடுத்துக்கொள்ளுங்கள்.';
        } else if (foodRelation == 'after') {
          foodText = ' உணவுக்குப் பின் எடுத்துக்கொள்ளுங்கள்.';
        } else if (foodRelation == 'with') {
          foodText = ' உணவுடன் எடுத்துக்கொள்ளுங்கள்.';
        }
        final noteText = doseNote.trim().isNotEmpty ? ' $doseNote.' : '';
        return '$label எடுத்துக்கொள்ளும் நேரம் இது.$noteText$foodText';
      } else {
        String foodText = '';
        if (foodRelation == 'before') {
          foodText = ' Take it before food.';
        } else if (foodRelation == 'after') {
          foodText = ' Take it after food.';
        } else if (foodRelation == 'with') {
          foodText = ' Take it with food.';
        }
        final noteText = doseNote.trim().isNotEmpty ? ' $doseNote.' : '';
        return 'It is time to take $label.$noteText$foodText';
      }
    } else if (alertType == 'meeting') {
      return isTamil
          ? 'சந்திப்பு நேரம்: $label. $doseNote'.trim()
          : 'Meeting time: $label. $doseNote'.trim();
    } else if (alertType == 'alarm') {
      return isTamil
          ? 'எழுந்திருக்க வேண்டிய நேரம்: $label'
          : 'Wake up time: $label';
    } else {
      return isTamil
          ? 'நினைவூட்டல்: $label'
          : 'Reminder: $label';
    }
  }

  /// Generates the audio file for a schedule if not already present
  Future<String> ensureVoiceFileForSchedule({
    required String scheduleId,
    required String alertType,
    required String label,
    required String voiceLang,
    String doseNote = '',
    String foodRelation = 'none',
  }) async {
    final phrase = buildSpokenPhrase(
      alertType: alertType,
      label: label,
      voiceLang: voiceLang,
      doseNote: doseNote,
      foodRelation: foodRelation,
    );

    return await _voiceService.synthesizeSpokenFile(
      text: phrase,
      filename: 'voice_${scheduleId}_$voiceLang.wav',
    );
  }

  /// Top-up all active alarms for the next [days] days. Idempotent.
  Future<void> topUp({int days = 14}) async {
    final now = DateTime.now();
    final activeSchedules = await (db.select(db.schedules)
          ..where((t) => t.enabled.equals(true) & t.deletedAt.isNull()))
        .get();

    for (final schedule in activeSchedules) {
      Medicine? medicine;
      if (schedule.medicineId != null) {
        medicine = await (db.select(db.medicines)
              ..where((t) => t.id.equals(schedule.medicineId!)))
            .getSingleOrNull();
      }

      final occurrences = nextOccurrences(schedule, now, days: days);

      // Ensure voice file is synthesized
      String voicePath = schedule.voiceFilePath;
      if (voicePath.isEmpty || !File(voicePath).existsSync()) {
        try {
          voicePath = await ensureVoiceFileForSchedule(
            scheduleId: schedule.id,
            alertType: schedule.alertType,
            label: schedule.label,
            voiceLang: schedule.voiceLang,
            doseNote: medicine?.doseNote ?? '',
            foodRelation: medicine?.foodRelation ?? 'none',
          );
          // Update DB with generated voice path
          await (db.update(db.schedules)..where((t) => t.id.equals(schedule.id)))
              .write(SchedulesCompanion(voiceFilePath: Value(voicePath)));
        } catch (_) {
          voicePath = '';
        }
      }

      for (final fireAt in occurrences) {
        final alarmId = stable31BitAlarmId(schedule.id, fireAt);

        // Check if already in scheduled_alarms
        final existing = await (db.select(db.scheduledAlarms)
              ..where((t) => t.alarmId.equals(alarmId)))
            .getSingleOrNull();

        if (existing == null) {
          final success = await AlarmService.scheduleAlarm(
            id: alarmId,
            fireAt: fireAt,
            voiceAudioPath: voicePath.isNotEmpty ? voicePath : null,
            title: schedule.alertType == 'medicine' ? 'மருந்து நேரம் / Medicine' : schedule.label,
            body: schedule.label,
          );

          if (success) {
            await db.into(db.scheduledAlarms).insertOnConflictUpdate(
                  ScheduledAlarmsCompanion(
                    alarmId: Value(alarmId),
                    scheduleId: Value(schedule.id),
                    fireAt: Value(fireAt),
                    voiceFilePath: Value(voicePath),
                  ),
                );
          }
        }
      }
    }

    // Clean up expired alarms from database table
    final threshold = now.subtract(const Duration(hours: 1));
    await (db.delete(db.scheduledAlarms)..where((t) => t.fireAt.isSmallerThanValue(threshold))).go();
  }

  /// Cancels all scheduled alarms for a specific schedule
  Future<void> cancelScheduleAlarms(String scheduleId) async {
    final alarms = await (db.select(db.scheduledAlarms)
          ..where((t) => t.scheduleId.equals(scheduleId)))
        .get();

    for (final alarm in alarms) {
      await AlarmService.stop(alarm.alarmId);
    }

    await (db.delete(db.scheduledAlarms)
          ..where((t) => t.scheduleId.equals(scheduleId)))
        .go();
  }
}

