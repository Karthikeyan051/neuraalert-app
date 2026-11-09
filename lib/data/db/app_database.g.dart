// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $MedicinesTable extends Medicines
    with TableInfo<$MedicinesTable, Medicine> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MedicinesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 120,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _doseNoteMeta = const VerificationMeta(
    'doseNote',
  );
  @override
  late final GeneratedColumn<String> doseNote = GeneratedColumn<String>(
    'dose_note',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _foodRelationMeta = const VerificationMeta(
    'foodRelation',
  );
  @override
  late final GeneratedColumn<String> foodRelation = GeneratedColumn<String>(
    'food_relation',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('none'),
  );
  static const VerificationMeta _stockCountMeta = const VerificationMeta(
    'stockCount',
  );
  @override
  late final GeneratedColumn<int> stockCount = GeneratedColumn<int>(
    'stock_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(-1),
  );
  static const VerificationMeta _unitsPerDoseMeta = const VerificationMeta(
    'unitsPerDose',
  );
  @override
  late final GeneratedColumn<double> unitsPerDose = GeneratedColumn<double>(
    'units_per_dose',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(1.0),
  );
  static const VerificationMeta _refillThresholdDaysMeta =
      const VerificationMeta('refillThresholdDays');
  @override
  late final GeneratedColumn<int> refillThresholdDays = GeneratedColumn<int>(
    'refill_threshold_days',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(7),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    doseNote,
    foodRelation,
    stockCount,
    unitsPerDose,
    refillThresholdDays,
    createdAt,
    updatedAt,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'medicines';
  @override
  VerificationContext validateIntegrity(
    Insertable<Medicine> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('dose_note')) {
      context.handle(
        _doseNoteMeta,
        doseNote.isAcceptableOrUnknown(data['dose_note']!, _doseNoteMeta),
      );
    }
    if (data.containsKey('food_relation')) {
      context.handle(
        _foodRelationMeta,
        foodRelation.isAcceptableOrUnknown(
          data['food_relation']!,
          _foodRelationMeta,
        ),
      );
    }
    if (data.containsKey('stock_count')) {
      context.handle(
        _stockCountMeta,
        stockCount.isAcceptableOrUnknown(data['stock_count']!, _stockCountMeta),
      );
    }
    if (data.containsKey('units_per_dose')) {
      context.handle(
        _unitsPerDoseMeta,
        unitsPerDose.isAcceptableOrUnknown(
          data['units_per_dose']!,
          _unitsPerDoseMeta,
        ),
      );
    }
    if (data.containsKey('refill_threshold_days')) {
      context.handle(
        _refillThresholdDaysMeta,
        refillThresholdDays.isAcceptableOrUnknown(
          data['refill_threshold_days']!,
          _refillThresholdDaysMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Medicine map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Medicine(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      doseNote: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}dose_note'],
      )!,
      foodRelation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}food_relation'],
      )!,
      stockCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}stock_count'],
      )!,
      unitsPerDose: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}units_per_dose'],
      )!,
      refillThresholdDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}refill_threshold_days'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  $MedicinesTable createAlias(String alias) {
    return $MedicinesTable(attachedDatabase, alias);
  }
}

