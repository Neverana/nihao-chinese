// lib/features/block/block_screen.dart
//
// Экран блока — зигзаг-карточки тем на десктопе (3 в ряд),
// вертикальный список на мобиле.
// При нажатии на карточку — попап с уроками.

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_tokens.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_card.dart';
import '../../data/models/models.dart';
import '../../data/repositories/content_repository.dart';

// ── Provider ─────────────────────────────────────────────────────────────────

final blockScreenProvider =
    Provider.family<_BlockScreenData?, String>((ref, blockId) {
  final repo = ref.watch(contentRepositoryProvider);
  final block = repo.getBlock(blockId);
  if (block == null) return null;
  final topics = repo.getTopicsForBlock(blockId);
  final blockText = repo.getBlockText(blockId);
  return _BlockScreenData(
    block: block,
    topics: topics,
    blockText: blockText,
    repo: repo,
  );
});

class _BlockScreenData {
  final Block block;
  final List<Topic> topics;
  final BlockText? blockText;
  final ContentRepository repo;
  const _BlockScreenData({
    required this.block,
    required this.topics,
    required this.blockText,
    required this.repo,
  });
  ProgressStatus statusOf(String id) => repo.getStatus(id);
}

// ── Эмодзи/иконки тем по порядку ─────────────────────────────────────────────
// Можно расширять. Если тем больше — циклически.
const _topicEmojis = [
  ('🗣️', Color(0xFF5B8FFF)),
  ('🔢', Color(0xFF34D399)),
  ('👨‍👩‍👧', Color(0xFFA78BFA)),
  ('💼', Color(0xFFFB923C)),
  ('🍜', Color(0xFFF87171)),
  ('🚌', Color(0xFF60C0FF)),
  ('🛒', Color(0xFF34D399)),
  ('📚', Color(0xFFA78BFA)),
];

(String, Color) _emojiForIndex(int i) =>
    _topicEmojis[i % _topicEmojis.length];

// ── BlockScreen ───────────────────────────────────────────────────────────────

class BlockScreen extends ConsumerWidget {
  final String blockId;
  const BlockScreen({required this.blockId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(appTokensProvider);
    final ts = AppTextStyles.of(t);
    final data = ref.watch(blockScreenProvider(blockId));

    if (data == null) {
      return AppBackground(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(child: Text('Блок не найден', style: ts.displayMedium)),
        ),
      );
    }

    final width = MediaQuery.of(context).size.width;
    final isWide = width >= 700;

    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: _BlockTopBar(block: data.block),
        body: isWide
            ? _WideZigzagBody(data: data)
            : _MobileListBody(data: data),
      ),
    );
  }
}

// ── TopBar ────────────────────────────────────────────────────────────────────

class _BlockTopBar extends ConsumerWidget implements PreferredSizeWidget {
  final Block block;
  const _BlockTopBar({required this.block});

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(appTokensProvider);
    final ts = AppTextStyles.of(t);

    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: t.isGlass ? t.surface : t.navBarBackground,
        border: Border(bottom: BorderSide(color: t.navBarBorder, width: 1)),
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            GestureDetector(
              onTap: () => context.pop(),
              child: Container(
                width: 40, height: 40,
                margin: const EdgeInsets.only(left: 12),
                decoration: BoxDecoration(
                  color: t.surfaceHighlight,
                  shape: BoxShape.circle,
                  border: Border.all(color: t.surfaceBorder),
                ),
                child: Icon(Icons.arrow_back_rounded, color: t.onSurface, size: 20),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${block.emoji}  ${block.titleRu}',
                    style: ts.headlineLarge,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(block.titleZh,
                      style: ts.hanziSmall.copyWith(color: t.accent, fontSize: 12)),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: t.accentSoft,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(block.hskLevel,
                  style: ts.caption.copyWith(color: t.accent, fontWeight: FontWeight.w700)),
            ),
          ],
        ),
      ),
    );
  }
}

// ── MOBILE: вертикальный список ───────────────────────────────────────────────

class _MobileListBody extends ConsumerWidget {
  final _BlockScreenData data;
  const _MobileListBody({required this.data});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(appTokensProvider);
    final topics = data.topics;

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
      itemCount: topics.length + (data.blockText != null ? 1 : 0),
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, i) {
        if (i < topics.length) {
          final topic = topics[i];
          final status = data.statusOf(topic.id);
          final (emoji, color) = _emojiForIndex(i);
          return _TopicCardMobile(
            topic: topic,
            status: status,
            emoji: emoji,
            accentColor: color,
            onTap: status.isAccessible
                ? () => _showTopicPopup(context, ref, topic, data, color)
                : null,
          );
        }
        // Текст блока
        return _BlockTextCard(
          blockText: data.blockText!,
          onTap: () => context.push('/block-text/${data.block.id}'),
        );
      },
    );
  }
}

