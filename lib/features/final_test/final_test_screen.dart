// lib/features/final_test/final_test_screen.dart
//
// Итоговый тест темы.
// Отличия от урока:
//   • 2 жизни (❤️ ❤️)
//   • Пиньинь ВЫКЛ, включить нельзя
//   • CalligraphyExercise без образца
//   • ListeningExercise — не более 2 прослушиваний
//   • При 0 жизнях — экран провала
//   • При прохождении — finalTestPassed = true + Achievement

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_tokens.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_card.dart';
import '../../data/models/models.dart';
import '../../data/repositories/content_repository.dart';
import '../lesson/lesson_screen.dart';

// ── Состояние теста ───────────────────────────────────────────────────────────

class FinalTestState {
  final int lives; // 0-2
  final int currentIndex;
  final int totalExercises;
  final int correctAnswers;
  final bool pinyinEnabled; // всегда false, нельзя изменить
  final bool isFinished;
  final bool isPassed;

  const FinalTestState({
    this.lives = 2,
    this.currentIndex = 0,
    this.totalExercises = 0,
    this.correctAnswers = 0,
    this.pinyinEnabled = false,
    this.isFinished = false,
    this.isPassed = false,
  });

  FinalTestState copyWith({
    int? lives,
    int? currentIndex,
    int? totalExercises,
    int? correctAnswers,
    bool? isFinished,
    bool? isPassed,
  }) =>
      FinalTestState(
        lives: lives ?? this.lives,
        currentIndex: currentIndex ?? this.currentIndex,
        totalExercises: totalExercises ?? this.totalExercises,
        correctAnswers: correctAnswers ?? this.correctAnswers,
        pinyinEnabled: false,
        isFinished: isFinished ?? this.isFinished,
        isPassed: isPassed ?? this.isPassed,
      );

  double get progress =>
      totalExercises == 0 ? 0 : currentIndex / totalExercises;
}

class FinalTestNotifier extends StateNotifier<FinalTestState> {
  FinalTestNotifier(int total) : super(FinalTestState(totalExercises: total));

  void answer(bool correct) {
    if (correct) {
      state = state.copyWith(correctAnswers: state.correctAnswers + 1);
    } else {
      final newLives = state.lives - 1;
      if (newLives <= 0) {
        state = state.copyWith(lives: 0, isFinished: true, isPassed: false);
        return;
      }
      state = state.copyWith(lives: newLives);
    }
  }

  void next() {
    if (state.isFinished) return;
    if (state.currentIndex + 1 >= state.totalExercises) {
      state = state.copyWith(isFinished: true, isPassed: state.lives > 0);
    } else {
      state = state.copyWith(currentIndex: state.currentIndex + 1);
    }
  }
}

final finalTestProvider = StateNotifierProvider.autoDispose
    .family<FinalTestNotifier, FinalTestState, int>(
        (ref, total) => FinalTestNotifier(total));

// ── FinalTestScreen ───────────────────────────────────────────────────────────

class FinalTestScreen extends ConsumerStatefulWidget {
  final String topicId;
  const FinalTestScreen({required this.topicId, super.key});

  @override
  ConsumerState<FinalTestScreen> createState() => _FinalTestScreenState();
}

