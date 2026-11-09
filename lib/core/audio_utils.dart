import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

/// Utility to generate a clean PCM WAV beep / chime audio file
class AudioUtils {
  static Future<File> createChimeWav(File targetFile) async {
    if (await targetFile.exists() && (await targetFile.length()) > 100) {
      return targetFile;
    }

    const sampleRate = 16000;
    const durationSeconds = 3;
    const numSamples = sampleRate * durationSeconds;

    final samples = Int16List(numSamples);

    // Generate a gentle two-tone chime (523 Hz C5 + 659 Hz E5) with smooth envelope
    for (int i = 0; i < numSamples; i++) {
      final t = i / sampleRate;
      final envelope = exp(-1.5 * (t % 1.5));
      final tone1 = sin(2 * pi * 523.25 * t);
      final tone2 = sin(2 * pi * 659.25 * t);
      final sampleVal = ((tone1 + tone2) * 0.4 * envelope * 32767).clamp(-32768, 32767).toInt();
      samples[i] = sampleVal;
    }

    final byteData = ByteData(44 + numSamples * 2);
    // RIFF chunk descriptor
    byteData.setUint8(0, 0x52); // R
    byteData.setUint8(1, 0x49); // I
    byteData.setUint8(2, 0x46); // F
    byteData.setUint8(3, 0x46); // F
    byteData.setUint32(4, 36 + numSamples * 2, Endian.little);
    byteData.setUint8(8, 0x57);  // W
    byteData.setUint8(9, 0x41);  // A
    byteData.setUint8(10, 0x56); // V
    byteData.setUint8(11, 0x45); // E

    // 'fmt ' sub-chunk
    byteData.setUint8(12, 0x66); // f
    byteData.setUint8(13, 0x6D); // m
    byteData.setUint8(14, 0x74); // t
    byteData.setUint8(15, 0x20); // ' '
    byteData.setUint32(16, 16, Endian.little); // Subchunk1Size (16 for PCM)
    byteData.setUint16(20, 1, Endian.little);  // AudioFormat (1 = PCM)
    byteData.setUint16(22, 1, Endian.little);  // NumChannels (1 = Mono)
    byteData.setUint32(24, sampleRate, Endian.little); // SampleRate
    byteData.setUint32(28, sampleRate * 2, Endian.little); // ByteRate
    byteData.setUint16(32, 2, Endian.little);  // BlockAlign
    byteData.setUint16(34, 16, Endian.little); // BitsPerSample (16 bits)

    // 'data' sub-chunk
    byteData.setUint8(36, 0x64); // d
    byteData.setUint8(37, 0x61); // a
    byteData.setUint8(38, 0x74); // t
    byteData.setUint8(39, 0x61); // a
    byteData.setUint32(40, numSamples * 2, Endian.little);

    for (int i = 0; i < numSamples; i++) {
      byteData.setInt16(44 + i * 2, samples[i], Endian.little);
    }

    await targetFile.parent.create(recursive: true);
    await targetFile.writeAsBytes(byteData.buffer.asUint8List(), flush: true);
    return targetFile;
  }
}
