// lib/core/audio/audio_service.dart

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

class AudioService {
  final _player = AudioPlayer();
  double _speed = 1.0;

  Future<void> playWord(String? audioPath) async {
    if (audioPath == null || audioPath.isEmpty) return;
    try {
      await _player.setAsset(audioPath);
      await _player.setSpeed(_speed);
      await _player.play();
    } catch (e) {
      // Файл не найден — тихо пропускаем (TTS добавится позже)
      debugPrint('AudioService: cannot play $audioPath — $e');
    }
  }

  Future<void> playAsset(String path) async {
    try {
      await _player.setAsset(path);
      await _player.setSpeed(_speed);
      await _player.play();
    } catch (e) {
      debugPrint('AudioService: cannot play $path — $e');
    }
  }

  void setSpeed(double speed) => _speed = speed;

  bool get isPlaying => _player.playing;

  Stream<bool> get playingStream => _player.playingStream;

  Future<void> stop() async => _player.stop();

  void dispose() => _player.dispose();
}

final audioServiceProvider = Provider<AudioService>((ref) {
  final service = AudioService();
  ref.onDispose(service.dispose);
  return service;
});
