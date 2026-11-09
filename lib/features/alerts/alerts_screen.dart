import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AlertsScreen extends StatelessWidget {
  const AlertsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Alerts')),
      body: const Center(child: Text('Your reminders will appear here', style: TextStyle(fontSize: 16))),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/add-alert'),
        icon: const Icon(Icons.add),
        label: const Text('Add Alert'),
      ),
    );
  }
}
