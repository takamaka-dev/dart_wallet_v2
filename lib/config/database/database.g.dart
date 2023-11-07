// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $MetatransactionTable extends Metatransaction
    with TableInfo<$MetatransactionTable, MetatransactionData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MetatransactionTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _jsonhashMeta =
      const VerificationMeta('jsonhash');
  @override
  late final GeneratedColumn<String> jsonhash = GeneratedColumn<String>(
      'jsonhash', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 6, maxTextLength: 32),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _createdMeta =
      const VerificationMeta('created');
  @override
  late final GeneratedColumn<DateTime> created = GeneratedColumn<DateTime>(
      'created', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _solvedMeta = const VerificationMeta('solved');
  @override
  late final GeneratedColumn<DateTime> solved = GeneratedColumn<DateTime>(
      'solved', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _isSolvedMeta =
      const VerificationMeta('isSolved');
  @override
  late final GeneratedColumn<bool> isSolved = GeneratedColumn<bool>(
      'is_solved', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_solved" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [jsonhash, created, solved, isSolved];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'metatransaction';
  @override
  VerificationContext validateIntegrity(
      Insertable<MetatransactionData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('jsonhash')) {
      context.handle(_jsonhashMeta,
          jsonhash.isAcceptableOrUnknown(data['jsonhash']!, _jsonhashMeta));
    } else if (isInserting) {
      context.missing(_jsonhashMeta);
    }
    if (data.containsKey('created')) {
      context.handle(_createdMeta,
          created.isAcceptableOrUnknown(data['created']!, _createdMeta));
    }
    if (data.containsKey('solved')) {
      context.handle(_solvedMeta,
          solved.isAcceptableOrUnknown(data['solved']!, _solvedMeta));
    }
    if (data.containsKey('is_solved')) {
      context.handle(_isSolvedMeta,
          isSolved.isAcceptableOrUnknown(data['is_solved']!, _isSolvedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  MetatransactionData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MetatransactionData(
      jsonhash: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}jsonhash'])!,
      created: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created'])!,
      solved: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}solved']),
      isSolved: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_solved'])!,
    );
  }

  @override
  $MetatransactionTable createAlias(String alias) {
    return $MetatransactionTable(attachedDatabase, alias);
  }
}

class MetatransactionData extends DataClass
    implements Insertable<MetatransactionData> {
  final String jsonhash;
  final DateTime created;
  final DateTime? solved;
  final bool isSolved;
  const MetatransactionData(
      {required this.jsonhash,
      required this.created,
      this.solved,
      required this.isSolved});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['jsonhash'] = Variable<String>(jsonhash);
    map['created'] = Variable<DateTime>(created);
    if (!nullToAbsent || solved != null) {
      map['solved'] = Variable<DateTime>(solved);
    }
    map['is_solved'] = Variable<bool>(isSolved);
    return map;
  }

  MetatransactionCompanion toCompanion(bool nullToAbsent) {
    return MetatransactionCompanion(
      jsonhash: Value(jsonhash),
      created: Value(created),
      solved:
          solved == null && nullToAbsent ? const Value.absent() : Value(solved),
      isSolved: Value(isSolved),
    );
  }

  factory MetatransactionData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MetatransactionData(
      jsonhash: serializer.fromJson<String>(json['jsonhash']),
      created: serializer.fromJson<DateTime>(json['created']),
      solved: serializer.fromJson<DateTime?>(json['solved']),
      isSolved: serializer.fromJson<bool>(json['isSolved']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'jsonhash': serializer.toJson<String>(jsonhash),
      'created': serializer.toJson<DateTime>(created),
      'solved': serializer.toJson<DateTime?>(solved),
      'isSolved': serializer.toJson<bool>(isSolved),
    };
  }

  MetatransactionData copyWith(
          {String? jsonhash,
          DateTime? created,
          Value<DateTime?> solved = const Value.absent(),
          bool? isSolved}) =>
      MetatransactionData(
        jsonhash: jsonhash ?? this.jsonhash,
        created: created ?? this.created,
        solved: solved.present ? solved.value : this.solved,
        isSolved: isSolved ?? this.isSolved,
      );
  @override
  String toString() {
    return (StringBuffer('MetatransactionData(')
          ..write('jsonhash: $jsonhash, ')
          ..write('created: $created, ')
          ..write('solved: $solved, ')
          ..write('isSolved: $isSolved')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(jsonhash, created, solved, isSolved);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MetatransactionData &&
          other.jsonhash == this.jsonhash &&
          other.created == this.created &&
          other.solved == this.solved &&
          other.isSolved == this.isSolved);
}

class MetatransactionCompanion extends UpdateCompanion<MetatransactionData> {
  final Value<String> jsonhash;
  final Value<DateTime> created;
  final Value<DateTime?> solved;
  final Value<bool> isSolved;
  final Value<int> rowid;
  const MetatransactionCompanion({
    this.jsonhash = const Value.absent(),
    this.created = const Value.absent(),
    this.solved = const Value.absent(),
    this.isSolved = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MetatransactionCompanion.insert({
    required String jsonhash,
    this.created = const Value.absent(),
    this.solved = const Value.absent(),
    this.isSolved = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : jsonhash = Value(jsonhash);
  static Insertable<MetatransactionData> custom({
    Expression<String>? jsonhash,
    Expression<DateTime>? created,
    Expression<DateTime>? solved,
    Expression<bool>? isSolved,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (jsonhash != null) 'jsonhash': jsonhash,
      if (created != null) 'created': created,
      if (solved != null) 'solved': solved,
      if (isSolved != null) 'is_solved': isSolved,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MetatransactionCompanion copyWith(
      {Value<String>? jsonhash,
      Value<DateTime>? created,
      Value<DateTime?>? solved,
      Value<bool>? isSolved,
      Value<int>? rowid}) {
    return MetatransactionCompanion(
      jsonhash: jsonhash ?? this.jsonhash,
      created: created ?? this.created,
      solved: solved ?? this.solved,
      isSolved: isSolved ?? this.isSolved,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (jsonhash.present) {
      map['jsonhash'] = Variable<String>(jsonhash.value);
    }
    if (created.present) {
      map['created'] = Variable<DateTime>(created.value);
    }
    if (solved.present) {
      map['solved'] = Variable<DateTime>(solved.value);
    }
    if (isSolved.present) {
      map['is_solved'] = Variable<bool>(isSolved.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MetatransactionCompanion(')
          ..write('jsonhash: $jsonhash, ')
          ..write('created: $created, ')
          ..write('solved: $solved, ')
          ..write('isSolved: $isSolved, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  late final $MetatransactionTable metatransaction =
      $MetatransactionTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [metatransaction];
}
