import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:neuraalert/app/app_theme.dart';
import 'package:neuraalert/features/settings/app_settings_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(appSettingsProvider);
    final notifier = ref.read(appSettingsProvider.notifier);
    final isTa = settings.isTamil;

    return Scaffold(
      backgroundColor: AppTheme.bg(context),
      appBar: AppBar(
        titleSpacing: 24,
        title: Text(isTa ? 'அமைப்புகள்' : 'Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 128),
        children: [
          // ── Display ──────────────────────────────────────────────────
          _SectionHeader(isTa ? 'காட்சி · DISPLAY' : 'DISPLAY'),
          _SettingsGroup(
            children: [
              _SettingsRow(
                icon: Icons.language_rounded,
                label: isTa ? 'மொழி' : 'Language',
                valueText: isTa ? 'தமிழ்' : 'English',
                onTap: () => _pickLanguage(context, notifier, isTa),
              ),
              const _RowDivider(),
              _SettingsRow(
                icon: Icons.text_fields_rounded,
                label: isTa ? 'எழுத்து அளவு' : 'Text Size',
                valueText: _fontScaleLabel(settings.fontScale, isTa),
                onTap: () => _pickFontScale(context, notifier, settings.fontScale, isTa),
              ),
              const _RowDivider(),
              _SettingsRow(
                icon: Icons.brightness_6_outlined,
                label: isTa ? 'தோற்றம்' : 'Appearance',
                valueText: _themeLabel(settings.themeMode, isTa),
                onTap: () => _pickThemeMode(context, notifier, settings.themeMode, isTa),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // ── Alerts ───────────────────────────────────────────────────
          _SectionHeader(isTa ? 'அலாரம் · ALERTS' : 'ALERTS'),
          _SettingsGroup(
            children: [
              _SettingsRow(
                icon: Icons.snooze_rounded,
                label: isTa ? 'தள்ளிப்போடு நேரம்' : 'Snooze Duration',
                valueText: isTa
                    ? '${settings.snoozeMinutes} நிமிடம்'
                    : '${settings.snoozeMinutes} min',
                onTap: () => _pickSnooze(
                    context, notifier, settings.snoozeMinutes, isTa),
              ),
              const _RowDivider(),
              _SettingsRow(
                icon: Icons.timer_outlined,
                label: isTa ? 'ஒலிக்கும் நேரம்' : 'Ring Duration',
                valueText: isTa
                    ? '${settings.ringSeconds} வினாடி'
                    : '${settings.ringSeconds} sec',
                onTap: () =>
                    _pickRingDuration(context, notifier, settings.ringSeconds, isTa),
              ),
              const _RowDivider(),
              _SettingsSwitchRow(
                icon: Icons.volume_up_rounded,
                label: isTa ? 'குரல் அலாரம்' : 'Voice Alert',
                value: settings.voiceEnabled,
                onChanged: (v) => notifier.setVoiceEnabled(v),
              ),
              const _RowDivider(),
              _SettingsRow(
                icon: Icons.verified_user_outlined,
                label: isTa
                    ? 'அனுமதிகள் & 1 நிமிட சோதனை'
                    : 'Permissions & Test Alert',
                valueText: settings.testAlertPassed
                    ? (isTa ? 'சரிபார்க்கப்பட்டது' : 'Verified')
                    : (isTa ? 'சோதனை செய்' : 'Test now'),
                onTap: () => context.push('/onboarding?from=settings'),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // ── Daily Digest ─────────────────────────────────────────────
          _SectionHeader(isTa ? 'காலை சுருக்கம் · DIGEST' : 'MORNING DIGEST'),
          _SettingsGroup(
            children: [
              _SettingsSwitchRow(
                icon: Icons.wb_sunny_outlined,
                label: isTa ? 'காலை சுருக்கம் இயக்கு' : 'Morning Digest',
                value: settings.digestEnabled,
                onChanged: (v) => notifier.setDigestEnabled(v),
              ),
              const _RowDivider(),
              _SettingsRow(
                icon: Icons.access_time_rounded,
                label: isTa ? 'சுருக்க நேரம்' : 'Digest Time',
                valueText: _formatDigestTime(settings.digestTime),
                onTap: () => _pickDigestTime(
                    context, notifier, settings.digestTime),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // ── About & Legal ────────────────────────────────────────────
          _SectionHeader(isTa ? 'பற்றி · ABOUT' : 'ABOUT'),
          _SettingsGroup(
            children: [
              _SettingsRow(
                icon: Icons.privacy_tip_outlined,
                label: isTa ? 'தனியுரிமை குறிப்பு' : 'Privacy Notice',
                onTap: () => _showInfoDialog(
                  context,
                  title: isTa ? 'தனியுரிமை குறிப்பு' : 'Privacy Notice',
                  body: isTa
                      ? 'உங்கள் மருந்து விவரங்கள் அனைத்தும் உங்கள் தொலைபேசியில் மட்டுமே (SQLite) சேமிக்கப்படுகின்றன. கணக்குகள், விளம்பரங்கள் அல்லது கண்காணிப்பு எதுவும் இல்லை.'
                      : 'All your medicine reminders and dose history stay locally on your phone. No accounts, no tracking, and no cloud sharing of health records.',
                  okLabel: isTa ? 'சரி' : 'OK',
                ),
              ),
              const _RowDivider(),
              _SettingsRow(
                icon: Icons.medical_information_outlined,
                label: isTa ? 'மருத்துவ மறுப்பு' : 'Medical Disclaimer',
                onTap: () => _showInfoDialog(
                  context,
                  title: isTa ? 'மருத்துவ மறுப்பு' : 'Medical Disclaimer',
                  body: isTa
                      ? 'இந்தச் செயலி நினைவூட்டல்களை மட்டுமே வழங்குகிறது. இது மருத்துவ ஆலோசனை அல்ல. எப்போதும் உங்கள் மருத்துவரின் அறிவுறுத்தல்களைப் பின்பற்றவும்.'
                      : 'This app sends reminders only. It does not provide medical advice or dosing guidance. Always follow your doctor\'s instructions.',
                  okLabel: isTa ? 'சரி' : 'OK',
                ),
              ),
              const _RowDivider(),
              _SettingsRow(
                icon: Icons.info_outline_rounded,
                label: isTa ? 'பதிப்பு' : 'App Version',
                valueText: '1.0.0 (beta)',
                onTap: null,
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _fontScaleLabel(double scale, bool isTa) {
    if (scale >= 1.35) return isTa ? 'மிக பெரியது (1.4x)' : 'Extra Large (1.4x)';
    if (scale >= 1.15) return isTa ? 'பெரியது (1.2x)' : 'Large (1.2x)';
    return isTa ? 'சாதாரணம் (1.0x)' : 'Normal (1.0x)';
  }

  String _themeLabel(ThemeMode mode, bool isTa) {
    return switch (mode) {
      ThemeMode.light => isTa ? 'வெளிர் (Light)' : 'Light',
      ThemeMode.dark => isTa ? 'இருண்ட (Dark)' : 'Dark',
      ThemeMode.system => isTa ? 'அமைப்பு (System)' : 'System',
    };
  }

  String _formatDigestTime(String hhmm) {
    final parts = hhmm.split(':');
    if (parts.length != 2) return hhmm;
    final h = int.tryParse(parts[0]) ?? 8;
    final m = int.tryParse(parts[1]) ?? 30;
    final period = h >= 12 ? 'PM' : 'AM';
    final dh = h == 0 ? 12 : (h > 12 ? h - 12 : h);
    return '$dh:${m.toString().padLeft(2, '0')} $period';
  }

  void _pickLanguage(
      BuildContext context, AppSettingsNotifier notifier, bool isTa) {
    _showChoiceSheet<String>(
      context: context,
      title: isTa ? 'மொழி தேர்வு' : 'Choose Language',
      current: isTa ? 'ta' : 'en',
      options: const [
        ('ta', 'தமிழ் (Tamil)'),
        ('en', 'English'),
      ],
      onSelected: (v) => notifier.setLanguage(v),
    );
  }

  void _pickFontScale(BuildContext context, AppSettingsNotifier notifier,
      double current, bool isTa) {
    _showChoiceSheet<double>(
      context: context,
      title: isTa ? 'எழுத்து அளவு' : 'Text Size',
      current: current,
      options: [
        (1.0, isTa ? 'சாதாரணம் (1.0x)' : 'Normal (1.0x)'),
        (1.2, isTa ? 'பெரியது (1.2x)' : 'Large (1.2x)'),
        (1.4, isTa ? 'மிக பெரியது (1.4x)' : 'Extra Large (1.4x)'),
      ],
      onSelected: (v) => notifier.setFontScale(v),
    );
  }

  void _pickThemeMode(BuildContext context, AppSettingsNotifier notifier,
      ThemeMode current, bool isTa) {
    _showChoiceSheet<ThemeMode>(
      context: context,
      title: isTa ? 'தோற்றம்' : 'Appearance',
      current: current,
      options: [
        (ThemeMode.system, isTa ? 'அமைப்பு (System)' : 'System default'),
        (ThemeMode.light, isTa ? 'வெளிர் (Light)' : 'Light'),
        (ThemeMode.dark, isTa ? 'இருண்ட (Dark)' : 'Dark'),
      ],
      onSelected: (v) => notifier.setThemeMode(v),
    );
  }

  void _pickSnooze(BuildContext context, AppSettingsNotifier notifier,
      int current, bool isTa) {
    _showChoiceSheet<int>(
      context: context,
      title: isTa ? 'தள்ளிப்போடு நேரம்' : 'Snooze Duration',
      current: current,
      options: [
        (5, isTa ? '5 நிமிடம்' : '5 minutes'),
        (10, isTa ? '10 நிமிடம்' : '10 minutes'),
        (15, isTa ? '15 நிமிடம்' : '15 minutes'),
        (30, isTa ? '30 நிமிடம்' : '30 minutes'),
      ],
      onSelected: (v) => notifier.setSnoozeMinutes(v),
    );
  }

  void _pickRingDuration(BuildContext context, AppSettingsNotifier notifier,
      int current, bool isTa) {
    _showChoiceSheet<int>(
      context: context,
      title: isTa ? 'ஒலிக்கும் நேரம்' : 'Ring Duration',
      current: current,
      options: [
        (30, isTa ? '30 வினாடி' : '30 seconds'),
        (60, isTa ? '60 வினாடி' : '60 seconds'),
        (120, isTa ? '2 நிமிடம்' : '2 minutes'),
        (300, isTa ? '5 நிமிடம்' : '5 minutes'),
      ],
      onSelected: (v) => notifier.setRingSeconds(v),
    );
  }

  Future<void> _pickDigestTime(BuildContext context,
      AppSettingsNotifier notifier, String current) async {
    final parts = current.split(':');
    final h = int.tryParse(parts[0]) ?? 8;
    final m = int.tryParse(parts.length > 1 ? parts[1] : '30') ?? 30;
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: h, minute: m),
    );
    if (picked != null) {
      final formatted =
          '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
      await notifier.setDigestTime(formatted);
    }
  }

  void _showChoiceSheet<T>({
    required BuildContext context,
    required String title,
    required T current,
    required List<(T, String)> options,
    required ValueChanged<T> onSelected,
  }) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppTheme.surface(context),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.text(ctx),
                ),
              ),
              const SizedBox(height: 16),
              ...options.map((opt) {
                final selected = opt.$1 == current;
                return ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radiusMD),
                  ),
                  title: Text(
                    opt.$2,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight:
                          selected ? FontWeight.w700 : FontWeight.w500,
                      color: selected
                          ? AppTheme.primaryOf(ctx)
                          : AppTheme.text(ctx),
                    ),
                  ),
                  trailing: selected
                      ? Icon(Icons.check_rounded,
                          color: AppTheme.primaryOf(ctx))
                      : null,
                  onTap: () {
                    Navigator.pop(ctx);
                    onSelected(opt.$1);
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  void _showInfoDialog(
    BuildContext context, {
    required String title,
    required String body,
    required String okLabel,
  }) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(body, style: const TextStyle(height: 1.5)),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(okLabel),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String text;
  const _SectionHeader(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 6, 4, 8),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: AppTheme.primaryOf(context),
          letterSpacing: 0.6,
        ),
      ),
    );
  }
}

class _SettingsGroup extends StatelessWidget {
  final List<Widget> children;
  const _SettingsGroup({required this.children});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppTheme.surface(context),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusLG),
        side: BorderSide(color: AppTheme.divider(context)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(children: children),
    );
  }
}

class _RowDivider extends StatelessWidget {
  const _RowDivider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 54),
      child: Divider(height: 1, color: AppTheme.divider(context)),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? valueText;
  final VoidCallback? onTap;

  const _SettingsRow({
    required this.icon,
    required this.label,
    this.valueText,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.primaryOf(context), size: 22),
      title: Text(
        label,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: AppTheme.text(context),
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (valueText != null)
            Text(
              valueText!,
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.textSub(context),
                fontWeight: FontWeight.w500,
              ),
            ),
          if (onTap != null) ...[
            const SizedBox(width: 6),
            Icon(Icons.chevron_right_rounded,
                color: AppTheme.textSub(context)),
          ],
        ],
      ),
      onTap: onTap,
      minTileHeight: AppTheme.touchTarget,
    );
  }
}

class _SettingsSwitchRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SettingsSwitchRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.primaryOf(context), size: 22),
      title: Text(
        label,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: AppTheme.text(context),
        ),
      ),
      trailing: Switch(value: value, onChanged: onChanged),
      minTileHeight: AppTheme.touchTarget,
    );
  }
}
