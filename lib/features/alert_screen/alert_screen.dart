import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../services/alarm_service.dart';
import '../../services/voice_service.dart';

class AlertScreen extends StatefulWidget {
  final int alarmId;
  final String medicineName;
  final String scheduleLabel;
  final String voiceLang;      // 'ta' or 'en'
  final String voiceFilePath;

  const AlertScreen({
    super.key,
    required this.alarmId,
    required this.medicineName,
    this.scheduleLabel = '',
    this.voiceLang = 'ta',
    this.voiceFilePath = '',
  });

  @override
  State<AlertScreen> createState() => _AlertScreenState();
}

class _AlertScreenState extends State<AlertScreen> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  final VoiceService _voiceService = VoiceService();
  Timer? _voiceRepeatTimer;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.92, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Speak voice alert immediately and loop
    _initAndStartVoice();
  }

  Future<void> _initAndStartVoice() async {
    await _voiceService.init();
    _playVoiceOnce();

    // Repeat spoken alert every 9 seconds while screen is visible
    _voiceRepeatTimer = Timer.periodic(const Duration(seconds: 9), (_) {
      if (mounted) {
        _playVoiceOnce();
      }
    });
  }

  void _playVoiceOnce() {
    final textToSpeak = widget.scheduleLabel.isNotEmpty
        ? widget.scheduleLabel
        : widget.medicineName;
    _voiceService.speakText(textToSpeak, widget.voiceLang);
  }

  @override
  void dispose() {
    _voiceRepeatTimer?.cancel();
    _voiceService.stop();
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _handleTaken() async {
    _voiceRepeatTimer?.cancel();
    await _voiceService.stop();
    await AlarmService.stop(widget.alarmId);
    if (mounted) Navigator.of(context).maybePop();
  }

  Future<void> _handleSnooze() async {
    _voiceRepeatTimer?.cancel();
    await _voiceService.stop();
    await AlarmService.stop(widget.alarmId);
    // Schedule snooze in 10 minutes
    await AlarmService.scheduleAlarm(
      id: widget.alarmId + 1000,
      fireAt: DateTime.now().add(const Duration(minutes: 10)),
      title: widget.medicineName,
      body: widget.scheduleLabel,
    );
    if (mounted) Navigator.of(context).maybePop();
  }

  Future<void> _handleSkip() async {
    _voiceRepeatTimer?.cancel();
    await _voiceService.stop();
    await AlarmService.stop(widget.alarmId);
    if (mounted) Navigator.of(context).maybePop();
  }

  @override
  Widget build(BuildContext context) {
    final isTa = widget.voiceLang == 'ta';
    final timeStr = DateFormat('hh:mm a').format(DateTime.now());

    const categoryLabel = '💊 Medicine Alert';

    final takenLabel = isTa ? '✓ எடுத்தேன்' : '✓ Taken';
    final snoozeLabel = isTa ? '⏱ 10 நிமிடம் தள்ளிப்போடு' : '⏱ Snooze 10 min';
    final skipLabel = isTa ? 'தவிர்' : 'Skip';

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: const Color(0xFF0D1E3A), // Deep professional navy
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Top Header: Category Pill & Time
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                      ),
                      child: const Text(
                        categoryLabel,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Text(
                      timeStr,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.85),
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),

                const Spacer(flex: 1),

                // Pulsing Icon Ring (Alive, professional breathing animation)
                AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _pulseAnimation.value,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF1565C0).withValues(alpha: 0.25),
                          border: Border.all(
                            color: const Color(0xFF2196F3).withValues(alpha: 0.6),
                            width: 2.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF2196F3).withValues(alpha: 0.3),
                              blurRadius: 30,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.notifications_active_rounded,
                          color: Colors.white,
                          size: 56,
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 36),

                // Dominant Alert Name
                Text(
                  widget.medicineName,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 38,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                    height: 1.2,
                  ),
                ),

                const SizedBox(height: 16),

                // Subtitle / Schedule Label
                if (widget.scheduleLabel.isNotEmpty)
                  Text(
                    widget.scheduleLabel,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontSize: 19,
                      fontWeight: FontWeight.w500,
                      height: 1.4,
                    ),
                  ),

                const Spacer(flex: 2),

                // Action 1: Taken (Primary Full Width 64dp)
                SizedBox(
                  width: double.infinity,
                  height: 64,
                  child: ElevatedButton(
                    onPressed: _handleTaken,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1565C0), // Blue primary
                      foregroundColor: Colors.white,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      takenLabel,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                // Action 2: Snooze 10 min (Outlined 56dp)
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: OutlinedButton(
                    onPressed: _handleSnooze,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: BorderSide(color: Colors.white.withValues(alpha: 0.4), width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      snoozeLabel,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // Action 3: Skip (Muted Text Button 48dp)
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: TextButton(
                    onPressed: _handleSkip,
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white.withValues(alpha: 0.65),
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

                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
