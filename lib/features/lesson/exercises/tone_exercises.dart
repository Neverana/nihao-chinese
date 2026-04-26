// lib/features/lesson/exercises/tone_exercises.dart
//
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/audio/audio_service.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../../../data/models/models.dart';

// ═════════════════════════════════════════════════════════════════════════════
// 1. TONE SELECTION — выбери правильный тон
// ═════════════════════════════════════════════════════════════════════════════

class ToneSelectionExercise extends ConsumerStatefulWidget {
  final List<Word> words;
  final void Function(bool) onAnswer;
  final VoidCallback onNext;

  const ToneSelectionExercise({
    required this.words,
    required this.onAnswer,
    required this.onNext,
    super.key,
  });

  @override
  ConsumerState<ToneSelectionExercise> createState() => _ToneSelectionState();
}

class _ToneSelectionState extends ConsumerState<ToneSelectionExercise> {
  late Word _target;
  late List<String> _options; // 4 варианта пиньиня с разными тонами
  int? _selectedIndex;
  bool _answered = false;

  // Маркеры тонов для подстановки
  static const _toneMarkers = ['¯', '/', 'ˇ', '\\', '·']; // 1-5 условно

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() {
    final rng = Random();
    final pool = [...widget.words]..shuffle(rng);
    _target = pool.first;

    // Строим 4 варианта: правильный пиньинь + 3 с варьированными тонами
    final correct = _target.pinyin;
    final variants = _generateToneVariants(correct);
    _options = ([correct, ...variants.take(3)])..shuffle(rng);

    _selectedIndex = null;
    _answered = false;
  }

  List<String> _generateToneVariants(String pinyin) {
    // Простая замена тоновых диакритиков для генерации неправильных вариантов
    const toneMap = {
      'ā': ['á', 'ǎ', 'à', 'a'],
      'á': ['ā', 'ǎ', 'à', 'a'],
      'ǎ': ['ā', 'á', 'à', 'a'],
      'à': ['ā', 'á', 'ǎ', 'a'],
      'ē': ['é', 'ě', 'è', 'e'],
      'é': ['ē', 'ě', 'è', 'e'],
      'ě': ['ē', 'é', 'è', 'e'],
      'è': ['ē', 'é', 'ě', 'e'],
      'ī': ['í', 'ǐ', 'ì', 'i'],
      'í': ['ī', 'ǐ', 'ì', 'i'],
      'ǐ': ['ī', 'í', 'ì', 'i'],
      'ì': ['ī', 'í', 'ǐ', 'i'],
      'ō': ['ó', 'ǒ', 'ò', 'o'],
      'ó': ['ō', 'ǒ', 'ò', 'o'],
      'ǒ': ['ō', 'ó', 'ò', 'o'],
      'ò': ['ō', 'ó', 'ǒ', 'o'],
      'ū': ['ú', 'ǔ', 'ù', 'u'],
      'ú': ['ū', 'ǔ', 'ù', 'u'],
      'ǔ': ['ū', 'ú', 'ù', 'u'],
      'ù': ['ū', 'ú', 'ǔ', 'u'],
    };

    final variants = <String>{};
    final rng = Random();

    for (int attempt = 0; attempt < 20 && variants.length < 3; attempt++) {
      var variant = pinyin;
      for (final entry in toneMap.entries) {
        if (variant.contains(entry.key)) {
          final replacements = entry.value;
          final replacement = replacements[rng.nextInt(replacements.length)];
          variant = variant.replaceFirst(entry.key, replacement);
          break;
        }
      }
      if (variant != pinyin) variants.add(variant);
    }

    // Если не смогли сгенерировать — добавляем варианты из других слов
    if (variants.length < 3) {
      for (final w in widget.words) {
        if (w.id != _target.id && variants.length < 3) {
          variants.add(w.pinyin);
        }
      }
    }

    return variants.take(3).toList();
  }

