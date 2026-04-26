// lib/core/router/app_router.dart

import 'package:go_router/go_router.dart';
import '../../features/home/home_screen.dart';
import '../../features/block/block_screen.dart';
import '../../features/topic/topic_screen.dart';
import '../../features/lesson/lesson_screen.dart';
import '../../features/lesson/lesson_result_screen.dart';
import '../../features/final_test/final_test_screen.dart';
import '../../features/block_text/block_text_screen.dart';
import '../../features/calligraphy/calligraphy_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/block/:blockId',
      name: 'block',
      builder: (context, state) =>
          BlockScreen(blockId: state.pathParameters['blockId']!),
    ),
    GoRoute(
      path: '/topic/:topicId',
      name: 'topic',
      builder: (context, state) =>
          TopicScreen(topicId: state.pathParameters['topicId']!),
    ),
    GoRoute(
      path: '/lesson/:subtopicId',
      name: 'lesson',
      builder: (context, state) => LessonScreen(
        subtopicId: state.pathParameters['subtopicId']!,
        isReview: state.uri.queryParameters['review'] == 'true',
        isFinalTest: false,
      ),
    ),
    GoRoute(
      path: '/lesson-result/:subtopicId',
      name: 'lessonResult',
      builder: (context, state) => LessonResultScreen(
        subtopicId: state.pathParameters['subtopicId']!,
        correct: int.tryParse(state.uri.queryParameters['correct'] ?? '0') ?? 0,
        total: int.tryParse(state.uri.queryParameters['total'] ?? '0') ?? 0,
      ),
    ),
    GoRoute(
      path: '/final-test/:topicId',
      name: 'finalTest',
      builder: (context, state) =>
          FinalTestScreen(topicId: state.pathParameters['topicId']!),
    ),
    GoRoute(
      path: '/block-text/:blockId',
      name: 'blockText',
      builder: (context, state) =>
          BlockTextScreen(blockId: state.pathParameters['blockId']!),
    ),
    GoRoute(
      path: '/calligraphy/:wordId',
      name: 'calligraphyPractice',
      builder: (context, state) =>
          CalligraphyPracticeScreen(wordId: state.pathParameters['wordId']!),
    ),
  ],
);
