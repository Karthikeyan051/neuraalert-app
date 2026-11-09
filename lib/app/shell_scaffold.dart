// lib/app/shell_scaffold.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ShellScaffold extends StatelessWidget {
  final Widget child;
  const ShellScaffold({super.key, required this.child});

  static const _tabs = [
    (path: '/today',    icon: Icons.today_outlined,    activeIcon: Icons.today,     label: 'Today'),
    (path: '/alerts',   icon: Icons.alarm_outlined,    activeIcon: Icons.alarm,     label: 'Alerts'),
    (path: '/history',  icon: Icons.bar_chart_outlined, activeIcon: Icons.bar_chart, label: 'History'),
    (path: '/settings', icon: Icons.settings_outlined,  activeIcon: Icons.settings,  label: 'Settings'),
  ];

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    final idx = _tabs.indexWhere((t) => location.startsWith(t.path));
    final currentIdx = idx < 0 ? 0 : idx;

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIdx,
        onDestinationSelected: (i) => context.go(_tabs[i].path),
        destinations: _tabs.map((t) => NavigationDestination(
          icon: Icon(t.icon),
          selectedIcon: Icon(t.activeIcon),
          label: t.label,
        )).toList(),
      ),
    );
  }
}
