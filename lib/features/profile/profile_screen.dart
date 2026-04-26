// lib/features/profile/profile_screen.dart
// FIX: статистика на ПК — адаптивный размер карточек
// На широком экране используем Row вместо GridView

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_tokens.dart';
import '../../core/theme/app_theme_mode.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_card.dart';
import '../../data/repositories/content_repository.dart';
import '../../data/models/models.dart';
import '../home/providers/home_provider.dart';

class _Achievement {
  final String id;
  final String emoji;
  final String titleRu;
  final String descriptionRu;
  final bool Function(ContentRepository) isUnlocked;
  const _Achievement({
    required this.id,
    required this.emoji,
    required this.titleRu,
    required this.descriptionRu,
    required this.isUnlocked,
  });
}

final _achievements = [
  _Achievement(
      id: 'first_lesson',
      emoji: '📝',
      titleRu: 'Первый шаг',
      descriptionRu: 'Пройди первый урок',
      isUnlocked: (repo) {
        final topics = repo.getTopicsForBlock('block_1');
        if (topics.isEmpty) return false;
        final subs = topics.first.subtopics;
        if (subs.isEmpty) return false;
        return repo.getStatus(subs.first.id) == ProgressStatus.completed;
      }),
  _Achievement(
      id: 'words_10',
      emoji: '📖',
      titleRu: '10 слов',
      descriptionRu: 'Изучи 10 слов',
      isUnlocked: (_) => false),
  _Achievement(
      id: 'words_50',
      emoji: '📚',
      titleRu: '50 слов',
      descriptionRu: 'Изучи 50 слов',
      isUnlocked: (_) => false),
  _Achievement(
      id: 'topic_done',
      emoji: '🏆',
      titleRu: 'Первый тест',
      descriptionRu: 'Пройди итоговый тест',
      isUnlocked: (_) => false),
  _Achievement(
      id: 'streak_7',
      emoji: '🔥',
      titleRu: 'На огне!',
      descriptionRu: '7 дней подряд',
      isUnlocked: (_) => false),
  _Achievement(
      id: 'callig_5',
      emoji: '✍️',
      titleRu: 'Каллиграф',
      descriptionRu: 'Напиши 5 иероглифов',
      isUnlocked: (_) => false),
  _Achievement(
      id: 'block_1_done',
      emoji: '🌟',
      titleRu: 'Мастер HSK 1',
      descriptionRu: 'Завершить Блок 1',
      isUnlocked: (repo) =>
          repo.getStatus('block_1') == ProgressStatus.completed),
  _Achievement(
      id: 'streak_30',
      emoji: '⚡',
      titleRu: 'Неудержимый',
      descriptionRu: '30 дней подряд',
      isUnlocked: (_) => false),
];

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(userStatsProvider);
    final repo = ref.watch(contentRepositoryProvider);
    final blocks = repo.getAllBlocks();

    int completedTopics = 0;
    int totalTopics = 0;
    for (final block in blocks) {
      final topics = repo.getTopicsForBlock(block.id);
      totalTopics += topics.length;
      for (final topic in topics) {
        if (repo.getStatus(topic.id) == ProgressStatus.completed) {
          completedTopics++;
        }
      }
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 48),
      children: [
        _ProfileHeader(stats: stats),
        const SizedBox(height: 20),
        SectionHeader('Статистика'),
        const SizedBox(height: 8),
        // FIX: адаптивный layout
        _AdaptiveStatsGrid(
          stats: stats,
          completedTopics: completedTopics,
          totalTopics: totalTopics,
        ),
        const SizedBox(height: 24),
        SectionHeader('Прогресс по курсу'),
        const SizedBox(height: 8),
        _CourseProgress(repo: repo, blocks: blocks),
        const SizedBox(height: 24),
        SectionHeader('Достижения'),
        const SizedBox(height: 8),
        _AchievementsGrid(repo: repo),
        const SizedBox(height: 24),
        SectionHeader('Настройки'),
        const SizedBox(height: 8),
        _SettingsSection(),
      ],
    );
  }
}

class _ProfileHeader extends ConsumerWidget {
  final UserStats stats;
  const _ProfileHeader({required this.stats});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(appTokensProvider);
    final ts = AppTextStyles.of(t);

