import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:neuraalert/app/app_theme.dart';
import 'package:neuraalert/data/db/app_database.dart';
import 'package:neuraalert/features/alerts/reminders_repository.dart';
import 'package:neuraalert/features/settings/app_settings_provider.dart';

final _dailyQuoteProvider = FutureProvider<Map<String, String>?>((ref) async {
  try {
    final raw = await rootBundle.loadString('assets/quotes/quotes.json');
    final list = jsonDecode(raw) as List<dynamic>;
    if (list.isEmpty) return null;
    final now = DateTime.now();
    final dayOfYear =
        now.difference(DateTime(now.year, 1, 1)).inDays;
    final item = list[dayOfYear % list.length] as Map<String, dynamic>;
    return {
      'en': item['en']?.toString() ?? '',
      'ta': item['ta']?.toString() ?? '',
      'author': item['author']?.toString() ?? '',
    };
  } catch (_) {
    return null;
  }
});

class TodayScreen extends ConsumerWidget {
  const TodayScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final schedulesAsync = ref.watch(activeSchedulesStreamProvider);
    final logsAsync = ref.watch(todayDoseLogsStreamProvider);
    final quoteAsync = ref.watch(_dailyQuoteProvider);
    final settings = ref.watch(appSettingsProvider);
    final isTa = settings.isTamil;

    final now = DateTime.now();
    final greeting = _greeting(now, isTa);
    final dateStr = DateFormat('EEEE, d MMM').format(now);

