// lib/app/shell_scaffold.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:neuraalert/app/app_theme.dart';
import 'package:neuraalert/features/settings/app_settings_provider.dart';

class ShellScaffold extends ConsumerWidget {
  final Widget child;
  const ShellScaffold({super.key, required this.child});

  static const _tabs = [
    (
      path: '/today',
      icon: Icons.home_outlined,
      activeIcon: Icons.home_rounded,
      labelTa: 'இன்று',
      labelEn: 'Today',
    ),
    (
      path: '/alerts',
      icon: Icons.medication_outlined,
      activeIcon: Icons.medication_rounded,
      labelTa: 'மருந்துகள்',
      labelEn: 'Reminders',
    ),
    (
      path: '/settings',
      icon: Icons.settings_outlined,
      activeIcon: Icons.settings_rounded,
      labelTa: 'அமைப்புகள்',
      labelEn: 'Settings',
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location = GoRouterState.of(context).matchedLocation;
    final idx = _tabs.indexWhere((t) => location.startsWith(t.path));
    final currentIdx = idx < 0 ? 0 : idx;
    final settings = ref.watch(appSettingsProvider);
    final bottomPad = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: child),
          Positioned(
            left: 24,
            right: 24,
            bottom: 16 + bottomPad,
            child: _FloatingPillDock(
              currentIdx: currentIdx,
              isTamil: settings.isTamil,
              tabs: _tabs,
              onTap: (i) {
                HapticFeedback.selectionClick();
                context.go(_tabs[i].path);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _FloatingPillDock extends StatelessWidget {
  final int currentIdx;
  final bool isTamil;
  final ValueChanged<int> onTap;
  final List<
      ({
        String path,
        IconData icon,
        IconData activeIcon,
        String labelTa,
        String labelEn,
      })> tabs;

  const _FloatingPillDock({
    required this.currentIdx,
    required this.isTamil,
    required this.onTap,
    required this.tabs,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = AppTheme.isDark(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.surface(context),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.divider(context), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.08),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: List.generate(tabs.length, (i) {
          final tab = tabs[i];
          final isSelected = i == currentIdx;

          return Expanded(
            child: _DockItem(
              icon: tab.icon,
              activeIcon: tab.activeIcon,
              label: isTamil ? tab.labelTa : tab.labelEn,
              isSelected: isSelected,
              onTap: () => onTap(i),
            ),
          );
        }),
      ),
    );
  }
}

class _DockItem extends StatefulWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _DockItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_DockItem> createState() => _DockItemState();
}

class _DockItemState extends State<_DockItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 140),
    );
    _scale = Tween<double>(begin: 1.0, end: 0.92).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOut),
    );
  }

  @override
  void didUpdateWidget(_DockItem old) {
    super.didUpdateWidget(old);
    if (widget.isSelected && !old.isSelected) {
      _ctrl.forward().then((_) {
        if (mounted) _ctrl.reverse();
      });
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSelected = widget.isSelected;
    final primaryColor = AppTheme.primaryOf(context);
    final inactiveColor = AppTheme.textSub(context);

    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => _ctrl.forward(),
      onTapUp: (_) => _ctrl.reverse(),
      onTapCancel: () => _ctrl.reverse(),
      behavior: HitTestBehavior.opaque,
      child: ScaleTransition(
        scale: _scale,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          constraints: const BoxConstraints(minHeight: AppTheme.touchTarget),
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
          decoration: BoxDecoration(
            color:
                isSelected ? AppTheme.chipBg(context) : Colors.transparent,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isSelected ? widget.activeIcon : widget.icon,
                color: isSelected ? primaryColor : inactiveColor,
                size: 23,
              ),
              const SizedBox(height: 2),
              Text(
                widget.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight:
                      isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? primaryColor : inactiveColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
