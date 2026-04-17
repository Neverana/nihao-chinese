import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/app_database.dart' as db;
import '../database/database_provider.dart';
import '../models/models.dart';

class ContentRepository {
  final Map<String, Block> _blocks = {};
  final Map<String, Topic> _topics = {};
  final Map<String, BlockText> _blockTexts = {};
  final Map<String, Word> _words = {};
  final Map<String, Dialogue> _dialogues = {};
  final Map<String, UserProgress> _progress = {};

  bool _seeded = false;
  db.AppDatabase? _db;

  void attachDatabase(db.AppDatabase database) {
    _db = database;
  }

  Future<void> seedIfNeeded() async {
    if (_seeded) return;
    await _seed();
    _seeded = true;
  }

  Future<void> _seed() async {
    String blocksRaw;
    try {
      blocksRaw = await rootBundle.loadString('assets/content/blocks.json');
    } catch (_) {
      _seedMock();
      return;
    }

    Map<String, dynamic> blocksJson;
    try {
      blocksJson = jsonDecode(blocksRaw) as Map<String, dynamic>;
    } catch (_) {
      _seedMock();
      return;
    }

    final blocksList = blocksJson['blocks'] as List? ?? [];
    if (blocksList.isEmpty) {
      _seedMock();
      return;
    }

    for (final blockData in blocksList) {
      final block = Block.fromJson(blockData as Map<String, dynamic>);
      _blocks[block.id] = block;
      for (final topicFile in block.topicFiles) {
        try {
          final topicRaw =
              await rootBundle.loadString('assets/content/topics/$topicFile');
          final topic =
              Topic.fromJson(jsonDecode(topicRaw) as Map<String, dynamic>);
          _topics[topic.id] = topic;
          for (final word in topic.words) _words[word.id] = word;
          for (final dialogue in topic.dialogues)
            _dialogues[dialogue.id] = dialogue;
        } catch (_) {}
      }
      if (block.blockTextFile.isNotEmpty) {
        try {
          final textRaw = await rootBundle
              .loadString('assets/content/topics/${block.blockTextFile}');
          final blockText =
              BlockText.fromJson(jsonDecode(textRaw) as Map<String, dynamic>);
          _blockTexts[blockText.id] = blockText;
        } catch (_) {}
      }
    }

    _initProgress();
  }

  void _initProgress() {
    final sortedBlocks = _blocks.values.toList()
      ..sort((a, b) => a.order.compareTo(b.order));
    for (int bi = 0; bi < sortedBlocks.length; bi++) {
      final block = sortedBlocks[bi];
      _progress[block.id] = UserProgress(
        entityId: block.id,
        entityType: EntityType.block,
        status: bi == 0 ? ProgressStatus.available : ProgressStatus.locked,
      );
      final topics = getTopicsForBlock(block.id);
      for (int ti = 0; ti < topics.length; ti++) {
        final topic = topics[ti];
        _progress[topic.id] = UserProgress(
          entityId: topic.id,
          entityType: EntityType.topic,
          status: (bi == 0 && ti == 0)
              ? ProgressStatus.available
              : ProgressStatus.locked,
        );
        for (int si = 0; si < topic.subtopics.length; si++) {
          final sub = topic.subtopics[si];
          _progress[sub.id] = UserProgress(
            entityId: sub.id,
            entityType: EntityType.subtopic,
            status: (bi == 0 && ti == 0 && si == 0)
                ? ProgressStatus.available
                : ProgressStatus.locked,
          );
        }
      }
    }
  }

