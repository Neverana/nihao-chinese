// lib/features/lesson/exercises/sentence_builder_exercise.dart
//
// Упражнение: собери предложение из перемешанных слов.
// Слова-чипы внизу → нажимаешь → выстраиваются сверху в нужном порядке.

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../../../data/models/models.dart';

class SentenceBuilderExercise extends ConsumerStatefulWidget {
  final List<Word> words;
  final bool pinyinEnabled;
  final void Function(bool) onAnswer;
  final VoidCallback onNext;

  const SentenceBuilderExercise({
    required this.words,
    required this.pinyinEnabled,
    required this.onAnswer,
    required this.onNext,
    super.key,
  });

  @override
  ConsumerState<SentenceBuilderExercise> createState() =>
      _SentenceBuilderState();
}

class _SentenceBuilderState extends ConsumerState<SentenceBuilderExercise> {
  late List<_Token> _allTokens;
  late List<_Token> _correctOrder;
  final List<_Token> _selected = [];
  bool _answered = false;
  bool _correct = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() {
    final rng = Random();
    // Выбираем слово с примером для разбора на токены
    final wordsWithExample =
        widget.words.where((w) => w.exampleZh != null).toList();
    final target = wordsWithExample.isNotEmpty
        ? wordsWithExample[rng.nextInt(wordsWithExample.length)]
        : widget.words.first;

    // Простая токенизация: разбиваем пример на слова из нашего словаря + остаток
    final example = target.exampleZh ?? '${target.hanzi}。';
    final tokens = _tokenize(example, widget.words);

    _correctOrder = tokens;
    _allTokens = List.from(tokens)..shuffle(rng);
    _selected.clear();
    _answered = false;
    _correct = false;
  }

  // Простая токенизация: ищем совпадения слов из словаря в строке
  List<_Token> _tokenize(String sentence, List<Word> vocabulary) {
    final tokens = <_Token>[];
    int i = 0;
    while (i < sentence.length) {
      bool found = false;
      // Пробуем найти слово из словаря начиная с позиции i (с конца по длине)
      for (int len = 4; len >= 1; len--) {
        if (i + len > sentence.length) continue;
        final chunk = sentence.substring(i, i + len);
        final word = vocabulary.firstWhere(
          (w) => w.hanzi == chunk,
          orElse: () => Word(
              id: '', hanzi: '', pinyin: '', translationRu: '',
              hskLevel: '', strokeCount: 0, tags: []),
        );
        if (word.id.isNotEmpty) {
          tokens.add(_Token(text: chunk, pinyin: word.pinyin, isWord: true));
          i += len;
          found = true;
          break;
        }
      }
      if (!found) {
        // Одиночный символ (пунктуация или незнакомый иероглиф)
        tokens.add(_Token(text: sentence[i], pinyin: '', isWord: false));
        i++;
      }
    }
    // Удаляем одиночные пустые токены типа пробел
    return tokens.where((t) => t.text.trim().isNotEmpty).toList();
  }

  void _selectToken(_Token token) {
    if (_answered) return;
    if (_selected.contains(token)) return;
    setState(() => _selected.add(token));
  }

  void _removeToken(_Token token) {
    if (_answered) return;
    setState(() => _selected.remove(token));
  }

  void _check() {
    if (_selected.length != _allTokens.length) return;
    final correct = List.generate(
      _selected.length,
      (i) => _selected[i].text == _correctOrder[i].text,
    ).every((e) => e);

    setState(() {
      _answered = true;
      _correct = correct;
    });
    widget.onAnswer(correct);
  }

  @override
  Widget build(BuildContext context) {
    final t = ref.watch(appTokensProvider);
    final ts = AppTextStyles.of(t);
    final allSelected = _selected.length == _allTokens.length;

    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Составь предложение', style: ts.displayMedium),
                const SizedBox(height: 6),
                Text('Нажимай на слова в правильном порядке',
                    style: ts.bodyMuted),
                const SizedBox(height: 28),

                // Зона построенного предложения
                AppCard(
                  padding: const EdgeInsets.all(16),
                  customBorderColor: _answered
                      ? (_correct ? t.accentSuccess : t.accentDanger)
                      : null,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Минимальная высота чтобы зона не схлопывалась
                      ConstrainedBox(
                        constraints: const BoxConstraints(minHeight: 52),
                        child: _selected.isEmpty
                            ? Center(
                                child: Text('Нажми на слово ниже',
                                    style: ts.bodyMuted
                                        .copyWith(fontStyle: FontStyle.italic)),
                              )
                            : Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: _selected.map((token) {
                                  return GestureDetector(
                                    onTap: () => _removeToken(token),
                                    child: _TokenChip(
                                      token: token,
                                      pinyinEnabled: widget.pinyinEnabled,
                                      selected: true,
                                      answered: _answered,
                                      correct: _correct,
                                    ),
                                  );
                                }).toList(),
                              ),
                      ),
                      // Результат
                      if (_answered) ...[
                        const SizedBox(height: 10),
                        Divider(color: t.surfaceBorder),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(
                              _correct
                                  ? Icons.check_circle_rounded
                                  : Icons.cancel_rounded,
                              color: _correct ? t.accentSuccess : t.accentDanger,
                              size: 16,
                            ),
                            const SizedBox(width: 6),
                            if (!_correct)
                              Expanded(
                                child: Text(
                                  'Правильно: ${_correctOrder.map((t) => t.text).join('')}',
                                  style: ts.bodyMuted,
                                ),
                              )
                            else
                              Text('Правильно!',
                                  style: ts.body.copyWith(
                                      color: t.accentSuccess)),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Доступные токены
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _allTokens.map((token) {
                    final isUsed = _selected.contains(token);
                    return GestureDetector(
                      onTap: isUsed || _answered
                          ? null
                          : () => _selectToken(token),
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 200),
                        opacity: isUsed ? 0.3 : 1.0,
                        child: _TokenChip(
                          token: token,
                          pinyinEnabled: widget.pinyinEnabled,
                          selected: false,
                          answered: false,
                          correct: false,
                        ),
                      ),
                    );
                  }).toList(),
                ),

                const Spacer(),

                // Кнопка проверки
                if (!_answered && allSelected)
                  GestureDetector(
                    onTap: _check,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: t.accentSoft,
                        borderRadius: BorderRadius.circular(t.radiusButton),
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

class _Token {
  final String text;
  final String pinyin;
  final bool isWord;
  _Token({required this.text, required this.pinyin, required this.isWord});
}

class _TokenChip extends ConsumerWidget {
  final _Token token;
  final bool pinyinEnabled;
  final bool selected;
  final bool answered;
  final bool correct;

  const _TokenChip({
    required this.token,
    required this.pinyinEnabled,
    required this.selected,
    required this.answered,
    required this.correct,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(appTokensProvider);
    final ts = AppTextStyles.of(t);

    Color bg = selected ? t.accentSoft : t.surface;
    Color border = selected ? t.accent : t.surfaceBorder;

    if (selected && answered) {
      bg = correct
          ? t.accentSuccess.withValues(alpha: 0.15)
          : t.accentDanger.withValues(alpha: 0.15);
      border = correct ? t.accentSuccess : t.accentDanger;
    }

    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: 14, vertical: token.isWord ? 8 : 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: border, width: 1.5),
        boxShadow: t.cardShadow,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (pinyinEnabled && token.pinyin.isNotEmpty)
            Text(token.pinyin,
                style: ts.pinyin.copyWith(fontSize: 10)),
          Text(token.text,
              style: ts.hanziSmall.copyWith(color: t.onSurface)),
        ],
      ),
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
