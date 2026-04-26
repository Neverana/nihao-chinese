// lib/features/lesson/lesson_screen.dart
// ФИКСЫ:
//   • TopBar: пиньинь-тоггл в отдельном SizedBox фиксированной ширины, не въезжает в счётчик
//   • DialogueExercise: перевод НЕ показывается под текстом, только при нажатии на реплику
//   • WordMatchingExercise: при нажатии на слово показывается tooltip с переводом и пиньинем

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/audio/audio_service.dart';
import '../../core/theme/app_tokens.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_card.dart';
import '../../core/services/stroke_data_service.dart';
import '../../data/models/models.dart';
import '../../data/models/stroke_data.dart';
import '../../data/repositories/content_repository.dart';
import '../calligraphy/widgets/stroke_practice_canvas.dart';
import 'exercises/fill_in_blank_exercise.dart';
import 'exercises/sentence_builder_exercise.dart';
import 'exercises/tone_exercises.dart';

// ── Состояние ─────────────────────────────────────────────────────────────────

class LessonState {
  final int currentIndex;
  final int totalExercises;
  final int correctAnswers;
  final bool pinyinEnabled;
  final bool isFinished;

  const LessonState({
    this.currentIndex = 0,
    this.totalExercises = 0,
    this.correctAnswers = 0,
    this.pinyinEnabled = true,
    this.isFinished = false,
  });

  LessonState copyWith({
    int? currentIndex,
    int? totalExercises,
    int? correctAnswers,
    bool? pinyinEnabled,
    bool? isFinished,
  }) =>
      LessonState(
        currentIndex: currentIndex ?? this.currentIndex,
        totalExercises: totalExercises ?? this.totalExercises,
        correctAnswers: correctAnswers ?? this.correctAnswers,
        pinyinEnabled: pinyinEnabled ?? this.pinyinEnabled,
        isFinished: isFinished ?? this.isFinished,
      );

  double get progress =>
      totalExercises == 0 ? 0 : currentIndex / totalExercises;
}

class LessonNotifier extends StateNotifier<LessonState> {
  LessonNotifier(int total) : super(LessonState(totalExercises: total));
  void answer(bool correct) {
    if (correct)
      state = state.copyWith(correctAnswers: state.correctAnswers + 1);
  }

  void next() {
    if (state.currentIndex + 1 >= state.totalExercises) {
      state = state.copyWith(isFinished: true);
    } else {
      state = state.copyWith(currentIndex: state.currentIndex + 1);
    }
  }

  void togglePinyin() =>
      state = state.copyWith(pinyinEnabled: !state.pinyinEnabled);
}

final lessonProvider = StateNotifierProvider.autoDispose
    .family<LessonNotifier, LessonState, int>(
        (ref, total) => LessonNotifier(total));

// ── LessonScreen ──────────────────────────────────────────────────────────────

class LessonScreen extends ConsumerStatefulWidget {
  final String subtopicId;
  final bool isReview;
  final bool isFinalTest;

  const LessonScreen({
    required this.subtopicId,
    this.isReview = false,
    this.isFinalTest = false,
    super.key,
  });

  @override
  ConsumerState<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends ConsumerState<LessonScreen> {
  late PageController _pageController;
  List<_ExerciseItem> _exercises = [];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _loadData();
  }

  void _loadData() {
    final repo = ref.read(contentRepositoryProvider);
    final sub = repo.getSubtopic(widget.subtopicId);
    if (sub == null) return;
    final words = repo.getWordsForIds(sub.wordIds);

    _exercises = sub.exercises.map((cfg) {
      final exWords = cfg.params['wordIds'] != null
          ? repo
              .getWordsForIds(List<String>.from(cfg.params['wordIds'] as List))
          : words;
      return _ExerciseItem(
        config: cfg,
        words: exWords.isEmpty ? words : exWords,
        dialogue: cfg.params['dialogueId'] != null
            ? repo.getDialogue(cfg.params['dialogueId'] as String)
            : null,
      );
    }).toList();

    setState(() {});
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onAnswer(bool correct) =>
      ref.read(lessonProvider(_exercises.length).notifier).answer(correct);

  void _onNext() {
    final notifier = ref.read(lessonProvider(_exercises.length).notifier);
    final state = ref.read(lessonProvider(_exercises.length));
    notifier.next();

    if (!state.isFinished && state.currentIndex + 1 < _exercises.length) {
      _pageController.animateToPage(
        state.currentIndex + 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      final repo = ref.read(contentRepositoryProvider);
      repo.completeSubtopic(
        widget.subtopicId,
        score: _exercises.isEmpty
            ? 100
            : state.correctAnswers * 100 ~/ _exercises.length,
      );
      context.pushReplacement(
        '/lesson-result/${widget.subtopicId}'
        '?correct=${state.correctAnswers}&total=${_exercises.length}',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = ref.watch(appTokensProvider);
    final ts = AppTextStyles.of(t);
    final lessonState = ref.watch(lessonProvider(_exercises.length));

    if (_exercises.isEmpty) {
      return AppBackground(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Загрузка...', style: ts.displayMedium),
                const SizedBox(height: 16),
                CircularProgressIndicator(color: t.accent),
              ],
            ),
          ),
        ),
      );
    }

    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              _LessonTopBar(
                state: lessonState,
                isFinalTest: widget.isFinalTest,
                onClose: () => _confirmClose(context, t, ts),
                onTogglePinyin: widget.isFinalTest
                    ? null
                    : () => ref
                        .read(lessonProvider(_exercises.length).notifier)
                        .togglePinyin(),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _exercises.length,
                  itemBuilder: (_, i) {
                    final item = _exercises[i];
                    return ExerciseWidgetFactory.build(
                      config: item.config,
                      words: item.words,
                      dialogue: item.dialogue,
                      pinyinEnabled: lessonState.pinyinEnabled,
                      isFinalTest: widget.isFinalTest,
                      onAnswer: _onAnswer,
                      onNext: _onNext,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmClose(BuildContext context, AppTokens t, AppTextStyles ts) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: t.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Выйти из урока?', style: ts.headlineLarge),
        content: Text('Прогресс не сохранится.', style: ts.body),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Остаться', style: ts.label.copyWith(color: t.accent)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              } else {
                context.go('/');
              }
            },
            child:
                Text('Выйти', style: ts.label.copyWith(color: t.accentDanger)),
          ),
        ],
      ),
    );
  }
}

