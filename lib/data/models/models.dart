// lib/data/models/models.dart
//
// Все pure-Dart модели приложения.
// Drift-таблицы находятся в data/database/tables/.
// Эти модели используются в UI и провайдерах.

// ─── Прогресс ────────────────────────────────────────────────────────────────

enum ProgressStatus {
  locked,
  available,
  inProgress,
  completed;

  bool get isAccessible =>
      this == ProgressStatus.available ||
      this == ProgressStatus.inProgress ||
      this == ProgressStatus.completed;
}

enum EntityType { block, topic, subtopic }

class UserProgress {
  final String entityId;
  final EntityType entityType;
  final ProgressStatus status;
  final int score;
  final DateTime? completedAt;
  final bool finalTestPassed;

  const UserProgress({
    required this.entityId,
    required this.entityType,
    required this.status,
    this.score = 0,
    this.completedAt,
    this.finalTestPassed = false,
  });

  UserProgress copyWith({
    ProgressStatus? status,
    int? score,
    DateTime? completedAt,
    bool? finalTestPassed,
  }) =>
      UserProgress(
        entityId: entityId,
        entityType: entityType,
        status: status ?? this.status,
        score: score ?? this.score,
        completedAt: completedAt ?? this.completedAt,
        finalTestPassed: finalTestPassed ?? this.finalTestPassed,
      );
}

// ─── Упражнения ──────────────────────────────────────────────────────────────

enum ExerciseType {
  translation,
  dialogue,
  listening,
  wordMatching,
  calligraphy,
  fillInTheBlank,
  sentenceBuilder,
  toneSelection,
  pinyinInput,
  trueOrFalse,
  wordCardFlip,
}

class ExerciseConfig {
  final ExerciseType type;
  final Map<String, dynamic> params;

  const ExerciseConfig({required this.type, this.params = const {}});

  factory ExerciseConfig.fromJson(Map<String, dynamic> json) {
    final typeStr = json['type'] as String;
    final type = ExerciseType.values.firstWhere(
      (e) => e.name == typeStr,
      orElse: () => ExerciseType.translation,
    );
    return ExerciseConfig(
      type: type,
      params: Map<String, dynamic>.from(json['params'] as Map? ?? {}),
    );
  }
}

// ─── Слово ───────────────────────────────────────────────────────────────────

class Word {
  final String id;
  final String hanzi;
  final String pinyin;
  final String translationRu;
  final String? exampleZh;
  final String? examplePinyin;
  final String? exampleRu;
  final String hskLevel;
  final String? audioPath;
  final int strokeCount;
  final List<String> tags;
  final String? topicId;

  const Word({
    required this.id,
    required this.hanzi,
    required this.pinyin,
    required this.translationRu,
    this.exampleZh,
    this.examplePinyin,
    this.exampleRu,
    required this.hskLevel,
    this.audioPath,
    required this.strokeCount,
    required this.tags,
    this.topicId,
  });

  factory Word.fromJson(Map<String, dynamic> json) => Word(
        id: json['id'] as String,
        hanzi: json['hanzi'] as String,
        pinyin: json['pinyin'] as String,
        translationRu: json['translationRu'] as String,
        exampleZh: json['exampleZh'] as String?,
        examplePinyin: json['examplePinyin'] as String?,
        exampleRu: json['exampleRu'] as String?,
        hskLevel: json['hskLevel'] as String? ?? 'HSK1',
        audioPath: json['audioPath'] as String?,
        strokeCount: json['strokeCount'] as int? ?? 0,
        tags: List<String>.from(json['tags'] as List? ?? []),
        topicId: json['topicId'] as String?,
      );
}

// ─── Грамматика ───────────────────────────────────────────────────────────────

class Grammar {
  final String id;
  final String pattern;
  final String explanationRu;
  final String exampleZh;
  final String examplePinyin;
  final String exampleRu;
  final String hskLevel;
  final String topicId;

  const Grammar({
    required this.id,
    required this.pattern,
    required this.explanationRu,
    required this.exampleZh,
    required this.examplePinyin,
    required this.exampleRu,
    required this.hskLevel,
    required this.topicId,
  });

  factory Grammar.fromJson(Map<String, dynamic> json, String topicId) =>
      Grammar(
        id: json['id'] as String,
        pattern: json['pattern'] as String,
        explanationRu: json['explanationRu'] as String,
        exampleZh: json['exampleZh'] as String,
        examplePinyin: json['examplePinyin'] as String,
        exampleRu: json['exampleRu'] as String,
        hskLevel: json['hskLevel'] as String? ?? 'HSK1',
        topicId: topicId,
      );
}

// ─── Диалог ───────────────────────────────────────────────────────────────────

class DialogueTurn {
  final String speaker;
  final String role; // 'user' | 'other'
  final String zh;
  final String pinyin;
  final String ru;

