import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Setup')),
      body: Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Text('Permissions & Test Alert', style: TextStyle(fontSize: 20)),
          const SizedBox(height: 24),
          FilledButton(onPressed: () => context.go('/today'), child: const Text('Continue')),
        ]),
      ),
    );
  }
}
