import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:neuraalert/app/app_theme.dart';
import 'package:neuraalert/data/db/app_database.dart';
import 'package:neuraalert/features/alerts/add_alert_screen.dart';
import 'package:neuraalert/features/alerts/alerts_screen.dart';
import 'package:neuraalert/features/alerts/reminders_repository.dart';
import 'package:neuraalert/features/history/history_screen.dart';
import 'package:neuraalert/features/onboarding/language_pick_screen.dart';
import 'package:neuraalert/features/settings/app_settings_provider.dart';
import 'package:neuraalert/features/settings/settings_screen.dart';
import 'package:neuraalert/features/today/today_screen.dart';

void main() {
  final now = DateTime.now();

  final sampleSchedules = [
    ScheduleWithMedicine(
      schedule: Schedule(
        id: 's1',
        medicineId: 'm1',
        alertType: 'medicine',
        label: 'Paracetamol 500mg',
        timeMinutes: 8 * 60,
        daysMask: 127,
        startDate: now.subtract(const Duration(days: 1)),
        enabled: true,
        voiceLang: 'ta',
        voiceFilePath: '',
        updatedAt: now,
      ),
      medicine: Medicine(
        id: 'm1',
        name: 'Paracetamol 500mg',
        doseNote: '1 tablet',
        foodRelation: 'after',
        stockCount: -1,
        unitsPerDose: 1.0,
        refillThresholdDays: 7,
        createdAt: now,
        updatedAt: now,
      ),
    ),
    ScheduleWithMedicine(
      schedule: Schedule(
        id: 's2',
        medicineId: null,
        alertType: 'meeting',
        label: 'Doctor Checkup',
        timeMinutes: 14 * 60 + 30,
        daysMask: 127,
        startDate: now.subtract(const Duration(days: 1)),
        enabled: true,
        voiceLang: 'en',
        voiceFilePath: '',
        updatedAt: now,
      ),
    ),
    ScheduleWithMedicine(
      schedule: Schedule(
        id: 's3',
        medicineId: 'm3',
        alertType: 'medicine',
        label: 'Metformin',
        timeMinutes: 20 * 60,
        daysMask: 127,
        startDate: now.subtract(const Duration(days: 1)),
        enabled: true,
        voiceLang: 'ta',
        voiceFilePath: '',
        updatedAt: now,
      ),
    ),
  ];

  final sampleLogs = [
    DoseLog(
      id: 'l1',
      scheduleId: 's1',
      scheduledAt: DateTime(now.year, now.month, now.day, 8, 0),
      status: 'taken',
      actedAt: now,
      updatedAt: now,
    ),
  ];

  Widget wrapScreen({
    required Widget child,
    required String lang,
    double textScale = 1.0,
    bool darkMode = false,
  }) {
    final settings = AppSettingsState(
      language: lang,
      fontScale: 1.0,
      themeMode: darkMode ? ThemeMode.dark : ThemeMode.light,
      onboardingDone: true,
      testAlertPassed: true,
    );

    return ProviderScope(
      overrides: [
        initialAppSettingsProvider.overrideWithValue(settings),
        activeSchedulesStreamProvider
            .overrideWith((ref) => Stream.value(sampleSchedules)),
        todayDoseLogsStreamProvider
            .overrideWith((ref) => Stream.value(sampleLogs)),
        recentDoseLogsStreamProvider.overrideWith(
          (ref) => Stream.value([
            DoseLogWithSchedule(
              log: sampleLogs.first,
              schedule: sampleSchedules.first.schedule,
            ),
          ]),
        ),
      ],
      child: MaterialApp(
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        themeMode: darkMode ? ThemeMode.dark : ThemeMode.light,
        home: MediaQuery(
          data: MediaQueryData(
            size: const Size(390, 844),
            textScaler: TextScaler.linear(textScale),
          ),
          child: child,
        ),
      ),
    );
  }

  group('UI Redesign Smoke & 200% Font-Scale Layout Tests', () {
    for (final lang in ['ta', 'en']) {
      for (final scale in [1.0, 2.0]) {
        testWidgets('TodayScreen renders cleanly ($lang, ${scale}x)',
            (tester) async {
          await tester.pumpWidget(wrapScreen(
            child: const TodayScreen(),
            lang: lang,
            textScale: scale,
          ));
          await tester.pump();
          expect(find.text('Paracetamol 500mg'), findsOneWidget);
          expect(tester.takeException(), isNull);
        });

        testWidgets('AlertsScreen renders grouped lists cleanly ($lang, ${scale}x)',
            (tester) async {
          await tester.pumpWidget(wrapScreen(
            child: const AlertsScreen(),
            lang: lang,
            textScale: scale,
          ));
          await tester.pump();
          expect(find.text('Paracetamol 500mg'), findsOneWidget);
          expect(tester.takeException(), isNull);
        });

        testWidgets('AddAlertScreen steps render cleanly ($lang, ${scale}x)',
            (tester) async {
          await tester.pumpWidget(wrapScreen(
            child: const AddAlertScreen(),
            lang: lang,
            textScale: scale,
          ));
          await tester.pump();
          await tester.enterText(find.byType(TextField).first, 'Aspirin 75mg');
          await tester.pump();
          expect(find.text('Aspirin 75mg'), findsOneWidget);
          expect(tester.takeException(), isNull);
        });

        testWidgets('SettingsScreen & HistoryScreen render cleanly ($lang, ${scale}x)',
            (tester) async {
          await tester.pumpWidget(wrapScreen(
            child: const SettingsScreen(),
            lang: lang,
            textScale: scale,
            darkMode: scale == 2.0,
          ));
          await tester.pump();
          expect(tester.takeException(), isNull);

          await tester.pumpWidget(wrapScreen(
            child: const HistoryScreen(),
            lang: lang,
            textScale: scale,
          ));
          await tester.pump();
          expect(tester.takeException(), isNull);
        });
      }
    }

    testWidgets('LanguagePickScreen renders cleanly at 2.0x scale',
        (tester) async {
      await tester.pumpWidget(wrapScreen(
        child: const LanguagePickScreen(),
        lang: 'ta',
        textScale: 2.0,
      ));
      await tester.pump();
      expect(find.text('NeuraAlert'), findsOneWidget);
      expect(find.text('தமிழ்'), findsOneWidget);
      expect(find.text('English'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}

