// lib/features/home/widgets/block_card.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../../../data/models/block_model.dart';

class BlockCard extends ConsumerStatefulWidget {
  final BlockModel block;
  final VoidCallback? onTap;

  const BlockCard({required this.block, this.onTap, super.key});

  @override
  ConsumerState<BlockCard> createState() => _BlockCardState();
}

class _BlockCardState extends ConsumerState<BlockCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _pressCtrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _pressCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _scale = Tween<double>(begin: 1.0, end: 0.975).animate(
      CurvedAnimation(parent: _pressCtrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pressCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = ref.watch(appTokensProvider);
    final ts = AppTextStyles.of(t);
    final block = widget.block;
    final isLocked = block.status == ProgressStatus.locked;
    final isAccessible = block.status.isAccessible ||
        block.status == ProgressStatus.completed;

    return AnimatedBuilder(
      animation: _scale,
      builder: (ctx, child) => Transform.scale(scale: _scale.value, child: child),
      child: GestureDetector(
        onTapDown: isAccessible ? (_) => _pressCtrl.forward() : null,
        onTapUp: isAccessible ? (_) => _pressCtrl.reverse() : null,
        onTapCancel: isAccessible ? () => _pressCtrl.reverse() : null,
        onTap: isAccessible ? widget.onTap : null,
        child: AppCard(
          padding: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Шапка блока ──────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 48, height: 48,
                      decoration: BoxDecoration(
                        color: isLocked
                            ? t.surfaceHighlight
                            : t.accentSoft,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isLocked
                              ? t.surfaceBorder
                              : t.accent.withValues(alpha: 0.25),
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          isLocked ? '🔒' : block.emoji,
                          style: const TextStyle(fontSize: 24),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Блок ${block.order}: ${block.titleRu}',
                                  style: ts.headlineLarge.copyWith(
                                    color: isLocked ? t.onSurfaceDisabled : t.onSurface,
                                  ),
                                ),
                              ),
                              AppChip(
                                label: block.hskLevel,
                                color: isLocked ? t.onSurfaceDisabled : t.accent,
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(block.descriptionRu, style: ts.bodyMuted),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // ── Прогресс ─────────────────────────────────────────────────
              if (block.topics.isNotEmpty && !isLocked) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _BlockProgressSection(block: block, tokens: t, ts: ts),
                ),
                const SizedBox(height: 14),
              ],

              // ── Заблокировано ─────────────────────────────────────────────
              if (isLocked)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Row(
                    children: [
                      Icon(Icons.lock_outline_rounded, size: 14, color: t.onSurfaceDisabled),
                      const SizedBox(width: 6),
                      Text(
                        'Доступно после прохождения блока ${block.order - 1}',
                        style: ts.bodyMuted.copyWith(color: t.onSurfaceDisabled),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BlockProgressSection extends StatelessWidget {
  final BlockModel block;
  final AppTokens tokens;
  final AppTextStyles ts;

  const _BlockProgressSection({
    required this.block,
    required this.tokens,
    required this.ts,
  });

  @override
  Widget build(BuildContext context) {
    final t = tokens;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Прогресс блока', style: ts.caption),
            Text('${block.completedTopics}/${block.totalTopics} тем',
                style: ts.labelAccent),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: block.progressFraction,
            minHeight: 5,
            backgroundColor: t.surfaceBorder,
            valueColor: AlwaysStoppedAnimation(t.accent),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 6,
          children: block.topics.map((topic) =>
              _TopicChip(topic: topic, tokens: t, ts: ts)).toList(),
        ),
      ],
    );
  }
}

class _TopicChip extends StatelessWidget {
  final TopicModel topic;
  final AppTokens tokens;
  final AppTextStyles ts;

  const _TopicChip({
    required this.topic,
    required this.tokens,
    required this.ts,
  });

  @override
  Widget build(BuildContext context) {
    final t = tokens;

    final (Color bg, Color fg, IconData icon) = switch (topic.status) {
      ProgressStatus.completed  => (t.accentSuccess.withValues(alpha: 0.15), t.accentSuccess, Icons.check_rounded),
      ProgressStatus.inProgress => (t.accent.withValues(alpha: 0.12),        t.accent,        Icons.play_arrow_rounded),
      ProgressStatus.available  => (t.surfaceHighlight,                       t.onSurfaceMuted, Icons.arrow_forward_rounded),
      ProgressStatus.locked     => (Colors.transparent,                       t.onSurfaceDisabled, Icons.lock_outline_rounded),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(t.radiusChip),
        border: Border.all(color: fg.withValues(alpha: 0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: fg),
          const SizedBox(width: 4),
          Text('Тема ${topic.order}',
              style: ts.label.copyWith(color: fg, fontSize: 11)),
        ],
      ),
    );
  }
}
