import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:neuraalert/app/app_theme.dart';
import 'package:neuraalert/features/alerts/reminders_repository.dart';
import 'package:neuraalert/features/settings/app_settings_provider.dart';
import 'package:neuraalert/services/scheduler_service.dart';
import 'package:neuraalert/services/voice_service.dart';

class AddAlertScreen extends ConsumerStatefulWidget {
  final ScheduleWithMedicine? existing;
  const AddAlertScreen({super.key, this.existing});

  @override
  ConsumerState<AddAlertScreen> createState() => _AddAlertScreenState();
}

class _AddAlertScreenState extends ConsumerState<AddAlertScreen> {
  final _labelController = TextEditingController();
  final _doseNoteController = TextEditingController();
  final PageController _pageController = PageController();
  int _currentStep = 0;

  String _alertType = 'medicine';
  String _foodRelation = 'none';
  late String _voiceLang;
  int _timeHour = 8; // 1..12
  int _timeMinute = 0; // 0..59
  bool _isAm = true;
  int _daysMask = 127;

  bool _isSaving = false;
  bool _isPlayingPreview = false;
  final VoiceService _voiceService = VoiceService();

  late final FixedExtentScrollController _hourCtrl;
  late final FixedExtentScrollController _minuteCtrl;
  late final FixedExtentScrollController _amPmCtrl;