// ── DESKTOP: зигзаг ───────────────────────────────────────────────────────────
// Ряды по 3 карточки: нечётные ряды — слева направо, чётные — справа налево.

class _WideZigzagBody extends ConsumerWidget {
  final _BlockScreenData data;
  const _WideZigzagBody({required this.data});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final topics = data.topics;
    final rows = <List<(int, Topic)>>[];

    // Разбиваем на ряды по 3
    for (int i = 0; i < topics.length; i += 3) {
      var chunk = topics
          .sublist(i, math.min(i + 3, topics.length))
          .asMap()
          .entries
          .map((e) => (i + e.key, e.value))
          .toList();
      // Чётный ряд (0, 2, 4...) — слева направо
      // Нечётный — справа налево
      if ((i ~/ 3) % 2 == 1) chunk = chunk.reversed.toList();
      rows.add(chunk);
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(32, 28, 32, 48),
      child: Column(
        children: [
          for (int ri = 0; ri < rows.length; ri++) ...[
            _ZigzagRow(
              items: rows[ri],
              rowIndex: ri,
              data: data,
            ),
            if (ri < rows.length - 1)
              _ZigzagConnector(
                fromRow: rows[ri],
                toRow: rows[ri + 1],
                rowIndex: ri,
              ),
          ],
          // Текст блока
          if (data.blockText != null) ...[
            const SizedBox(height: 32),
            _BlockTextCard(
              blockText: data.blockText!,
              onTap: () => context.push('/block-text/${data.block.id}'),
            ),
          ],
        ],
      ),
    );
  }
}

// ── Ряд зигзага ──────────────────────────────────────────────────────────────

class _ZigzagRow extends ConsumerWidget {
  final List<(int, Topic)> items;
  final int rowIndex;
  final _BlockScreenData data;

  const _ZigzagRow({
    required this.items,
    required this.rowIndex,
    required this.data,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int ci = 0; ci < items.length; ci++) ...[
          Expanded(
            child: Builder(builder: (context) {
              final (globalIdx, topic) = items[ci];
              final status = data.statusOf(topic.id);
              final (emoji, color) = _emojiForIndex(globalIdx);
              return _TopicCardWide(
                topic: topic,
                status: status,
                emoji: emoji,
                accentColor: color,
                index: globalIdx,
                onTap: status.isAccessible
                    ? () => _showTopicPopup(context, ref, topic, data, color)
                    : null,
              );
            }),
          ),
          if (ci < items.length - 1)
            _HorizontalConnector(
              leftStatus: data.statusOf(items[ci].$2.id),
              rightStatus: data.statusOf(items[ci + 1].$2.id),
            ),
        ],
        // Заполнитель если карточек меньше 3
        for (int fi = items.length; fi < 3; fi++) ...[
          if (items.isNotEmpty) _HorizontalConnector(
            leftStatus: ProgressStatus.locked,
            rightStatus: ProgressStatus.locked,
          ),
          const Expanded(child: SizedBox()),
        ],
      ],
    );
  }
}

// ── Горизонтальный коннектор между карточками ─────────────────────────────────

class _HorizontalConnector extends ConsumerWidget {
  final ProgressStatus leftStatus;
  final ProgressStatus rightStatus;
  const _HorizontalConnector({required this.leftStatus, required this.rightStatus});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(appTokensProvider);
    final active = leftStatus.isAccessible && rightStatus != ProgressStatus.locked;
    return SizedBox(
      width: 32,
      height: 120,
      child: Center(
        child: CustomPaint(
          size: const Size(32, 3),
          painter: _DashedLinePainter(
            color: active ? t.accent : t.onSurfaceDisabled,
            horizontal: true,
          ),
        ),
      ),
    );
  }
}

// ── Вертикальный коннектор между рядами ──────────────────────────────────────

class _ZigzagConnector extends ConsumerWidget {
  final List<(int, Topic)> fromRow;
  final List<(int, Topic)> toRow;
  final int rowIndex;