    return AppCard(
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: t.accentSoft,
              shape: BoxShape.circle,
              border:
                  Border.all(color: t.accent.withValues(alpha: 0.3), width: 2),
            ),
            child:
                const Center(child: Text('🐉', style: TextStyle(fontSize: 28))),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Ученик', style: ts.displayMedium),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    _SmallBadge(
                      icon: Icons.local_fire_department_rounded,
                      label: '${stats.streakDays} дней',
                      color: t.accentWarn,
                    ),
                    _SmallBadge(
                      icon: Icons.star_rounded,
                      label: '${stats.starCount} XP',
                      color: const Color(0xFFFFCC00),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SmallBadge extends ConsumerWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _SmallBadge(
      {required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(appTokensProvider);
    final ts = AppTextStyles.of(t);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, color: color, size: 13),
        const SizedBox(width: 3),
        Text(label,
            style:
                ts.caption.copyWith(color: color, fontWeight: FontWeight.w700)),
      ]),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// FIX: адаптивная сетка статистики
// Мобайл (< 600px): 2×2 GridView с childAspectRatio: 2.0
// Десктоп (≥ 600px): горизонтальная Row, высота фиксированная 80px
// ─────────────────────────────────────────────────────────────────────────────

class _AdaptiveStatsGrid extends ConsumerWidget {
  final UserStats stats;
  final int completedTopics;
  final int totalTopics;

  const _AdaptiveStatsGrid({
    required this.stats,
    required this.completedTopics,
    required this.totalTopics,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(appTokensProvider);
    final width = MediaQuery.of(context).size.width;
    final isWide = width >= 600;

    final items = [
      (
        Icons.menu_book_rounded,
        t.accent,
        '${stats.wordsLearned}',
        'Слов изучено'
      ),
      (
        Icons.local_fire_department_rounded,
        t.accentWarn,
        '${stats.streakDays}',
        'Дней подряд'
      ),
      (
        Icons.access_time_rounded,
        t.accentSuccess,
        '${stats.totalHours}ч',
        'Время занятий'
      ),
      (
        Icons.flag_rounded,
        t.accentSecondary,
        '$completedTopics/$totalTopics',
        'Тем пройдено'
      ),
    ];

    if (isWide) {
      // Десктоп: горизонтальная строка, фиксированная высота
      return SizedBox(
        height: 80,
        child: Row(
          children: items.indexed.map((rec) {
            final i = rec.$1;
            final item = rec.$2;
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: i < items.length - 1 ? 10 : 0),
                child: _StatCard(item: item),
              ),
            );
          }).toList(),
        ),
      );
    }

    // Мобайл: 2×2 GridView
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 2.4,
      children: items.map((item) => _StatCard(item: item)).toList(),
    );
  }
}

