// lib/data/repositories/content_repository.dart
//
// На этом этапе — JSON → in-memory хранилище (Map).
// Позже заменяется на Drift без изменения публичного API.
// Вызывается один раз при старте из main.dart.

import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';

class ContentRepository {
  // ── In-memory хранилище ──────────────────────────────────────────────────
  final Map<String, Block> _blocks = {};
  final Map<String, Topic> _topics = {};
  final Map<String, BlockText> _blockTexts = {};
  final Map<String, Word> _words = {};
  final Map<String, Dialogue> _dialogues = {};

  // Прогресс — ключ: entityId
  final Map<String, UserProgress> _progress = {};

  bool _seeded = false;

  // ── Инициализация ─────────────────────────────────────────────────────────

  Future<void> seedIfNeeded() async {
    if (_seeded) return;
    await _seed();
    _seeded = true;
  }

  Future<void> _seed() async {
    // 1. Читаем blocks.json
    String blocksRaw;
    try {
      blocksRaw = await rootBundle.loadString('assets/content/blocks.json');
    } catch (_) {
      // blocks.json пуст или содержит заглушку — используем mock
      _seedMock();
      return;
    }

    final blocksJson = jsonDecode(blocksRaw) as Map<String, dynamic>;
    final blocksList = blocksJson['blocks'] as List? ?? [];

    if (blocksList.isEmpty) {
      _seedMock();
      return;
    }

    // 2. Парсим каждый блок и его темы
    for (final blockData in blocksList) {
      final block = Block.fromJson(blockData as Map<String, dynamic>);
      _blocks[block.id] = block;

      // Читаем темы
      for (final topicFile in block.topicFiles) {
        try {
          final topicRaw = await rootBundle
              .loadString('assets/content/topics/$topicFile');
          final topic = Topic.fromJson(
              jsonDecode(topicRaw) as Map<String, dynamic>);
          _topics[topic.id] = topic;

          // Индексируем слова и диалоги
          for (final word in topic.words) {
            _words[word.id] = word;
          }
          for (final dialogue in topic.dialogues) {
            _dialogues[dialogue.id] = dialogue;
          }
        } catch (e) {
          // файл не найден — пропускаем
        }
      }

      // Читаем текст блока
      if (block.blockTextFile.isNotEmpty) {
        try {
          final textRaw = await rootBundle
              .loadString('assets/content/topics/${block.blockTextFile}');
          final blockText = BlockText.fromJson(
              jsonDecode(textRaw) as Map<String, dynamic>);
          _blockTexts[blockText.id] = blockText;
        } catch (_) {}
      }
    }

    // 3. Инициализируем прогресс
    _initProgress();
  }

  void _initProgress() {
    final sortedBlocks = _blocks.values.toList()
      ..sort((a, b) => a.order.compareTo(b.order));

    for (int bi = 0; bi < sortedBlocks.length; bi++) {
      final block = sortedBlocks[bi];
      final blockStatus =
          bi == 0 ? ProgressStatus.available : ProgressStatus.locked;

      _progress[block.id] = UserProgress(
        entityId: block.id,
        entityType: EntityType.block,
        status: blockStatus,
      );

      final topics = getTopicsForBlock(block.id);
      for (int ti = 0; ti < topics.length; ti++) {
        final topic = topics[ti];
        final topicStatus = (bi == 0 && ti == 0)
            ? ProgressStatus.available
            : ProgressStatus.locked;

        _progress[topic.id] = UserProgress(
          entityId: topic.id,
          entityType: EntityType.topic,
          status: topicStatus,
        );

        for (int si = 0; si < topic.subtopics.length; si++) {
          final sub = topic.subtopics[si];
          final subStatus = (bi == 0 && ti == 0 && si == 0)
              ? ProgressStatus.available
              : ProgressStatus.locked;

          _progress[sub.id] = UserProgress(
            entityId: sub.id,
            entityType: EntityType.subtopic,
            status: subStatus,
          );
        }
      }
    }
  }

  // ── Mock-данные (пока нет реального JSON) ────────────────────────────────

