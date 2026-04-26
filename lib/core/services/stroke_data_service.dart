// lib/core/services/stroke_data_service.dart
//
// Сервис загрузки данных о чертах иероглифов.
// Загружает JSON из assets/content/strokes/ — один файл на иероглиф.
// Формат файла: { "character": "我", "strokes": [ [[x,y],...], ... ] }
//
// Источник данных: hanzi-writer-data (https://github.com/skishore/hanzi-writer-data)
// Конвертирован в упрощённый формат для Flutter.

import 'dart:convert';
import 'package:flutter/services.dart';
import '../../data/models/stroke_data.dart';

class StrokeDataService {
  static const String _basePath = 'assets/content/strokes/';

  /// Кэш загруженных данных.
  final Map<String, HanziStrokeData> _cache = {};

  /// Загрузить данные черт для одного иероглифа.
  /// Возвращает null если данные не найдены.
  Future<HanziStrokeData?> loadStrokeData(String character) async {
    if (_cache.containsKey(character)) {
      return _cache[character];
    }

    try {
      // Имя файла: иероглиф.json (например 我.json)
      final fileName = '$character.json';
      final jsonString = await rootBundle.loadString('$_basePath$fileName');
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      json['character'] = character;
      final data = HanziStrokeData.fromJson(json);
      _cache[character] = data;
      return data;
    } catch (e) {
      // Файл не найден или ошибка парсинга — возвращаем null
      return null;
    }
  }

  /// Загрузить данные для нескольких иероглифов.
  Future<Map<String, HanziStrokeData>> loadMultiple(
      List<String> characters) async {
    final result = <String, HanziStrokeData>{};
    for (final char in characters) {
      final data = await loadStrokeData(char);
      if (data != null) {
        result[char] = data;
      }
    }
    return result;
  }

  /// Проверить, есть ли данные для иероглифа в кэше.
  bool hasCached(String character) => _cache.containsKey(character);

  /// Очистить кэш.
  void clearCache() => _cache.clear();
}