  static const _dayNamesTa = [
    'திங்',
    'செவ்',
    'புத',
    'வியா',
    'வெள்',
    'சனி',
    'ஞாயி',
  ];
  static const _dayNamesEn = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ];

  @override
  void initState() {
    super.initState();
    _voiceLang = ref.read(appSettingsProvider).language;
    if (widget.existing != null) {
      final s = widget.existing!.schedule;
      final m = widget.existing!.medicine;
      _labelController.text = s.label;
      _alertType = s.alertType;
      final totalMins = s.timeMinutes;
      final hour24 = totalMins ~/ 60;
      _timeMinute = totalMins % 60;
      _isAm = hour24 < 12;
      _timeHour = hour24 == 0 ? 12 : (hour24 > 12 ? hour24 - 12 : hour24);
      _daysMask = s.daysMask;
      _voiceLang = s.voiceLang;
      if (m != null) {
        _doseNoteController.text = m.doseNote;
        _foodRelation = m.foodRelation;
      }
    }
    _hourCtrl = FixedExtentScrollController(initialItem: _timeHour - 1);
    _minuteCtrl = FixedExtentScrollController(initialItem: _timeMinute);
    _amPmCtrl = FixedExtentScrollController(initialItem: _isAm ? 0 : 1);
  }

  @override
  void dispose() {
    _labelController.dispose();
    _doseNoteController.dispose();
    _pageController.dispose();
    _hourCtrl.dispose();
    _minuteCtrl.dispose();
    _amPmCtrl.dispose();
    super.dispose();
  }

  int get _timeMinutes {
    int hour24 = _timeHour % 12;
    if (!_isAm) hour24 += 12;
    return hour24 * 60 + _timeMinute;
  }

  String get _formattedTime {
    final minStr = _timeMinute.toString().padLeft(2, '0');
    final period = _isAm ? 'AM' : 'PM';
    return '$_timeHour:$minStr $period';
  }

  String _tamilPeriodHelper() {
    final total = _timeMinutes;
    final h = total ~/ 60;
    if (h < 12) return 'காலை (Morning)';
    if (h < 16) return 'மதியம் (Afternoon)';
    if (h < 19) return 'மாலை (Evening)';
    return 'இரவு (Night)';
  }

  void _goToPage(int page) {
    FocusScope.of(context).unfocus();
    HapticFeedback.selectionClick();
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
    );
    setState(() => _currentStep = page);
  }

  bool _validateStep1(bool uiIsTa) {
    if (_labelController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              uiIsTa ? 'பெயரை உள்ளிடவும்' : 'Please enter a name'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return false;
    }
    return true;
  }

  Future<void> _playVoicePreview(bool uiIsTa) async {
    if (_labelController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(uiIsTa
              ? 'முதலில் பெயரை உள்ளிடவும்'
              : 'Please enter a name first'),
          behavior: SnackBarBehavior.floating,
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
    if (mounted) setState(() => _isPlayingPreview = false);
  }

  Future<void> _save(bool uiIsTa) async {
    if (!_validateStep1(uiIsTa)) {
      _goToPage(0);
      return;
    }
    if (_daysMask == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(uiIsTa
              ? 'குறைந்தது ஒரு நாளையாவது தேர்ந்தெடுக்கவும்'
              : 'Please select at least one day'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

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
      if (mounted) context.pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _deleteExisting(bool uiIsTa) async {
    final existing = widget.existing;
    if (existing == null) return;
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
    if (confirmed == true) {
      await ref
          .read(remindersRepositoryProvider)
          .deleteSchedule(existing.schedule.id);
      if (mounted) context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final uiIsTa = ref.watch(appSettingsProvider).isTamil;
    final isEdit = widget.existing != null;
    final stepTitles = uiIsTa
        ? ['பெயர் & வகை', 'நேரம் தேர்வு', 'நாட்கள் & குரல்']
        : ['Name & Type', 'Set Time', 'Days & Voice'];

    return Scaffold(
      backgroundColor: AppTheme.bg(context),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          tooltip: uiIsTa ? 'மூடு' : 'Close',
          onPressed: () => context.pop(),
        ),
        title: Text(
          isEdit
              ? (uiIsTa ? 'நினைவூட்டல் மாற்று' : 'Edit Reminder')
              : (uiIsTa ? 'புதிய நினைவூட்டல்' : 'New Reminder'),
        ),
        actions: [
          if (isEdit)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: TextButton.icon(
                onPressed: _isSaving ? null : () => _deleteExisting(uiIsTa),
                icon: const Icon(Icons.delete_outline_rounded,
                    color: AppTheme.error, size: 20),
                label: Text(
                  uiIsTa ? 'நீக்கு' : 'Delete',
                  style: const TextStyle(color: AppTheme.error),
                ),
              ),
            ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(54),
          child: _StepIndicator(
            currentStep: _currentStep,
            stepLabel: uiIsTa
                ? 'படி ${_currentStep + 1} / 3 · ${stepTitles[_currentStep]}'
                : 'Step ${_currentStep + 1} of 3 · ${stepTitles[_currentStep]}',
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          onPageChanged: (i) => setState(() => _currentStep = i),
          children: [
            _StepOne(
              labelController: _labelController,
              doseNoteController: _doseNoteController,
              alertType: _alertType,
              foodRelation: _foodRelation,
              isTamil: uiIsTa,
              onTypeChanged: (t) => setState(() => _alertType = t),
              onFoodChanged: (f) => setState(() => _foodRelation = f),
              onNext: () {
                if (_validateStep1(uiIsTa)) _goToPage(1);
              },
            ),
            _StepTwo(
              hourCtrl: _hourCtrl,
              minuteCtrl: _minuteCtrl,
              amPmCtrl: _amPmCtrl,
              timeHour: _timeHour,
              timeMinute: _timeMinute,
              isAm: _isAm,
              formattedTime: _formattedTime,
              periodHelper: _tamilPeriodHelper(),
              isTamil: uiIsTa,
              onHourChanged: (h) => setState(() => _timeHour = h + 1),
              onMinuteChanged: (m) => setState(() => _timeMinute = m),
              onAmPmChanged: (i) => setState(() => _isAm = i == 0),
              onPreset: (h, m, am) {
                setState(() {
                  _timeHour = h;
                  _timeMinute = m;
                  _isAm = am;
                });
                _hourCtrl.animateToItem(h - 1,
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOut);
                _minuteCtrl.animateToItem(m,
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOut);
                _amPmCtrl.animateToItem(am ? 0 : 1,
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOut);
              },
              onBack: () => _goToPage(0),
              onNext: () => _goToPage(2),
            ),
            _StepThree(
              daysMask: _daysMask,
              voiceLang: _voiceLang,
              uiIsTa: uiIsTa,
              dayNamesTa: _dayNamesTa,
              dayNamesEn: _dayNamesEn,
              isPlayingPreview: _isPlayingPreview,
              isSaving: _isSaving,
              onDayToggle: (bit) =>
                  setState(() => _daysMask = _daysMask ^ bit),
              onEveryDay: () => setState(() => _daysMask = 127),
              onClearDays: () => setState(() => _daysMask = 0),
              onLangChanged: (lang) => setState(() => _voiceLang = lang),
              onPreview: () => _playVoicePreview(uiIsTa),
              onBack: () => _goToPage(1),
              onSave: () => _save(uiIsTa),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Step Indicator ───────────────────────────────────────────────────────────

class _StepIndicator extends StatelessWidget {
  final int currentStep;
  final String stepLabel;

  const _StepIndicator({
    required this.currentStep,
    required this.stepLabel,
  });

  @override
  Widget build(BuildContext context) {
    final primary = AppTheme.primaryOf(context);
    final divider = AppTheme.divider(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 4, 24, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            stepLabel,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppTheme.textSub(context),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: List.generate(3, (i) {
              final isActive = i <= currentStep;
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: i < 2 ? 8 : 0),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    height: 4,
                    decoration: BoxDecoration(
                      color: isActive ? primary : divider,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

// ── Step 1: Name & Type ──────────────────────────────────────────────────────

class _StepOne extends StatelessWidget {
  final TextEditingController labelController;
  final TextEditingController doseNoteController;
  final String alertType;
  final String foodRelation;
  final bool isTamil;
  final ValueChanged<String> onTypeChanged;
  final ValueChanged<String> onFoodChanged;
  final VoidCallback onNext;

  const _StepOne({
    required this.labelController,
    required this.doseNoteController,
    required this.alertType,
    required this.foodRelation,
    required this.isTamil,
    required this.onTypeChanged,
    required this.onFoodChanged,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionLabel(
              isTamil ? 'வகை தேர்வு' : 'What kind of reminder?'),
          const SizedBox(height: 12),
          _TypeGrid(
            selectedType: alertType,
            isTamil: isTamil,
            onChanged: onTypeChanged,
          ),
          const SizedBox(height: 28),
          _SectionLabel(
            alertType == 'medicine'
                ? (isTamil ? 'மருந்தின் பெயர் *' : 'Medicine Name *')
                : (isTamil ? 'தலைப்பு *' : 'Reminder Title *'),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: labelController,
            textInputAction: TextInputAction.next,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: AppTheme.text(context),
            ),
            decoration: InputDecoration(
              hintText: alertType == 'medicine'
                  ? (isTamil ? 'எ.கா: Paracetamol 500mg' : 'e.g. Paracetamol 500mg')
                  : (isTamil ? 'எ.கா: மருத்துவ சந்திப்பு' : 'e.g. Doctor appointment'),
              prefixIcon: const Icon(Icons.edit_rounded),
            ),
          ),
          if (alertType == 'medicine') ...[
            const SizedBox(height: 28),
            _SectionLabel(
                isTamil ? 'அளவு குறிப்பு (விருப்பம்)' : 'Dose Note (Optional)'),
            const SizedBox(height: 10),
            TextField(
              controller: doseNoteController,
              style: TextStyle(
                fontSize: 18,
                color: AppTheme.text(context),
              ),
              decoration: InputDecoration(
                hintText:
                    isTamil ? 'எ.கா: 1 மாத்திரை / 10ml' : 'e.g. 1 tablet / 10ml',
                prefixIcon: const Icon(Icons.medication_liquid_rounded),
              ),
            ),
            const SizedBox(height: 28),
            _SectionLabel(isTamil ? 'உணவு தொடர்பு' : 'Food Timing'),
            const SizedBox(height: 12),
            _FoodChips(
              selected: foodRelation,
              isTamil: isTamil,
              onChanged: onFoodChanged,
            ),
          ],
          const SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: onNext,
              icon: const Icon(Icons.arrow_forward_rounded),
              label: Text(isTamil ? 'நேரம் தேர்வு செய்க' : 'Continue to Time'),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Step 2: Time ─────────────────────────────────────────────────────────────

class _StepTwo extends StatelessWidget {
  final FixedExtentScrollController hourCtrl;
  final FixedExtentScrollController minuteCtrl;
  final FixedExtentScrollController amPmCtrl;
  final int timeHour;
  final int timeMinute;
  final bool isAm;
  final String formattedTime;
  final String periodHelper;
  final bool isTamil;
  final ValueChanged<int> onHourChanged;
  final ValueChanged<int> onMinuteChanged;
  final ValueChanged<int> onAmPmChanged;
  final Function(int h, int m, bool am) onPreset;
  final VoidCallback onBack;
  final VoidCallback onNext;

  const _StepTwo({
    required this.hourCtrl,
    required this.minuteCtrl,
    required this.amPmCtrl,
    required this.timeHour,
    required this.timeMinute,
    required this.isAm,
    required this.formattedTime,
    required this.periodHelper,
    required this.isTamil,
    required this.onHourChanged,
    required this.onMinuteChanged,
    required this.onAmPmChanged,
    required this.onPreset,
    required this.onBack,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final primary = AppTheme.primaryOf(context);
    final divider = AppTheme.divider(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Column(
              children: [
                Text(
                  formattedTime,
                  style: TextStyle(
                    fontSize: 44,
                    fontWeight: FontWeight.w700,
                    color: primary,
                    letterSpacing: -1,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  periodHelper,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.textSub(context),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Drum picker card with highlighted selection bar
          Container(
            decoration: BoxDecoration(
              color: AppTheme.surface(context),
              borderRadius: BorderRadius.circular(AppTheme.radiusLG),
              border: Border.all(color: divider),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Center highlight band
                Positioned(
                  left: 12,
                  right: 12,
                  top: 84,
                  height: 48,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppTheme.chipBg(context),
                      borderRadius: BorderRadius.circular(AppTheme.radiusMD),
                      border: Border.all(
                        color: primary.withValues(alpha: 0.35),
                        width: 1,
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: _DrumPicker(
                        controller: hourCtrl,
                        selectedIndex: timeHour - 1,
                        items: List.generate(12, (i) => '${i + 1}'),
                        onChanged: onHourChanged,
                        label: isTamil ? 'மணி' : 'Hour',
                      ),
                    ),
                    Container(width: 1, height: 180, color: divider),
                    Expanded(
                      child: _DrumPicker(
                        controller: minuteCtrl,
                        selectedIndex: timeMinute,
                        items: List.generate(
                            60, (i) => i.toString().padLeft(2, '0')),
                        onChanged: onMinuteChanged,
                        label: isTamil ? 'நிமிடம்' : 'Minute',
                      ),
                    ),
                    Container(width: 1, height: 180, color: divider),
                    Expanded(
                      child: _DrumPicker(
                        controller: amPmCtrl,
                        selectedIndex: isAm ? 0 : 1,
                        items: const ['AM', 'PM'],
                        onChanged: onAmPmChanged,
                        label: isTamil ? 'வேளை' : 'AM/PM',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),
          _SectionLabel(isTamil ? 'விரைவு நேரங்கள்' : 'Quick Presets'),
          const SizedBox(height: 12),
          Row(
            children: [
              _PresetBtn(
                label: isTamil ? 'காலை 8:00' : '8:00 AM',
                selected: timeHour == 8 && timeMinute == 0 && isAm,
                onTap: () => onPreset(8, 0, true),
              ),
              const SizedBox(width: 8),
              _PresetBtn(
                label: isTamil ? 'மதியம் 1:00' : '1:00 PM',
                selected: timeHour == 1 && timeMinute == 0 && !isAm,
                onTap: () => onPreset(1, 0, false),
              ),
              const SizedBox(width: 8),
              _PresetBtn(
                label: isTamil ? 'இரவு 8:00' : '8:00 PM',
                selected: timeHour == 8 && timeMinute == 0 && !isAm,
                onTap: () => onPreset(8, 0, false),
              ),
            ],
          ),

          const SizedBox(height: 40),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onBack,
                  child: Text(isTamil ? '← பின்' : '← Back'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: FilledButton(
                  onPressed: onNext,
                  child: Text(isTamil ? 'தொடர்க →' : 'Continue →'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Step 3: Days & Voice ─────────────────────────────────────────────────────

class _StepThree extends StatelessWidget {
  final int daysMask;
  final String voiceLang;
  final bool uiIsTa;
  final List<String> dayNamesTa;
  final List<String> dayNamesEn;
  final bool isPlayingPreview;
  final bool isSaving;
  final ValueChanged<int> onDayToggle;
  final VoidCallback onEveryDay;
  final VoidCallback onClearDays;
  final ValueChanged<String> onLangChanged;
  final VoidCallback onPreview;
  final VoidCallback onBack;
  final VoidCallback onSave;

  const _StepThree({
    required this.daysMask,
    required this.voiceLang,
    required this.uiIsTa,
    required this.dayNamesTa,
    required this.dayNamesEn,
    required this.isPlayingPreview,
    required this.isSaving,
    required this.onDayToggle,
    required this.onEveryDay,
    required this.onClearDays,
    required this.onLangChanged,
    required this.onPreview,
    required this.onBack,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final dayNames = uiIsTa ? dayNamesTa : dayNamesEn;
    final isEveryDay = daysMask == 127;
    final primary = AppTheme.primaryOf(context);
    final divider = AppTheme.divider(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _SectionLabel(
                  uiIsTa ? 'திரும்பும் நாட்கள்' : 'Repeat Days'),
              TextButton(
                onPressed: isEveryDay ? onClearDays : onEveryDay,
                child: Text(isEveryDay
                    ? (uiIsTa ? 'அனைத்தும் நீக்கு' : 'Clear all')
                    : (uiIsTa ? 'தினமும்' : 'Every day')),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Day selector pills
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List.generate(7, (index) {
              final bit = 1 << index;
              final isSelected = (daysMask & bit) != 0;
              return GestureDetector(
                onTap: () {
                  HapticFeedback.selectionClick();
                  onDayToggle(bit);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 160),
                  width: 48,
                  height: 52,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected ? primary : AppTheme.card(context),
                    borderRadius: BorderRadius.circular(AppTheme.radiusMD),
                    border: Border.all(
                      color: isSelected ? primary : divider,
                      width: isSelected ? 1.5 : 1,
                    ),
                  ),
                  child: Text(
                    dayNames[index],
                    style: TextStyle(
                      color: isSelected
                          ? (AppTheme.isDark(context)
                              ? AppTheme.darkBg
                              : Colors.white)
                          : AppTheme.textSub(context),
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
              );
            }),
          ),

          const SizedBox(height: 32),
          _SectionLabel(
              uiIsTa ? 'குரல் மொழி' : 'Spoken Alert Language'),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _LangChip(
                  label: 'தமிழ்',
                  selected: voiceLang == 'ta',
                  onTap: () => onLangChanged('ta'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _LangChip(
                  label: 'English',
                  selected: voiceLang == 'en',
                  onTap: () => onLangChanged('en'),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: isPlayingPreview ? null : onPreview,
              icon: isPlayingPreview
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.volume_up_rounded),
              label: Text(
                isPlayingPreview
                    ? (uiIsTa ? 'ஒலிக்கிறது...' : 'Playing voice...')
                    : (uiIsTa ? 'குரல் மாதிரி கேள்' : 'Preview Voice'),
              ),
            ),
          ),

          const SizedBox(height: 40),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onBack,
                  child: Text(uiIsTa ? '← பின்' : '← Back'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: FilledButton.icon(
                  onPressed: isSaving ? null : onSave,
                  icon: isSaving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2.5),
                        )
                      : const Icon(Icons.check_rounded),
                  label: Text(uiIsTa ? 'சேமி' : 'Save Reminder'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Shared Widgets ───────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: AppTheme.textSub(context),
        letterSpacing: 0.1,
      ),
    );
  }
}

class _TypeGrid extends StatelessWidget {
  final String selectedType;
  final bool isTamil;
  final ValueChanged<String> onChanged;

  const _TypeGrid({
    required this.selectedType,
    required this.isTamil,
    required this.onChanged,
  });

  static const _types = [
    (
      type: 'medicine',
      iconData: Icons.medication_rounded,
      labelTa: 'மருந்து',
      labelEn: 'Medicine'
    ),
    (
      type: 'meeting',
      iconData: Icons.event_rounded,
      labelTa: 'சந்திப்பு',
      labelEn: 'Meeting'
    ),
    (
      type: 'alarm',
      iconData: Icons.alarm_rounded,
      labelTa: 'அலாரம்',
      labelEn: 'Alarm'
    ),
    (
      type: 'custom',
      iconData: Icons.notifications_active_rounded,
      labelTa: 'மற்றவை',
      labelEn: 'Custom'
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final primary = AppTheme.primaryOf(context);
    final divider = AppTheme.divider(context);

    Widget buildCard(({String type, IconData iconData, String labelTa, String labelEn}) t) {
      final isSelected = t.type == selectedType;
      final label = isTamil ? t.labelTa : t.labelEn;
      return Expanded(
        child: GestureDetector(
          onTap: () {
            HapticFeedback.selectionClick();
            onChanged(t.type);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            constraints: const BoxConstraints(minHeight: AppTheme.touchTarget),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            decoration: BoxDecoration(
              color:
                  isSelected ? AppTheme.chipBg(context) : AppTheme.card(context),
              borderRadius: BorderRadius.circular(AppTheme.radiusMD),
              border: Border.all(
                color: isSelected ? primary : divider,
                width: isSelected ? 1.5 : 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  t.iconData,
                  color: isSelected ? primary : AppTheme.textSub(context),
                  size: 22,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? primary : AppTheme.text(context),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Column(
      children: [
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              buildCard(_types[0]),
              const SizedBox(width: 10),
              buildCard(_types[1]),
            ],
          ),
        ),
        const SizedBox(height: 10),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              buildCard(_types[2]),
              const SizedBox(width: 10),
              buildCard(_types[3]),
            ],
          ),
        ),
      ],
    );
  }
}

class _FoodChips extends StatelessWidget {
  final String selected;
  final bool isTamil;
  final ValueChanged<String> onChanged;

  const _FoodChips({
    required this.selected,
    required this.isTamil,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final primary = AppTheme.primaryOf(context);
    final divider = AppTheme.divider(context);

    final options = [
      (value: 'none', labelTa: 'குறிப்பில்லை', labelEn: 'No rule'),
      (value: 'before', labelTa: 'உணவுக்கு முன்', labelEn: 'Before food'),
      (value: 'after', labelTa: 'உணவுக்குப் பின்', labelEn: 'After food'),
      (value: 'with', labelTa: 'உணவுடன்', labelEn: 'With food'),
    ];

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: options.map((opt) {
        final isSelected = opt.value == selected;
        final label = isTamil ? opt.labelTa : opt.labelEn;
        return GestureDetector(
          onTap: () {
            HapticFeedback.selectionClick();
            onChanged(opt.value);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color:
                  isSelected ? AppTheme.chipBg(context) : AppTheme.card(context),
              borderRadius: BorderRadius.circular(AppTheme.radiusMD),
              border: Border.all(
                color: isSelected ? primary : divider,
                width: isSelected ? 1.5 : 1,
              ),
            ),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? primary : AppTheme.text(context),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _DrumPicker extends StatelessWidget {
  final FixedExtentScrollController controller;
  final int selectedIndex;
  final List<String> items;
  final ValueChanged<int> onChanged;
  final String label;

  const _DrumPicker({
    required this.controller,
    required this.selectedIndex,
    required this.items,
    required this.onChanged,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final primary = AppTheme.primaryOf(context);
    final textNormal = AppTheme.textSub(context).withValues(alpha: 0.55);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 2),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: AppTheme.textSub(context),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(
          height: 168,
          child: ListWheelScrollView.useDelegate(
            controller: controller,
            itemExtent: 48,
            perspective: 0.003,
            diameterRatio: 1.6,
            physics: const FixedExtentScrollPhysics(),
            onSelectedItemChanged: (idx) {
              HapticFeedback.selectionClick();
              onChanged(idx);
            },
            childDelegate: ListWheelChildBuilderDelegate(
              childCount: items.length,
              builder: (context, index) {
                final isSelected = index == selectedIndex;
                return Center(
                  child: Text(
                    items[index],
                    style: TextStyle(
                      fontSize: isSelected ? 24 : 18,
                      fontWeight:
                          isSelected ? FontWeight.w700 : FontWeight.w400,
                      color: isSelected ? primary : textNormal,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _PresetBtn extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _PresetBtn({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final primary = AppTheme.primaryOf(context);
    return Expanded(
      child: OutlinedButton(
        onPressed: () {
          HapticFeedback.selectionClick();
          onTap();
        },
        style: OutlinedButton.styleFrom(
          backgroundColor:
              selected ? AppTheme.chipBg(context) : Colors.transparent,
          side: BorderSide(
            color: selected ? primary : AppTheme.divider(context),
            width: selected ? 1.5 : 1,
          ),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
          minimumSize: const Size(0, 48),
          textStyle:
              const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}

class _LangChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _LangChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final primary = AppTheme.primaryOf(context);
    final divider = AppTheme.divider(context);

    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        constraints: const BoxConstraints(minHeight: AppTheme.touchTarget),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AppTheme.chipBg(context) : AppTheme.card(context),
          borderRadius: BorderRadius.circular(AppTheme.radiusMD),
          border: Border.all(
            color: selected ? primary : divider,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: selected ? primary : AppTheme.text(context),
          ),
        ),
      ),
    );
  }
}