  void _seedMock() {
    final mockWords = [
      const Word(id: 'w_nihao', hanzi: '你好', pinyin: 'nǐ hǎo',
          translationRu: 'привет, здравствуйте',
          exampleZh: '你好！我叫李明。', examplePinyin: 'Nǐ hǎo! Wǒ jiào Lǐ Míng.',
          exampleRu: 'Привет! Меня зовут Ли Мин.',
          hskLevel: 'HSK1', strokeCount: 9, tags: ['приветствие']),
      const Word(id: 'w_zaijian', hanzi: '再见', pinyin: 'zàijiàn',
          translationRu: 'до свидания',
          exampleZh: '再见！明天见。', examplePinyin: 'Zàijiàn! Míngtiān jiàn.',
          exampleRu: 'До свидания! Увидимся завтра.',
          hskLevel: 'HSK1', strokeCount: 9, tags: ['приветствие']),
      const Word(id: 'w_xiexie', hanzi: '谢谢', pinyin: 'xièxie',
          translationRu: 'спасибо',
          exampleZh: '谢谢你的帮助。', examplePinyin: 'Xièxie nǐ de bāngzhù.',
          exampleRu: 'Спасибо за помощь.',
          hskLevel: 'HSK1', strokeCount: 12, tags: ['этикет']),
      const Word(id: 'w_wo', hanzi: '我', pinyin: 'wǒ',
          translationRu: 'я',
          exampleZh: '我是学生。', examplePinyin: 'Wǒ shì xuésheng.',
          exampleRu: 'Я студент.',
          hskLevel: 'HSK1', strokeCount: 7, tags: ['местоимение']),
      const Word(id: 'w_ni', hanzi: '你', pinyin: 'nǐ',
          translationRu: 'ты',
          exampleZh: '你好吗？', examplePinyin: 'Nǐ hǎo ma?',
          exampleRu: 'Как ты?',
          hskLevel: 'HSK1', strokeCount: 7, tags: ['местоимение']),
      const Word(id: 'w_shi', hanzi: '是', pinyin: 'shì',
          translationRu: 'быть, являться',
          exampleZh: '我是中国人。', examplePinyin: 'Wǒ shì Zhōngguórén.',
          exampleRu: 'Я китаец.',
          hskLevel: 'HSK1', strokeCount: 9, tags: ['глагол']),
      const Word(id: 'w_jiao', hanzi: '叫', pinyin: 'jiào',
          translationRu: 'звать, называться',
          exampleZh: '我叫安娜。', examplePinyin: 'Wǒ jiào Ānnà.',
          exampleRu: 'Меня зовут Анна.',
          hskLevel: 'HSK1', strokeCount: 5, tags: ['глагол']),
      const Word(id: 'w_mingzi', hanzi: '名字', pinyin: 'míngzi',
          translationRu: 'имя',
          exampleZh: '你叫什么名字？', examplePinyin: 'Nǐ jiào shénme míngzi?',
          exampleRu: 'Как тебя зовут?',
          hskLevel: 'HSK1', strokeCount: 12, tags: ['существительное']),
    ];

    for (final w in mockWords) {
      _words[w.id] = w;
    }

    final mockGrammar = [
      Grammar(
        id: 'gram_svo', pattern: 'S + 是 + O (shì)',
        explanationRu: 'Базовая связка «быть». Я есть студент.',
        exampleZh: '我是学生。', examplePinyin: 'Wǒ shì xuésheng.',
        exampleRu: 'Я студент.',
        hskLevel: 'HSK1', topicId: 'block_1_topic_1',
      ),
      Grammar(
        id: 'gram_ma', pattern: '...吗？(ma)',
        explanationRu: 'Вопросительная частица. Добавь 吗 в конец — получишь вопрос.',
        exampleZh: '你好吗？', examplePinyin: 'Nǐ hǎo ma?',
        exampleRu: 'Ты в порядке?',
        hskLevel: 'HSK1', topicId: 'block_1_topic_1',
      ),
      Grammar(
        id: 'gram_jiao', pattern: '我叫... (wǒ jiào)',
        explanationRu: 'Представиться: меня зовут...',
        exampleZh: '我叫李明。', examplePinyin: 'Wǒ jiào Lǐ Míng.',
        exampleRu: 'Меня зовут Ли Мин.',
        hskLevel: 'HSK1', topicId: 'block_1_topic_1',
      ),
    ];

    final mockDialogue = Dialogue(
      id: 'dlg_b1t1_hello',
      titleRu: 'Первое знакомство',
      turns: [
        const DialogueTurn(speaker: 'Ли Мин', role: 'other',
            zh: '你好！你叫什么名字？',
            pinyin: 'Nǐ hǎo! Nǐ jiào shénme míngzi?',
            ru: 'Привет! Как тебя зовут?'),
        const DialogueTurn(speaker: 'Вы', role: 'user',
            zh: '你好！我叫安娜。',
            pinyin: 'Nǐ hǎo! Wǒ jiào Ānnà.',
            ru: 'Привет! Меня зовут Анна.'),
        const DialogueTurn(speaker: 'Ли Мин', role: 'other',
            zh: '很高兴认识你！',
            pinyin: 'Hěn gāoxìng rènshi nǐ!',
            ru: 'Очень приятно познакомиться!'),
        const DialogueTurn(speaker: 'Вы', role: 'user',
            zh: '我也很高兴认识你！',
            pinyin: 'Wǒ yě hěn gāoxìng rènshi nǐ!',
            ru: 'Мне тоже очень приятно!'),
      ],
    );
    _dialogues[mockDialogue.id] = mockDialogue;

    final mockSubtopic1 = Subtopic(
      id: 'block_1_topic_1_sub_1',
      topicId: 'block_1_topic_1',
      order: 1,
      titleRu: 'Урок 1: Приветствия',
      titleZh: '第一课：打招呼',
      estimatedMinutes: 8,
      wordIds: ['w_nihao', 'w_zaijian', 'w_xiexie', 'w_wo', 'w_ni'],
      grammarIds: ['gram_svo', 'gram_ma'],
      exercises: const [
        ExerciseConfig(type: ExerciseType.wordMatching,
            params: {'pairCount': 4, 'wordIds': ['w_nihao', 'w_zaijian', 'w_xiexie', 'w_wo']}),
        ExerciseConfig(type: ExerciseType.translation,
            params: {'direction': 'zh_to_ru', 'wordIds': ['w_nihao', 'w_zaijian', 'w_xiexie']}),
        ExerciseConfig(type: ExerciseType.dialogue,
            params: {'dialogueId': 'dlg_b1t1_hello'}),
      ],
    );

    final mockSubtopic2 = Subtopic(
      id: 'block_1_topic_1_sub_2',
      topicId: 'block_1_topic_1',
      order: 2,
      titleRu: 'Урок 2: Знакомство',
      titleZh: '第二课：自我介绍',
      estimatedMinutes: 10,
      wordIds: ['w_shi', 'w_jiao', 'w_mingzi'],
      grammarIds: ['gram_jiao'],
      exercises: const [
        ExerciseConfig(type: ExerciseType.translation,
            params: {'direction': 'ru_to_zh', 'wordIds': ['w_shi', 'w_jiao', 'w_mingzi']}),
        ExerciseConfig(type: ExerciseType.wordMatching,
            params: {'pairCount': 3, 'wordIds': ['w_shi', 'w_jiao', 'w_mingzi']}),
        ExerciseConfig(type: ExerciseType.calligraphy,
            params: {'wordId': 'w_wo'}),
      ],
    );

    final mockTopic1 = Topic(
      id: 'block_1_topic_1',
      blockId: 'block_1',
      order: 1,
      titleRu: 'Приветствия и этикет',
      titleZh: '问候与礼仪',
      descriptionRu: 'Приветствия · 8 слов · 2 урока',
      situationRu:
          'После этой темы вы сможете поздороваться, представиться и поблагодарить собеседника.',
      hskLevel: 'HSK1',
      subtopics: [mockSubtopic1, mockSubtopic2],
      words: mockWords.take(5).toList(),
      grammar: mockGrammar.take(2).toList(),
      dialogues: [mockDialogue],
    );

    final mockTopic2 = Topic(
      id: 'block_1_topic_2',
      blockId: 'block_1',
      order: 2,
      titleRu: 'Числа и возраст',
      titleZh: '数字与年龄',
      descriptionRu: 'Числа · 12 слов · 3 урока',
      situationRu:
          'После этой темы вы сможете называть числа, спрашивать и говорить о возрасте.',
      hskLevel: 'HSK1',
      subtopics: [],
      words: mockWords.skip(5).toList(),
      grammar: mockGrammar.skip(2).toList(),
      dialogues: [],
    );

    final mockTopic3 = Topic(
      id: 'block_1_topic_3',
      blockId: 'block_1',
      order: 3,
      titleRu: 'Семья и родственники',
      titleZh: '家庭与亲属',
      descriptionRu: 'Семья · 10 слов · 3 урока',
      situationRu:
          'После этой темы вы сможете рассказать о своей семье и понять простой текст о родственниках.',
      hskLevel: 'HSK1',
      subtopics: [],
      words: [],
      grammar: [],
      dialogues: [],
    );

    final mockTopic4 = Topic(
      id: 'block_1_topic_4',
      blockId: 'block_1',
      order: 4,
      titleRu: 'Профессии и работа',
      titleZh: '职业与工作',
      descriptionRu: 'Работа · 14 слов · 4 урока',
      situationRu:
          'После этой темы вы сможете рассказать о своей профессии.',
      hskLevel: 'HSK1',
      subtopics: [],
      words: [],
      grammar: [],
      dialogues: [],
    );

    for (final t in [mockTopic1, mockTopic2, mockTopic3, mockTopic4]) {
      _topics[t.id] = t;
    }

    final mockBlock1 = const Block(
      id: 'block_1',
      order: 1,
      titleRu: 'Знакомство и приветствия',
      titleZh: '第一章：问候与介绍',
      descriptionRu: 'Первые шаги в китайском языке',
      emoji: '🌱',
      hskLevel: 'HSK 1',
      blockTextFile: '',
      topicFiles: [],
    );
    _blocks[mockBlock1.id] = mockBlock1;

    _progress['block_1'] = const UserProgress(
      entityId: 'block_1',
      entityType: EntityType.block,
      status: ProgressStatus.inProgress,
    );
    _progress['block_1_topic_1'] = const UserProgress(
      entityId: 'block_1_topic_1',
      entityType: EntityType.topic,
      status: ProgressStatus.inProgress,
    );
    _progress['block_1_topic_2'] = const UserProgress(
      entityId: 'block_1_topic_2',
      entityType: EntityType.topic,
      status: ProgressStatus.available,
    );
    _progress['block_1_topic_3'] = const UserProgress(
      entityId: 'block_1_topic_3',
      entityType: EntityType.topic,
      status: ProgressStatus.locked,
    );
    _progress['block_1_topic_4'] = const UserProgress(
      entityId: 'block_1_topic_4',
      entityType: EntityType.topic,
      status: ProgressStatus.locked,
    );
    _progress['block_1_topic_1_sub_1'] = const UserProgress(
      entityId: 'block_1_topic_1_sub_1',
      entityType: EntityType.subtopic,
      status: ProgressStatus.available,
    );
    _progress['block_1_topic_1_sub_2'] = const UserProgress(
      entityId: 'block_1_topic_1_sub_2',
      entityType: EntityType.subtopic,
      status: ProgressStatus.locked,
    );
  }

