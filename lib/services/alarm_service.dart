import 'dart:io';
import 'package:alarm/alarm.dart';
import 'package:path_provider/path_provider.dart';
import '../core/audio_utils.dart';

class AlarmService {
  static bool _initialized = false;

  static Future<void> init() async {
    if (_initialized) return;
    await Alarm.init();
    _initialized = true;
  }

  static Future<String> getFallbackChimePath() async {
    final dir = await getApplicationDocumentsDirectory();
    final soundFile = File('${dir.path}/sounds/neura_chime.wav');
    await AudioUtils.createChimeWav(soundFile);
    return soundFile.path;
  }

  static Future<bool> scheduleAlarm({
    required int id,
    required DateTime fireAt,
    String? voiceAudioPath,
    required String title,
    required String body,
  }) async {
    await init();

    String soundPath = voiceAudioPath ?? '';
    if (soundPath.isEmpty || !File(soundPath).existsSync()) {
      soundPath = await getFallbackChimePath();
    }

    final alarmSettings = AlarmSettings(
      id: id,
      dateTime: fireAt,
      assetAudioPath: soundPath,
      loopAudio: true,
      vibrate: true,
      volumeSettings: VolumeSettings.fixed(volume: 1.0),
      notificationSettings: NotificationSettings(
        title: title,
        body: body,
        stopButton: 'Stop',
        icon: 'notification_icon',
      ),
      warningNotificationOnKill: true,
      androidFullScreenIntent: true,
    );

    return await Alarm.set(alarmSettings: alarmSettings);
  }

  static Future<bool> stop(int id) async {
    await init();
    return await Alarm.stop(id);
  }

  // ignore: deprecated_member_use
  static Stream<AlarmSettings> get onRing => Alarm.ringStream.stream;
}
