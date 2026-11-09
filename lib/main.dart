import 'dart:async';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/supabase_config.dart';
import 'features/alert_screen/alert_screen.dart';
import 'services/alarm_service.dart';
import 'services/voice_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  try {
    await Supabase.initialize(
      url: SupabaseConfig.url,
      publishableKey: SupabaseConfig.publishableKey,
    );
  } catch (e) {
    debugPrint('Supabase init note: $e');
  }

  // Initialize Alarms
  await AlarmService.init();

  runApp(const NeuraAlertApp());
}

class NeuraAlertApp extends StatelessWidget {
  const NeuraAlertApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NeuraAlert',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF5F9FF),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1565C0),
          primary: const Color(0xFF1565C0),
          secondary: const Color(0xFF2196F3),
          surface: Colors.white,
        ),
        fontFamily: 'Roboto',
      ),
      home: const SpikeHomeScreen(),
    );
  }
}

class SpikeHomeScreen extends StatefulWidget {
  const SpikeHomeScreen({super.key});

  @override
  State<SpikeHomeScreen> createState() => _SpikeHomeScreenState();
}

class _SpikeHomeScreenState extends State<SpikeHomeScreen> {
  final VoiceService _voiceService = VoiceService();
  StreamSubscription? _ringSubscription;

  // Form state
  final TextEditingController _nameController = TextEditingController(text: 'Paracetamol 500mg');
  final TextEditingController _doseController = TextEditingController(text: '1 மாத்திரை / 1 tablet');
  String _foodRelation = 'after'; // 'none', 'before', 'after', 'with'
  String _selectedLang = 'ta'; // 'ta' or 'en'
  int _delaySeconds = 15; // 15s quick test

  // Permissions state
  bool _notificationGranted = false;
  bool _exactAlarmGranted = false;