  // ── Публичный API ─────────────────────────────────────────────────────────

  List<Block> getAllBlocks() =>
      _blocks.values.toList()..sort((a, b) => a.order.compareTo(b.order));

  Block? getBlock(String id) => _blocks[id];

  List<Topic> getTopicsForBlock(String blockId) {
    final topics =
        _topics.values.where((t) => t.blockId == blockId).toList();
    topics.sort((a, b) => a.order.compareTo(b.order));
    return topics;
  }

  Topic? getTopic(String id) => _topics[id];

  Subtopic? getSubtopic(String id) {
    for (final topic in _topics.values) {
      for (final sub in topic.subtopics) {
        if (sub.id == id) return sub;
      }
    }
    return null;
  }

  Word? getWord(String id) => _words[id];

  List<Word> getWordsForIds(List<String> ids) =>
      ids.map((id) => _words[id]).whereType<Word>().toList();

  Dialogue? getDialogue(String id) => _dialogues[id];

  BlockText? getBlockText(String blockId) =>
      _blockTexts.values.where((bt) => bt.blockId == blockId).firstOrNull;

  UserProgress? getProgress(String entityId) => _progress[entityId];

  ProgressStatus getStatus(String entityId) =>
      _progress[entityId]?.status ?? ProgressStatus.locked;