class _ExerciseItem {
  final ExerciseConfig config;
  final List<Word> words;
  final Dialogue? dialogue;
  const _ExerciseItem(
      {required this.config, required this.words, this.dialogue});
}

// ── ExerciseWidgetFactory ─────────────────────────────────────────────────────

class ExerciseWidgetFactory {
  static Widget build({
    required ExerciseConfig config,
    required List<Word> words,
    Dialogue? dialogue,
    required bool pinyinEnabled,
    required bool isFinalTest,
    required void Function(bool) onAnswer,
    required VoidCallback onNext,
  }) {
    if (words.isEmpty)
      return _PlaceholderExercise(type: config.type, onNext: onNext);

    return switch (config.type) {
      ExerciseType.wordMatching => WordMatchingExercise(
          words: words,
          pairCount: config.params['pairCount'] as int? ?? 4,
          pinyinEnabled: pinyinEnabled,
          onAnswer: onAnswer,
          onNext: onNext,
        ),
      ExerciseType.translation => TranslationExercise(
          words: words,
          direction: config.params['direction'] as String? ?? 'zh_to_ru',
          pinyinEnabled: pinyinEnabled,
          isFinalTest: isFinalTest,
          onAnswer: onAnswer,
          onNext: onNext,
        ),
      ExerciseType.dialogue => DialogueExercise(
          dialogue: dialogue,
          pinyinEnabled: pinyinEnabled,
          onAnswer: onAnswer,
          onNext: onNext,
        ),
      ExerciseType.calligraphy => CalligraphyExercise(
          word: words.isNotEmpty ? words.first : null,
          wordId: config.params['wordId'] as String?,
          showGuide: !isFinalTest,
          onNext: onNext,
        ),
      ExerciseType.listening => ListeningExercise(
          words: words,
          audioPath: config.params['audioPath'] as String?,
          prompt: config.params['prompt'] as String? ??
              'Прослушай аудио и выбери правильный ответ',
          options:
              List<String>.from(config.params['options'] as List? ?? const []),
          correctAnswer: config.params['correctAnswer'] as String?,
          maxPlays:
              config.params['maxPlays'] as int? ?? (isFinalTest ? 2 : 999),
          isFinalTest: isFinalTest,
          onAnswer: onAnswer,
          onNext: onNext,
        ),
      ExerciseType.fillInTheBlank => FillInBlankExercise(
          words: words,
          pinyinEnabled: pinyinEnabled,
          onAnswer: onAnswer,
          onNext: onNext,
        ),
      ExerciseType.sentenceBuilder => SentenceBuilderExercise(
          words: words,
          pinyinEnabled: pinyinEnabled,
          onAnswer: onAnswer,
          onNext: onNext,
        ),
      ExerciseType.toneSelection => ToneSelectionExercise(
          words: words,
          onAnswer: onAnswer,
          onNext: onNext,
        ),
      ExerciseType.pinyinInput => PinyinInputExercise(
          words: words,
          pinyinEnabled: pinyinEnabled,
          onAnswer: onAnswer,
          onNext: onNext,
        ),
      ExerciseType.trueOrFalse => TrueOrFalseExercise(
          words: words,
          pinyinEnabled: pinyinEnabled,
          onAnswer: onAnswer,
          onNext: onNext,
        ),
      ExerciseType.wordCardFlip => WordCardFlipExercise(
          words: words,
          pinyinEnabled: pinyinEnabled,
          onAnswer: onAnswer,
          onNext: onNext,
        ),
    };
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// TOPBAR — FIX: Stack с Positioned, счётчик строго по центру
// Пиньинь-тоггл в SizedBox(width: 82) — никогда не двигает счётчик
// ═════════════════════════════════════════════════════════════════════════════

class _LessonTopBar extends ConsumerWidget {
  final LessonState state;
  final bool isFinalTest;
  final VoidCallback onClose;
  final VoidCallback? onTogglePinyin;

  const _LessonTopBar({
    required this.state,
    required this.isFinalTest,
    required this.onClose,
    this.onTogglePinyin,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(appTokensProvider);
    final ts = AppTextStyles.of(t);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        LinearProgressIndicator(
          value: state.progress,
          minHeight: 4,
          backgroundColor: t.surfaceBorder,
          valueColor:
              AlwaysStoppedAnimation(isFinalTest ? t.accentWarn : t.accent),
        ),
        // FIX: Stack — счётчик ВСЕГДА по центру независимо от правой кнопки
        SizedBox(
          height: 52,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Кнопка закрыть — слева
              Positioned(
                left: 12,
                child: GestureDetector(
                  onTap: onClose,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: t.surfaceHighlight,
                      shape: BoxShape.circle,
                      border: Border.all(color: t.surfaceBorder),
                    ),
                    child: Icon(Icons.close_rounded,
                        color: t.onSurfaceMuted, size: 20),
                  ),
                ),
              ),

              // Счётчик — строго центр, в чипе
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: t.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: t.surfaceBorder, width: 1.5),
                ),
                child: Text(
                  '${state.currentIndex + 1} / ${state.totalExercises}',
                  style: ts.headlineMedium,
                ),
              ),

