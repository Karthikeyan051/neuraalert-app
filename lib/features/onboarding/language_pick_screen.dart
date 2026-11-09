import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LanguagePickScreen extends StatelessWidget {
  const LanguagePickScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D2137),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              const Text('NeuraAlert', style: TextStyle(color: Color(0xFF00D4FF), fontSize: 32, fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              const Text('by Neurava', style: TextStyle(color: Colors.white54, fontSize: 16)),
              const SizedBox(height: 48),
              const Text('Choose your language\nமொழியை தேர்ந்தெடுங்கள்',
                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600, height: 1.6)),
              const SizedBox(height: 32),
              FilledButton(
                onPressed: () => context.go('/onboarding'),
                style: FilledButton.styleFrom(backgroundColor: const Color(0xFF1565C0), foregroundColor: Colors.white),
                child: const Padding(padding: EdgeInsets.symmetric(vertical: 8), child: Text('English', style: TextStyle(fontSize: 20))),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => context.go('/onboarding'),
                style: FilledButton.styleFrom(backgroundColor: const Color(0xFF00D4FF), foregroundColor: const Color(0xFF060B14)),
                child: const Padding(padding: EdgeInsets.symmetric(vertical: 8), child: Text('தமிழ்', style: TextStyle(fontSize: 20))),
              ),
              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}
