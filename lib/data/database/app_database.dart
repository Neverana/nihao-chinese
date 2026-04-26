import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

class Blocks extends Table {
  TextColumn get id => text()();
  IntColumn get order => integer()();
  TextColumn get titleRu => text()();
  TextColumn get titleZh => text()();
  TextColumn get descriptionRu => text()();
  TextColumn get emoji => text()();
  TextColumn get hskLevel => text()();
  TextColumn get blockTextFile => text().withDefault(const Constant(''))();

  @override
  Set<Column> get primaryKey => {id};
}

class Topics extends Table {
  TextColumn get id => text()();
  TextColumn get blockId => text()();
  IntColumn get order => integer()();
  TextColumn get titleRu => text()();
  TextColumn get titleZh => text()();
  TextColumn get descriptionRu => text()();
  TextColumn get situationRu => text()();
  TextColumn get hskLevel => text()();

  @override
  Set<Column> get primaryKey => {id};
}

class Subtopics extends Table {
  TextColumn get id => text()();
  TextColumn get topicId => text()();
  IntColumn get order => integer()();
  TextColumn get titleRu => text()();
  TextColumn get titleZh => text()();
  IntColumn get estimatedMinutes => integer()();
  TextColumn get wordIdsJson => text()();
  TextColumn get grammarIdsJson => text()();
  TextColumn get exercisesJson => text()();

  @override
  Set<Column> get primaryKey => {id};
}

class Words extends Table {
  TextColumn get id => text()();
  TextColumn get hanzi => text()();
  TextColumn get pinyin => text()();
  TextColumn get translationRu => text()();
  TextColumn get exampleZh => text().nullable()();
  TextColumn get examplePinyin => text().nullable()();
  TextColumn get exampleRu => text().nullable()();
  TextColumn get hskLevel => text()();
  TextColumn get audioPath => text().nullable()();
  IntColumn get strokeCount => integer()();
  TextColumn get tagsJson => text()();
  TextColumn get topicId => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class ProgressEntries extends Table {
  TextColumn get entityId => text()();
  TextColumn get entityType => text()();
  TextColumn get status => text()();
  IntColumn get score => integer().withDefault(const Constant(0))();
  DateTimeColumn get completedAt => dateTime().nullable()();
  BoolColumn get finalTestPassed =>
      boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {entityId};
}

class DictionaryEntries extends Table {
  TextColumn get wordId => text()();
  IntColumn get srsLevel => integer().withDefault(const Constant(0))();
  IntColumn get repetitions => integer().withDefault(const Constant(0))();
  IntColumn get intervalDays => integer().withDefault(const Constant(1))();
  RealColumn get easeFactor => real().withDefault(const Constant(2.5))();
  DateTimeColumn get nextReviewAt => dateTime().nullable()();
  DateTimeColumn get lastReviewedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {wordId};
}

class CalligraphyEntries extends Table {
  TextColumn get wordId => text()();
  IntColumn get attempts => integer().withDefault(const Constant(0))();
  IntColumn get bestScore => integer().withDefault(const Constant(0))();
  DateTimeColumn get lastAttemptAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {wordId};
}

@DriftDatabase(
  tables: [
    Blocks,
    Topics,
    Subtopics,
    Words,
    ProgressEntries,
    DictionaryEntries,
    CalligraphyEntries,
  ],
  daos: [
    BlocksDao,
    TopicsDao,
    SubtopicsDao,
    WordsDao,
    ProgressDao,
    DictionaryDao,
    CalligraphyDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async => m.createAll(),
      );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'nihao_chinese.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}

@DriftAccessor(tables: [Blocks])
class BlocksDao extends DatabaseAccessor<AppDatabase> with _$BlocksDaoMixin {
  BlocksDao(super.attachedDatabase);

  Future<List<Block>> getAllBlocks() => select(blocks).get();
}

@DriftAccessor(tables: [Topics])
class TopicsDao extends DatabaseAccessor<AppDatabase> with _$TopicsDaoMixin {
  TopicsDao(super.attachedDatabase);

  Future<List<Topic>> getTopicsForBlock(String blockId) =>
      (select(topics)..where((t) => t.blockId.equals(blockId))).get();
}

@DriftAccessor(tables: [Subtopics])
class SubtopicsDao extends DatabaseAccessor<AppDatabase>
    with _$SubtopicsDaoMixin {
  SubtopicsDao(super.attachedDatabase);
}

@DriftAccessor(tables: [Words])
class WordsDao extends DatabaseAccessor<AppDatabase> with _$WordsDaoMixin {
  WordsDao(super.attachedDatabase);
}

@DriftAccessor(tables: [ProgressEntries])
class ProgressDao extends DatabaseAccessor<AppDatabase>
    with _$ProgressDaoMixin {
  ProgressDao(super.attachedDatabase);

  Future<void> upsertProgress(ProgressEntriesCompanion entry) =>
      into(progressEntries).insertOnConflictUpdate(entry);
}

@DriftAccessor(tables: [DictionaryEntries])
class DictionaryDao extends DatabaseAccessor<AppDatabase>
    with _$DictionaryDaoMixin {
  DictionaryDao(super.attachedDatabase);
}

@DriftAccessor(tables: [CalligraphyEntries])
class CalligraphyDao extends DatabaseAccessor<AppDatabase>
    with _$CalligraphyDaoMixin {
  CalligraphyDao(super.attachedDatabase);
}
