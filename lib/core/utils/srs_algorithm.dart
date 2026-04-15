// lib/core/utils/srs_algorithm.dart
//
// Упрощённый алгоритм SM-2.
// quality: 0-1 = неверно, 2 = с трудом, 3-5 = верно

class SrsResult {
  final int newInterval;       // дни до следующего повторения
  final double newEaseFactor;  // коэффициент лёгкости (1.3 – 2.5)
  final int newRepetitionCount;

  const SrsResult({
    required this.newInterval,
    required this.newEaseFactor,
    required this.newRepetitionCount,
  });
}

SrsResult calculateSrs({
  required int quality,          // 0–5
  required int currentInterval,  // дни
  required double currentEaseFactor,
  required int repetitionCount,
}) {
  if (quality < 2) {
    // Неверно — сбрасываем
    return SrsResult(
      newInterval: 1,
      newEaseFactor: currentEaseFactor,
      newRepetitionCount: 0,
    );
  }

  final newEF = (currentEaseFactor +
          (0.1 - (5 - quality) * (0.08 + (5 - quality) * 0.02)))
      .clamp(1.3, 2.5);

  final newInterval = switch (repetitionCount) {
    0 => 1,
    1 => 6,
    _ => (currentInterval * newEF).round(),
  };

  return SrsResult(
    newInterval: newInterval,
    newEaseFactor: newEF,
    newRepetitionCount: repetitionCount + 1,
  );
}

// Конвертация правильность → quality
int answerToQuality({required bool correct, required bool wasEasy}) {
  if (!correct) return 1;
  if (wasEasy) return 5;
  return 3;
}

// Статус карточки для отображения
enum SrsDisplayStatus { newCard, review, mature, learning }

SrsDisplayStatus srsDisplayStatus({
  required int repetitionCount,
  required int interval,
  required DateTime nextReview,
}) {
  if (repetitionCount == 0) return SrsDisplayStatus.newCard;
  if (interval >= 21) return SrsDisplayStatus.mature;
  if (nextReview.isBefore(DateTime.now())) return SrsDisplayStatus.review;
  return SrsDisplayStatus.learning;
}

String srsLabel({
  required int repetitionCount,
  required int interval,
  required DateTime nextReview,
}) {
  final status = srsDisplayStatus(
    repetitionCount: repetitionCount,
    interval: interval,
    nextReview: nextReview,
  );
  return switch (status) {
    SrsDisplayStatus.newCard => 'Новое',
    SrsDisplayStatus.review => '🔴 Повторить!',
    SrsDisplayStatus.mature => '🟢 Зрелое',
    SrsDisplayStatus.learning => () {
        final days = nextReview.difference(DateTime.now()).inDays;
        return days <= 0 ? '🟡 Сегодня' : 'через $days дн.';
      }(),
  };
}