class Medicine extends DataClass implements Insertable<Medicine> {
  final String id;
  final String name;
  final String doseNote;
  final String foodRelation;
  final int stockCount;
  final double unitsPerDose;
  final int refillThresholdDays;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  const Medicine({
    required this.id,
    required this.name,
    required this.doseNote,
    required this.foodRelation,
    required this.stockCount,
    required this.unitsPerDose,
    required this.refillThresholdDays,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['dose_note'] = Variable<String>(doseNote);
    map['food_relation'] = Variable<String>(foodRelation);
    map['stock_count'] = Variable<int>(stockCount);
    map['units_per_dose'] = Variable<double>(unitsPerDose);
    map['refill_threshold_days'] = Variable<int>(refillThresholdDays);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  MedicinesCompanion toCompanion(bool nullToAbsent) {
    return MedicinesCompanion(
      id: Value(id),
      name: Value(name),
      doseNote: Value(doseNote),
      foodRelation: Value(foodRelation),
      stockCount: Value(stockCount),
      unitsPerDose: Value(unitsPerDose),
      refillThresholdDays: Value(refillThresholdDays),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory Medicine.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Medicine(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      doseNote: serializer.fromJson<String>(json['doseNote']),
      foodRelation: serializer.fromJson<String>(json['foodRelation']),
      stockCount: serializer.fromJson<int>(json['stockCount']),
      unitsPerDose: serializer.fromJson<double>(json['unitsPerDose']),
      refillThresholdDays: serializer.fromJson<int>(
        json['refillThresholdDays'],
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'doseNote': serializer.toJson<String>(doseNote),
      'foodRelation': serializer.toJson<String>(foodRelation),
      'stockCount': serializer.toJson<int>(stockCount),
      'unitsPerDose': serializer.toJson<double>(unitsPerDose),
      'refillThresholdDays': serializer.toJson<int>(refillThresholdDays),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  Medicine copyWith({
    String? id,
    String? name,
    String? doseNote,
    String? foodRelation,
    int? stockCount,
    double? unitsPerDose,
    int? refillThresholdDays,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
  }) => Medicine(
    id: id ?? this.id,
    name: name ?? this.name,
    doseNote: doseNote ?? this.doseNote,
    foodRelation: foodRelation ?? this.foodRelation,
    stockCount: stockCount ?? this.stockCount,
    unitsPerDose: unitsPerDose ?? this.unitsPerDose,
    refillThresholdDays: refillThresholdDays ?? this.refillThresholdDays,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  Medicine copyWithCompanion(MedicinesCompanion data) {
    return Medicine(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      doseNote: data.doseNote.present ? data.doseNote.value : this.doseNote,
      foodRelation: data.foodRelation.present
          ? data.foodRelation.value
          : this.foodRelation,
      stockCount: data.stockCount.present
          ? data.stockCount.value
          : this.stockCount,
      unitsPerDose: data.unitsPerDose.present
          ? data.unitsPerDose.value
          : this.unitsPerDose,
      refillThresholdDays: data.refillThresholdDays.present
          ? data.refillThresholdDays.value
          : this.refillThresholdDays,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Medicine(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('doseNote: $doseNote, ')
          ..write('foodRelation: $foodRelation, ')
          ..write('stockCount: $stockCount, ')
          ..write('unitsPerDose: $unitsPerDose, ')
          ..write('refillThresholdDays: $refillThresholdDays, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    doseNote,
    foodRelation,
    stockCount,
    unitsPerDose,
    refillThresholdDays,
    createdAt,
    updatedAt,
    deletedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Medicine &&
          other.id == this.id &&
          other.name == this.name &&
          other.doseNote == this.doseNote &&
          other.foodRelation == this.foodRelation &&
          other.stockCount == this.stockCount &&
          other.unitsPerDose == this.unitsPerDose &&
          other.refillThresholdDays == this.refillThresholdDays &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt);
}

class MedicinesCompanion extends UpdateCompanion<Medicine> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> doseNote;
  final Value<String> foodRelation;
  final Value<int> stockCount;
  final Value<double> unitsPerDose;
  final Value<int> refillThresholdDays;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const MedicinesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.doseNote = const Value.absent(),
    this.foodRelation = const Value.absent(),
    this.stockCount = const Value.absent(),
    this.unitsPerDose = const Value.absent(),
    this.refillThresholdDays = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MedicinesCompanion.insert({
    required String id,
    required String name,
    this.doseNote = const Value.absent(),
    this.foodRelation = const Value.absent(),
    this.stockCount = const Value.absent(),
    this.unitsPerDose = const Value.absent(),
    this.refillThresholdDays = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name);
  static Insertable<Medicine> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? doseNote,
    Expression<String>? foodRelation,
    Expression<int>? stockCount,
    Expression<double>? unitsPerDose,
    Expression<int>? refillThresholdDays,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (doseNote != null) 'dose_note': doseNote,
      if (foodRelation != null) 'food_relation': foodRelation,
      if (stockCount != null) 'stock_count': stockCount,
      if (unitsPerDose != null) 'units_per_dose': unitsPerDose,
      if (refillThresholdDays != null)
        'refill_threshold_days': refillThresholdDays,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MedicinesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? doseNote,
    Value<String>? foodRelation,
    Value<int>? stockCount,
    Value<double>? unitsPerDose,
    Value<int>? refillThresholdDays,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<int>? rowid,
  }) {
    return MedicinesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      doseNote: doseNote ?? this.doseNote,
      foodRelation: foodRelation ?? this.foodRelation,
      stockCount: stockCount ?? this.stockCount,
      unitsPerDose: unitsPerDose ?? this.unitsPerDose,
      refillThresholdDays: refillThresholdDays ?? this.refillThresholdDays,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (doseNote.present) {
      map['dose_note'] = Variable<String>(doseNote.value);
    }
    if (foodRelation.present) {
      map['food_relation'] = Variable<String>(foodRelation.value);
    }
    if (stockCount.present) {
      map['stock_count'] = Variable<int>(stockCount.value);
    }
    if (unitsPerDose.present) {
      map['units_per_dose'] = Variable<double>(unitsPerDose.value);
    }
    if (refillThresholdDays.present) {
      map['refill_threshold_days'] = Variable<int>(refillThresholdDays.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MedicinesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('doseNote: $doseNote, ')
          ..write('foodRelation: $foodRelation, ')
          ..write('stockCount: $stockCount, ')
          ..write('unitsPerDose: $unitsPerDose, ')
          ..write('refillThresholdDays: $refillThresholdDays, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SchedulesTable extends Schedules
    with TableInfo<$SchedulesTable, Schedule> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SchedulesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _medicineIdMeta = const VerificationMeta(
    'medicineId',
  );
  @override
  late final GeneratedColumn<String> medicineId = GeneratedColumn<String>(
    'medicine_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES medicines (id)',
    ),
  );
  static const VerificationMeta _alertTypeMeta = const VerificationMeta(
    'alertType',
  );
  @override
  late final GeneratedColumn<String> alertType = GeneratedColumn<String>(
    'alert_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('medicine'),
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 120,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timeMinutesMeta = const VerificationMeta(
    'timeMinutes',
  );
  @override
  late final GeneratedColumn<int> timeMinutes = GeneratedColumn<int>(
    'time_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _daysMaskMeta = const VerificationMeta(
    'daysMask',
  );
  @override
  late final GeneratedColumn<int> daysMask = GeneratedColumn<int>(
    'days_mask',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(127),
  );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
    'start_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endDateMeta = const VerificationMeta(
    'endDate',
  );
  @override
  late final GeneratedColumn<DateTime> endDate = GeneratedColumn<DateTime>(
    'end_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _enabledMeta = const VerificationMeta(
    'enabled',
  );
  @override
  late final GeneratedColumn<bool> enabled = GeneratedColumn<bool>(
    'enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _voiceLangMeta = const VerificationMeta(
    'voiceLang',
  );
  @override
  late final GeneratedColumn<String> voiceLang = GeneratedColumn<String>(
    'voice_lang',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('ta'),
  );
  static const VerificationMeta _voiceFilePathMeta = const VerificationMeta(
    'voiceFilePath',
  );
  @override
  late final GeneratedColumn<String> voiceFilePath = GeneratedColumn<String>(
    'voice_file_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    medicineId,
    alertType,
    label,
    timeMinutes,
    daysMask,
    startDate,
    endDate,
    enabled,
    voiceLang,
    voiceFilePath,
    updatedAt,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'schedules';
  @override
  VerificationContext validateIntegrity(
    Insertable<Schedule> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('medicine_id')) {
      context.handle(
        _medicineIdMeta,
        medicineId.isAcceptableOrUnknown(data['medicine_id']!, _medicineIdMeta),
      );
    }
    if (data.containsKey('alert_type')) {
      context.handle(
        _alertTypeMeta,
        alertType.isAcceptableOrUnknown(data['alert_type']!, _alertTypeMeta),
      );
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('time_minutes')) {
      context.handle(
        _timeMinutesMeta,
        timeMinutes.isAcceptableOrUnknown(
          data['time_minutes']!,
          _timeMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_timeMinutesMeta);
    }
    if (data.containsKey('days_mask')) {
      context.handle(
        _daysMaskMeta,
        daysMask.isAcceptableOrUnknown(data['days_mask']!, _daysMaskMeta),
      );
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('end_date')) {
      context.handle(
        _endDateMeta,
        endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta),
      );
    }
    if (data.containsKey('enabled')) {
      context.handle(
        _enabledMeta,
        enabled.isAcceptableOrUnknown(data['enabled']!, _enabledMeta),
      );
    }
    if (data.containsKey('voice_lang')) {
      context.handle(
        _voiceLangMeta,
        voiceLang.isAcceptableOrUnknown(data['voice_lang']!, _voiceLangMeta),
      );
    }
    if (data.containsKey('voice_file_path')) {
      context.handle(
        _voiceFilePathMeta,
        voiceFilePath.isAcceptableOrUnknown(
          data['voice_file_path']!,
          _voiceFilePathMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Schedule map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Schedule(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      medicineId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}medicine_id'],
      ),
      alertType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}alert_type'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      )!,
      timeMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}time_minutes'],
      )!,
      daysMask: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}days_mask'],
      )!,
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_date'],
      )!,
      endDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end_date'],
      ),
      enabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}enabled'],
      )!,
      voiceLang: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}voice_lang'],
      )!,
      voiceFilePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}voice_file_path'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  $SchedulesTable createAlias(String alias) {
    return $SchedulesTable(attachedDatabase, alias);
  }
}

class Schedule extends DataClass implements Insertable<Schedule> {
  final String id;
  final String? medicineId;
  final String alertType;
  final String label;
  final int timeMinutes;
  final int daysMask;
  final DateTime startDate;
  final DateTime? endDate;
  final bool enabled;
  final String voiceLang;
  final String voiceFilePath;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  const Schedule({
    required this.id,
    this.medicineId,
    required this.alertType,
    required this.label,
    required this.timeMinutes,
    required this.daysMask,
    required this.startDate,
    this.endDate,
    required this.enabled,
    required this.voiceLang,
    required this.voiceFilePath,
    required this.updatedAt,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || medicineId != null) {
      map['medicine_id'] = Variable<String>(medicineId);
    }
    map['alert_type'] = Variable<String>(alertType);
    map['label'] = Variable<String>(label);
    map['time_minutes'] = Variable<int>(timeMinutes);
    map['days_mask'] = Variable<int>(daysMask);
    map['start_date'] = Variable<DateTime>(startDate);
    if (!nullToAbsent || endDate != null) {
      map['end_date'] = Variable<DateTime>(endDate);
    }
    map['enabled'] = Variable<bool>(enabled);
    map['voice_lang'] = Variable<String>(voiceLang);
    map['voice_file_path'] = Variable<String>(voiceFilePath);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  SchedulesCompanion toCompanion(bool nullToAbsent) {
    return SchedulesCompanion(
      id: Value(id),
      medicineId: medicineId == null && nullToAbsent
          ? const Value.absent()
          : Value(medicineId),
      alertType: Value(alertType),
      label: Value(label),
      timeMinutes: Value(timeMinutes),
      daysMask: Value(daysMask),
      startDate: Value(startDate),
      endDate: endDate == null && nullToAbsent
          ? const Value.absent()
          : Value(endDate),
      enabled: Value(enabled),
      voiceLang: Value(voiceLang),
      voiceFilePath: Value(voiceFilePath),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory Schedule.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Schedule(
      id: serializer.fromJson<String>(json['id']),
      medicineId: serializer.fromJson<String?>(json['medicineId']),
      alertType: serializer.fromJson<String>(json['alertType']),
      label: serializer.fromJson<String>(json['label']),
      timeMinutes: serializer.fromJson<int>(json['timeMinutes']),
      daysMask: serializer.fromJson<int>(json['daysMask']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      endDate: serializer.fromJson<DateTime?>(json['endDate']),
      enabled: serializer.fromJson<bool>(json['enabled']),
      voiceLang: serializer.fromJson<String>(json['voiceLang']),
      voiceFilePath: serializer.fromJson<String>(json['voiceFilePath']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'medicineId': serializer.toJson<String?>(medicineId),
      'alertType': serializer.toJson<String>(alertType),
      'label': serializer.toJson<String>(label),
      'timeMinutes': serializer.toJson<int>(timeMinutes),
      'daysMask': serializer.toJson<int>(daysMask),
      'startDate': serializer.toJson<DateTime>(startDate),
      'endDate': serializer.toJson<DateTime?>(endDate),
      'enabled': serializer.toJson<bool>(enabled),
      'voiceLang': serializer.toJson<String>(voiceLang),
      'voiceFilePath': serializer.toJson<String>(voiceFilePath),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  Schedule copyWith({
    String? id,
    Value<String?> medicineId = const Value.absent(),
    String? alertType,
    String? label,
    int? timeMinutes,
    int? daysMask,
    DateTime? startDate,
    Value<DateTime?> endDate = const Value.absent(),
    bool? enabled,
    String? voiceLang,
    String? voiceFilePath,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
  }) => Schedule(
    id: id ?? this.id,
    medicineId: medicineId.present ? medicineId.value : this.medicineId,
    alertType: alertType ?? this.alertType,
    label: label ?? this.label,
    timeMinutes: timeMinutes ?? this.timeMinutes,
    daysMask: daysMask ?? this.daysMask,
    startDate: startDate ?? this.startDate,
    endDate: endDate.present ? endDate.value : this.endDate,
    enabled: enabled ?? this.enabled,
    voiceLang: voiceLang ?? this.voiceLang,
    voiceFilePath: voiceFilePath ?? this.voiceFilePath,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  Schedule copyWithCompanion(SchedulesCompanion data) {
    return Schedule(
      id: data.id.present ? data.id.value : this.id,
      medicineId: data.medicineId.present
          ? data.medicineId.value
          : this.medicineId,
      alertType: data.alertType.present ? data.alertType.value : this.alertType,
      label: data.label.present ? data.label.value : this.label,
      timeMinutes: data.timeMinutes.present
          ? data.timeMinutes.value
          : this.timeMinutes,
      daysMask: data.daysMask.present ? data.daysMask.value : this.daysMask,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      enabled: data.enabled.present ? data.enabled.value : this.enabled,
      voiceLang: data.voiceLang.present ? data.voiceLang.value : this.voiceLang,
      voiceFilePath: data.voiceFilePath.present
          ? data.voiceFilePath.value
          : this.voiceFilePath,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Schedule(')
          ..write('id: $id, ')
          ..write('medicineId: $medicineId, ')
          ..write('alertType: $alertType, ')
          ..write('label: $label, ')
          ..write('timeMinutes: $timeMinutes, ')
          ..write('daysMask: $daysMask, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('enabled: $enabled, ')
          ..write('voiceLang: $voiceLang, ')
          ..write('voiceFilePath: $voiceFilePath, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    medicineId,
    alertType,
    label,
    timeMinutes,
    daysMask,
    startDate,
    endDate,
    enabled,
    voiceLang,
    voiceFilePath,
    updatedAt,
    deletedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Schedule &&
          other.id == this.id &&
          other.medicineId == this.medicineId &&
          other.alertType == this.alertType &&
          other.label == this.label &&
          other.timeMinutes == this.timeMinutes &&
          other.daysMask == this.daysMask &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.enabled == this.enabled &&
          other.voiceLang == this.voiceLang &&
          other.voiceFilePath == this.voiceFilePath &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt);
}

class SchedulesCompanion extends UpdateCompanion<Schedule> {
  final Value<String> id;
  final Value<String?> medicineId;
  final Value<String> alertType;
  final Value<String> label;
  final Value<int> timeMinutes;
  final Value<int> daysMask;
  final Value<DateTime> startDate;
  final Value<DateTime?> endDate;
  final Value<bool> enabled;
  final Value<String> voiceLang;
  final Value<String> voiceFilePath;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const SchedulesCompanion({
    this.id = const Value.absent(),
    this.medicineId = const Value.absent(),
    this.alertType = const Value.absent(),
    this.label = const Value.absent(),
    this.timeMinutes = const Value.absent(),
    this.daysMask = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.enabled = const Value.absent(),
    this.voiceLang = const Value.absent(),
    this.voiceFilePath = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SchedulesCompanion.insert({
    required String id,
    this.medicineId = const Value.absent(),
    this.alertType = const Value.absent(),
    required String label,
    required int timeMinutes,
    this.daysMask = const Value.absent(),
    required DateTime startDate,
    this.endDate = const Value.absent(),
    this.enabled = const Value.absent(),
    this.voiceLang = const Value.absent(),
    this.voiceFilePath = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       label = Value(label),
       timeMinutes = Value(timeMinutes),
       startDate = Value(startDate);
  static Insertable<Schedule> custom({
    Expression<String>? id,
    Expression<String>? medicineId,
    Expression<String>? alertType,
    Expression<String>? label,
    Expression<int>? timeMinutes,
    Expression<int>? daysMask,
    Expression<DateTime>? startDate,
    Expression<DateTime>? endDate,
    Expression<bool>? enabled,
    Expression<String>? voiceLang,
    Expression<String>? voiceFilePath,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (medicineId != null) 'medicine_id': medicineId,
      if (alertType != null) 'alert_type': alertType,
      if (label != null) 'label': label,
      if (timeMinutes != null) 'time_minutes': timeMinutes,
      if (daysMask != null) 'days_mask': daysMask,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (enabled != null) 'enabled': enabled,
      if (voiceLang != null) 'voice_lang': voiceLang,
      if (voiceFilePath != null) 'voice_file_path': voiceFilePath,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SchedulesCompanion copyWith({
    Value<String>? id,
    Value<String?>? medicineId,
    Value<String>? alertType,
    Value<String>? label,
    Value<int>? timeMinutes,
    Value<int>? daysMask,
    Value<DateTime>? startDate,
    Value<DateTime?>? endDate,
    Value<bool>? enabled,
    Value<String>? voiceLang,
    Value<String>? voiceFilePath,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<int>? rowid,
  }) {
    return SchedulesCompanion(
      id: id ?? this.id,
      medicineId: medicineId ?? this.medicineId,
      alertType: alertType ?? this.alertType,
      label: label ?? this.label,
      timeMinutes: timeMinutes ?? this.timeMinutes,
      daysMask: daysMask ?? this.daysMask,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      enabled: enabled ?? this.enabled,
      voiceLang: voiceLang ?? this.voiceLang,
      voiceFilePath: voiceFilePath ?? this.voiceFilePath,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (medicineId.present) {
      map['medicine_id'] = Variable<String>(medicineId.value);
    }
    if (alertType.present) {
      map['alert_type'] = Variable<String>(alertType.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (timeMinutes.present) {
      map['time_minutes'] = Variable<int>(timeMinutes.value);
    }
    if (daysMask.present) {
      map['days_mask'] = Variable<int>(daysMask.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<DateTime>(endDate.value);
    }
    if (enabled.present) {
      map['enabled'] = Variable<bool>(enabled.value);
    }
    if (voiceLang.present) {
      map['voice_lang'] = Variable<String>(voiceLang.value);
    }
    if (voiceFilePath.present) {
      map['voice_file_path'] = Variable<String>(voiceFilePath.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SchedulesCompanion(')
          ..write('id: $id, ')
          ..write('medicineId: $medicineId, ')
          ..write('alertType: $alertType, ')
          ..write('label: $label, ')
          ..write('timeMinutes: $timeMinutes, ')
          ..write('daysMask: $daysMask, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('enabled: $enabled, ')
          ..write('voiceLang: $voiceLang, ')
          ..write('voiceFilePath: $voiceFilePath, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DoseLogsTable extends DoseLogs with TableInfo<$DoseLogsTable, DoseLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DoseLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _scheduleIdMeta = const VerificationMeta(
    'scheduleId',
  );
  @override
  late final GeneratedColumn<String> scheduleId = GeneratedColumn<String>(
    'schedule_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES schedules (id)',
    ),
  );
  static const VerificationMeta _scheduledAtMeta = const VerificationMeta(
    'scheduledAt',
  );
  @override
  late final GeneratedColumn<DateTime> scheduledAt = GeneratedColumn<DateTime>(
    'scheduled_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _actedAtMeta = const VerificationMeta(
    'actedAt',
  );
  @override
  late final GeneratedColumn<DateTime> actedAt = GeneratedColumn<DateTime>(
    'acted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    scheduleId,
    scheduledAt,
    status,
    actedAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'dose_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<DoseLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('schedule_id')) {
      context.handle(
        _scheduleIdMeta,
        scheduleId.isAcceptableOrUnknown(data['schedule_id']!, _scheduleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_scheduleIdMeta);
    }
    if (data.containsKey('scheduled_at')) {
      context.handle(
        _scheduledAtMeta,
        scheduledAt.isAcceptableOrUnknown(
          data['scheduled_at']!,
          _scheduledAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_scheduledAtMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('acted_at')) {
      context.handle(
        _actedAtMeta,
        actedAt.isAcceptableOrUnknown(data['acted_at']!, _actedAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DoseLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DoseLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      scheduleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}schedule_id'],
      )!,
      scheduledAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}scheduled_at'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      actedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}acted_at'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $DoseLogsTable createAlias(String alias) {
    return $DoseLogsTable(attachedDatabase, alias);
  }
}

class DoseLog extends DataClass implements Insertable<DoseLog> {
  final String id;
  final String scheduleId;
  final DateTime scheduledAt;
  final String status;
  final DateTime? actedAt;
  final DateTime updatedAt;
  const DoseLog({
    required this.id,
    required this.scheduleId,
    required this.scheduledAt,
    required this.status,
    this.actedAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['schedule_id'] = Variable<String>(scheduleId);
    map['scheduled_at'] = Variable<DateTime>(scheduledAt);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || actedAt != null) {
      map['acted_at'] = Variable<DateTime>(actedAt);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  DoseLogsCompanion toCompanion(bool nullToAbsent) {
    return DoseLogsCompanion(
      id: Value(id),
      scheduleId: Value(scheduleId),
      scheduledAt: Value(scheduledAt),
      status: Value(status),
      actedAt: actedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(actedAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory DoseLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DoseLog(
      id: serializer.fromJson<String>(json['id']),
      scheduleId: serializer.fromJson<String>(json['scheduleId']),
      scheduledAt: serializer.fromJson<DateTime>(json['scheduledAt']),
      status: serializer.fromJson<String>(json['status']),
      actedAt: serializer.fromJson<DateTime?>(json['actedAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'scheduleId': serializer.toJson<String>(scheduleId),
      'scheduledAt': serializer.toJson<DateTime>(scheduledAt),
      'status': serializer.toJson<String>(status),
      'actedAt': serializer.toJson<DateTime?>(actedAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  DoseLog copyWith({
    String? id,
    String? scheduleId,
    DateTime? scheduledAt,
    String? status,
    Value<DateTime?> actedAt = const Value.absent(),
    DateTime? updatedAt,
  }) => DoseLog(
    id: id ?? this.id,
    scheduleId: scheduleId ?? this.scheduleId,
    scheduledAt: scheduledAt ?? this.scheduledAt,
    status: status ?? this.status,
    actedAt: actedAt.present ? actedAt.value : this.actedAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  DoseLog copyWithCompanion(DoseLogsCompanion data) {
    return DoseLog(
      id: data.id.present ? data.id.value : this.id,
      scheduleId: data.scheduleId.present
          ? data.scheduleId.value
          : this.scheduleId,
      scheduledAt: data.scheduledAt.present
          ? data.scheduledAt.value
          : this.scheduledAt,
      status: data.status.present ? data.status.value : this.status,
      actedAt: data.actedAt.present ? data.actedAt.value : this.actedAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DoseLog(')
          ..write('id: $id, ')
          ..write('scheduleId: $scheduleId, ')
          ..write('scheduledAt: $scheduledAt, ')
          ..write('status: $status, ')
          ..write('actedAt: $actedAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, scheduleId, scheduledAt, status, actedAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DoseLog &&
          other.id == this.id &&
          other.scheduleId == this.scheduleId &&
          other.scheduledAt == this.scheduledAt &&
          other.status == this.status &&
          other.actedAt == this.actedAt &&
          other.updatedAt == this.updatedAt);
}

class DoseLogsCompanion extends UpdateCompanion<DoseLog> {
  final Value<String> id;
  final Value<String> scheduleId;
  final Value<DateTime> scheduledAt;
  final Value<String> status;
  final Value<DateTime?> actedAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const DoseLogsCompanion({
    this.id = const Value.absent(),
    this.scheduleId = const Value.absent(),
    this.scheduledAt = const Value.absent(),
    this.status = const Value.absent(),
    this.actedAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DoseLogsCompanion.insert({
    required String id,
    required String scheduleId,
    required DateTime scheduledAt,
    required String status,
    this.actedAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       scheduleId = Value(scheduleId),
       scheduledAt = Value(scheduledAt),
       status = Value(status);
  static Insertable<DoseLog> custom({
    Expression<String>? id,
    Expression<String>? scheduleId,
    Expression<DateTime>? scheduledAt,
    Expression<String>? status,
    Expression<DateTime>? actedAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (scheduleId != null) 'schedule_id': scheduleId,
      if (scheduledAt != null) 'scheduled_at': scheduledAt,
      if (status != null) 'status': status,
      if (actedAt != null) 'acted_at': actedAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DoseLogsCompanion copyWith({
    Value<String>? id,
    Value<String>? scheduleId,
    Value<DateTime>? scheduledAt,
    Value<String>? status,
    Value<DateTime?>? actedAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return DoseLogsCompanion(
      id: id ?? this.id,
      scheduleId: scheduleId ?? this.scheduleId,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      status: status ?? this.status,
      actedAt: actedAt ?? this.actedAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (scheduleId.present) {
      map['schedule_id'] = Variable<String>(scheduleId.value);
    }
    if (scheduledAt.present) {
      map['scheduled_at'] = Variable<DateTime>(scheduledAt.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (actedAt.present) {
      map['acted_at'] = Variable<DateTime>(actedAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DoseLogsCompanion(')
          ..write('id: $id, ')
          ..write('scheduleId: $scheduleId, ')
          ..write('scheduledAt: $scheduledAt, ')
          ..write('status: $status, ')
          ..write('actedAt: $actedAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ScheduledAlarmsTable extends ScheduledAlarms
    with TableInfo<$ScheduledAlarmsTable, ScheduledAlarm> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ScheduledAlarmsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _alarmIdMeta = const VerificationMeta(
    'alarmId',
  );
  @override
  late final GeneratedColumn<int> alarmId = GeneratedColumn<int>(
    'alarm_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _scheduleIdMeta = const VerificationMeta(
    'scheduleId',
  );
  @override
  late final GeneratedColumn<String> scheduleId = GeneratedColumn<String>(
    'schedule_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES schedules (id)',
    ),
  );
  static const VerificationMeta _fireAtMeta = const VerificationMeta('fireAt');
  @override
  late final GeneratedColumn<DateTime> fireAt = GeneratedColumn<DateTime>(
    'fire_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _voiceFilePathMeta = const VerificationMeta(
    'voiceFilePath',
  );
  @override
  late final GeneratedColumn<String> voiceFilePath = GeneratedColumn<String>(
    'voice_file_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  List<GeneratedColumn> get $columns => [
    alarmId,
    scheduleId,
    fireAt,
    voiceFilePath,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'scheduled_alarms';
  @override
  VerificationContext validateIntegrity(
    Insertable<ScheduledAlarm> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('alarm_id')) {
      context.handle(
        _alarmIdMeta,
        alarmId.isAcceptableOrUnknown(data['alarm_id']!, _alarmIdMeta),
      );
    }
    if (data.containsKey('schedule_id')) {
      context.handle(
        _scheduleIdMeta,
        scheduleId.isAcceptableOrUnknown(data['schedule_id']!, _scheduleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_scheduleIdMeta);
    }
    if (data.containsKey('fire_at')) {
      context.handle(
        _fireAtMeta,
        fireAt.isAcceptableOrUnknown(data['fire_at']!, _fireAtMeta),
      );
    } else if (isInserting) {
      context.missing(_fireAtMeta);
    }
    if (data.containsKey('voice_file_path')) {
      context.handle(
        _voiceFilePathMeta,
        voiceFilePath.isAcceptableOrUnknown(
          data['voice_file_path']!,
          _voiceFilePathMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {alarmId};
  @override
  ScheduledAlarm map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ScheduledAlarm(
      alarmId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}alarm_id'],
      )!,
      scheduleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}schedule_id'],
      )!,
      fireAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fire_at'],
      )!,
      voiceFilePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}voice_file_path'],
      )!,
    );
  }

  @override
  $ScheduledAlarmsTable createAlias(String alias) {
    return $ScheduledAlarmsTable(attachedDatabase, alias);
  }
}

class ScheduledAlarm extends DataClass implements Insertable<ScheduledAlarm> {
  final int alarmId;
  final String scheduleId;
  final DateTime fireAt;
  final String voiceFilePath;
  const ScheduledAlarm({
    required this.alarmId,
    required this.scheduleId,
    required this.fireAt,
    required this.voiceFilePath,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['alarm_id'] = Variable<int>(alarmId);
    map['schedule_id'] = Variable<String>(scheduleId);
    map['fire_at'] = Variable<DateTime>(fireAt);
    map['voice_file_path'] = Variable<String>(voiceFilePath);
    return map;
  }

  ScheduledAlarmsCompanion toCompanion(bool nullToAbsent) {
    return ScheduledAlarmsCompanion(
      alarmId: Value(alarmId),
      scheduleId: Value(scheduleId),
      fireAt: Value(fireAt),
      voiceFilePath: Value(voiceFilePath),
    );
  }

  factory ScheduledAlarm.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ScheduledAlarm(
      alarmId: serializer.fromJson<int>(json['alarmId']),
      scheduleId: serializer.fromJson<String>(json['scheduleId']),
      fireAt: serializer.fromJson<DateTime>(json['fireAt']),
      voiceFilePath: serializer.fromJson<String>(json['voiceFilePath']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'alarmId': serializer.toJson<int>(alarmId),
      'scheduleId': serializer.toJson<String>(scheduleId),
      'fireAt': serializer.toJson<DateTime>(fireAt),
      'voiceFilePath': serializer.toJson<String>(voiceFilePath),
    };
  }

  ScheduledAlarm copyWith({
    int? alarmId,
    String? scheduleId,
    DateTime? fireAt,
    String? voiceFilePath,
  }) => ScheduledAlarm(
    alarmId: alarmId ?? this.alarmId,
    scheduleId: scheduleId ?? this.scheduleId,
    fireAt: fireAt ?? this.fireAt,
    voiceFilePath: voiceFilePath ?? this.voiceFilePath,
  );
  ScheduledAlarm copyWithCompanion(ScheduledAlarmsCompanion data) {
    return ScheduledAlarm(
      alarmId: data.alarmId.present ? data.alarmId.value : this.alarmId,
      scheduleId: data.scheduleId.present
          ? data.scheduleId.value
          : this.scheduleId,
      fireAt: data.fireAt.present ? data.fireAt.value : this.fireAt,
      voiceFilePath: data.voiceFilePath.present
          ? data.voiceFilePath.value
          : this.voiceFilePath,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ScheduledAlarm(')
          ..write('alarmId: $alarmId, ')
          ..write('scheduleId: $scheduleId, ')
          ..write('fireAt: $fireAt, ')
          ..write('voiceFilePath: $voiceFilePath')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(alarmId, scheduleId, fireAt, voiceFilePath);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ScheduledAlarm &&
          other.alarmId == this.alarmId &&
          other.scheduleId == this.scheduleId &&
          other.fireAt == this.fireAt &&
          other.voiceFilePath == this.voiceFilePath);
}

class ScheduledAlarmsCompanion extends UpdateCompanion<ScheduledAlarm> {
  final Value<int> alarmId;
  final Value<String> scheduleId;
  final Value<DateTime> fireAt;
  final Value<String> voiceFilePath;
  const ScheduledAlarmsCompanion({
    this.alarmId = const Value.absent(),
    this.scheduleId = const Value.absent(),
    this.fireAt = const Value.absent(),
    this.voiceFilePath = const Value.absent(),
  });
  ScheduledAlarmsCompanion.insert({
    this.alarmId = const Value.absent(),
    required String scheduleId,
    required DateTime fireAt,
    this.voiceFilePath = const Value.absent(),
  }) : scheduleId = Value(scheduleId),
       fireAt = Value(fireAt);
  static Insertable<ScheduledAlarm> custom({
    Expression<int>? alarmId,
    Expression<String>? scheduleId,
    Expression<DateTime>? fireAt,
    Expression<String>? voiceFilePath,
  }) {
    return RawValuesInsertable({
      if (alarmId != null) 'alarm_id': alarmId,
      if (scheduleId != null) 'schedule_id': scheduleId,
      if (fireAt != null) 'fire_at': fireAt,
      if (voiceFilePath != null) 'voice_file_path': voiceFilePath,
    });
  }

  ScheduledAlarmsCompanion copyWith({
    Value<int>? alarmId,
    Value<String>? scheduleId,
    Value<DateTime>? fireAt,
    Value<String>? voiceFilePath,
  }) {
    return ScheduledAlarmsCompanion(
      alarmId: alarmId ?? this.alarmId,
      scheduleId: scheduleId ?? this.scheduleId,
      fireAt: fireAt ?? this.fireAt,
      voiceFilePath: voiceFilePath ?? this.voiceFilePath,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (alarmId.present) {
      map['alarm_id'] = Variable<int>(alarmId.value);
    }
    if (scheduleId.present) {
      map['schedule_id'] = Variable<String>(scheduleId.value);
    }
    if (fireAt.present) {
      map['fire_at'] = Variable<DateTime>(fireAt.value);
    }
    if (voiceFilePath.present) {
      map['voice_file_path'] = Variable<String>(voiceFilePath.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ScheduledAlarmsCompanion(')
          ..write('alarmId: $alarmId, ')
          ..write('scheduleId: $scheduleId, ')
          ..write('fireAt: $fireAt, ')
          ..write('voiceFilePath: $voiceFilePath')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsTable extends AppSettings
    with TableInfo<$AppSettingsTable, AppSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppSetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  AppSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSetting(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $AppSettingsTable createAlias(String alias) {
    return $AppSettingsTable(attachedDatabase, alias);
  }
}

class AppSetting extends DataClass implements Insertable<AppSetting> {
  final String key;
  final String value;
  const AppSetting({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  AppSettingsCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsCompanion(key: Value(key), value: Value(value));
  }

  factory AppSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSetting(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  AppSetting copyWith({String? key, String? value}) =>
      AppSetting(key: key ?? this.key, value: value ?? this.value);
  AppSetting copyWithCompanion(AppSettingsCompanion data) {
    return AppSetting(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSetting(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSetting &&
          other.key == this.key &&
          other.value == this.value);
}

class AppSettingsCompanion extends UpdateCompanion<AppSetting> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const AppSettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppSettingsCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<AppSetting> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppSettingsCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return AppSettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DigestCacheTable extends DigestCache
    with TableInfo<$DigestCacheTable, DigestCacheData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DigestCacheTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _jsonMeta = const VerificationMeta('json');
  @override
  late final GeneratedColumn<String> json = GeneratedColumn<String>(
    'json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fetchedAtMeta = const VerificationMeta(
    'fetchedAt',
  );
  @override
  late final GeneratedColumn<DateTime> fetchedAt = GeneratedColumn<DateTime>(
    'fetched_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [date, json, fetchedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'digest_cache';
  @override
  VerificationContext validateIntegrity(
    Insertable<DigestCacheData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('json')) {
      context.handle(
        _jsonMeta,
        json.isAcceptableOrUnknown(data['json']!, _jsonMeta),
      );
    } else if (isInserting) {
      context.missing(_jsonMeta);
    }
    if (data.containsKey('fetched_at')) {
      context.handle(
        _fetchedAtMeta,
        fetchedAt.isAcceptableOrUnknown(data['fetched_at']!, _fetchedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_fetchedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {date};
  @override
  DigestCacheData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DigestCacheData(
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
      json: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}json'],
      )!,
      fetchedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fetched_at'],
      )!,
    );
  }

  @override
  $DigestCacheTable createAlias(String alias) {
    return $DigestCacheTable(attachedDatabase, alias);
  }
}

class DigestCacheData extends DataClass implements Insertable<DigestCacheData> {
  final String date;
  final String json;
  final DateTime fetchedAt;
  const DigestCacheData({
    required this.date,
    required this.json,
    required this.fetchedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['date'] = Variable<String>(date);
    map['json'] = Variable<String>(json);
    map['fetched_at'] = Variable<DateTime>(fetchedAt);
    return map;
  }

  DigestCacheCompanion toCompanion(bool nullToAbsent) {
    return DigestCacheCompanion(
      date: Value(date),
      json: Value(json),
      fetchedAt: Value(fetchedAt),
    );
  }

  factory DigestCacheData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DigestCacheData(
      date: serializer.fromJson<String>(json['date']),
      json: serializer.fromJson<String>(json['json']),
      fetchedAt: serializer.fromJson<DateTime>(json['fetchedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'date': serializer.toJson<String>(date),
      'json': serializer.toJson<String>(json),
      'fetchedAt': serializer.toJson<DateTime>(fetchedAt),
    };
  }

  DigestCacheData copyWith({String? date, String? json, DateTime? fetchedAt}) =>
      DigestCacheData(
        date: date ?? this.date,
        json: json ?? this.json,
        fetchedAt: fetchedAt ?? this.fetchedAt,
      );
  DigestCacheData copyWithCompanion(DigestCacheCompanion data) {
    return DigestCacheData(
      date: data.date.present ? data.date.value : this.date,
      json: data.json.present ? data.json.value : this.json,
      fetchedAt: data.fetchedAt.present ? data.fetchedAt.value : this.fetchedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DigestCacheData(')
          ..write('date: $date, ')
          ..write('json: $json, ')
          ..write('fetchedAt: $fetchedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(date, json, fetchedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DigestCacheData &&
          other.date == this.date &&
          other.json == this.json &&
          other.fetchedAt == this.fetchedAt);
}

class DigestCacheCompanion extends UpdateCompanion<DigestCacheData> {
  final Value<String> date;
  final Value<String> json;
  final Value<DateTime> fetchedAt;
  final Value<int> rowid;
  const DigestCacheCompanion({
    this.date = const Value.absent(),
    this.json = const Value.absent(),
    this.fetchedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DigestCacheCompanion.insert({
    required String date,
    required String json,
    required DateTime fetchedAt,
    this.rowid = const Value.absent(),
  }) : date = Value(date),
       json = Value(json),
       fetchedAt = Value(fetchedAt);
  static Insertable<DigestCacheData> custom({
    Expression<String>? date,
    Expression<String>? json,
    Expression<DateTime>? fetchedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (date != null) 'date': date,
      if (json != null) 'json': json,
      if (fetchedAt != null) 'fetched_at': fetchedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DigestCacheCompanion copyWith({
    Value<String>? date,
    Value<String>? json,
    Value<DateTime>? fetchedAt,
    Value<int>? rowid,
  }) {
    return DigestCacheCompanion(
      date: date ?? this.date,
      json: json ?? this.json,
      fetchedAt: fetchedAt ?? this.fetchedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (json.present) {
      map['json'] = Variable<String>(json.value);
    }
    if (fetchedAt.present) {
      map['fetched_at'] = Variable<DateTime>(fetchedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DigestCacheCompanion(')
          ..write('date: $date, ')
          ..write('json: $json, ')
          ..write('fetchedAt: $fetchedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $MedicinesTable medicines = $MedicinesTable(this);
  late final $SchedulesTable schedules = $SchedulesTable(this);
  late final $DoseLogsTable doseLogs = $DoseLogsTable(this);
  late final $ScheduledAlarmsTable scheduledAlarms = $ScheduledAlarmsTable(
    this,
  );
  late final $AppSettingsTable appSettings = $AppSettingsTable(this);
  late final $DigestCacheTable digestCache = $DigestCacheTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    medicines,
    schedules,
    doseLogs,
    scheduledAlarms,
    appSettings,
    digestCache,
  ];
}

typedef $$MedicinesTableCreateCompanionBuilder =
    MedicinesCompanion Function({
      required String id,
      required String name,
      Value<String> doseNote,
      Value<String> foodRelation,
      Value<int> stockCount,
      Value<double> unitsPerDose,
      Value<int> refillThresholdDays,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });
typedef $$MedicinesTableUpdateCompanionBuilder =
    MedicinesCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> doseNote,
      Value<String> foodRelation,
      Value<int> stockCount,
      Value<double> unitsPerDose,
      Value<int> refillThresholdDays,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });

final class $$MedicinesTableReferences
    extends BaseReferences<_$AppDatabase, $MedicinesTable, Medicine> {
  $$MedicinesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$SchedulesTable, List<Schedule>>
  _schedulesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.schedules,
    aliasName: $_aliasNameGenerator(db.medicines.id, db.schedules.medicineId),
  );

  $$SchedulesTableProcessedTableManager get schedulesRefs {
    final manager = $$SchedulesTableTableManager(
      $_db,
      $_db.schedules,
    ).filter((f) => f.medicineId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_schedulesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$MedicinesTableFilterComposer
    extends Composer<_$AppDatabase, $MedicinesTable> {
  $$MedicinesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get doseNote => $composableBuilder(
    column: $table.doseNote,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get foodRelation => $composableBuilder(
    column: $table.foodRelation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get stockCount => $composableBuilder(
    column: $table.stockCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get unitsPerDose => $composableBuilder(
    column: $table.unitsPerDose,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get refillThresholdDays => $composableBuilder(
    column: $table.refillThresholdDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> schedulesRefs(
    Expression<bool> Function($$SchedulesTableFilterComposer f) f,
  ) {
    final $$SchedulesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.schedules,
      getReferencedColumn: (t) => t.medicineId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SchedulesTableFilterComposer(
            $db: $db,
            $table: $db.schedules,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MedicinesTableOrderingComposer
    extends Composer<_$AppDatabase, $MedicinesTable> {
  $$MedicinesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get doseNote => $composableBuilder(
    column: $table.doseNote,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get foodRelation => $composableBuilder(
    column: $table.foodRelation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get stockCount => $composableBuilder(
    column: $table.stockCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get unitsPerDose => $composableBuilder(
    column: $table.unitsPerDose,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get refillThresholdDays => $composableBuilder(
    column: $table.refillThresholdDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MedicinesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MedicinesTable> {
  $$MedicinesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get doseNote =>
      $composableBuilder(column: $table.doseNote, builder: (column) => column);

  GeneratedColumn<String> get foodRelation => $composableBuilder(
    column: $table.foodRelation,
    builder: (column) => column,
  );

  GeneratedColumn<int> get stockCount => $composableBuilder(
    column: $table.stockCount,
    builder: (column) => column,
  );

  GeneratedColumn<double> get unitsPerDose => $composableBuilder(
    column: $table.unitsPerDose,
    builder: (column) => column,
  );

  GeneratedColumn<int> get refillThresholdDays => $composableBuilder(
    column: $table.refillThresholdDays,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  Expression<T> schedulesRefs<T extends Object>(
    Expression<T> Function($$SchedulesTableAnnotationComposer a) f,
  ) {
    final $$SchedulesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.schedules,
      getReferencedColumn: (t) => t.medicineId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SchedulesTableAnnotationComposer(
            $db: $db,
            $table: $db.schedules,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MedicinesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MedicinesTable,
          Medicine,
          $$MedicinesTableFilterComposer,
          $$MedicinesTableOrderingComposer,
          $$MedicinesTableAnnotationComposer,
          $$MedicinesTableCreateCompanionBuilder,
          $$MedicinesTableUpdateCompanionBuilder,
          (Medicine, $$MedicinesTableReferences),
          Medicine,
          PrefetchHooks Function({bool schedulesRefs})
        > {
  $$MedicinesTableTableManager(_$AppDatabase db, $MedicinesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MedicinesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MedicinesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MedicinesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> doseNote = const Value.absent(),
                Value<String> foodRelation = const Value.absent(),
                Value<int> stockCount = const Value.absent(),
                Value<double> unitsPerDose = const Value.absent(),
                Value<int> refillThresholdDays = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MedicinesCompanion(
                id: id,
                name: name,
                doseNote: doseNote,
                foodRelation: foodRelation,
                stockCount: stockCount,
                unitsPerDose: unitsPerDose,
                refillThresholdDays: refillThresholdDays,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String> doseNote = const Value.absent(),
                Value<String> foodRelation = const Value.absent(),
                Value<int> stockCount = const Value.absent(),
                Value<double> unitsPerDose = const Value.absent(),
                Value<int> refillThresholdDays = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MedicinesCompanion.insert(
                id: id,
                name: name,
                doseNote: doseNote,
                foodRelation: foodRelation,
                stockCount: stockCount,
                unitsPerDose: unitsPerDose,
                refillThresholdDays: refillThresholdDays,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MedicinesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({schedulesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (schedulesRefs) db.schedules],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (schedulesRefs)
                    await $_getPrefetchedData<
                      Medicine,
                      $MedicinesTable,
                      Schedule
                    >(
                      currentTable: table,
                      referencedTable: $$MedicinesTableReferences
                          ._schedulesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$MedicinesTableReferences(
                            db,
                            table,
                            p0,
                          ).schedulesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.medicineId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$MedicinesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MedicinesTable,
      Medicine,
      $$MedicinesTableFilterComposer,
      $$MedicinesTableOrderingComposer,
      $$MedicinesTableAnnotationComposer,
      $$MedicinesTableCreateCompanionBuilder,
      $$MedicinesTableUpdateCompanionBuilder,
      (Medicine, $$MedicinesTableReferences),
      Medicine,
      PrefetchHooks Function({bool schedulesRefs})
    >;
typedef $$SchedulesTableCreateCompanionBuilder =
    SchedulesCompanion Function({
      required String id,
      Value<String?> medicineId,
      Value<String> alertType,
      required String label,
      required int timeMinutes,
      Value<int> daysMask,
      required DateTime startDate,
      Value<DateTime?> endDate,
      Value<bool> enabled,
      Value<String> voiceLang,
      Value<String> voiceFilePath,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });
typedef $$SchedulesTableUpdateCompanionBuilder =
    SchedulesCompanion Function({
      Value<String> id,
      Value<String?> medicineId,
      Value<String> alertType,
      Value<String> label,
      Value<int> timeMinutes,
      Value<int> daysMask,
      Value<DateTime> startDate,
      Value<DateTime?> endDate,
      Value<bool> enabled,
      Value<String> voiceLang,
      Value<String> voiceFilePath,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });

final class $$SchedulesTableReferences
    extends BaseReferences<_$AppDatabase, $SchedulesTable, Schedule> {
  $$SchedulesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $MedicinesTable _medicineIdTable(_$AppDatabase db) =>
      db.medicines.createAlias(
        $_aliasNameGenerator(db.schedules.medicineId, db.medicines.id),
      );

  $$MedicinesTableProcessedTableManager? get medicineId {
    final $_column = $_itemColumn<String>('medicine_id');
    if ($_column == null) return null;
    final manager = $$MedicinesTableTableManager(
      $_db,
      $_db.medicines,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_medicineIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$DoseLogsTable, List<DoseLog>> _doseLogsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.doseLogs,
    aliasName: $_aliasNameGenerator(db.schedules.id, db.doseLogs.scheduleId),
  );

  $$DoseLogsTableProcessedTableManager get doseLogsRefs {
    final manager = $$DoseLogsTableTableManager(
      $_db,
      $_db.doseLogs,
    ).filter((f) => f.scheduleId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_doseLogsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ScheduledAlarmsTable, List<ScheduledAlarm>>
  _scheduledAlarmsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.scheduledAlarms,
    aliasName: $_aliasNameGenerator(
      db.schedules.id,
      db.scheduledAlarms.scheduleId,
    ),
  );

  $$ScheduledAlarmsTableProcessedTableManager get scheduledAlarmsRefs {
    final manager = $$ScheduledAlarmsTableTableManager(
      $_db,
      $_db.scheduledAlarms,
    ).filter((f) => f.scheduleId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _scheduledAlarmsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SchedulesTableFilterComposer
    extends Composer<_$AppDatabase, $SchedulesTable> {
  $$SchedulesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get alertType => $composableBuilder(
    column: $table.alertType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get timeMinutes => $composableBuilder(
    column: $table.timeMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get daysMask => $composableBuilder(
    column: $table.daysMask,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get voiceLang => $composableBuilder(
    column: $table.voiceLang,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get voiceFilePath => $composableBuilder(
    column: $table.voiceFilePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$MedicinesTableFilterComposer get medicineId {
    final $$MedicinesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicineId,
      referencedTable: $db.medicines,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicinesTableFilterComposer(
            $db: $db,
            $table: $db.medicines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> doseLogsRefs(
    Expression<bool> Function($$DoseLogsTableFilterComposer f) f,
  ) {
    final $$DoseLogsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.doseLogs,
      getReferencedColumn: (t) => t.scheduleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DoseLogsTableFilterComposer(
            $db: $db,
            $table: $db.doseLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> scheduledAlarmsRefs(
    Expression<bool> Function($$ScheduledAlarmsTableFilterComposer f) f,
  ) {
    final $$ScheduledAlarmsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.scheduledAlarms,
      getReferencedColumn: (t) => t.scheduleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ScheduledAlarmsTableFilterComposer(
            $db: $db,
            $table: $db.scheduledAlarms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SchedulesTableOrderingComposer
    extends Composer<_$AppDatabase, $SchedulesTable> {
  $$SchedulesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get alertType => $composableBuilder(
    column: $table.alertType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get timeMinutes => $composableBuilder(
    column: $table.timeMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get daysMask => $composableBuilder(
    column: $table.daysMask,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get voiceLang => $composableBuilder(
    column: $table.voiceLang,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get voiceFilePath => $composableBuilder(
    column: $table.voiceFilePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$MedicinesTableOrderingComposer get medicineId {
    final $$MedicinesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicineId,
      referencedTable: $db.medicines,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicinesTableOrderingComposer(
            $db: $db,
            $table: $db.medicines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SchedulesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SchedulesTable> {
  $$SchedulesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get alertType =>
      $composableBuilder(column: $table.alertType, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<int> get timeMinutes => $composableBuilder(
    column: $table.timeMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get daysMask =>
      $composableBuilder(column: $table.daysMask, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<bool> get enabled =>
      $composableBuilder(column: $table.enabled, builder: (column) => column);

  GeneratedColumn<String> get voiceLang =>
      $composableBuilder(column: $table.voiceLang, builder: (column) => column);

  GeneratedColumn<String> get voiceFilePath => $composableBuilder(
    column: $table.voiceFilePath,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  $$MedicinesTableAnnotationComposer get medicineId {
    final $$MedicinesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicineId,
      referencedTable: $db.medicines,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicinesTableAnnotationComposer(
            $db: $db,
            $table: $db.medicines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> doseLogsRefs<T extends Object>(
    Expression<T> Function($$DoseLogsTableAnnotationComposer a) f,
  ) {
    final $$DoseLogsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.doseLogs,
      getReferencedColumn: (t) => t.scheduleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DoseLogsTableAnnotationComposer(
            $db: $db,
            $table: $db.doseLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> scheduledAlarmsRefs<T extends Object>(
    Expression<T> Function($$ScheduledAlarmsTableAnnotationComposer a) f,
  ) {
    final $$ScheduledAlarmsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.scheduledAlarms,
      getReferencedColumn: (t) => t.scheduleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ScheduledAlarmsTableAnnotationComposer(
            $db: $db,
            $table: $db.scheduledAlarms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SchedulesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SchedulesTable,
          Schedule,
          $$SchedulesTableFilterComposer,
          $$SchedulesTableOrderingComposer,
          $$SchedulesTableAnnotationComposer,
          $$SchedulesTableCreateCompanionBuilder,
          $$SchedulesTableUpdateCompanionBuilder,
          (Schedule, $$SchedulesTableReferences),
          Schedule,
          PrefetchHooks Function({
            bool medicineId,
            bool doseLogsRefs,
            bool scheduledAlarmsRefs,
          })
        > {
  $$SchedulesTableTableManager(_$AppDatabase db, $SchedulesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SchedulesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SchedulesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SchedulesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> medicineId = const Value.absent(),
                Value<String> alertType = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<int> timeMinutes = const Value.absent(),
                Value<int> daysMask = const Value.absent(),
                Value<DateTime> startDate = const Value.absent(),
                Value<DateTime?> endDate = const Value.absent(),
                Value<bool> enabled = const Value.absent(),
                Value<String> voiceLang = const Value.absent(),
                Value<String> voiceFilePath = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SchedulesCompanion(
                id: id,
                medicineId: medicineId,
                alertType: alertType,
                label: label,
                timeMinutes: timeMinutes,
                daysMask: daysMask,
                startDate: startDate,
                endDate: endDate,
                enabled: enabled,
                voiceLang: voiceLang,
                voiceFilePath: voiceFilePath,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> medicineId = const Value.absent(),
                Value<String> alertType = const Value.absent(),
                required String label,
                required int timeMinutes,
                Value<int> daysMask = const Value.absent(),
                required DateTime startDate,
                Value<DateTime?> endDate = const Value.absent(),
                Value<bool> enabled = const Value.absent(),
                Value<String> voiceLang = const Value.absent(),
                Value<String> voiceFilePath = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SchedulesCompanion.insert(
                id: id,
                medicineId: medicineId,
                alertType: alertType,
                label: label,
                timeMinutes: timeMinutes,
                daysMask: daysMask,
                startDate: startDate,
                endDate: endDate,
                enabled: enabled,
                voiceLang: voiceLang,
                voiceFilePath: voiceFilePath,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SchedulesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                medicineId = false,
                doseLogsRefs = false,
                scheduledAlarmsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (doseLogsRefs) db.doseLogs,
                    if (scheduledAlarmsRefs) db.scheduledAlarms,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (medicineId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.medicineId,
                                    referencedTable: $$SchedulesTableReferences
                                        ._medicineIdTable(db),
                                    referencedColumn: $$SchedulesTableReferences
                                        ._medicineIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (doseLogsRefs)
                        await $_getPrefetchedData<
                          Schedule,
                          $SchedulesTable,
                          DoseLog
                        >(
                          currentTable: table,
                          referencedTable: $$SchedulesTableReferences
                              ._doseLogsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SchedulesTableReferences(
                                db,
                                table,
                                p0,
                              ).doseLogsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.scheduleId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (scheduledAlarmsRefs)
                        await $_getPrefetchedData<
                          Schedule,
                          $SchedulesTable,
                          ScheduledAlarm
                        >(
                          currentTable: table,
                          referencedTable: $$SchedulesTableReferences
                              ._scheduledAlarmsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SchedulesTableReferences(
                                db,
                                table,
                                p0,
                              ).scheduledAlarmsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.scheduleId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$SchedulesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SchedulesTable,
      Schedule,
      $$SchedulesTableFilterComposer,
      $$SchedulesTableOrderingComposer,
      $$SchedulesTableAnnotationComposer,
      $$SchedulesTableCreateCompanionBuilder,
      $$SchedulesTableUpdateCompanionBuilder,
      (Schedule, $$SchedulesTableReferences),
      Schedule,
      PrefetchHooks Function({
        bool medicineId,
        bool doseLogsRefs,
        bool scheduledAlarmsRefs,
      })
    >;
typedef $$DoseLogsTableCreateCompanionBuilder =
    DoseLogsCompanion Function({
      required String id,
      required String scheduleId,
      required DateTime scheduledAt,
      required String status,
      Value<DateTime?> actedAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$DoseLogsTableUpdateCompanionBuilder =
    DoseLogsCompanion Function({
      Value<String> id,
      Value<String> scheduleId,
      Value<DateTime> scheduledAt,
      Value<String> status,
      Value<DateTime?> actedAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$DoseLogsTableReferences
    extends BaseReferences<_$AppDatabase, $DoseLogsTable, DoseLog> {
  $$DoseLogsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SchedulesTable _scheduleIdTable(_$AppDatabase db) =>
      db.schedules.createAlias(
        $_aliasNameGenerator(db.doseLogs.scheduleId, db.schedules.id),
      );

  $$SchedulesTableProcessedTableManager get scheduleId {
    final $_column = $_itemColumn<String>('schedule_id')!;

    final manager = $$SchedulesTableTableManager(
      $_db,
      $_db.schedules,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_scheduleIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$DoseLogsTableFilterComposer
    extends Composer<_$AppDatabase, $DoseLogsTable> {
  $$DoseLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get scheduledAt => $composableBuilder(
    column: $table.scheduledAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get actedAt => $composableBuilder(
    column: $table.actedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$SchedulesTableFilterComposer get scheduleId {
    final $$SchedulesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.scheduleId,
      referencedTable: $db.schedules,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SchedulesTableFilterComposer(
            $db: $db,
            $table: $db.schedules,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DoseLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $DoseLogsTable> {
  $$DoseLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get scheduledAt => $composableBuilder(
    column: $table.scheduledAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get actedAt => $composableBuilder(
    column: $table.actedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$SchedulesTableOrderingComposer get scheduleId {
    final $$SchedulesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.scheduleId,
      referencedTable: $db.schedules,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SchedulesTableOrderingComposer(
            $db: $db,
            $table: $db.schedules,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DoseLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DoseLogsTable> {
  $$DoseLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get scheduledAt => $composableBuilder(
    column: $table.scheduledAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get actedAt =>
      $composableBuilder(column: $table.actedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$SchedulesTableAnnotationComposer get scheduleId {
    final $$SchedulesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.scheduleId,
      referencedTable: $db.schedules,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SchedulesTableAnnotationComposer(
            $db: $db,
            $table: $db.schedules,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DoseLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DoseLogsTable,
          DoseLog,
          $$DoseLogsTableFilterComposer,
          $$DoseLogsTableOrderingComposer,
          $$DoseLogsTableAnnotationComposer,
          $$DoseLogsTableCreateCompanionBuilder,
          $$DoseLogsTableUpdateCompanionBuilder,
          (DoseLog, $$DoseLogsTableReferences),
          DoseLog,
          PrefetchHooks Function({bool scheduleId})
        > {
  $$DoseLogsTableTableManager(_$AppDatabase db, $DoseLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DoseLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DoseLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DoseLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> scheduleId = const Value.absent(),
                Value<DateTime> scheduledAt = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime?> actedAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DoseLogsCompanion(
                id: id,
                scheduleId: scheduleId,
                scheduledAt: scheduledAt,
                status: status,
                actedAt: actedAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String scheduleId,
                required DateTime scheduledAt,
                required String status,
                Value<DateTime?> actedAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DoseLogsCompanion.insert(
                id: id,
                scheduleId: scheduleId,
                scheduledAt: scheduledAt,
                status: status,
                actedAt: actedAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$DoseLogsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({scheduleId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (scheduleId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.scheduleId,
                                referencedTable: $$DoseLogsTableReferences
                                    ._scheduleIdTable(db),
                                referencedColumn: $$DoseLogsTableReferences
                                    ._scheduleIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$DoseLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DoseLogsTable,
      DoseLog,
      $$DoseLogsTableFilterComposer,
      $$DoseLogsTableOrderingComposer,
      $$DoseLogsTableAnnotationComposer,
      $$DoseLogsTableCreateCompanionBuilder,
      $$DoseLogsTableUpdateCompanionBuilder,
      (DoseLog, $$DoseLogsTableReferences),
      DoseLog,
      PrefetchHooks Function({bool scheduleId})
    >;
typedef $$ScheduledAlarmsTableCreateCompanionBuilder =
    ScheduledAlarmsCompanion Function({
      Value<int> alarmId,
      required String scheduleId,
      required DateTime fireAt,
      Value<String> voiceFilePath,
    });
typedef $$ScheduledAlarmsTableUpdateCompanionBuilder =
    ScheduledAlarmsCompanion Function({
      Value<int> alarmId,
      Value<String> scheduleId,
      Value<DateTime> fireAt,
      Value<String> voiceFilePath,
    });

final class $$ScheduledAlarmsTableReferences
    extends
        BaseReferences<_$AppDatabase, $ScheduledAlarmsTable, ScheduledAlarm> {
  $$ScheduledAlarmsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $SchedulesTable _scheduleIdTable(_$AppDatabase db) =>
      db.schedules.createAlias(
        $_aliasNameGenerator(db.scheduledAlarms.scheduleId, db.schedules.id),
      );

  $$SchedulesTableProcessedTableManager get scheduleId {
    final $_column = $_itemColumn<String>('schedule_id')!;

    final manager = $$SchedulesTableTableManager(
      $_db,
      $_db.schedules,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_scheduleIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ScheduledAlarmsTableFilterComposer
    extends Composer<_$AppDatabase, $ScheduledAlarmsTable> {
  $$ScheduledAlarmsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get alarmId => $composableBuilder(
    column: $table.alarmId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fireAt => $composableBuilder(
    column: $table.fireAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get voiceFilePath => $composableBuilder(
    column: $table.voiceFilePath,
    builder: (column) => ColumnFilters(column),
  );

  $$SchedulesTableFilterComposer get scheduleId {
    final $$SchedulesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.scheduleId,
      referencedTable: $db.schedules,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SchedulesTableFilterComposer(
            $db: $db,
            $table: $db.schedules,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ScheduledAlarmsTableOrderingComposer
    extends Composer<_$AppDatabase, $ScheduledAlarmsTable> {
  $$ScheduledAlarmsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get alarmId => $composableBuilder(
    column: $table.alarmId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fireAt => $composableBuilder(
    column: $table.fireAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get voiceFilePath => $composableBuilder(
    column: $table.voiceFilePath,
    builder: (column) => ColumnOrderings(column),
  );

  $$SchedulesTableOrderingComposer get scheduleId {
    final $$SchedulesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.scheduleId,
      referencedTable: $db.schedules,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SchedulesTableOrderingComposer(
            $db: $db,
            $table: $db.schedules,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ScheduledAlarmsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ScheduledAlarmsTable> {
  $$ScheduledAlarmsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get alarmId =>
      $composableBuilder(column: $table.alarmId, builder: (column) => column);

  GeneratedColumn<DateTime> get fireAt =>
      $composableBuilder(column: $table.fireAt, builder: (column) => column);

  GeneratedColumn<String> get voiceFilePath => $composableBuilder(
    column: $table.voiceFilePath,
    builder: (column) => column,
  );

  $$SchedulesTableAnnotationComposer get scheduleId {
    final $$SchedulesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.scheduleId,
      referencedTable: $db.schedules,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SchedulesTableAnnotationComposer(
            $db: $db,
            $table: $db.schedules,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ScheduledAlarmsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ScheduledAlarmsTable,
          ScheduledAlarm,
          $$ScheduledAlarmsTableFilterComposer,
          $$ScheduledAlarmsTableOrderingComposer,
          $$ScheduledAlarmsTableAnnotationComposer,
          $$ScheduledAlarmsTableCreateCompanionBuilder,
          $$ScheduledAlarmsTableUpdateCompanionBuilder,
          (ScheduledAlarm, $$ScheduledAlarmsTableReferences),
          ScheduledAlarm,
          PrefetchHooks Function({bool scheduleId})
        > {
  $$ScheduledAlarmsTableTableManager(
    _$AppDatabase db,
    $ScheduledAlarmsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ScheduledAlarmsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ScheduledAlarmsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ScheduledAlarmsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> alarmId = const Value.absent(),
                Value<String> scheduleId = const Value.absent(),
                Value<DateTime> fireAt = const Value.absent(),
                Value<String> voiceFilePath = const Value.absent(),
              }) => ScheduledAlarmsCompanion(
                alarmId: alarmId,
                scheduleId: scheduleId,
                fireAt: fireAt,
                voiceFilePath: voiceFilePath,
              ),
          createCompanionCallback:
              ({
                Value<int> alarmId = const Value.absent(),
                required String scheduleId,
                required DateTime fireAt,
                Value<String> voiceFilePath = const Value.absent(),
              }) => ScheduledAlarmsCompanion.insert(
                alarmId: alarmId,
                scheduleId: scheduleId,
                fireAt: fireAt,
                voiceFilePath: voiceFilePath,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ScheduledAlarmsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({scheduleId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (scheduleId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.scheduleId,
                                referencedTable:
                                    $$ScheduledAlarmsTableReferences
                                        ._scheduleIdTable(db),
                                referencedColumn:
                                    $$ScheduledAlarmsTableReferences
                                        ._scheduleIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ScheduledAlarmsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ScheduledAlarmsTable,
      ScheduledAlarm,
      $$ScheduledAlarmsTableFilterComposer,
      $$ScheduledAlarmsTableOrderingComposer,
      $$ScheduledAlarmsTableAnnotationComposer,
      $$ScheduledAlarmsTableCreateCompanionBuilder,
      $$ScheduledAlarmsTableUpdateCompanionBuilder,
      (ScheduledAlarm, $$ScheduledAlarmsTableReferences),
      ScheduledAlarm,
      PrefetchHooks Function({bool scheduleId})
    >;
typedef $$AppSettingsTableCreateCompanionBuilder =
    AppSettingsCompanion Function({
      required String key,
      required String value,
      Value<int> rowid,
    });
typedef $$AppSettingsTableUpdateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<int> rowid,
    });

class $$AppSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$AppSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppSettingsTable,
          AppSetting,
          $$AppSettingsTableFilterComposer,
          $$AppSettingsTableOrderingComposer,
          $$AppSettingsTableAnnotationComposer,
          $$AppSettingsTableCreateCompanionBuilder,
          $$AppSettingsTableUpdateCompanionBuilder,
          (
            AppSetting,
            BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
          ),
          AppSetting,
          PrefetchHooks Function()
        > {
  $$AppSettingsTableTableManager(_$AppDatabase db, $AppSettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsCompanion.insert(
                key: key,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppSettingsTable,
      AppSetting,
      $$AppSettingsTableFilterComposer,
      $$AppSettingsTableOrderingComposer,
      $$AppSettingsTableAnnotationComposer,
      $$AppSettingsTableCreateCompanionBuilder,
      $$AppSettingsTableUpdateCompanionBuilder,
      (
        AppSetting,
        BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
      ),
      AppSetting,
      PrefetchHooks Function()
    >;
typedef $$DigestCacheTableCreateCompanionBuilder =
    DigestCacheCompanion Function({
      required String date,
      required String json,
      required DateTime fetchedAt,
      Value<int> rowid,
    });
typedef $$DigestCacheTableUpdateCompanionBuilder =
    DigestCacheCompanion Function({
      Value<String> date,
      Value<String> json,
      Value<DateTime> fetchedAt,
      Value<int> rowid,
    });

class $$DigestCacheTableFilterComposer
    extends Composer<_$AppDatabase, $DigestCacheTable> {
  $$DigestCacheTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get json => $composableBuilder(
    column: $table.json,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fetchedAt => $composableBuilder(
    column: $table.fetchedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DigestCacheTableOrderingComposer
    extends Composer<_$AppDatabase, $DigestCacheTable> {
  $$DigestCacheTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get json => $composableBuilder(
    column: $table.json,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fetchedAt => $composableBuilder(
    column: $table.fetchedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DigestCacheTableAnnotationComposer
    extends Composer<_$AppDatabase, $DigestCacheTable> {
  $$DigestCacheTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get json =>
      $composableBuilder(column: $table.json, builder: (column) => column);

  GeneratedColumn<DateTime> get fetchedAt =>
      $composableBuilder(column: $table.fetchedAt, builder: (column) => column);
}

class $$DigestCacheTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DigestCacheTable,
          DigestCacheData,
          $$DigestCacheTableFilterComposer,
          $$DigestCacheTableOrderingComposer,
          $$DigestCacheTableAnnotationComposer,
          $$DigestCacheTableCreateCompanionBuilder,
          $$DigestCacheTableUpdateCompanionBuilder,
          (
            DigestCacheData,
            BaseReferences<_$AppDatabase, $DigestCacheTable, DigestCacheData>,
          ),
          DigestCacheData,
          PrefetchHooks Function()
        > {
  $$DigestCacheTableTableManager(_$AppDatabase db, $DigestCacheTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DigestCacheTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DigestCacheTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DigestCacheTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> date = const Value.absent(),
                Value<String> json = const Value.absent(),
                Value<DateTime> fetchedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DigestCacheCompanion(
                date: date,
                json: json,
                fetchedAt: fetchedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String date,
                required String json,
                required DateTime fetchedAt,
                Value<int> rowid = const Value.absent(),
              }) => DigestCacheCompanion.insert(
                date: date,
                json: json,
                fetchedAt: fetchedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DigestCacheTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DigestCacheTable,
      DigestCacheData,
      $$DigestCacheTableFilterComposer,
      $$DigestCacheTableOrderingComposer,
      $$DigestCacheTableAnnotationComposer,
      $$DigestCacheTableCreateCompanionBuilder,
      $$DigestCacheTableUpdateCompanionBuilder,
      (
        DigestCacheData,
        BaseReferences<_$AppDatabase, $DigestCacheTable, DigestCacheData>,
      ),
      DigestCacheData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$MedicinesTableTableManager get medicines =>
      $$MedicinesTableTableManager(_db, _db.medicines);
  $$SchedulesTableTableManager get schedules =>
      $$SchedulesTableTableManager(_db, _db.schedules);
  $$DoseLogsTableTableManager get doseLogs =>
      $$DoseLogsTableTableManager(_db, _db.doseLogs);
  $$ScheduledAlarmsTableTableManager get scheduledAlarms =>
      $$ScheduledAlarmsTableTableManager(_db, _db.scheduledAlarms);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db, _db.appSettings);
  $$DigestCacheTableTableManager get digestCache =>
      $$DigestCacheTableTableManager(_db, _db.digestCache);
}
