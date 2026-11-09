import 'dart:io';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:path_provider/path_provider.dart';

class VoiceService {
  final FlutterTts _tts = FlutterTts();
  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;
    try {
      if (Platform.isAndroid) {
        // Prefer Google TTS engine which has best Tamil support
        final engines = await _tts.getEngines;
        if (engines is List && engines.contains('com.google.android.tts')) {
          await _tts.setEngine('com.google.android.tts');
        }
      }
      await _tts.setSpeechRate(0.5);
      await _tts.setVolume(1.0);
      await _tts.setPitch(1.0);
      _isInitialized = true;
    } catch (e) {
      // Fallback
    }
  }

  Future<bool> isTamilAvailable() async {
    await init();
    try {
      final res = await _tts.isLanguageAvailable("ta-IN");
      return res == true || res == 1;
    } catch (_) {
      return false;
    }
  }

  String buildSpokenPhrase({
    required String medicineName,
    required String doseNote,
    required String foodRelation, // 'none', 'before', 'after', 'with'
    required String lang, // 'ta' or 'en'
  }) {
    if (lang == 'ta') {
      String foodPhrase = '';
      if (foodRelation == 'before') {
        foodPhrase = 'உணவுக்கு முன் எடுத்துக்கொள்ளுங்கள்.';
      } else if (foodRelation == 'after') {
        foodPhrase = 'உணவுக்குப் பின் எடுத்துக்கொள்ளுங்கள்.';
      } else if (foodRelation == 'with') {
        foodPhrase = 'உணவுடன் எடுத்துக்கொள்ளுங்கள்.';
      }

      final notePart = doseNote.trim().isNotEmpty ? ' $doseNote.' : '';
      final foodPart = foodPhrase.isNotEmpty ? ' $foodPhrase' : '';
      return '$medicineName எடுத்துக்கொள்ளும் நேரம் இது.$notePart$foodPart';
    } else {
      String foodPhrase = '';
      if (foodRelation == 'before') {
        foodPhrase = 'Take it before food.';
      } else if (foodRelation == 'after') {
        foodPhrase = 'Take it after food.';
      } else if (foodRelation == 'with') {
        foodPhrase = 'Take it with food.';
      }

      final notePart = doseNote.trim().isNotEmpty ? ' $doseNote.' : '';
      final foodPart = foodPhrase.isNotEmpty ? ' $foodPhrase' : '';
      return 'It is time to take $medicineName.$notePart$foodPart';
    }
  }

  Future<void> speakPreview({
    required String medicineName,
    required String doseNote,
    required String foodRelation,
    required String lang,
  }) async {
    await init();
    final locale = lang == 'ta' ? 'ta-IN' : 'en-IN';
    await _tts.setLanguage(locale);
    final phrase = buildSpokenPhrase(
      medicineName: medicineName,
      doseNote: doseNote,
      foodRelation: foodRelation,
      lang: lang,
    );
    await _tts.speak(phrase);
  }

  Future<String?> synthesizeSpokenFile({
    required String id,
    required String medicineName,
    required String doseNote,
    required String foodRelation,
    required String lang,
  }) async {
    await init();
    try {
      final locale = lang == 'ta' ? 'ta-IN' : 'en-IN';
      await _tts.setLanguage(locale);
      final phrase = buildSpokenPhrase(
        medicineName: medicineName,
        doseNote: doseNote,
        foodRelation: foodRelation,
        lang: lang,
      );

      final dir = await getApplicationDocumentsDirectory();
      final voiceDir = Directory('${dir.path}/voice');
      if (!await voiceDir.exists()) {
        await voiceDir.create(recursive: true);
      }
      final fileName = 'voice_${id}_$lang.wav';
      final file = File('${voiceDir.path}/$fileName');

      // Android synthesizeToFile writes relative to external storage or app dir
      final result = await _tts.synthesizeToFile(phrase, fileName);
      if (result == 1) {
        if (await file.exists()) {
          return file.path;
        }
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<void> stop() async {
    await _tts.stop();
  }
}
