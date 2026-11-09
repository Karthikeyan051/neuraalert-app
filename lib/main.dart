// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:alarm/alarm.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'core/supabase_config.dart';
import 'data/db/app_database.dart';
import 'app/app_router.dart';
import 'app/app_theme.dart';

late AppDatabase db;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Timezones
  tz.initializeTimeZones();

  // Supabase
  await Supabase.initialize(
    url: SupabaseConfig.url,
    publishableKey: SupabaseConfig.publishableKey,
  );

  // Local DB
  db = AppDatabase.instance;

  // Alarm package
  await Alarm.init();

  runApp(const ProviderScope(child: NeuraAlertApp()));
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
