// lib/features/dictionary/dictionary_screen.dart
// ФИКСЫ:
//   • Убраны SRS-метки «Повторить» / «Зрелое»
//   • Добавлен прогресс-бар 0-100 вместо меток
//   • Разделение по темам: карточки тем, при нажатии — список слов
//   • Убраны фильтры SRS (их заменяет прогресс-бар)

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/audio/audio_service.dart';
import '../../core/theme/app_tokens.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_card.dart';
import '../../data/models/models.dart';
import '../../data/repositories/content_repository.dart';

// ── Модели ────────────────────────────────────────────────────────────────────

class _TopicWithWords {
  final Topic topic;
  final List<_DictWord> words;
  const _TopicWithWords({required this.topic, required this.words});

  double get avgProgress {
    if (words.isEmpty) return 0;
    return words.map((w) => w.progress).reduce((a, b) => a + b) / words.length;
  }
}

class _DictWord {
  final Word word;
  // Прогресс 0.0–1.0 (mock — позже из Drift)
  final double progress;

  const _DictWord({required this.word, required this.progress});

  // Прогресс 0–100 для отображения
  int get progressPercent => (progress * 100).round();
}

// ── Провайдеры ────────────────────────────────────────────────────────────────

final dictSearchProvider = StateProvider<String>((ref) => '');

final dictionaryTopicsProvider = Provider<List<_TopicWithWords>>((ref) {
  final repo = ref.watch(contentRepositoryProvider);
  final search = ref.watch(dictSearchProvider).toLowerCase();
  final result = <_TopicWithWords>[];

  for (final block in repo.getAllBlocks()) {
    for (final topic in repo.getTopicsForBlock(block.id)) {
      if (repo.getStatus(topic.id) == ProgressStatus.locked) continue;

      var words = topic.words.map((word) {
        // Mock прогресс: если тема пройдена — выше прогресс
        final topicStatus = repo.getStatus(topic.id);
        final mockProgress = topicStatus == ProgressStatus.completed
            ? 0.7 + (word.strokeCount % 3) * 0.1
            : topicStatus == ProgressStatus.inProgress
                ? 0.3 + (word.strokeCount % 4) * 0.05
                : 0.0;

        return _DictWord(
          word: word,
          progress: mockProgress.clamp(0.0, 1.0),
        );
      }).toList();

      // Поиск
      if (search.isNotEmpty) {
        words = words.where((dw) {
          return dw.word.hanzi.contains(search) ||
              dw.word.pinyin.toLowerCase().contains(search) ||
              dw.word.translationRu.toLowerCase().contains(search);
        }).toList();
      }

      if (words.isEmpty && search.isNotEmpty) continue;

      result.add(_TopicWithWords(topic: topic, words: words));
    }
  }

  return result;
});

// ── DictionaryScreen ──────────────────────────────────────────────────────────

class DictionaryScreen extends ConsumerWidget {
  const DictionaryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(appTokensProvider);
    final ts = AppTextStyles.of(t);
    final topicGroups = ref.watch(dictionaryTopicsProvider);

    // Суммарное количество слов
    final totalWords = topicGroups.fold(0, (sum, g) => sum + g.words.length);

    return Column(
      children: [
        // Поиск
        Container(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
          child: TextField(
            onChanged: (v) => ref.read(dictSearchProvider.notifier).state = v,
            style: TextStyle(
              fontFamily: 'NotoSansSC',
              fontSize: 16,
              color: t.onSurface,
            ),
            decoration: InputDecoration(
              hintText: '搜索 · Поиск по иероглифу, пиньиню или переводу...',
              hintStyle: ts.bodyMuted,
              prefixIcon: Icon(Icons.search_rounded, color: t.onSurfaceMuted),
              filled: true,
              fillColor: t.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: t.surfaceBorder),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: t.surfaceBorder),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: t.accent, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),

        // Список тем
        Expanded(
          child: topicGroups.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('📖', style: TextStyle(fontSize: 48)),
                      const SizedBox(height: 16),
                      Text('Слов не найдено', style: ts.displayMedium),
                      const SizedBox(height: 8),
                      Text(
                        'Пройди уроки, чтобы слова появились в словаре',
                        style: ts.bodyMuted,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                  itemCount: topicGroups.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (_, i) => _TopicGroupCard(group: topicGroups[i]),
                ),
        ),
      ],
    );
  }
}

