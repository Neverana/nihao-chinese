// lib/features/topic/topic_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/audio/audio_service.dart';
import '../../core/theme/app_tokens.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_card.dart';
import '../../data/models/models.dart';
import '../../data/repositories/content_repository.dart';

// ── Provider ──────────────────────────────────────────────────────────────────

final topicScreenDataProvider =
    Provider.family<_TopicScreenData?, String>((ref, topicId) {
  final repo = ref.watch(contentRepositoryProvider);
  final topic = repo.getTopic(topicId);
  if (topic == null) return null;

  Subtopic? nextSubtopic;
  for (final sub in topic.subtopics) {
    final st = repo.getStatus(sub.id);
    if (st == ProgressStatus.available || st == ProgressStatus.inProgress) {
      nextSubtopic = sub;
      break;
    }
  }

  final allSubtopicsDone = topic.subtopics.isNotEmpty &&
      topic.subtopics
          .every((s) => repo.getStatus(s.id) == ProgressStatus.completed);

  final anySubtopicDone = topic.subtopics
      .any((s) => repo.getStatus(s.id) == ProgressStatus.completed);

  return _TopicScreenData(
    topic: topic,
    nextSubtopic: nextSubtopic,
    allSubtopicsDone: allSubtopicsDone,
    anySubtopicDone: anySubtopicDone,
    getStatus: repo.getStatus,
  );
});

class _TopicScreenData {
  final Topic topic;
  final Subtopic? nextSubtopic;
  final bool allSubtopicsDone;
  final bool anySubtopicDone;
  final ProgressStatus Function(String) getStatus;

  const _TopicScreenData({
    required this.topic,
    required this.nextSubtopic,
    required this.allSubtopicsDone,
    required this.anySubtopicDone,
    required this.getStatus,
  });
}

final pinyinEnabledProvider = StateProvider<bool>((ref) => true);

// ── TopicScreen ───────────────────────────────────────────────────────────────

class TopicScreen extends ConsumerWidget {
  final String topicId;
  const TopicScreen({required this.topicId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(appTokensProvider);
    final ts = AppTextStyles.of(t);
    final data = ref.watch(topicScreenDataProvider(topicId));

    if (data == null) {
      return AppBackground(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(child: Text('Тема не найдена', style: ts.displayMedium)),
        ),
      );
    }

    final topic = data.topic;

    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: _TopicTopBar(topic: topic),
        body: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 120),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _SituationCard(topic: topic),
                  const SizedBox(height: 20),
                  if (topic.words.isNotEmpty) ...[
                    SectionHeader('Слова темы · ${topic.words.length} слов'),
                    const SizedBox(height: 8),
                    _WordsWrap(words: topic.words),
                    const SizedBox(height: 20),
                  ],
                  if (topic.grammar.isNotEmpty) ...[
                    SectionHeader('Грамматика · ${topic.grammar.length} конструкции'),
                    const SizedBox(height: 8),
                    ...topic.grammar.map((g) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: _GrammarCard(grammar: g),
                        )),
                    const SizedBox(height: 12),
                  ],
                  if (topic.subtopics.isNotEmpty) ...[
                    SectionHeader('Уроки · ${topic.subtopics.length} урока'),
                    const SizedBox(height: 8),
                    ...topic.subtopics.map((sub) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: _SubtopicCard(
                            subtopic: sub,
                            status: data.getStatus(sub.id),
                            onTap: data.getStatus(sub.id).isAccessible
                                ? () => context.push('/lesson/${sub.id}')
                                : null,
                          ),
                        )),
                  ],
                ]),
              ),
            ),
          ],
        ),
        bottomNavigationBar: _ActionButtons(data: data, topicId: topicId),
      ),
    );
  }
}

// ── TopBar — ФИКС: фиксированный layout, кнопка назад через Navigator ────────