  const DialogueTurn({
    required this.speaker,
    required this.role,
    required this.zh,
    required this.pinyin,
    required this.ru,
  });

  factory DialogueTurn.fromJson(Map<String, dynamic> json) => DialogueTurn(
        speaker: json['speaker'] as String,
        role: json['role'] as String,
        zh: json['zh'] as String,
        pinyin: json['pinyin'] as String,
        ru: json['ru'] as String,
      );
}

class Dialogue {
  final String id;
  final String titleRu;
  final List<DialogueTurn> turns;

  const Dialogue({
    required this.id,
    required this.titleRu,
    required this.turns,
  });

  factory Dialogue.fromJson(Map<String, dynamic> json) => Dialogue(
        id: json['id'] as String,
        titleRu: json['titleRu'] as String,
        turns: (json['turns'] as List)
            .map((t) => DialogueTurn.fromJson(t as Map<String, dynamic>))
            .toList(),
      );
}

// ─── Подтема / Урок ───────────────────────────────────────────────────────────

class Subtopic {
  final String id;
  final String topicId;
  final int order;
  final String titleRu;
  final String titleZh;
  final int estimatedMinutes;
  final List<String> wordIds;
  final List<String> grammarIds;
  final List<ExerciseConfig> exercises;

  const Subtopic({
    required this.id,
    required this.topicId,
    required this.order,
    required this.titleRu,
    required this.titleZh,
    required this.estimatedMinutes,
    required this.wordIds,
    required this.grammarIds,
    required this.exercises,
  });

