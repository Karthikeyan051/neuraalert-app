import 'dart:io';
import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:neuraalert/app/app_theme.dart';
import 'package:neuraalert/features/settings/app_settings_provider.dart';
import 'package:neuraalert/services/alarm_service.dart';
import 'package:neuraalert/services/scheduler_service.dart';
import 'package:neuraalert/services/voice_service.dart';
import 'package:permission_handler/permission_handler.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  final bool fromSettings;
  const OnboardingScreen({super.key, this.fromSettings = false});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen>
    with WidgetsBindingObserver {
  bool _notifGranted = false;
  bool _exactAlarmGranted = false;
  bool _batteryIgnored = false;
  bool _tamilVoiceReady = false;
  bool _checking = true;
  bool _schedulingTest = false;
  DateTime? _scheduledTestTime;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _refreshStatuses();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _refreshStatuses();
    }
  }

  Future<void> _refreshStatuses() async {
    try {
      final notif = await Permission.notification.status;
      final exact = await Permission.scheduleExactAlarm.status;
      final battery = await Permission.ignoreBatteryOptimizations.status;
      final tamilOk = await VoiceService().isTamilAvailable();
      if (!mounted) return;
      setState(() {
        _notifGranted = notif.isGranted;
        _exactAlarmGranted = exact.isGranted;
        _batteryIgnored = battery.isGranted;
        _tamilVoiceReady = tamilOk;
        _checking = false;
      });
    } catch (_) {
      if (mounted) setState(() => _checking = false);
    }
  }

  Future<void> _requestNotification() async {
    final res = await Permission.notification.request();
    if (res.isPermanentlyDenied) {
      await openAppSettings();
    }
    await _refreshStatuses();
  }

  Future<void> _requestExactAlarm() async {
    final res = await Permission.scheduleExactAlarm.request();
    if (!res.isGranted && Platform.isAndroid) {
      try {
        await const AndroidIntent(
          action: 'android.settings.REQUEST_SCHEDULE_EXACT_ALARM',
        ).launch();
      } catch (_) {
        await openAppSettings();
      }
    }
    await _refreshStatuses();
  }

  Future<void> _requestBatteryIgnore() async {
    final res = await Permission.ignoreBatteryOptimizations.request();
    if (!res.isGranted) {
      await openAppSettings();
    }
    await _refreshStatuses();
  }

  Future<void> _openTtsInstall() async {
    if (Platform.isAndroid) {
      try {
        await const AndroidIntent(
          action: 'android.speech.tts.engine.INSTALL_TTS_DATA',
        ).launch();
      } catch (_) {
        await openAppSettings();
      }
    }
  }

  Future<void> _scheduleTestAlert(bool isTa) async {
    setState(() => _schedulingTest = true);
    try {
      final fireAt = DateTime.now().add(const Duration(minutes: 1));
      final medName = isTa ? 'சோதனை நினைவூட்டல்' : 'Test Medicine Alert';
      final phrase = SchedulerService.buildSpokenPhrase(
        alertType: 'medicine',
        label: medName,
        voiceLang: isTa ? 'ta' : 'en',
        doseNote: isTa ? '1 மாத்திரை (சோதனை)' : '1 tablet (Test)',
        foodRelation: 'after',
      );
      String voicePath = '';
      try {
        voicePath = await VoiceService().synthesizeSpokenFile(
          text: phrase,
          filename: 'test_alert_${isTa ? 'ta' : 'en'}.wav',
          lang: isTa ? 'ta' : 'en',
        );
      } catch (_) {}

      await AlarmService.scheduleAlarm(
        id: 999999,
        fireAt: fireAt,
        voiceAudioPath: voicePath.isNotEmpty ? voicePath : null,
        title: isTa ? 'NeuraAlert சோதனை' : 'NeuraAlert Test',
        body: medName,
      );

      if (!mounted) return;
      setState(() => _scheduledTestTime = fireAt);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isTa
                ? '1 நிமிடத்தில் அலாரம் அமைக்கப்பட்டது. திரையைப் பூட்டி (Lock) சோதிக்கவும்.'
                : 'Test alarm set for 1 minute from now. Lock your phone to test.',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) setState(() => _schedulingTest = false);
    }
  }

  Future<void> _finish() async {
    await ref.read(appSettingsProvider.notifier).markOnboardingDone();
    if (!mounted) return;
    if (widget.fromSettings && context.canPop()) {
      context.pop();
    } else {
      context.go('/today');
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(appSettingsProvider);
    final isTa = settings.isTamil;

    return Scaffold(
      backgroundColor: AppTheme.bg(context),
      appBar: AppBar(
        titleSpacing: 24,
        title: Text(isTa ? 'அலாரம் அமைப்பு' : 'Keep Alerts Reliable'),
      ),
      body: SafeArea(
        child: _checking
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 48),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      isTa
                          ? 'தொலைபேசி பூட்டியிருந்தாலும் மருந்து நேரம் தவறாமல் ஒலிக்க கீழே உள்ள அனுமதிகளை வழங்கவும்.'
                          : 'Allow these permissions so medicine alerts ring on time even when your phone is locked or idle.',
                      style: TextStyle(
                        fontSize: 17,
                        height: 1.5,
                        color: AppTheme.textSub(context),
                      ),
                    ),
                    const SizedBox(height: 24),

                    _PermissionRow(
                      icon: Icons.notifications_active_outlined,
                      title: isTa ? 'அறிவிப்புகள்' : 'Notifications',
                      subtitle: isTa
                          ? 'அலாரம் திரையில் தோன்ற அறிவிப்பு அனுமதி தேவை.'
                          : 'Required to show your medicine alert banner and sound.',
                      granted: _notifGranted,
                      isTa: isTa,
                      onTap: _requestNotification,
                    ),
                    const SizedBox(height: 12),

                    _PermissionRow(
                      icon: Icons.alarm_on_rounded,
                      title: isTa ? 'துல்லிய அலாரம்' : 'Exact Alarms',
                      subtitle: isTa
                          ? 'நீங்கள் அமைத்த சரியான நிமிடத்தில் அலாரம் அடிக்க.'
                          : 'Allows alerts to fire at the exact minute you choose.',
                      granted: _exactAlarmGranted,
                      isTa: isTa,
                      onTap: _requestExactAlarm,
                    ),
                    const SizedBox(height: 12),

                    _PermissionRow(
                      icon: Icons.battery_saver_rounded,
                      title: isTa
                          ? 'பேட்டரி தடையில்லா இயக்கம்'
                          : 'Unrestricted Battery',
                      subtitle: isTa
                          ? 'பின்னணியில் செயலி நிறுத்தப்படுவதைத் தடுக்கிறது.'
                          : 'Prevents Android from pausing reminders in the background.',
                      granted: _batteryIgnored,
                      isTa: isTa,
                      onTap: _requestBatteryIgnore,
                    ),
                    const SizedBox(height: 12),

                    _PermissionRow(
                      icon: Icons.record_voice_over_rounded,
                      title: isTa
                          ? 'தமிழ் குரல் தரவு (Google TTS)'
                          : 'Spoken Voice Data (Tamil / English)',
                      subtitle: isTa
                          ? 'மருந்து பெயரைத் தெளிவாக தமிழில் உச்சரிக்க.'
                          : 'Enables clear spoken Tamil and English voice alerts offline.',
                      granted: _tamilVoiceReady,
                      isTa: isTa,
                      onTap: _openTtsInstall,
                    ),

                    const SizedBox(height: 28),

                    // ── 1-Minute Test Alert Box ───────────────────────────
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppTheme.surface(context),
                        borderRadius: BorderRadius.circular(AppTheme.radiusLG),
                        border: Border.all(color: AppTheme.divider(context)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.play_circle_outline_rounded,
                                  color: AppTheme.primaryOf(context), size: 24),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  isTa
                                      ? '1 நிமிட சோதனை அலாரம்'
                                      : 'Run a 1-Minute Test Alert',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: AppTheme.text(context),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            isTa
                                ? 'உங்கள் தொலைபேசியில் அலாரம் வேலை செய்கிறதா என்பதை உறுதிப்படுத்த சோதனையை இயக்கவும்.'
                                : 'Run this quick test and lock your phone screen to verify the alert rings and speaks aloud.',
                            style: TextStyle(
                              fontSize: 15,
                              height: 1.5,
                              color: AppTheme.textSub(context),
                            ),
                          ),
                          if (_scheduledTestTime != null) ...[
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: AppTheme.successBg(context),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                isTa
                                    ? 'சோதனை அலாரம் ${DateFormat('hh:mm a').format(_scheduledTestTime!)} க்கு அமைக்கப்பட்டது'
                                    : 'Scheduled for ${DateFormat('hh:mm a').format(_scheduledTestTime!)} — lock your screen now.',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.successFg(context),
                                ),
                              ),
                            ),
                          ],
                          const SizedBox(height: 16),
                          OutlinedButton.icon(
                            onPressed: _schedulingTest
                                ? null
                                : () => _scheduleTestAlert(isTa),
                            icon: _schedulingTest
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2),
                                  )
                                : const Icon(Icons.notifications_active_outlined),
                            label: Text(
                              isTa
                                  ? '1 நிமிடத்தில் சோதனை செய்க'
                                  : 'Test Alert in 1 Minute',
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),

                    FilledButton.icon(
                      onPressed: _finish,
                      icon: const Icon(Icons.check_rounded),
                      label: Text(
                        widget.fromSettings
                            ? (isTa ? 'முடிந்தது' : 'Done')
                            : (isTa ? 'தொடங்குக' : 'Continue to App'),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

class _PermissionRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool granted;
  final bool isTa;
  final VoidCallback onTap;

  const _PermissionRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.granted,
    required this.isTa,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final primary = AppTheme.primaryOf(context);
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.radiusLG),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: granted
                      ? AppTheme.successBg(context)
                      : AppTheme.chipBg(context),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  granted ? Icons.check_circle_rounded : icon,
                  color: granted ? AppTheme.successFg(context) : primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.text(context),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: granted
                                ? AppTheme.successBg(context)
                                : AppTheme.warningBg(context),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            granted
                                ? (isTa ? 'சரி' : 'Allowed')
                                : (isTa ? 'அனுமதி தா' : 'Tap to allow'),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: granted
                                  ? AppTheme.successFg(context)
                                  : AppTheme.warningFg(context),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.4,
                        color: AppTheme.textSub(context),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