class _TopicTopBar extends ConsumerWidget implements PreferredSizeWidget {
  final Topic topic;
  const _TopicTopBar({required this.topic});

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(appTokensProvider);
    final ts = AppTextStyles.of(t);
    final pinyinOn = ref.watch(pinyinEnabledProvider);

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
            // FIX: используем Navigator.of(context).pop() — надёжнее чем context.pop()
            GestureDetector(
              onTap: () {
                if (Navigator.of(context).canPop()) {
                  Navigator.of(context).pop();
                } else {
                  context.go('/');
                }
              },
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
            const SizedBox(width: 8),
            // Текст — фиксированная ширина через Expanded
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(topic.titleRu,
                      style: ts.headlineLarge,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1),
                  Text(topic.titleZh,
                      style: ts.hanziSmall.copyWith(
                          color: t.accent, fontSize: 12),
                      overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            // Пиньинь-тоггл — фиксированная ширина, не влияет на счётчик
            GestureDetector(
              onTap: () => ref
                  .read(pinyinEnabledProvider.notifier)
                  .state = !pinyinOn,
              child: Container(
                width: 80,
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: pinyinOn ? t.accentSoft : t.surfaceHighlight,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: pinyinOn
                        ? t.accent.withValues(alpha: 0.4)
                        : t.surfaceBorder,
                  ),
                ),
                child: Text(
                  pinyinOn ? '拼 ВКЛ' : '拼 ВЫКЛ',
                  style: ts.caption.copyWith(
                    color: pinyinOn ? t.accent : t.onSurfaceMuted,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Карточка ситуации ─────────────────────────────────────────────────────────

class _SituationCard extends ConsumerWidget {
  final Topic topic;
  const _SituationCard({required this.topic});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(appTokensProvider);
    final ts = AppTextStyles.of(t);

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb_outline_rounded, color: t.accentWarn, size: 20),
              const SizedBox(width: 8),
              Text('После этой темы вы сможете:', style: ts.headlineMedium),
            ],
          ),
          const SizedBox(height: 8),
          Text(topic.situationRu, style: ts.body),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8, runSpacing: 6,
            children: [
              AppChip(label: topic.hskLevel, color: t.accent, icon: Icons.school_outlined),
              AppChip(label: '${topic.words.length} слов', color: t.accentSuccess, icon: Icons.translate_rounded),
              AppChip(label: '${topic.grammar.length} конструкции', color: t.accentSecondary, icon: Icons.format_list_bulleted_rounded),
              AppChip(label: '${topic.subtopics.length} урока', color: t.accentWarn, icon: Icons.play_lesson_outlined),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Слова темы ────────────────────────────────────────────────────────────────

class _WordsWrap extends ConsumerWidget {
  final List<Word> words;
  const _WordsWrap({required this.words});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pinyinOn = ref.watch(pinyinEnabledProvider);
    return Wrap(
      spacing: 8, runSpacing: 8,
      children: words.map((word) => _WordChip(word: word, pinyinOn: pinyinOn)).toList(),
    );
  }
}

class _WordChip extends ConsumerWidget {
  final Word word;
  final bool pinyinOn;
  const _WordChip({required this.word, required this.pinyinOn});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(appTokensProvider);
    final ts = AppTextStyles.of(t);

     return GestureDetector(
       onTap: () {
         ref.read(audioServiceProvider).speakChineseText(word.hanzi);
         _showWordPopup(context, ref, word);
       },
       child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: t.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: t.surfaceBorder, width: 1.5),
          boxShadow: t.cardShadow,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(word.hanzi, style: ts.hanziSmall.copyWith(color: t.onSurface)),
            if (pinyinOn) Text(word.pinyin, style: ts.pinyin.copyWith(fontSize: 11)),
            Text(word.translationRu, style: ts.caption.copyWith(color: t.onSurfaceMuted)),
          ],
        ),
      ),
    );
  }

  void _showWordPopup(BuildContext context, WidgetRef ref, Word word) {
    final t = ref.read(appTokensProvider);
    final ts = AppTextStyles.of(t);
    final pinyinOn = ref.read(pinyinEnabledProvider);

    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: AppCard(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(word.hanzi, style: ts.hanziLarge.copyWith(color: t.onSurface)),
              if (pinyinOn) ...[
                const SizedBox(height: 4),
                Text(word.pinyin, style: ts.pinyinLarge),
              ],
              const SizedBox(height: 8),
              Text(word.translationRu,
                  style: ts.headlineMedium, textAlign: TextAlign.center),
              if (word.exampleZh != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: t.accentSoft,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(word.exampleZh!, style: ts.hanziSmall.copyWith(color: t.onSurface)),
                      if (pinyinOn && word.examplePinyin != null)
                        Text(word.examplePinyin!, style: ts.pinyin),
                      if (word.exampleRu != null)
                        Text(word.exampleRu!, style: ts.bodyMuted),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: t.accentSoft,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text('Закрыть',
                      style: ts.label.copyWith(color: t.accent),
                      textAlign: TextAlign.center),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Грамматика ────────────────────────────────────────────────────────────────

class _GrammarCard extends ConsumerWidget {
  final Grammar grammar;
  const _GrammarCard({required this.grammar});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(appTokensProvider);
    final ts = AppTextStyles.of(t);

    return AppCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: t.accentSecondary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(grammar.pattern,
                style: ts.hanziSmall.copyWith(color: t.accentSecondary)),
          ),
          const SizedBox(height: 8),
          Text(grammar.explanationRu, style: ts.body),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: t.accentSoft,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(grammar.exampleZh, style: ts.hanziSmall.copyWith(color: t.onSurface)),
                Text(grammar.examplePinyin, style: ts.pinyin),
                Text(grammar.exampleRu, style: ts.bodyMuted),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Карточка урока ────────────────────────────────────────────────────────────

class _SubtopicCard extends ConsumerWidget {
  final Subtopic subtopic;
  final ProgressStatus status;
  final VoidCallback? onTap;

  const _SubtopicCard({
    required this.subtopic,
    required this.status,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(appTokensProvider);
    final ts = AppTextStyles.of(t);
    final isLocked = status == ProgressStatus.locked;
    final isCompleted = status == ProgressStatus.completed;

    final (Color statusColor, IconData statusIcon) = switch (status) {
      ProgressStatus.completed => (t.accentSuccess, Icons.check_circle_rounded),
      ProgressStatus.inProgress => (t.accent, Icons.play_circle_rounded),
      ProgressStatus.available => (t.accent, Icons.play_circle_outline_rounded),
      ProgressStatus.locked => (t.onSurfaceDisabled, Icons.lock_outline_rounded),
    };

    return GestureDetector(
      onTap: onTap,
      child: AppCard(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(statusIcon, color: statusColor, size: 26),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(subtopic.titleRu,
                      style: ts.headlineMedium.copyWith(
                        color: isLocked ? t.onSurfaceDisabled : t.onSurface,
                      )),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Icon(Icons.schedule_rounded, size: 12, color: t.onSurfaceMuted),
                      const SizedBox(width: 4),
                      Text('~${subtopic.estimatedMinutes} мин', style: ts.bodyMuted),
                      const SizedBox(width: 12),
                      Icon(Icons.translate_rounded, size: 12, color: t.onSurfaceMuted),
                      const SizedBox(width: 4),
                      Text('${subtopic.wordIds.length} слов', style: ts.bodyMuted),
                    ],
                  ),
                  if (isCompleted)
                    Padding(
                      padding: const EdgeInsets.only(top: 3),
                      child: Text('Пройдено', style: ts.caption.copyWith(color: t.accentSuccess)),
                    ),
                ],
              ),
            ),
            if (!isLocked)
              Icon(Icons.chevron_right_rounded, color: t.onSurfaceMuted, size: 20),
          ],
        ),
      ),
    );
  }
}

