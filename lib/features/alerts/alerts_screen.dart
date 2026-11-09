import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:neuraalert/features/alerts/reminders_repository.dart';

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

  String _formatDays(int mask, String lang) {
    if (mask == 127) {
      return lang == 'ta' ? 'தினமும்' : 'Every day';
    }
    if (mask == 31) {
      return lang == 'ta' ? 'வார நாட்கள் (திங்கள்-வெள்ளி)' : 'Weekdays (Mon-Fri)';
    }
    if (mask == 96) {
      return lang == 'ta' ? 'வார இறுதி (சனி, ஞாயிறு)' : 'Weekends (Sat-Sun)';
    }

    final dayNames = lang == 'ta'
        ? ['திங்கள்', 'செவ்வாய்', 'புதன்', 'வியாழன்', 'வெள்ளி', 'சனி', 'ஞாயிறு']
        : ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    final selected = <String>[];
    for (int i = 0; i < 7; i++) {
      if ((mask & (1 << i)) != 0) {
        selected.add(dayNames[i]);
      }
    }

    return selected.isEmpty
        ? (lang == 'ta' ? 'ஒரு முறை மட்டும்' : 'Never')
        : selected.join(', ');
  }

  String _getTypeLabel(String type, String lang) {
    switch (type) {
      case 'medicine':
        return lang == 'ta' ? 'மருந்து' : 'Medicine';
      case 'meeting':
        return lang == 'ta' ? 'சந்திப்பு' : 'Meeting';
      case 'alarm':
        return lang == 'ta' ? 'அலாரம்' : 'Alarm';
      default:
        return lang == 'ta' ? 'விருப்பம்' : 'Custom';
    }
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final schedulesAsync = ref.watch(activeSchedulesStreamProvider);
    final repo = ref.read(remindersRepositoryProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('நினைவூட்டல்கள் / Alerts'),
      ),
      body: schedulesAsync.when(
        data: (schedules) {
          if (schedules.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.alarm_off_rounded,
                      size: 72,
                      color: theme.colorScheme.primary.withAlpha(120),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'நினைவூட்டல்கள் எதுவும் இல்லை',
                      style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'மருந்து, சந்திப்பு அல்லது அலாரம் அமைக்க கீழே உள்ள பொத்தானை அழுத்தவும்.',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    FilledButton.icon(
                      onPressed: () => context.push('/add-alert'),
                      icon: const Icon(Icons.add),
                      label: const Text('புதிய நினைவூட்டல் சேர்'),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            itemCount: schedules.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = schedules[index];
              final schedule = item.schedule;
              final medicine = item.medicine;
              final isEnabled = schedule.enabled;
              final lang = schedule.voiceLang;

              return Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(
                    color: isEnabled
                        ? theme.colorScheme.primary.withAlpha(60)
                        : Colors.grey.withAlpha(40),
                    width: 1.2,
                  ),
                ),
                color: isEnabled ? theme.cardColor : theme.cardColor.withAlpha(120),
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () => context.push('/add-alert', extra: item),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: isEnabled
                                    ? theme.colorScheme.primary.withAlpha(30)
                                    : Colors.grey.withAlpha(30),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                _getTypeIcon(schedule.alertType),
                                color: isEnabled ? theme.colorScheme.primary : Colors.grey,
                                size: 28,
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
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: isEnabled
                                          ? theme.textTheme.bodyLarge?.color
                                          : Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    schedule.label,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: isEnabled
                                          ? theme.textTheme.bodyLarge?.color
                                          : Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Switch(
                              value: isEnabled,
                              onChanged: (val) {
                                repo.toggleScheduleEnabled(schedule.id, val);
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Divider(height: 1),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Wrap(
                              spacing: 6,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.primary.withAlpha(20),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    _getTypeLabel(schedule.alertType, lang),
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: theme.colorScheme.primary,
                                    ),
                                  ),
                                ),
                                if (medicine != null && medicine.foodRelation != 'none')
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: Colors.amber.withAlpha(30),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      medicine.foodRelation == 'before'
                                          ? 'முன் (Before)'
                                          : (medicine.foodRelation == 'after' ? 'பின் (After)' : 'உடன் (With)'),
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.amber,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(Icons.repeat, size: 14, color: Colors.grey[600]),
                                const SizedBox(width: 4),
                                Text(
                                  _formatDays(schedule.daysMask, lang),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error loading alerts: $err')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/add-alert'),
        icon: const Icon(Icons.add),
        label: const Text('Add Alert'),
      ),
    );
  }
}
