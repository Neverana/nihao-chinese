// lib/core/audio/audio_service.dart

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:just_audio/just_audio.dart';

class AudioService {
  final _player = AudioPlayer();
  final _tts = FlutterTts();
  double _speed = 1.0;

  AudioService() {
    _initTts();
  }

  void _initTts() {
    _tts.setLanguage("zh-CN");
    _tts.setSpeechRate(0.5); // Нормальная скорость для изучения языка
    _tts.setVolume(1.0);
    _tts.setPitch(1.0);
  }

  Future<void> playWord(String? audioPath) async {
    if (audioPath == null || audioPath.isEmpty) return;
    await _play(audioPath);
  }

  Future<void> playSfx(String sfxName) async {
    // Останавливаем любой текущий SFX
    if (_player.playing) {
      await _player.stop();
    }
    // Пробуем оба расширения .wav и .mp3
    final extensions = ['.wav', '.mp3'];
    for (final ext in extensions) {
      final path = 'assets/audio/sfx/$sfxName$ext';
      if (await _play(path)) {
        return;
      }
    }
    debugPrint('AudioService: cannot play sfx $sfxName (tried .wav and .mp3)');
  }

  Future<void> speakChineseText(String text) async {
    if (text.trim().isEmpty) return;
    try {
      // Останавливаем предыдущую речь, если идет
      await _tts.stop();
      await _tts.speak(text);
    } catch (e) {
      debugPrint('AudioService: TTS error for text "$text" — $e');
    }
  }

  Future<void> playAsset(String path) async {
    await _play(path);
  }

  Future<bool> _play(String path) async {
    try {
      // Останавливаем текущее воспроизведение
      if (_player.playing) {
        await _player.stop();
      }
      await _player.setAudioSource(AudioSource.asset(path));
      await _player.setSpeed(_speed);
      await _player.play();
      return true;
    } catch (e) {
      debugPrint('AudioService: error playing $path — $e');
      return false;
    }
  }

  void setSpeed(double speed) => _speed = speed;

  bool get isPlaying => _player.playing;

  Stream<bool> get playingStream => _player.playingStream;

  Future<void> stop() async {
    await _player.stop();
    await _tts.stop();
  }

  void dispose() {
    _player.dispose();
    _tts.stop();
  }
}

final audioServiceProvider = Provider<AudioService>((ref) {
  final service = AudioService();
  ref.onDispose(service.dispose);
  return service;
});
