import 'package:flutter_test/flutter_test.dart';
import 'package:neuraalert/data/db/app_database.dart';
import 'package:neuraalert/services/scheduler_service.dart';

void main() {
  group('SchedulerService.nextOccurrences', () {
    test('Daily schedule generates occurrences for next 14 days', () {
      final now = DateTime(2026, 11, 9, 7, 0); // 7:00 AM
      final schedule = Schedule(
        id: 'test-1',
        alertType: 'medicine',
        label: 'Paracetamol',
        timeMinutes: 8 * 60, // 8:00 AM
        daysMask: 127, // Every day
        startDate: DateTime(2026, 11, 1),
        enabled: true,
        voiceLang: 'ta',
        voiceFilePath: '',
        updatedAt: now,
      );

      final occurrences = SchedulerService.nextOccurrences(schedule, now, days: 14);

      expect(occurrences.length, 14);
      expect(occurrences.first, DateTime(2026, 11, 9, 8, 0));
      expect(occurrences.last, DateTime(2026, 11, 22, 8, 0));
    });

    test('Skips occurrences if fire time has already passed today', () {
      final now = DateTime(2026, 11, 9, 9, 30); // 9:30 AM
      final schedule = Schedule(
        id: 'test-2',
        alertType: 'medicine',
        label: 'Vitamin C',
        timeMinutes: 8 * 60, // 8:00 AM
        daysMask: 127,
        startDate: DateTime(2026, 11, 1),
        enabled: true,
        voiceLang: 'ta',
        voiceFilePath: '',
        updatedAt: now,
      );

      final occurrences = SchedulerService.nextOccurrences(schedule, now, days: 14);

      // Today's 8:00 AM has passed, so 13 occurrences left in 14-day window
      expect(occurrences.length, 13);
      expect(occurrences.first, DateTime(2026, 11, 10, 8, 0));
    });

    test('Respects weekday-only bitmask (Mon-Fri = 31)', () {
      // 2026-11-09 is a Monday
      final now = DateTime(2026, 11, 9, 7, 0);
      final schedule = Schedule(
        id: 'test-3',
        alertType: 'meeting',
        label: 'Team Standup',
        timeMinutes: 10 * 60, // 10:00 AM
        daysMask: 31, // Mon(1) + Tue(2) + Wed(4) + Thu(8) + Fri(16)
        startDate: DateTime(2026, 11, 1),
        enabled: true,
        voiceLang: 'en',
        voiceFilePath: '',
        updatedAt: now,
      );

      final occurrences = SchedulerService.nextOccurrences(schedule, now, days: 14);

      // In 14 days starting Monday, there are exactly 10 weekdays
      expect(occurrences.length, 10);
      for (final occ in occurrences) {
        expect(occ.weekday >= 1 && occ.weekday <= 5, true);
      }
    });

    test('Disabled schedule returns empty list', () {
      final now = DateTime(2026, 11, 9, 7, 0);
      final schedule = Schedule(
        id: 'test-4',
        alertType: 'alarm',
        label: 'Workout',
        timeMinutes: 6 * 60,
        daysMask: 127,
        startDate: DateTime(2026, 11, 1),
        enabled: false,
        voiceLang: 'ta',
        voiceFilePath: '',
        updatedAt: now,
      );

      final occurrences = SchedulerService.nextOccurrences(schedule, now);
      expect(occurrences, isEmpty);
    });
  });

  group('SchedulerService.stable31BitAlarmId', () {
    test('Produces positive 31-bit integer within valid range', () {
      final fireAt = DateTime(2026, 11, 9, 8, 0);
      final id = SchedulerService.stable31BitAlarmId('uuid-1234', fireAt);

      expect(id, isNonNegative);
      expect(id, lessThanOrEqualTo(0x7FFFFFFF));
    });

    test('Is deterministic for same schedule and fire time', () {
      final fireAt = DateTime(2026, 11, 9, 8, 0);
      final id1 = SchedulerService.stable31BitAlarmId('uuid-1234', fireAt);
      final id2 = SchedulerService.stable31BitAlarmId('uuid-1234', fireAt);

      expect(id1, equals(id2));
    });
  });

  group('SchedulerService.buildSpokenPhrase', () {
    test('Constructs Tamil medicine phrase with food note', () {
      final phrase = SchedulerService.buildSpokenPhrase(
        alertType: 'medicine',
        label: 'Paracetamol',
        voiceLang: 'ta',
        doseNote: '1 மாத்திரை',
        foodRelation: 'after',
      );

      expect(phrase, contains('Paracetamol எடுத்துக்கொள்ளும் நேரம் இது'));
      expect(phrase, contains('1 மாத்திரை'));
      expect(phrase, contains('உணவுக்குப் பின் எடுத்துக்கொள்ளுங்கள்'));
    });

    test('Constructs English medicine phrase with food note', () {
      final phrase = SchedulerService.buildSpokenPhrase(
        alertType: 'medicine',
        label: 'Paracetamol',
        voiceLang: 'en',
        doseNote: '1 tablet',
        foodRelation: 'after',
      );

      expect(phrase, contains('It is time to take Paracetamol'));
      expect(phrase, contains('1 tablet'));
      expect(phrase, contains('Take it after food'));
    });
  });
}