    return Scaffold(
      backgroundColor: AppTheme.bg(context),
      body: schedulesAsync.when(
        data: (allSchedules) {
          final todaySchedules = allSchedules
              .where((item) =>
                  RemindersRepository.isScheduledForDate(item.schedule, now))
              .toList();

          final todayLogs = logsAsync.valueOrNull ?? <DoseLog>[];
          final statusByScheduleId = <String, String>{};
          for (final log in todayLogs) {
            statusByScheduleId.putIfAbsent(log.scheduleId, () => log.status);
          }

          final total = todaySchedules.length;
          final takenCount = todaySchedules
              .where((s) => statusByScheduleId[s.schedule.id] == 'taken')
              .length;

          final morning = <ScheduleWithMedicine>[];
          final afternoon = <ScheduleWithMedicine>[];
          final night = <ScheduleWithMedicine>[];

          for (final item in todaySchedules) {
            final h = item.schedule.timeMinutes ~/ 60;
            if (h < 12) {
              morning.add(item);
            } else if (h < 17) {
              afternoon.add(item);
            } else {
              night.add(item);
            }
          }

          return CustomScrollView(
            slivers: [
              // ── App bar ───────────────────────────────────────────────
              SliverAppBar(
                floating: true,
                snap: true,
                elevation: 0,
                scrolledUnderElevation: 1,
                titleSpacing: 24,
                title: const Text(
                  'NeuraAlert',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.3,
                  ),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: TextButton.icon(
                      onPressed: () => context.go('/history'),
                      icon: const Icon(Icons.bar_chart_rounded, size: 20),
                      label: Text(isTa ? 'வரலாறு' : 'History'),
                    ),
                  ),
                ],
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // ── Greeting & Date ──────────────────────────────
                      Text(
                        greeting,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.text(context),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        dateStr,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: AppTheme.textSub(context),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // ── Test alert setup banner if never tested ───────
                      if (!settings.testAlertPassed) ...[
                        _SetupBanner(
                          isTa: isTa,
                          onTap: () => context.push('/onboarding?from=settings'),
                        ),
                        const SizedBox(height: 16),
                      ],

                      // ── Adherence Ring Card ───────────────────────────
                      _AdherenceCard(
                        taken: takenCount,
                        total: total,
                        isTa: isTa,
                        onTap: () => context.go('/history'),
                      ),

                      // ── Quote Card ────────────────────────────────────
                      if (quoteAsync.valueOrNull != null) ...[
                        const SizedBox(height: 16),
                        _QuoteCard(
                          quote: quoteAsync.valueOrNull!,
                          isTa: isTa,
                        ),
                      ],

                      const SizedBox(height: 28),

                      if (total == 0)
                        _EmptyToday(
                          isTa: isTa,
                          onAdd: () => context.push('/add-alert'),
                        )
                      else ...[
                        if (morning.isNotEmpty) ...[
                          _TimeSectionHeader(
                            label: isTa ? 'காலை · Morning' : 'MORNING',
                            count: morning.length,
                          ),
                          const SizedBox(height: 10),
                          ...morning.map((item) => _DoseCard(
                                item: item,
                                status: statusByScheduleId[item.schedule.id] ??
                                    'pending',
                                isTa: isTa,
                                onTap: () => _showDoseActionSheet(
                                    context, ref, item, isTa),
                              )),
                          const SizedBox(height: 20),
                        ],
                        if (afternoon.isNotEmpty) ...[
                          _TimeSectionHeader(
                            label: isTa ? 'மதியம் · Afternoon' : 'AFTERNOON',
                            count: afternoon.length,
                          ),
                          const SizedBox(height: 10),
                          ...afternoon.map((item) => _DoseCard(
                                item: item,
                                status: statusByScheduleId[item.schedule.id] ??
                                    'pending',
                                isTa: isTa,
                                onTap: () => _showDoseActionSheet(
                                    context, ref, item, isTa),
                              )),
                          const SizedBox(height: 20),
                        ],
                        if (night.isNotEmpty) ...[
                          _TimeSectionHeader(
                            label: isTa ? 'இரவு · Night' : 'EVENING & NIGHT',
                            count: night.length,
                          ),
                          const SizedBox(height: 10),
                          ...night.map((item) => _DoseCard(
                                item: item,
                                status: statusByScheduleId[item.schedule.id] ??
                                    'pending',
                                isTa: isTa,
                                onTap: () => _showDoseActionSheet(
                                    context, ref, item, isTa),
                              )),
                        ],
                      ],

                      // Generous bottom breathing space clear of FAB & floating dock
                      const SizedBox(height: 168),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 92),
        child: FloatingActionButton.extended(
          onPressed: () => context.push('/add-alert'),
          icon: const Icon(Icons.add_rounded),
          label: Text(
            isTa ? 'மருந்து சேர்' : 'Add medicine',
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
          ),
          backgroundColor: AppTheme.primaryOf(context),
          foregroundColor:
              AppTheme.isDark(context) ? AppTheme.darkBg : Colors.white,
          elevation: 2,
        ),
      ),
    );
  }

  String _greeting(DateTime now, bool isTa) {
    final h = now.hour;
    if (isTa) {
      if (h < 12) return 'காலை வணக்கம்';
      if (h < 17) return 'மதிய வணக்கம்';
      if (h < 20) return 'மாலை வணக்கம்';
      return 'இரவு வணக்கம்';
    } else {
      if (h < 12) return 'Good morning';
      if (h < 17) return 'Good afternoon';
      return 'Good evening';
    }
  }

  void _showDoseActionSheet(
    BuildContext context,
    WidgetRef ref,
    ScheduleWithMedicine item,
    bool isTa,
  ) {
    final repo = ref.read(remindersRepositoryProvider);
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppTheme.surface(context),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  item.schedule.label,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.text(ctx),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  isTa
                      ? 'இன்றைய நிலையைப் பதிவு செய்யவும்'
                      : 'Update status for today',
                  style: TextStyle(
                    fontSize: 15,
                    color: AppTheme.textSub(ctx),
                  ),
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: () async {
                    Navigator.pop(ctx);
                    await repo.logManualDose(
                        schedule: item.schedule, status: 'taken');
                  },
                  icon: const Icon(Icons.check_rounded),
                  label: Text(isTa ? 'எடுத்தேன்' : 'Mark as Taken'),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () async {
                    Navigator.pop(ctx);
                    await repo.logManualDose(
                        schedule: item.schedule, status: 'skipped');
                  },
                  icon: const Icon(Icons.close_rounded),
                  label: Text(isTa ? 'இன்று தவிர்' : 'Skip Today'),
                ),
                const SizedBox(height: 8),
                TextButton.icon(
                  onPressed: () {
                    Navigator.pop(ctx);
                    context.push('/add-alert', extra: item);
                  },
                  icon: const Icon(Icons.edit_outlined, size: 18),
                  label: Text(isTa ? 'நினைவூட்டலை மாற்று' : 'Edit Reminder'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ── Setup / Test Alert Banner ────────────────────────────────────────────────

class _SetupBanner extends StatelessWidget {
  final bool isTa;
  final VoidCallback onTap;

  const _SetupBanner({required this.isTa, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppTheme.radiusLG),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppTheme.warningBg(context),
          borderRadius: BorderRadius.circular(AppTheme.radiusLG),
          border: Border.all(
              color: AppTheme.warningFg(context).withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Icon(Icons.notifications_paused_rounded,
                color: AppTheme.warningFg(context), size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                isTa
                    ? 'அலாரம் சரியாக ஒலிக்கிறதா என 1 நிமிட சோதனை செய்க'
                    : 'Run the 1-minute test alert to confirm alarms work on this phone',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.warningFg(context),
                ),
              ),
            ),
            Icon(Icons.chevron_right_rounded,
                color: AppTheme.warningFg(context)),
          ],
        ),
      ),
    );
  }
}