  // ── Обновление прогресса ──────────────────────────────────────────────────

  void completeSubtopic(String subtopicId, {int score = 100}) {
    _progress[subtopicId] = UserProgress(
      entityId: subtopicId,
      entityType: EntityType.subtopic,
      status: ProgressStatus.completed,
      score: score,
      completedAt: DateTime.now(),
    );
    _unlockNext(subtopicId);
  }

  void _unlockNext(String completedSubtopicId) {
    // Найти следующую подтему или тему
    for (final topic in _topics.values) {
      final subs = topic.subtopics;
      for (int i = 0; i < subs.length; i++) {
        if (subs[i].id == completedSubtopicId) {
          // Есть следующая подтема?
          if (i + 1 < subs.length) {
            final nextSub = subs[i + 1];
            if (getStatus(nextSub.id) == ProgressStatus.locked) {
              _progress[nextSub.id] = UserProgress(
                entityId: nextSub.id,
                entityType: EntityType.subtopic,
                status: ProgressStatus.available,
              );
            }
          } else {
            // Все подтемы темы завершены?
            final allDone = subs.every(
                (s) => getStatus(s.id) == ProgressStatus.completed);
            if (allDone) {
              _progress[topic.id] = (_progress[topic.id] ??
                      UserProgress(
                          entityId: topic.id,
                          entityType: EntityType.topic,
                          status: ProgressStatus.completed))
                  .copyWith(
                      status: ProgressStatus.completed,
                      completedAt: DateTime.now());
              _unlockNextTopic(topic.id);
            }
          }
          return;
        }
      }
    }
  }