  const _ZigzagConnector({
    required this.fromRow,
    required this.toRow,
    required this.rowIndex,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(appTokensProvider);
    // Соединяем последнюю карточку текущего ряда с первой следующего
    // Чётный ряд заканчивается справа, нечётный — слева
    final isEvenRow = rowIndex % 2 == 0;
    final lastStatus = fromRow.isNotEmpty
        ? ProgressStatus.available // упрощённо
        : ProgressStatus.locked;

    return SizedBox(
      height: 40,
      child: Row(
        children: [
          if (isEvenRow) const Spacer(),
          SizedBox(
            width: 100,
            child: CustomPaint(
              painter: _DashedLinePainter(
                color: t.accent.withValues(alpha: 0.5),
                horizontal: false,
              ),
              size: const Size(3, 40),
            ),
          ),
          if (!isEvenRow) const Spacer(),
        ],
      ),
    );
  }
}

// ── Художник пунктирных линий ─────────────────────────────────────────────────

class _DashedLinePainter extends CustomPainter {
  final Color color;
  final bool horizontal;
  const _DashedLinePainter({required this.color, required this.horizontal});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    const dashLen = 6.0;
    const gapLen = 5.0;
    final total = horizontal ? size.width : size.height;
    double pos = 0;

    while (pos < total) {
      final end = math.min(pos + dashLen, total);
      canvas.drawLine(
        horizontal ? Offset(pos, size.height / 2) : Offset(size.width / 2, pos),
        horizontal ? Offset(end, size.height / 2) : Offset(size.width / 2, end),
        paint,
      );
      pos += dashLen + gapLen;
    }
  }

  @override
  bool shouldRepaint(_DashedLinePainter old) => old.color != color;
}

// ─────────────────────────────────────────────────────────────────────────────
// КАРТОЧКА ТЕМЫ — МОБАЙЛ
// ─────────────────────────────────────────────────────────────────────────────

class _TopicCardMobile extends ConsumerStatefulWidget {
  final Topic topic;
  final ProgressStatus status;
  final String emoji;
  final Color accentColor;
  final VoidCallback? onTap;

  const _TopicCardMobile({
    required this.topic,
    required this.status,
    required this.emoji,
    required this.accentColor,
    this.onTap,
  });

  @override
  ConsumerState<_TopicCardMobile> createState() => _TopicCardMobileState();
}