// ── Карточка темы — сворачивается/разворачивается ─────────────────────────────

class _TopicGroupCard extends ConsumerStatefulWidget {
  final _TopicWithWords group;
  const _TopicGroupCard({required this.group});

  @override
  ConsumerState<_TopicGroupCard> createState() => _TopicGroupCardState();
}

class _TopicGroupCardState extends ConsumerState<_TopicGroupCard>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;
  late AnimationController _ctrl;
  late Animation<double> _expandAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _expandAnim = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() => _expanded = !_expanded);
    if (_expanded) {
      _ctrl.forward();
    } else {
      _ctrl.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = ref.watch(appTokensProvider);
    final ts = AppTextStyles.of(t);
    final group = widget.group;
    final avgProgress = group.avgProgress;

    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          // Заголовок темы — нажимается для разворачивания
          GestureDetector(
            onTap: _toggle,
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Номер и название
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 7, vertical: 2),
                              decoration: BoxDecoration(
                                color: t.accentSoft,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                'Тема ${group.topic.order}',
                                style: ts.caption.copyWith(
                                    color: t.accent, fontWeight: FontWeight.w700),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                group.topic.titleRu,
                                style: ts.headlineMedium,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // Прогресс-бар темы
                        Row(
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: avgProgress,
                                  minHeight: 6,
                                  backgroundColor: t.surfaceBorder,
                                  valueColor: AlwaysStoppedAnimation(t.accent),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              '${(avgProgress * 100).round()}%',
                              style: ts.caption.copyWith(
                                  color: t.accent, fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${group.words.length} слов',
                              style: ts.caption.copyWith(color: t.onSurfaceMuted),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Стрелка
                  AnimatedRotation(
                    turns: _expanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 250),
                    child: Icon(Icons.keyboard_arrow_down_rounded,
                        color: t.onSurfaceMuted, size: 24),
                  ),
                ],
              ),
            ),
          ),

          // Список слов (анимированный)
          SizeTransition(
            sizeFactor: _expandAnim,
            child: Column(
              children: [
                Divider(height: 1, color: t.surfaceBorder),
                ...group.words.map((dw) => _DictWordTile(dw: dw)),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Тайл слова ────────────────────────────────────────────────────────────────

class _DictWordTile extends ConsumerWidget {
  final _DictWord dw;
  const _DictWordTile({required this.dw});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(appTokensProvider);
    final ts = AppTextStyles.of(t);
    final audio = ref.read(audioServiceProvider);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Row(
        children: [
          // Иероглиф + пиньинь
          SizedBox(
            width: 64,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(dw.word.hanzi,
                    style: ts.hanziMedium.copyWith(color: t.onSurface)),
                Text(dw.word.pinyin,
                    style: ts.pinyin.copyWith(fontSize: 11)),
              ],
            ),
          ),
          const SizedBox(width: 12),

          // Перевод + прогресс-бар
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(dw.word.translationRu,
                    style: ts.body,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(3),
                        child: LinearProgressIndicator(
                          value: dw.progress,
                          minHeight: 4,
                          backgroundColor: t.surfaceBorder,
                          valueColor: AlwaysStoppedAnimation(
                            dw.progress >= 0.8
                                ? t.accentSuccess
                                : dw.progress >= 0.4
                                    ? t.accent
                                    : t.accentWarn,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text('${dw.progressPercent}%',
                        style: ts.caption.copyWith(
                          color: dw.progress >= 0.8
                              ? t.accentSuccess
                              : t.onSurfaceMuted,
                          fontWeight: FontWeight.w600,
                          fontSize: 10,
                        )),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),

          // Кнопка аудио
          GestureDetector(
            onTap: () => audio.playWord(dw.word.audioPath),
            child: Container(
              width: 34, height: 34,
              decoration: BoxDecoration(
                color: dw.word.audioPath != null
                    ? t.accentSoft
                    : t.surfaceHighlight,
                shape: BoxShape.circle,
                border: Border.all(
                  color: dw.word.audioPath != null
                      ? t.accent.withValues(alpha: 0.3)
                      : t.surfaceBorder,
                ),
              ),
              child: Icon(
                Icons.volume_up_rounded,
                color: dw.word.audioPath != null
                    ? t.accent
                    : t.onSurfaceDisabled,
                size: 17,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
