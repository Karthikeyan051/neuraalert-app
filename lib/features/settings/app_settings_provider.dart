import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neuraalert/core/app_constants.dart';
import 'package:neuraalert/main.dart';

class AppSettingsState {
  final String language; // 'ta' or 'en'
  final double fontScale; // 1.0, 1.2, 1.4
  final ThemeMode themeMode;
  final int snoozeMinutes;
  final int ringSeconds;
  final bool voiceEnabled;
  final bool digestEnabled;
  final String digestTime; // 'HH:mm'
  final bool onboardingDone;
  final bool testAlertPassed;

  const AppSettingsState({
    this.language = AppConstants.langTa,
    this.fontScale = 1.0,
    this.themeMode = ThemeMode.system,
    this.snoozeMinutes = AppConstants.defaultSnoozeMinutes,
    this.ringSeconds = AppConstants.defaultRingSeconds,
    this.voiceEnabled = true,
    this.digestEnabled = true,
    this.digestTime = AppConstants.digestDefault,
    this.onboardingDone = false,
    this.testAlertPassed = false,
  });

  bool get isTamil => language == AppConstants.langTa;

  String tr(String ta, String en) => isTamil ? ta : en;

  AppSettingsState copyWith({
    String? language,
    double? fontScale,
    ThemeMode? themeMode,
    int? snoozeMinutes,
    int? ringSeconds,
    bool? voiceEnabled,
    bool? digestEnabled,
    String? digestTime,
    bool? onboardingDone,
    bool? testAlertPassed,
  }) {
    return AppSettingsState(
      language: language ?? this.language,
      fontScale: fontScale ?? this.fontScale,
      themeMode: themeMode ?? this.themeMode,
      snoozeMinutes: snoozeMinutes ?? this.snoozeMinutes,
      ringSeconds: ringSeconds ?? this.ringSeconds,
      voiceEnabled: voiceEnabled ?? this.voiceEnabled,
      digestEnabled: digestEnabled ?? this.digestEnabled,
      digestTime: digestTime ?? this.digestTime,
      onboardingDone: onboardingDone ?? this.onboardingDone,
      testAlertPassed: testAlertPassed ?? this.testAlertPassed,
    );
  }
}

class AppSettingsNotifier extends StateNotifier<AppSettingsState> {
  AppSettingsNotifier(super.initial);

  static const String snoozeKey = 'snoozeMinutes';
  static const String ringKey = 'ringSeconds';
  static const String digestEnabledKey = 'digestEnabled';
  static const String testAlertPassedKey = 'testAlertPassed';

  static Future<AppSettingsState> loadFromDb() async {
    final rows = await db.select(db.appSettings).get();
    final map = {for (final r in rows) r.key: r.value};

    final lang = map[AppConstants.langKey] ?? AppConstants.langTa;
    final fontScale =
        double.tryParse(map[AppConstants.fontScaleKey] ?? '') ?? 1.0;
    final themeStr = map[AppConstants.themeModeKey] ?? 'system';
    final themeMode = switch (themeStr) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
    final snooze = int.tryParse(map[snoozeKey] ?? '') ??
        AppConstants.defaultSnoozeMinutes;
    final ring = int.tryParse(map[ringKey] ?? '') ??
        AppConstants.defaultRingSeconds;
    final voiceEnabled = (map[AppConstants.voiceEnabledKey] ?? 'true') == 'true';
    final digestEnabled = (map[digestEnabledKey] ?? 'true') == 'true';
    final digestTime =
        map[AppConstants.digestTimeKey] ?? AppConstants.digestDefault;
    final onboardingDone =
        (map[AppConstants.onboardingDoneKey] ?? 'false') == 'true';
    final testAlertPassed = (map[testAlertPassedKey] ?? 'false') == 'true';

    return AppSettingsState(
      language: lang,
      fontScale: fontScale.clamp(0.9, 1.6),
      themeMode: themeMode,
      snoozeMinutes: snooze,
      ringSeconds: ring,
      voiceEnabled: voiceEnabled,
      digestEnabled: digestEnabled,
      digestTime: digestTime,
      onboardingDone: onboardingDone,
      testAlertPassed: testAlertPassed,
    );
  }

  Future<void> setLanguage(String lang) async {
    state = state.copyWith(language: lang);
    await db.setSetting(AppConstants.langKey, lang);
  }

  Future<void> setFontScale(double scale) async {
    state = state.copyWith(fontScale: scale);
    await db.setSetting(AppConstants.fontScaleKey, scale.toString());
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = state.copyWith(themeMode: mode);
    final str = switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      ThemeMode.system => 'system',
    };
    await db.setSetting(AppConstants.themeModeKey, str);
  }

  Future<void> setSnoozeMinutes(int minutes) async {
    state = state.copyWith(snoozeMinutes: minutes);
    await db.setSetting(snoozeKey, minutes.toString());
  }

  Future<void> setRingSeconds(int seconds) async {
    state = state.copyWith(ringSeconds: seconds);
    await db.setSetting(ringKey, seconds.toString());
  }

  Future<void> setVoiceEnabled(bool enabled) async {
    state = state.copyWith(voiceEnabled: enabled);
    await db.setSetting(AppConstants.voiceEnabledKey, enabled.toString());
  }

  Future<void> setDigestEnabled(bool enabled) async {
    state = state.copyWith(digestEnabled: enabled);
    await db.setSetting(digestEnabledKey, enabled.toString());
  }

  Future<void> setDigestTime(String time) async {
    state = state.copyWith(digestTime: time);
    await db.setSetting(AppConstants.digestTimeKey, time);
  }

  Future<void> markOnboardingDone() async {
    state = state.copyWith(onboardingDone: true);
    await db.setSetting(AppConstants.onboardingDoneKey, 'true');
  }

  Future<void> markTestAlertPassed() async {
    state = state.copyWith(testAlertPassed: true);
    await db.setSetting(testAlertPassedKey, 'true');
  }
}

final initialAppSettingsProvider =
    Provider<AppSettingsState>((ref) => const AppSettingsState());

final appSettingsProvider =
    StateNotifierProvider<AppSettingsNotifier, AppSettingsState>((ref) {
  final initial = ref.watch(initialAppSettingsProvider);
  return AppSettingsNotifier(initial);
});