// ── Кнопки действий ──────────────────────────────────────────────────────────

class _ActionButtons extends ConsumerWidget {
  final _TopicScreenData data;
  final String topicId;

  const _ActionButtons({required this.data, required this.topicId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(appTokensProvider);
    final ts = AppTextStyles.of(t);
    final hasNext = data.nextSubtopic != null;
    final canRepeat = data.anySubtopicDone;
    final canTest = data.allSubtopicsDone;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      decoration: BoxDecoration(
        color: t.isGlass ? t.surface.withValues(alpha: 0.9) : t.navBarBackground,
        border: Border(top: BorderSide(color: t.navBarBorder, width: 1)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (hasNext)
              _ActionBtn(
                icon: Icons.play_arrow_rounded,
                label: 'Продолжить',
                color: t.accent,
                onTap: () => context.push('/lesson/${data.nextSubtopic!.id}'),
              ),
            if (hasNext && (canRepeat || canTest)) const SizedBox(height: 8),
            Row(
              children: [
                if (canRepeat)
                  Expanded(
                    child: _ActionBtn(
                      icon: Icons.refresh_rounded,
                      label: 'Повторить',
                      color: t.accentSecondary,
                      small: true,
                      onTap: () => context.push(
                          '/lesson/${data.topic.subtopics.first.id}?review=true'),
                    ),
                  ),
                if (canRepeat && canTest) const SizedBox(width: 8),
                if (canTest)
                  Expanded(
                    child: _ActionBtn(
                      icon: Icons.emoji_events_rounded,
                      label: 'Итоговый тест',
                      color: t.accentWarn,
                      small: true,
                      onTap: () => context.push('/final-test/$topicId'),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionBtn extends ConsumerWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  final bool small;

  const _ActionBtn({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    this.small = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(appTokensProvider);
    final ts = AppTextStyles.of(t);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: small ? 12 : 16, horizontal: 20),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(t.radiusButton),
          border: Border.all(color: color.withValues(alpha: 0.4), width: 1.5),
          boxShadow: [
            BoxShadow(
                color: color.withValues(alpha: 0.15),
                blurRadius: 12,
                offset: const Offset(0, 4)),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: small ? 18 : 22),
            const SizedBox(width: 8),
            Text(label,
                style: (small ? ts.headlineMedium : ts.headlineLarge)
                    .copyWith(color: color, fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }
}