              // FIX: правая кнопка в SizedBox фиксированной ширины
              Positioned(
                right: 12,
                child: SizedBox(
                  width: 88,
                  child: onTogglePinyin != null
                      ? GestureDetector(
                          onTap: onTogglePinyin,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 6),
                            decoration: BoxDecoration(
                              color: state.pinyinEnabled
                                  ? t.accent.withValues(alpha: 0.15)
                                  : t.surface,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: state.pinyinEnabled
                                    ? t.accent.withValues(alpha: 0.5)
                                    : t.surfaceBorder,
                                width: 1.5,
                              ),
                              boxShadow: state.pinyinEnabled
                                  ? [
                                      BoxShadow(
                                        color: t.accent.withValues(alpha: 0.15),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '拼',
                                  style: TextStyle(
                                    fontFamily: 'NotoSansSC',
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: state.pinyinEnabled
                                        ? t.accent
                                        : t.onSurfaceMuted,
                                  ),
                                ),
                                const SizedBox(width: 3),
                                Text(
                                  state.pinyinEnabled ? 'ВКЛ' : 'ВЫКЛ',
                                  style: ts.caption.copyWith(
                                    color: state.pinyinEnabled
                                        ? t.accent
                                        : t.onSurfaceMuted,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 10,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        )
                      : Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 5),
                          decoration: BoxDecoration(
                            color: t.accentWarn.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                color: t.accentWarn.withValues(alpha: 0.3)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.lock_outline_rounded,
                                  color: t.accentWarn, size: 14),
                              const SizedBox(width: 4),
                              Text('Тест',
                                  style: ts.caption.copyWith(
                                      color: t.accentWarn,
                                      fontWeight: FontWeight.w700)),
                            ],
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// WORD MATCHING — чипы одинаковой высоты через Expanded
// ═════════════════════════════════════════════════════════════════════════════

class WordMatchingExercise extends ConsumerStatefulWidget {
  final List<Word> words;
  final int pairCount;
  final bool pinyinEnabled;
  final void Function(bool) onAnswer;
  final VoidCallback onNext;

  const WordMatchingExercise({
    required this.words,
    required this.pairCount,
    required this.pinyinEnabled,
    required this.onAnswer,
    required this.onNext,
    super.key,
  });

  @override
  ConsumerState<WordMatchingExercise> createState() => _WordMatchingState();
}

class _WordMatchingState extends ConsumerState<WordMatchingExercise> {
  late List<Word> _pairs;
  late List<String> _leftItems;
  late List<String> _rightItems;
  String? _selectedLeft;
  String? _selectedRight;
  final Set<String> _matched = {};
  final Map<String, bool> _feedback = {};
  bool _allMatched = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() {
    final rng = Random();
    final pool = [...widget.words]..shuffle(rng);
    _pairs = pool.take(widget.pairCount.clamp(2, pool.length)).toList();
    _leftItems = _pairs.map((w) => w.hanzi).toList()..shuffle(rng);
    _rightItems = _pairs.map((w) => w.translationRu).toList()..shuffle(rng);
  }

  void _selectLeft(String hanzi) {
    if (_matched.contains(hanzi)) return;
    setState(() => _selectedLeft = hanzi);
    _checkMatch();
  }

  void _selectRight(String tr) {
    final alreadyMatched = _matched.any((id) {
      final w = _pairs.firstWhereOrNull((w) => w.id == id);
      return w?.translationRu == tr;
    });
    if (alreadyMatched) return;
    setState(() => _selectedRight = tr);
    _checkMatch();
  }

   void _checkMatch() {
     if (_selectedLeft == null || _selectedRight == null) return;
     final word = _pairs.firstWhereOrNull((w) => w.hanzi == _selectedLeft);
     if (word == null) return;
     final correct = word.translationRu == _selectedRight;
     setState(() {
       if (correct) {
         _matched.add(word.id);
         _feedback[word.id] = true;
         widget.onAnswer(true);
         _selectedLeft = null;
         _selectedRight = null;
         _allMatched = _matched.length == _pairs.length;
         // Play correct sound
         ref.read(audioServiceProvider).playSfx('correct');
       } else {
         _feedback[word.id] = false;
         widget.onAnswer(false);
         // Play incorrect sound
         ref.read(audioServiceProvider).playSfx('wrong');
         Future.delayed(const Duration(milliseconds: 600), () {
           if (mounted) {
             setState(() {
               _feedback.remove(word.id);
               _selectedLeft = null;
               _selectedRight = null;
             });
           }
         });
       }
     });
   }

  @override
  Widget build(BuildContext context) {
    final t = ref.watch(appTokensProvider);
    final ts = AppTextStyles.of(t);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Сопоставь слова', style: ts.displayMedium),
              Text('Нажми на слово — увидишь перевод и пиньинь',
                  style: ts.bodyMuted),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    children: _leftItems.map((hanzi) {
                      final word =
                          _pairs.firstWhereOrNull((w) => w.hanzi == hanzi);
                      final isMatched =
                          word != null && _matched.contains(word.id);
                      final isSelected = _selectedLeft == hanzi;
                      final feedbackOk =
                          word != null && _feedback[word.id] == true;
                      final feedbackBad =
                          word != null && _feedback[word.id] == false;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxHeight: 56),
                          child: _MatchChip(
                            label: hanzi,
                            sublabel: widget.pinyinEnabled && word != null
                                ? word.pinyin
                                : null,
                            word: word,
                            isSelected: isSelected,
                            isMatched: isMatched,
                            feedbackOk: feedbackOk,
                            feedbackBad: feedbackBad,
                            onTap: isMatched ? null : () => _selectLeft(hanzi),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    children: _rightItems.map((tr) {
                      final word =
                          _pairs.firstWhereOrNull((w) => w.translationRu == tr);
                      final isMatched =
                          word != null && _matched.contains(word.id);
                      final isSelected = _selectedRight == tr;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxHeight: 56),
                          child: _MatchChip(
                            label: tr,
                            isSelected: isSelected,
                            isMatched: isMatched,
                            feedbackOk: false,
                            feedbackBad: false,
                            onTap: isMatched ? null : () => _selectRight(tr),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
        LessonBottomNextButton(
            visible: _allMatched, label: 'Далее', onTap: widget.onNext),
      ],
    );
  }
}

// FIX: при нажатии на слово (левая колонка) показываем tooltip с переводом
class _MatchChip extends ConsumerStatefulWidget {
  final String label;
  final String? sublabel;
  final Word? word; // null для правой колонки
  final bool isSelected;
  final bool isMatched;
  final bool feedbackOk;
  final bool feedbackBad;
  final VoidCallback? onTap;

  const _MatchChip({
    required this.label,
    this.sublabel,
    this.word,
    required this.isSelected,
    required this.isMatched,
    required this.feedbackOk,
    required this.feedbackBad,
    this.onTap,
  });

  @override
  ConsumerState<_MatchChip> createState() => _MatchChipState();
}

class _MatchChipState extends ConsumerState<_MatchChip> {
  bool _showTooltip = false;

  @override
  Widget build(BuildContext context) {
    final t = ref.watch(appTokensProvider);
    final ts = AppTextStyles.of(t);

    Color bg = t.surface;
    Color border = t.surfaceBorder;
    if (widget.isMatched || widget.feedbackOk) {
      bg = t.accentSuccess.withValues(alpha: 0.15);
      border = t.accentSuccess;
    } else if (widget.feedbackBad) {
      bg = t.accentDanger.withValues(alpha: 0.15);
      border = t.accentDanger;
    } else if (widget.isSelected) {
      bg = t.accentSoft;
      border = t.accent;
    }

    return GestureDetector(
      onTap: widget.onTap != null ? () {
        if (widget.word != null) {
          ref.read(audioServiceProvider).speakChineseText(widget.word!.hanzi);
        }
        widget.onTap!();
      } : null,
      onLongPress: widget.word != null
          ? () => setState(() => _showTooltip = !_showTooltip)
          : null,
      child: Stack(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: double.infinity,
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: border, width: 1.5),
            ),
                 child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                          child: widget.word != null
                              ? Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(widget.label,
                                        style: ts.hanziSmall.copyWith(
                                            color: widget.isMatched
                                                ? t.accentSuccess
                                                : t.onSurface),
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis),
                                    if (widget.sublabel != null)
                                      Text(widget.sublabel!,
                                          style: ts.pinyin.copyWith(fontSize: 11),
                                          textAlign: TextAlign.center),
                                  ],
                                )
                              : Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(widget.label,
                                        style: ts.body.copyWith(color: t.onSurface)),
                                  ],
                                ),
                        ),
                      ),
          ),
          // FIX: tooltip с переводом при долгом нажатии на иероглиф
          if (_showTooltip && widget.word != null)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: GestureDetector(
                onTap: () => setState(() => _showTooltip = false),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: t.accent,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                          color: t.accent.withValues(alpha: 0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 4)),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(widget.word!.pinyin,
                          style: ts.caption.copyWith(
                              color: Colors.white.withValues(alpha: 0.85))),
                      Text(widget.word!.translationRu,
                          style: ts.label.copyWith(
                              color: Colors.white, fontWeight: FontWeight.w700),
                          textAlign: TextAlign.center),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// TRANSLATION
