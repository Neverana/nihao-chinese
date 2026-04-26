// lib/data/models/stroke_data.dart
//
// Модели данных для черт иероглифов (hanzi-writer format).
// Каждая черта — это набор точек (x, y), описывающих путь кисти.

/// Одна черта иероглифа — последовательность точек пути.
class StrokePath {
  /// Точки пути: каждая точка — (x, y) в относительных координатах 0–1024.
  final List<({double x, double y})> points;

  const StrokePath({required this.points});

  factory StrokePath.fromJson(List<dynamic> json) {
    final pts = <({double x, double y})>[];
    for (final item in json) {
      if (item is List && item.length >= 2) {
        pts.add(
            (x: (item[0] as num).toDouble(), y: (item[1] as num).toDouble()));
      }
    }
    return StrokePath(points: pts);
  }
}

/// Данные одного иероглифа: все черты в правильном порядке.
class HanziStrokeData {
  /// Иероглиф (ключ).
  final String character;

  /// Список черт в правильном порядке написания.
  final List<StrokePath> strokes;

  const HanziStrokeData({
    required this.character,
    required this.strokes,
  });

  /// Количество черт.
  int get strokeCount => strokes.length;

  factory HanziStrokeData.fromJson(Map<String, dynamic> json) {
    final strokes = <StrokePath>[];
    if (json['strokes'] != null) {
      for (final s in json['strokes'] as List) {
        strokes.add(StrokePath.fromJson(s as List));
      }
    }
    return HanziStrokeData(
      character: json['character'] as String,
      strokes: strokes,
    );
  }

  Map<String, dynamic> toJson() => {
        'character': character,
        'strokes': strokes
            .map((s) => s.points.map((p) => [p.x, p.y]).toList())
            .toList(),
      };
}
