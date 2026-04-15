// lib/features/calligraphy/calligraphy_screen.dart
// FIX: только одиночные иероглифы — hanzi.length == 1
// Слова вроде 你好, 再见, 谢谢 исключаются — это словосочетания, не отдельные символы

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_tokens.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_card.dart';
import '../../data/models/models.dart';
import '../../data/repositories/content_repository.dart';

class _CalligEntry {
  final Word word;
  final String topicTitle;
  final int masteryLevel;
  final int practiceCount;

  const _CalligEntry({
    required this.word,
    required this.topicTitle,
    required this.masteryLevel,
    required this.practiceCount,
  });
}

final calligraphyWordsProvider = Provider<List<_CalligEntry>>((ref) {
  final repo = ref.watch(contentRepositoryProvider);
  final result = <_CalligEntry>[];

  for (final block in repo.getAllBlocks()) {
    for (final topic in repo.getTopicsForBlock(block.id)) {
      if (repo.getStatus(topic.id) == ProgressStatus.locked) continue;

      for (final word in topic.words) {
        // FIX: только одиночные иероглифы
        // hanzi.length == 1 — один символ (我, 你, 是, 家...)
        // Исключаем словосочетания (你好, 再见, 谢谢 и т.д.)
        if (word.hanzi.length == 1 && word.strokeCount > 0) {
          result.add(_CalligEntry(
            word: word,
            topicTitle: topic.titleRu,
            masteryLevel: 0, // TODO: из Drift
            practiceCount: 0,
          ));
        }
      }
    }
  }

  // Убираем дубликаты по hanzi
  final seen = <String>{};
  return result.where((e) => seen.add(e.word.hanzi)).toList();
});

// ── CalligraphyScreen ─────────────────────────────────────────────────────────

class CalligraphyScreen extends ConsumerWidget {
  const CalligraphyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(appTokensProvider);
    final ts = AppTextStyles.of(t);
    final entries = ref.watch(calligraphyWordsProvider);

    if (entries.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('✍️', style: TextStyle(fontSize: 64)),
            const SizedBox(height: 16),
            Text('Каллиграфия', style: ts.displayMedium),
            const SizedBox(height: 8),
            Text(
              'Пройди уроки, чтобы иероглифы\nпоявились здесь',
              style: ts.bodyMuted,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Каллиграфия', style: ts.displayMedium),
                    Text('${entries.length} иероглифов', style: ts.bodyMuted),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: t.accentSoft,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.auto_awesome_rounded, color: t.accent, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      '${entries.where((e) => e.masteryLevel >= 3).length} освоено',
                      style: ts.caption.copyWith(
                          color: t.accent, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 0.9,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: entries.length,
            itemBuilder: (_, i) => _CalligraphyCard(
              entry: entries[i],
              onTap: () => context.push('/calligraphy/${entries[i].word.id}'),
            ),
          ),
        ),
      ],
    );
  }
}

class _CalligraphyCard extends ConsumerWidget {
  final _CalligEntry entry;
  final VoidCallback onTap;

