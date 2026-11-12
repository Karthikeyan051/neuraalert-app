import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:neuraalert/app/app_theme.dart';
import 'package:neuraalert/features/alerts/reminders_repository.dart';
import 'package:neuraalert/features/settings/app_settings_provider.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  int _selectedDayOffset = 0; // 0 = today, 1 = yesterday, ..., 6 = 6 days ago

  @override
  Widget build(BuildContext context) {
    final logsAsync = ref.watch(recentDoseLogsStreamProvider);
    final isTa = ref.watch(appSettingsProvider).isTamil;
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);

    return Scaffold(
      backgroundColor: AppTheme.bg(context),
      appBar: AppBar(
        titleSpacing: 24,
        title: Text(isTa ? 'மருந்து வரலாறு' : 'Dose History'),
      ),
      body: logsAsync.when(
        data: (allLogs) {
          final taken7 =
              allLogs.where((l) => l.log.status == 'taken').length;
          final skipped7 =
              allLogs.where((l) => l.log.status == 'skipped').length;
          final snoozed7 =
              allLogs.where((l) => l.log.status == 'snoozed').length;

          final selectedDay =
              todayStart.subtract(Duration(days: _selectedDayOffset));
          final nextDay = selectedDay.add(const Duration(days: 1));
          final dayLogs = allLogs.where((l) {
            final t = l.log.scheduledAt;
            return !t.isBefore(selectedDay) && t.isBefore(nextDay);
          }).toList();

          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 128),
            children: [
              // ── 7-day summary strip ───────────────────────────────────
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppTheme.surface(context),
                  borderRadius: BorderRadius.circular(AppTheme.radiusLG),
                  border: Border.all(color: AppTheme.divider(context)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isTa ? 'கடந்த 7 நாட்கள்' : 'LAST 7 DAYS',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.6,
                        color: AppTheme.primaryOf(context),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        _StatCount(
                          count: taken7,
                          label: isTa ? 'எடுத்தது' : 'Taken',
                          color: AppTheme.successFg(context),
                        ),
                        _StatCount(
                          count: snoozed7,
                          label: isTa ? 'தள்ளியது' : 'Snoozed',
                          color: AppTheme.warningFg(context),
                        ),
                        _StatCount(
                          count: skipped7,
                          label: isTa ? 'தவிர்த்தது' : 'Skipped',
                          color: AppTheme.textSub(context),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ── Day picker strip ──────────────────────────────────────
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(7, (idx) {
                    final day = todayStart.subtract(Duration(days: idx));
                    final isSelected = idx == _selectedDayOffset;
                    final primary = AppTheme.primaryOf(context);
                    return Padding(
                      padding: EdgeInsets.only(right: idx < 6 ? 8 : 0),
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedDayOffset = idx),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 160),
                          constraints: const BoxConstraints(
                              minWidth: 64, minHeight: 72),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppTheme.chipBg(context)
                                : AppTheme.surface(context),
                            borderRadius:
                                BorderRadius.circular(AppTheme.radiusMD),
                            border: Border.all(
                              color: isSelected
                                  ? primary
                                  : AppTheme.divider(context),
                              width: isSelected ? 1.5 : 1,
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                idx == 0
                                    ? (isTa ? 'இன்று' : 'Today')
                                    : DateFormat('EEE').format(day),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: isSelected
                                      ? primary
                                      : AppTheme.textSub(context),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${day.day}',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: isSelected
                                      ? primary
                                      : AppTheme.text(context),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),

              const SizedBox(height: 24),

              // ── Daily Log List ────────────────────────────────────────
              if (dayLogs.isEmpty)
                Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: AppTheme.surface(context),
                    borderRadius: BorderRadius.circular(AppTheme.radiusLG),
                    border: Border.all(color: AppTheme.divider(context)),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.history_rounded,
                          size: 40, color: AppTheme.textSub(context)),
                      const SizedBox(height: 12),
                      Text(
                        isTa
                            ? 'இந்த நாளில் பதிவுகள் எதுவும் இல்லை'
                            : 'No dose logs recorded for this day',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppTheme.textSub(context),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              else
                ...dayLogs.map((entry) {
                  final log = entry.log;
                  final name = entry.schedule?.label ??
                      (isTa ? 'நினைவூட்டல்' : 'Reminder');
                  final timeStr = DateFormat('hh:mm a').format(log.scheduledAt);
                  final (label, bg, fg) = switch (log.status) {
                    'taken' => (
                        isTa ? 'எடுத்தது' : 'Taken',
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
                        log.status,
                        AppTheme.chipBg(context),
                        AppTheme.primaryOf(context),
                      ),
                  };

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    name,
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
                                      color: AppTheme.text(context),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    timeStr,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: AppTheme.textSub(context),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: bg,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                label,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: fg,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }
}

class _StatCount extends StatelessWidget {
  final int count;
  final String label;
  final Color color;

  const _StatCount({
    required this.count,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            '$count',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: AppTheme.textSub(context),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