  void _seedMock() {
    final mockWords = [
      const Word(
          id: 'w_nihao',
          hanzi: '你好',
          pinyin: 'nǐ hǎo',
          translationRu: 'привет, здравствуйте',
          exampleZh: '你好！我叫李明。',
          examplePinyin: 'Nǐ hǎo! Wǒ jiào Lǐ Míng.',
          exampleRu: 'Привет! Меня зовут Ли Мин.',
          hskLevel: 'HSK1',
          strokeCount: 9,
          tags: ['приветствие']),
      const Word(
          id: 'w_zaijian',
          hanzi: '再见',
          pinyin: 'zàijiàn',
          translationRu: 'до свидания',
          exampleZh: '再见！明天见。',
          examplePinyin: 'Zàijiàn! Míngtiān jiàn.',
          exampleRu: 'До свидания! Увидимся завтра.',
          hskLevel: 'HSK1',
          strokeCount: 9,
          tags: ['приветствие']),
      const Word(
          id: 'w_xiexie',
          hanzi: '谢谢',
          pinyin: 'xièxie',
          translationRu: 'спасибо',
          exampleZh: '谢谢你的帮助。',
          examplePinyin: 'Xièxie nǐ de bāngzhù.',
          exampleRu: 'Спасибо за помощь.',
          hskLevel: 'HSK1',
          strokeCount: 12,
          tags: ['этикет']),
      const Word(
          id: 'w_wo',
          hanzi: '我',
          pinyin: 'wǒ',
          translationRu: 'я',
          exampleZh: '我是学生。',
          examplePinyin: 'Wǒ shì xuésheng.',
          exampleRu: 'Я студент.',
          hskLevel: 'HSK1',
          strokeCount: 7,
          tags: ['местоимение']),
      const Word(
          id: 'w_ni',
          hanzi: '你',
          pinyin: 'nǐ',
          translationRu: 'ты',
          exampleZh: '你好吗？',
          examplePinyin: 'Nǐ hǎo ma?',
          exampleRu: 'Как ты?',
          hskLevel: 'HSK1',
          strokeCount: 7,
          tags: ['местоимение']),
      const Word(
          id: 'w_shi',
          hanzi: '是',
          pinyin: 'shì',
          translationRu: 'быть, являться',
          exampleZh: '我是中国人。',
          examplePinyin: 'Wǒ shì Zhōngguórén.',
          exampleRu: 'Я китаец.',
          hskLevel: 'HSK1',
          strokeCount: 9,
          tags: ['глагол']),
      const Word(
          id: 'w_jiao',
          hanzi: '叫',
          pinyin: 'jiào',
          translationRu: 'звать, называться',
          exampleZh: '我叫安娜。',
          examplePinyin: 'Wǒ jiào Ānnà.',
          exampleRu: 'Меня зовут Анна.',
          hskLevel: 'HSK1',
          strokeCount: 5,
          tags: ['глагол']),
      const Word(
          id: 'w_mingzi',
          hanzi: '名字',
          pinyin: 'míngzi',
          translationRu: 'имя',
          exampleZh: '你叫什么名字？',
          examplePinyin: 'Nǐ jiào shénme míngzi?',
          exampleRu: 'Как тебя зовут?',
          hskLevel: 'HSK1',
          strokeCount: 12,
          tags: ['существительное']),
    ];
    for (final w in mockWords) _words[w.id] = w;
    final mockSubtopic1 = Subtopic(
        id: 'block_1_topic_1_sub_1',
        topicId: 'block_1_topic_1',
        order: 1,
        titleRu: 'Урок 1: Приветствия',
        titleZh: '第一课：打招呼',
        estimatedMinutes: 8,
        wordIds: [
          'w_nihao',
          'w_zaijian',
          'w_xiexie',
          'w_wo',
          'w_ni'
        ],
        grammarIds: [
          'gram_svo',
          'gram_ma'
        ],
        exercises: const [
          ExerciseConfig(type: ExerciseType.wordMatching, params: {
            'pairCount': 4,
            'wordIds': ['w_nihao', 'w_zaijian', 'w_xiexie', 'w_wo']
          }),
          ExerciseConfig(type: ExerciseType.translation, params: {
            'direction': 'zh_to_ru',
            'wordIds': ['w_nihao', 'w_zaijian', 'w_xiexie']
          }),
          ExerciseConfig(
              type: ExerciseType.dialogue,
              params: {'dialogueId': 'dlg_b1t1_hello'})
        ]);
    final mockSubtopic2 = Subtopic(
        id: 'block_1_topic_1_sub_2',
        topicId: 'block_1_topic_1',
        order: 2,
        titleRu: 'Урок 2: Знакомство',
        titleZh: '第二课：自我介绍',
        estimatedMinutes: 10,
        wordIds: [
          'w_shi',
          'w_jiao',
          'w_mingzi'
        ],
        grammarIds: [
          'gram_jiao'
        ],
        exercises: const [
          ExerciseConfig(type: ExerciseType.translation, params: {
            'direction': 'ru_to_zh',
            'wordIds': ['w_shi', 'w_jiao', 'w_mingzi']
          }),
          ExerciseConfig(type: ExerciseType.wordMatching, params: {
            'pairCount': 3,
            'wordIds': ['w_shi', 'w_jiao', 'w_mingzi']
          }),
          ExerciseConfig(
              type: ExerciseType.calligraphy, params: {'wordId': 'w_wo'})
        ]);
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
        grammar: const [],
        dialogues: []);
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
        subtopics: const [],
        words: mockWords.skip(5).toList(),
        grammar: const [],
        dialogues: const []);
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
        subtopics: const [],
        words: const [],
        grammar: const [],
        dialogues: const []);
    final mockTopic4 = Topic(
        id: 'block_1_topic_4',
        blockId: 'block_1',
        order: 4,
        titleRu: 'Профессии и работа',
        titleZh: '职业与工作',
        descriptionRu: 'Работа · 14 слов · 4 урока',
        situationRu: 'После этой темы вы сможете рассказать о своей профессии.',
        hskLevel: 'HSK1',
        subtopics: const [],
        words: const [],
        grammar: const [],
        dialogues: const []);
    for (final t in [mockTopic1, mockTopic2, mockTopic3, mockTopic4])
      _topics[t.id] = t;
    _blocks['block_1'] = const Block(
        id: 'block_1',
        order: 1,
        titleRu: 'Знакомство и приветствия',
        titleZh: '第一章：问候与介绍',
        descriptionRu: 'Первые шаги в китайском языке',
        emoji: '🌱',
        hskLevel: 'HSK 1',
        blockTextFile: '',
        topicFiles: []);
    _progress['block_1'] = const UserProgress(
        entityId: 'block_1',
        entityType: EntityType.block,
        status: ProgressStatus.inProgress);
    _progress['block_1_topic_1'] = const UserProgress(
        entityId: 'block_1_topic_1',
        entityType: EntityType.topic,
        status: ProgressStatus.inProgress);
    _progress['block_1_topic_2'] = const UserProgress(
        entityId: 'block_1_topic_2',
        entityType: EntityType.topic,
        status: ProgressStatus.available);
    _progress['block_1_topic_3'] = const UserProgress(
        entityId: 'block_1_topic_3',
        entityType: EntityType.topic,
        status: ProgressStatus.locked);
    _progress['block_1_topic_4'] = const UserProgress(
        entityId: 'block_1_topic_4',
        entityType: EntityType.topic,
        status: ProgressStatus.locked);
    _progress['block_1_topic_1_sub_1'] = const UserProgress(
        entityId: 'block_1_topic_1_sub_1',
        entityType: EntityType.subtopic,
        status: ProgressStatus.available);
    _progress['block_1_topic_1_sub_2'] = const UserProgress(
        entityId: 'block_1_topic_1_sub_2',
        entityType: EntityType.subtopic,
        status: ProgressStatus.locked);
  }

  List<Block> getAllBlocks() =>
      _blocks.values.toList()..sort((a, b) => a.order.compareTo(b.order));
  Block? getBlock(String id) => _blocks[id];
  List<Topic> getTopicsForBlock(String blockId) {
    final topics = _topics.values.where((t) => t.blockId == blockId).toList();
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
  void completeSubtopic(String subtopicId, {int score = 100}) {
    _progress[subtopicId] = UserProgress(
        entityId: subtopicId,
        entityType: EntityType.subtopic,
        status: ProgressStatus.completed,
        score: score,
        completedAt: DateTime.now());
    _unlockNext(subtopicId);
  }

  void _unlockNext(String completedSubtopicId) {
    for (final topic in _topics.values) {
      final subs = topic.subtopics;
      for (int i = 0; i < subs.length; i++) {
        if (subs[i].id == completedSubtopicId) {
          if (i + 1 < subs.length) {
            final nextSub = subs[i + 1];
            if (getStatus(nextSub.id) == ProgressStatus.locked)
              _progress[nextSub.id] = UserProgress(
                  entityId: nextSub.id,
                  entityType: EntityType.subtopic,
                  status: ProgressStatus.available);
          } else {
            final allDone =
                subs.every((s) => getStatus(s.id) == ProgressStatus.completed);
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
              status: ProgressStatus.available);
          if (nextTopic.subtopics.isNotEmpty) {
            final firstSub = nextTopic.subtopics.first;
            _progress[firstSub.id] = UserProgress(
                entityId: firstSub.id,
                entityType: EntityType.subtopic,
                status: ProgressStatus.available);
          }
        }
        return;
      }
    }
  }

  void startSubtopic(String subtopicId) {
    if (getStatus(subtopicId) == ProgressStatus.available)
      _progress[subtopicId] = UserProgress(
          entityId: subtopicId,
          entityType: EntityType.subtopic,
          status: ProgressStatus.inProgress);
  }
}

final contentRepositoryProvider = Provider<ContentRepository>((ref) {
  final repo = ContentRepository();
  repo.attachDatabase(ref.read(appDatabaseProvider));
  return repo;
});
