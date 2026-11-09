// lib/app/app_router.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/onboarding/language_pick_screen.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../features/auth/auth_screen.dart';
import '../features/today/today_screen.dart';
import '../features/alerts/alerts_screen.dart';
import '../features/alerts/add_alert_screen.dart';
import '../features/alert_screen/alert_screen.dart';
import '../features/history/history_screen.dart';
import '../features/settings/settings_screen.dart';
import 'shell_scaffold.dart';

final navigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: navigatorKey,
  initialLocation: '/today',
  routes: [
    GoRoute(
      path: '/language',
      builder: (ctx, state) => const LanguagePickScreen(),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (ctx, state) => const OnboardingScreen(),
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
          scheduleLabel: extra['scheduleLabel'] as String? ?? '',
          voiceLang: extra['voiceLang'] as String? ?? 'ta',
          voiceFilePath: extra['voiceFilePath'] as String? ?? '',
        );
      },
    ),
    ShellRoute(
      builder: (ctx, state, child) => ShellScaffold(child: child),
      routes: [
        GoRoute(path: '/today', builder: (ctx, state) => const TodayScreen()),
        GoRoute(path: '/alerts', builder: (ctx, state) => const AlertsScreen()),
        GoRoute(path: '/add-alert', builder: (ctx, state) => const AddAlertScreen()),
        GoRoute(path: '/history', builder: (ctx, state) => const HistoryScreen()),
        GoRoute(path: '/settings', builder: (ctx, state) => const SettingsScreen()),
      ],
    ),
  ],
);
