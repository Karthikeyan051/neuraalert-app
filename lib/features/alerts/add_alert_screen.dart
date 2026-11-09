import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:neuraalert/features/alerts/reminders_repository.dart';
import 'package:neuraalert/services/scheduler_service.dart';
import 'package:neuraalert/services/voice_service.dart';

class AddAlertScreen extends ConsumerStatefulWidget {
  final ScheduleWithMedicine? existing;

  const AddAlertScreen({super.key, this.existing});

  @override
  ConsumerState<AddAlertScreen> createState() => _AddAlertScreenState();
}

class _AddAlertScreenState extends ConsumerState<AddAlertScreen> {
  final _formKey = GlobalKey<FormState>();
  final _labelController = TextEditingController();
  final _doseNoteController = TextEditingController();

  String _alertType = 'medicine'; // medicine, meeting, alarm, custom
  String _foodRelation = 'none'; // none, before, after, with
  String _voiceLang = 'ta'; // ta, en
  int _timeMinutes = 8 * 60; // Default 08:00 AM
  int _daysMask = 127; // Every day

  bool _isSaving = false;
  bool _isPlayingPreview = false;
  final VoiceService _voiceService = VoiceService();

  final List<String> _dayNames = ['திங்கள்', 'செவ்வாய்', 'புதன்', 'வியாழன்', 'வெள்ளி', 'சனி', 'ஞாயிறு'];
  final List<String> _dayNamesEn = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  @override
  void initState() {
    super.initState();
    if (widget.existing != null) {
      final s = widget.existing!.schedule;
      final m = widget.existing!.medicine;
      _labelController.text = s.label;
      _alertType = s.alertType;
      _timeMinutes = s.timeMinutes;
      _daysMask = s.daysMask;
      _voiceLang = s.voiceLang;
      if (m != null) {
        _doseNoteController.text = m.doseNote;
        _foodRelation = m.foodRelation;
      }
    }
  }

  @override
  void dispose() {
    _labelController.dispose();
    _doseNoteController.dispose();
    super.dispose();
  }

  String _formatTime(int minutes) {
    final hour = minutes ~/ 60;
    final min = minutes % 60;
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    final minStr = min.toString().padLeft(2, '0');
    final tamilPeriod = hour >= 12 ? (hour >= 18 ? 'இரவு' : 'மதியம்') : 'காலை';
    return _voiceLang == 'ta'
        ? '$tamilPeriod $displayHour:$minStr $period'
        : '$displayHour:$minStr $period';
  }