  factory Subtopic.fromJson(Map<String, dynamic> json, String topicId) =>
      Subtopic(
        id: json['id'] as String,
        topicId: topicId,
        order: json['order'] as int,
        titleRu: json['titleRu'] as String,
        titleZh: json['titleZh'] as String? ?? '',
        estimatedMinutes: json['estimatedMinutes'] as int? ?? 10,
        wordIds: List<String>.from(json['wordIds'] as List? ?? []),
        grammarIds: List<String>.from(json['grammarIds'] as List? ?? []),
        exercises: (json['exercises'] as List? ?? [])
            .map((e) => ExerciseConfig.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}

// ─── Тема ────────────────────────────────────────────────────────────────────

class Topic {
  final String id;
  final String blockId;
  final int order;
  final String titleRu;
  final String titleZh;
  final String descriptionRu;
  final String situationRu;
  final String hskLevel;
  final List<Subtopic> subtopics;
  final List<Word> words;
  final List<Grammar> grammar;
  final List<Dialogue> dialogues;

  const Topic({
    required this.id,
    required this.blockId,
    required this.order,
    required this.titleRu,
    required this.titleZh,
    required this.descriptionRu,
    required this.situationRu,
    required this.hskLevel,
    required this.subtopics,
    required this.words,
    required this.grammar,
    required this.dialogues,
  });

  factory Topic.fromJson(Map<String, dynamic> json) {
    final id = json['id'] as String;
    return Topic(
      id: id,
      blockId: json['blockId'] as String,
      order: json['order'] as int,
      titleRu: json['titleRu'] as String,
      titleZh: json['titleZh'] as String? ?? '',
      descriptionRu: json['descriptionRu'] as String? ?? '',
      situationRu: json['situationRu'] as String? ?? '',
      hskLevel: json['hskLevel'] as String? ?? 'HSK1',
      words: (json['words'] as List? ?? [])
          .map((w) => Word.fromJson(w as Map<String, dynamic>))
          .toList(),
      grammar: (json['grammar'] as List? ?? [])
          .map((g) => Grammar.fromJson(g as Map<String, dynamic>, id))
          .toList(),
      subtopics: (json['subtopics'] as List? ?? [])
          .map((s) => Subtopic.fromJson(s as Map<String, dynamic>, id))
          .toList(),
      dialogues: (json['dialogues'] as List? ?? [])
          .map((d) => Dialogue.fromJson(d as Map<String, dynamic>))
          .toList(),
    );
  }
}

// ─── Текст блока ─────────────────────────────────────────────────────────────

class TextSegment {
  final String text;
  final bool isWord;
  final String? wordId;

  const TextSegment({
    required this.text,
    required this.isWord,
    this.wordId,
  });

  factory TextSegment.fromJson(Map<String, dynamic> json) => TextSegment(
        text: json['text'] as String,
        isWord: json['isWord'] as bool? ?? false,
        wordId: json['wordId'] as String?,
      );
}

class TextQuestion {
  final String id;
  final String questionZh;
  final String questionPinyin;
  final List<String> expectedKeywords;
  final String hintRu;

  const TextQuestion({
    required this.id,
    required this.questionZh,
    required this.questionPinyin,
    required this.expectedKeywords,
    required this.hintRu,
  });

  factory TextQuestion.fromJson(Map<String, dynamic> json) => TextQuestion(
        id: json['id'] as String,
        questionZh: json['questionZh'] as String,
        questionPinyin: json['questionPinyin'] as String? ?? '',
        expectedKeywords:
            List<String>.from(json['expectedKeywords'] as List? ?? []),
        hintRu: json['hintRu'] as String? ?? '',
      );
}

class BlockText {
  final String id;
  final String blockId;
  final String titleZh;
  final String titleRu;
  final List<TextSegment> segments;
  final List<TextQuestion> questions;

  const BlockText({
    required this.id,
    required this.blockId,
    required this.titleZh,
    required this.titleRu,
    required this.segments,
    required this.questions,
  });

  factory BlockText.fromJson(Map<String, dynamic> json) => BlockText(
        id: json['id'] as String,
        blockId: json['blockId'] as String,
        titleZh: json['titleZh'] as String,
        titleRu: json['titleRu'] as String,
        segments: (json['segments'] as List? ?? [])
            .map((s) => TextSegment.fromJson(s as Map<String, dynamic>))
            .toList(),
        questions: (json['questions'] as List? ?? [])
            .map((q) => TextQuestion.fromJson(q as Map<String, dynamic>))
            .toList(),
      );
}

// ─── Блок ────────────────────────────────────────────────────────────────────

class Block {
  final String id;
  final int order;
  final String titleRu;
  final String titleZh;
  final String descriptionRu;
  final String emoji;
  final String hskLevel;
  final String blockTextFile;
  final List<String> topicFiles;

  const Block({
    required this.id,
    required this.order,
    required this.titleRu,
    required this.titleZh,
    required this.descriptionRu,
    required this.emoji,
    required this.hskLevel,
    required this.blockTextFile,
    required this.topicFiles,
  });

  factory Block.fromJson(Map<String, dynamic> json) => Block(
        id: json['id'] as String,
        order: json['order'] as int,
        titleRu: json['titleRu'] as String,
        titleZh: json['titleZh'] as String? ?? '',
        descriptionRu: json['descriptionRu'] as String? ?? '',
        emoji: json['emoji'] as String? ?? '📚',
        hskLevel: json['hskLevel'] as String? ?? 'HSK1',
        blockTextFile: json['blockTextFile'] as String? ?? '',
        topicFiles: List<String>.from(json['topicFiles'] as List? ?? []),
      );
}

// ─── Словарная запись ─────────────────────────────────────────────────────────

class DictionaryEntry {
  final String wordId;
  final DateTime addedAt;
  final String topicId;
  final int repetitionCount;
  final double easeFactor;
  final DateTime nextReview;
  final int interval;

  const DictionaryEntry({
    required this.wordId,
    required this.addedAt,
    required this.topicId,
    this.repetitionCount = 0,
    this.easeFactor = 2.5,
    required this.nextReview,
    this.interval = 1,
  });
}

// ─── Каллиграфия ─────────────────────────────────────────────────────────────

class CalligraphyEntry {
  final String wordId;
  final DateTime addedAt;
  final String topicId;
  final int practiceCount;
  final int masteryLevel; // 0–3
  final DateTime? lastPracticed;

  const CalligraphyEntry({
    required this.wordId,
    required this.addedAt,
    required this.topicId,
    this.practiceCount = 0,
    this.masteryLevel = 0,
    this.lastPracticed,
  });
}

// ─── UI-модели для HomeScreen ─────────────────────────────────────────────────
// Используются block_card.dart и home_screen.dart.
// Строятся провайдером homeBlocksProvider из HomeBlockViewModel.

class TopicModel {
  final int order;
  final ProgressStatus status;

  const TopicModel({required this.order, required this.status});
}

class BlockModel {
  final String emoji;
  final int order;
  final String titleRu;
  final String hskLevel;
  final String descriptionRu;
  final ProgressStatus status;
  final List<TopicModel> topics;
  final int completedTopics;
  final int totalTopics;
  final double progressFraction;

  const BlockModel({
    required this.emoji,
    required this.order,
    required this.titleRu,
    required this.hskLevel,
    required this.descriptionRu,
    required this.status,
    required this.topics,
    required this.completedTopics,
    required this.totalTopics,
    required this.progressFraction,
  });
}

// ─── Результат урока ─────────────────────────────────────────────────────────

class LessonResult {
  final String subtopicId;
  final int totalExercises;
  final int correctAnswers;
  final List<Word> newWords;
  final int xpEarned;

  const LessonResult({
    required this.subtopicId,
    required this.totalExercises,
    required this.correctAnswers,
    required this.newWords,
    required this.xpEarned,
  });

  double get accuracy =>
      totalExercises == 0 ? 0 : correctAnswers / totalExercises;
}
