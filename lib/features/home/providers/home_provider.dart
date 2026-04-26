// lib/features/home/providers/home_provider.dart
//
// Теперь данные берутся из ContentRepository, не из хардкода.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/models.dart';
import '../../../data/repositories/content_repository.dart';

// Модели для HomeScreen — строим из реального репозитория

class HomeBlockViewModel {
  final Block block;
  final List<Topic> topics;
  final ProgressStatus blockStatus;
  final Map<String, ProgressStatus> topicStatuses;

  const HomeBlockViewModel({
    required this.block,
    required this.topics,
    required this.blockStatus,
    required this.topicStatuses,
  });

  int get completedTopics =>
      topicStatuses.values.where((s) => s == ProgressStatus.completed).length;
  int get totalTopics => topics.length;
  double get progressFraction =>
      totalTopics == 0 ? 0 : completedTopics / totalTopics;
}

final homeBlocksViewModelProvider =
    Provider<List<HomeBlockViewModel>>((ref) {
  final repo = ref.watch(contentRepositoryProvider);
  final blocks = repo.getAllBlocks();

  return blocks.map((block) {
    final topics = repo.getTopicsForBlock(block.id);
    final blockStatus = repo.getStatus(block.id);
    final topicStatuses = {
      for (final t in topics) t.id: repo.getStatus(t.id),
    };
    return HomeBlockViewModel(
      block: block,
      topics: topics,
      blockStatus: blockStatus,
      topicStatuses: topicStatuses,
    );
  }).toList();
});

// Провайдер, совместимый с виджетами (BlockModel/TopicModel)
final homeBlocksProvider = Provider<List<BlockModel>>((ref) {
  final viewModels = ref.watch(homeBlocksViewModelProvider);
  return viewModels.map((vm) {
    return BlockModel(
      emoji: vm.block.emoji,
      order: vm.block.order,
      titleRu: vm.block.titleRu,
      hskLevel: vm.block.hskLevel,
      descriptionRu: vm.block.descriptionRu,
      status: vm.blockStatus,
      topics: vm.topics
          .map((t) => TopicModel(
                order: t.order,
                status: vm.topicStatuses[t.id] ?? ProgressStatus.locked,
              ))
          .toList(),
      completedTopics: vm.completedTopics,
      totalTopics: vm.totalTopics,
      progressFraction: vm.progressFraction,
    );
  }).toList();
});

class UserStats {
  final int wordsLearned;
  final int streakDays;
  final double totalHours;
  final int topicsCompleted;
  final int fireCount;
  final int starCount;

  const UserStats({
    required this.wordsLearned,
    required this.streakDays,
    required this.totalHours,
    required this.topicsCompleted,
    required this.fireCount,
    required this.starCount,
  });
}

// Mock статистика — будет заменена реальными данными из Drift
final userStatsProvider = Provider<UserStats>((ref) => const UserStats(
      wordsLearned: 48,
      streakDays: 12,
      totalHours: 4.2,
      topicsCompleted: 2,
      fireCount: 7,
      starCount: 320,
    ));