class _TopicCardMobileState extends ConsumerState<_TopicCardMobile>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 110));
    _scale = Tween(begin: 1.0, end: 0.97)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final t = ref.watch(appTokensProvider);
    final ts = AppTextStyles.of(t);
    final topic = widget.topic;
    final isLocked = widget.status == ProgressStatus.locked;
    final color = isLocked ? t.onSurfaceDisabled : widget.accentColor;

    final completedSubs = topic.subtopics
        .where((s) => widget.status == ProgressStatus.completed)
        .length;
    final totalSubs = topic.subtopics.length;

    return AnimatedBuilder(
      animation: _scale,
      builder: (_, child) => Transform.scale(scale: _scale.value, child: child),
      child: GestureDetector(
        onTapDown: widget.onTap != null ? (_) => _ctrl.forward() : null,
        onTapUp: widget.onTap != null ? (_) => _ctrl.reverse() : null,
        onTapCancel: widget.onTap != null ? () => _ctrl.reverse() : null,
        onTap: widget.onTap,
        child: AppCard(
          padding: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Шапка с эмодзи и цветом
              Container(
                height: 80,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: isLocked ? 0.06 : 0.12),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(17)),
                ),
                child: Center(
                  child: Text(
                    isLocked ? '🔒' : widget.emoji,
                    style: const TextStyle(fontSize: 36),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Тема ${topic.order}: ${topic.titleRu}',
                      style: ts.headlineMedium.copyWith(
                        color: isLocked ? t.onSurfaceDisabled : t.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      topic.descriptionRu,
                      style: ts.bodyMuted.copyWith(
                        color: isLocked ? t.onSurfaceDisabled : t.onSurfaceMuted,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                    _TopicCardFooter(
                      topic: topic,
                      status: widget.status,
                      color: color,
                      isLocked: isLocked,
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

// ─────────────────────────────────────────────────────────────────────────────
// КАРТОЧКА ТЕМЫ — ДЕСКТОП (вертикальная, для зигзага)
// ─────────────────────────────────────────────────────────────────────────────

class _TopicCardWide extends ConsumerStatefulWidget {
  final Topic topic;
  final ProgressStatus status;
  final String emoji;
  final Color accentColor;
  final int index;
  final VoidCallback? onTap;

  const _TopicCardWide({
    required this.topic,
    required this.status,
    required this.emoji,
    required this.accentColor,
    required this.index,
    this.onTap,
  });

  @override
  ConsumerState<_TopicCardWide> createState() => _TopicCardWideState();
}

class _TopicCardWideState extends ConsumerState<_TopicCardWide>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 110));
    _scale = Tween(begin: 1.0, end: 0.97)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final t = ref.watch(appTokensProvider);
    final ts = AppTextStyles.of(t);
    final topic = widget.topic;
    final isLocked = widget.status == ProgressStatus.locked;
    final color = isLocked ? t.onSurfaceDisabled : widget.accentColor;

    return AnimatedBuilder(
      animation: _scale,
      builder: (_, child) => Transform.scale(scale: _scale.value, child: child),
      child: GestureDetector(
        onTapDown: widget.onTap != null ? (_) => _ctrl.forward() : null,
        onTapUp: widget.onTap != null ? (_) => _ctrl.reverse() : null,
        onTapCancel: widget.onTap != null ? () => _ctrl.reverse() : null,
        onTap: widget.onTap,
        child: AppCard(
          padding: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Иллюстрация
              Container(
                height: 100,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: isLocked ? 0.06 : 0.13),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(17)),
                ),
                child: Stack(
                  children: [
                    // Фоновый иероглиф
                    Center(
                      child: Text(
                        topic.titleZh.isNotEmpty
                            ? topic.titleZh.characters.first
                            : '字',
                        style: TextStyle(
                          fontFamily: 'NotoSansSC',
                          fontSize: 52,
                          color: color.withValues(alpha: 0.15),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    // Эмодзи поверх
                    Center(
                      child: Text(
                        isLocked ? '🔒' : widget.emoji,
                        style: const TextStyle(fontSize: 36),
                      ),
                    ),
                    // Номер темы
                    Positioned(
                      top: 8, left: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: isLocked ? 0.1 : 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${widget.index + 1}',
                          style: ts.caption.copyWith(
                            color: isLocked ? t.onSurfaceDisabled : color,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    // Статус
                    if (!isLocked)
                      Positioned(
                        top: 8, right: 10,
                        child: Icon(
                          widget.status == ProgressStatus.completed
                              ? Icons.check_circle_rounded
                              : widget.status == ProgressStatus.inProgress
                                  ? Icons.play_circle_rounded
                                  : Icons.radio_button_unchecked_rounded,
                          color: widget.status == ProgressStatus.completed
                              ? t.accentSuccess
                              : color,
                          size: 18,
                        ),
                      ),
                  ],
                ),
              ),
              // Контент
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      topic.titleRu,
                      style: ts.headlineMedium.copyWith(
                        color: isLocked ? t.onSurfaceDisabled : t.onSurface,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      topic.descriptionRu,
                      style: ts.bodyMuted.copyWith(
                        color: isLocked ? t.onSurfaceDisabled : t.onSurfaceMuted,
                        fontSize: 11,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 10),
                    _TopicCardFooter(
                      topic: topic,
                      status: widget.status,
                      color: color,
                      isLocked: isLocked,
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

// ── Футер карточки (прогресс-бар + метрики) ───────────────────────────────────

class _TopicCardFooter extends ConsumerWidget {
  final Topic topic;
  final ProgressStatus status;
  final Color color;
  final bool isLocked;

  const _TopicCardFooter({
    required this.topic,
    required this.status,
    required this.color,
    required this.isLocked,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(appTokensProvider);
    final ts = AppTextStyles.of(t);

    final totalSubs = topic.subtopics.length;
    // Считаем пройденные уроки через статус подтем
    // Упрощённо: если тема completed — все уроки пройдены
    final completedSubs = status == ProgressStatus.completed
        ? totalSubs
        : status == ProgressStatus.inProgress
            ? (totalSubs / 2).floor()
            : 0;

    final totalWords = topic.words.length;
    final learnedWords = status == ProgressStatus.completed
        ? totalWords
        : status == ProgressStatus.inProgress
            ? (totalWords * 0.5).floor()
            : 0;

    final progress = totalSubs == 0
        ? 0.0
        : completedSubs / totalSubs;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Прогресс бар
        ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child: LinearProgressIndicator(
            value: isLocked ? 0 : progress,
            minHeight: 4,
            backgroundColor: t.surfaceBorder,
            valueColor: AlwaysStoppedAnimation(isLocked ? t.onSurfaceDisabled : color),
          ),
        ),
        const SizedBox(height: 8),
        // Метрики
        Row(
          children: [
            Icon(Icons.play_lesson_outlined,
                size: 11, color: isLocked ? t.onSurfaceDisabled : t.onSurfaceMuted),
            const SizedBox(width: 3),
            Text(
              '$completedSubs/$totalSubs ур.',
              style: ts.caption.copyWith(
                  color: isLocked ? t.onSurfaceDisabled : t.onSurfaceMuted,
                  fontSize: 10),
            ),
            const SizedBox(width: 10),
            Icon(Icons.translate_rounded,
                size: 11, color: isLocked ? t.onSurfaceDisabled : t.onSurfaceMuted),
            const SizedBox(width: 3),
            Text(
              '$learnedWords/$totalWords сл.',
              style: ts.caption.copyWith(
                  color: isLocked ? t.onSurfaceDisabled : t.onSurfaceMuted,
                  fontSize: 10),
            ),
          ],
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ПОПАП С УРОКАМИ
// ─────────────────────────────────────────────────────────────────────────────

void _showTopicPopup(
  BuildContext context,
  WidgetRef ref,
  Topic topic,
  _BlockScreenData data,
  Color accentColor,
) {
  final width = MediaQuery.of(context).size.width;
  final isMobile = width < 700;

  showDialog(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.55),
    barrierDismissible: true,
    builder: (_) => ProviderScope(
      parent: ProviderScope.containerOf(context),
      child: _TopicPopup(
        topic: topic,
        data: data,
        accentColor: accentColor,
        isMobile: isMobile,
      ),
    ),
  );
}

class _TopicPopup extends ConsumerWidget {
  final Topic topic;
  final _BlockScreenData data;
  final Color accentColor;
  final bool isMobile;

  const _TopicPopup({
    required this.topic,
    required this.data,
    required this.accentColor,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(appTokensProvider);
    final ts = AppTextStyles.of(t);
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    final popupWidth = isMobile ? width : width * 0.8;
    final popupHeight = isMobile ? height * 0.92 : height * 0.8;

    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: popupWidth,
          height: popupHeight,
          decoration: BoxDecoration(
            color: t.isGlass
                ? t.surface.withValues(alpha: 0.97)
                : t.navBarBackground,
            borderRadius: BorderRadius.circular(isMobile ? 0 : 24),
            border: Border.all(color: t.surfaceBorder, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 40,
                offset: const Offset(0, 16),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(isMobile ? 0 : 23),
            child: Column(
              children: [
                // Заголовок попапа
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 20, 16, 16),
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.1),
                    border: Border(
                        bottom: BorderSide(color: t.surfaceBorder, width: 1)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 48, height: 48,
                        decoration: BoxDecoration(
                          color: accentColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Center(
                          child: Text(
                            topic.titleZh.isNotEmpty
                                ? topic.titleZh.characters.first
                                : '字',
                            style: TextStyle(
                              fontFamily: 'NotoSansSC',
                              fontSize: 26,
                              color: accentColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(topic.titleRu, style: ts.displayMedium),
                            Text(topic.situationRu,
                                style: ts.bodyMuted, maxLines: 2,
                                overflow: TextOverflow.ellipsis),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          width: 36, height: 36,
                          decoration: BoxDecoration(
                            color: t.surfaceHighlight,
                            shape: BoxShape.circle,
                            border: Border.all(color: t.surfaceBorder),
                          ),
                          child: Icon(Icons.close_rounded,
                              color: t.onSurfaceMuted, size: 18),
                        ),
                      ),
                    ],
                  ),
                ),

                // Список уроков
                Expanded(
                  child: topic.subtopics.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('🚧', style: const TextStyle(fontSize: 48)),
                              const SizedBox(height: 12),
                              Text('Уроки добавляются',
                                  style: ts.displayMedium),
                              Text('Контент этой темы в разработке',
                                  style: ts.bodyMuted),
                            ],
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.all(16),
                          itemCount: topic.subtopics.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 10),
                          itemBuilder: (ctx, i) {
                            final sub = topic.subtopics[i];
                            final status = data.statusOf(sub.id);
                            final previewWords = sub.wordIds
                                .take(3)
                                .map((id) => data.repo.getWord(id))
                                .whereType<Word>()
                                .map((w) => w.hanzi)
                                .join('、');

                            return _LessonRow(
                              subtopic: sub,
                              status: status,
                              accentColor: accentColor,
                              previewWords: previewWords,
                              onStart: status.isAccessible
                                  ? () {
                                      Navigator.of(context).pop();
                                      context.push('/lesson/${sub.id}');
                                    }
                                  : null,
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Строка урока в попапе ─────────────────────────────────────────────────────

class _LessonRow extends ConsumerWidget {
  final Subtopic subtopic;
  final ProgressStatus status;
  final Color accentColor;
  final String previewWords;
  final VoidCallback? onStart;

  const _LessonRow({
    required this.subtopic,
    required this.status,
    required this.accentColor,
    required this.previewWords,
    this.onStart,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(appTokensProvider);
    final ts = AppTextStyles.of(t);
    final isLocked = status == ProgressStatus.locked;
    final isCompleted = status == ProgressStatus.completed;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: t.surface,
        borderRadius: BorderRadius.circular(t.radiusButton),
        border: Border.all(
          color: isCompleted
              ? t.accentSuccess.withValues(alpha: 0.4)
              : isLocked
                  ? t.surfaceBorder
                  : accentColor.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          // Номер
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              color: isLocked
                  ? t.surfaceHighlight
                  : isCompleted
                      ? t.accentSuccess.withValues(alpha: 0.15)
                      : accentColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: isCompleted
                  ? Icon(Icons.check_rounded, color: t.accentSuccess, size: 18)
                  : isLocked
                      ? Icon(Icons.lock_outline_rounded,
                          color: t.onSurfaceDisabled, size: 16)
                      : Text(
                          '${subtopic.order}',
                          style: ts.headlineMedium.copyWith(color: accentColor),
                        ),
            ),
          ),
          const SizedBox(width: 12),

          // Название + превью слов
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subtopic.titleRu,
                  style: ts.headlineMedium.copyWith(
                    color: isLocked ? t.onSurfaceDisabled : t.onSurface,
                  ),
                ),
                if (previewWords.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    previewWords,
                    style: TextStyle(
                      fontFamily: 'NotoSansSC',
                      fontSize: 13,
                      color: isLocked ? t.onSurfaceDisabled : accentColor,
                    ),
                  ),
                ],
                const SizedBox(height: 3),
                Row(
                  children: [
                    Icon(Icons.schedule_rounded,
                        size: 11, color: t.onSurfaceMuted),
                    const SizedBox(width: 3),
                    Text('~${subtopic.estimatedMinutes} мин',
                        style: ts.caption.copyWith(fontSize: 10)),
                    const SizedBox(width: 10),
                    Icon(Icons.translate_rounded,
                        size: 11, color: t.onSurfaceMuted),
                    const SizedBox(width: 3),
                    Text('${subtopic.wordIds.length} слов',
                        style: ts.caption.copyWith(fontSize: 10)),
                  ],
                ),
              ],
            ),
          ),

          // Кнопка Старт
          if (!isLocked && onStart != null)
            GestureDetector(
              onTap: onStart,
              child: Container(
                width: 44, height: 44,
                decoration: BoxDecoration(
                  color: isCompleted
                      ? t.accentSuccess.withValues(alpha: 0.15)
                      : accentColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isCompleted
                        ? t.accentSuccess.withValues(alpha: 0.4)
                        : accentColor.withValues(alpha: 0.4),
                    width: 1.5,
                  ),
                ),
                child: Icon(
                  isCompleted
                      ? Icons.replay_rounded
                      : Icons.play_arrow_rounded,
                  color: isCompleted ? t.accentSuccess : accentColor,
                  size: 24,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ── Карточка текста блока ─────────────────────────────────────────────────────

class _BlockTextCard extends ConsumerWidget {
  final BlockText blockText;
  final VoidCallback onTap;
  const _BlockTextCard({required this.blockText, required this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(appTokensProvider);
    final ts = AppTextStyles.of(t);

    return GestureDetector(
      onTap: onTap,
      child: AppCard(
        child: Row(
          children: [
            Container(
              width: 48, height: 48,
              decoration: BoxDecoration(
                color: t.accentSecondary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.article_outlined,
                  color: t.accentSecondary, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(blockText.titleZh,
                      style: ts.hanziSmall.copyWith(color: t.accentSecondary)),
                  Text(blockText.titleRu, style: ts.headlineMedium),
                  Text('Читать текст с заданиями · ~10 мин',
                      style: ts.bodyMuted),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: t.onSurfaceMuted, size: 22),
          ],
        ),
      ),
    );
  }
}
