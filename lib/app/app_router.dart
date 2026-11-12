// lib/app/app_router.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/onboarding/language_pick_screen.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../features/auth/auth_screen.dart';
import '../features/today/today_screen.dart';
import '../features/alerts/alerts_screen.dart';
import '../features/alerts/add_alert_screen.dart';
import '../features/alerts/reminders_repository.dart';
import '../features/alert_screen/alert_screen.dart';
import '../features/history/history_screen.dart';
import '../features/settings/settings_screen.dart';
import 'shell_scaffold.dart';

final navigatorKey = GlobalKey<NavigatorState>();

GoRouter createAppRouter({required String initialLocation}) {
  return GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: initialLocation,
    routes: [
      GoRoute(
        path: '/language',
        builder: (ctx, state) {
          final fromSettings = state.uri.queryParameters['from'] == 'settings';
          return LanguagePickScreen(fromSettings: fromSettings);
        },
      ),
      GoRoute(
        path: '/onboarding',
        builder: (ctx, state) {
          final fromSettings = state.uri.queryParameters['from'] == 'settings';
          return OnboardingScreen(fromSettings: fromSettings);
        },
      ),
      GoRoute(
        path: '/auth',
        builder: (ctx, state) => const AuthScreen(),
      ),
      GoRoute(
        path: '/alert-screen',
        builder: (ctx, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          return AlertScreen(
            alarmId: extra['alarmId'] as int? ?? 0,
            medicineName: extra['medicineName'] as String? ?? 'Alert',
            alertType: extra['alertType'] as String? ?? 'medicine',
            doseNote: extra['doseNote'] as String? ?? '',
            foodRelation: extra['foodRelation'] as String? ?? 'none',
            spokenPhrase: extra['spokenPhrase'] as String? ?? '',
            voiceLang: extra['voiceLang'] as String? ?? 'ta',
            voiceFilePath: extra['voiceFilePath'] as String? ?? '',
            isTestAlert: extra['isTestAlert'] as bool? ?? false,
          );
        },
      ),
      ShellRoute(
        builder: (ctx, state, child) => ShellScaffold(child: child),
        routes: [
          GoRoute(
              path: '/today', builder: (ctx, state) => const TodayScreen()),
          GoRoute(
              path: '/alerts', builder: (ctx, state) => const AlertsScreen()),
          GoRoute(
              path: '/history',
              builder: (ctx, state) => const HistoryScreen()),
          GoRoute(
              path: '/settings',
              builder: (ctx, state) => const SettingsScreen()),
        ],
      ),
      GoRoute(
        path: '/add-alert',
        builder: (ctx, state) => AddAlertScreen(
          existing: state.extra as ScheduleWithMedicine?,
        ),
      ),
    ],
  );
}
