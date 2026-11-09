import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AddAlertScreen extends StatelessWidget {
  const AddAlertScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Alert')),
      body: const Center(child: Text('Add alert form — coming in M2', style: TextStyle(fontSize: 16))),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: FilledButton(onPressed: () => context.go('/alerts'), child: const Text('Save')),
      ),
    );
  }
}