  const _CalligraphyCard({required this.entry, required this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(appTokensProvider);
    final ts = AppTextStyles.of(t);
    final needsPractice = entry.masteryLevel < 2;

    return GestureDetector(
      onTap: onTap,
      child: AppCard(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(entry.word.hanzi,
                style: TextStyle(
                  fontFamily: 'NotoSansSC',
                  fontSize: 40,
                  fontWeight: FontWeight.w600,
                  color: t.onSurface,
                )),
            const SizedBox(height: 4),
            Text(entry.word.pinyin,
                style: ts.pinyin.copyWith(fontSize: 12),
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
            const SizedBox(height: 2),
            Text(entry.word.translationRu,
                style:
                    ts.caption.copyWith(color: t.onSurfaceMuted, fontSize: 10),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center),
            const SizedBox(height: 4),
            Text('${entry.word.strokeCount} черт',
                style:
                    ts.caption.copyWith(color: t.onSurfaceMuted, fontSize: 9)),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                  3,
                  (i) => Icon(
                        i < entry.masteryLevel
                            ? Icons.star_rounded
                            : Icons.star_border_rounded,
                        color: i < entry.masteryLevel
                            ? t.accentWarn
                            : t.onSurfaceDisabled,
                        size: 14,
                      )),
            ),
            if (needsPractice) ...[
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: t.accentWarn.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text('Учить!',
                    style: ts.caption.copyWith(
                        color: t.accentWarn,
                        fontSize: 9,
                        fontWeight: FontWeight.w700)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// CalligraphyPracticeScreen
// ═════════════════════════════════════════════════════════════════════════════

class CalligraphyPracticeScreen extends ConsumerStatefulWidget {
  final String wordId;
  const CalligraphyPracticeScreen({required this.wordId, super.key});

  @override
  ConsumerState<CalligraphyPracticeScreen> createState() =>
      _CalligraphyPracticeState();
}

class _CalligraphyPracticeState
    extends ConsumerState<CalligraphyPracticeScreen> {
  final List<List<Offset>> _strokes = [];
  List<Offset> _current = [];
  bool _showGuide = true;
  int _currentWordIndex = 0;
  List<Word> _words = [];

  @override
  void initState() {
    super.initState();
    _loadWords();
  }

  void _loadWords() {
    final repo = ref.read(contentRepositoryProvider);
    final allWords = <Word>[];

    for (final block in repo.getAllBlocks()) {
      for (final topic in repo.getTopicsForBlock(block.id)) {
        if (repo.getStatus(topic.id) == ProgressStatus.locked) continue;
        // FIX: только одиночные иероглифы
        allWords.addAll(
            topic.words.where((w) => w.hanzi.length == 1 && w.strokeCount > 0));
      }
    }

    // Убираем дубликаты
    final seen = <String>{};
    final unique = allWords.where((w) => seen.add(w.hanzi)).toList();

    final startIndex = unique.indexWhere((w) => w.id == widget.wordId);
    setState(() {
      _words = unique;
      _currentWordIndex = startIndex >= 0 ? startIndex : 0;
    });
  }

  Word? get _currentWord =>
      _words.isNotEmpty ? _words[_currentWordIndex] : null;

  void _clear() => setState(() {
        _strokes.clear();
        _current = [];
      });

  void _prevWord() {
    if (_currentWordIndex > 0) {
      setState(() {
        _currentWordIndex--;
        _clear();
      });
    }
  }

  void _nextWord() {
    if (_currentWordIndex < _words.length - 1) {
      setState(() {
        _currentWordIndex++;
        _clear();
      });
    }
  }

  void _rate(int level) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text(['😔 Плохо', '🙂 Хорошо', '😄 Отлично'][level.clamp(0, 2)]),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
    _nextWord();
  }

  @override
  Widget build(BuildContext context) {
    final t = ref.watch(appTokensProvider);
    final ts = AppTextStyles.of(t);
    final word = _currentWord;

    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: _PracticeTopBar(
          word: word,
          currentIndex: _currentWordIndex,
          totalWords: _words.length,
          showGuide: _showGuide,
          onBack: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              context.go('/');
            }
          },
          onToggleGuide: () => setState(() => _showGuide = !_showGuide),
          onPrev: _currentWordIndex > 0 ? _prevWord : null,
          onNext: _currentWordIndex < _words.length - 1 ? _nextWord : null,
        ),
        body: word == null
            ? Center(child: Text('Нет иероглифов', style: ts.displayMedium))
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(word.pinyin, style: ts.pinyinLarge),
                              Text(word.translationRu, style: ts.body),
                            ],
                          ),
                        ),
                        Text('${word.strokeCount} черт',
                            style:
                                ts.caption.copyWith(color: t.onSurfaceMuted)),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: GestureDetector(
                        onPanStart: (d) =>
                            setState(() => _current = [d.localPosition]),
                        onPanUpdate: (d) =>
                            setState(() => _current.add(d.localPosition)),
                        onPanEnd: (_) => setState(() {
                          if (_current.length > 2) {
                            _strokes.add(List.from(_current));
                          }
                          _current = [];
                        }),
                        child: CustomPaint(
                          painter: _PracticePainter(
                            hanzi: word.hanzi,
                            showGuide: _showGuide,
                            strokes: _strokes,
                            current: _current,
                            gridColor: t.surfaceBorder,
                            strokeColor: t.onSurface,
                            guideColor: t.onSurface.withValues(alpha: 0.08),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: t.surface,
                              borderRadius: BorderRadius.circular(t.radiusCard),
                              border:
                                  Border.all(color: t.surfaceBorder, width: 2),
                            ),
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
                          child: _PracticeBtn(
                            icon: Icons.refresh_rounded,
                            label: 'Очистить',
                            color: t.onSurfaceMuted,
                            bg: t.surfaceHighlight,
                            border: t.surfaceBorder,
                            onTap: _clear,
                          ),
                        ),
                        if (_strokes.isNotEmpty) ...[
                          const SizedBox(width: 8),
                          Expanded(
                            child: _PracticeBtn(
                              icon: Icons.sentiment_dissatisfied_rounded,
                              label: 'Плохо',
                              color: t.accentDanger,
                              bg: t.accentDanger.withValues(alpha: 0.1),
                              border: t.accentDanger.withValues(alpha: 0.3),
                              onTap: () => _rate(0),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _PracticeBtn(
                              icon: Icons.sentiment_satisfied_rounded,
                              label: 'Хорошо',
                              color: t.accentWarn,
                              bg: t.accentWarn.withValues(alpha: 0.1),
                              border: t.accentWarn.withValues(alpha: 0.3),
                              onTap: () => _rate(1),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _PracticeBtn(
                              icon: Icons.sentiment_very_satisfied_rounded,
                              label: 'Отлично',
                              color: t.accentSuccess,
                              bg: t.accentSuccess.withValues(alpha: 0.1),
                              border: t.accentSuccess.withValues(alpha: 0.3),
                              onTap: () => _rate(2),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
      ),
    );
  }
}

class _PracticeBtn extends ConsumerWidget {
  final IconData icon;
  final String label;
  final Color color;
  final Color bg;
  final Color border;
  final VoidCallback onTap;

  const _PracticeBtn({
    required this.icon,
    required this.label,
    required this.color,
    required this.bg,
    required this.border,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(appTokensProvider);
    final ts = AppTextStyles.of(t);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(t.radiusButton),
          border: Border.all(color: border, width: 1.5),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 3),
            Text(label,
                style: ts.caption
                    .copyWith(color: color, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class _PracticeTopBar extends ConsumerWidget implements PreferredSizeWidget {
  final Word? word;
  final int currentIndex;
  final int totalWords;
  final bool showGuide;
  final VoidCallback onBack;
  final VoidCallback onToggleGuide;
  final VoidCallback? onPrev;
  final VoidCallback? onNext;

  const _PracticeTopBar({
    required this.word,
    required this.currentIndex,
    required this.totalWords,
    required this.showGuide,
    required this.onBack,
    required this.onToggleGuide,
    this.onPrev,
    this.onNext,
  });

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
              onTap: onBack,
              child: Container(
                width: 40,
                height: 40,
                margin: const EdgeInsets.only(left: 12),
                decoration: BoxDecoration(
                  color: t.surfaceHighlight,
                  shape: BoxShape.circle,
                  border: Border.all(color: t.surfaceBorder),
                ),
                child: Icon(Icons.arrow_back_rounded,
                    color: t.onSurface, size: 20),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: onPrev,
              child: Icon(Icons.chevron_left_rounded,
                  color: onPrev != null ? t.onSurface : t.onSurfaceDisabled,
                  size: 28),
            ),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (word != null)
                      Text(word!.hanzi,
                          style: ts.hanziMedium.copyWith(color: t.onSurface)),
                    Text('${currentIndex + 1} / $totalWords',
                        style: ts.caption.copyWith(color: t.onSurfaceMuted)),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: onNext,
              child: Icon(Icons.chevron_right_rounded,
                  color: onNext != null ? t.onSurface : t.onSurfaceDisabled,
                  size: 28),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: onToggleGuide,
              child: Container(
                margin: const EdgeInsets.only(right: 12),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: showGuide ? t.accentSoft : t.surfaceHighlight,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: showGuide
                        ? t.accent.withValues(alpha: 0.4)
                        : t.surfaceBorder,
                  ),
                ),
                child: Text(
                  showGuide ? '字 ВКЛ' : '字 ВЫКЛ',
                  style: ts.caption.copyWith(
                    color: showGuide ? t.accent : t.onSurfaceMuted,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PracticePainter extends CustomPainter {
  final String hanzi;
  final bool showGuide;
  final List<List<Offset>> strokes;
  final List<Offset> current;
  final Color gridColor;
  final Color strokeColor;
  final Color guideColor;

  const _PracticePainter({
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
    final gridPaint = Paint()
      ..color = gridColor
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    final step = size.width / 4;
    for (int i = 1; i < 4; i++) {
      canvas.drawLine(
          Offset(step * i, 0), Offset(step * i, size.height), gridPaint);
      canvas.drawLine(
          Offset(0, step * i), Offset(size.width, step * i), gridPaint);
    }
    final diagPaint = Paint()
      ..color = gridColor.withOpacity(0.3)
      ..strokeWidth = 0.5;
    canvas.drawLine(Offset.zero, Offset(size.width, size.height), diagPaint);
    canvas.drawLine(Offset(size.width, 0), Offset(0, size.height), diagPaint);

    if (showGuide) {
      final tp = TextPainter(
        text: TextSpan(
          text: hanzi,
          style: TextStyle(
            fontSize: size.width * 0.72,
            color: guideColor,
            fontFamily: 'NotoSansSC',
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas,
          Offset((size.width - tp.width) / 2, (size.height - tp.height) / 2));
    }

    final strokePaint = Paint()
      ..color = strokeColor
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    for (final stroke in [...strokes, current]) {
      if (stroke.length < 2) continue;
      final path = Path()..moveTo(stroke.first.dx, stroke.first.dy);
      for (final p in stroke.skip(1)) path.lineTo(p.dx, p.dy);
      canvas.drawPath(path, strokePaint);
    }
  }

  @override
  bool shouldRepaint(_PracticePainter old) => true;
}

// Нужен AppBackground — импортируем
// (уже импортирован через app_card.dart в основном проекте)
