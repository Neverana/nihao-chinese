// lib/features/home/widgets/stats_bar.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../providers/home_provider.dart';

class StatsBar extends ConsumerWidget {
  final UserStats stats;
  const StatsBar({required this.stats, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(appTokensProvider);

    return Row(
      children: [
        Expanded(child: _StatCell(
          icon: Icons.menu_book_rounded,
          iconColor: t.accent,
          value: '${stats.wordsLearned}',
          label: 'Слов изучено',
        )),
        const SizedBox(width: 8),
        Expanded(child: _StatCell(
          icon: Icons.local_fire_department_rounded,
          iconColor: t.accentWarn,
          value: '${stats.streakDays}',
          label: 'Дней подряд',
        )),
        const SizedBox(width: 8),
        Expanded(child: _StatCell(
          icon: Icons.access_time_rounded,
          iconColor: t.accentSuccess,
          value: '${stats.totalHours}ч',
          label: 'Время занятий',
        )),
      ],
    );
  }
}

class _StatCell extends ConsumerWidget {
  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;

  const _StatCell({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(appTokensProvider);
    final ts = AppTextStyles.of(t);

    return AppCard(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      child: Column(
        children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          const SizedBox(height: 8),
          Text(value, style: ts.statNumber),
          const SizedBox(height: 2),
          Text(label, style: ts.statLabel, textAlign: TextAlign.center, maxLines: 2),
        ],
      ),
    );
  }
}