// ── Adherence Ring Card ──────────────────────────────────────────────────────

class _AdherenceCard extends StatelessWidget {
  final int taken;
  final int total;
  final bool isTa;
  final VoidCallback onTap;

  const _AdherenceCard({
    required this.taken,
    required this.total,
    required this.isTa,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final progress = total == 0 ? 0.0 : (taken / total).clamp(0.0, 1.0);
    final percent = (progress * 100).round();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: AppTheme.primary,
          borderRadius: BorderRadius.circular(AppTheme.radiusXL),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isTa ? 'இன்றைய நிலை' : 'TODAY\'S PROGRESS',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    total == 0
                        ? (isTa ? 'நினைவூட்டல்கள் இல்லை' : 'No doses today')
                        : (isTa
                            ? '$total இல் $taken எடுத்தது'
                            : '$taken of $total taken'),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    isTa ? 'வரலாறு பார்க்க →' : 'View weekly history →',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            SizedBox(
              width: 80,
              height: 80,
              child: CustomPaint(
                painter: _RingPainter(progress: progress),
                child: Center(
                  child: Text(
                    '$percent%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress;
  _RingPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 10) / 2;
    const stroke = 8.0;

    final trackPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke;

    final activePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, trackPaint);
    if (progress > 0) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -math.pi / 2,
        2 * math.pi * progress,
        false,
        activePaint,
      );
    }
  }

  @override
  bool shouldRepaint(_RingPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

// ── Quote Card ───────────────────────────────────────────────────────────────

class _QuoteCard extends StatelessWidget {
  final Map<String, String> quote;
  final bool isTa;

  const _QuoteCard({required this.quote, required this.isTa});

  @override
  Widget build(BuildContext context) {
    final text = isTa
        ? (quote['ta']?.isNotEmpty == true ? quote['ta']! : quote['en'] ?? '')
        : (quote['en'] ?? '');
    final author = quote['author'] ?? '';

    if (text.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface(context),
        borderRadius: BorderRadius.circular(AppTheme.radiusLG),
        border: Border.all(color: AppTheme.divider(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '“$text”',
            style: TextStyle(
              fontSize: 15,
              height: 1.5,
              color: AppTheme.text(context),
            ),
          ),
          if (author.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              '— $author',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppTheme.textSub(context),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ── Time Section & Dose Card ─────────────────────────────────────────────────

class _TimeSectionHeader extends StatelessWidget {
  final String label;
  final int count;

  const _TimeSectionHeader({required this.label, required this.count});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: AppTheme.primaryOf(context),
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(child: Divider(color: AppTheme.divider(context))),
        const SizedBox(width: 8),
        Text(
          '$count',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppTheme.textSub(context),
          ),
        ),
      ],
    );
  }
}

class _DoseCard extends StatelessWidget {
  final ScheduleWithMedicine item;
  final String status;
  final bool isTa;
  final VoidCallback onTap;

  const _DoseCard({
    required this.item,
    required this.status,
    required this.isTa,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final schedule = item.schedule;
    final medicine = item.medicine;
    final hour = schedule.timeMinutes ~/ 60;
    final min = schedule.timeMinutes % 60;
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    final timeStr = '$displayHour:${min.toString().padLeft(2, '0')} $period';

    final (chipLabel, chipBg, chipFg) = switch (status) {
      'taken' => (
          isTa ? 'எடுத்தது ✓' : 'Taken ✓',
          AppTheme.successBg(context),
          AppTheme.successFg(context),
        ),
      'snoozed' => (
          isTa ? 'தள்ளியது' : 'Snoozed',
          AppTheme.warningBg(context),
          AppTheme.warningFg(context),
        ),
      'skipped' => (
          isTa ? 'தவிர்த்தது' : 'Skipped',
          AppTheme.card(context),
          AppTheme.textSub(context),
        ),
      _ => (
          isTa ? 'காத்திருக்கிறது' : 'Pending',
          AppTheme.chipBg(context),
          AppTheme.primaryOf(context),
        ),
    };

    String foodLabel = '';
    if (medicine != null && medicine.foodRelation != 'none') {
      foodLabel = switch (medicine.foodRelation) {
        'before' => isTa ? 'உணவுக்கு முன்' : 'Before food',
        'after' => isTa ? 'உணவுக்குப் பின்' : 'After food',
        'with' => isTa ? 'உணவுடன்' : 'With food',
        _ => '',
      };
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Card(
        child: InkWell(
          borderRadius: BorderRadius.circular(AppTheme.radiusLG),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppTheme.chipBg(context),
                    borderRadius: BorderRadius.circular(AppTheme.radiusMD),
                  ),
                  child: Icon(
                    schedule.alertType == 'medicine'
                        ? Icons.medication_rounded
                        : (schedule.alertType == 'meeting'
                            ? Icons.event_rounded
                            : Icons.alarm_rounded),
                    color: AppTheme.primaryOf(context),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        schedule.label,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.text(context),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Wrap(
                        spacing: 6,
                        runSpacing: 2,
                        children: [
                          Text(
                            timeStr,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppTheme.textSub(context),
                            ),
                          ),
                          if (medicine != null && medicine.doseNote.isNotEmpty)
                            Text(
                              '· ${medicine.doseNote}',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppTheme.textSub(context),
                              ),
                            ),
                          if (foodLabel.isNotEmpty)
                            Text(
                              '· $foodLabel',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppTheme.textSub(context),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: chipBg,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    chipLabel,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: chipFg,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyToday extends StatelessWidget {
  final bool isTa;
  final VoidCallback onAdd;

  const _EmptyToday({required this.isTa, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 28),
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppTheme.chipBg(context),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(
              Icons.alarm_add_rounded,
              color: AppTheme.primaryOf(context),
              size: 36,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            isTa ? 'இன்று நினைவூட்டல்கள் இல்லை' : 'Nothing scheduled today',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w700,
              color: AppTheme.text(context),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            isTa
                ? 'மருந்து அல்லது நினைவூட்டல் சேர்க்க கீழே உள்ள பொத்தானை அழுத்தவும்.'
                : 'Tap the button below to schedule your first medicine reminder.',
            style: TextStyle(
              fontSize: 16,
              color: AppTheme.textSub(context),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          OutlinedButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add_rounded),
            label: Text(isTa ? 'நினைவூட்டல் சேர்' : 'Add Reminder'),
          ),
        ],
      ),
    );
  }
}