class _FinalTestScreenState extends ConsumerState<FinalTestScreen> {
  late PageController _pageController;
  Topic? _topic;
  List<_ExItem> _exercises = [];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _loadData();
  }

  void _loadData() {
    final repo = ref.read(contentRepositoryProvider);
    final topic = repo.getTopic(widget.topicId);
    if (topic == null) return;
    _topic = topic;

    // Собираем все слова темы
    final allWords = topic.words;
    final rng = Random();

    // Генерируем упражнения из всех слов темы
    _exercises = [];
    if (allWords.length >= 4) {
      // wordMatching
      _exercises.add(_ExItem(
        config: ExerciseConfig(
          type: ExerciseType.wordMatching,
          params: {'pairCount': min(4, allWords.length)},
        ),
        words: allWords,
      ));
    }
    // translation x3
    final shuffled = [...allWords]..shuffle(rng);
    for (int i = 0; i < min(3, shuffled.length); i++) {
      _exercises.add(_ExItem(
        config: ExerciseConfig(
          type: ExerciseType.translation,
          params: {'direction': i % 2 == 0 ? 'zh_to_ru' : 'ru_to_zh'},
        ),
        words: shuffled,
      ));
    }
    // listening (2 попытки)
    if (allWords.isNotEmpty) {
      final target = allWords.first;
      _exercises.add(_ExItem(
        config: ExerciseConfig(
          type: ExerciseType.listening,
          params: {
            'audioPath':
                target.audioPath ?? 'assets/audio/words/${target.id}.mp3',
            'prompt': 'Прослушай аудио и выбери правильный перевод',
            'options': allWords.take(4).map((w) => w.translationRu).toList(),
            'correctAnswer': target.translationRu,
            'maxPlays': 2,
          },
        ),
        words: allWords,
      ));
    }
    // calligraphy (без образца)
    if (allWords.isNotEmpty) {
      _exercises.add(_ExItem(
        config: const ExerciseConfig(
          type: ExerciseType.calligraphy,
          params: {},
        ),
        words: [allWords[rng.nextInt(allWords.length)]],
      ));
    }

    _exercises.shuffle(rng);
    setState(() {});
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = ref.watch(appTokensProvider);
    final ts = AppTextStyles.of(t);
    final testState = ref.watch(finalTestProvider(_exercises.length));

    // Провал — 0 жизней
    if (testState.isFinished && !testState.isPassed) {
      return AppBackground(
        child: _FailScreen(
          topicId: widget.topicId,
          correct: testState.correctAnswers,
          total: _exercises.length,
        ),
      );
    }

    // Успех
    if (testState.isFinished && testState.isPassed) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.pushReplacement(
          '/lesson-result/${widget.topicId}'
          '?correct=${testState.correctAnswers}'
          '&total=${_exercises.length}'
          '&isFinalTest=true',
        );
      });
    }

    if (_exercises.isEmpty) {
      return AppBackground(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(child: Text('Загрузка...', style: ts.displayMedium)),
        ),
      );
    }

    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              _FinalTestTopBar(
                state: testState,
                totalExercises: _exercises.length,
                onClose: () => _confirmClose(context, ref, t, ts),
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
                      dialogue: null,
                      pinyinEnabled: false, // тест — всегда без пиньиня
                      isFinalTest: true,
                      onAnswer: (correct) {
                        ref
                            .read(finalTestProvider(_exercises.length).notifier)
                            .answer(correct);
                      },
                      onNext: () {
                        final notifier = ref.read(
                            finalTestProvider(_exercises.length).notifier);
                        final st =
                            ref.read(finalTestProvider(_exercises.length));
                        notifier.next();
                        if (!st.isFinished &&
                            st.currentIndex + 1 < _exercises.length) {
                          _pageController.animateToPage(
                            st.currentIndex + 1,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
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

  void _confirmClose(
      BuildContext context, WidgetRef ref, AppTokens t, AppTextStyles ts) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: t.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Выйти из теста?', style: ts.headlineLarge),
        content: Text('Прогресс теста не сохранится.', style: ts.body),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Остаться', style: ts.label.copyWith(color: t.accent)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.pop();
            },
            child:
                Text('Выйти', style: ts.label.copyWith(color: t.accentDanger)),
          ),
        ],
      ),
    );
  }
}

class _ExItem {
  final ExerciseConfig config;
  final List<Word> words;
  const _ExItem({required this.config, required this.words});
}

// ── TopBar теста ──────────────────────────────────────────────────────────────

class _FinalTestTopBar extends ConsumerWidget {
  final FinalTestState state;
  final int totalExercises;
  final VoidCallback onClose;

  const _FinalTestTopBar({
    required this.state,
    required this.totalExercises,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(appTokensProvider);
    final ts = AppTextStyles.of(t);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Прогресс-бар оранжевый
        LinearProgressIndicator(
          value: state.progress,
          minHeight: 4,
          backgroundColor: t.surfaceBorder,
          valueColor: AlwaysStoppedAnimation(t.accentWarn),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              GestureDetector(
                onTap: onClose,
                child: Icon(Icons.close_rounded,
                    color: t.onSurfaceMuted, size: 24),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.emoji_events_rounded,
                        color: t.accentWarn, size: 18),
                    const SizedBox(width: 6),
                    Text('Итоговый тест',
                        style: ts.headlineMedium.copyWith(color: t.accentWarn)),
                  ],
                ),
              ),
              // Жизни
              Row(
                children: List.generate(2, (i) {
                  final alive = i < state.lives;
                  return Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: Icon(
                      alive
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      color: alive ? t.accentDanger : t.onSurfaceDisabled,
                      size: 22,
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Экран провала ─────────────────────────────────────────────────────────────

class _FailScreen extends ConsumerWidget {
  final String topicId;
  final int correct;
  final int total;

  const _FailScreen({
    required this.topicId,
    required this.correct,
    required this.total,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(appTokensProvider);
    final ts = AppTextStyles.of(t);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('😓', style: TextStyle(fontSize: 72)),
              const SizedBox(height: 20),
              Text('Попробуй ещё раз',
                  style: ts.displayLarge, textAlign: TextAlign.center),
              const SizedBox(height: 8),
              Text(
                'Не хватило жизней. Повтори тему и попробуй снова.',
                style: ts.bodyMuted,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text('$correct / $total правильных ответов',
                  style: ts.body.copyWith(color: t.onSurfaceMuted)),
              const SizedBox(height: 40),
              GestureDetector(
                onTap: () => context.pushReplacement('/final-test/$topicId'),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: t.accent,
                    borderRadius: BorderRadius.circular(t.radiusButton),
                    boxShadow: t.buttonShadow,
                  ),
                  child: Text('Попробовать снова',
                      style: ts.headlineLarge.copyWith(
                          color: Colors.white, fontWeight: FontWeight.w700),
                      textAlign: TextAlign.center),
                ),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () => context.go('/topic/$topicId'),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: t.surfaceHighlight,
                    borderRadius: BorderRadius.circular(t.radiusButton),
                    border: Border.all(color: t.surfaceBorder),
                  ),
                  child: Text('Повторить тему',
                      style:
                          ts.headlineMedium.copyWith(color: t.onSurfaceMuted),
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