// ═════════════════════════════════════════════════════════════════════════════

class TranslationExercise extends ConsumerStatefulWidget {
  final List<Word> words;
  final String direction;
  final bool pinyinEnabled;
  final bool isFinalTest;
  final void Function(bool) onAnswer;
  final VoidCallback onNext;

  const TranslationExercise({
    required this.words,
    required this.direction,
    required this.pinyinEnabled,
    required this.isFinalTest,
    required this.onAnswer,
    required this.onNext,
    super.key,
  });

  @override
  ConsumerState<TranslationExercise> createState() => _TranslationState();
}

class _TranslationState extends ConsumerState<TranslationExercise> {
  late Word _target;
  late List<Word> _options;
  int? _selectedIndex;
  bool _answered = false;
  bool _showTranslation = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() {
    final rng = Random();
    final pool = [...widget.words]..shuffle(rng);
    _target = pool.first;
    final others = pool.skip(1).take(3).toList();
    _options = [...others, _target]..shuffle(rng);
    _selectedIndex = null;
    _answered = false;
  }

  void _select(int i) {
    if (_answered) return;
    final correct = _options[i].id == _target.id;
    setState(() {
      _selectedIndex = i;
      _answered = true;
    });
    widget.onAnswer(correct);
    // Play sound feedback
    final audioService = ref.read(audioServiceProvider);
    if (correct) {
      audioService.playSfx('correct');
    } else {
      audioService.playSfx('wrong');
    }
  }

