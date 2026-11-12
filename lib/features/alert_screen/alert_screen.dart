import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:drift/drift.dart' as drift;
import 'package:uuid/uuid.dart';
import '../../app/app_theme.dart';
import '../../data/db/app_database.dart';
import '../../main.dart';
import '../../services/alarm_service.dart';
import '../../services/voice_service.dart';
import '../settings/app_settings_provider.dart';

class AlertScreen extends ConsumerStatefulWidget {
  final int alarmId;
  final String medicineName;
  final String alertType;
  final String doseNote;
  final String foodRelation;
  final String spokenPhrase;
  final String voiceLang;
  final String voiceFilePath;
  final bool isTestAlert;

  const AlertScreen({
    super.key,
    required this.alarmId,
    required this.medicineName,
    this.alertType = 'medicine',
    this.doseNote = '',
    this.foodRelation = 'none',
    this.spokenPhrase = '',
    this.voiceLang = 'ta',
    this.voiceFilePath = '',
    this.isTestAlert = false,
  });

  @override
  ConsumerState<AlertScreen> createState() => _AlertScreenState();
}

class _AlertScreenState extends ConsumerState<AlertScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  final VoiceService _voiceService = VoiceService();
  Timer? _voiceRepeatTimer;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.96, end: 1.04).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _initAndStartVoice();
  }

  Future<void> _initAndStartVoice() async {
    final settings = ref.read(appSettingsProvider);
    if (!settings.voiceEnabled) return;

    await _voiceService.init();
    _playVoiceOnce();
    _voiceRepeatTimer = Timer.periodic(const Duration(seconds: 9), (_) {
      if (mounted) _playVoiceOnce();
    });
  }

  void _playVoiceOnce() {
    final textToSpeak = widget.spokenPhrase.isNotEmpty
        ? widget.spokenPhrase
        : widget.medicineName;
    _voiceService.speakText(textToSpeak, widget.voiceLang);
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    _voiceRepeatTimer?.cancel();
    _voiceService.stop();
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _recordDoseLog(String status) async {
    if (widget.isTestAlert) {
      await ref.read(appSettingsProvider.notifier).markTestAlertPassed();
      return;
    }
    try {
      final scheduledAlarm = await (db.select(db.scheduledAlarms)
            ..where((t) => t.alarmId.equals(widget.alarmId)))
          .getSingleOrNull();

      if (scheduledAlarm != null) {
        final now = DateTime.now();
        await db.into(db.doseLogs).insert(
              DoseLogsCompanion(
                id: drift.Value(const Uuid().v4()),
                scheduleId: drift.Value(scheduledAlarm.scheduleId),
                scheduledAt: drift.Value(scheduledAlarm.fireAt),
                status: drift.Value(status),
                actedAt: drift.Value(now),
                updatedAt: drift.Value(now),
              ),
            );
      }
    } catch (_) {}
  }

  void _dismissScreen() {
    if (mounted) {
      if (context.canPop()) {
        context.pop();
      } else {
        context.go('/today');
      }
    }
  }

  Future<void> _handleTaken() async {
    HapticFeedback.mediumImpact();
    _voiceRepeatTimer?.cancel();
    await _voiceService.stop();
    await AlarmService.stop(widget.alarmId);
    await _recordDoseLog('taken');
    _dismissScreen();
  }

  Future<void> _handleSnooze() async {
    HapticFeedback.lightImpact();
    final snoozeMins = ref.read(appSettingsProvider).snoozeMinutes;
    _voiceRepeatTimer?.cancel();
    await _voiceService.stop();
    await AlarmService.stop(widget.alarmId);
    await _recordDoseLog('snoozed');
    final snoozeAlarmId = (widget.alarmId + 1000) & 0x7FFFFFFF;
    await AlarmService.scheduleAlarm(
      id: snoozeAlarmId,
      fireAt: DateTime.now().add(Duration(minutes: snoozeMins)),
      voiceAudioPath:
          widget.voiceFilePath.isNotEmpty ? widget.voiceFilePath : null,
      title: widget.medicineName,
      body: widget.spokenPhrase,
    );
    _dismissScreen();
  }

  Future<void> _handleSkip() async {
    HapticFeedback.selectionClick();
    _voiceRepeatTimer?.cancel();
    await _voiceService.stop();
    await AlarmService.stop(widget.alarmId);
    await _recordDoseLog('skipped');
    _dismissScreen();
  }

  String _foodRelationText(String rel, bool isTa) {
    return switch (rel) {
      'before' => isTa ? 'உணவுக்கு முன்' : 'Before food',
      'after' => isTa ? 'உணவுக்குப் பின்' : 'After food',
      'with' => isTa ? 'உணவுடன்' : 'With food',
      _ => '',
    };
  }

  String _alertBadgeText(String type, bool isTa) {
    return switch (type) {
      'meeting' => isTa ? 'சந்திப்பு நேரம்' : 'Meeting Alert',
      'alarm' => isTa ? 'அலாரம்' : 'Alarm',
      'custom' => isTa ? 'நினைவூட்டல்' : 'Reminder',
      _ => isTa ? 'மருந்து நேரம்' : 'Medicine Alert',
    };
  }

  IconData _alertIcon(String type) {
    return switch (type) {
      'meeting' => Icons.event_rounded,
      'alarm' => Icons.alarm_rounded,
      'custom' => Icons.notifications_active_rounded,
      _ => Icons.medication_rounded,
    };
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(appSettingsProvider);
    final isTa = widget.voiceLang == 'ta';
    final snoozeMins = settings.snoozeMinutes;
    final timeStr = DateFormat('hh:mm a').format(DateTime.now());

    final alertLabel = _alertBadgeText(widget.alertType, isTa);
    final foodText = _foodRelationText(widget.foodRelation, isTa);
    final takenLabel = isTa ? 'எடுத்தேன்' : 'Taken';
    final snoozeLabel = isTa
        ? '$snoozeMins நிமிடம் தள்ளிப்போடு'
        : 'Snooze $snoozeMins min';
    final skipLabel = isTa ? 'தவிர்' : 'Skip';

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppTheme.alertBg,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24.0, vertical: 24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // ── Top bar: category pill + time ─────────────
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 14, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: AppTheme.alertPrimary
                                        .withValues(alpha: 0.14),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: AppTheme.alertPrimary
                                          .withValues(alpha: 0.45),
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        _alertIcon(widget.alertType),
                                        color: AppTheme.alertPrimary,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 6),
                                      Flexible(
                                        child: Text(
                                          alertLabel,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            color: AppTheme.alertPrimary,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                timeStr,
                                style: TextStyle(
                                  color: AppTheme.alertText
                                      .withValues(alpha: 0.78),
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),

                          const Spacer(),
                          const SizedBox(height: 24),

                          // ── Calm clinical bell emblem ─────────────────
                          ScaleTransition(
                            scale: _pulseAnimation,
                            child: Container(
                              width: 96,
                              height: 96,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppTheme.alertPrimary
                                    .withValues(alpha: 0.10),
                                border: Border.all(
                                  color: AppTheme.alertPrimary
                                      .withValues(alpha: 0.45),
                                  width: 2,
                                ),
                              ),
                              child: const Icon(
                                Icons.notifications_active_rounded,
                                color: AppTheme.alertPrimary,
                                size: 44,
                              ),
                            ),
                          ),

                          const SizedBox(height: 32),

                          // ── Dominant medicine/alert name ──────────────
                          Text(
                            widget.medicineName,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: AppTheme.alertText,
                              fontSize: 38,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.5,
                              height: 1.2,
                            ),
                          ),

                          if (widget.doseNote.trim().isNotEmpty) ...[
                            const SizedBox(height: 16),
                            Text(
                              widget.doseNote.trim(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color:
                                    AppTheme.alertText.withValues(alpha: 0.85),
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],

                          if (foodText.isNotEmpty) ...[
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.18),
                                ),
                              ),
                              child: Text(
                                foodText,
                                style: const TextStyle(
                                  color: AppTheme.alertTextSub,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],

                          const Spacer(flex: 2),
                          const SizedBox(height: 32),

                          // ── Primary Action: Taken ─────────────────────
                          SizedBox(
                            width: double.infinity,
                            height: 62,
                            child: FilledButton.icon(
                              onPressed: _handleTaken,
                              style: FilledButton.styleFrom(
                                backgroundColor: AppTheme.primary,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(AppTheme.radiusLG),
                                ),
                              ),
                              icon: const Icon(Icons.check_rounded, size: 24),
                              label: Text(
                                takenLabel,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 14),

                          // ── Secondary Action: Snooze ──────────────────
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: OutlinedButton.icon(
                              onPressed: _handleSnooze,
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppTheme.alertText,
                                side: BorderSide(
                                  color:
                                      AppTheme.alertText.withValues(alpha: 0.35),
                                  width: 1.5,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(AppTheme.radiusLG),
                                ),
                              ),
                              icon:
                                  const Icon(Icons.snooze_rounded, size: 20),
                              label: Text(
                                snoozeLabel,
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 10),

                          // ── Muted Action: Skip ────────────────────────
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: TextButton(
                              onPressed: _handleSkip,
                              style: TextButton.styleFrom(
                                foregroundColor:
                                    AppTheme.alertText.withValues(alpha: 0.65),
                              ),
                              child: Text(
                                skipLabel,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
