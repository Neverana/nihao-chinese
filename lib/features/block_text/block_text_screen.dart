// lib/features/block_text/block_text_screen.dart

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

final blockTextScreenProvider =
    Provider.family<_BlockTextData?, String>((ref, blockId) {
  final repo = ref.watch(contentRepositoryProvider);
  final blockText = repo.getBlockText(blockId);
  if (blockText == null) return null;

  // Строим карту wordId → Word
  final wordMap = <String, Word>{};
  for (final seg in blockText.segments) {
    if (seg.isWord && seg.wordId != null) {
      final w = repo.getWord(seg.wordId!);
      if (w != null) wordMap[seg.wordId!] = w;
    }
  }
  return _BlockTextData(blockText: blockText, wordMap: wordMap);
});

class _BlockTextData {
  final BlockText blockText;
  final Map<String, Word> wordMap;
  const _BlockTextData({required this.blockText, required this.wordMap});
}

// ── BlockTextScreen ───────────────────────────────────────────────────────────

class BlockTextScreen extends ConsumerStatefulWidget {
  final String blockId;
  const BlockTextScreen({required this.blockId, super.key});

  @override
  ConsumerState<BlockTextScreen> createState() => _BlockTextScreenState();
}

class _BlockTextScreenState extends ConsumerState<BlockTextScreen> {
  bool _pinyinEnabled = true;
  String? _activeWordId;
  final Map<String, TextEditingController> _answerControllers = {};
  final Map<String, bool?> _answerResults = {};

