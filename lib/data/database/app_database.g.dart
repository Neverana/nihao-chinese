// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $BlocksTable extends Blocks with TableInfo<$BlocksTable, Block> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BlocksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _orderMeta = const VerificationMeta('order');
  @override
  late final GeneratedColumn<int> order = GeneratedColumn<int>(
      'order', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _titleRuMeta =
      const VerificationMeta('titleRu');
  @override
  late final GeneratedColumn<String> titleRu = GeneratedColumn<String>(
      'title_ru', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleZhMeta =
      const VerificationMeta('titleZh');
  @override
  late final GeneratedColumn<String> titleZh = GeneratedColumn<String>(
      'title_zh', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionRuMeta =
      const VerificationMeta('descriptionRu');
  @override
  late final GeneratedColumn<String> descriptionRu = GeneratedColumn<String>(
      'description_ru', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _emojiMeta = const VerificationMeta('emoji');
  @override
  late final GeneratedColumn<String> emoji = GeneratedColumn<String>(
      'emoji', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _hskLevelMeta =
      const VerificationMeta('hskLevel');
  @override
  late final GeneratedColumn<String> hskLevel = GeneratedColumn<String>(
      'hsk_level', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _blockTextFileMeta =
      const VerificationMeta('blockTextFile');
  @override
  late final GeneratedColumn<String> blockTextFile = GeneratedColumn<String>(
      'block_text_file', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        order,
        titleRu,
        titleZh,
        descriptionRu,
        emoji,
        hskLevel,
        blockTextFile
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'blocks';
  @override
  VerificationContext validateIntegrity(Insertable<Block> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('order')) {
      context.handle(
          _orderMeta, order.isAcceptableOrUnknown(data['order']!, _orderMeta));
    } else if (isInserting) {
      context.missing(_orderMeta);
    }
    if (data.containsKey('title_ru')) {
      context.handle(_titleRuMeta,
          titleRu.isAcceptableOrUnknown(data['title_ru']!, _titleRuMeta));
    } else if (isInserting) {
      context.missing(_titleRuMeta);
    }
    if (data.containsKey('title_zh')) {
      context.handle(_titleZhMeta,
          titleZh.isAcceptableOrUnknown(data['title_zh']!, _titleZhMeta));
    } else if (isInserting) {
      context.missing(_titleZhMeta);
    }
    if (data.containsKey('description_ru')) {
      context.handle(
          _descriptionRuMeta,
          descriptionRu.isAcceptableOrUnknown(
              data['description_ru']!, _descriptionRuMeta));
    } else if (isInserting) {
      context.missing(_descriptionRuMeta);
    }
    if (data.containsKey('emoji')) {
      context.handle(
          _emojiMeta, emoji.isAcceptableOrUnknown(data['emoji']!, _emojiMeta));
    } else if (isInserting) {
      context.missing(_emojiMeta);
    }
    if (data.containsKey('hsk_level')) {
      context.handle(_hskLevelMeta,
          hskLevel.isAcceptableOrUnknown(data['hsk_level']!, _hskLevelMeta));
    } else if (isInserting) {
      context.missing(_hskLevelMeta);
    }
    if (data.containsKey('block_text_file')) {
      context.handle(
          _blockTextFileMeta,
          blockTextFile.isAcceptableOrUnknown(
              data['block_text_file']!, _blockTextFileMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Block map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Block(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      order: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}order'])!,
      titleRu: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title_ru'])!,
      titleZh: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title_zh'])!,
      descriptionRu: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description_ru'])!,
      emoji: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}emoji'])!,
      hskLevel: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}hsk_level'])!,
      blockTextFile: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}block_text_file'])!,
    );
  }

  @override
  $BlocksTable createAlias(String alias) {
    return $BlocksTable(attachedDatabase, alias);
  }
}

class Block extends DataClass implements Insertable<Block> {
  final String id;
  final int order;
  final String titleRu;
  final String titleZh;
  final String descriptionRu;
  final String emoji;
  final String hskLevel;
  final String blockTextFile;
  const Block(
      {required this.id,
      required this.order,
      required this.titleRu,
      required this.titleZh,
      required this.descriptionRu,
      required this.emoji,
      required this.hskLevel,
      required this.blockTextFile});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['order'] = Variable<int>(order);
    map['title_ru'] = Variable<String>(titleRu);
    map['title_zh'] = Variable<String>(titleZh);
    map['description_ru'] = Variable<String>(descriptionRu);
    map['emoji'] = Variable<String>(emoji);
    map['hsk_level'] = Variable<String>(hskLevel);
    map['block_text_file'] = Variable<String>(blockTextFile);
    return map;
  }

  BlocksCompanion toCompanion(bool nullToAbsent) {
    return BlocksCompanion(
      id: Value(id),
      order: Value(order),
      titleRu: Value(titleRu),
      titleZh: Value(titleZh),
      descriptionRu: Value(descriptionRu),
      emoji: Value(emoji),
      hskLevel: Value(hskLevel),
      blockTextFile: Value(blockTextFile),
    );
  }

  factory Block.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Block(
      id: serializer.fromJson<String>(json['id']),
      order: serializer.fromJson<int>(json['order']),
      titleRu: serializer.fromJson<String>(json['titleRu']),
      titleZh: serializer.fromJson<String>(json['titleZh']),
      descriptionRu: serializer.fromJson<String>(json['descriptionRu']),
      emoji: serializer.fromJson<String>(json['emoji']),
      hskLevel: serializer.fromJson<String>(json['hskLevel']),
      blockTextFile: serializer.fromJson<String>(json['blockTextFile']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'order': serializer.toJson<int>(order),
      'titleRu': serializer.toJson<String>(titleRu),
      'titleZh': serializer.toJson<String>(titleZh),
      'descriptionRu': serializer.toJson<String>(descriptionRu),
      'emoji': serializer.toJson<String>(emoji),
      'hskLevel': serializer.toJson<String>(hskLevel),
      'blockTextFile': serializer.toJson<String>(blockTextFile),
    };
  }

  Block copyWith(
          {String? id,
          int? order,
          String? titleRu,
          String? titleZh,
          String? descriptionRu,
          String? emoji,
          String? hskLevel,
          String? blockTextFile}) =>
      Block(
        id: id ?? this.id,
        order: order ?? this.order,
        titleRu: titleRu ?? this.titleRu,
        titleZh: titleZh ?? this.titleZh,
        descriptionRu: descriptionRu ?? this.descriptionRu,
        emoji: emoji ?? this.emoji,
        hskLevel: hskLevel ?? this.hskLevel,
        blockTextFile: blockTextFile ?? this.blockTextFile,
      );
  Block copyWithCompanion(BlocksCompanion data) {
    return Block(
      id: data.id.present ? data.id.value : this.id,
      order: data.order.present ? data.order.value : this.order,
      titleRu: data.titleRu.present ? data.titleRu.value : this.titleRu,
      titleZh: data.titleZh.present ? data.titleZh.value : this.titleZh,
      descriptionRu: data.descriptionRu.present
          ? data.descriptionRu.value
          : this.descriptionRu,
      emoji: data.emoji.present ? data.emoji.value : this.emoji,
      hskLevel: data.hskLevel.present ? data.hskLevel.value : this.hskLevel,
      blockTextFile: data.blockTextFile.present
          ? data.blockTextFile.value
          : this.blockTextFile,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Block(')
          ..write('id: $id, ')
          ..write('order: $order, ')
          ..write('titleRu: $titleRu, ')
          ..write('titleZh: $titleZh, ')
          ..write('descriptionRu: $descriptionRu, ')
          ..write('emoji: $emoji, ')
          ..write('hskLevel: $hskLevel, ')
          ..write('blockTextFile: $blockTextFile')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, order, titleRu, titleZh, descriptionRu,
      emoji, hskLevel, blockTextFile);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Block &&
          other.id == this.id &&
          other.order == this.order &&
          other.titleRu == this.titleRu &&
          other.titleZh == this.titleZh &&
          other.descriptionRu == this.descriptionRu &&
          other.emoji == this.emoji &&
          other.hskLevel == this.hskLevel &&
          other.blockTextFile == this.blockTextFile);
}

class BlocksCompanion extends UpdateCompanion<Block> {
  final Value<String> id;
  final Value<int> order;
  final Value<String> titleRu;
  final Value<String> titleZh;
  final Value<String> descriptionRu;
  final Value<String> emoji;
  final Value<String> hskLevel;
  final Value<String> blockTextFile;
  final Value<int> rowid;
  const BlocksCompanion({
    this.id = const Value.absent(),
    this.order = const Value.absent(),
    this.titleRu = const Value.absent(),
    this.titleZh = const Value.absent(),
    this.descriptionRu = const Value.absent(),
    this.emoji = const Value.absent(),
    this.hskLevel = const Value.absent(),
    this.blockTextFile = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BlocksCompanion.insert({
    required String id,
    required int order,
    required String titleRu,
    required String titleZh,
    required String descriptionRu,
    required String emoji,
    required String hskLevel,
    this.blockTextFile = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        order = Value(order),
        titleRu = Value(titleRu),
        titleZh = Value(titleZh),
        descriptionRu = Value(descriptionRu),
        emoji = Value(emoji),
        hskLevel = Value(hskLevel);
  static Insertable<Block> custom({
    Expression<String>? id,
    Expression<int>? order,
    Expression<String>? titleRu,
    Expression<String>? titleZh,
    Expression<String>? descriptionRu,
    Expression<String>? emoji,
    Expression<String>? hskLevel,
    Expression<String>? blockTextFile,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (order != null) 'order': order,
      if (titleRu != null) 'title_ru': titleRu,
      if (titleZh != null) 'title_zh': titleZh,
      if (descriptionRu != null) 'description_ru': descriptionRu,
      if (emoji != null) 'emoji': emoji,
      if (hskLevel != null) 'hsk_level': hskLevel,
      if (blockTextFile != null) 'block_text_file': blockTextFile,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BlocksCompanion copyWith(
      {Value<String>? id,
      Value<int>? order,
      Value<String>? titleRu,
      Value<String>? titleZh,
      Value<String>? descriptionRu,
      Value<String>? emoji,
      Value<String>? hskLevel,
      Value<String>? blockTextFile,
      Value<int>? rowid}) {
    return BlocksCompanion(
      id: id ?? this.id,
      order: order ?? this.order,
      titleRu: titleRu ?? this.titleRu,
      titleZh: titleZh ?? this.titleZh,
      descriptionRu: descriptionRu ?? this.descriptionRu,
      emoji: emoji ?? this.emoji,
      hskLevel: hskLevel ?? this.hskLevel,
      blockTextFile: blockTextFile ?? this.blockTextFile,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (order.present) {
      map['order'] = Variable<int>(order.value);
    }
    if (titleRu.present) {
      map['title_ru'] = Variable<String>(titleRu.value);
    }
    if (titleZh.present) {
      map['title_zh'] = Variable<String>(titleZh.value);
    }
    if (descriptionRu.present) {
      map['description_ru'] = Variable<String>(descriptionRu.value);
    }
    if (emoji.present) {
      map['emoji'] = Variable<String>(emoji.value);
    }
    if (hskLevel.present) {
      map['hsk_level'] = Variable<String>(hskLevel.value);
    }
    if (blockTextFile.present) {
      map['block_text_file'] = Variable<String>(blockTextFile.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BlocksCompanion(')
          ..write('id: $id, ')
          ..write('order: $order, ')
          ..write('titleRu: $titleRu, ')
          ..write('titleZh: $titleZh, ')
          ..write('descriptionRu: $descriptionRu, ')
          ..write('emoji: $emoji, ')
          ..write('hskLevel: $hskLevel, ')
          ..write('blockTextFile: $blockTextFile, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TopicsTable extends Topics with TableInfo<$TopicsTable, Topic> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TopicsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _blockIdMeta =
      const VerificationMeta('blockId');
  @override
  late final GeneratedColumn<String> blockId = GeneratedColumn<String>(
      'block_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _orderMeta = const VerificationMeta('order');
  @override
  late final GeneratedColumn<int> order = GeneratedColumn<int>(
      'order', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _titleRuMeta =
      const VerificationMeta('titleRu');
  @override
  late final GeneratedColumn<String> titleRu = GeneratedColumn<String>(
      'title_ru', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleZhMeta =
      const VerificationMeta('titleZh');
  @override
  late final GeneratedColumn<String> titleZh = GeneratedColumn<String>(
      'title_zh', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionRuMeta =
      const VerificationMeta('descriptionRu');
  @override
  late final GeneratedColumn<String> descriptionRu = GeneratedColumn<String>(
      'description_ru', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _situationRuMeta =
      const VerificationMeta('situationRu');
  @override
  late final GeneratedColumn<String> situationRu = GeneratedColumn<String>(
      'situation_ru', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _hskLevelMeta =
      const VerificationMeta('hskLevel');
  @override
  late final GeneratedColumn<String> hskLevel = GeneratedColumn<String>(
      'hsk_level', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        blockId,
        order,
        titleRu,
        titleZh,
        descriptionRu,
        situationRu,
        hskLevel
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'topics';
  @override
  VerificationContext validateIntegrity(Insertable<Topic> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('block_id')) {
      context.handle(_blockIdMeta,
          blockId.isAcceptableOrUnknown(data['block_id']!, _blockIdMeta));
    } else if (isInserting) {
      context.missing(_blockIdMeta);
    }
    if (data.containsKey('order')) {
      context.handle(
          _orderMeta, order.isAcceptableOrUnknown(data['order']!, _orderMeta));
    } else if (isInserting) {
      context.missing(_orderMeta);
    }
    if (data.containsKey('title_ru')) {
      context.handle(_titleRuMeta,
          titleRu.isAcceptableOrUnknown(data['title_ru']!, _titleRuMeta));
    } else if (isInserting) {
      context.missing(_titleRuMeta);
    }
    if (data.containsKey('title_zh')) {
      context.handle(_titleZhMeta,
          titleZh.isAcceptableOrUnknown(data['title_zh']!, _titleZhMeta));
    } else if (isInserting) {
      context.missing(_titleZhMeta);
    }
    if (data.containsKey('description_ru')) {
      context.handle(
          _descriptionRuMeta,
          descriptionRu.isAcceptableOrUnknown(
              data['description_ru']!, _descriptionRuMeta));
    } else if (isInserting) {
      context.missing(_descriptionRuMeta);
    }
    if (data.containsKey('situation_ru')) {
      context.handle(
          _situationRuMeta,
          situationRu.isAcceptableOrUnknown(
              data['situation_ru']!, _situationRuMeta));
    } else if (isInserting) {
      context.missing(_situationRuMeta);
    }
    if (data.containsKey('hsk_level')) {
      context.handle(_hskLevelMeta,
          hskLevel.isAcceptableOrUnknown(data['hsk_level']!, _hskLevelMeta));
    } else if (isInserting) {
      context.missing(_hskLevelMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Topic map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Topic(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      blockId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}block_id'])!,
      order: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}order'])!,
      titleRu: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title_ru'])!,
      titleZh: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title_zh'])!,
      descriptionRu: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description_ru'])!,
      situationRu: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}situation_ru'])!,
      hskLevel: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}hsk_level'])!,
    );
  }

  @override
  $TopicsTable createAlias(String alias) {
    return $TopicsTable(attachedDatabase, alias);
  }
}

class Topic extends DataClass implements Insertable<Topic> {
  final String id;
  final String blockId;
  final int order;
  final String titleRu;
  final String titleZh;
  final String descriptionRu;
  final String situationRu;
  final String hskLevel;
  const Topic(
      {required this.id,
      required this.blockId,
      required this.order,
      required this.titleRu,
      required this.titleZh,
      required this.descriptionRu,
      required this.situationRu,
      required this.hskLevel});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['block_id'] = Variable<String>(blockId);
    map['order'] = Variable<int>(order);
    map['title_ru'] = Variable<String>(titleRu);
    map['title_zh'] = Variable<String>(titleZh);
    map['description_ru'] = Variable<String>(descriptionRu);
    map['situation_ru'] = Variable<String>(situationRu);
    map['hsk_level'] = Variable<String>(hskLevel);
    return map;
  }

  TopicsCompanion toCompanion(bool nullToAbsent) {
    return TopicsCompanion(
      id: Value(id),
      blockId: Value(blockId),
      order: Value(order),
      titleRu: Value(titleRu),
      titleZh: Value(titleZh),
      descriptionRu: Value(descriptionRu),
      situationRu: Value(situationRu),
      hskLevel: Value(hskLevel),
    );
  }

  factory Topic.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Topic(
      id: serializer.fromJson<String>(json['id']),
      blockId: serializer.fromJson<String>(json['blockId']),
      order: serializer.fromJson<int>(json['order']),
      titleRu: serializer.fromJson<String>(json['titleRu']),
      titleZh: serializer.fromJson<String>(json['titleZh']),
      descriptionRu: serializer.fromJson<String>(json['descriptionRu']),
      situationRu: serializer.fromJson<String>(json['situationRu']),
      hskLevel: serializer.fromJson<String>(json['hskLevel']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'blockId': serializer.toJson<String>(blockId),
      'order': serializer.toJson<int>(order),
      'titleRu': serializer.toJson<String>(titleRu),
      'titleZh': serializer.toJson<String>(titleZh),
      'descriptionRu': serializer.toJson<String>(descriptionRu),
      'situationRu': serializer.toJson<String>(situationRu),
      'hskLevel': serializer.toJson<String>(hskLevel),
    };
  }

  Topic copyWith(
          {String? id,
          String? blockId,
          int? order,
          String? titleRu,
          String? titleZh,
          String? descriptionRu,
          String? situationRu,
          String? hskLevel}) =>
      Topic(
        id: id ?? this.id,
        blockId: blockId ?? this.blockId,
        order: order ?? this.order,
        titleRu: titleRu ?? this.titleRu,
        titleZh: titleZh ?? this.titleZh,
        descriptionRu: descriptionRu ?? this.descriptionRu,
        situationRu: situationRu ?? this.situationRu,
        hskLevel: hskLevel ?? this.hskLevel,
      );
  Topic copyWithCompanion(TopicsCompanion data) {
    return Topic(
      id: data.id.present ? data.id.value : this.id,
      blockId: data.blockId.present ? data.blockId.value : this.blockId,
      order: data.order.present ? data.order.value : this.order,
      titleRu: data.titleRu.present ? data.titleRu.value : this.titleRu,
      titleZh: data.titleZh.present ? data.titleZh.value : this.titleZh,
      descriptionRu: data.descriptionRu.present
          ? data.descriptionRu.value
          : this.descriptionRu,
      situationRu:
          data.situationRu.present ? data.situationRu.value : this.situationRu,
      hskLevel: data.hskLevel.present ? data.hskLevel.value : this.hskLevel,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Topic(')
          ..write('id: $id, ')
          ..write('blockId: $blockId, ')
          ..write('order: $order, ')
          ..write('titleRu: $titleRu, ')
          ..write('titleZh: $titleZh, ')
          ..write('descriptionRu: $descriptionRu, ')
          ..write('situationRu: $situationRu, ')
          ..write('hskLevel: $hskLevel')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, blockId, order, titleRu, titleZh,
      descriptionRu, situationRu, hskLevel);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Topic &&
          other.id == this.id &&
          other.blockId == this.blockId &&
          other.order == this.order &&
          other.titleRu == this.titleRu &&
          other.titleZh == this.titleZh &&
          other.descriptionRu == this.descriptionRu &&
          other.situationRu == this.situationRu &&
          other.hskLevel == this.hskLevel);
}

class TopicsCompanion extends UpdateCompanion<Topic> {
  final Value<String> id;
  final Value<String> blockId;
  final Value<int> order;
  final Value<String> titleRu;
  final Value<String> titleZh;
  final Value<String> descriptionRu;
  final Value<String> situationRu;
  final Value<String> hskLevel;
  final Value<int> rowid;
  const TopicsCompanion({
    this.id = const Value.absent(),
    this.blockId = const Value.absent(),
    this.order = const Value.absent(),
    this.titleRu = const Value.absent(),
    this.titleZh = const Value.absent(),
    this.descriptionRu = const Value.absent(),
    this.situationRu = const Value.absent(),
    this.hskLevel = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TopicsCompanion.insert({
    required String id,
    required String blockId,
    required int order,
    required String titleRu,
    required String titleZh,
    required String descriptionRu,
    required String situationRu,
    required String hskLevel,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        blockId = Value(blockId),
        order = Value(order),
        titleRu = Value(titleRu),
        titleZh = Value(titleZh),
        descriptionRu = Value(descriptionRu),
        situationRu = Value(situationRu),
        hskLevel = Value(hskLevel);
  static Insertable<Topic> custom({
    Expression<String>? id,
    Expression<String>? blockId,
    Expression<int>? order,
    Expression<String>? titleRu,
    Expression<String>? titleZh,
    Expression<String>? descriptionRu,
    Expression<String>? situationRu,
    Expression<String>? hskLevel,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (blockId != null) 'block_id': blockId,
      if (order != null) 'order': order,
      if (titleRu != null) 'title_ru': titleRu,
      if (titleZh != null) 'title_zh': titleZh,
      if (descriptionRu != null) 'description_ru': descriptionRu,
      if (situationRu != null) 'situation_ru': situationRu,
      if (hskLevel != null) 'hsk_level': hskLevel,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TopicsCompanion copyWith(
      {Value<String>? id,
      Value<String>? blockId,
      Value<int>? order,
      Value<String>? titleRu,
      Value<String>? titleZh,
      Value<String>? descriptionRu,
      Value<String>? situationRu,
      Value<String>? hskLevel,
      Value<int>? rowid}) {
    return TopicsCompanion(
      id: id ?? this.id,
      blockId: blockId ?? this.blockId,
      order: order ?? this.order,
      titleRu: titleRu ?? this.titleRu,
      titleZh: titleZh ?? this.titleZh,
      descriptionRu: descriptionRu ?? this.descriptionRu,
      situationRu: situationRu ?? this.situationRu,
      hskLevel: hskLevel ?? this.hskLevel,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (blockId.present) {
      map['block_id'] = Variable<String>(blockId.value);
    }
    if (order.present) {
      map['order'] = Variable<int>(order.value);
    }
    if (titleRu.present) {
      map['title_ru'] = Variable<String>(titleRu.value);
    }
    if (titleZh.present) {
      map['title_zh'] = Variable<String>(titleZh.value);
    }
    if (descriptionRu.present) {
      map['description_ru'] = Variable<String>(descriptionRu.value);
    }
    if (situationRu.present) {
      map['situation_ru'] = Variable<String>(situationRu.value);
    }
    if (hskLevel.present) {
      map['hsk_level'] = Variable<String>(hskLevel.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TopicsCompanion(')
          ..write('id: $id, ')
          ..write('blockId: $blockId, ')
          ..write('order: $order, ')
          ..write('titleRu: $titleRu, ')
          ..write('titleZh: $titleZh, ')
          ..write('descriptionRu: $descriptionRu, ')
          ..write('situationRu: $situationRu, ')
          ..write('hskLevel: $hskLevel, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SubtopicsTable extends Subtopics
    with TableInfo<$SubtopicsTable, Subtopic> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SubtopicsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _topicIdMeta =
      const VerificationMeta('topicId');
  @override
  late final GeneratedColumn<String> topicId = GeneratedColumn<String>(
      'topic_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _orderMeta = const VerificationMeta('order');
  @override
  late final GeneratedColumn<int> order = GeneratedColumn<int>(
      'order', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _titleRuMeta =
      const VerificationMeta('titleRu');
  @override
  late final GeneratedColumn<String> titleRu = GeneratedColumn<String>(
      'title_ru', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleZhMeta =
      const VerificationMeta('titleZh');
  @override
  late final GeneratedColumn<String> titleZh = GeneratedColumn<String>(
      'title_zh', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _estimatedMinutesMeta =
      const VerificationMeta('estimatedMinutes');
  @override
  late final GeneratedColumn<int> estimatedMinutes = GeneratedColumn<int>(
      'estimated_minutes', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _wordIdsJsonMeta =
      const VerificationMeta('wordIdsJson');
  @override
  late final GeneratedColumn<String> wordIdsJson = GeneratedColumn<String>(
      'word_ids_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _grammarIdsJsonMeta =
      const VerificationMeta('grammarIdsJson');
  @override
  late final GeneratedColumn<String> grammarIdsJson = GeneratedColumn<String>(
      'grammar_ids_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _exercisesJsonMeta =
      const VerificationMeta('exercisesJson');
  @override
  late final GeneratedColumn<String> exercisesJson = GeneratedColumn<String>(
      'exercises_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        topicId,
        order,
        titleRu,
        titleZh,
        estimatedMinutes,
        wordIdsJson,
        grammarIdsJson,
        exercisesJson
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'subtopics';
  @override
  VerificationContext validateIntegrity(Insertable<Subtopic> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('topic_id')) {
      context.handle(_topicIdMeta,
          topicId.isAcceptableOrUnknown(data['topic_id']!, _topicIdMeta));
    } else if (isInserting) {
      context.missing(_topicIdMeta);
    }
    if (data.containsKey('order')) {
      context.handle(
          _orderMeta, order.isAcceptableOrUnknown(data['order']!, _orderMeta));
    } else if (isInserting) {
      context.missing(_orderMeta);
    }
    if (data.containsKey('title_ru')) {
      context.handle(_titleRuMeta,
          titleRu.isAcceptableOrUnknown(data['title_ru']!, _titleRuMeta));
    } else if (isInserting) {
      context.missing(_titleRuMeta);
    }
    if (data.containsKey('title_zh')) {
      context.handle(_titleZhMeta,
          titleZh.isAcceptableOrUnknown(data['title_zh']!, _titleZhMeta));
    } else if (isInserting) {
      context.missing(_titleZhMeta);
    }
    if (data.containsKey('estimated_minutes')) {
      context.handle(
          _estimatedMinutesMeta,
          estimatedMinutes.isAcceptableOrUnknown(
              data['estimated_minutes']!, _estimatedMinutesMeta));
    } else if (isInserting) {
      context.missing(_estimatedMinutesMeta);
    }
    if (data.containsKey('word_ids_json')) {
      context.handle(
          _wordIdsJsonMeta,
          wordIdsJson.isAcceptableOrUnknown(
              data['word_ids_json']!, _wordIdsJsonMeta));
    } else if (isInserting) {
      context.missing(_wordIdsJsonMeta);
    }
    if (data.containsKey('grammar_ids_json')) {
      context.handle(
          _grammarIdsJsonMeta,
          grammarIdsJson.isAcceptableOrUnknown(
              data['grammar_ids_json']!, _grammarIdsJsonMeta));
    } else if (isInserting) {
      context.missing(_grammarIdsJsonMeta);
    }
    if (data.containsKey('exercises_json')) {
      context.handle(
          _exercisesJsonMeta,
          exercisesJson.isAcceptableOrUnknown(
              data['exercises_json']!, _exercisesJsonMeta));
    } else if (isInserting) {
      context.missing(_exercisesJsonMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Subtopic map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Subtopic(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      topicId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}topic_id'])!,
      order: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}order'])!,
      titleRu: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title_ru'])!,
      titleZh: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title_zh'])!,
      estimatedMinutes: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}estimated_minutes'])!,
      wordIdsJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}word_ids_json'])!,
      grammarIdsJson: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}grammar_ids_json'])!,
      exercisesJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}exercises_json'])!,
    );
  }

  @override
  $SubtopicsTable createAlias(String alias) {
    return $SubtopicsTable(attachedDatabase, alias);
  }
}

class Subtopic extends DataClass implements Insertable<Subtopic> {
  final String id;
  final String topicId;
  final int order;
  final String titleRu;
  final String titleZh;
  final int estimatedMinutes;
  final String wordIdsJson;
  final String grammarIdsJson;
  final String exercisesJson;
  const Subtopic(
      {required this.id,
      required this.topicId,
      required this.order,
      required this.titleRu,
      required this.titleZh,
      required this.estimatedMinutes,
      required this.wordIdsJson,
      required this.grammarIdsJson,
      required this.exercisesJson});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['topic_id'] = Variable<String>(topicId);
    map['order'] = Variable<int>(order);
    map['title_ru'] = Variable<String>(titleRu);
    map['title_zh'] = Variable<String>(titleZh);
    map['estimated_minutes'] = Variable<int>(estimatedMinutes);
    map['word_ids_json'] = Variable<String>(wordIdsJson);
    map['grammar_ids_json'] = Variable<String>(grammarIdsJson);
    map['exercises_json'] = Variable<String>(exercisesJson);
    return map;
  }

  SubtopicsCompanion toCompanion(bool nullToAbsent) {
    return SubtopicsCompanion(
      id: Value(id),
      topicId: Value(topicId),
      order: Value(order),
      titleRu: Value(titleRu),
      titleZh: Value(titleZh),
      estimatedMinutes: Value(estimatedMinutes),
      wordIdsJson: Value(wordIdsJson),
      grammarIdsJson: Value(grammarIdsJson),
      exercisesJson: Value(exercisesJson),
    );
  }

  factory Subtopic.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Subtopic(
      id: serializer.fromJson<String>(json['id']),
      topicId: serializer.fromJson<String>(json['topicId']),
      order: serializer.fromJson<int>(json['order']),
      titleRu: serializer.fromJson<String>(json['titleRu']),
      titleZh: serializer.fromJson<String>(json['titleZh']),
      estimatedMinutes: serializer.fromJson<int>(json['estimatedMinutes']),
      wordIdsJson: serializer.fromJson<String>(json['wordIdsJson']),
      grammarIdsJson: serializer.fromJson<String>(json['grammarIdsJson']),
      exercisesJson: serializer.fromJson<String>(json['exercisesJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'topicId': serializer.toJson<String>(topicId),
      'order': serializer.toJson<int>(order),
      'titleRu': serializer.toJson<String>(titleRu),
      'titleZh': serializer.toJson<String>(titleZh),
      'estimatedMinutes': serializer.toJson<int>(estimatedMinutes),
      'wordIdsJson': serializer.toJson<String>(wordIdsJson),
      'grammarIdsJson': serializer.toJson<String>(grammarIdsJson),
      'exercisesJson': serializer.toJson<String>(exercisesJson),
    };
  }

  Subtopic copyWith(
          {String? id,
          String? topicId,
          int? order,
          String? titleRu,
          String? titleZh,
          int? estimatedMinutes,
          String? wordIdsJson,
          String? grammarIdsJson,
          String? exercisesJson}) =>
      Subtopic(
        id: id ?? this.id,
        topicId: topicId ?? this.topicId,
        order: order ?? this.order,
        titleRu: titleRu ?? this.titleRu,
        titleZh: titleZh ?? this.titleZh,
        estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
        wordIdsJson: wordIdsJson ?? this.wordIdsJson,
        grammarIdsJson: grammarIdsJson ?? this.grammarIdsJson,
        exercisesJson: exercisesJson ?? this.exercisesJson,
      );
  Subtopic copyWithCompanion(SubtopicsCompanion data) {
    return Subtopic(
      id: data.id.present ? data.id.value : this.id,
      topicId: data.topicId.present ? data.topicId.value : this.topicId,
      order: data.order.present ? data.order.value : this.order,
      titleRu: data.titleRu.present ? data.titleRu.value : this.titleRu,
      titleZh: data.titleZh.present ? data.titleZh.value : this.titleZh,
      estimatedMinutes: data.estimatedMinutes.present
          ? data.estimatedMinutes.value
          : this.estimatedMinutes,
      wordIdsJson:
          data.wordIdsJson.present ? data.wordIdsJson.value : this.wordIdsJson,
      grammarIdsJson: data.grammarIdsJson.present
          ? data.grammarIdsJson.value
          : this.grammarIdsJson,
      exercisesJson: data.exercisesJson.present
          ? data.exercisesJson.value
          : this.exercisesJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Subtopic(')
          ..write('id: $id, ')
          ..write('topicId: $topicId, ')
          ..write('order: $order, ')
          ..write('titleRu: $titleRu, ')
          ..write('titleZh: $titleZh, ')
          ..write('estimatedMinutes: $estimatedMinutes, ')
          ..write('wordIdsJson: $wordIdsJson, ')
          ..write('grammarIdsJson: $grammarIdsJson, ')
          ..write('exercisesJson: $exercisesJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, topicId, order, titleRu, titleZh,
      estimatedMinutes, wordIdsJson, grammarIdsJson, exercisesJson);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Subtopic &&
          other.id == this.id &&
          other.topicId == this.topicId &&
          other.order == this.order &&
          other.titleRu == this.titleRu &&
          other.titleZh == this.titleZh &&
          other.estimatedMinutes == this.estimatedMinutes &&
          other.wordIdsJson == this.wordIdsJson &&
          other.grammarIdsJson == this.grammarIdsJson &&
          other.exercisesJson == this.exercisesJson);
}

class SubtopicsCompanion extends UpdateCompanion<Subtopic> {
  final Value<String> id;
  final Value<String> topicId;
  final Value<int> order;
  final Value<String> titleRu;
  final Value<String> titleZh;
  final Value<int> estimatedMinutes;
  final Value<String> wordIdsJson;
  final Value<String> grammarIdsJson;
  final Value<String> exercisesJson;
  final Value<int> rowid;
  const SubtopicsCompanion({
    this.id = const Value.absent(),
    this.topicId = const Value.absent(),
    this.order = const Value.absent(),
    this.titleRu = const Value.absent(),
    this.titleZh = const Value.absent(),
    this.estimatedMinutes = const Value.absent(),
    this.wordIdsJson = const Value.absent(),
    this.grammarIdsJson = const Value.absent(),
    this.exercisesJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SubtopicsCompanion.insert({
    required String id,
    required String topicId,
    required int order,
    required String titleRu,
    required String titleZh,
    required int estimatedMinutes,
    required String wordIdsJson,
    required String grammarIdsJson,
    required String exercisesJson,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        topicId = Value(topicId),
        order = Value(order),
        titleRu = Value(titleRu),
        titleZh = Value(titleZh),
        estimatedMinutes = Value(estimatedMinutes),
        wordIdsJson = Value(wordIdsJson),
        grammarIdsJson = Value(grammarIdsJson),
        exercisesJson = Value(exercisesJson);
  static Insertable<Subtopic> custom({
    Expression<String>? id,
    Expression<String>? topicId,
    Expression<int>? order,
    Expression<String>? titleRu,
    Expression<String>? titleZh,
    Expression<int>? estimatedMinutes,
    Expression<String>? wordIdsJson,
    Expression<String>? grammarIdsJson,
    Expression<String>? exercisesJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (topicId != null) 'topic_id': topicId,
      if (order != null) 'order': order,
      if (titleRu != null) 'title_ru': titleRu,
      if (titleZh != null) 'title_zh': titleZh,
      if (estimatedMinutes != null) 'estimated_minutes': estimatedMinutes,
      if (wordIdsJson != null) 'word_ids_json': wordIdsJson,
      if (grammarIdsJson != null) 'grammar_ids_json': grammarIdsJson,
      if (exercisesJson != null) 'exercises_json': exercisesJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SubtopicsCompanion copyWith(
      {Value<String>? id,
      Value<String>? topicId,
      Value<int>? order,
      Value<String>? titleRu,
      Value<String>? titleZh,
      Value<int>? estimatedMinutes,
      Value<String>? wordIdsJson,
      Value<String>? grammarIdsJson,
      Value<String>? exercisesJson,
      Value<int>? rowid}) {
    return SubtopicsCompanion(
      id: id ?? this.id,
      topicId: topicId ?? this.topicId,
      order: order ?? this.order,
      titleRu: titleRu ?? this.titleRu,
      titleZh: titleZh ?? this.titleZh,
      estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
      wordIdsJson: wordIdsJson ?? this.wordIdsJson,
      grammarIdsJson: grammarIdsJson ?? this.grammarIdsJson,
      exercisesJson: exercisesJson ?? this.exercisesJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (topicId.present) {
      map['topic_id'] = Variable<String>(topicId.value);
    }
    if (order.present) {
      map['order'] = Variable<int>(order.value);
    }
    if (titleRu.present) {
      map['title_ru'] = Variable<String>(titleRu.value);
    }
    if (titleZh.present) {
      map['title_zh'] = Variable<String>(titleZh.value);
    }
    if (estimatedMinutes.present) {
      map['estimated_minutes'] = Variable<int>(estimatedMinutes.value);
    }
    if (wordIdsJson.present) {
      map['word_ids_json'] = Variable<String>(wordIdsJson.value);
    }
    if (grammarIdsJson.present) {
      map['grammar_ids_json'] = Variable<String>(grammarIdsJson.value);
    }
    if (exercisesJson.present) {
      map['exercises_json'] = Variable<String>(exercisesJson.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SubtopicsCompanion(')
          ..write('id: $id, ')
          ..write('topicId: $topicId, ')
          ..write('order: $order, ')
          ..write('titleRu: $titleRu, ')
          ..write('titleZh: $titleZh, ')
          ..write('estimatedMinutes: $estimatedMinutes, ')
          ..write('wordIdsJson: $wordIdsJson, ')
          ..write('grammarIdsJson: $grammarIdsJson, ')
          ..write('exercisesJson: $exercisesJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WordsTable extends Words with TableInfo<$WordsTable, Word> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _hanziMeta = const VerificationMeta('hanzi');
  @override
  late final GeneratedColumn<String> hanzi = GeneratedColumn<String>(
      'hanzi', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _pinyinMeta = const VerificationMeta('pinyin');
  @override
  late final GeneratedColumn<String> pinyin = GeneratedColumn<String>(
      'pinyin', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _translationRuMeta =
      const VerificationMeta('translationRu');
  @override
  late final GeneratedColumn<String> translationRu = GeneratedColumn<String>(
      'translation_ru', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _exampleZhMeta =
      const VerificationMeta('exampleZh');
  @override
  late final GeneratedColumn<String> exampleZh = GeneratedColumn<String>(
      'example_zh', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _examplePinyinMeta =
      const VerificationMeta('examplePinyin');
  @override
  late final GeneratedColumn<String> examplePinyin = GeneratedColumn<String>(
      'example_pinyin', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _exampleRuMeta =
      const VerificationMeta('exampleRu');
  @override
  late final GeneratedColumn<String> exampleRu = GeneratedColumn<String>(
      'example_ru', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _hskLevelMeta =
      const VerificationMeta('hskLevel');
  @override
  late final GeneratedColumn<String> hskLevel = GeneratedColumn<String>(
      'hsk_level', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _audioPathMeta =
      const VerificationMeta('audioPath');
  @override
  late final GeneratedColumn<String> audioPath = GeneratedColumn<String>(
      'audio_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _strokeCountMeta =
      const VerificationMeta('strokeCount');
  @override
  late final GeneratedColumn<int> strokeCount = GeneratedColumn<int>(
      'stroke_count', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _tagsJsonMeta =
      const VerificationMeta('tagsJson');
  @override
  late final GeneratedColumn<String> tagsJson = GeneratedColumn<String>(
      'tags_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _topicIdMeta =
      const VerificationMeta('topicId');
  @override
  late final GeneratedColumn<String> topicId = GeneratedColumn<String>(
      'topic_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        hanzi,
        pinyin,
        translationRu,
        exampleZh,
        examplePinyin,
        exampleRu,
        hskLevel,
        audioPath,
        strokeCount,
        tagsJson,
        topicId
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'words';
  @override
  VerificationContext validateIntegrity(Insertable<Word> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('hanzi')) {
      context.handle(
          _hanziMeta, hanzi.isAcceptableOrUnknown(data['hanzi']!, _hanziMeta));
    } else if (isInserting) {
      context.missing(_hanziMeta);
    }
    if (data.containsKey('pinyin')) {
      context.handle(_pinyinMeta,
          pinyin.isAcceptableOrUnknown(data['pinyin']!, _pinyinMeta));
    } else if (isInserting) {
      context.missing(_pinyinMeta);
    }
    if (data.containsKey('translation_ru')) {
      context.handle(
          _translationRuMeta,
          translationRu.isAcceptableOrUnknown(
              data['translation_ru']!, _translationRuMeta));
    } else if (isInserting) {
      context.missing(_translationRuMeta);
    }
    if (data.containsKey('example_zh')) {
      context.handle(_exampleZhMeta,
          exampleZh.isAcceptableOrUnknown(data['example_zh']!, _exampleZhMeta));
    }
    if (data.containsKey('example_pinyin')) {
      context.handle(
          _examplePinyinMeta,
          examplePinyin.isAcceptableOrUnknown(
              data['example_pinyin']!, _examplePinyinMeta));
    }
    if (data.containsKey('example_ru')) {
      context.handle(_exampleRuMeta,
          exampleRu.isAcceptableOrUnknown(data['example_ru']!, _exampleRuMeta));
    }
    if (data.containsKey('hsk_level')) {
      context.handle(_hskLevelMeta,
          hskLevel.isAcceptableOrUnknown(data['hsk_level']!, _hskLevelMeta));
    } else if (isInserting) {
      context.missing(_hskLevelMeta);
    }
    if (data.containsKey('audio_path')) {
      context.handle(_audioPathMeta,
          audioPath.isAcceptableOrUnknown(data['audio_path']!, _audioPathMeta));
    }
    if (data.containsKey('stroke_count')) {
      context.handle(
          _strokeCountMeta,
          strokeCount.isAcceptableOrUnknown(
              data['stroke_count']!, _strokeCountMeta));
    } else if (isInserting) {
      context.missing(_strokeCountMeta);
    }
    if (data.containsKey('tags_json')) {
      context.handle(_tagsJsonMeta,
          tagsJson.isAcceptableOrUnknown(data['tags_json']!, _tagsJsonMeta));
    } else if (isInserting) {
      context.missing(_tagsJsonMeta);
    }
    if (data.containsKey('topic_id')) {
      context.handle(_topicIdMeta,
          topicId.isAcceptableOrUnknown(data['topic_id']!, _topicIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Word map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Word(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      hanzi: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}hanzi'])!,
      pinyin: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}pinyin'])!,
      translationRu: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}translation_ru'])!,
      exampleZh: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}example_zh']),
      examplePinyin: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}example_pinyin']),
      exampleRu: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}example_ru']),
      hskLevel: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}hsk_level'])!,
      audioPath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}audio_path']),
      strokeCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}stroke_count'])!,
      tagsJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tags_json'])!,
      topicId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}topic_id']),
    );
  }

  @override
  $WordsTable createAlias(String alias) {
    return $WordsTable(attachedDatabase, alias);
  }
}

class Word extends DataClass implements Insertable<Word> {
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
  final String tagsJson;
  final String? topicId;
  const Word(
      {required this.id,
      required this.hanzi,
      required this.pinyin,
      required this.translationRu,
      this.exampleZh,
      this.examplePinyin,
      this.exampleRu,
      required this.hskLevel,
      this.audioPath,
      required this.strokeCount,
      required this.tagsJson,
      this.topicId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['hanzi'] = Variable<String>(hanzi);
    map['pinyin'] = Variable<String>(pinyin);
    map['translation_ru'] = Variable<String>(translationRu);
    if (!nullToAbsent || exampleZh != null) {
      map['example_zh'] = Variable<String>(exampleZh);
    }
    if (!nullToAbsent || examplePinyin != null) {
      map['example_pinyin'] = Variable<String>(examplePinyin);
    }
    if (!nullToAbsent || exampleRu != null) {
      map['example_ru'] = Variable<String>(exampleRu);
    }
    map['hsk_level'] = Variable<String>(hskLevel);
    if (!nullToAbsent || audioPath != null) {
      map['audio_path'] = Variable<String>(audioPath);
    }
    map['stroke_count'] = Variable<int>(strokeCount);
    map['tags_json'] = Variable<String>(tagsJson);
    if (!nullToAbsent || topicId != null) {
      map['topic_id'] = Variable<String>(topicId);
    }
    return map;
  }

  WordsCompanion toCompanion(bool nullToAbsent) {
    return WordsCompanion(
      id: Value(id),
      hanzi: Value(hanzi),
      pinyin: Value(pinyin),
      translationRu: Value(translationRu),
      exampleZh: exampleZh == null && nullToAbsent
          ? const Value.absent()
          : Value(exampleZh),
      examplePinyin: examplePinyin == null && nullToAbsent
          ? const Value.absent()
          : Value(examplePinyin),
      exampleRu: exampleRu == null && nullToAbsent
          ? const Value.absent()
          : Value(exampleRu),
      hskLevel: Value(hskLevel),
      audioPath: audioPath == null && nullToAbsent
          ? const Value.absent()
          : Value(audioPath),
      strokeCount: Value(strokeCount),
      tagsJson: Value(tagsJson),
      topicId: topicId == null && nullToAbsent
          ? const Value.absent()
          : Value(topicId),
    );
  }

  factory Word.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Word(
      id: serializer.fromJson<String>(json['id']),
      hanzi: serializer.fromJson<String>(json['hanzi']),
      pinyin: serializer.fromJson<String>(json['pinyin']),
      translationRu: serializer.fromJson<String>(json['translationRu']),
      exampleZh: serializer.fromJson<String?>(json['exampleZh']),
      examplePinyin: serializer.fromJson<String?>(json['examplePinyin']),
      exampleRu: serializer.fromJson<String?>(json['exampleRu']),
      hskLevel: serializer.fromJson<String>(json['hskLevel']),
      audioPath: serializer.fromJson<String?>(json['audioPath']),
      strokeCount: serializer.fromJson<int>(json['strokeCount']),
      tagsJson: serializer.fromJson<String>(json['tagsJson']),
      topicId: serializer.fromJson<String?>(json['topicId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'hanzi': serializer.toJson<String>(hanzi),
      'pinyin': serializer.toJson<String>(pinyin),
      'translationRu': serializer.toJson<String>(translationRu),
      'exampleZh': serializer.toJson<String?>(exampleZh),
      'examplePinyin': serializer.toJson<String?>(examplePinyin),
      'exampleRu': serializer.toJson<String?>(exampleRu),
      'hskLevel': serializer.toJson<String>(hskLevel),
      'audioPath': serializer.toJson<String?>(audioPath),
      'strokeCount': serializer.toJson<int>(strokeCount),
      'tagsJson': serializer.toJson<String>(tagsJson),
      'topicId': serializer.toJson<String?>(topicId),
    };
  }

  Word copyWith(
          {String? id,
          String? hanzi,
          String? pinyin,
          String? translationRu,
          Value<String?> exampleZh = const Value.absent(),
          Value<String?> examplePinyin = const Value.absent(),
          Value<String?> exampleRu = const Value.absent(),
          String? hskLevel,
          Value<String?> audioPath = const Value.absent(),
          int? strokeCount,
          String? tagsJson,
          Value<String?> topicId = const Value.absent()}) =>
      Word(
        id: id ?? this.id,
        hanzi: hanzi ?? this.hanzi,
        pinyin: pinyin ?? this.pinyin,
        translationRu: translationRu ?? this.translationRu,
        exampleZh: exampleZh.present ? exampleZh.value : this.exampleZh,
        examplePinyin:
            examplePinyin.present ? examplePinyin.value : this.examplePinyin,
        exampleRu: exampleRu.present ? exampleRu.value : this.exampleRu,
        hskLevel: hskLevel ?? this.hskLevel,
        audioPath: audioPath.present ? audioPath.value : this.audioPath,
        strokeCount: strokeCount ?? this.strokeCount,
        tagsJson: tagsJson ?? this.tagsJson,
        topicId: topicId.present ? topicId.value : this.topicId,
      );
  Word copyWithCompanion(WordsCompanion data) {
    return Word(
      id: data.id.present ? data.id.value : this.id,
      hanzi: data.hanzi.present ? data.hanzi.value : this.hanzi,
      pinyin: data.pinyin.present ? data.pinyin.value : this.pinyin,
      translationRu: data.translationRu.present
          ? data.translationRu.value
          : this.translationRu,
      exampleZh: data.exampleZh.present ? data.exampleZh.value : this.exampleZh,
      examplePinyin: data.examplePinyin.present
          ? data.examplePinyin.value
          : this.examplePinyin,
      exampleRu: data.exampleRu.present ? data.exampleRu.value : this.exampleRu,
      hskLevel: data.hskLevel.present ? data.hskLevel.value : this.hskLevel,
      audioPath: data.audioPath.present ? data.audioPath.value : this.audioPath,
      strokeCount:
          data.strokeCount.present ? data.strokeCount.value : this.strokeCount,
      tagsJson: data.tagsJson.present ? data.tagsJson.value : this.tagsJson,
      topicId: data.topicId.present ? data.topicId.value : this.topicId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Word(')
          ..write('id: $id, ')
          ..write('hanzi: $hanzi, ')
          ..write('pinyin: $pinyin, ')
          ..write('translationRu: $translationRu, ')
          ..write('exampleZh: $exampleZh, ')
          ..write('examplePinyin: $examplePinyin, ')
          ..write('exampleRu: $exampleRu, ')
          ..write('hskLevel: $hskLevel, ')
          ..write('audioPath: $audioPath, ')
          ..write('strokeCount: $strokeCount, ')
          ..write('tagsJson: $tagsJson, ')
          ..write('topicId: $topicId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      hanzi,
      pinyin,
      translationRu,
      exampleZh,
      examplePinyin,
      exampleRu,
      hskLevel,
      audioPath,
      strokeCount,
      tagsJson,
      topicId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Word &&
          other.id == this.id &&
          other.hanzi == this.hanzi &&
          other.pinyin == this.pinyin &&
          other.translationRu == this.translationRu &&
          other.exampleZh == this.exampleZh &&
          other.examplePinyin == this.examplePinyin &&
          other.exampleRu == this.exampleRu &&
          other.hskLevel == this.hskLevel &&
          other.audioPath == this.audioPath &&
          other.strokeCount == this.strokeCount &&
          other.tagsJson == this.tagsJson &&
          other.topicId == this.topicId);
}

class WordsCompanion extends UpdateCompanion<Word> {
  final Value<String> id;
  final Value<String> hanzi;
  final Value<String> pinyin;
  final Value<String> translationRu;
  final Value<String?> exampleZh;
  final Value<String?> examplePinyin;
  final Value<String?> exampleRu;
  final Value<String> hskLevel;
  final Value<String?> audioPath;
  final Value<int> strokeCount;
  final Value<String> tagsJson;
  final Value<String?> topicId;
  final Value<int> rowid;
  const WordsCompanion({
    this.id = const Value.absent(),
    this.hanzi = const Value.absent(),
    this.pinyin = const Value.absent(),
    this.translationRu = const Value.absent(),
    this.exampleZh = const Value.absent(),
    this.examplePinyin = const Value.absent(),
    this.exampleRu = const Value.absent(),
    this.hskLevel = const Value.absent(),
    this.audioPath = const Value.absent(),
    this.strokeCount = const Value.absent(),
    this.tagsJson = const Value.absent(),
    this.topicId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WordsCompanion.insert({
    required String id,
    required String hanzi,
    required String pinyin,
    required String translationRu,
    this.exampleZh = const Value.absent(),
    this.examplePinyin = const Value.absent(),
    this.exampleRu = const Value.absent(),
    required String hskLevel,
    this.audioPath = const Value.absent(),
    required int strokeCount,
    required String tagsJson,
    this.topicId = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        hanzi = Value(hanzi),
        pinyin = Value(pinyin),
        translationRu = Value(translationRu),
        hskLevel = Value(hskLevel),
        strokeCount = Value(strokeCount),
        tagsJson = Value(tagsJson);
  static Insertable<Word> custom({
    Expression<String>? id,
    Expression<String>? hanzi,
    Expression<String>? pinyin,
    Expression<String>? translationRu,
    Expression<String>? exampleZh,
    Expression<String>? examplePinyin,
    Expression<String>? exampleRu,
    Expression<String>? hskLevel,
    Expression<String>? audioPath,
    Expression<int>? strokeCount,
    Expression<String>? tagsJson,
    Expression<String>? topicId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (hanzi != null) 'hanzi': hanzi,
      if (pinyin != null) 'pinyin': pinyin,
      if (translationRu != null) 'translation_ru': translationRu,
      if (exampleZh != null) 'example_zh': exampleZh,
      if (examplePinyin != null) 'example_pinyin': examplePinyin,
      if (exampleRu != null) 'example_ru': exampleRu,
      if (hskLevel != null) 'hsk_level': hskLevel,
      if (audioPath != null) 'audio_path': audioPath,
      if (strokeCount != null) 'stroke_count': strokeCount,
      if (tagsJson != null) 'tags_json': tagsJson,
      if (topicId != null) 'topic_id': topicId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WordsCompanion copyWith(
      {Value<String>? id,
      Value<String>? hanzi,
      Value<String>? pinyin,
      Value<String>? translationRu,
      Value<String?>? exampleZh,
      Value<String?>? examplePinyin,
      Value<String?>? exampleRu,
      Value<String>? hskLevel,
      Value<String?>? audioPath,
      Value<int>? strokeCount,
      Value<String>? tagsJson,
      Value<String?>? topicId,
      Value<int>? rowid}) {
    return WordsCompanion(
      id: id ?? this.id,
      hanzi: hanzi ?? this.hanzi,
      pinyin: pinyin ?? this.pinyin,
      translationRu: translationRu ?? this.translationRu,
      exampleZh: exampleZh ?? this.exampleZh,
      examplePinyin: examplePinyin ?? this.examplePinyin,
      exampleRu: exampleRu ?? this.exampleRu,
      hskLevel: hskLevel ?? this.hskLevel,
      audioPath: audioPath ?? this.audioPath,
      strokeCount: strokeCount ?? this.strokeCount,
      tagsJson: tagsJson ?? this.tagsJson,
      topicId: topicId ?? this.topicId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (hanzi.present) {
      map['hanzi'] = Variable<String>(hanzi.value);
    }
    if (pinyin.present) {
      map['pinyin'] = Variable<String>(pinyin.value);
    }
    if (translationRu.present) {
      map['translation_ru'] = Variable<String>(translationRu.value);
    }
    if (exampleZh.present) {
      map['example_zh'] = Variable<String>(exampleZh.value);
    }
    if (examplePinyin.present) {
      map['example_pinyin'] = Variable<String>(examplePinyin.value);
    }
    if (exampleRu.present) {
      map['example_ru'] = Variable<String>(exampleRu.value);
    }
    if (hskLevel.present) {
      map['hsk_level'] = Variable<String>(hskLevel.value);
    }
    if (audioPath.present) {
      map['audio_path'] = Variable<String>(audioPath.value);
    }
    if (strokeCount.present) {
      map['stroke_count'] = Variable<int>(strokeCount.value);
    }
    if (tagsJson.present) {
      map['tags_json'] = Variable<String>(tagsJson.value);
    }
    if (topicId.present) {
      map['topic_id'] = Variable<String>(topicId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WordsCompanion(')
          ..write('id: $id, ')
          ..write('hanzi: $hanzi, ')
          ..write('pinyin: $pinyin, ')
          ..write('translationRu: $translationRu, ')
          ..write('exampleZh: $exampleZh, ')
          ..write('examplePinyin: $examplePinyin, ')
          ..write('exampleRu: $exampleRu, ')
          ..write('hskLevel: $hskLevel, ')
          ..write('audioPath: $audioPath, ')
          ..write('strokeCount: $strokeCount, ')
          ..write('tagsJson: $tagsJson, ')
          ..write('topicId: $topicId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProgressEntriesTable extends ProgressEntries
    with TableInfo<$ProgressEntriesTable, ProgressEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProgressEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _entityIdMeta =
      const VerificationMeta('entityId');
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
      'entity_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _entityTypeMeta =
      const VerificationMeta('entityType');
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
      'entity_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _scoreMeta = const VerificationMeta('score');
  @override
  late final GeneratedColumn<int> score = GeneratedColumn<int>(
      'score', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _completedAtMeta =
      const VerificationMeta('completedAt');
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
      'completed_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _finalTestPassedMeta =
      const VerificationMeta('finalTestPassed');
  @override
  late final GeneratedColumn<bool> finalTestPassed = GeneratedColumn<bool>(
      'final_test_passed', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("final_test_passed" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns =>
      [entityId, entityType, status, score, completedAt, finalTestPassed];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'progress_entries';
  @override
  VerificationContext validateIntegrity(Insertable<ProgressEntry> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('entity_id')) {
      context.handle(_entityIdMeta,
          entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta));
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('entity_type')) {
      context.handle(
          _entityTypeMeta,
          entityType.isAcceptableOrUnknown(
              data['entity_type']!, _entityTypeMeta));
    } else if (isInserting) {
      context.missing(_entityTypeMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('score')) {
      context.handle(
          _scoreMeta, score.isAcceptableOrUnknown(data['score']!, _scoreMeta));
    }
    if (data.containsKey('completed_at')) {
      context.handle(
          _completedAtMeta,
          completedAt.isAcceptableOrUnknown(
              data['completed_at']!, _completedAtMeta));
    }
    if (data.containsKey('final_test_passed')) {
      context.handle(
          _finalTestPassedMeta,
          finalTestPassed.isAcceptableOrUnknown(
              data['final_test_passed']!, _finalTestPassedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {entityId};
  @override
  ProgressEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProgressEntry(
      entityId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entity_id'])!,
      entityType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entity_type'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      score: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}score'])!,
      completedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}completed_at']),
      finalTestPassed: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}final_test_passed'])!,
    );
  }

  @override
  $ProgressEntriesTable createAlias(String alias) {
    return $ProgressEntriesTable(attachedDatabase, alias);
  }
}

class ProgressEntry extends DataClass implements Insertable<ProgressEntry> {
  final String entityId;
  final String entityType;
  final String status;
  final int score;
  final DateTime? completedAt;
  final bool finalTestPassed;
  const ProgressEntry(
      {required this.entityId,
      required this.entityType,
      required this.status,
      required this.score,
      this.completedAt,
      required this.finalTestPassed});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['entity_id'] = Variable<String>(entityId);
    map['entity_type'] = Variable<String>(entityType);
    map['status'] = Variable<String>(status);
    map['score'] = Variable<int>(score);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    map['final_test_passed'] = Variable<bool>(finalTestPassed);
    return map;
  }

  ProgressEntriesCompanion toCompanion(bool nullToAbsent) {
    return ProgressEntriesCompanion(
      entityId: Value(entityId),
      entityType: Value(entityType),
      status: Value(status),
      score: Value(score),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      finalTestPassed: Value(finalTestPassed),
    );
  }

  factory ProgressEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProgressEntry(
      entityId: serializer.fromJson<String>(json['entityId']),
      entityType: serializer.fromJson<String>(json['entityType']),
      status: serializer.fromJson<String>(json['status']),
      score: serializer.fromJson<int>(json['score']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
      finalTestPassed: serializer.fromJson<bool>(json['finalTestPassed']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'entityId': serializer.toJson<String>(entityId),
      'entityType': serializer.toJson<String>(entityType),
      'status': serializer.toJson<String>(status),
      'score': serializer.toJson<int>(score),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
      'finalTestPassed': serializer.toJson<bool>(finalTestPassed),
    };
  }

  ProgressEntry copyWith(
          {String? entityId,
          String? entityType,
          String? status,
          int? score,
          Value<DateTime?> completedAt = const Value.absent(),
          bool? finalTestPassed}) =>
      ProgressEntry(
        entityId: entityId ?? this.entityId,
        entityType: entityType ?? this.entityType,
        status: status ?? this.status,
        score: score ?? this.score,
        completedAt: completedAt.present ? completedAt.value : this.completedAt,
        finalTestPassed: finalTestPassed ?? this.finalTestPassed,
      );
  ProgressEntry copyWithCompanion(ProgressEntriesCompanion data) {
    return ProgressEntry(
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      entityType:
          data.entityType.present ? data.entityType.value : this.entityType,
      status: data.status.present ? data.status.value : this.status,
      score: data.score.present ? data.score.value : this.score,
      completedAt:
          data.completedAt.present ? data.completedAt.value : this.completedAt,
      finalTestPassed: data.finalTestPassed.present
          ? data.finalTestPassed.value
          : this.finalTestPassed,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProgressEntry(')
          ..write('entityId: $entityId, ')
          ..write('entityType: $entityType, ')
          ..write('status: $status, ')
          ..write('score: $score, ')
          ..write('completedAt: $completedAt, ')
          ..write('finalTestPassed: $finalTestPassed')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      entityId, entityType, status, score, completedAt, finalTestPassed);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProgressEntry &&
          other.entityId == this.entityId &&
          other.entityType == this.entityType &&
          other.status == this.status &&
          other.score == this.score &&
          other.completedAt == this.completedAt &&
          other.finalTestPassed == this.finalTestPassed);
}

class ProgressEntriesCompanion extends UpdateCompanion<ProgressEntry> {
  final Value<String> entityId;
  final Value<String> entityType;
  final Value<String> status;
  final Value<int> score;
  final Value<DateTime?> completedAt;
  final Value<bool> finalTestPassed;
  final Value<int> rowid;
  const ProgressEntriesCompanion({
    this.entityId = const Value.absent(),
    this.entityType = const Value.absent(),
    this.status = const Value.absent(),
    this.score = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.finalTestPassed = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProgressEntriesCompanion.insert({
    required String entityId,
    required String entityType,
    required String status,
    this.score = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.finalTestPassed = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : entityId = Value(entityId),
        entityType = Value(entityType),
        status = Value(status);
  static Insertable<ProgressEntry> custom({
    Expression<String>? entityId,
    Expression<String>? entityType,
    Expression<String>? status,
    Expression<int>? score,
    Expression<DateTime>? completedAt,
    Expression<bool>? finalTestPassed,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (entityId != null) 'entity_id': entityId,
      if (entityType != null) 'entity_type': entityType,
      if (status != null) 'status': status,
      if (score != null) 'score': score,
      if (completedAt != null) 'completed_at': completedAt,
      if (finalTestPassed != null) 'final_test_passed': finalTestPassed,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProgressEntriesCompanion copyWith(
      {Value<String>? entityId,
      Value<String>? entityType,
      Value<String>? status,
      Value<int>? score,
      Value<DateTime?>? completedAt,
      Value<bool>? finalTestPassed,
      Value<int>? rowid}) {
    return ProgressEntriesCompanion(
      entityId: entityId ?? this.entityId,
      entityType: entityType ?? this.entityType,
      status: status ?? this.status,
      score: score ?? this.score,
      completedAt: completedAt ?? this.completedAt,
      finalTestPassed: finalTestPassed ?? this.finalTestPassed,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (score.present) {
      map['score'] = Variable<int>(score.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (finalTestPassed.present) {
      map['final_test_passed'] = Variable<bool>(finalTestPassed.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProgressEntriesCompanion(')
          ..write('entityId: $entityId, ')
          ..write('entityType: $entityType, ')
          ..write('status: $status, ')
          ..write('score: $score, ')
          ..write('completedAt: $completedAt, ')
          ..write('finalTestPassed: $finalTestPassed, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DictionaryEntriesTable extends DictionaryEntries
    with TableInfo<$DictionaryEntriesTable, DictionaryEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DictionaryEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _wordIdMeta = const VerificationMeta('wordId');
  @override
  late final GeneratedColumn<String> wordId = GeneratedColumn<String>(
      'word_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _srsLevelMeta =
      const VerificationMeta('srsLevel');
  @override
  late final GeneratedColumn<int> srsLevel = GeneratedColumn<int>(
      'srs_level', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _repetitionsMeta =
      const VerificationMeta('repetitions');
  @override
  late final GeneratedColumn<int> repetitions = GeneratedColumn<int>(
      'repetitions', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _intervalDaysMeta =
      const VerificationMeta('intervalDays');
  @override
  late final GeneratedColumn<int> intervalDays = GeneratedColumn<int>(
      'interval_days', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _easeFactorMeta =
      const VerificationMeta('easeFactor');
  @override
  late final GeneratedColumn<double> easeFactor = GeneratedColumn<double>(
      'ease_factor', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(2.5));
  static const VerificationMeta _nextReviewAtMeta =
      const VerificationMeta('nextReviewAt');
  @override
  late final GeneratedColumn<DateTime> nextReviewAt = GeneratedColumn<DateTime>(
      'next_review_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _lastReviewedAtMeta =
      const VerificationMeta('lastReviewedAt');
  @override
  late final GeneratedColumn<DateTime> lastReviewedAt =
      GeneratedColumn<DateTime>('last_reviewed_at', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        wordId,
        srsLevel,
        repetitions,
        intervalDays,
        easeFactor,
        nextReviewAt,
        lastReviewedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'dictionary_entries';
  @override
  VerificationContext validateIntegrity(Insertable<DictionaryEntry> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('word_id')) {
      context.handle(_wordIdMeta,
          wordId.isAcceptableOrUnknown(data['word_id']!, _wordIdMeta));
    } else if (isInserting) {
      context.missing(_wordIdMeta);
    }
    if (data.containsKey('srs_level')) {
      context.handle(_srsLevelMeta,
          srsLevel.isAcceptableOrUnknown(data['srs_level']!, _srsLevelMeta));
    }
    if (data.containsKey('repetitions')) {
      context.handle(
          _repetitionsMeta,
          repetitions.isAcceptableOrUnknown(
              data['repetitions']!, _repetitionsMeta));
    }
    if (data.containsKey('interval_days')) {
      context.handle(
          _intervalDaysMeta,
          intervalDays.isAcceptableOrUnknown(
              data['interval_days']!, _intervalDaysMeta));
    }
    if (data.containsKey('ease_factor')) {
      context.handle(
          _easeFactorMeta,
          easeFactor.isAcceptableOrUnknown(
              data['ease_factor']!, _easeFactorMeta));
    }
    if (data.containsKey('next_review_at')) {
      context.handle(
          _nextReviewAtMeta,
          nextReviewAt.isAcceptableOrUnknown(
              data['next_review_at']!, _nextReviewAtMeta));
    }
    if (data.containsKey('last_reviewed_at')) {
      context.handle(
          _lastReviewedAtMeta,
          lastReviewedAt.isAcceptableOrUnknown(
              data['last_reviewed_at']!, _lastReviewedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {wordId};
  @override
  DictionaryEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DictionaryEntry(
      wordId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}word_id'])!,
      srsLevel: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}srs_level'])!,
      repetitions: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}repetitions'])!,
      intervalDays: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}interval_days'])!,
      easeFactor: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}ease_factor'])!,
      nextReviewAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}next_review_at']),
      lastReviewedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_reviewed_at']),
    );
  }

  @override
  $DictionaryEntriesTable createAlias(String alias) {
    return $DictionaryEntriesTable(attachedDatabase, alias);
  }
}

class DictionaryEntry extends DataClass implements Insertable<DictionaryEntry> {
  final String wordId;
  final int srsLevel;
  final int repetitions;
  final int intervalDays;
  final double easeFactor;
  final DateTime? nextReviewAt;
  final DateTime? lastReviewedAt;
  const DictionaryEntry(
      {required this.wordId,
      required this.srsLevel,
      required this.repetitions,
      required this.intervalDays,
      required this.easeFactor,
      this.nextReviewAt,
      this.lastReviewedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['word_id'] = Variable<String>(wordId);
    map['srs_level'] = Variable<int>(srsLevel);
    map['repetitions'] = Variable<int>(repetitions);
    map['interval_days'] = Variable<int>(intervalDays);
    map['ease_factor'] = Variable<double>(easeFactor);
    if (!nullToAbsent || nextReviewAt != null) {
      map['next_review_at'] = Variable<DateTime>(nextReviewAt);
    }
    if (!nullToAbsent || lastReviewedAt != null) {
      map['last_reviewed_at'] = Variable<DateTime>(lastReviewedAt);
    }
    return map;
  }

  DictionaryEntriesCompanion toCompanion(bool nullToAbsent) {
    return DictionaryEntriesCompanion(
      wordId: Value(wordId),
      srsLevel: Value(srsLevel),
      repetitions: Value(repetitions),
      intervalDays: Value(intervalDays),
      easeFactor: Value(easeFactor),
      nextReviewAt: nextReviewAt == null && nullToAbsent
          ? const Value.absent()
          : Value(nextReviewAt),
      lastReviewedAt: lastReviewedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastReviewedAt),
    );
  }

  factory DictionaryEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DictionaryEntry(
      wordId: serializer.fromJson<String>(json['wordId']),
      srsLevel: serializer.fromJson<int>(json['srsLevel']),
      repetitions: serializer.fromJson<int>(json['repetitions']),
      intervalDays: serializer.fromJson<int>(json['intervalDays']),
      easeFactor: serializer.fromJson<double>(json['easeFactor']),
      nextReviewAt: serializer.fromJson<DateTime?>(json['nextReviewAt']),
      lastReviewedAt: serializer.fromJson<DateTime?>(json['lastReviewedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'wordId': serializer.toJson<String>(wordId),
      'srsLevel': serializer.toJson<int>(srsLevel),
      'repetitions': serializer.toJson<int>(repetitions),
      'intervalDays': serializer.toJson<int>(intervalDays),
      'easeFactor': serializer.toJson<double>(easeFactor),
      'nextReviewAt': serializer.toJson<DateTime?>(nextReviewAt),
      'lastReviewedAt': serializer.toJson<DateTime?>(lastReviewedAt),
    };
  }

  DictionaryEntry copyWith(
          {String? wordId,
          int? srsLevel,
          int? repetitions,
          int? intervalDays,
          double? easeFactor,
          Value<DateTime?> nextReviewAt = const Value.absent(),
          Value<DateTime?> lastReviewedAt = const Value.absent()}) =>
      DictionaryEntry(
        wordId: wordId ?? this.wordId,
        srsLevel: srsLevel ?? this.srsLevel,
        repetitions: repetitions ?? this.repetitions,
        intervalDays: intervalDays ?? this.intervalDays,
        easeFactor: easeFactor ?? this.easeFactor,
        nextReviewAt:
            nextReviewAt.present ? nextReviewAt.value : this.nextReviewAt,
        lastReviewedAt:
            lastReviewedAt.present ? lastReviewedAt.value : this.lastReviewedAt,
      );
  DictionaryEntry copyWithCompanion(DictionaryEntriesCompanion data) {
    return DictionaryEntry(
      wordId: data.wordId.present ? data.wordId.value : this.wordId,
      srsLevel: data.srsLevel.present ? data.srsLevel.value : this.srsLevel,
      repetitions:
          data.repetitions.present ? data.repetitions.value : this.repetitions,
      intervalDays: data.intervalDays.present
          ? data.intervalDays.value
          : this.intervalDays,
      easeFactor:
          data.easeFactor.present ? data.easeFactor.value : this.easeFactor,
      nextReviewAt: data.nextReviewAt.present
          ? data.nextReviewAt.value
          : this.nextReviewAt,
      lastReviewedAt: data.lastReviewedAt.present
          ? data.lastReviewedAt.value
          : this.lastReviewedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DictionaryEntry(')
          ..write('wordId: $wordId, ')
          ..write('srsLevel: $srsLevel, ')
          ..write('repetitions: $repetitions, ')
          ..write('intervalDays: $intervalDays, ')
          ..write('easeFactor: $easeFactor, ')
          ..write('nextReviewAt: $nextReviewAt, ')
          ..write('lastReviewedAt: $lastReviewedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(wordId, srsLevel, repetitions, intervalDays,
      easeFactor, nextReviewAt, lastReviewedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DictionaryEntry &&
          other.wordId == this.wordId &&
          other.srsLevel == this.srsLevel &&
          other.repetitions == this.repetitions &&
          other.intervalDays == this.intervalDays &&
          other.easeFactor == this.easeFactor &&
          other.nextReviewAt == this.nextReviewAt &&
          other.lastReviewedAt == this.lastReviewedAt);
}

class DictionaryEntriesCompanion extends UpdateCompanion<DictionaryEntry> {
  final Value<String> wordId;
  final Value<int> srsLevel;
  final Value<int> repetitions;
  final Value<int> intervalDays;
  final Value<double> easeFactor;
  final Value<DateTime?> nextReviewAt;
  final Value<DateTime?> lastReviewedAt;
  final Value<int> rowid;
  const DictionaryEntriesCompanion({
    this.wordId = const Value.absent(),
    this.srsLevel = const Value.absent(),
    this.repetitions = const Value.absent(),
    this.intervalDays = const Value.absent(),
    this.easeFactor = const Value.absent(),
    this.nextReviewAt = const Value.absent(),
    this.lastReviewedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DictionaryEntriesCompanion.insert({
    required String wordId,
    this.srsLevel = const Value.absent(),
    this.repetitions = const Value.absent(),
    this.intervalDays = const Value.absent(),
    this.easeFactor = const Value.absent(),
    this.nextReviewAt = const Value.absent(),
    this.lastReviewedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : wordId = Value(wordId);
  static Insertable<DictionaryEntry> custom({
    Expression<String>? wordId,
    Expression<int>? srsLevel,
    Expression<int>? repetitions,
    Expression<int>? intervalDays,
    Expression<double>? easeFactor,
    Expression<DateTime>? nextReviewAt,
    Expression<DateTime>? lastReviewedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (wordId != null) 'word_id': wordId,
      if (srsLevel != null) 'srs_level': srsLevel,
      if (repetitions != null) 'repetitions': repetitions,
      if (intervalDays != null) 'interval_days': intervalDays,
      if (easeFactor != null) 'ease_factor': easeFactor,
      if (nextReviewAt != null) 'next_review_at': nextReviewAt,
      if (lastReviewedAt != null) 'last_reviewed_at': lastReviewedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DictionaryEntriesCompanion copyWith(
      {Value<String>? wordId,
      Value<int>? srsLevel,
      Value<int>? repetitions,
      Value<int>? intervalDays,
      Value<double>? easeFactor,
      Value<DateTime?>? nextReviewAt,
      Value<DateTime?>? lastReviewedAt,
      Value<int>? rowid}) {
    return DictionaryEntriesCompanion(
      wordId: wordId ?? this.wordId,
      srsLevel: srsLevel ?? this.srsLevel,
      repetitions: repetitions ?? this.repetitions,
      intervalDays: intervalDays ?? this.intervalDays,
      easeFactor: easeFactor ?? this.easeFactor,
      nextReviewAt: nextReviewAt ?? this.nextReviewAt,
      lastReviewedAt: lastReviewedAt ?? this.lastReviewedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (wordId.present) {
      map['word_id'] = Variable<String>(wordId.value);
    }
    if (srsLevel.present) {
      map['srs_level'] = Variable<int>(srsLevel.value);
    }
    if (repetitions.present) {
      map['repetitions'] = Variable<int>(repetitions.value);
    }
    if (intervalDays.present) {
      map['interval_days'] = Variable<int>(intervalDays.value);
    }
    if (easeFactor.present) {
      map['ease_factor'] = Variable<double>(easeFactor.value);
    }
    if (nextReviewAt.present) {
      map['next_review_at'] = Variable<DateTime>(nextReviewAt.value);
    }
    if (lastReviewedAt.present) {
      map['last_reviewed_at'] = Variable<DateTime>(lastReviewedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DictionaryEntriesCompanion(')
          ..write('wordId: $wordId, ')
          ..write('srsLevel: $srsLevel, ')
          ..write('repetitions: $repetitions, ')
          ..write('intervalDays: $intervalDays, ')
          ..write('easeFactor: $easeFactor, ')
          ..write('nextReviewAt: $nextReviewAt, ')
          ..write('lastReviewedAt: $lastReviewedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CalligraphyEntriesTable extends CalligraphyEntries
    with TableInfo<$CalligraphyEntriesTable, CalligraphyEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CalligraphyEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _wordIdMeta = const VerificationMeta('wordId');
  @override
  late final GeneratedColumn<String> wordId = GeneratedColumn<String>(
      'word_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _attemptsMeta =
      const VerificationMeta('attempts');
  @override
  late final GeneratedColumn<int> attempts = GeneratedColumn<int>(
      'attempts', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _bestScoreMeta =
      const VerificationMeta('bestScore');
  @override
  late final GeneratedColumn<int> bestScore = GeneratedColumn<int>(
      'best_score', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _lastAttemptAtMeta =
      const VerificationMeta('lastAttemptAt');
  @override
  late final GeneratedColumn<DateTime> lastAttemptAt =
      GeneratedColumn<DateTime>('last_attempt_at', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [wordId, attempts, bestScore, lastAttemptAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'calligraphy_entries';
  @override
  VerificationContext validateIntegrity(Insertable<CalligraphyEntry> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('word_id')) {
      context.handle(_wordIdMeta,
          wordId.isAcceptableOrUnknown(data['word_id']!, _wordIdMeta));
    } else if (isInserting) {
      context.missing(_wordIdMeta);
    }
    if (data.containsKey('attempts')) {
      context.handle(_attemptsMeta,
          attempts.isAcceptableOrUnknown(data['attempts']!, _attemptsMeta));
    }
    if (data.containsKey('best_score')) {
      context.handle(_bestScoreMeta,
          bestScore.isAcceptableOrUnknown(data['best_score']!, _bestScoreMeta));
    }
    if (data.containsKey('last_attempt_at')) {
      context.handle(
          _lastAttemptAtMeta,
          lastAttemptAt.isAcceptableOrUnknown(
              data['last_attempt_at']!, _lastAttemptAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {wordId};
  @override
  CalligraphyEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CalligraphyEntry(
      wordId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}word_id'])!,
      attempts: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}attempts'])!,
      bestScore: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}best_score'])!,
      lastAttemptAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_attempt_at']),
    );
  }

  @override
  $CalligraphyEntriesTable createAlias(String alias) {
    return $CalligraphyEntriesTable(attachedDatabase, alias);
  }
}

class CalligraphyEntry extends DataClass
    implements Insertable<CalligraphyEntry> {
  final String wordId;
  final int attempts;
  final int bestScore;
  final DateTime? lastAttemptAt;
  const CalligraphyEntry(
      {required this.wordId,
      required this.attempts,
      required this.bestScore,
      this.lastAttemptAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['word_id'] = Variable<String>(wordId);
    map['attempts'] = Variable<int>(attempts);
    map['best_score'] = Variable<int>(bestScore);
    if (!nullToAbsent || lastAttemptAt != null) {
      map['last_attempt_at'] = Variable<DateTime>(lastAttemptAt);
    }
    return map;
  }

  CalligraphyEntriesCompanion toCompanion(bool nullToAbsent) {
    return CalligraphyEntriesCompanion(
      wordId: Value(wordId),
      attempts: Value(attempts),
      bestScore: Value(bestScore),
      lastAttemptAt: lastAttemptAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastAttemptAt),
    );
  }

  factory CalligraphyEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CalligraphyEntry(
      wordId: serializer.fromJson<String>(json['wordId']),
      attempts: serializer.fromJson<int>(json['attempts']),
      bestScore: serializer.fromJson<int>(json['bestScore']),
      lastAttemptAt: serializer.fromJson<DateTime?>(json['lastAttemptAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'wordId': serializer.toJson<String>(wordId),
      'attempts': serializer.toJson<int>(attempts),
      'bestScore': serializer.toJson<int>(bestScore),
      'lastAttemptAt': serializer.toJson<DateTime?>(lastAttemptAt),
    };
  }

  CalligraphyEntry copyWith(
          {String? wordId,
          int? attempts,
          int? bestScore,
          Value<DateTime?> lastAttemptAt = const Value.absent()}) =>
      CalligraphyEntry(
        wordId: wordId ?? this.wordId,
        attempts: attempts ?? this.attempts,
        bestScore: bestScore ?? this.bestScore,
        lastAttemptAt:
            lastAttemptAt.present ? lastAttemptAt.value : this.lastAttemptAt,
      );
  CalligraphyEntry copyWithCompanion(CalligraphyEntriesCompanion data) {
    return CalligraphyEntry(
      wordId: data.wordId.present ? data.wordId.value : this.wordId,
      attempts: data.attempts.present ? data.attempts.value : this.attempts,
      bestScore: data.bestScore.present ? data.bestScore.value : this.bestScore,
      lastAttemptAt: data.lastAttemptAt.present
          ? data.lastAttemptAt.value
          : this.lastAttemptAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CalligraphyEntry(')
          ..write('wordId: $wordId, ')
          ..write('attempts: $attempts, ')
          ..write('bestScore: $bestScore, ')
          ..write('lastAttemptAt: $lastAttemptAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(wordId, attempts, bestScore, lastAttemptAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CalligraphyEntry &&
          other.wordId == this.wordId &&
          other.attempts == this.attempts &&
          other.bestScore == this.bestScore &&
          other.lastAttemptAt == this.lastAttemptAt);
}

class CalligraphyEntriesCompanion extends UpdateCompanion<CalligraphyEntry> {
  final Value<String> wordId;
  final Value<int> attempts;
  final Value<int> bestScore;
  final Value<DateTime?> lastAttemptAt;
  final Value<int> rowid;
  const CalligraphyEntriesCompanion({
    this.wordId = const Value.absent(),
    this.attempts = const Value.absent(),
    this.bestScore = const Value.absent(),
    this.lastAttemptAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CalligraphyEntriesCompanion.insert({
    required String wordId,
    this.attempts = const Value.absent(),
    this.bestScore = const Value.absent(),
    this.lastAttemptAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : wordId = Value(wordId);
  static Insertable<CalligraphyEntry> custom({
    Expression<String>? wordId,
    Expression<int>? attempts,
    Expression<int>? bestScore,
    Expression<DateTime>? lastAttemptAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (wordId != null) 'word_id': wordId,
      if (attempts != null) 'attempts': attempts,
      if (bestScore != null) 'best_score': bestScore,
      if (lastAttemptAt != null) 'last_attempt_at': lastAttemptAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CalligraphyEntriesCompanion copyWith(
      {Value<String>? wordId,
      Value<int>? attempts,
      Value<int>? bestScore,
      Value<DateTime?>? lastAttemptAt,
      Value<int>? rowid}) {
    return CalligraphyEntriesCompanion(
      wordId: wordId ?? this.wordId,
      attempts: attempts ?? this.attempts,
      bestScore: bestScore ?? this.bestScore,
      lastAttemptAt: lastAttemptAt ?? this.lastAttemptAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (wordId.present) {
      map['word_id'] = Variable<String>(wordId.value);
    }
    if (attempts.present) {
      map['attempts'] = Variable<int>(attempts.value);
    }
    if (bestScore.present) {
      map['best_score'] = Variable<int>(bestScore.value);
    }
    if (lastAttemptAt.present) {
      map['last_attempt_at'] = Variable<DateTime>(lastAttemptAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CalligraphyEntriesCompanion(')
          ..write('wordId: $wordId, ')
          ..write('attempts: $attempts, ')
          ..write('bestScore: $bestScore, ')
          ..write('lastAttemptAt: $lastAttemptAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $BlocksTable blocks = $BlocksTable(this);
  late final $TopicsTable topics = $TopicsTable(this);
  late final $SubtopicsTable subtopics = $SubtopicsTable(this);
  late final $WordsTable words = $WordsTable(this);
  late final $ProgressEntriesTable progressEntries =
      $ProgressEntriesTable(this);
  late final $DictionaryEntriesTable dictionaryEntries =
      $DictionaryEntriesTable(this);
  late final $CalligraphyEntriesTable calligraphyEntries =
      $CalligraphyEntriesTable(this);
  late final BlocksDao blocksDao = BlocksDao(this as AppDatabase);
  late final TopicsDao topicsDao = TopicsDao(this as AppDatabase);
  late final SubtopicsDao subtopicsDao = SubtopicsDao(this as AppDatabase);
  late final WordsDao wordsDao = WordsDao(this as AppDatabase);
  late final ProgressDao progressDao = ProgressDao(this as AppDatabase);
  late final DictionaryDao dictionaryDao = DictionaryDao(this as AppDatabase);
  late final CalligraphyDao calligraphyDao =
      CalligraphyDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        blocks,
        topics,
        subtopics,
        words,
        progressEntries,
        dictionaryEntries,
        calligraphyEntries
      ];
}

typedef $$BlocksTableCreateCompanionBuilder = BlocksCompanion Function({
  required String id,
  required int order,
  required String titleRu,
  required String titleZh,
  required String descriptionRu,
  required String emoji,
  required String hskLevel,
  Value<String> blockTextFile,
  Value<int> rowid,
});
typedef $$BlocksTableUpdateCompanionBuilder = BlocksCompanion Function({
  Value<String> id,
  Value<int> order,
  Value<String> titleRu,
  Value<String> titleZh,
  Value<String> descriptionRu,
  Value<String> emoji,
  Value<String> hskLevel,
  Value<String> blockTextFile,
  Value<int> rowid,
});

class $$BlocksTableFilterComposer
    extends Composer<_$AppDatabase, $BlocksTable> {
  $$BlocksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get order => $composableBuilder(
      column: $table.order, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get titleRu => $composableBuilder(
      column: $table.titleRu, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get titleZh => $composableBuilder(
      column: $table.titleZh, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get descriptionRu => $composableBuilder(
      column: $table.descriptionRu, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get emoji => $composableBuilder(
      column: $table.emoji, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get hskLevel => $composableBuilder(
      column: $table.hskLevel, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get blockTextFile => $composableBuilder(
      column: $table.blockTextFile, builder: (column) => ColumnFilters(column));
}

class $$BlocksTableOrderingComposer
    extends Composer<_$AppDatabase, $BlocksTable> {
  $$BlocksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get order => $composableBuilder(
      column: $table.order, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get titleRu => $composableBuilder(
      column: $table.titleRu, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get titleZh => $composableBuilder(
      column: $table.titleZh, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get descriptionRu => $composableBuilder(
      column: $table.descriptionRu,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get emoji => $composableBuilder(
      column: $table.emoji, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get hskLevel => $composableBuilder(
      column: $table.hskLevel, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get blockTextFile => $composableBuilder(
      column: $table.blockTextFile,
      builder: (column) => ColumnOrderings(column));
}

class $$BlocksTableAnnotationComposer
    extends Composer<_$AppDatabase, $BlocksTable> {
  $$BlocksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get order =>
      $composableBuilder(column: $table.order, builder: (column) => column);

  GeneratedColumn<String> get titleRu =>
      $composableBuilder(column: $table.titleRu, builder: (column) => column);

  GeneratedColumn<String> get titleZh =>
      $composableBuilder(column: $table.titleZh, builder: (column) => column);

  GeneratedColumn<String> get descriptionRu => $composableBuilder(
      column: $table.descriptionRu, builder: (column) => column);

  GeneratedColumn<String> get emoji =>
      $composableBuilder(column: $table.emoji, builder: (column) => column);

  GeneratedColumn<String> get hskLevel =>
      $composableBuilder(column: $table.hskLevel, builder: (column) => column);

  GeneratedColumn<String> get blockTextFile => $composableBuilder(
      column: $table.blockTextFile, builder: (column) => column);
}

class $$BlocksTableTableManager extends RootTableManager<
    _$AppDatabase,
    $BlocksTable,
    Block,
    $$BlocksTableFilterComposer,
    $$BlocksTableOrderingComposer,
    $$BlocksTableAnnotationComposer,
    $$BlocksTableCreateCompanionBuilder,
    $$BlocksTableUpdateCompanionBuilder,
    (Block, BaseReferences<_$AppDatabase, $BlocksTable, Block>),
    Block,
    PrefetchHooks Function()> {
  $$BlocksTableTableManager(_$AppDatabase db, $BlocksTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BlocksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BlocksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BlocksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<int> order = const Value.absent(),
            Value<String> titleRu = const Value.absent(),
            Value<String> titleZh = const Value.absent(),
            Value<String> descriptionRu = const Value.absent(),
            Value<String> emoji = const Value.absent(),
            Value<String> hskLevel = const Value.absent(),
            Value<String> blockTextFile = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              BlocksCompanion(
            id: id,
            order: order,
            titleRu: titleRu,
            titleZh: titleZh,
            descriptionRu: descriptionRu,
            emoji: emoji,
            hskLevel: hskLevel,
            blockTextFile: blockTextFile,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required int order,
            required String titleRu,
            required String titleZh,
            required String descriptionRu,
            required String emoji,
            required String hskLevel,
            Value<String> blockTextFile = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              BlocksCompanion.insert(
            id: id,
            order: order,
            titleRu: titleRu,
            titleZh: titleZh,
            descriptionRu: descriptionRu,
            emoji: emoji,
            hskLevel: hskLevel,
            blockTextFile: blockTextFile,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$BlocksTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $BlocksTable,
    Block,
    $$BlocksTableFilterComposer,
    $$BlocksTableOrderingComposer,
    $$BlocksTableAnnotationComposer,
    $$BlocksTableCreateCompanionBuilder,
    $$BlocksTableUpdateCompanionBuilder,
    (Block, BaseReferences<_$AppDatabase, $BlocksTable, Block>),
    Block,
    PrefetchHooks Function()>;
typedef $$TopicsTableCreateCompanionBuilder = TopicsCompanion Function({
  required String id,
  required String blockId,
  required int order,
  required String titleRu,
  required String titleZh,
  required String descriptionRu,
  required String situationRu,
  required String hskLevel,
  Value<int> rowid,
});
typedef $$TopicsTableUpdateCompanionBuilder = TopicsCompanion Function({
  Value<String> id,
  Value<String> blockId,
  Value<int> order,
  Value<String> titleRu,
  Value<String> titleZh,
  Value<String> descriptionRu,
  Value<String> situationRu,
  Value<String> hskLevel,
  Value<int> rowid,
});

class $$TopicsTableFilterComposer
    extends Composer<_$AppDatabase, $TopicsTable> {
  $$TopicsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get blockId => $composableBuilder(
      column: $table.blockId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get order => $composableBuilder(
      column: $table.order, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get titleRu => $composableBuilder(
      column: $table.titleRu, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get titleZh => $composableBuilder(
      column: $table.titleZh, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get descriptionRu => $composableBuilder(
      column: $table.descriptionRu, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get situationRu => $composableBuilder(
      column: $table.situationRu, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get hskLevel => $composableBuilder(
      column: $table.hskLevel, builder: (column) => ColumnFilters(column));
}

class $$TopicsTableOrderingComposer
    extends Composer<_$AppDatabase, $TopicsTable> {
  $$TopicsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get blockId => $composableBuilder(
      column: $table.blockId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get order => $composableBuilder(
      column: $table.order, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get titleRu => $composableBuilder(
      column: $table.titleRu, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get titleZh => $composableBuilder(
      column: $table.titleZh, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get descriptionRu => $composableBuilder(
      column: $table.descriptionRu,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get situationRu => $composableBuilder(
      column: $table.situationRu, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get hskLevel => $composableBuilder(
      column: $table.hskLevel, builder: (column) => ColumnOrderings(column));
}

class $$TopicsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TopicsTable> {
  $$TopicsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get blockId =>
      $composableBuilder(column: $table.blockId, builder: (column) => column);

  GeneratedColumn<int> get order =>
      $composableBuilder(column: $table.order, builder: (column) => column);

  GeneratedColumn<String> get titleRu =>
      $composableBuilder(column: $table.titleRu, builder: (column) => column);

  GeneratedColumn<String> get titleZh =>
      $composableBuilder(column: $table.titleZh, builder: (column) => column);

  GeneratedColumn<String> get descriptionRu => $composableBuilder(
      column: $table.descriptionRu, builder: (column) => column);

  GeneratedColumn<String> get situationRu => $composableBuilder(
      column: $table.situationRu, builder: (column) => column);

  GeneratedColumn<String> get hskLevel =>
      $composableBuilder(column: $table.hskLevel, builder: (column) => column);
}

class $$TopicsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TopicsTable,
    Topic,
    $$TopicsTableFilterComposer,
    $$TopicsTableOrderingComposer,
    $$TopicsTableAnnotationComposer,
    $$TopicsTableCreateCompanionBuilder,
    $$TopicsTableUpdateCompanionBuilder,
    (Topic, BaseReferences<_$AppDatabase, $TopicsTable, Topic>),
    Topic,
    PrefetchHooks Function()> {
  $$TopicsTableTableManager(_$AppDatabase db, $TopicsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TopicsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TopicsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TopicsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> blockId = const Value.absent(),
            Value<int> order = const Value.absent(),
            Value<String> titleRu = const Value.absent(),
            Value<String> titleZh = const Value.absent(),
            Value<String> descriptionRu = const Value.absent(),
            Value<String> situationRu = const Value.absent(),
            Value<String> hskLevel = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TopicsCompanion(
            id: id,
            blockId: blockId,
            order: order,
            titleRu: titleRu,
            titleZh: titleZh,
            descriptionRu: descriptionRu,
            situationRu: situationRu,
            hskLevel: hskLevel,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String blockId,
            required int order,
            required String titleRu,
            required String titleZh,
            required String descriptionRu,
            required String situationRu,
            required String hskLevel,
            Value<int> rowid = const Value.absent(),
          }) =>
              TopicsCompanion.insert(
            id: id,
            blockId: blockId,
            order: order,
            titleRu: titleRu,
            titleZh: titleZh,
            descriptionRu: descriptionRu,
            situationRu: situationRu,
            hskLevel: hskLevel,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TopicsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TopicsTable,
    Topic,
    $$TopicsTableFilterComposer,
    $$TopicsTableOrderingComposer,
    $$TopicsTableAnnotationComposer,
    $$TopicsTableCreateCompanionBuilder,
    $$TopicsTableUpdateCompanionBuilder,
    (Topic, BaseReferences<_$AppDatabase, $TopicsTable, Topic>),
    Topic,
    PrefetchHooks Function()>;
typedef $$SubtopicsTableCreateCompanionBuilder = SubtopicsCompanion Function({
  required String id,
  required String topicId,
  required int order,
  required String titleRu,
  required String titleZh,
  required int estimatedMinutes,
  required String wordIdsJson,
  required String grammarIdsJson,
  required String exercisesJson,
  Value<int> rowid,
});
typedef $$SubtopicsTableUpdateCompanionBuilder = SubtopicsCompanion Function({
  Value<String> id,
  Value<String> topicId,
  Value<int> order,
  Value<String> titleRu,
  Value<String> titleZh,
  Value<int> estimatedMinutes,
  Value<String> wordIdsJson,
  Value<String> grammarIdsJson,
  Value<String> exercisesJson,
  Value<int> rowid,
});

class $$SubtopicsTableFilterComposer
    extends Composer<_$AppDatabase, $SubtopicsTable> {
  $$SubtopicsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get topicId => $composableBuilder(
      column: $table.topicId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get order => $composableBuilder(
      column: $table.order, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get titleRu => $composableBuilder(
      column: $table.titleRu, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get titleZh => $composableBuilder(
      column: $table.titleZh, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get estimatedMinutes => $composableBuilder(
      column: $table.estimatedMinutes,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get wordIdsJson => $composableBuilder(
      column: $table.wordIdsJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get grammarIdsJson => $composableBuilder(
      column: $table.grammarIdsJson,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get exercisesJson => $composableBuilder(
      column: $table.exercisesJson, builder: (column) => ColumnFilters(column));
}

class $$SubtopicsTableOrderingComposer
    extends Composer<_$AppDatabase, $SubtopicsTable> {
  $$SubtopicsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get topicId => $composableBuilder(
      column: $table.topicId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get order => $composableBuilder(
      column: $table.order, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get titleRu => $composableBuilder(
      column: $table.titleRu, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get titleZh => $composableBuilder(
      column: $table.titleZh, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get estimatedMinutes => $composableBuilder(
      column: $table.estimatedMinutes,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get wordIdsJson => $composableBuilder(
      column: $table.wordIdsJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get grammarIdsJson => $composableBuilder(
      column: $table.grammarIdsJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get exercisesJson => $composableBuilder(
      column: $table.exercisesJson,
      builder: (column) => ColumnOrderings(column));
}

class $$SubtopicsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SubtopicsTable> {
  $$SubtopicsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get topicId =>
      $composableBuilder(column: $table.topicId, builder: (column) => column);

  GeneratedColumn<int> get order =>
      $composableBuilder(column: $table.order, builder: (column) => column);

  GeneratedColumn<String> get titleRu =>
      $composableBuilder(column: $table.titleRu, builder: (column) => column);

  GeneratedColumn<String> get titleZh =>
      $composableBuilder(column: $table.titleZh, builder: (column) => column);

  GeneratedColumn<int> get estimatedMinutes => $composableBuilder(
      column: $table.estimatedMinutes, builder: (column) => column);

  GeneratedColumn<String> get wordIdsJson => $composableBuilder(
      column: $table.wordIdsJson, builder: (column) => column);

  GeneratedColumn<String> get grammarIdsJson => $composableBuilder(
      column: $table.grammarIdsJson, builder: (column) => column);

  GeneratedColumn<String> get exercisesJson => $composableBuilder(
      column: $table.exercisesJson, builder: (column) => column);
}

class $$SubtopicsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SubtopicsTable,
    Subtopic,
    $$SubtopicsTableFilterComposer,
    $$SubtopicsTableOrderingComposer,
    $$SubtopicsTableAnnotationComposer,
    $$SubtopicsTableCreateCompanionBuilder,
    $$SubtopicsTableUpdateCompanionBuilder,
    (Subtopic, BaseReferences<_$AppDatabase, $SubtopicsTable, Subtopic>),
    Subtopic,
    PrefetchHooks Function()> {
  $$SubtopicsTableTableManager(_$AppDatabase db, $SubtopicsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SubtopicsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SubtopicsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SubtopicsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> topicId = const Value.absent(),
            Value<int> order = const Value.absent(),
            Value<String> titleRu = const Value.absent(),
            Value<String> titleZh = const Value.absent(),
            Value<int> estimatedMinutes = const Value.absent(),
            Value<String> wordIdsJson = const Value.absent(),
            Value<String> grammarIdsJson = const Value.absent(),
            Value<String> exercisesJson = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SubtopicsCompanion(
            id: id,
            topicId: topicId,
            order: order,
            titleRu: titleRu,
            titleZh: titleZh,
            estimatedMinutes: estimatedMinutes,
            wordIdsJson: wordIdsJson,
            grammarIdsJson: grammarIdsJson,
            exercisesJson: exercisesJson,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String topicId,
            required int order,
            required String titleRu,
            required String titleZh,
            required int estimatedMinutes,
            required String wordIdsJson,
            required String grammarIdsJson,
            required String exercisesJson,
            Value<int> rowid = const Value.absent(),
          }) =>
              SubtopicsCompanion.insert(
            id: id,
            topicId: topicId,
            order: order,
            titleRu: titleRu,
            titleZh: titleZh,
            estimatedMinutes: estimatedMinutes,
            wordIdsJson: wordIdsJson,
            grammarIdsJson: grammarIdsJson,
            exercisesJson: exercisesJson,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SubtopicsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SubtopicsTable,
    Subtopic,
    $$SubtopicsTableFilterComposer,
    $$SubtopicsTableOrderingComposer,
    $$SubtopicsTableAnnotationComposer,
    $$SubtopicsTableCreateCompanionBuilder,
    $$SubtopicsTableUpdateCompanionBuilder,
    (Subtopic, BaseReferences<_$AppDatabase, $SubtopicsTable, Subtopic>),
    Subtopic,
    PrefetchHooks Function()>;
typedef $$WordsTableCreateCompanionBuilder = WordsCompanion Function({
  required String id,
  required String hanzi,
  required String pinyin,
  required String translationRu,
  Value<String?> exampleZh,
  Value<String?> examplePinyin,
  Value<String?> exampleRu,
  required String hskLevel,
  Value<String?> audioPath,
  required int strokeCount,
  required String tagsJson,
  Value<String?> topicId,
  Value<int> rowid,
});
typedef $$WordsTableUpdateCompanionBuilder = WordsCompanion Function({
  Value<String> id,
  Value<String> hanzi,
  Value<String> pinyin,
  Value<String> translationRu,
  Value<String?> exampleZh,
  Value<String?> examplePinyin,
  Value<String?> exampleRu,
  Value<String> hskLevel,
  Value<String?> audioPath,
  Value<int> strokeCount,
  Value<String> tagsJson,
  Value<String?> topicId,
  Value<int> rowid,
});

class $$WordsTableFilterComposer extends Composer<_$AppDatabase, $WordsTable> {
  $$WordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get hanzi => $composableBuilder(
      column: $table.hanzi, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get pinyin => $composableBuilder(
      column: $table.pinyin, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get translationRu => $composableBuilder(
      column: $table.translationRu, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get exampleZh => $composableBuilder(
      column: $table.exampleZh, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get examplePinyin => $composableBuilder(
      column: $table.examplePinyin, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get exampleRu => $composableBuilder(
      column: $table.exampleRu, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get hskLevel => $composableBuilder(
      column: $table.hskLevel, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get audioPath => $composableBuilder(
      column: $table.audioPath, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get strokeCount => $composableBuilder(
      column: $table.strokeCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tagsJson => $composableBuilder(
      column: $table.tagsJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get topicId => $composableBuilder(
      column: $table.topicId, builder: (column) => ColumnFilters(column));
}

class $$WordsTableOrderingComposer
    extends Composer<_$AppDatabase, $WordsTable> {
  $$WordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get hanzi => $composableBuilder(
      column: $table.hanzi, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get pinyin => $composableBuilder(
      column: $table.pinyin, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get translationRu => $composableBuilder(
      column: $table.translationRu,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get exampleZh => $composableBuilder(
      column: $table.exampleZh, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get examplePinyin => $composableBuilder(
      column: $table.examplePinyin,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get exampleRu => $composableBuilder(
      column: $table.exampleRu, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get hskLevel => $composableBuilder(
      column: $table.hskLevel, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get audioPath => $composableBuilder(
      column: $table.audioPath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get strokeCount => $composableBuilder(
      column: $table.strokeCount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tagsJson => $composableBuilder(
      column: $table.tagsJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get topicId => $composableBuilder(
      column: $table.topicId, builder: (column) => ColumnOrderings(column));
}

class $$WordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WordsTable> {
  $$WordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get hanzi =>
      $composableBuilder(column: $table.hanzi, builder: (column) => column);

  GeneratedColumn<String> get pinyin =>
      $composableBuilder(column: $table.pinyin, builder: (column) => column);

  GeneratedColumn<String> get translationRu => $composableBuilder(
      column: $table.translationRu, builder: (column) => column);

  GeneratedColumn<String> get exampleZh =>
      $composableBuilder(column: $table.exampleZh, builder: (column) => column);

  GeneratedColumn<String> get examplePinyin => $composableBuilder(
      column: $table.examplePinyin, builder: (column) => column);

  GeneratedColumn<String> get exampleRu =>
      $composableBuilder(column: $table.exampleRu, builder: (column) => column);

  GeneratedColumn<String> get hskLevel =>
      $composableBuilder(column: $table.hskLevel, builder: (column) => column);

  GeneratedColumn<String> get audioPath =>
      $composableBuilder(column: $table.audioPath, builder: (column) => column);

  GeneratedColumn<int> get strokeCount => $composableBuilder(
      column: $table.strokeCount, builder: (column) => column);

  GeneratedColumn<String> get tagsJson =>
      $composableBuilder(column: $table.tagsJson, builder: (column) => column);

  GeneratedColumn<String> get topicId =>
      $composableBuilder(column: $table.topicId, builder: (column) => column);
}

class $$WordsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $WordsTable,
    Word,
    $$WordsTableFilterComposer,
    $$WordsTableOrderingComposer,
    $$WordsTableAnnotationComposer,
    $$WordsTableCreateCompanionBuilder,
    $$WordsTableUpdateCompanionBuilder,
    (Word, BaseReferences<_$AppDatabase, $WordsTable, Word>),
    Word,
    PrefetchHooks Function()> {
  $$WordsTableTableManager(_$AppDatabase db, $WordsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> hanzi = const Value.absent(),
            Value<String> pinyin = const Value.absent(),
            Value<String> translationRu = const Value.absent(),
            Value<String?> exampleZh = const Value.absent(),
            Value<String?> examplePinyin = const Value.absent(),
            Value<String?> exampleRu = const Value.absent(),
            Value<String> hskLevel = const Value.absent(),
            Value<String?> audioPath = const Value.absent(),
            Value<int> strokeCount = const Value.absent(),
            Value<String> tagsJson = const Value.absent(),
            Value<String?> topicId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              WordsCompanion(
            id: id,
            hanzi: hanzi,
            pinyin: pinyin,
            translationRu: translationRu,
            exampleZh: exampleZh,
            examplePinyin: examplePinyin,
            exampleRu: exampleRu,
            hskLevel: hskLevel,
            audioPath: audioPath,
            strokeCount: strokeCount,
            tagsJson: tagsJson,
            topicId: topicId,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String hanzi,
            required String pinyin,
            required String translationRu,
            Value<String?> exampleZh = const Value.absent(),
            Value<String?> examplePinyin = const Value.absent(),
            Value<String?> exampleRu = const Value.absent(),
            required String hskLevel,
            Value<String?> audioPath = const Value.absent(),
            required int strokeCount,
            required String tagsJson,
            Value<String?> topicId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              WordsCompanion.insert(
            id: id,
            hanzi: hanzi,
            pinyin: pinyin,
            translationRu: translationRu,
            exampleZh: exampleZh,
            examplePinyin: examplePinyin,
            exampleRu: exampleRu,
            hskLevel: hskLevel,
            audioPath: audioPath,
            strokeCount: strokeCount,
            tagsJson: tagsJson,
            topicId: topicId,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$WordsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $WordsTable,
    Word,
    $$WordsTableFilterComposer,
    $$WordsTableOrderingComposer,
    $$WordsTableAnnotationComposer,
    $$WordsTableCreateCompanionBuilder,
    $$WordsTableUpdateCompanionBuilder,
    (Word, BaseReferences<_$AppDatabase, $WordsTable, Word>),
    Word,
    PrefetchHooks Function()>;
typedef $$ProgressEntriesTableCreateCompanionBuilder = ProgressEntriesCompanion
    Function({
  required String entityId,
  required String entityType,
  required String status,
  Value<int> score,
  Value<DateTime?> completedAt,
  Value<bool> finalTestPassed,
  Value<int> rowid,
});
typedef $$ProgressEntriesTableUpdateCompanionBuilder = ProgressEntriesCompanion
    Function({
  Value<String> entityId,
  Value<String> entityType,
  Value<String> status,
  Value<int> score,
  Value<DateTime?> completedAt,
  Value<bool> finalTestPassed,
  Value<int> rowid,
});

class $$ProgressEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $ProgressEntriesTable> {
  $$ProgressEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get entityId => $composableBuilder(
      column: $table.entityId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get entityType => $composableBuilder(
      column: $table.entityType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get score => $composableBuilder(
      column: $table.score, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get finalTestPassed => $composableBuilder(
      column: $table.finalTestPassed,
      builder: (column) => ColumnFilters(column));
}

class $$ProgressEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $ProgressEntriesTable> {
  $$ProgressEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get entityId => $composableBuilder(
      column: $table.entityId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get entityType => $composableBuilder(
      column: $table.entityType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get score => $composableBuilder(
      column: $table.score, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get finalTestPassed => $composableBuilder(
      column: $table.finalTestPassed,
      builder: (column) => ColumnOrderings(column));
}

class $$ProgressEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProgressEntriesTable> {
  $$ProgressEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get entityType => $composableBuilder(
      column: $table.entityType, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get score =>
      $composableBuilder(column: $table.score, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => column);

  GeneratedColumn<bool> get finalTestPassed => $composableBuilder(
      column: $table.finalTestPassed, builder: (column) => column);
}

class $$ProgressEntriesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ProgressEntriesTable,
    ProgressEntry,
    $$ProgressEntriesTableFilterComposer,
    $$ProgressEntriesTableOrderingComposer,
    $$ProgressEntriesTableAnnotationComposer,
    $$ProgressEntriesTableCreateCompanionBuilder,
    $$ProgressEntriesTableUpdateCompanionBuilder,
    (
      ProgressEntry,
      BaseReferences<_$AppDatabase, $ProgressEntriesTable, ProgressEntry>
    ),
    ProgressEntry,
    PrefetchHooks Function()> {
  $$ProgressEntriesTableTableManager(
      _$AppDatabase db, $ProgressEntriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProgressEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProgressEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProgressEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> entityId = const Value.absent(),
            Value<String> entityType = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<int> score = const Value.absent(),
            Value<DateTime?> completedAt = const Value.absent(),
            Value<bool> finalTestPassed = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ProgressEntriesCompanion(
            entityId: entityId,
            entityType: entityType,
            status: status,
            score: score,
            completedAt: completedAt,
            finalTestPassed: finalTestPassed,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String entityId,
            required String entityType,
            required String status,
            Value<int> score = const Value.absent(),
            Value<DateTime?> completedAt = const Value.absent(),
            Value<bool> finalTestPassed = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ProgressEntriesCompanion.insert(
            entityId: entityId,
            entityType: entityType,
            status: status,
            score: score,
            completedAt: completedAt,
            finalTestPassed: finalTestPassed,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ProgressEntriesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ProgressEntriesTable,
    ProgressEntry,
    $$ProgressEntriesTableFilterComposer,
    $$ProgressEntriesTableOrderingComposer,
    $$ProgressEntriesTableAnnotationComposer,
    $$ProgressEntriesTableCreateCompanionBuilder,
    $$ProgressEntriesTableUpdateCompanionBuilder,
    (
      ProgressEntry,
      BaseReferences<_$AppDatabase, $ProgressEntriesTable, ProgressEntry>
    ),
    ProgressEntry,
    PrefetchHooks Function()>;
typedef $$DictionaryEntriesTableCreateCompanionBuilder
    = DictionaryEntriesCompanion Function({
  required String wordId,
  Value<int> srsLevel,
  Value<int> repetitions,
  Value<int> intervalDays,
  Value<double> easeFactor,
  Value<DateTime?> nextReviewAt,
  Value<DateTime?> lastReviewedAt,
  Value<int> rowid,
});
typedef $$DictionaryEntriesTableUpdateCompanionBuilder
    = DictionaryEntriesCompanion Function({
  Value<String> wordId,
  Value<int> srsLevel,
  Value<int> repetitions,
  Value<int> intervalDays,
  Value<double> easeFactor,
  Value<DateTime?> nextReviewAt,
  Value<DateTime?> lastReviewedAt,
  Value<int> rowid,
});

class $$DictionaryEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $DictionaryEntriesTable> {
  $$DictionaryEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get wordId => $composableBuilder(
      column: $table.wordId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get srsLevel => $composableBuilder(
      column: $table.srsLevel, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get repetitions => $composableBuilder(
      column: $table.repetitions, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get intervalDays => $composableBuilder(
      column: $table.intervalDays, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get easeFactor => $composableBuilder(
      column: $table.easeFactor, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get nextReviewAt => $composableBuilder(
      column: $table.nextReviewAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastReviewedAt => $composableBuilder(
      column: $table.lastReviewedAt,
      builder: (column) => ColumnFilters(column));
}

class $$DictionaryEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $DictionaryEntriesTable> {
  $$DictionaryEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get wordId => $composableBuilder(
      column: $table.wordId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get srsLevel => $composableBuilder(
      column: $table.srsLevel, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get repetitions => $composableBuilder(
      column: $table.repetitions, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get intervalDays => $composableBuilder(
      column: $table.intervalDays,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get easeFactor => $composableBuilder(
      column: $table.easeFactor, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get nextReviewAt => $composableBuilder(
      column: $table.nextReviewAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastReviewedAt => $composableBuilder(
      column: $table.lastReviewedAt,
      builder: (column) => ColumnOrderings(column));
}

class $$DictionaryEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $DictionaryEntriesTable> {
  $$DictionaryEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get wordId =>
      $composableBuilder(column: $table.wordId, builder: (column) => column);

  GeneratedColumn<int> get srsLevel =>
      $composableBuilder(column: $table.srsLevel, builder: (column) => column);

  GeneratedColumn<int> get repetitions => $composableBuilder(
      column: $table.repetitions, builder: (column) => column);

  GeneratedColumn<int> get intervalDays => $composableBuilder(
      column: $table.intervalDays, builder: (column) => column);

  GeneratedColumn<double> get easeFactor => $composableBuilder(
      column: $table.easeFactor, builder: (column) => column);

  GeneratedColumn<DateTime> get nextReviewAt => $composableBuilder(
      column: $table.nextReviewAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastReviewedAt => $composableBuilder(
      column: $table.lastReviewedAt, builder: (column) => column);
}

class $$DictionaryEntriesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DictionaryEntriesTable,
    DictionaryEntry,
    $$DictionaryEntriesTableFilterComposer,
    $$DictionaryEntriesTableOrderingComposer,
    $$DictionaryEntriesTableAnnotationComposer,
    $$DictionaryEntriesTableCreateCompanionBuilder,
    $$DictionaryEntriesTableUpdateCompanionBuilder,
    (
      DictionaryEntry,
      BaseReferences<_$AppDatabase, $DictionaryEntriesTable, DictionaryEntry>
    ),
    DictionaryEntry,
    PrefetchHooks Function()> {
  $$DictionaryEntriesTableTableManager(
      _$AppDatabase db, $DictionaryEntriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DictionaryEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DictionaryEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DictionaryEntriesTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> wordId = const Value.absent(),
            Value<int> srsLevel = const Value.absent(),
            Value<int> repetitions = const Value.absent(),
            Value<int> intervalDays = const Value.absent(),
            Value<double> easeFactor = const Value.absent(),
            Value<DateTime?> nextReviewAt = const Value.absent(),
            Value<DateTime?> lastReviewedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              DictionaryEntriesCompanion(
            wordId: wordId,
            srsLevel: srsLevel,
            repetitions: repetitions,
            intervalDays: intervalDays,
            easeFactor: easeFactor,
            nextReviewAt: nextReviewAt,
            lastReviewedAt: lastReviewedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String wordId,
            Value<int> srsLevel = const Value.absent(),
            Value<int> repetitions = const Value.absent(),
            Value<int> intervalDays = const Value.absent(),
            Value<double> easeFactor = const Value.absent(),
            Value<DateTime?> nextReviewAt = const Value.absent(),
            Value<DateTime?> lastReviewedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              DictionaryEntriesCompanion.insert(
            wordId: wordId,
            srsLevel: srsLevel,
            repetitions: repetitions,
            intervalDays: intervalDays,
            easeFactor: easeFactor,
            nextReviewAt: nextReviewAt,
            lastReviewedAt: lastReviewedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$DictionaryEntriesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DictionaryEntriesTable,
    DictionaryEntry,
    $$DictionaryEntriesTableFilterComposer,
    $$DictionaryEntriesTableOrderingComposer,
    $$DictionaryEntriesTableAnnotationComposer,
    $$DictionaryEntriesTableCreateCompanionBuilder,
    $$DictionaryEntriesTableUpdateCompanionBuilder,
    (
      DictionaryEntry,
      BaseReferences<_$AppDatabase, $DictionaryEntriesTable, DictionaryEntry>
    ),
    DictionaryEntry,
    PrefetchHooks Function()>;
typedef $$CalligraphyEntriesTableCreateCompanionBuilder
    = CalligraphyEntriesCompanion Function({
  required String wordId,
  Value<int> attempts,
  Value<int> bestScore,
  Value<DateTime?> lastAttemptAt,
  Value<int> rowid,
});
typedef $$CalligraphyEntriesTableUpdateCompanionBuilder
    = CalligraphyEntriesCompanion Function({
  Value<String> wordId,
  Value<int> attempts,
  Value<int> bestScore,
  Value<DateTime?> lastAttemptAt,
  Value<int> rowid,
});

class $$CalligraphyEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $CalligraphyEntriesTable> {
  $$CalligraphyEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get wordId => $composableBuilder(
      column: $table.wordId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get attempts => $composableBuilder(
      column: $table.attempts, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get bestScore => $composableBuilder(
      column: $table.bestScore, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastAttemptAt => $composableBuilder(
      column: $table.lastAttemptAt, builder: (column) => ColumnFilters(column));
}

class $$CalligraphyEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $CalligraphyEntriesTable> {
  $$CalligraphyEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get wordId => $composableBuilder(
      column: $table.wordId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get attempts => $composableBuilder(
      column: $table.attempts, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get bestScore => $composableBuilder(
      column: $table.bestScore, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastAttemptAt => $composableBuilder(
      column: $table.lastAttemptAt,
      builder: (column) => ColumnOrderings(column));
}

class $$CalligraphyEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CalligraphyEntriesTable> {
  $$CalligraphyEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get wordId =>
      $composableBuilder(column: $table.wordId, builder: (column) => column);

  GeneratedColumn<int> get attempts =>
      $composableBuilder(column: $table.attempts, builder: (column) => column);

  GeneratedColumn<int> get bestScore =>
      $composableBuilder(column: $table.bestScore, builder: (column) => column);

  GeneratedColumn<DateTime> get lastAttemptAt => $composableBuilder(
      column: $table.lastAttemptAt, builder: (column) => column);
}

class $$CalligraphyEntriesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CalligraphyEntriesTable,
    CalligraphyEntry,
    $$CalligraphyEntriesTableFilterComposer,
    $$CalligraphyEntriesTableOrderingComposer,
    $$CalligraphyEntriesTableAnnotationComposer,
    $$CalligraphyEntriesTableCreateCompanionBuilder,
    $$CalligraphyEntriesTableUpdateCompanionBuilder,
    (
      CalligraphyEntry,
      BaseReferences<_$AppDatabase, $CalligraphyEntriesTable, CalligraphyEntry>
    ),
    CalligraphyEntry,
    PrefetchHooks Function()> {
  $$CalligraphyEntriesTableTableManager(
      _$AppDatabase db, $CalligraphyEntriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CalligraphyEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CalligraphyEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CalligraphyEntriesTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> wordId = const Value.absent(),
            Value<int> attempts = const Value.absent(),
            Value<int> bestScore = const Value.absent(),
            Value<DateTime?> lastAttemptAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CalligraphyEntriesCompanion(
            wordId: wordId,
            attempts: attempts,
            bestScore: bestScore,
            lastAttemptAt: lastAttemptAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String wordId,
            Value<int> attempts = const Value.absent(),
            Value<int> bestScore = const Value.absent(),
            Value<DateTime?> lastAttemptAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CalligraphyEntriesCompanion.insert(
            wordId: wordId,
            attempts: attempts,
            bestScore: bestScore,
            lastAttemptAt: lastAttemptAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CalligraphyEntriesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CalligraphyEntriesTable,
    CalligraphyEntry,
    $$CalligraphyEntriesTableFilterComposer,
    $$CalligraphyEntriesTableOrderingComposer,
    $$CalligraphyEntriesTableAnnotationComposer,
    $$CalligraphyEntriesTableCreateCompanionBuilder,
    $$CalligraphyEntriesTableUpdateCompanionBuilder,
    (
      CalligraphyEntry,
      BaseReferences<_$AppDatabase, $CalligraphyEntriesTable, CalligraphyEntry>
    ),
    CalligraphyEntry,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$BlocksTableTableManager get blocks =>
      $$BlocksTableTableManager(_db, _db.blocks);
  $$TopicsTableTableManager get topics =>
      $$TopicsTableTableManager(_db, _db.topics);
  $$SubtopicsTableTableManager get subtopics =>
      $$SubtopicsTableTableManager(_db, _db.subtopics);
  $$WordsTableTableManager get words =>
      $$WordsTableTableManager(_db, _db.words);
  $$ProgressEntriesTableTableManager get progressEntries =>
      $$ProgressEntriesTableTableManager(_db, _db.progressEntries);
  $$DictionaryEntriesTableTableManager get dictionaryEntries =>
      $$DictionaryEntriesTableTableManager(_db, _db.dictionaryEntries);
  $$CalligraphyEntriesTableTableManager get calligraphyEntries =>
      $$CalligraphyEntriesTableTableManager(_db, _db.calligraphyEntries);
}

mixin _$BlocksDaoMixin on DatabaseAccessor<AppDatabase> {
  $BlocksTable get blocks => attachedDatabase.blocks;
}
mixin _$TopicsDaoMixin on DatabaseAccessor<AppDatabase> {
  $TopicsTable get topics => attachedDatabase.topics;
}
mixin _$SubtopicsDaoMixin on DatabaseAccessor<AppDatabase> {
  $SubtopicsTable get subtopics => attachedDatabase.subtopics;
}
mixin _$WordsDaoMixin on DatabaseAccessor<AppDatabase> {
  $WordsTable get words => attachedDatabase.words;
}
mixin _$ProgressDaoMixin on DatabaseAccessor<AppDatabase> {
  $ProgressEntriesTable get progressEntries => attachedDatabase.progressEntries;
}
mixin _$DictionaryDaoMixin on DatabaseAccessor<AppDatabase> {
  $DictionaryEntriesTable get dictionaryEntries =>
      attachedDatabase.dictionaryEntries;
}
mixin _$CalligraphyDaoMixin on DatabaseAccessor<AppDatabase> {
  $CalligraphyEntriesTable get calligraphyEntries =>
      attachedDatabase.calligraphyEntries;
}