   void _select(int i) {
     if (_answered) return;
     final correct = _options[i] == _target.pinyin;
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

  @override
  Widget build(BuildContext context) {
    final t = ref.watch(appTokensProvider);
    final ts = AppTextStyles.of(t);

    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Выбери правильный тон',
                      style: ts.displayMedium),
                ),
                const SizedBox(height: 6),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Как читается этот иероглиф?',
                      style: ts.bodyMuted),
                ),
                const SizedBox(height: 40),

                 // Иероглиф крупно
                 AppCard(
                   padding: const EdgeInsets.symmetric(
                       horizontal: 40, vertical: 32),
                   child: Column(
                     children: [
                        GestureDetector(
                          onTap: () {
                            ref.read(audioServiceProvider).speakChineseText(_target.hanzi);
                          },
                          child: Text(
                            _target.hanzi,
                            style: ts.hanziHero.copyWith(color: t.onSurface),
                          ),
                        ),
                       const SizedBox(height: 8),
                       Text(_target.translationRu,
                           style: ts.bodyMuted,
                           textAlign: TextAlign.center),
                     ],
                   ),
                 ),
                const SizedBox(height: 32),

                // 4 варианта пиньиня
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 2.8,
                  children: List.generate(_options.length, (i) {
                    final opt = _options[i];
                    final isCorrect = opt == _target.pinyin;
                    final isSelected = _selectedIndex == i;

                    Color bg = t.surface;
                    Color border = t.surfaceBorder;
                    if (_answered) {
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
                      onTap: () => _select(i),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          color: bg,
                          borderRadius:
                              BorderRadius.circular(t.radiusButton),
                          border:
                              Border.all(color: border, width: 1.5),
                        ),
                        child: Center(
                          child: Text(opt,
                              style: ts.pinyinLarge.copyWith(
                                  color: t.onSurface)),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
        _BottomNextButton(
            visible: _answered, label: 'Далее', onTap: widget.onNext),
      ],
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// 2. PINYIN INPUT — введи пиньинь для иероглифа
// ═════════════════════════════════════════════════════════════════════════════

class PinyinInputExercise extends ConsumerStatefulWidget {
  final List<Word> words;
  final bool pinyinEnabled;
  final void Function(bool) onAnswer;
  final VoidCallback onNext;

  const PinyinInputExercise({
    required this.words,
    required this.pinyinEnabled,
    required this.onAnswer,
    required this.onNext,
    super.key,
  });

  @override
  ConsumerState<PinyinInputExercise> createState() => _PinyinInputState();
}

class _PinyinInputState extends ConsumerState<PinyinInputExercise> {
  late Word _target;
  final _controller = TextEditingController();
  bool _answered = false;
  bool _correct = false;
  String _userInput = '';

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() {
    final rng = Random();
    final pool = [...widget.words]..shuffle(rng);
    _target = pool.first;
    _controller.clear();
    _answered = false;
    _correct = false;
    _userInput = '';
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _normalize(String s) =>
      s.trim().toLowerCase().replaceAll(' ', '');

  void _check() {
    _userInput = _controller.text;
    final input = _normalize(_userInput);
    final expected = _normalize(_target.pinyin);
    // Принимаем: с тонами (точно) или без тонов (упрощённо)
    final expectedNoTones = _stripTones(expected);
    final correct =
        input == expected || input == expectedNoTones;
    setState(() {
      _answered = true;
      _correct = correct;
    });
    widget.onAnswer(correct);
  }

  String _stripTones(String s) {
    const toneMap = {
      'ā': 'a', 'á': 'a', 'ǎ': 'a', 'à': 'a',
      'ē': 'e', 'é': 'e', 'ě': 'e', 'è': 'e',
      'ī': 'i', 'í': 'i', 'ǐ': 'i', 'ì': 'i',
      'ō': 'o', 'ó': 'o', 'ǒ': 'o', 'ò': 'o',
      'ū': 'u', 'ú': 'u', 'ǔ': 'u', 'ù': 'u',
      'ǖ': 'v', 'ǘ': 'v', 'ǚ': 'v', 'ǜ': 'v', 'ü': 'v',
    };
    var result = s;
    for (final e in toneMap.entries) {
      result = result.replaceAll(e.key, e.value);
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final t = ref.watch(appTokensProvider);
    final ts = AppTextStyles.of(t);

    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Введи пиньинь', style: ts.displayMedium),
                const SizedBox(height: 6),
                Text('Напиши транскрипцию для этого иероглифа',
                    style: ts.bodyMuted),
                const SizedBox(height: 40),

                // Иероглиф
                Center(
                  child: AppCard(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 48, vertical: 32),
                    child: Column(
                      children: [
                        Text(_target.hanzi,
                            style: ts.hanziHero
                                .copyWith(color: t.onSurface)),
                        const SizedBox(height: 8),
                        Text(_target.translationRu,
                            style: ts.bodyMuted),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Поле ввода
                TextField(
                  controller: _controller,
                  enabled: !_answered,
                  autofocus: true,
                  textAlign: TextAlign.center,
                  style: ts.pinyinLarge.copyWith(color: t.onSurface),
                  decoration: InputDecoration(
                    hintText: 'nǐ hǎo...',
                    hintStyle: ts.bodyMuted,
                    filled: true,
                    fillColor: t.surfaceHighlight,
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
                      borderSide:
                          BorderSide(color: t.accent, width: 2),
                    ),
                    suffixIcon: _answered
                        ? Icon(
                            _correct
                                ? Icons.check_circle_rounded
                                : Icons.cancel_rounded,
                            color: _correct
                                ? t.accentSuccess
                                : t.accentDanger,
                          )
                        : null,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 16),
                  ),
                  onSubmitted: (_) {
                    if (!_answered) _check();
                  },
                ),

                // Результат
                if (_answered) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: _correct
                          ? t.accentSuccess.withValues(alpha: 0.1)
                          : t.accentDanger.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _correct
                            ? t.accentSuccess.withValues(alpha: 0.4)
                            : t.accentDanger.withValues(alpha: 0.4),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          _correct
                              ? Icons.check_circle_rounded
                              : Icons.cancel_rounded,
                          color: _correct
                              ? t.accentSuccess
                              : t.accentDanger,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _correct ? 'Правильно!' : 'Ошибка',
                              style: ts.headlineMedium.copyWith(
                                color: _correct
                                    ? t.accentSuccess
                                    : t.accentDanger,
                              ),
                            ),
                            if (!_correct)
                              Text(
                                'Правильно: ${_target.pinyin}',
                                style: ts.body
                                    .copyWith(color: t.onSurfaceMuted),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],

                if (!_answered) ...[
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: _check,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: t.accentSoft,
                        borderRadius:
                            BorderRadius.circular(t.radiusButton),
                        border: Border.all(
                            color: t.accent.withValues(alpha: 0.4)),
                      ),
                      child: Text('Проверить',
                          style: ts.headlineMedium
                              .copyWith(color: t.accent),
                          textAlign: TextAlign.center),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        _BottomNextButton(
            visible: _answered, label: 'Далее', onTap: widget.onNext),
      ],
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// 3. TRUE OR FALSE — верно / неверно
// ═════════════════════════════════════════════════════════════════════════════

class TrueOrFalseExercise extends ConsumerStatefulWidget {
  final List<Word> words;
  final bool pinyinEnabled;
  final void Function(bool) onAnswer;
  final VoidCallback onNext;

  const TrueOrFalseExercise({
    required this.words,
    required this.pinyinEnabled,
    required this.onAnswer,
    required this.onNext,
    super.key,
  });

  @override
  ConsumerState<TrueOrFalseExercise> createState() => _TrueOrFalseState();
}

class _TrueOrFalseState extends ConsumerState<TrueOrFalseExercise> {
  late Word _word;
  late String _shownTranslation;
  late bool _statementIsTrue;
  bool? _userChoice; // true=верно, false=неверно
  bool _answered = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() {
    final rng = Random();
    final pool = [...widget.words]..shuffle(rng);
    _word = pool.first;

    // 50% шанс показать правильный перевод, 50% — чужой
    _statementIsTrue = rng.nextBool();
    if (_statementIsTrue) {
      _shownTranslation = _word.translationRu;
    } else {
      // Берём перевод другого слова
      final others = pool.where((w) => w.id != _word.id).toList();
      _shownTranslation = others.isNotEmpty
          ? others.first.translationRu
          : '${_word.translationRu}?';
    }

    _userChoice = null;
    _answered = false;
  }

  void _select(bool choice) {
    if (_answered) return;
    final correct = choice == _statementIsTrue;
    setState(() {
      _userChoice = choice;
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

    final userCorrect =
        _answered && _userChoice == _statementIsTrue;

    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Верно или нет?', style: ts.displayMedium),
                ),
                const SizedBox(height: 6),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Соответствует ли перевод иероглифу?',
                      style: ts.bodyMuted),
                ),
                const SizedBox(height: 40),

                // Карточка утверждения
                Expanded(
                  child: Center(
                    child: AppCard(
                      padding: const EdgeInsets.all(28),
                      customBorderColor: _answered
                          ? (userCorrect ? t.accentSuccess : t.accentDanger)
                          : null,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Иероглиф
                          Text(_word.hanzi,
                              style: ts.hanziHero
                                  .copyWith(color: t.onSurface)),
                          if (widget.pinyinEnabled) ...[
                            const SizedBox(height: 6),
                            Text(_word.pinyin, style: ts.pinyinLarge),
                          ],
                          const SizedBox(height: 20),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 2, vertical: 1),
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('= ', style: ts.bodyMuted),
                                Text('"$_shownTranslation"',
                                    style: ts.headlineLarge.copyWith(
                                        color: t.onSurface)),
                              ],
                            ),
                          ),
                          // Ответ
                          if (_answered) ...[
                            const SizedBox(height: 16),
                            Text(
                              userCorrect
                                  ? '✓ Верно!'
                                  : '✗ Правильный ответ: "${_word.translationRu}"',
                              style: ts.body.copyWith(
                                color: userCorrect
                                    ? t.accentSuccess
                                    : t.accentDanger,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Кнопки Верно / Неверно
                if (!_answered)
                  Row(
                    children: [
                      Expanded(
                        child: _TFButton(
                          label: '✓  Верно',
                          color: t.accentSuccess,
                          onTap: () => _select(true),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _TFButton(
                          label: '✗  Неверно',
                          color: t.accentDanger,
                          onTap: () => _select(false),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
        _BottomNextButton(
            visible: _answered, label: 'Далее', onTap: widget.onNext),
      ],
    );
  }
}

class _TFButton extends ConsumerWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _TFButton({required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(appTokensProvider);
    final ts = AppTextStyles.of(t);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(t.radiusButton),
          border: Border.all(color: color.withValues(alpha: 0.4), width: 1.5),
        ),
        child: Text(label,
            style: ts.headlineLarge.copyWith(
                color: color, fontWeight: FontWeight.w700),
            textAlign: TextAlign.center),
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// 4. WORD CARD FLIP — карточка с 3D-переворотом и самооценкой
// ═════════════════════════════════════════════════════════════════════════════

class WordCardFlipExercise extends ConsumerStatefulWidget {
  final List<Word> words;
  final bool pinyinEnabled;
  final void Function(bool) onAnswer;
  final VoidCallback onNext;

  const WordCardFlipExercise({
    required this.words,
    required this.pinyinEnabled,
    required this.onAnswer,
    required this.onNext,
    super.key,
  });

  @override
  ConsumerState<WordCardFlipExercise> createState() =>
      _WordCardFlipState();
}

class _WordCardFlipState extends ConsumerState<WordCardFlipExercise>
    with SingleTickerProviderStateMixin {
  late AnimationController _flipCtrl;
  late Animation<double> _flipAnim;
  bool _isFlipped = false;
  bool _answered = false;
  late Word _target;
  int _cardIndex = 0;

  @override
  void initState() {
    super.initState();
    _flipCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _flipAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _flipCtrl, curve: Curves.easeInOut),
    );
    _loadCard();
  }

  void _loadCard() {
    final rng = Random();
    final pool = [...widget.words]..shuffle(rng);
    _target = pool[_cardIndex % pool.length];
    _isFlipped = false;
    _answered = false;
    _flipCtrl.reset();
  }

  @override
  void dispose() {
    _flipCtrl.dispose();
    super.dispose();
  }

  void _flip() {
    if (_isFlipped) return;
    setState(() => _isFlipped = true);
    _flipCtrl.forward();
  }

  void _selfRate(bool knew) {
    setState(() => _answered = true);
    widget.onAnswer(knew);
    // Play sound feedback
    final audioService = ref.read(audioServiceProvider);
    audioService.playSfx(knew ? 'correct' : 'wrong');
    // Небольшая задержка перед onNext
    Future.delayed(const Duration(milliseconds: 400), widget.onNext);
  }

  @override
  Widget build(BuildContext context) {
    final t = ref.watch(appTokensProvider);
    final ts = AppTextStyles.of(t);

    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Карточка', style: ts.displayMedium),
                ),
                const SizedBox(height: 6),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    _isFlipped
                        ? 'Ты знал это слово?'
                        : 'Нажми на карточку, чтобы перевернуть',
                    style: ts.bodyMuted,
                  ),
                ),
                const SizedBox(height: 32),

                // Анимированная карточка
                Expanded(
                  child: GestureDetector(
                     onTap: () {
                       ref.read(audioServiceProvider).speakChineseText(_target.hanzi);
                       _flip();
                     },
                    child: AnimatedBuilder(
                      animation: _flipAnim,
                      builder: (_, __) {
                        final angle = _flipAnim.value * 3.14159;
                        final showFront = _flipAnim.value < 0.5;

                        return Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.identity()
                            ..setEntry(3, 2, 0.001)
                            ..rotateY(angle),
                          child: showFront
                              ? _CardFace(

                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: [
                                        Text(_target.hanzi,
                                            style: ts.hanziHero.copyWith(
                                                color: t.onSurface)),
                                        const SizedBox(height: 24),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 8),
                                          decoration: BoxDecoration(
                                            color: t.accentSoft,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(Icons.touch_app_rounded,
                                                  color: t.accent, size: 16),
                                              const SizedBox(width: 6),
                                              Text('Перевернуть',
                                                  style: ts.label.copyWith(
                                                      color: t.accent)),
                                            ],
                                          ),
                                        ),
                                      ],
                                  ),
                                )
                              : Transform(
                                  alignment: Alignment.center,
                                  transform: Matrix4.identity()
                                    ..rotateY(3.14159),
                                  child: _CardFace(

                                    color: t.accentSoft,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(_target.hanzi,
                                            style: ts.hanziLarge.copyWith(
                                                color: t.accent)),
                                        const SizedBox(height: 8),
                                        if (widget.pinyinEnabled) ...[
                                          Text(_target.pinyin,
                                              style: ts.pinyinLarge),
                                          const SizedBox(height: 12),
                                        ],
                                        Text(_target.translationRu,
                                            style: ts.displayMedium.copyWith(
                                                color: t.onSurface),
                                            textAlign: TextAlign.center),
                                        if (_target.exampleZh != null) ...[
                                          const SizedBox(height: 20),
                                          Container(
                                            padding: const EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                              color: t.surface,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Column(
                                              children: [
                                                Text(_target.exampleZh!,
                                                    style: ts.hanziSmall
                                                        .copyWith(
                                                            color:
                                                                t.onSurface),
                                                    textAlign:
                                                        TextAlign.center),
                                                if (widget.pinyinEnabled &&
                                                    _target.examplePinyin !=
                                                        null)
                                                  Text(
                                                      _target.examplePinyin!,
                                                      style: ts.pinyin,
                                                      textAlign:
                                                          TextAlign.center),
                                                if (_target.exampleRu != null)
                                                  Text(_target.exampleRu!,
                                                      style: ts.bodyMuted,
                                                      textAlign:
                                                          TextAlign.center),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ),
                        );
                      },
                    ),
                  ),
                ),

                // Кнопки самооценки (появляются после переворота)
                if (_isFlipped && !_answered) ...[
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _selfRate(false),
                          child: Container(
                            padding:
                                const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              color: t.accentDanger
                                  .withValues(alpha: 0.12),
                              borderRadius:
                                  BorderRadius.circular(t.radiusButton),
                              border: Border.all(
                                  color: t.accentDanger
                                      .withValues(alpha: 0.4),
                                  width: 1.5),
                            ),
                            child: Column(
                              children: [
                                Icon(Icons.close_rounded,
                                    color: t.accentDanger, size: 24),
                                const SizedBox(height: 4),
                                Text('Не знал',
                                    style: ts.label
                                        .copyWith(color: t.accentDanger)),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _selfRate(true),
                          child: Container(
                            padding:
                                const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              color: t.accentSuccess
                                  .withValues(alpha: 0.12),
                              borderRadius:
                                  BorderRadius.circular(t.radiusButton),
                              border: Border.all(
                                  color: t.accentSuccess
                                      .withValues(alpha: 0.4),
                                  width: 1.5),
                            ),
                            child: Column(
                              children: [
                                Icon(Icons.check_rounded,
                                    color: t.accentSuccess, size: 24),
                                const SizedBox(height: 4),
                                Text('Знал',
                                    style: ts.label.copyWith(
                                        color: t.accentSuccess)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _CardFace extends ConsumerWidget {
  final Widget child;
  final Color? color;
  const _CardFace({required this.child, this.color});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(appTokensProvider);
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: color ?? t.surface,
        borderRadius: BorderRadius.circular(t.radiusCard),
        border: Border.all(color: t.surfaceBorder, width: 1.5),
        boxShadow: t.cardShadow,
      ),
      padding: const EdgeInsets.all(24),
      child: child,
    );
  }
}

// ── Кнопка «Далее» ────────────────────────────────────────────────────────────

class _BottomNextButton extends ConsumerWidget {
  final bool visible;
  final String label;
  final VoidCallback onTap;

  const _BottomNextButton(
      {required this.visible, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(appTokensProvider);
    final ts = AppTextStyles.of(t);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
      height: visible ? null : 0,
      child: visible
          ? Padding(
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
                        style: ts.headlineLarge.copyWith(
                            color: Colors.white, fontWeight: FontWeight.w700),
                        textAlign: TextAlign.center),
                  ),
                ),
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}