  @override
  void dispose() {
    for (final c in _answerControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = ref.watch(appTokensProvider);
    final ts = AppTextStyles.of(t);
    final data = ref.watch(blockTextScreenProvider(widget.blockId));

    if (data == null) {
      return AppBackground(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
              child: Text('Текст не найден', style: ts.displayMedium)),
        ),
      );
    }

    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: _TextTopBar(
          title: data.blockText.titleRu,
          titleZh: data.blockText.titleZh,
          pinyinEnabled: _pinyinEnabled,
          onTogglePinyin: () =>
              setState(() => _pinyinEnabled = !_pinyinEnabled),
        ),
        body: GestureDetector(
          onTap: () => setState(() => _activeWordId = null),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 48),
            children: [
              // Текст
              AppCard(
                child: _TextBody(
                  data: data,
                  pinyinEnabled: _pinyinEnabled,
                  activeWordId: _activeWordId,
                  onWordTap: (wordId) =>
                      setState(() => _activeWordId =
                          _activeWordId == wordId ? null : wordId),
                ),
              ),
              const SizedBox(height: 24),

              // Вопросы
              if (data.blockText.questions.isNotEmpty) ...[
                SectionHeader('Вопросы по тексту'),
                const SizedBox(height: 8),
                ...data.blockText.questions.map((q) {
                  _answerControllers[q.id] ??= TextEditingController();
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _QuestionCard(
                      question: q,
                      controller: _answerControllers[q.id]!,
                      result: _answerResults[q.id],
                      pinyinEnabled: _pinyinEnabled,
                      onCheck: (answer) {
                        final correct = q.expectedKeywords
                            .any((kw) => answer.contains(kw));
                        setState(
                            () => _answerResults[q.id] = correct);
                      },
                    ),
                  );
                }),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ── TopBar ────────────────────────────────────────────────────────────────────

class _TextTopBar extends ConsumerWidget implements PreferredSizeWidget {
  final String title;
  final String titleZh;
  final bool pinyinEnabled;
  final VoidCallback onTogglePinyin;

  const _TextTopBar({
    required this.title,
    required this.titleZh,
    required this.pinyinEnabled,
    required this.onTogglePinyin,
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
              onTap: () => context.pop(),
              child: Container(
                width: 40, height: 40,
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
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: ts.headlineLarge,
                      overflow: TextOverflow.ellipsis),
                  Text(titleZh,
                      style: ts.hanziSmall
                          .copyWith(color: t.accentSecondary, fontSize: 12)),
                ],
              ),
            ),
            GestureDetector(
              onTap: onTogglePinyin,
              child: Container(
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: pinyinEnabled ? t.accentSoft : t.surfaceHighlight,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: pinyinEnabled
                        ? t.accent.withValues(alpha: 0.4)
                        : t.surfaceBorder,
                  ),
                ),
                child: Text(
                  pinyinEnabled ? '拼 ВКЛ' : '拼 ВЫКЛ',
                  style: ts.caption.copyWith(
                    color: pinyinEnabled ? t.accent : t.onSurfaceMuted,
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

// ── Тело текста с кликабельными словами ──────────────────────────────────────

class _TextBody extends ConsumerWidget {
  final _BlockTextData data;
  final bool pinyinEnabled;
  final String? activeWordId;
  final void Function(String) onWordTap;

  const _TextBody({
    required this.data,
    required this.pinyinEnabled,
    required this.activeWordId,
    required this.onWordTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(appTokensProvider);
    final ts = AppTextStyles.of(t);
    final segments = data.blockText.segments;

    return Wrap(
      alignment: WrapAlignment.start,
      crossAxisAlignment: WrapCrossAlignment.end,
      runSpacing: 8,
      children: segments.map((seg) {
        if (!seg.isWord || seg.wordId == null) {
          return Text(seg.text,
              style: ts.hanziMedium.copyWith(color: t.onSurface));
        }

        final word = data.wordMap[seg.wordId];
        final isActive = activeWordId == seg.wordId;

        return GestureDetector(
          onTap: () {
            ref.read(audioServiceProvider).speakChineseText(seg.text);
            onWordTap(seg.wordId!);
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Пиньинь над словом
              if (pinyinEnabled && word != null)
                Text(
                  word.pinyin,
                  style: ts.pinyin.copyWith(fontSize: 10),
                )
              else
                const SizedBox(height: 14),
              // Иероглиф
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 1),
                decoration: BoxDecoration(
                  color: isActive
                      ? t.accent.withValues(alpha: 0.15)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(4),
                  border: isActive
                      ? Border.all(
                          color: t.accent.withValues(alpha: 0.5), width: 1)
                      : null,
                ),
                child: Text(
                  seg.text,
                  style: ts.hanziMedium.copyWith(
                    color: isActive ? t.accent : t.onSurface,
                  ),
                ),
              ),
              // Попап-перевод под словом
              if (isActive && word != null)
                Container(
                  margin: const EdgeInsets.only(top: 4),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: t.accent,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: t.accent.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Text(
                    word.translationRu,
                    style: ts.caption.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

// ── Вопрос ────────────────────────────────────────────────────────────────────

class _QuestionCard extends ConsumerWidget {
  final TextQuestion question;
  final TextEditingController controller;
  final bool? result;
  final bool pinyinEnabled;
  final void Function(String) onCheck;

  const _QuestionCard({
    required this.question,
    required this.controller,
    required this.result,
    required this.pinyinEnabled,
    required this.onCheck,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(appTokensProvider);
    final ts = AppTextStyles.of(t);
    final answered = result != null;

    Color? borderColor;
    if (result == true) borderColor = t.accentSuccess;
    if (result == false) borderColor = t.accentDanger;

    return AppCard(
      customBorderColor: borderColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Вопрос
          Text(question.questionZh,
              style: ts.hanziSmall.copyWith(color: t.onSurface)),
          if (pinyinEnabled && question.questionPinyin.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(question.questionPinyin, style: ts.pinyin),
          ],
          const SizedBox(height: 12),

          // Поле ввода
          TextField(
            controller: controller,
            enabled: !answered,
            style: TextStyle(
              fontFamily: 'NotoSansSC',
              fontSize: 16,
              color: t.onSurface,
            ),
            decoration: InputDecoration(
              hintText: 'Введите ответ иероглифами...',
              hintStyle: ts.bodyMuted,
              filled: true,
              fillColor: t.surfaceHighlight,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: t.surfaceBorder),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: t.surfaceBorder),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: t.accent, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 10),
            ),
          ),
          const SizedBox(height: 10),

          // Кнопка проверки / результат
          if (!answered)
            GestureDetector(
              onTap: () => onCheck(controller.text.trim()),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: t.accentSoft,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: t.accent.withValues(alpha: 0.3), width: 1),
                ),
                child: Text('Проверить',
                    style: ts.label.copyWith(color: t.accent),
                    textAlign: TextAlign.center),
              ),
            )
          else
            Row(
              children: [
                Icon(
                  result! ? Icons.check_circle_rounded : Icons.cancel_rounded,
                  color: result! ? t.accentSuccess : t.accentDanger,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  result! ? 'Правильно!' : 'Подсказка: ${question.hintRu}',
                  style: ts.body.copyWith(
                    color: result! ? t.accentSuccess : t.accentDanger,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