  Future<void> _pickTime() async {
    final currentHour = _timeMinutes ~/ 60;
    final currentMinute = _timeMinutes % 60;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: currentHour, minute: currentMinute),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child!,
        );
      },
    );

    if (time != null) {
      setState(() {
        _timeMinutes = time.hour * 60 + time.minute;
      });
    }
  }

  Future<void> _playVoicePreview() async {
    if (_labelController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_voiceLang == 'ta'
              ? 'முதலில் பெயரை உள்ளிடவும்'
              : 'Please enter a name first'),
        ),
      );
      return;
    }

    setState(() => _isPlayingPreview = true);

    final phrase = SchedulerService.buildSpokenPhrase(
      alertType: _alertType,
      label: _labelController.text.trim(),
      voiceLang: _voiceLang,
      doseNote: _doseNoteController.text.trim(),
      foodRelation: _foodRelation,
    );

    await _voiceService.speakText(phrase, _voiceLang);

    if (mounted) {
      setState(() => _isPlayingPreview = false);
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    final repo = ref.read(remindersRepositoryProvider);

    try {
      if (widget.existing == null) {
        await repo.createSchedule(
          alertType: _alertType,
          label: _labelController.text.trim(),
          timeMinutes: _timeMinutes,
          daysMask: _daysMask,
          doseNote: _doseNoteController.text.trim(),
          foodRelation: _foodRelation,
          voiceLang: _voiceLang,
        );
      } else {
        await repo.updateSchedule(
          scheduleId: widget.existing!.schedule.id,
          alertType: _alertType,
          label: _labelController.text.trim(),
          timeMinutes: _timeMinutes,
          daysMask: _daysMask,
          doseNote: _doseNoteController.text.trim(),
          foodRelation: _foodRelation,
          voiceLang: _voiceLang,
        );
      }

      if (mounted) {
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving reminder: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isTamil = _voiceLang == 'ta';

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existing == null
            ? (isTamil ? 'புதிய நினைவூட்டல்' : 'New Alert')
            : (isTamil ? 'நினைவூட்டலை மாற்று' : 'Edit Alert')),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              // ── Type Selector ──────────────────────────────────────
              Text(
                isTamil ? 'வகை / Alert Type' : 'Alert Type',
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildTypeChip('medicine', 'மருந்து', 'Medicine', Icons.medication),
                    const SizedBox(width: 8),
                    _buildTypeChip('meeting', 'சந்திப்பு', 'Meeting', Icons.event),
                    const SizedBox(width: 8),
                    _buildTypeChip('alarm', 'அலாரம்', 'Alarm', Icons.alarm),
                    const SizedBox(width: 8),
                    _buildTypeChip('custom', 'விருப்பம்', 'Custom', Icons.notifications_active),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ── Name Field ─────────────────────────────────────────
              Text(
                _alertType == 'medicine'
                    ? (isTamil ? 'மருந்தின் பெயர் *' : 'Medicine Name *')
                    : (isTamil ? 'தலைப்பு / பெயர் *' : 'Title / Name *'),
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _labelController,
                decoration: InputDecoration(
                  hintText: _alertType == 'medicine'
                      ? (isTamil ? 'எ.கா: Paracetamol 500mg' : 'e.g. Paracetamol 500mg')
                      : (isTamil ? 'எ.கா: மருத்துவ சந்திப்பு' : 'e.g. Doctor appointment'),
                  prefixIcon: const Icon(Icons.edit_note),
                ),
                style: const TextStyle(fontSize: 18),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return isTamil ? 'பெயரை உள்ளிடவும்' : 'Please enter a name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // ── Medicine-Specific Fields ────────────────────────────
              if (_alertType == 'medicine') ...[
                Text(
                  isTamil ? 'அளவு குறிப்பு (விருப்பம்)' : 'Dose Note (Optional)',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _doseNoteController,
                  decoration: InputDecoration(
                    hintText: isTamil ? 'எ.கா: 1 மாத்திரை / 10ml' : 'e.g. 1 tablet / 10ml',
                    prefixIcon: const Icon(Icons.numbers),
                  ),
                ),
                const SizedBox(height: 20),

                Text(
                  isTamil ? 'உணவு தொடர்பு' : 'Food Relation',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildFoodChip('none', isTamil ? 'குறிப்பில்லை' : 'None'),
                    _buildFoodChip('before', isTamil ? 'உணவுக்கு முன்' : 'Before food'),
                    _buildFoodChip('after', isTamil ? 'உணவுக்குப் பின்' : 'After food'),
                    _buildFoodChip('with', isTamil ? 'உணவுடன்' : 'With food'),
                  ],
                ),
                const SizedBox(height: 24),
              ],

              // ── Time Section ───────────────────────────────────────
              Text(
                isTamil ? 'நேரம் / Time' : 'Time',
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: _pickTime,
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withAlpha(20),
                    border: Border.all(color: theme.colorScheme.primary, width: 1.5),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.access_time_filled, color: theme.colorScheme.primary, size: 28),
                          const SizedBox(width: 14),
                          Text(
                            _formatTime(_timeMinutes),
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        isTamil ? 'மாற்று' : 'Change',
                        style: TextStyle(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Presets
              Row(
                children: [
                  _buildPresetButton(8 * 60, isTamil ? 'காலை 8:00' : 'Morning 8:00'),
                  const SizedBox(width: 8),
                  _buildPresetButton(13 * 60, isTamil ? 'மதியம் 1:00' : 'Noon 1:00'),
                  const SizedBox(width: 8),
                  _buildPresetButton(20 * 60, isTamil ? 'இரவு 8:00' : 'Night 8:00'),
                ],
              ),
              const SizedBox(height: 24),

              // ── Days of Week ───────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isTamil ? 'நினைவூட்டும் நாட்கள்' : 'Repeat Days',
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _daysMask = _daysMask == 127 ? 0 : 127;
                      });
                    },
                    child: Text(_daysMask == 127
                        ? (isTamil ? 'அனைத்தும் நீக்கு' : 'Clear all')
                        : (isTamil ? 'தினமும்' : 'Every day')),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(7, (index) {
                  final bit = 1 << index;
                  final isSelected = (_daysMask & bit) != 0;
                  final dayLabel = isTamil ? _dayNames[index].substring(0, 1) : _dayNamesEn[index].substring(0, 1);
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          _daysMask &= ~bit;
                        } else {
                          _daysMask |= bit;
                        }
                      });
                    },
                    child: Container(
                      width: 44,
                      height: 44,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isSelected ? theme.colorScheme.primary : theme.cardColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? theme.colorScheme.primary : Colors.grey.withAlpha(60),
                        ),
                      ),
                      child: Text(
                        dayLabel,
                        style: TextStyle(
                          color: isSelected ? Colors.white : theme.textTheme.bodyMedium?.color,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 24),

              // ── Voice Language ─────────────────────────────────────
              Text(
                isTamil ? 'குரல் மொழி / Voice Language' : 'Voice Language',
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: ChoiceChip(
                      label: const Center(child: Text('தமிழ் (Tamil)', style: TextStyle(fontSize: 16))),
                      selected: _voiceLang == 'ta',
                      onSelected: (val) {
                        if (val) setState(() => _voiceLang = 'ta');
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ChoiceChip(
                      label: const Center(child: Text('English', style: TextStyle(fontSize: 16))),
                      selected: _voiceLang == 'en',
                      onSelected: (val) {
                        if (val) setState(() => _voiceLang = 'en');
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // ── Voice Preview Button ───────────────────────────────
              OutlinedButton.icon(
                onPressed: _isPlayingPreview ? null : _playVoicePreview,
                icon: _isPlayingPreview
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.volume_up_rounded),
                label: Text(
                  _isPlayingPreview
                      ? (isTamil ? 'ஒலிக்கிறது...' : 'Playing...')
                      : (isTamil ? 'குரல் மாதிரி கேட்க (Preview)' : 'Preview Voice'),
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
              ),
              const SizedBox(height: 32),

              // ── Save Button ────────────────────────────────────────
              FilledButton(
                onPressed: _isSaving ? null : _save,
                child: _isSaving
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                        isTamil ? 'சேமி (Save)' : 'Save Alert',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeChip(String type, String labelTa, String labelEn, IconData icon) {
    final isSelected = _alertType == type;
    final theme = Theme.of(context);
    final isTamil = _voiceLang == 'ta';

    return FilterChip(
      selected: isSelected,
      avatar: Icon(icon, size: 18, color: isSelected ? Colors.white : theme.colorScheme.primary),
      label: Text(isTamil ? labelTa : labelEn),
      onSelected: (val) {
        if (val) setState(() => _alertType = type);
      },
    );
  }

  Widget _buildFoodChip(String relation, String label) {
    final isSelected = _foodRelation == relation;
    return ChoiceChip(
      selected: isSelected,
      label: Text(label),
      onSelected: (val) {
        if (val) setState(() => _foodRelation = relation);
      },
    );
  }

  Widget _buildPresetButton(int minutes, String label) {
    final isSelected = _timeMinutes == minutes;
    return Expanded(
      child: OutlinedButton(
        onPressed: () => setState(() => _timeMinutes = minutes),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 8),
          side: BorderSide(
            color: isSelected ? Theme.of(context).colorScheme.primary : Colors.grey.withAlpha(80),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
