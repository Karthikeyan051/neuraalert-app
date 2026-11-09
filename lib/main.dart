// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'core/supabase_config.dart';
import 'data/db/app_database.dart';
import 'app/app_router.dart';
import 'app/app_theme.dart';
import 'services/alarm_service.dart';
import 'services/scheduler_service.dart';

late AppDatabase db;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Timezones
  tz.initializeTimeZones();

  // Supabase
  try {
    await Supabase.initialize(
      url: SupabaseConfig.url,
      publishableKey: SupabaseConfig.publishableKey,
    );
  } catch (_) {}

  // Local DB
  db = AppDatabase();

  // Alarm package
  await AlarmService.init();

  // Listen for alarm rings to launch full-screen alert
  _setupAlarmListener();

  // Top up next 14 days of alarms in background
  SchedulerService().topUp().catchError((_) {});

  runApp(const ProviderScope(child: NeuraAlertApp()));
}

void _setupAlarmListener() {
  AlarmService.onRing.listen((alarmSettings) async {
    final scheduledAlarm = await (db.select(db.scheduledAlarms)
          ..where((t) => t.alarmId.equals(alarmSettings.id)))
        .getSingleOrNull();

    String medicineName = alarmSettings.notificationSettings.body;
    String scheduleLabel = alarmSettings.notificationSettings.title;
    String voiceLang = 'ta';
    String voiceFilePath = alarmSettings.assetAudioPath ?? '';

    if (scheduledAlarm != null) {
      final schedule = await (db.select(db.schedules)
            ..where((t) => t.id.equals(scheduledAlarm.scheduleId)))
          .getSingleOrNull();
      if (schedule != null) {
        medicineName = schedule.label;
        scheduleLabel = schedule.alertType == 'medicine'
            ? 'மருந்து நேரம்: ${schedule.label}'
            : schedule.label;
        voiceLang = schedule.voiceLang;
      }
    }

    appRouter.push('/alert-screen', extra: {
      'alarmId': alarmSettings.id,
      'medicineName': medicineName,
      'scheduleLabel': scheduleLabel,
      'voiceLang': voiceLang,
      'voiceFilePath': voiceFilePath,
    });
  });
}

class NeuraAlertApp extends StatelessWidget {
  const NeuraAlertApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'NeuraAlert',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.system,
      routerConfig: appRouter,
    );
  }
}