  void _unlockNextTopic(String completedTopicId) {
    final topic = _topics[completedTopicId];
    if (topic == null) return;

    final blockTopics = getTopicsForBlock(topic.blockId);
    for (int i = 0; i < blockTopics.length; i++) {
      if (blockTopics[i].id == completedTopicId && i + 1 < blockTopics.length) {
        final nextTopic = blockTopics[i + 1];
        if (getStatus(nextTopic.id) == ProgressStatus.locked) {
          _progress[nextTopic.id] = UserProgress(
            entityId: nextTopic.id,
            entityType: EntityType.topic,
            status: ProgressStatus.available,
          );
          // Разблокировать первую подтему следующей темы
          if (nextTopic.subtopics.isNotEmpty) {
            final firstSub = nextTopic.subtopics.first;
            _progress[firstSub.id] = UserProgress(
              entityId: firstSub.id,
              entityType: EntityType.subtopic,
              status: ProgressStatus.available,
            );
          }
        }
        return;
      }
    }
  }

  void startSubtopic(String subtopicId) {
    if (getStatus(subtopicId) == ProgressStatus.available) {
      _progress[subtopicId] = UserProgress(
        entityId: subtopicId,
        entityType: EntityType.subtopic,
        status: ProgressStatus.inProgress,
      );
    }
  }
}

// ── Provider ─────────────────────────────────────────────────────────────────

final contentRepositoryProvider = Provider<ContentRepository>((ref) {
  return ContentRepository();
});