  // Карточка-цель с переводом по клику
  Widget _buildTargetCardWithTranslation(AppTokens t, AppTextStyles ts, Word word, WidgetRef ref, bool pinyinEnabled) {
    return GestureDetector(
      onTap: () {
        // Озвучиваем слово при каждом клике
        ref.read(audioServiceProvider).speakChineseText(word.hanzi);
        setState(() => _showTranslation = !_showTranslation);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        decoration: BoxDecoration(
          color: t.surface,
          borderRadius: BorderRadius.circular(t.radiusCard),
          border: Border.all(color: t.surfaceBorder, width: 1.5),
          boxShadow: t.cardShadow,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
             Text(
               word.hanzi,
               style: ts.hanziHero.copyWith(color: t.onSurface),
             ),
            if (pinyinEnabled) ...[
              const SizedBox(height: 6),
              Text(word.pinyin, style: ts.pinyinLarge),
            ],
            // Анимированный блок перевода
            AnimatedSize(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              child: _showTranslation
                  ? Column(
                      children: [
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: t.accentSoft,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            word.translationRu,
                            style: ts.headlineMedium.copyWith(color: t.accent),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = ref.watch(appTokensProvider);
    final ts = AppTextStyles.of(t);
    final isZhToRu = widget.direction == 'zh_to_ru';

    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(isZhToRu ? 'Выбери перевод' : 'Выбери иероглиф',
                    style: ts.displayMedium),
                const SizedBox(height: 24),
                Center(
                  child: AppCard(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
            if (isZhToRu) ...[
              // Китайское слово с переводом по клику
              _buildTargetCardWithTranslation(t, ts, _target, ref, widget.pinyinEnabled),
            ] else
              Text(_target.translationRu,
                  style:
                      ts.displayLarge.copyWith(color: t.onSurface),
                  textAlign: TextAlign.center),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: Row(
                          children: [0, 1]
                              .map((i) => Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          right: i == 0 ? 6 : 0, bottom: 6),
                                      child: _TranslationOption(
                                        word: _options[i],
                                        isZhToRu: isZhToRu,
                                        pinyinEnabled: widget.pinyinEnabled,
                                        isSelected: _selectedIndex == i,
                                        isCorrect: _options[i].id == _target.id,
                                        answered: _answered,
                                        onTap: () => _select(i),
                                      ),
                                    ),
                                  ))
                              .toList(),
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: [2, 3].map((i) {
                            if (i >= _options.length)
                              return const Expanded(child: SizedBox());
                            return Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(right: i == 2 ? 6 : 0),
                                child: _TranslationOption(
                                  word: _options[i],
                                  isZhToRu: isZhToRu,
                                  pinyinEnabled: widget.pinyinEnabled,
                                  isSelected: _selectedIndex == i,
                                  isCorrect: _options[i].id == _target.id,
                                  answered: _answered,
                                  onTap: () => _select(i),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        LessonBottomNextButton(
            visible: _answered, label: 'Далее', onTap: widget.onNext),
      ],
    );
  }
}

class _TranslationOption extends ConsumerWidget {
  final Word word;
  final bool isZhToRu;
  final bool pinyinEnabled;
  final bool isSelected;
  final bool isCorrect;
  final bool answered;
  final VoidCallback onTap;

  const _TranslationOption({
    required this.word,
    required this.isZhToRu,
    required this.pinyinEnabled,
    required this.isSelected,
    required this.isCorrect,
    required this.answered,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(appTokensProvider);
    final ts = AppTextStyles.of(t);

    Color bg = t.surface;
    Color border = t.surfaceBorder;
    if (answered) {
      if (isCorrect) {
        bg = t.accentSuccess.withValues(alpha: 0.15);
        border = t.accentSuccess;
      } else if (isSelected) {
        bg = t.accentDanger.withValues(alpha: 0.15);
        border = t.accentDanger;
      }
    } else if (isSelected) {
      bg = t.accentSoft;
      border = t.accent;
    }

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(t.radiusButton),
          border: Border.all(color: border, width: 1.5),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: isZhToRu
                ? Text(word.translationRu,
                    style: ts.body.copyWith(color: t.onSurface),
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis)
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(word.hanzi,
                          style: ts.hanziMedium.copyWith(color: t.onSurface)),
                      if (pinyinEnabled) Text(word.pinyin, style: ts.pinyin),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// DIALOGUE — FIX: перевод НЕ под текстом, только при нажатии на реплику
// ═════════════════════════════════════════════════════════════════════════════

class DialogueExercise extends ConsumerStatefulWidget {
  final Dialogue? dialogue;
  final bool pinyinEnabled;
  final void Function(bool) onAnswer;
  final VoidCallback onNext;

  const DialogueExercise({
    this.dialogue,
    required this.pinyinEnabled,
    required this.onAnswer,
    required this.onNext,
    super.key,
  });

  @override
  ConsumerState<DialogueExercise> createState() => _DialogueState();
}

class _DialogueState extends ConsumerState<DialogueExercise> {
  int _currentTurnIndex = 0;
  final List<_ShownTurn> _shownTurns = [];
  List<DialogueTurn> _options = [];
  bool _waitingForChoice = false;
  bool _finished = false;
  // Какая реплика сейчас раскрыта (показывает перевод)
  int? _expandedTurnIndex;

  @override
  void initState() {
    super.initState();
    _advance();
  }

  void _advance() {
    final dialogue = widget.dialogue;
    if (dialogue == null || _currentTurnIndex >= dialogue.turns.length) {
      setState(() => _finished = true);
      return;
    }

    final turn = dialogue.turns[_currentTurnIndex];

    if (turn.role == 'other') {
      setState(() {
        _shownTurns
            .add(_ShownTurn(turn: turn, wasGuessed: false, correct: true));
        _currentTurnIndex++;
        _waitingForChoice = false;
        _expandedTurnIndex = null;
      });
      Future.delayed(const Duration(milliseconds: 400), _advance);
    } else {
      final allTurns = dialogue.turns;
      final userTurns = allTurns.where((t) => t.role == 'user').toList();
      final rng = Random();
      final distractors = userTurns.where((t) => t.zh != turn.zh).toList()
        ..shuffle(rng);
      final options = [turn, ...distractors.take(2)]..shuffle(rng);
      setState(() {
        _options = options;
        _waitingForChoice = true;
        _expandedTurnIndex = null;
      });
    }
  }

  void _selectOption(DialogueTurn selected) {
    if (!_waitingForChoice) return;
    final dialogue = widget.dialogue!;
    final correctTurn = dialogue.turns[_currentTurnIndex];
    final correct = selected.zh == correctTurn.zh;

    widget.onAnswer(correct);
    // Play sound feedback
    final audioService = ref.read(audioServiceProvider);
    if (correct) {
      audioService.playSfx('correct');
    } else {
      audioService.playSfx('wrong');
    }

    setState(() {
      _shownTurns.add(_ShownTurn(
        turn: correctTurn,
        wasGuessed: true,
        correct: correct,
        userChose: correct ? null : selected.zh,
      ));
      _currentTurnIndex++;
      _waitingForChoice = false;
    });

    Future.delayed(const Duration(milliseconds: 600), _advance);
  }

  @override
  Widget build(BuildContext context) {
    final t = ref.watch(appTokensProvider);
    final ts = AppTextStyles.of(t);
    final dialogue = widget.dialogue;

    if (dialogue == null) {
      return Column(
        children: [
          Expanded(
              child: Center(
                  child: Text('Диалог не найден', style: ts.displayMedium))),
          LessonBottomNextButton(
              visible: true, label: 'Пропустить', onTap: widget.onNext),
        ],
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Диалог', style: ts.displayMedium),
                    Text(dialogue.titleRu, style: ts.bodyMuted),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                    color: t.accentSoft,
                    borderRadius: BorderRadius.circular(12)),
                child: Text(
                  '${_shownTurns.length}/${dialogue.turns.length}',
                  style: ts.caption
                      .copyWith(color: t.accent, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
        ),

        // FIX: подсказка — нажми на реплику чтобы увидеть перевод
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            '💡 Нажми на реплику, чтобы увидеть перевод',
            style: ts.caption
                .copyWith(color: t.onSurfaceMuted, fontStyle: FontStyle.italic),
          ),
        ),
        const SizedBox(height: 8),

        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _shownTurns.length,
            itemBuilder: (_, i) {
              final shown = _shownTurns[i];
              final isUser = shown.turn.role == 'user';
              final isExpanded = _expandedTurnIndex == i;

              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  mainAxisAlignment:
                      isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!isUser) ...[
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: t.accentSoft,
                        child: Text('李',
                            style: ts.caption.copyWith(color: t.accent)),
                      ),
                      const SizedBox(width: 8),
                    ],
                    Flexible(
                         child: GestureDetector(
                           // FIX: перевод появляется только при нажатии на реплику + TTS
                           onTap: () {
                             ref.read(audioServiceProvider).speakChineseText(shown.turn.zh);
                             setState(() {
                               _expandedTurnIndex = isExpanded ? null : i;
                             });
                           },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.all(11),
                          decoration: BoxDecoration(
                            color: isUser
                                ? (shown.wasGuessed
                                    ? (shown.correct
                                        ? t.accentSuccess
                                            .withValues(alpha: 0.15)
                                        : t.accentDanger
                                            .withValues(alpha: 0.12))
                                    : t.accent.withValues(alpha: 0.15))
                                : t.surface,
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(14),
                              topRight: const Radius.circular(14),
                              bottomLeft: Radius.circular(isUser ? 14 : 4),
                              bottomRight: Radius.circular(isUser ? 4 : 14),
                            ),
                            border: Border.all(
                              color: isUser
                                  ? (shown.wasGuessed
                                      ? (shown.correct
                                          ? t.accentSuccess
                                              .withValues(alpha: 0.4)
                                          : t.accentDanger
                                              .withValues(alpha: 0.3))
                                      : t.accent.withValues(alpha: 0.3))
                                  : t.surfaceBorder,
                              width: 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(shown.turn.zh,
                                  style: ts.hanziSmall
                                      .copyWith(color: t.onSurface)),
                              if (widget.pinyinEnabled) ...[
                                const SizedBox(height: 2),
                                Text(shown.turn.pinyin, style: ts.pinyin),
                              ],
                              // FIX: перевод ТОЛЬКО при нажатии (isExpanded)
                              if (isExpanded) ...[
                                const SizedBox(height: 6),
                                Text(shown.turn.ru,
                                    style: ts.bodyMuted
                                        .copyWith(fontStyle: FontStyle.italic)),
                              ],
                              // Показываем что выбрал если ошибся
                              if (shown.wasGuessed &&
                                  !shown.correct &&
                                  shown.userChose != null)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text(
                                    'Ты: ${shown.userChose}',
                                    style: ts.caption
                                        .copyWith(color: t.accentDanger),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    if (isUser) ...[
                      const SizedBox(width: 8),
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: t.accentSoft,
                        child: Icon(Icons.person, size: 16, color: t.accent),
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
        ),

        // Варианты выбора
        if (_waitingForChoice) ...[
          Container(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: Text('Выбери подходящую реплику:', style: ts.bodyMuted),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              children: _options.map((option) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: GestureDetector(
                    onTap: () => _selectOption(option),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: t.surface,
                        borderRadius: BorderRadius.circular(t.radiusButton),
                        border: Border.all(
                            color: t.accent.withValues(alpha: 0.3), width: 1.5),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(option.zh,
                              style:
                                  ts.hanziSmall.copyWith(color: t.onSurface)),
                          if (widget.pinyinEnabled)
                            Text(option.pinyin, style: ts.pinyin),
                          // FIX: перевод в вариантах НЕ показываем
                          // Пользователь должен понять по контексту/иероглифам
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],

        LessonBottomNextButton(
            visible: _finished, label: 'Готово', onTap: widget.onNext),
      ],
    );
  }
}

class _ShownTurn {
  final DialogueTurn turn;
  final bool wasGuessed;
  final bool correct;
  final String? userChose;

  const _ShownTurn({
    required this.turn,
    required this.wasGuessed,
    required this.correct,
    this.userChose,
  });
}

// ═════════════════════════════════════════════════════════════════════════════
// CALLIGRAPHY — пошаговое обучение чертам
// ═════════════════════════════════════════════════════════════════════════════

class CalligraphyExercise extends ConsumerStatefulWidget {
  final Word? word;
  final String? wordId;
  final bool showGuide;
  final VoidCallback onNext;

  const CalligraphyExercise({
    this.word,
    this.wordId,
    required this.showGuide,
    required this.onNext,
    super.key,
  });

  @override
  ConsumerState<CalligraphyExercise> createState() => _CalligraphyState();
}

class _CalligraphyState extends ConsumerState<CalligraphyExercise> {
  // For free-draw fallback when stroke data is unavailable
  final List<List<Offset>> _strokes = [];
  bool _isDone = false;
  HanziStrokeData? _strokeData;
  int _completedStrokes = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStrokeData();
  }

  Future<void> _loadStrokeData() async {
    final word = widget.word;
    if (word == null || word.hanzi.length != 1) {
      setState(() => _isLoading = false);
      return;
    }

    final service = StrokeDataService();
    final data = await service.loadStrokeData(word.hanzi);

    setState(() {
      _strokeData = data;
      _completedStrokes = 0;
      _isLoading = false;
    });
  }

  void _onStrokeCompleted() {
    setState(() {
      _completedStrokes++;
    });
  }

  void _onCharacterCompleted() {
    setState(() {
      _isDone = true;
    });
  }

  void _retryCharacter() {
    setState(() {
      _strokes.clear();
      _completedStrokes = 0;
      _isDone = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = ref.watch(appTokensProvider);
    final ts = AppTextStyles.of(t);
    final word = widget.word;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Напиши иероглиф', style: ts.displayMedium),
              if (word != null)
                Row(children: [
                  Text('${word.pinyin}  ', style: ts.pinyinLarge),
                  Text(word.translationRu, style: ts.bodyMuted),
                ]),
              if (_strokeData != null && !_isLoading)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    'Черта: $_completedStrokes/${_strokeData!.strokeCount}',
                    style: ts.caption.copyWith(
                      color: t.accent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: AspectRatio(
              aspectRatio: 1,
              child: _isLoading
                  ? Center(child: CircularProgressIndicator(color: t.accent))
                  : _strokeData == null
                      ? _LessonFreeDrawCanvas(
                          hanzi: word?.hanzi ?? '？',
                          showGuide: widget.showGuide,
                          gridColor: t.surfaceBorder,
                          strokeColor: t.onSurface,
                          guideColor: t.onSurface.withValues(alpha: 0.1),
                          surface: t.surface,
                          radiusCard: t.radiusCard,
                          surfaceBorder: t.surfaceBorder,
                          onDone: () => setState(() => _isDone = true),
                          hasStrokes: _strokes.isNotEmpty,
                        )
                      : Container(
                          decoration: BoxDecoration(
                            color: t.surface,
                            borderRadius: BorderRadius.circular(t.radiusCard),
                            border:
                                Border.all(color: t.surfaceBorder, width: 2),
                          ),
                          child: StrokePracticeCanvas(
                            strokeData: _strokeData!,
                            completedStrokes: _completedStrokes,
                            showHint: widget.showGuide,
                            onStrokeCompleted: _onStrokeCompleted,
                            onCharacterCompleted: _onCharacterCompleted,
                            strokeColor: t.onSurface,
                            hintColor: t.accent,
                            gridColor: t.surfaceBorder,
                          ),
                        ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: _retryCharacter,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: t.surfaceHighlight,
                      borderRadius: BorderRadius.circular(t.radiusButton),
                      border: Border.all(color: t.surfaceBorder),
                    ),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.refresh_rounded,
                              color: t.onSurfaceMuted, size: 18),
                          const SizedBox(width: 6),
                          Text('Очистить',
                              style:
                                  ts.label.copyWith(color: t.onSurfaceMuted)),
                        ]),
                  ),
                ),
              ),
              if (_strokeData == null) ...[
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: _strokes.isNotEmpty
                        ? () => setState(() => _isDone = true)
                        : null,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: _strokes.isNotEmpty
                            ? t.accentSuccess.withValues(alpha: 0.15)
                            : t.surfaceHighlight,
                        borderRadius: BorderRadius.circular(t.radiusButton),
                        border: Border.all(
                          color: _strokes.isNotEmpty
                              ? t.accentSuccess
                              : t.surfaceBorder,
                        ),
                      ),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.check_rounded,
                                color: _strokes.isNotEmpty
                                    ? t.accentSuccess
                                    : t.onSurfaceDisabled,
                                size: 18),
                            const SizedBox(width: 6),
                            Text('Готово',
                                style: ts.label.copyWith(
                                    color: _strokes.isNotEmpty
                                        ? t.accentSuccess
                                        : t.onSurfaceDisabled)),
                          ]),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        LessonBottomNextButton(
            visible: _isDone, label: 'Далее', onTap: widget.onNext),
      ],
    );
  }
}

/// Свободное рисование в уроке когда нет данных о чертах.
class _LessonFreeDrawCanvas extends StatefulWidget {
  final String hanzi;
  final bool showGuide;
  final Color gridColor;
  final Color strokeColor;
  final Color guideColor;
  final Color surface;
  final double radiusCard;
  final Color surfaceBorder;
  final VoidCallback onDone;
  final bool hasStrokes;

  const _LessonFreeDrawCanvas({
    required this.hanzi,
    required this.showGuide,
    required this.gridColor,
    required this.strokeColor,
    required this.guideColor,
    required this.surface,
    required this.radiusCard,
    required this.surfaceBorder,
    required this.onDone,
    required this.hasStrokes,
  });

  @override
  State<_LessonFreeDrawCanvas> createState() => _LessonFreeDrawState();
}

class _LessonFreeDrawState extends State<_LessonFreeDrawCanvas> {
  final List<List<Offset>> _strokes = [];
  List<Offset> _current = [];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (d) => setState(() => _current = [d.localPosition]),
      onPanUpdate: (d) => setState(() => _current.add(d.localPosition)),
      onPanEnd: (_) => setState(() {
        if (_current.length > 2) _strokes.add(List.from(_current));
        _current = [];
      }),
      child: CustomPaint(
        painter: _CalligraphyPainter(
          hanzi: widget.hanzi,
          showGuide: widget.showGuide,
          strokes: _strokes,
          current: _current,
          gridColor: widget.gridColor,
          strokeColor: widget.strokeColor,
          guideColor: widget.guideColor,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: widget.surface,
            borderRadius: BorderRadius.circular(widget.radiusCard),
            border: Border.all(color: widget.surfaceBorder, width: 2),
          ),
        ),
      ),
    );
  }
}

class _CalligraphyPainter extends CustomPainter {
  final String hanzi;
  final bool showGuide;
  final List<List<Offset>> strokes;
  final List<Offset> current;
  final Color gridColor;
  final Color strokeColor;
  final Color guideColor;

  const _CalligraphyPainter({
    required this.hanzi,
    required this.showGuide,
    required this.strokes,
    required this.current,
    required this.gridColor,
    required this.strokeColor,
    required this.guideColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final gp = Paint()
      ..color = gridColor
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    final step = size.width / 4;
    for (int i = 1; i < 4; i++) {
      canvas.drawLine(Offset(step * i, 0), Offset(step * i, size.height), gp);
      canvas.drawLine(Offset(0, step * i), Offset(size.width, step * i), gp);
    }
    final dp = Paint()
      ..color = gridColor.withValues(alpha: 0.4)
      ..strokeWidth = 0.5;
    canvas.drawLine(Offset.zero, Offset(size.width, size.height), dp);
    canvas.drawLine(Offset(size.width, 0), Offset(0, size.height), dp);

    if (showGuide) {
      final tp = TextPainter(
        text: TextSpan(
            text: hanzi,
            style: TextStyle(
                fontSize: size.width * 0.65,
                color: guideColor,
                fontFamily: 'NotoSansSC')),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas,
          Offset((size.width - tp.width) / 2, (size.height - tp.height) / 2));
    }

    final sp = Paint()
      ..color = strokeColor
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    for (final stroke in [...strokes, current]) {
      if (stroke.length < 2) continue;
      final path = Path()..moveTo(stroke.first.dx, stroke.first.dy);
      for (final p in stroke.skip(1)) path.lineTo(p.dx, p.dy);
      canvas.drawPath(path, sp);
    }
  }

  @override
  bool shouldRepaint(_CalligraphyPainter old) => true;
}

// ── Placeholder ───────────────────────────────────────────────────────────────

class ListeningExercise extends ConsumerStatefulWidget {
  final List<Word> words;
  final String? audioPath;
  final String prompt;
  final List<String> options;
  final String? correctAnswer;
  final int maxPlays;
  final bool isFinalTest;
  final void Function(bool) onAnswer;
  final VoidCallback onNext;

  const ListeningExercise({
    required this.words,
    required this.audioPath,
    required this.prompt,
    required this.options,
    required this.correctAnswer,
    required this.maxPlays,
    required this.isFinalTest,
    required this.onAnswer,
    required this.onNext,
    super.key,
  });

  @override
  ConsumerState<ListeningExercise> createState() => _ListeningExerciseState();
}

class _ListeningExerciseState extends ConsumerState<ListeningExercise> {
  int _plays = 0;
  String? _selected;
  bool _answered = false;
  bool _playedOnce = false;

  String? get _answer =>
      widget.correctAnswer ??
      (widget.words.isNotEmpty ? widget.words.first.translationRu : null);

  List<String> _buildOptions() {
    if (widget.options.isNotEmpty) return widget.options;
    final pool = widget.words
        .map((w) => w.translationRu)
        .where((v) => v.isNotEmpty)
        .toSet()
        .toList();
    if (_answer != null && !pool.contains(_answer)) pool.insert(0, _answer!);
    return pool.take(4).toList();
  }

  Future<void> _play() async {
    if (_plays >= widget.maxPlays) return;
    final audio = ref.read(audioServiceProvider);
    if (widget.audioPath != null && widget.audioPath!.isNotEmpty) {
      await audio.playAsset(widget.audioPath!);
    } else if (widget.words.isNotEmpty) {
      await audio.playWord(widget.words.first.audioPath);
    }
    setState(() {
      _plays++;
      _playedOnce = true;
    });
  }

  void _select(String option) {
    if (_answered) return;
    final correct = _answer != null && option == _answer;
    setState(() {
      _selected = option;
      _answered = true;
    });
    widget.onAnswer(correct);
    // Play sound feedback
    final audioService = ref.read(audioServiceProvider);
    if (correct) {
      audioService.playSfx('correct');
    } else {
      audioService.playSfx('wrong');
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = ref.watch(appTokensProvider);
    final ts = AppTextStyles.of(t);
    final options = _buildOptions();
    final canPlay = _plays < widget.maxPlays;

    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Аудирование', style: ts.displayMedium),
                const SizedBox(height: 6),
                Text(widget.prompt, style: ts.bodyMuted),
                const SizedBox(height: 24),
                Center(
                  child: GestureDetector(
                    onTap: canPlay ? _play : null,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 18),
                      decoration: BoxDecoration(
                        color: canPlay ? t.accentSoft : t.surface,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: canPlay ? t.accent : t.surfaceBorder,
                            width: 1.5),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.play_arrow_rounded,
                              size: 44,
                              color: canPlay ? t.accent : t.onSurfaceMuted),
                          const SizedBox(height: 8),
                          Text('Прослушать (${_plays}/${widget.maxPlays})',
                              style: ts.label),
                          if (widget.isFinalTest) ...[
                            const SizedBox(height: 4),
                            Text('В тесте не более 2 прослушиваний',
                                style: ts.caption
                                    .copyWith(color: t.onSurfaceMuted)),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                if (widget.isFinalTest && _playedOnce) ...[
                  Text('Выбери правильный ответ', style: ts.body),
                  const SizedBox(height: 12),
                ],
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: options.map((opt) {
                    final selected = _selected == opt;
                    final correct = _answered && _answer == opt;
                    Color bg = t.surface;
                    Color border = t.surfaceBorder;
                    if (_answered) {
                      if (correct) {
                        bg = t.accentSuccess.withValues(alpha: 0.15);
                        border = t.accentSuccess;
                      } else if (selected) {
                        bg = t.accentDanger.withValues(alpha: 0.15);
                        border = t.accentDanger;
                      }
                    } else if (selected) {
                      bg = t.accentSoft;
                      border = t.accent;
                    }
                    return GestureDetector(
                      onTap: () => _select(opt),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: bg,
                          borderRadius: BorderRadius.circular(t.radiusButton),
                          border: Border.all(color: border, width: 1.5),
                        ),
                        child: Text(opt, style: ts.body),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
        LessonBottomNextButton(
            visible: _answered, label: 'Далее', onTap: widget.onNext),
      ],
    );
  }
}

class _PlaceholderExercise extends ConsumerWidget {
  final ExerciseType type;
  final VoidCallback onNext;
  const _PlaceholderExercise({required this.type, required this.onNext});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(appTokensProvider);
    final ts = AppTextStyles.of(t);
    return Column(
      children: [
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('🚧', style: TextStyle(fontSize: 48)),
                const SizedBox(height: 16),
                Text(type.name, style: ts.displayMedium),
                const SizedBox(height: 8),
                Text('Будет реализовано позже', style: ts.bodyMuted),
              ],
            ),
          ),
        ),
        LessonBottomNextButton(visible: true, label: 'Далее', onTap: onNext),
      ],
    );
  }
}

// ── Публичная кнопка (используется в отдельных файлах упражнений) ─────────────

class LessonBottomNextButton extends ConsumerWidget {
  final bool visible;
  final String label;
  final VoidCallback onTap;

  const LessonBottomNextButton({
    required this.visible,
    required this.label,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(appTokensProvider);
    final ts = AppTextStyles.of(t);

    if (!visible) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: SafeArea(
        top: false,
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: t.accent,
              borderRadius: BorderRadius.circular(t.radiusButton),
              boxShadow: t.buttonShadow,
            ),
            child: Text(label,
                style: ts.headlineLarge
                    .copyWith(color: Colors.white, fontWeight: FontWeight.w700),
                textAlign: TextAlign.center),
          ),
        ),
      ),
    );
  }
}

// Extension
extension ListWhereOrNull<T> on List<T> {
  T? firstWhereOrNull(bool Function(T) test) {
    for (final e in this) {
      if (test(e)) return e;
    }
    return null;
  }
}

// AppBackground
