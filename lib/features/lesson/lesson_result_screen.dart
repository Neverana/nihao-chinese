// lib/features/lesson/lesson_result_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_tokens.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_card.dart';
import '../../data/repositories/content_repository.dart';

class LessonResultScreen extends ConsumerWidget {
  final String subtopicId;
  final int correct;
  final int total;

  const LessonResultScreen({
    required this.subtopicId,
    required this.correct,
    required this.total,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(appTokensProvider);
    final ts = AppTextStyles.of(t);
    final repo = ref.watch(contentRepositoryProvider);
    final sub = repo.getSubtopic(subtopicId);
    final topic = sub != null ? repo.getTopic(sub.topicId) : null;

    final accuracy = total == 0 ? 1.0 : correct / total;
    final isPerfect = accuracy == 1.0;
    final xp = _calcXp(accuracy);

    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Эмоджи результата
                Text(
                  isPerfect ? '🎉' : accuracy >= 0.6 ? '✅' : '📖',
                  style: const TextStyle(fontSize: 72),
                ),
                const SizedBox(height: 20),

                // Заголовок
                Text(
                  isPerfect
                      ? 'Идеально!'
                      : accuracy >= 0.6
                          ? 'Урок завершён!'
                          : 'Не сдавайся!',
                  style: ts.displayLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),

                if (sub != null)
                  Text(sub.titleRu,
                      style: ts.bodyMuted, textAlign: TextAlign.center),

                const SizedBox(height: 32),

                // Статистика
                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        icon: Icons.check_circle_rounded,
                        color: t.accentSuccess,
                        value: '$correct/$total',
                        label: 'Правильных',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatCard(
                        icon: Icons.percent_rounded,
                        color: t.accent,
                        value: '${(accuracy * 100).round()}%',
                        label: 'Точность',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatCard(
                        icon: Icons.star_rounded,
                        color: t.accentWarn,
                        value: '+$xp',
                        label: 'XP',
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // Кнопка «Продолжить»
                GestureDetector(
                  onTap: () {
                    // Возвращаемся на экран темы
                    if (topic != null) {
                      context.go('/topic/${topic.id}');
                    } else {
                      context.go('/');
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: t.accent,
                      borderRadius: BorderRadius.circular(t.radiusButton),
                      boxShadow: t.buttonShadow,
                    ),
                    child: Text(
                      'Продолжить',
                      style: ts.headlineLarge.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Повторить
                GestureDetector(
                  onTap: () =>
                      context.pushReplacement('/lesson/$subtopicId'),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: t.surfaceHighlight,
                      borderRadius: BorderRadius.circular(t.radiusButton),
                      border: Border.all(color: t.surfaceBorder),
                    ),
                    child: Text(
                      'Пройти ещё раз',
                      style: ts.headlineMedium.copyWith(
                          color: t.onSurfaceMuted),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  int _calcXp(double accuracy) {
    if (accuracy == 1.0) return 25;
    if (accuracy >= 0.8) return 20;
    if (accuracy >= 0.6) return 15;
    return 10;
  }
}

class _StatCard extends ConsumerWidget {
  final IconData icon;
  final Color color;
  final String value;
  final String label;

  const _StatCard({
    required this.icon,
    required this.color,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(appTokensProvider);
    final ts = AppTextStyles.of(t);

    return AppCard(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(value, style: ts.statNumber),
          Text(label, style: ts.statLabel, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
