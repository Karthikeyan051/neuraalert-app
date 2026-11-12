import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:neuraalert/app/app_theme.dart';
import 'package:neuraalert/features/settings/app_settings_provider.dart';

class LanguagePickScreen extends ConsumerStatefulWidget {
  final bool fromSettings;
  const LanguagePickScreen({super.key, this.fromSettings = false});

  @override
  ConsumerState<LanguagePickScreen> createState() =>
      _LanguagePickScreenState();
}

class _LanguagePickScreenState extends ConsumerState<LanguagePickScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ambientCtrl;

  @override
  void initState() {
    super.initState();
    _ambientCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();
  }

  @override
  void dispose() {
    _ambientCtrl.dispose();
    super.dispose();
  }

  Future<void> _selectLanguage(String lang) async {
    HapticFeedback.selectionClick();
    await ref.read(appSettingsProvider.notifier).setLanguage(lang);
    if (!mounted) return;
    if (widget.fromSettings) {
      context.pop();
    } else {
      context.go('/onboarding');
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentLang = ref.watch(appSettingsProvider).language;

    return Scaffold(
      backgroundColor: AppTheme.bg(context),
      body: Stack(
        children: [
          // Subtle calm desaturated fold lines in the background
          Positioned.fill(
            child: IgnorePointer(
              child: AnimatedBuilder(
                animation: _ambientCtrl,
                builder: (context, _) {
                  return CustomPaint(
                    painter: _CalmFoldPainter(
                      progress: _ambientCtrl.value,
                      color: AppTheme.primaryOf(context)
                          .withValues(alpha: 0.045),
                    ),
                  );
                },
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(28, 32, 28, 48),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (widget.fromSettings) ...[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton.icon(
                        onPressed: () => context.pop(),
                        icon: const Icon(Icons.arrow_back_rounded),
                        label: Text(
                            currentLang == 'ta' ? 'திரும்பு' : 'Back'),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ] else
                    const SizedBox(height: 16),

                  // ── App Identity ────────────────────────────────────────
                  Row(
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: AppTheme.primary,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.notifications_active_rounded,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'NeuraAlert',
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                              color: AppTheme.primaryOf(context),
                              letterSpacing: -0.5,
                            ),
                          ),
                          Text(
                            'by Neurava',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppTheme.textSub(context),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 56),

                  // ── Headline ────────────────────────────────────────────
                  Text(
                    'Choose your language',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.text(context),
                      letterSpacing: -0.5,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'மொழியை தேர்ந்தெடுங்கள்',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.textSub(context),
                      height: 1.4,
                    ),
                  ),

                  const SizedBox(height: 44),

                  // ── Tamil Option ────────────────────────────────────────
                  _LangButton(
                    badge: 'த',
                    label: 'தமிழ்',
                    sublabel: 'தமிழில் தொடர்க',
                    filled: true,
                    onTap: () => _selectLanguage('ta'),
                  ),

                  const SizedBox(height: 16),

                  // ── English Option ──────────────────────────────────────
                  _LangButton(
                    badge: 'Aa',
                    label: 'English',
                    sublabel: 'Continue in English',
                    filled: false,
                    onTap: () => _selectLanguage('en'),
                  ),

                  const SizedBox(height: 52),

                  Text(
                    'You can change this anytime in Settings.\nமொழியை பின்னர் அமைப்புகளில் மாற்றலாம்.',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.textSub(context),
                      height: 1.6,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LangButton extends StatelessWidget {
  final String badge;
  final String label;
  final String sublabel;
  final bool filled;
  final VoidCallback onTap;

  const _LangButton({
    required this.badge,
    required this.label,
    required this.sublabel,
    required this.filled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = AppTheme.isDark(context);
    final primary = AppTheme.primaryOf(context);

    return Material(
      color: filled ? AppTheme.primary : AppTheme.surface(context),
      borderRadius: BorderRadius.circular(AppTheme.radiusLG),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.radiusLG),
        child: Container(
          constraints: const BoxConstraints(minHeight: 80),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppTheme.radiusLG),
            border: Border.all(
              color: filled ? AppTheme.primary : AppTheme.divider(context),
              width: filled ? 0 : 1.5,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: filled
                      ? Colors.white.withValues(alpha: 0.16)
                      : AppTheme.chipBg(context),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  badge,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: filled
                        ? Colors.white
                        : (isDark ? primary : AppTheme.primary),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: filled ? Colors.white : AppTheme.text(context),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      sublabel,
                      style: TextStyle(
                        fontSize: 14,
                        color: filled
                            ? Colors.white.withValues(alpha: 0.8)
                            : AppTheme.textSub(context),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_rounded,
                color: filled ? Colors.white70 : AppTheme.textSub(context),
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CalmFoldPainter extends CustomPainter {
  final double progress;
  final Color color;

  _CalmFoldPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;

    final phase = progress * 2 * math.pi;
    for (int line = 0; line < 4; line++) {
      final path = Path();
      final yBase = size.height * (0.28 + line * 0.16);
      for (double x = 0; x <= size.width; x += 12) {
        final wave =
            math.sin((x / size.width) * 2.5 * math.pi + phase + line * 0.7) *
                18;
        final y = yBase + wave;
        if (x == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(_CalmFoldPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.color != color;
}