  @override
  void initState() {
    super.initState();
    _voiceService.init();
    _checkPermissions();

    // Listen to alarms firing
    _ringSubscription = AlarmService.onRing.listen((alarmSettings) {
      if (!mounted) return;
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => AlertScreen(
            alarmId: alarmSettings.id,
            title: alarmSettings.notificationSettings.title,
            subtitle: alarmSettings.notificationSettings.body,
            category: 'medicine',
            language: _selectedLang,
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    _ringSubscription?.cancel();
    _nameController.dispose();
    _doseController.dispose();
    super.dispose();
  }

  Future<void> _checkPermissions() async {
    final notif = await Permission.notification.isGranted;
    final exact = await Permission.scheduleExactAlarm.isGranted;
    if (mounted) {
      setState(() {
        _notificationGranted = notif;
        _exactAlarmGranted = exact;
      });
    }
  }

  Future<void> _requestPermissions() async {
    await Permission.notification.request();
    await Permission.scheduleExactAlarm.request();
    await Permission.ignoreBatteryOptimizations.request();
    await _checkPermissions();
  }

  Future<void> _testVoicePreview(String lang) async {
    await _voiceService.speakPreview(
      medicineName: _nameController.text.trim(),
      doseNote: _doseController.text.trim(),
      foodRelation: _foodRelation,
      lang: lang,
    );
  }

  Future<void> _scheduleSpikeAlarm() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter medicine name')),
      );
      return;
    }

    final fireTime = DateTime.now().add(Duration(seconds: _delaySeconds));
    final id = DateTime.now().millisecondsSinceEpoch % 100000;

    // Pre-synthesize the voice file
    final audioPath = await _voiceService.synthesizeSpokenFile(
      id: id.toString(),
      medicineName: name,
      doseNote: _doseController.text.trim(),
      foodRelation: _foodRelation,
      lang: _selectedLang,
    );
    debugPrint('Synthesized audioPath: $audioPath');

    final title = _selectedLang == 'ta' ? 'மருந்து நேரம்: $name' : 'Medicine Alert: $name';
    final body = _voiceService.buildSpokenPhrase(
      medicineName: name,
      doseNote: _doseController.text.trim(),
      foodRelation: _foodRelation,
      lang: _selectedLang,
    );

    final success = await AlarmService.scheduleAlarm(
      id: id,
      fireAt: fireTime,
      voiceAudioPath: audioPath,
      title: title,
      body: body,
    );

    if (!mounted) return;

    if (success) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Row(
            children: [
              Icon(Icons.check_circle_rounded, color: Color(0xFF1B873D)),
              SizedBox(width: 10),
              Text('Alarm Scheduled!'),
            ],
          ),
          content: Text(
            'Ringing in $_delaySeconds seconds!\n\n'
            '👉 IMPORTANT:\n'
            '1. Press the lock button on your phone now.\n'
            '2. Wait $_delaySeconds seconds.\n'
            '3. Confirm the screen wakes up with the spoken voice alert!',
            style: const TextStyle(fontSize: 16, height: 1.4),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('OK, Locking Phone Now', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to schedule alarm. Check permissions.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1565C0),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.alarm_rounded, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 10),
                const Text(
                  'NeuraAlert',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0A1628),
                    fontSize: 22,
                  ),
                ),
              ],
            ),
            const Text(
              'by Neurava • M1 Alarm Spike Test',
              style: TextStyle(color: Color(0xFF4A6080), fontSize: 13),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Permissions Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFD6E4F7)),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1565C0).withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Android Permissions Check',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF0A1628)),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        _notificationGranted ? Icons.check_circle : Icons.warning_rounded,
                        color: _notificationGranted ? const Color(0xFF1B873D) : const Color(0xFFFF8F00),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _notificationGranted ? 'Notifications: Granted' : 'Notifications: Missing',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        _exactAlarmGranted ? Icons.check_circle : Icons.warning_rounded,
                        color: _exactAlarmGranted ? const Color(0xFF1B873D) : const Color(0xFFFF8F00),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _exactAlarmGranted ? 'Exact Alarm: Granted' : 'Exact Alarm: Missing',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  if (!_notificationGranted || !_exactAlarmGranted) ...[
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _requestPermissions,
                        icon: const Icon(Icons.security_rounded, size: 18),
                        label: const Text('Grant Required Permissions'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1565C0),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Medicine Details Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFD6E4F7)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Medicine Reminder Info',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF0A1628)),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Medicine Name',
                      hintText: 'e.g. Paracetamol 500mg',
                      filled: true,
                      fillColor: const Color(0xFFF5F9FF),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _doseController,
                    decoration: InputDecoration(
                      labelText: 'Dose Note',
                      hintText: 'e.g. 1 மாத்திரை',
                      filled: true,
                      fillColor: const Color(0xFFF5F9FF),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text('Food Relation:', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      ChoiceChip(
                        label: const Text('After Food (பின்)'),
                        selected: _foodRelation == 'after',
                        onSelected: (_) => setState(() => _foodRelation = 'after'),
                      ),
                      ChoiceChip(
                        label: const Text('Before Food (முன்)'),
                        selected: _foodRelation == 'before',
                        onSelected: (_) => setState(() => _foodRelation = 'before'),
                      ),
                      ChoiceChip(
                        label: const Text('With Food (உடன்)'),
                        selected: _foodRelation == 'with',
                        onSelected: (_) => setState(() => _foodRelation = 'with'),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Voice Engine Preview Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFD6E4F7)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.record_voice_over_rounded, color: Color(0xFF1565C0)),
                      SizedBox(width: 8),
                      Text(
                        'Voice Alert Preview (TTS)',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF0A1628)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Test how Google TTS pronounces this medicine name on your phone:',
                    style: TextStyle(color: Color(0xFF4A6080), fontSize: 13),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _testVoicePreview('ta'),
                          icon: const Icon(Icons.volume_up_rounded, size: 20),
                          label: const Text('தமிழில் கேள்'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF1565C0),
                            side: const BorderSide(color: Color(0xFF1565C0)),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _testVoicePreview('en'),
                          icon: const Icon(Icons.volume_up_rounded, size: 20),
                          label: const Text('English Voice'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF1565C0),
                            side: const BorderSide(color: Color(0xFF1565C0)),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Schedule Delay Selector & Trigger
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFEBF3FF),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFBBDEFB)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Alarm Trigger Delay:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF0A1628)),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      ChoiceChip(
                        label: const Text('15 Seconds'),
                        selected: _delaySeconds == 15,
                        onSelected: (_) => setState(() => _delaySeconds = 15),
                      ),
                      const SizedBox(width: 8),
                      ChoiceChip(
                        label: const Text('30 Seconds'),
                        selected: _delaySeconds == 30,
                        onSelected: (_) => setState(() => _delaySeconds = 30),
                      ),
                      const SizedBox(width: 8),
                      ChoiceChip(
                        label: const Text('1 Minute'),
                        selected: _delaySeconds == 60,
                        onSelected: (_) => setState(() => _delaySeconds = 60),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Text('Voice Language: ', style: TextStyle(fontWeight: FontWeight.w600)),
                      DropdownButton<String>(
                        value: _selectedLang,
                        items: const [
                          DropdownMenuItem(value: 'ta', child: Text('தமிழ் (Tamil)')),
                          DropdownMenuItem(value: 'en', child: Text('English')),
                        ],
                        onChanged: (val) {
                          if (val != null) setState(() => _selectedLang = val);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton.icon(
                      onPressed: _scheduleSpikeAlarm,
                      icon: const Icon(Icons.alarm_add_rounded),
                      label: Text(
                        'Ring in $_delaySeconds Seconds (Lock Phone!)',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1565C0),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        elevation: 3,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
