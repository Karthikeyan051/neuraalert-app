import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:neuraalert/app/app_theme.dart';
import 'package:neuraalert/features/alerts/reminders_repository.dart';
import 'package:neuraalert/features/settings/app_settings_provider.dart';

class AlertsScreen extends ConsumerWidget {
  const AlertsScreen({super.key});

  String _formatTime(int minutes) {
    final hour = minutes ~/ 60;
    final min = minutes % 60;
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    final minStr = min.toString().padLeft(2, '0');
    return '$displayHour:$minStr $period';
  }

  String _formatDays(int mask, bool isTa) {
    if (mask == 127) return isTa ? 'தினமும்' : 'Every day';
    if (mask == 31) return isTa ? 'திங்கள்–வெள்ளி' : 'Mon–Fri';
    if (mask == 96) return isTa ? 'சனி, ஞாயிறு' : 'Sat–Sun';
    final dayNames = isTa
        ? const ['திங்', 'செவ்', 'புத', 'வியா', 'வெள்', 'சனி', 'ஞாயி']
        : const ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final selected = <String>[];
    for (int i = 0; i < 7; i++) {
      if ((mask & (1 << i)) != 0) selected.add(dayNames[i]);
    }
    return selected.isEmpty
        ? (isTa ? 'ஒரு முறை' : 'Once')
        : selected.join(', ');
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'medicine':
        return Icons.medication_rounded;
      case 'meeting':
        return Icons.event_note_rounded;
      case 'alarm':
        return Icons.alarm_rounded;
      default:
        return Icons.notifications_active_rounded;
    }
  }

  String _getTypeLabel(String type, bool isTa) {
    switch (type) {
      case 'medicine':
        return isTa ? 'மருந்து' : 'Medicine';
      case 'meeting':
        return isTa ? 'சந்திப்பு' : 'Meeting';
      case 'alarm':
        return isTa ? 'அலாரம்' : 'Alarm';
      default:
        return isTa ? 'மற்றவை' : 'Custom';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final schedulesAsync = ref.watch(activeSchedulesStreamProvider);
    final isTa = ref.watch(appSettingsProvider).isTamil;

    return Scaffold(
      backgroundColor: AppTheme.bg(context),
      appBar: AppBar(
        titleSpacing: 24,
        title: Text(isTa ? 'நினைவூட்டல்கள்' : 'Reminders'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: FilledButton.icon(
              onPressed: () => context.push('/add-alert'),
              icon: const Icon(Icons.add_rounded, size: 20),
              label: Text(isTa ? 'சேர்' : 'Add'),
              style: FilledButton.styleFrom(
                minimumSize: const Size(0, 42),
                padding: const EdgeInsets.symmetric(horizontal: 14),
              ),
            ),
          ),
        ],
      ),
      body: schedulesAsync.when(
        data: (schedules) {
          if (schedules.isEmpty) {
            return _EmptyState(
              isTa: isTa,
              onAdd: () => context.push('/add-alert'),
            );
          }

          final morning = <ScheduleWithMedicine>[];
          final afternoon = <ScheduleWithMedicine>[];
          final night = <ScheduleWithMedicine>[];

          for (final item in schedules) {
            final h = item.schedule.timeMinutes ~/ 60;
            if (h < 12) {
              morning.add(item);
            } else if (h < 17) {
              afternoon.add(item);
            } else {
              night.add(item);
            }
          }

          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 128),
            children: [
              if (morning.isNotEmpty) ...[
                _GroupHeader(
                  title: isTa ? 'காலை (Morning)' : 'MORNING',
                  count: morning.length,
                ),
                ...morning.map((item) => _buildDismissibleTile(
                      context: context,
                      ref: ref,
                      item: item,
                      uiIsTa: isTa,
                    )),
                const SizedBox(height: 16),
              ],
              if (afternoon.isNotEmpty) ...[
                _GroupHeader(
                  title: isTa ? 'மதியம் (Afternoon)' : 'AFTERNOON',
                  count: afternoon.length,
                ),
                ...afternoon.map((item) => _buildDismissibleTile(
                      context: context,
                      ref: ref,
                      item: item,
                      uiIsTa: isTa,
                    )),
                const SizedBox(height: 16),
              ],
              if (night.isNotEmpty) ...[
                _GroupHeader(
                  title: isTa ? 'மாலை & இரவு (Night)' : 'EVENING & NIGHT',
                  count: night.length,
                ),
                ...night.map((item) => _buildDismissibleTile(
                      context: context,
                      ref: ref,
                      item: item,
                      uiIsTa: isTa,
                    )),
              ],
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) =>
            Center(child: Text('Error loading reminders: $err')),
      ),
    );
  }

  Widget _buildDismissibleTile({
    required BuildContext context,
    required WidgetRef ref,
    required ScheduleWithMedicine item,
    required bool uiIsTa,
  }) {
    final schedule = item.schedule;
    final medicine = item.medicine;
    final isEnabled = schedule.enabled;
    final primary = AppTheme.primaryOf(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Dismissible(
        key: Key(schedule.id),
        direction: DismissDirection.endToStart,
        confirmDismiss: (_) async {
          HapticFeedback.mediumImpact();
          final confirmed = await showDialog<bool>(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text(uiIsTa ? 'நினைவூட்டலை நீக்கவா?' : 'Delete Reminder?'),
              content: Text(uiIsTa
                  ? 'இதற்கான அனைத்து எதிர்கால அலாரங்களும் ரத்து செய்யப்படும்.'
                  : 'This will cancel all future alarms for this reminder.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  child: Text(uiIsTa ? 'ரத்து' : 'Cancel'),
                ),
                FilledButton(
                  onPressed: () => Navigator.pop(ctx, true),
                  style: FilledButton.styleFrom(backgroundColor: AppTheme.error),
                  child: Text(uiIsTa ? 'நீக்கு' : 'Delete'),
                ),
              ],
            ),
          );
          return confirmed == true;
        },
        onDismissed: (_) =>
            ref.read(remindersRepositoryProvider).deleteSchedule(schedule.id),
        background: Container(
          decoration: BoxDecoration(
            color: AppTheme.error,
            borderRadius: BorderRadius.circular(AppTheme.radiusLG),
          ),
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.delete_rounded, color: Colors.white, size: 26),
              const SizedBox(height: 4),
              Text(
                uiIsTa ? 'நீக்கு' : 'Delete',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        child: Card(
          child: InkWell(
            borderRadius: BorderRadius.circular(AppTheme.radiusLG),
            onTap: () => context.push('/add-alert', extra: item),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: isEnabled
                          ? AppTheme.chipBg(context)
                          : AppTheme.card(context),
                      borderRadius: BorderRadius.circular(AppTheme.radiusMD),
                    ),
                    child: Icon(
                      _getTypeIcon(schedule.alertType),
                      color: isEnabled ? primary : AppTheme.textSub(context),
                      size: 25,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _formatTime(schedule.timeMinutes),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: isEnabled
                                ? AppTheme.text(context)
                                : AppTheme.textSub(context),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          schedule.label,
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            color: isEnabled
                                ? AppTheme.text(context)
                                : AppTheme.textSub(context),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            _Tag(
                              label: _getTypeLabel(schedule.alertType, uiIsTa),
                              color: AppTheme.chipBg(context),
                              textColor: primary,
                            ),
                            if (medicine != null &&
                                medicine.foodRelation != 'none')
                              _Tag(
                                label: medicine.foodRelation == 'before'
                                    ? (uiIsTa ? 'உணவுக்கு முன்' : 'Before food')
                                    : (medicine.foodRelation == 'after'
                                        ? (uiIsTa
                                            ? 'உணவுக்குப் பின்'
                                            : 'After food')
                                        : (uiIsTa ? 'உணவுடன்' : 'With food')),
                                color: AppTheme.warningBg(context),
                                textColor: AppTheme.warningFg(context),
                              ),
                            Text(
                              _formatDays(schedule.daysMask, uiIsTa),
                              style: TextStyle(
                                fontSize: 13,
                                color: AppTheme.textSub(context),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Switch(
                    value: isEnabled,
                    onChanged: (val) {
                      HapticFeedback.selectionClick();
                      ref
                          .read(remindersRepositoryProvider)
                          .toggleScheduleEnabled(schedule.id, val);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GroupHeader extends StatelessWidget {
  final String title;
  final int count;

  const _GroupHeader({required this.title, required this.count});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 8, 4, 10),
      child: Row(
        children: [
          Text(
            title,
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
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String label;
  final Color color;
  final Color textColor;

  const _Tag({
    required this.label,
    required this.color,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final bool isTa;
  final VoidCallback onAdd;
  const _EmptyState({required this.isTa, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    final primary = AppTheme.primaryOf(context);
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(32, 32, 32, 128),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppTheme.chipBg(context),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.alarm_add_rounded,
                color: primary,
                size: 40,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              isTa ? 'நினைவூட்டல்கள் இல்லை' : 'No Reminders Yet',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppTheme.text(context),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              isTa
                  ? 'மருந்து, சந்திப்பு அல்லது அலாரம் சேர்க்க கீழே உள்ள பொத்தானை அழுத்தவும்.'
                  : 'Add your first medicine, meeting, or daily alarm below.',
              style: TextStyle(
                fontSize: 17,
                color: AppTheme.textSub(context),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),
            FilledButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add_rounded),
              label: Text(
                  isTa ? 'புதிய நினைவூட்டல் சேர்' : 'Add First Reminder'),
            ),
          ],
        ),
      ),
    );
  }
}
