import 'package:flutter/material.dart';

class TodayScreen extends StatelessWidget {
  const TodayScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NeuraAlert'),
        actions: [IconButton(icon: const Icon(Icons.account_circle_outlined), onPressed: () {})],
      ),
      body: const Center(child: Text('Today screen — coming in M5', style: TextStyle(fontSize: 16))),
    );
  }
}
