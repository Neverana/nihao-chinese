// lib/features/lesson/exercises/fill_in_blank_exercise.dart
//
// Упражнение: заполни пропуск в предложении.
// Показывается предложение с ___ , снизу 3–4 варианта-кнопки.

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../../../data/models/models.dart';

class FillInBlankExercise extends ConsumerStatefulWidget {
  final List<Word> words;
  final bool pinyinEnabled;
  final void Function(bool) onAnswer;
  final VoidCallback onNext;

  const FillInBlankExercise({
    required this.words,
    required this.pinyinEnabled,
    required this.onAnswer,
    required this.onNext,
    super.key,
  });

  @override
  ConsumerState<FillInBlankExercise> createState() => _FillInBlankState();
}

class _FillInBlankState extends ConsumerState<FillInBlankExercise> {
  late Word _target;
  late String _sentenceWithBlank;
  late List<Word> _options; // 3–4 варианта
  int? _selectedIndex;
  bool _answered = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() {
    final rng = Random();
    final pool = [...widget.words]..shuffle(rng);

    // Выбираем слово с примером
    _target = pool.firstWhere(
      (w) => w.exampleZh != null && w.exampleZh!.contains(w.hanzi),
      orElse: () => pool.first,
    );

    // Строим предложение с пропуском
    final example = _target.exampleZh ?? '${_target.hanzi}。';
    _sentenceWithBlank = example.replaceFirst(_target.hanzi, '___');

    // Дистракторы
    final distractors = pool
        .where((w) => w.id != _target.id)
        .take(3)
        .toList();
    _options = [...distractors, _target]..shuffle(rng);

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
                Text('Заполни пропуск', style: ts.displayMedium),
                const SizedBox(height: 6),
                Text('Выбери подходящее слово',
                    style: ts.bodyMuted),
                const SizedBox(height: 32),

                // Предложение с пропуском
                Center(
                  child: AppCard(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Пиньинь примера (если включён)
                        if (widget.pinyinEnabled &&
                            _target.examplePinyin != null) ...[
                          Text(
                            _target.examplePinyin!.replaceFirst(
                                _target.pinyin, '___'),
                            style: ts.pinyin,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 4),
                        ],
                        // Иероглифы с пропуском
                        _BlankSentenceWidget(
                          sentence: _sentenceWithBlank,
                          answered: _answered,
                          answer: _target.hanzi,
                          correct: _answered && _selectedIndex != null &&
                              _options[_selectedIndex!].id == _target.id,
                        ),
                        // Перевод примера
                        if (_target.exampleRu != null) ...[
                          const SizedBox(height: 8),
                          Text(
                            _target.exampleRu!.replaceFirst(
                                _target.translationRu, '...'),
                            style: ts.bodyMuted,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Варианты
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  alignment: WrapAlignment.center,
                  children: List.generate(_options.length, (i) {
                    final opt = _options[i];
                    final isCorrect = opt.id == _target.id;
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        decoration: BoxDecoration(
                          color: bg,
                          borderRadius:
                              BorderRadius.circular(t.radiusButton),
                          border:
                              Border.all(color: border, width: 1.5),
                          boxShadow: t.cardShadow,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(opt.hanzi,
                                style: ts.hanziMedium
                                    .copyWith(color: t.onSurface)),
                            if (widget.pinyinEnabled)
                              Text(opt.pinyin,
                                  style: ts.pinyin
                                      .copyWith(fontSize: 11)),
                            Text(opt.translationRu,
                                style: ts.caption.copyWith(
                                    color: t.onSurfaceMuted)),
                          ],
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
          visible: _answered,
          label: 'Далее',
          onTap: widget.onNext,
        ),
      ],
    );
  }
}

// Предложение с анимированным пропуском
class _BlankSentenceWidget extends StatelessWidget {
  final String sentence;
  final bool answered;
  final String answer;
  final bool correct;

  const _BlankSentenceWidget({
    required this.sentence,
    required this.answered,
    required this.answer,
    required this.correct,
  });

  @override
  Widget build(BuildContext context) {
    final parts = sentence.split('___');
    if (parts.length < 2) {
      return Text(sentence,
          style: const TextStyle(
              fontFamily: 'NotoSansSC',
              fontSize: 24,
              fontWeight: FontWeight.w500));
    }

    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(parts[0],
            style: const TextStyle(
                fontFamily: 'NotoSansSC',
                fontSize: 24,
                fontWeight: FontWeight.w500)),
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: answered
                ? (correct
                    ? const Color(0x2634D399)
                    : const Color(0x26F87171))
                : const Color(0x265B8FFF),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: answered
                  ? (correct
                      ? const Color(0xFF34D399)
                      : const Color(0xFFF87171))
                  : const Color(0xFF5B8FFF),
              width: 1.5,
            ),
          ),
          child: Text(
            answered ? answer : '   ',
            style: TextStyle(
              fontFamily: 'NotoSansSC',
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: answered
                  ? (correct
                      ? const Color(0xFF34D399)
                      : const Color(0xFFF87171))
                  : const Color(0xFF5B8FFF),
            ),
          ),
        ),
        Text(parts[1],
            style: const TextStyle(
                fontFamily: 'NotoSansSC',
                fontSize: 24,
                fontWeight: FontWeight.w500)),
      ],
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
