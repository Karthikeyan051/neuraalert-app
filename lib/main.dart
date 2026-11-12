// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'core/supabase_config.dart';
import 'data/db/app_database.dart';
import 'app/app_router.dart';
import 'app/app_theme.dart';
import 'features/settings/app_settings_provider.dart';
import 'services/alarm_service.dart';
import 'services/scheduler_service.dart';

late AppDatabase db;
late GoRouter appRouter;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  tz.initializeTimeZones();

  try {
    await Supabase.initialize(
      url: SupabaseConfig.url,
      publishableKey: SupabaseConfig.publishableKey,
    );
  } catch (_) {}

  db = AppDatabase();
  await AlarmService.init();

  // Load persisted settings & check onboarding state
  final initialSettings = await AppSettingsNotifier.loadFromDb();
  final existingSchedules = await (db.select(db.schedules)
        ..where((t) => t.deletedAt.isNull())
        ..limit(1))
      .get();

  final startLocation =
      (initialSettings.onboardingDone || existingSchedules.isNotEmpty)
          ? '/today'
          : '/language';

  appRouter = createAppRouter(initialLocation: startLocation);

  _setupAlarmListener();

  SchedulerService().topUp().catchError((_) {});

  runApp(
    ProviderScope(
      overrides: [
        initialAppSettingsProvider.overrideWithValue(initialSettings),
      ],
      child: const NeuraAlertApp(),
    ),
  );
}

void _setupAlarmListener() {
  AlarmService.onRing.listen((alarmSettings) async {
    final scheduledAlarm = await (db.select(db.scheduledAlarms)
          ..where((t) => t.alarmId.equals(alarmSettings.id)))
        .getSingleOrNull();

    String medicineName = alarmSettings.notificationSettings.body;
    String alertType = 'medicine';
    String doseNote = '';
    String foodRelation = 'none';
    String spokenPhrase = alarmSettings.notificationSettings.body;
    String voiceLang = 'ta';
    final String voiceFilePath = alarmSettings.assetAudioPath ?? '';
    final bool isTestAlert = alarmSettings.id == 999999;

    if (scheduledAlarm != null) {
      final schedule = await (db.select(db.schedules)
            ..where((t) => t.id.equals(scheduledAlarm.scheduleId)))
          .getSingleOrNull();
      if (schedule != null) {
        medicineName = schedule.label;
        alertType = schedule.alertType;
        voiceLang = schedule.voiceLang;

        if (schedule.medicineId != null) {
          final med = await (db.select(db.medicines)
                ..where((t) => t.id.equals(schedule.medicineId!)))
              .getSingleOrNull();
          if (med != null) {
            doseNote = med.doseNote;
            foodRelation = med.foodRelation;
          }
        }

        spokenPhrase = SchedulerService.buildSpokenPhrase(
          alertType: schedule.alertType,
          label: schedule.label,
          voiceLang: schedule.voiceLang,
          doseNote: doseNote,
          foodRelation: foodRelation,
        );
      }
    } else if (isTestAlert) {
      final settings = await AppSettingsNotifier.loadFromDb();
      voiceLang = settings.language;
      medicineName = settings.isTamil
          ? 'சோதனை நினைவூட்டல்'
          : 'Test Medicine Alert';
      doseNote = settings.isTamil ? '1 மாத்திரை (சோதனை)' : '1 tablet (Test)';
      foodRelation = 'after';
      spokenPhrase = SchedulerService.buildSpokenPhrase(
        alertType: 'medicine',
        label: medicineName,
        voiceLang: voiceLang,
        doseNote: doseNote,
        foodRelation: foodRelation,
      );
    }

    appRouter.push('/alert-screen', extra: {
      'alarmId': alarmSettings.id,
      'medicineName': medicineName,
      'alertType': alertType,
      'doseNote': doseNote,
      'foodRelation': foodRelation,
      'spokenPhrase': spokenPhrase,
      'voiceLang': voiceLang,
      'voiceFilePath': voiceFilePath,
      'isTestAlert': isTestAlert,
    });
  });
}

class NeuraAlertApp extends ConsumerWidget {
  const NeuraAlertApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(appSettingsProvider);

    return MaterialApp.router(
      title: 'NeuraAlert',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: settings.themeMode,
      routerConfig: appRouter,
      builder: (context, child) {
        final mq = MediaQuery.of(context);
        final systemScale = mq.textScaler.scale(1.0);
        final combinedScale = (systemScale * settings.fontScale).clamp(0.9, 2.2);
        return MediaQuery(
          data: mq.copyWith(textScaler: TextScaler.linear(combinedScale)),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}