class _StatCard extends ConsumerWidget {
  final (IconData, Color, String, String) item;
  const _StatCard({required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(appTokensProvider);
    final ts = AppTextStyles.of(t);

    return AppCard(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: item.$2.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(item.$1, color: item.$2, size: 16),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(item.$3,
                    style: ts.statNumber.copyWith(fontSize: 18),
                    overflow: TextOverflow.ellipsis),
                Text(item.$4,
                    style: ts.statLabel,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CourseProgress extends ConsumerWidget {
  final ContentRepository repo;
  final List<Block> blocks;
  const _CourseProgress({required this.repo, required this.blocks});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(appTokensProvider);
    final ts = AppTextStyles.of(t);

    return AppCard(
      child: Column(
        children: blocks.map((block) {
          final topics = repo.getTopicsForBlock(block.id);
          final done = topics
              .where((tp) => repo.getStatus(tp.id) == ProgressStatus.completed)
              .length;
          final total = topics.length;
          final progress = total == 0 ? 0.0 : done / total;
          final isLocked = repo.getStatus(block.id) == ProgressStatus.locked;

          return Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(block.emoji, style: const TextStyle(fontSize: 18)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(block.titleRu,
                          style: ts.headlineMedium.copyWith(
                              color: isLocked
                                  ? t.onSurfaceDisabled
                                  : t.onSurface)),
                    ),
                    Text(
                      isLocked ? '🔒' : '$done/$total',
                      style: ts.caption.copyWith(
                          color: isLocked ? t.onSurfaceDisabled : t.accent,
                          fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: isLocked ? 0 : progress,
                    minHeight: 6,
                    backgroundColor: t.surfaceBorder,
                    valueColor: AlwaysStoppedAnimation(
                        isLocked ? t.onSurfaceDisabled : t.accent),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _AchievementsGrid extends ConsumerWidget {
  final ContentRepository repo;
  const _AchievementsGrid({required this.repo});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(appTokensProvider);
    final ts = AppTextStyles.of(t);

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final crossAxisCount = width > 900
            ? 8
            : width > 600
                ? 6
                : 4;
        final childAspectRatio = width > 900 ? 1.0 : 0.85;

        return GridView.count(
          crossAxisCount: crossAxisCount,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: childAspectRatio,
          children: _achievements.map((ach) {
            final unlocked = ach.isUnlocked(repo);
            return GestureDetector(
              onTap: () => showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  backgroundColor: t.surface,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(unlocked ? ach.emoji : '🔒',
                          style: const TextStyle(fontSize: 48)),
                      const SizedBox(height: 12),
                      Text(ach.titleRu,
                          style: ts.displayMedium, textAlign: TextAlign.center),
                      const SizedBox(height: 6),
                      Text(ach.descriptionRu,
                          style: ts.bodyMuted, textAlign: TextAlign.center),
                      const SizedBox(height: 8),
                      Text(unlocked ? '✅ Получено!' : '🔒 Не получено',
                          style: ts.label.copyWith(
                              color: unlocked
                                  ? t.accentSuccess
                                  : t.onSurfaceMuted)),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child:
                          Text('Ок', style: ts.label.copyWith(color: t.accent)),
                    ),
                  ],
                ),
              ),
              child: AppCard(
                padding: const EdgeInsets.all(6),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(unlocked ? ach.emoji : '🔒',
                        style: TextStyle(
                            fontSize: 20,
                            color: unlocked ? null : t.onSurfaceDisabled)),
                    const SizedBox(height: 2),
                    Text(ach.titleRu,
                        style: ts.caption.copyWith(
                          color: unlocked ? t.onSurface : t.onSurfaceDisabled,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

class _SettingsSection extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(appTokensProvider);
    final ts = AppTextStyles.of(t);
    final currentMode = ref.watch(appThemeModeProvider);

    final themes = [
      (
        AppThemeMode.lightGlass,
        'Light\nGlass',
        [
          const Color(0xFFC8D8FF),
          const Color(0xFFE0C8FF),
          const Color(0xFFC8F0E8)
        ]
      ),
      (
        AppThemeMode.darkGlass,
        'Dark\nGlass',
        [
          const Color(0xFF0D0D1A),
          const Color(0xFF111830),
          const Color(0xFF0A1A0F)
        ]
      ),
      (
        AppThemeMode.lightMaterial,
        'Light\nMaterial',
        [
          const Color(0xFFFFF4EC),
          const Color(0xFFFCF0FF),
          const Color(0xFFECF4FF)
        ]
      ),
      (
        AppThemeMode.blackMaterial,
        'Blue\nMaterial',
        [
          const Color(0xFF0F1621),
          const Color(0xFF1C2535),
          const Color(0xFF243040)
        ]
      ),
    ];

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Тема оформления', style: ts.headlineMedium),
          const SizedBox(height: 14),
          Row(
            children: themes.map((th) {
              final isSelected = currentMode == th.$1;
              return Expanded(
                child: GestureDetector(
                  onTap: () =>
                      ref.read(appThemeModeProvider.notifier).setTheme(th.$1),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: Column(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          height: 52,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: th.$3,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected ? t.accent : t.surfaceBorder,
                              width: isSelected ? 2.5 : 1,
                            ),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                        color: t.accent.withValues(alpha: 0.25),
                                        blurRadius: 10,
                                        offset: const Offset(0, 3))
                                  ]
                                : [],
                          ),
                          child: isSelected
                              ? Center(
                                  child: Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                        color: t.accent,
                                        shape: BoxShape.circle),
                                    child: const Icon(Icons.check_rounded,
                                        color: Colors.white, size: 13),
                                  ),
                                )
                              : null,
                        ),
                        const SizedBox(height: 5),
                        Text(th.$2,
                            style: ts.caption.copyWith(
                              color: isSelected ? t.accent : t.onSurfaceMuted,
                              fontWeight: isSelected
                                  ? FontWeight.w700
                                  : FontWeight.w400,
                            ),
                            textAlign: TextAlign.center),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
