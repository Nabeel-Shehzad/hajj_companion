// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $PermitsTable extends Permits with TableInfo<$PermitsTable, Permit> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PermitsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _permitNumberMeta = const VerificationMeta(
    'permitNumber',
  );
  @override
  late final GeneratedColumn<String> permitNumber = GeneratedColumn<String>(
    'permit_number',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 20),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fullNameMeta = const VerificationMeta(
    'fullName',
  );
  @override
  late final GeneratedColumn<String> fullName = GeneratedColumn<String>(
    'full_name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 50),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _permitTypeMeta = const VerificationMeta(
    'permitType',
  );
  @override
  late final GeneratedColumn<String> permitType = GeneratedColumn<String>(
    'permit_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _encryptedDataMeta = const VerificationMeta(
    'encryptedData',
  );
  @override
  late final GeneratedColumn<String> encryptedData = GeneratedColumn<String>(
    'encrypted_data',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    permitNumber,
    fullName,
    permitType,
    startDate,
    endDate,
    encryptedData,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'permits';
  @override
  VerificationContext validateIntegrity(
    Insertable<Permit> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('permit_number')) {
      context.handle(
        _permitNumberMeta,
        permitNumber.isAcceptableOrUnknown(
          data['permit_number']!,
          _permitNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_permitNumberMeta);
    }
    if (data.containsKey('full_name')) {
      context.handle(
        _fullNameMeta,
        fullName.isAcceptableOrUnknown(data['full_name']!, _fullNameMeta),
      );
    } else if (isInserting) {
      context.missing(_fullNameMeta);
    }
    if (data.containsKey('permit_type')) {
      context.handle(
        _permitTypeMeta,
        permitType.isAcceptableOrUnknown(data['permit_type']!, _permitTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_permitTypeMeta);
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
    } else if (isInserting) {
      context.missing(_endDateMeta);
    }
    if (data.containsKey('encrypted_data')) {
      context.handle(
        _encryptedDataMeta,
        encryptedData.isAcceptableOrUnknown(
          data['encrypted_data']!,
          _encryptedDataMeta,
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
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Permit map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Permit(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      permitNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}permit_number'],
      )!,
      fullName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}full_name'],
      )!,
      permitType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}permit_type'],
      )!,
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_date'],
      )!,
      endDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end_date'],
      )!,
      encryptedData: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}encrypted_data'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $PermitsTable createAlias(String alias) {
    return $PermitsTable(attachedDatabase, alias);
  }
}

class Permit extends DataClass implements Insertable<Permit> {
  final int id;
  final String permitNumber;
  final String fullName;
  final String permitType;
  final DateTime startDate;
  final DateTime endDate;
  final String? encryptedData;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Permit({
    required this.id,
    required this.permitNumber,
    required this.fullName,
    required this.permitType,
    required this.startDate,
    required this.endDate,
    this.encryptedData,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['permit_number'] = Variable<String>(permitNumber);
    map['full_name'] = Variable<String>(fullName);
    map['permit_type'] = Variable<String>(permitType);
    map['start_date'] = Variable<DateTime>(startDate);
    map['end_date'] = Variable<DateTime>(endDate);
    if (!nullToAbsent || encryptedData != null) {
      map['encrypted_data'] = Variable<String>(encryptedData);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  PermitsCompanion toCompanion(bool nullToAbsent) {
    return PermitsCompanion(
      id: Value(id),
      permitNumber: Value(permitNumber),
      fullName: Value(fullName),
      permitType: Value(permitType),
      startDate: Value(startDate),
      endDate: Value(endDate),
      encryptedData: encryptedData == null && nullToAbsent
          ? const Value.absent()
          : Value(encryptedData),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Permit.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Permit(
      id: serializer.fromJson<int>(json['id']),
      permitNumber: serializer.fromJson<String>(json['permitNumber']),
      fullName: serializer.fromJson<String>(json['fullName']),
      permitType: serializer.fromJson<String>(json['permitType']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      endDate: serializer.fromJson<DateTime>(json['endDate']),
      encryptedData: serializer.fromJson<String?>(json['encryptedData']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'permitNumber': serializer.toJson<String>(permitNumber),
      'fullName': serializer.toJson<String>(fullName),
      'permitType': serializer.toJson<String>(permitType),
      'startDate': serializer.toJson<DateTime>(startDate),
      'endDate': serializer.toJson<DateTime>(endDate),
      'encryptedData': serializer.toJson<String?>(encryptedData),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Permit copyWith({
    int? id,
    String? permitNumber,
    String? fullName,
    String? permitType,
    DateTime? startDate,
    DateTime? endDate,
    Value<String?> encryptedData = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Permit(
    id: id ?? this.id,
    permitNumber: permitNumber ?? this.permitNumber,
    fullName: fullName ?? this.fullName,
    permitType: permitType ?? this.permitType,
    startDate: startDate ?? this.startDate,
    endDate: endDate ?? this.endDate,
    encryptedData: encryptedData.present
        ? encryptedData.value
        : this.encryptedData,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Permit copyWithCompanion(PermitsCompanion data) {
    return Permit(
      id: data.id.present ? data.id.value : this.id,
      permitNumber: data.permitNumber.present
          ? data.permitNumber.value
          : this.permitNumber,
      fullName: data.fullName.present ? data.fullName.value : this.fullName,
      permitType: data.permitType.present
          ? data.permitType.value
          : this.permitType,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      encryptedData: data.encryptedData.present
          ? data.encryptedData.value
          : this.encryptedData,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Permit(')
          ..write('id: $id, ')
          ..write('permitNumber: $permitNumber, ')
          ..write('fullName: $fullName, ')
          ..write('permitType: $permitType, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('encryptedData: $encryptedData, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    permitNumber,
    fullName,
    permitType,
    startDate,
    endDate,
    encryptedData,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Permit &&
          other.id == this.id &&
          other.permitNumber == this.permitNumber &&
          other.fullName == this.fullName &&
          other.permitType == this.permitType &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.encryptedData == this.encryptedData &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class PermitsCompanion extends UpdateCompanion<Permit> {
  final Value<int> id;
  final Value<String> permitNumber;
  final Value<String> fullName;
  final Value<String> permitType;
  final Value<DateTime> startDate;
  final Value<DateTime> endDate;
  final Value<String?> encryptedData;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const PermitsCompanion({
    this.id = const Value.absent(),
    this.permitNumber = const Value.absent(),
    this.fullName = const Value.absent(),
    this.permitType = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.encryptedData = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  PermitsCompanion.insert({
    this.id = const Value.absent(),
    required String permitNumber,
    required String fullName,
    required String permitType,
    required DateTime startDate,
    required DateTime endDate,
    this.encryptedData = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : permitNumber = Value(permitNumber),
       fullName = Value(fullName),
       permitType = Value(permitType),
       startDate = Value(startDate),
       endDate = Value(endDate);
  static Insertable<Permit> custom({
    Expression<int>? id,
    Expression<String>? permitNumber,
    Expression<String>? fullName,
    Expression<String>? permitType,
    Expression<DateTime>? startDate,
    Expression<DateTime>? endDate,
    Expression<String>? encryptedData,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (permitNumber != null) 'permit_number': permitNumber,
      if (fullName != null) 'full_name': fullName,
      if (permitType != null) 'permit_type': permitType,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (encryptedData != null) 'encrypted_data': encryptedData,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  PermitsCompanion copyWith({
    Value<int>? id,
    Value<String>? permitNumber,
    Value<String>? fullName,
    Value<String>? permitType,
    Value<DateTime>? startDate,
    Value<DateTime>? endDate,
    Value<String?>? encryptedData,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return PermitsCompanion(
      id: id ?? this.id,
      permitNumber: permitNumber ?? this.permitNumber,
      fullName: fullName ?? this.fullName,
      permitType: permitType ?? this.permitType,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      encryptedData: encryptedData ?? this.encryptedData,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (permitNumber.present) {
      map['permit_number'] = Variable<String>(permitNumber.value);
    }
    if (fullName.present) {
      map['full_name'] = Variable<String>(fullName.value);
    }
    if (permitType.present) {
      map['permit_type'] = Variable<String>(permitType.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<DateTime>(endDate.value);
    }
    if (encryptedData.present) {
      map['encrypted_data'] = Variable<String>(encryptedData.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PermitsCompanion(')
          ..write('id: $id, ')
          ..write('permitNumber: $permitNumber, ')
          ..write('fullName: $fullName, ')
          ..write('permitType: $permitType, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('encryptedData: $encryptedData, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
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
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
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
  List<GeneratedColumn> get $columns => [id, key, value, updatedAt];
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
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
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
  AppSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSetting(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $AppSettingsTable createAlias(String alias) {
    return $AppSettingsTable(attachedDatabase, alias);
  }
}

class AppSetting extends DataClass implements Insertable<AppSetting> {
  final int id;
  final String key;
  final String value;
  final DateTime updatedAt;
  const AppSetting({
    required this.id,
    required this.key,
    required this.value,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  AppSettingsCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsCompanion(
      id: Value(id),
      key: Value(key),
      value: Value(value),
      updatedAt: Value(updatedAt),
    );
  }

  factory AppSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSetting(
      id: serializer.fromJson<int>(json['id']),
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  AppSetting copyWith({
    int? id,
    String? key,
    String? value,
    DateTime? updatedAt,
  }) => AppSetting(
    id: id ?? this.id,
    key: key ?? this.key,
    value: value ?? this.value,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  AppSetting copyWithCompanion(AppSettingsCompanion data) {
    return AppSetting(
      id: data.id.present ? data.id.value : this.id,
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSetting(')
          ..write('id: $id, ')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, key, value, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSetting &&
          other.id == this.id &&
          other.key == this.key &&
          other.value == this.value &&
          other.updatedAt == this.updatedAt);
}

class AppSettingsCompanion extends UpdateCompanion<AppSetting> {
  final Value<int> id;
  final Value<String> key;
  final Value<String> value;
  final Value<DateTime> updatedAt;
  const AppSettingsCompanion({
    this.id = const Value.absent(),
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  AppSettingsCompanion.insert({
    this.id = const Value.absent(),
    required String key,
    required String value,
    this.updatedAt = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<AppSetting> custom({
    Expression<int>? id,
    Expression<String>? key,
    Expression<String>? value,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  AppSettingsCompanion copyWith({
    Value<int>? id,
    Value<String>? key,
    Value<String>? value,
    Value<DateTime>? updatedAt,
  }) {
    return AppSettingsCompanion(
      id: id ?? this.id,
      key: key ?? this.key,
      value: value ?? this.value,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsCompanion(')
          ..write('id: $id, ')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $DuasTable extends Duas with TableInfo<$DuasTable, Dua> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DuasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _locationIdMeta = const VerificationMeta(
    'locationId',
  );
  @override
  late final GeneratedColumn<String> locationId = GeneratedColumn<String>(
    'location_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ritualTypeMeta = const VerificationMeta(
    'ritualType',
  );
  @override
  late final GeneratedColumn<String> ritualType = GeneratedColumn<String>(
    'ritual_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _arabicTextMeta = const VerificationMeta(
    'arabicText',
  );
  @override
  late final GeneratedColumn<String> arabicText = GeneratedColumn<String>(
    'arabic_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _englishTranslationMeta =
      const VerificationMeta('englishTranslation');
  @override
  late final GeneratedColumn<String> englishTranslation =
      GeneratedColumn<String>(
        'english_translation',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _transliterationMeta = const VerificationMeta(
    'transliteration',
  );
  @override
  late final GeneratedColumn<String> transliteration = GeneratedColumn<String>(
    'transliteration',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _audioFileNameMeta = const VerificationMeta(
    'audioFileName',
  );
  @override
  late final GeneratedColumn<String> audioFileName = GeneratedColumn<String>(
    'audio_file_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _displayOrderMeta = const VerificationMeta(
    'displayOrder',
  );
  @override
  late final GeneratedColumn<int> displayOrder = GeneratedColumn<int>(
    'display_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    locationId,
    ritualType,
    arabicText,
    englishTranslation,
    transliteration,
    audioFileName,
    displayOrder,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'duas';
  @override
  VerificationContext validateIntegrity(
    Insertable<Dua> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('location_id')) {
      context.handle(
        _locationIdMeta,
        locationId.isAcceptableOrUnknown(data['location_id']!, _locationIdMeta),
      );
    } else if (isInserting) {
      context.missing(_locationIdMeta);
    }
    if (data.containsKey('ritual_type')) {
      context.handle(
        _ritualTypeMeta,
        ritualType.isAcceptableOrUnknown(data['ritual_type']!, _ritualTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_ritualTypeMeta);
    }
    if (data.containsKey('arabic_text')) {
      context.handle(
        _arabicTextMeta,
        arabicText.isAcceptableOrUnknown(data['arabic_text']!, _arabicTextMeta),
      );
    } else if (isInserting) {
      context.missing(_arabicTextMeta);
    }
    if (data.containsKey('english_translation')) {
      context.handle(
        _englishTranslationMeta,
        englishTranslation.isAcceptableOrUnknown(
          data['english_translation']!,
          _englishTranslationMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_englishTranslationMeta);
    }
    if (data.containsKey('transliteration')) {
      context.handle(
        _transliterationMeta,
        transliteration.isAcceptableOrUnknown(
          data['transliteration']!,
          _transliterationMeta,
        ),
      );
    }
    if (data.containsKey('audio_file_name')) {
      context.handle(
        _audioFileNameMeta,
        audioFileName.isAcceptableOrUnknown(
          data['audio_file_name']!,
          _audioFileNameMeta,
        ),
      );
    }
    if (data.containsKey('display_order')) {
      context.handle(
        _displayOrderMeta,
        displayOrder.isAcceptableOrUnknown(
          data['display_order']!,
          _displayOrderMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Dua map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Dua(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      locationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}location_id'],
      )!,
      ritualType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ritual_type'],
      )!,
      arabicText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}arabic_text'],
      )!,
      englishTranslation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}english_translation'],
      )!,
      transliteration: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}transliteration'],
      ),
      audioFileName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}audio_file_name'],
      ),
      displayOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}display_order'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $DuasTable createAlias(String alias) {
    return $DuasTable(attachedDatabase, alias);
  }
}

class Dua extends DataClass implements Insertable<Dua> {
  final int id;
  final String locationId;
  final String ritualType;
  final String arabicText;
  final String englishTranslation;
  final String? transliteration;
  final String? audioFileName;
  final int displayOrder;
  final DateTime createdAt;
  const Dua({
    required this.id,
    required this.locationId,
    required this.ritualType,
    required this.arabicText,
    required this.englishTranslation,
    this.transliteration,
    this.audioFileName,
    required this.displayOrder,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['location_id'] = Variable<String>(locationId);
    map['ritual_type'] = Variable<String>(ritualType);
    map['arabic_text'] = Variable<String>(arabicText);
    map['english_translation'] = Variable<String>(englishTranslation);
    if (!nullToAbsent || transliteration != null) {
      map['transliteration'] = Variable<String>(transliteration);
    }
    if (!nullToAbsent || audioFileName != null) {
      map['audio_file_name'] = Variable<String>(audioFileName);
    }
    map['display_order'] = Variable<int>(displayOrder);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  DuasCompanion toCompanion(bool nullToAbsent) {
    return DuasCompanion(
      id: Value(id),
      locationId: Value(locationId),
      ritualType: Value(ritualType),
      arabicText: Value(arabicText),
      englishTranslation: Value(englishTranslation),
      transliteration: transliteration == null && nullToAbsent
          ? const Value.absent()
          : Value(transliteration),
      audioFileName: audioFileName == null && nullToAbsent
          ? const Value.absent()
          : Value(audioFileName),
      displayOrder: Value(displayOrder),
      createdAt: Value(createdAt),
    );
  }

  factory Dua.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Dua(
      id: serializer.fromJson<int>(json['id']),
      locationId: serializer.fromJson<String>(json['locationId']),
      ritualType: serializer.fromJson<String>(json['ritualType']),
      arabicText: serializer.fromJson<String>(json['arabicText']),
      englishTranslation: serializer.fromJson<String>(
        json['englishTranslation'],
      ),
      transliteration: serializer.fromJson<String?>(json['transliteration']),
      audioFileName: serializer.fromJson<String?>(json['audioFileName']),
      displayOrder: serializer.fromJson<int>(json['displayOrder']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'locationId': serializer.toJson<String>(locationId),
      'ritualType': serializer.toJson<String>(ritualType),
      'arabicText': serializer.toJson<String>(arabicText),
      'englishTranslation': serializer.toJson<String>(englishTranslation),
      'transliteration': serializer.toJson<String?>(transliteration),
      'audioFileName': serializer.toJson<String?>(audioFileName),
      'displayOrder': serializer.toJson<int>(displayOrder),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Dua copyWith({
    int? id,
    String? locationId,
    String? ritualType,
    String? arabicText,
    String? englishTranslation,
    Value<String?> transliteration = const Value.absent(),
    Value<String?> audioFileName = const Value.absent(),
    int? displayOrder,
    DateTime? createdAt,
  }) => Dua(
    id: id ?? this.id,
    locationId: locationId ?? this.locationId,
    ritualType: ritualType ?? this.ritualType,
    arabicText: arabicText ?? this.arabicText,
    englishTranslation: englishTranslation ?? this.englishTranslation,
    transliteration: transliteration.present
        ? transliteration.value
        : this.transliteration,
    audioFileName: audioFileName.present
        ? audioFileName.value
        : this.audioFileName,
    displayOrder: displayOrder ?? this.displayOrder,
    createdAt: createdAt ?? this.createdAt,
  );
  Dua copyWithCompanion(DuasCompanion data) {
    return Dua(
      id: data.id.present ? data.id.value : this.id,
      locationId: data.locationId.present
          ? data.locationId.value
          : this.locationId,
      ritualType: data.ritualType.present
          ? data.ritualType.value
          : this.ritualType,
      arabicText: data.arabicText.present
          ? data.arabicText.value
          : this.arabicText,
      englishTranslation: data.englishTranslation.present
          ? data.englishTranslation.value
          : this.englishTranslation,
      transliteration: data.transliteration.present
          ? data.transliteration.value
          : this.transliteration,
      audioFileName: data.audioFileName.present
          ? data.audioFileName.value
          : this.audioFileName,
      displayOrder: data.displayOrder.present
          ? data.displayOrder.value
          : this.displayOrder,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Dua(')
          ..write('id: $id, ')
          ..write('locationId: $locationId, ')
          ..write('ritualType: $ritualType, ')
          ..write('arabicText: $arabicText, ')
          ..write('englishTranslation: $englishTranslation, ')
          ..write('transliteration: $transliteration, ')
          ..write('audioFileName: $audioFileName, ')
          ..write('displayOrder: $displayOrder, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    locationId,
    ritualType,
    arabicText,
    englishTranslation,
    transliteration,
    audioFileName,
    displayOrder,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Dua &&
          other.id == this.id &&
          other.locationId == this.locationId &&
          other.ritualType == this.ritualType &&
          other.arabicText == this.arabicText &&
          other.englishTranslation == this.englishTranslation &&
          other.transliteration == this.transliteration &&
          other.audioFileName == this.audioFileName &&
          other.displayOrder == this.displayOrder &&
          other.createdAt == this.createdAt);
}

class DuasCompanion extends UpdateCompanion<Dua> {
  final Value<int> id;
  final Value<String> locationId;
  final Value<String> ritualType;
  final Value<String> arabicText;
  final Value<String> englishTranslation;
  final Value<String?> transliteration;
  final Value<String?> audioFileName;
  final Value<int> displayOrder;
  final Value<DateTime> createdAt;
  const DuasCompanion({
    this.id = const Value.absent(),
    this.locationId = const Value.absent(),
    this.ritualType = const Value.absent(),
    this.arabicText = const Value.absent(),
    this.englishTranslation = const Value.absent(),
    this.transliteration = const Value.absent(),
    this.audioFileName = const Value.absent(),
    this.displayOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  DuasCompanion.insert({
    this.id = const Value.absent(),
    required String locationId,
    required String ritualType,
    required String arabicText,
    required String englishTranslation,
    this.transliteration = const Value.absent(),
    this.audioFileName = const Value.absent(),
    this.displayOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : locationId = Value(locationId),
       ritualType = Value(ritualType),
       arabicText = Value(arabicText),
       englishTranslation = Value(englishTranslation);
  static Insertable<Dua> custom({
    Expression<int>? id,
    Expression<String>? locationId,
    Expression<String>? ritualType,
    Expression<String>? arabicText,
    Expression<String>? englishTranslation,
    Expression<String>? transliteration,
    Expression<String>? audioFileName,
    Expression<int>? displayOrder,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (locationId != null) 'location_id': locationId,
      if (ritualType != null) 'ritual_type': ritualType,
      if (arabicText != null) 'arabic_text': arabicText,
      if (englishTranslation != null) 'english_translation': englishTranslation,
      if (transliteration != null) 'transliteration': transliteration,
      if (audioFileName != null) 'audio_file_name': audioFileName,
      if (displayOrder != null) 'display_order': displayOrder,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  DuasCompanion copyWith({
    Value<int>? id,
    Value<String>? locationId,
    Value<String>? ritualType,
    Value<String>? arabicText,
    Value<String>? englishTranslation,
    Value<String?>? transliteration,
    Value<String?>? audioFileName,
    Value<int>? displayOrder,
    Value<DateTime>? createdAt,
  }) {
    return DuasCompanion(
      id: id ?? this.id,
      locationId: locationId ?? this.locationId,
      ritualType: ritualType ?? this.ritualType,
      arabicText: arabicText ?? this.arabicText,
      englishTranslation: englishTranslation ?? this.englishTranslation,
      transliteration: transliteration ?? this.transliteration,
      audioFileName: audioFileName ?? this.audioFileName,
      displayOrder: displayOrder ?? this.displayOrder,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (locationId.present) {
      map['location_id'] = Variable<String>(locationId.value);
    }
    if (ritualType.present) {
      map['ritual_type'] = Variable<String>(ritualType.value);
    }
    if (arabicText.present) {
      map['arabic_text'] = Variable<String>(arabicText.value);
    }
    if (englishTranslation.present) {
      map['english_translation'] = Variable<String>(englishTranslation.value);
    }
    if (transliteration.present) {
      map['transliteration'] = Variable<String>(transliteration.value);
    }
    if (audioFileName.present) {
      map['audio_file_name'] = Variable<String>(audioFileName.value);
    }
    if (displayOrder.present) {
      map['display_order'] = Variable<int>(displayOrder.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DuasCompanion(')
          ..write('id: $id, ')
          ..write('locationId: $locationId, ')
          ..write('ritualType: $ritualType, ')
          ..write('arabicText: $arabicText, ')
          ..write('englishTranslation: $englishTranslation, ')
          ..write('transliteration: $transliteration, ')
          ..write('audioFileName: $audioFileName, ')
          ..write('displayOrder: $displayOrder, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $GeofenceLocationsTable extends GeofenceLocations
    with TableInfo<$GeofenceLocationsTable, GeofenceLocation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GeofenceLocationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _locationIdMeta = const VerificationMeta(
    'locationId',
  );
  @override
  late final GeneratedColumn<String> locationId = GeneratedColumn<String>(
    'location_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _nameEnMeta = const VerificationMeta('nameEn');
  @override
  late final GeneratedColumn<String> nameEn = GeneratedColumn<String>(
    'name_en',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameArMeta = const VerificationMeta('nameAr');
  @override
  late final GeneratedColumn<String> nameAr = GeneratedColumn<String>(
    'name_ar',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _latitudeMeta = const VerificationMeta(
    'latitude',
  );
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
    'latitude',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _longitudeMeta = const VerificationMeta(
    'longitude',
  );
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
    'longitude',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _radiusMetersMeta = const VerificationMeta(
    'radiusMeters',
  );
  @override
  late final GeneratedColumn<double> radiusMeters = GeneratedColumn<double>(
    'radius_meters',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ritualNameMeta = const VerificationMeta(
    'ritualName',
  );
  @override
  late final GeneratedColumn<String> ritualName = GeneratedColumn<String>(
    'ritual_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    locationId,
    nameEn,
    nameAr,
    description,
    latitude,
    longitude,
    radiusMeters,
    ritualName,
    isActive,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'geofence_locations';
  @override
  VerificationContext validateIntegrity(
    Insertable<GeofenceLocation> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('location_id')) {
      context.handle(
        _locationIdMeta,
        locationId.isAcceptableOrUnknown(data['location_id']!, _locationIdMeta),
      );
    } else if (isInserting) {
      context.missing(_locationIdMeta);
    }
    if (data.containsKey('name_en')) {
      context.handle(
        _nameEnMeta,
        nameEn.isAcceptableOrUnknown(data['name_en']!, _nameEnMeta),
      );
    } else if (isInserting) {
      context.missing(_nameEnMeta);
    }
    if (data.containsKey('name_ar')) {
      context.handle(
        _nameArMeta,
        nameAr.isAcceptableOrUnknown(data['name_ar']!, _nameArMeta),
      );
    } else if (isInserting) {
      context.missing(_nameArMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('latitude')) {
      context.handle(
        _latitudeMeta,
        latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta),
      );
    } else if (isInserting) {
      context.missing(_latitudeMeta);
    }
    if (data.containsKey('longitude')) {
      context.handle(
        _longitudeMeta,
        longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta),
      );
    } else if (isInserting) {
      context.missing(_longitudeMeta);
    }
    if (data.containsKey('radius_meters')) {
      context.handle(
        _radiusMetersMeta,
        radiusMeters.isAcceptableOrUnknown(
          data['radius_meters']!,
          _radiusMetersMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_radiusMetersMeta);
    }
    if (data.containsKey('ritual_name')) {
      context.handle(
        _ritualNameMeta,
        ritualName.isAcceptableOrUnknown(data['ritual_name']!, _ritualNameMeta),
      );
    } else if (isInserting) {
      context.missing(_ritualNameMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GeofenceLocation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GeofenceLocation(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      locationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}location_id'],
      )!,
      nameEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_en'],
      )!,
      nameAr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_ar'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      latitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}latitude'],
      )!,
      longitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}longitude'],
      )!,
      radiusMeters: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}radius_meters'],
      )!,
      ritualName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ritual_name'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $GeofenceLocationsTable createAlias(String alias) {
    return $GeofenceLocationsTable(attachedDatabase, alias);
  }
}

class GeofenceLocation extends DataClass
    implements Insertable<GeofenceLocation> {
  final int id;
  final String locationId;
  final String nameEn;
  final String nameAr;
  final String description;
  final double latitude;
  final double longitude;
  final double radiusMeters;
  final String ritualName;
  final bool isActive;
  final DateTime createdAt;
  const GeofenceLocation({
    required this.id,
    required this.locationId,
    required this.nameEn,
    required this.nameAr,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.radiusMeters,
    required this.ritualName,
    required this.isActive,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['location_id'] = Variable<String>(locationId);
    map['name_en'] = Variable<String>(nameEn);
    map['name_ar'] = Variable<String>(nameAr);
    map['description'] = Variable<String>(description);
    map['latitude'] = Variable<double>(latitude);
    map['longitude'] = Variable<double>(longitude);
    map['radius_meters'] = Variable<double>(radiusMeters);
    map['ritual_name'] = Variable<String>(ritualName);
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  GeofenceLocationsCompanion toCompanion(bool nullToAbsent) {
    return GeofenceLocationsCompanion(
      id: Value(id),
      locationId: Value(locationId),
      nameEn: Value(nameEn),
      nameAr: Value(nameAr),
      description: Value(description),
      latitude: Value(latitude),
      longitude: Value(longitude),
      radiusMeters: Value(radiusMeters),
      ritualName: Value(ritualName),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
    );
  }

  factory GeofenceLocation.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GeofenceLocation(
      id: serializer.fromJson<int>(json['id']),
      locationId: serializer.fromJson<String>(json['locationId']),
      nameEn: serializer.fromJson<String>(json['nameEn']),
      nameAr: serializer.fromJson<String>(json['nameAr']),
      description: serializer.fromJson<String>(json['description']),
      latitude: serializer.fromJson<double>(json['latitude']),
      longitude: serializer.fromJson<double>(json['longitude']),
      radiusMeters: serializer.fromJson<double>(json['radiusMeters']),
      ritualName: serializer.fromJson<String>(json['ritualName']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'locationId': serializer.toJson<String>(locationId),
      'nameEn': serializer.toJson<String>(nameEn),
      'nameAr': serializer.toJson<String>(nameAr),
      'description': serializer.toJson<String>(description),
      'latitude': serializer.toJson<double>(latitude),
      'longitude': serializer.toJson<double>(longitude),
      'radiusMeters': serializer.toJson<double>(radiusMeters),
      'ritualName': serializer.toJson<String>(ritualName),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  GeofenceLocation copyWith({
    int? id,
    String? locationId,
    String? nameEn,
    String? nameAr,
    String? description,
    double? latitude,
    double? longitude,
    double? radiusMeters,
    String? ritualName,
    bool? isActive,
    DateTime? createdAt,
  }) => GeofenceLocation(
    id: id ?? this.id,
    locationId: locationId ?? this.locationId,
    nameEn: nameEn ?? this.nameEn,
    nameAr: nameAr ?? this.nameAr,
    description: description ?? this.description,
    latitude: latitude ?? this.latitude,
    longitude: longitude ?? this.longitude,
    radiusMeters: radiusMeters ?? this.radiusMeters,
    ritualName: ritualName ?? this.ritualName,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt ?? this.createdAt,
  );
  GeofenceLocation copyWithCompanion(GeofenceLocationsCompanion data) {
    return GeofenceLocation(
      id: data.id.present ? data.id.value : this.id,
      locationId: data.locationId.present
          ? data.locationId.value
          : this.locationId,
      nameEn: data.nameEn.present ? data.nameEn.value : this.nameEn,
      nameAr: data.nameAr.present ? data.nameAr.value : this.nameAr,
      description: data.description.present
          ? data.description.value
          : this.description,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
      radiusMeters: data.radiusMeters.present
          ? data.radiusMeters.value
          : this.radiusMeters,
      ritualName: data.ritualName.present
          ? data.ritualName.value
          : this.ritualName,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GeofenceLocation(')
          ..write('id: $id, ')
          ..write('locationId: $locationId, ')
          ..write('nameEn: $nameEn, ')
          ..write('nameAr: $nameAr, ')
          ..write('description: $description, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('radiusMeters: $radiusMeters, ')
          ..write('ritualName: $ritualName, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    locationId,
    nameEn,
    nameAr,
    description,
    latitude,
    longitude,
    radiusMeters,
    ritualName,
    isActive,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GeofenceLocation &&
          other.id == this.id &&
          other.locationId == this.locationId &&
          other.nameEn == this.nameEn &&
          other.nameAr == this.nameAr &&
          other.description == this.description &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.radiusMeters == this.radiusMeters &&
          other.ritualName == this.ritualName &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt);
}

class GeofenceLocationsCompanion extends UpdateCompanion<GeofenceLocation> {
  final Value<int> id;
  final Value<String> locationId;
  final Value<String> nameEn;
  final Value<String> nameAr;
  final Value<String> description;
  final Value<double> latitude;
  final Value<double> longitude;
  final Value<double> radiusMeters;
  final Value<String> ritualName;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  const GeofenceLocationsCompanion({
    this.id = const Value.absent(),
    this.locationId = const Value.absent(),
    this.nameEn = const Value.absent(),
    this.nameAr = const Value.absent(),
    this.description = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.radiusMeters = const Value.absent(),
    this.ritualName = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  GeofenceLocationsCompanion.insert({
    this.id = const Value.absent(),
    required String locationId,
    required String nameEn,
    required String nameAr,
    required String description,
    required double latitude,
    required double longitude,
    required double radiusMeters,
    required String ritualName,
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : locationId = Value(locationId),
       nameEn = Value(nameEn),
       nameAr = Value(nameAr),
       description = Value(description),
       latitude = Value(latitude),
       longitude = Value(longitude),
       radiusMeters = Value(radiusMeters),
       ritualName = Value(ritualName);
  static Insertable<GeofenceLocation> custom({
    Expression<int>? id,
    Expression<String>? locationId,
    Expression<String>? nameEn,
    Expression<String>? nameAr,
    Expression<String>? description,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<double>? radiusMeters,
    Expression<String>? ritualName,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (locationId != null) 'location_id': locationId,
      if (nameEn != null) 'name_en': nameEn,
      if (nameAr != null) 'name_ar': nameAr,
      if (description != null) 'description': description,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (radiusMeters != null) 'radius_meters': radiusMeters,
      if (ritualName != null) 'ritual_name': ritualName,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  GeofenceLocationsCompanion copyWith({
    Value<int>? id,
    Value<String>? locationId,
    Value<String>? nameEn,
    Value<String>? nameAr,
    Value<String>? description,
    Value<double>? latitude,
    Value<double>? longitude,
    Value<double>? radiusMeters,
    Value<String>? ritualName,
    Value<bool>? isActive,
    Value<DateTime>? createdAt,
  }) {
    return GeofenceLocationsCompanion(
      id: id ?? this.id,
      locationId: locationId ?? this.locationId,
      nameEn: nameEn ?? this.nameEn,
      nameAr: nameAr ?? this.nameAr,
      description: description ?? this.description,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      radiusMeters: radiusMeters ?? this.radiusMeters,
      ritualName: ritualName ?? this.ritualName,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (locationId.present) {
      map['location_id'] = Variable<String>(locationId.value);
    }
    if (nameEn.present) {
      map['name_en'] = Variable<String>(nameEn.value);
    }
    if (nameAr.present) {
      map['name_ar'] = Variable<String>(nameAr.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (radiusMeters.present) {
      map['radius_meters'] = Variable<double>(radiusMeters.value);
    }
    if (ritualName.present) {
      map['ritual_name'] = Variable<String>(ritualName.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GeofenceLocationsCompanion(')
          ..write('id: $id, ')
          ..write('locationId: $locationId, ')
          ..write('nameEn: $nameEn, ')
          ..write('nameAr: $nameAr, ')
          ..write('description: $description, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('radiusMeters: $radiusMeters, ')
          ..write('ritualName: $ritualName, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $RitualSettingsTable extends RitualSettings
    with TableInfo<$RitualSettingsTable, RitualSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RitualSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _ritualTypeMeta = const VerificationMeta(
    'ritualType',
  );
  @override
  late final GeneratedColumn<String> ritualType = GeneratedColumn<String>(
    'ritual_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _selectedRitualMeta = const VerificationMeta(
    'selectedRitual',
  );
  @override
  late final GeneratedColumn<String> selectedRitual = GeneratedColumn<String>(
    'selected_ritual',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _audioEnabledMeta = const VerificationMeta(
    'audioEnabled',
  );
  @override
  late final GeneratedColumn<bool> audioEnabled = GeneratedColumn<bool>(
    'audio_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("audio_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _hapticEnabledMeta = const VerificationMeta(
    'hapticEnabled',
  );
  @override
  late final GeneratedColumn<bool> hapticEnabled = GeneratedColumn<bool>(
    'haptic_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("haptic_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _audioVolumeMeta = const VerificationMeta(
    'audioVolume',
  );
  @override
  late final GeneratedColumn<int> audioVolume = GeneratedColumn<int>(
    'audio_volume',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(80),
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
    ritualType,
    selectedRitual,
    audioEnabled,
    hapticEnabled,
    audioVolume,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ritual_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<RitualSetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('ritual_type')) {
      context.handle(
        _ritualTypeMeta,
        ritualType.isAcceptableOrUnknown(data['ritual_type']!, _ritualTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_ritualTypeMeta);
    }
    if (data.containsKey('selected_ritual')) {
      context.handle(
        _selectedRitualMeta,
        selectedRitual.isAcceptableOrUnknown(
          data['selected_ritual']!,
          _selectedRitualMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_selectedRitualMeta);
    }
    if (data.containsKey('audio_enabled')) {
      context.handle(
        _audioEnabledMeta,
        audioEnabled.isAcceptableOrUnknown(
          data['audio_enabled']!,
          _audioEnabledMeta,
        ),
      );
    }
    if (data.containsKey('haptic_enabled')) {
      context.handle(
        _hapticEnabledMeta,
        hapticEnabled.isAcceptableOrUnknown(
          data['haptic_enabled']!,
          _hapticEnabledMeta,
        ),
      );
    }
    if (data.containsKey('audio_volume')) {
      context.handle(
        _audioVolumeMeta,
        audioVolume.isAcceptableOrUnknown(
          data['audio_volume']!,
          _audioVolumeMeta,
        ),
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
  RitualSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RitualSetting(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      ritualType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ritual_type'],
      )!,
      selectedRitual: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}selected_ritual'],
      )!,
      audioEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}audio_enabled'],
      )!,
      hapticEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}haptic_enabled'],
      )!,
      audioVolume: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}audio_volume'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $RitualSettingsTable createAlias(String alias) {
    return $RitualSettingsTable(attachedDatabase, alias);
  }
}

class RitualSetting extends DataClass implements Insertable<RitualSetting> {
  final int id;
  final String ritualType;
  final String selectedRitual;
  final bool audioEnabled;
  final bool hapticEnabled;
  final int audioVolume;
  final DateTime updatedAt;
  const RitualSetting({
    required this.id,
    required this.ritualType,
    required this.selectedRitual,
    required this.audioEnabled,
    required this.hapticEnabled,
    required this.audioVolume,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['ritual_type'] = Variable<String>(ritualType);
    map['selected_ritual'] = Variable<String>(selectedRitual);
    map['audio_enabled'] = Variable<bool>(audioEnabled);
    map['haptic_enabled'] = Variable<bool>(hapticEnabled);
    map['audio_volume'] = Variable<int>(audioVolume);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  RitualSettingsCompanion toCompanion(bool nullToAbsent) {
    return RitualSettingsCompanion(
      id: Value(id),
      ritualType: Value(ritualType),
      selectedRitual: Value(selectedRitual),
      audioEnabled: Value(audioEnabled),
      hapticEnabled: Value(hapticEnabled),
      audioVolume: Value(audioVolume),
      updatedAt: Value(updatedAt),
    );
  }

  factory RitualSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RitualSetting(
      id: serializer.fromJson<int>(json['id']),
      ritualType: serializer.fromJson<String>(json['ritualType']),
      selectedRitual: serializer.fromJson<String>(json['selectedRitual']),
      audioEnabled: serializer.fromJson<bool>(json['audioEnabled']),
      hapticEnabled: serializer.fromJson<bool>(json['hapticEnabled']),
      audioVolume: serializer.fromJson<int>(json['audioVolume']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'ritualType': serializer.toJson<String>(ritualType),
      'selectedRitual': serializer.toJson<String>(selectedRitual),
      'audioEnabled': serializer.toJson<bool>(audioEnabled),
      'hapticEnabled': serializer.toJson<bool>(hapticEnabled),
      'audioVolume': serializer.toJson<int>(audioVolume),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  RitualSetting copyWith({
    int? id,
    String? ritualType,
    String? selectedRitual,
    bool? audioEnabled,
    bool? hapticEnabled,
    int? audioVolume,
    DateTime? updatedAt,
  }) => RitualSetting(
    id: id ?? this.id,
    ritualType: ritualType ?? this.ritualType,
    selectedRitual: selectedRitual ?? this.selectedRitual,
    audioEnabled: audioEnabled ?? this.audioEnabled,
    hapticEnabled: hapticEnabled ?? this.hapticEnabled,
    audioVolume: audioVolume ?? this.audioVolume,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  RitualSetting copyWithCompanion(RitualSettingsCompanion data) {
    return RitualSetting(
      id: data.id.present ? data.id.value : this.id,
      ritualType: data.ritualType.present
          ? data.ritualType.value
          : this.ritualType,
      selectedRitual: data.selectedRitual.present
          ? data.selectedRitual.value
          : this.selectedRitual,
      audioEnabled: data.audioEnabled.present
          ? data.audioEnabled.value
          : this.audioEnabled,
      hapticEnabled: data.hapticEnabled.present
          ? data.hapticEnabled.value
          : this.hapticEnabled,
      audioVolume: data.audioVolume.present
          ? data.audioVolume.value
          : this.audioVolume,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RitualSetting(')
          ..write('id: $id, ')
          ..write('ritualType: $ritualType, ')
          ..write('selectedRitual: $selectedRitual, ')
          ..write('audioEnabled: $audioEnabled, ')
          ..write('hapticEnabled: $hapticEnabled, ')
          ..write('audioVolume: $audioVolume, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    ritualType,
    selectedRitual,
    audioEnabled,
    hapticEnabled,
    audioVolume,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RitualSetting &&
          other.id == this.id &&
          other.ritualType == this.ritualType &&
          other.selectedRitual == this.selectedRitual &&
          other.audioEnabled == this.audioEnabled &&
          other.hapticEnabled == this.hapticEnabled &&
          other.audioVolume == this.audioVolume &&
          other.updatedAt == this.updatedAt);
}

class RitualSettingsCompanion extends UpdateCompanion<RitualSetting> {
  final Value<int> id;
  final Value<String> ritualType;
  final Value<String> selectedRitual;
  final Value<bool> audioEnabled;
  final Value<bool> hapticEnabled;
  final Value<int> audioVolume;
  final Value<DateTime> updatedAt;
  const RitualSettingsCompanion({
    this.id = const Value.absent(),
    this.ritualType = const Value.absent(),
    this.selectedRitual = const Value.absent(),
    this.audioEnabled = const Value.absent(),
    this.hapticEnabled = const Value.absent(),
    this.audioVolume = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  RitualSettingsCompanion.insert({
    this.id = const Value.absent(),
    required String ritualType,
    required String selectedRitual,
    this.audioEnabled = const Value.absent(),
    this.hapticEnabled = const Value.absent(),
    this.audioVolume = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : ritualType = Value(ritualType),
       selectedRitual = Value(selectedRitual);
  static Insertable<RitualSetting> custom({
    Expression<int>? id,
    Expression<String>? ritualType,
    Expression<String>? selectedRitual,
    Expression<bool>? audioEnabled,
    Expression<bool>? hapticEnabled,
    Expression<int>? audioVolume,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ritualType != null) 'ritual_type': ritualType,
      if (selectedRitual != null) 'selected_ritual': selectedRitual,
      if (audioEnabled != null) 'audio_enabled': audioEnabled,
      if (hapticEnabled != null) 'haptic_enabled': hapticEnabled,
      if (audioVolume != null) 'audio_volume': audioVolume,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  RitualSettingsCompanion copyWith({
    Value<int>? id,
    Value<String>? ritualType,
    Value<String>? selectedRitual,
    Value<bool>? audioEnabled,
    Value<bool>? hapticEnabled,
    Value<int>? audioVolume,
    Value<DateTime>? updatedAt,
  }) {
    return RitualSettingsCompanion(
      id: id ?? this.id,
      ritualType: ritualType ?? this.ritualType,
      selectedRitual: selectedRitual ?? this.selectedRitual,
      audioEnabled: audioEnabled ?? this.audioEnabled,
      hapticEnabled: hapticEnabled ?? this.hapticEnabled,
      audioVolume: audioVolume ?? this.audioVolume,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (ritualType.present) {
      map['ritual_type'] = Variable<String>(ritualType.value);
    }
    if (selectedRitual.present) {
      map['selected_ritual'] = Variable<String>(selectedRitual.value);
    }
    if (audioEnabled.present) {
      map['audio_enabled'] = Variable<bool>(audioEnabled.value);
    }
    if (hapticEnabled.present) {
      map['haptic_enabled'] = Variable<bool>(hapticEnabled.value);
    }
    if (audioVolume.present) {
      map['audio_volume'] = Variable<int>(audioVolume.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RitualSettingsCompanion(')
          ..write('id: $id, ')
          ..write('ritualType: $ritualType, ')
          ..write('selectedRitual: $selectedRitual, ')
          ..write('audioEnabled: $audioEnabled, ')
          ..write('hapticEnabled: $hapticEnabled, ')
          ..write('audioVolume: $audioVolume, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $ChatConversationsTable extends ChatConversations
    with TableInfo<$ChatConversationsTable, ChatConversation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChatConversationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 100),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  @override
  List<GeneratedColumn> get $columns => [id, title, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'chat_conversations';
  @override
  VerificationContext validateIntegrity(
    Insertable<ChatConversation> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
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
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChatConversation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChatConversation(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ChatConversationsTable createAlias(String alias) {
    return $ChatConversationsTable(attachedDatabase, alias);
  }
}

class ChatConversation extends DataClass
    implements Insertable<ChatConversation> {
  final int id;
  final String title;
  final DateTime createdAt;
  final DateTime updatedAt;
  const ChatConversation({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ChatConversationsCompanion toCompanion(bool nullToAbsent) {
    return ChatConversationsCompanion(
      id: Value(id),
      title: Value(title),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory ChatConversation.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChatConversation(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ChatConversation copyWith({
    int? id,
    String? title,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => ChatConversation(
    id: id ?? this.id,
    title: title ?? this.title,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ChatConversation copyWithCompanion(ChatConversationsCompanion data) {
    return ChatConversation(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChatConversation(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChatConversation &&
          other.id == this.id &&
          other.title == this.title &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ChatConversationsCompanion extends UpdateCompanion<ChatConversation> {
  final Value<int> id;
  final Value<String> title;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const ChatConversationsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  ChatConversationsCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : title = Value(title);
  static Insertable<ChatConversation> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  ChatConversationsCompanion copyWith({
    Value<int>? id,
    Value<String>? title,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return ChatConversationsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChatConversationsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $ChatMessagesTable extends ChatMessages
    with TableInfo<$ChatMessagesTable, ChatMessage> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChatMessagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _conversationIdMeta = const VerificationMeta(
    'conversationId',
  );
  @override
  late final GeneratedColumn<int> conversationId = GeneratedColumn<int>(
    'conversation_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES chat_conversations (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isUserMeta = const VerificationMeta('isUser');
  @override
  late final GeneratedColumn<bool> isUser = GeneratedColumn<bool>(
    'is_user',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_user" IN (0, 1))',
    ),
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    conversationId,
    content,
    isUser,
    timestamp,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'chat_messages';
  @override
  VerificationContext validateIntegrity(
    Insertable<ChatMessage> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('conversation_id')) {
      context.handle(
        _conversationIdMeta,
        conversationId.isAcceptableOrUnknown(
          data['conversation_id']!,
          _conversationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_conversationIdMeta);
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('is_user')) {
      context.handle(
        _isUserMeta,
        isUser.isAcceptableOrUnknown(data['is_user']!, _isUserMeta),
      );
    } else if (isInserting) {
      context.missing(_isUserMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChatMessage map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChatMessage(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      conversationId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}conversation_id'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
      isUser: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_user'],
      )!,
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}timestamp'],
      )!,
    );
  }

  @override
  $ChatMessagesTable createAlias(String alias) {
    return $ChatMessagesTable(attachedDatabase, alias);
  }
}

class ChatMessage extends DataClass implements Insertable<ChatMessage> {
  final int id;
  final int conversationId;
  final String content;
  final bool isUser;
  final DateTime timestamp;
  const ChatMessage({
    required this.id,
    required this.conversationId,
    required this.content,
    required this.isUser,
    required this.timestamp,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['conversation_id'] = Variable<int>(conversationId);
    map['content'] = Variable<String>(content);
    map['is_user'] = Variable<bool>(isUser);
    map['timestamp'] = Variable<DateTime>(timestamp);
    return map;
  }

  ChatMessagesCompanion toCompanion(bool nullToAbsent) {
    return ChatMessagesCompanion(
      id: Value(id),
      conversationId: Value(conversationId),
      content: Value(content),
      isUser: Value(isUser),
      timestamp: Value(timestamp),
    );
  }

  factory ChatMessage.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChatMessage(
      id: serializer.fromJson<int>(json['id']),
      conversationId: serializer.fromJson<int>(json['conversationId']),
      content: serializer.fromJson<String>(json['content']),
      isUser: serializer.fromJson<bool>(json['isUser']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'conversationId': serializer.toJson<int>(conversationId),
      'content': serializer.toJson<String>(content),
      'isUser': serializer.toJson<bool>(isUser),
      'timestamp': serializer.toJson<DateTime>(timestamp),
    };
  }

  ChatMessage copyWith({
    int? id,
    int? conversationId,
    String? content,
    bool? isUser,
    DateTime? timestamp,
  }) => ChatMessage(
    id: id ?? this.id,
    conversationId: conversationId ?? this.conversationId,
    content: content ?? this.content,
    isUser: isUser ?? this.isUser,
    timestamp: timestamp ?? this.timestamp,
  );
  ChatMessage copyWithCompanion(ChatMessagesCompanion data) {
    return ChatMessage(
      id: data.id.present ? data.id.value : this.id,
      conversationId: data.conversationId.present
          ? data.conversationId.value
          : this.conversationId,
      content: data.content.present ? data.content.value : this.content,
      isUser: data.isUser.present ? data.isUser.value : this.isUser,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChatMessage(')
          ..write('id: $id, ')
          ..write('conversationId: $conversationId, ')
          ..write('content: $content, ')
          ..write('isUser: $isUser, ')
          ..write('timestamp: $timestamp')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, conversationId, content, isUser, timestamp);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChatMessage &&
          other.id == this.id &&
          other.conversationId == this.conversationId &&
          other.content == this.content &&
          other.isUser == this.isUser &&
          other.timestamp == this.timestamp);
}

class ChatMessagesCompanion extends UpdateCompanion<ChatMessage> {
  final Value<int> id;
  final Value<int> conversationId;
  final Value<String> content;
  final Value<bool> isUser;
  final Value<DateTime> timestamp;
  const ChatMessagesCompanion({
    this.id = const Value.absent(),
    this.conversationId = const Value.absent(),
    this.content = const Value.absent(),
    this.isUser = const Value.absent(),
    this.timestamp = const Value.absent(),
  });
  ChatMessagesCompanion.insert({
    this.id = const Value.absent(),
    required int conversationId,
    required String content,
    required bool isUser,
    this.timestamp = const Value.absent(),
  }) : conversationId = Value(conversationId),
       content = Value(content),
       isUser = Value(isUser);
  static Insertable<ChatMessage> custom({
    Expression<int>? id,
    Expression<int>? conversationId,
    Expression<String>? content,
    Expression<bool>? isUser,
    Expression<DateTime>? timestamp,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (conversationId != null) 'conversation_id': conversationId,
      if (content != null) 'content': content,
      if (isUser != null) 'is_user': isUser,
      if (timestamp != null) 'timestamp': timestamp,
    });
  }

  ChatMessagesCompanion copyWith({
    Value<int>? id,
    Value<int>? conversationId,
    Value<String>? content,
    Value<bool>? isUser,
    Value<DateTime>? timestamp,
  }) {
    return ChatMessagesCompanion(
      id: id ?? this.id,
      conversationId: conversationId ?? this.conversationId,
      content: content ?? this.content,
      isUser: isUser ?? this.isUser,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (conversationId.present) {
      map['conversation_id'] = Variable<int>(conversationId.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (isUser.present) {
      map['is_user'] = Variable<bool>(isUser.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChatMessagesCompanion(')
          ..write('id: $id, ')
          ..write('conversationId: $conversationId, ')
          ..write('content: $content, ')
          ..write('isUser: $isUser, ')
          ..write('timestamp: $timestamp')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $PermitsTable permits = $PermitsTable(this);
  late final $AppSettingsTable appSettings = $AppSettingsTable(this);
  late final $DuasTable duas = $DuasTable(this);
  late final $GeofenceLocationsTable geofenceLocations =
      $GeofenceLocationsTable(this);
  late final $RitualSettingsTable ritualSettings = $RitualSettingsTable(this);
  late final $ChatConversationsTable chatConversations =
      $ChatConversationsTable(this);
  late final $ChatMessagesTable chatMessages = $ChatMessagesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    permits,
    appSettings,
    duas,
    geofenceLocations,
    ritualSettings,
    chatConversations,
    chatMessages,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'chat_conversations',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('chat_messages', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$PermitsTableCreateCompanionBuilder =
    PermitsCompanion Function({
      Value<int> id,
      required String permitNumber,
      required String fullName,
      required String permitType,
      required DateTime startDate,
      required DateTime endDate,
      Value<String?> encryptedData,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$PermitsTableUpdateCompanionBuilder =
    PermitsCompanion Function({
      Value<int> id,
      Value<String> permitNumber,
      Value<String> fullName,
      Value<String> permitType,
      Value<DateTime> startDate,
      Value<DateTime> endDate,
      Value<String?> encryptedData,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

class $$PermitsTableFilterComposer
    extends Composer<_$AppDatabase, $PermitsTable> {
  $$PermitsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get permitNumber => $composableBuilder(
    column: $table.permitNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fullName => $composableBuilder(
    column: $table.fullName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get permitType => $composableBuilder(
    column: $table.permitType,
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

  ColumnFilters<String> get encryptedData => $composableBuilder(
    column: $table.encryptedData,
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
}

class $$PermitsTableOrderingComposer
    extends Composer<_$AppDatabase, $PermitsTable> {
  $$PermitsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get permitNumber => $composableBuilder(
    column: $table.permitNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fullName => $composableBuilder(
    column: $table.fullName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get permitType => $composableBuilder(
    column: $table.permitType,
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

  ColumnOrderings<String> get encryptedData => $composableBuilder(
    column: $table.encryptedData,
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
}

class $$PermitsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PermitsTable> {
  $$PermitsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get permitNumber => $composableBuilder(
    column: $table.permitNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get fullName =>
      $composableBuilder(column: $table.fullName, builder: (column) => column);

  GeneratedColumn<String> get permitType => $composableBuilder(
    column: $table.permitType,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<String> get encryptedData => $composableBuilder(
    column: $table.encryptedData,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$PermitsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PermitsTable,
          Permit,
          $$PermitsTableFilterComposer,
          $$PermitsTableOrderingComposer,
          $$PermitsTableAnnotationComposer,
          $$PermitsTableCreateCompanionBuilder,
          $$PermitsTableUpdateCompanionBuilder,
          (Permit, BaseReferences<_$AppDatabase, $PermitsTable, Permit>),
          Permit,
          PrefetchHooks Function()
        > {
  $$PermitsTableTableManager(_$AppDatabase db, $PermitsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PermitsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PermitsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PermitsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> permitNumber = const Value.absent(),
                Value<String> fullName = const Value.absent(),
                Value<String> permitType = const Value.absent(),
                Value<DateTime> startDate = const Value.absent(),
                Value<DateTime> endDate = const Value.absent(),
                Value<String?> encryptedData = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => PermitsCompanion(
                id: id,
                permitNumber: permitNumber,
                fullName: fullName,
                permitType: permitType,
                startDate: startDate,
                endDate: endDate,
                encryptedData: encryptedData,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String permitNumber,
                required String fullName,
                required String permitType,
                required DateTime startDate,
                required DateTime endDate,
                Value<String?> encryptedData = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => PermitsCompanion.insert(
                id: id,
                permitNumber: permitNumber,
                fullName: fullName,
                permitType: permitType,
                startDate: startDate,
                endDate: endDate,
                encryptedData: encryptedData,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PermitsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PermitsTable,
      Permit,
      $$PermitsTableFilterComposer,
      $$PermitsTableOrderingComposer,
      $$PermitsTableAnnotationComposer,
      $$PermitsTableCreateCompanionBuilder,
      $$PermitsTableUpdateCompanionBuilder,
      (Permit, BaseReferences<_$AppDatabase, $PermitsTable, Permit>),
      Permit,
      PrefetchHooks Function()
    >;
typedef $$AppSettingsTableCreateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<int> id,
      required String key,
      required String value,
      Value<DateTime> updatedAt,
    });
typedef $$AppSettingsTableUpdateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<int> id,
      Value<String> key,
      Value<String> value,
      Value<DateTime> updatedAt,
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
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
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
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
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
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
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
                Value<int> id = const Value.absent(),
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => AppSettingsCompanion(
                id: id,
                key: key,
                value: value,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String key,
                required String value,
                Value<DateTime> updatedAt = const Value.absent(),
              }) => AppSettingsCompanion.insert(
                id: id,
                key: key,
                value: value,
                updatedAt: updatedAt,
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
typedef $$DuasTableCreateCompanionBuilder =
    DuasCompanion Function({
      Value<int> id,
      required String locationId,
      required String ritualType,
      required String arabicText,
      required String englishTranslation,
      Value<String?> transliteration,
      Value<String?> audioFileName,
      Value<int> displayOrder,
      Value<DateTime> createdAt,
    });
typedef $$DuasTableUpdateCompanionBuilder =
    DuasCompanion Function({
      Value<int> id,
      Value<String> locationId,
      Value<String> ritualType,
      Value<String> arabicText,
      Value<String> englishTranslation,
      Value<String?> transliteration,
      Value<String?> audioFileName,
      Value<int> displayOrder,
      Value<DateTime> createdAt,
    });

class $$DuasTableFilterComposer extends Composer<_$AppDatabase, $DuasTable> {
  $$DuasTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get locationId => $composableBuilder(
    column: $table.locationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ritualType => $composableBuilder(
    column: $table.ritualType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get arabicText => $composableBuilder(
    column: $table.arabicText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get englishTranslation => $composableBuilder(
    column: $table.englishTranslation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get transliteration => $composableBuilder(
    column: $table.transliteration,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get audioFileName => $composableBuilder(
    column: $table.audioFileName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DuasTableOrderingComposer extends Composer<_$AppDatabase, $DuasTable> {
  $$DuasTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get locationId => $composableBuilder(
    column: $table.locationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ritualType => $composableBuilder(
    column: $table.ritualType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get arabicText => $composableBuilder(
    column: $table.arabicText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get englishTranslation => $composableBuilder(
    column: $table.englishTranslation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get transliteration => $composableBuilder(
    column: $table.transliteration,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get audioFileName => $composableBuilder(
    column: $table.audioFileName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DuasTableAnnotationComposer
    extends Composer<_$AppDatabase, $DuasTable> {
  $$DuasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get locationId => $composableBuilder(
    column: $table.locationId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get ritualType => $composableBuilder(
    column: $table.ritualType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get arabicText => $composableBuilder(
    column: $table.arabicText,
    builder: (column) => column,
  );

  GeneratedColumn<String> get englishTranslation => $composableBuilder(
    column: $table.englishTranslation,
    builder: (column) => column,
  );

  GeneratedColumn<String> get transliteration => $composableBuilder(
    column: $table.transliteration,
    builder: (column) => column,
  );

  GeneratedColumn<String> get audioFileName => $composableBuilder(
    column: $table.audioFileName,
    builder: (column) => column,
  );

  GeneratedColumn<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$DuasTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DuasTable,
          Dua,
          $$DuasTableFilterComposer,
          $$DuasTableOrderingComposer,
          $$DuasTableAnnotationComposer,
          $$DuasTableCreateCompanionBuilder,
          $$DuasTableUpdateCompanionBuilder,
          (Dua, BaseReferences<_$AppDatabase, $DuasTable, Dua>),
          Dua,
          PrefetchHooks Function()
        > {
  $$DuasTableTableManager(_$AppDatabase db, $DuasTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DuasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DuasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DuasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> locationId = const Value.absent(),
                Value<String> ritualType = const Value.absent(),
                Value<String> arabicText = const Value.absent(),
                Value<String> englishTranslation = const Value.absent(),
                Value<String?> transliteration = const Value.absent(),
                Value<String?> audioFileName = const Value.absent(),
                Value<int> displayOrder = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => DuasCompanion(
                id: id,
                locationId: locationId,
                ritualType: ritualType,
                arabicText: arabicText,
                englishTranslation: englishTranslation,
                transliteration: transliteration,
                audioFileName: audioFileName,
                displayOrder: displayOrder,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String locationId,
                required String ritualType,
                required String arabicText,
                required String englishTranslation,
                Value<String?> transliteration = const Value.absent(),
                Value<String?> audioFileName = const Value.absent(),
                Value<int> displayOrder = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => DuasCompanion.insert(
                id: id,
                locationId: locationId,
                ritualType: ritualType,
                arabicText: arabicText,
                englishTranslation: englishTranslation,
                transliteration: transliteration,
                audioFileName: audioFileName,
                displayOrder: displayOrder,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DuasTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DuasTable,
      Dua,
      $$DuasTableFilterComposer,
      $$DuasTableOrderingComposer,
      $$DuasTableAnnotationComposer,
      $$DuasTableCreateCompanionBuilder,
      $$DuasTableUpdateCompanionBuilder,
      (Dua, BaseReferences<_$AppDatabase, $DuasTable, Dua>),
      Dua,
      PrefetchHooks Function()
    >;
typedef $$GeofenceLocationsTableCreateCompanionBuilder =
    GeofenceLocationsCompanion Function({
      Value<int> id,
      required String locationId,
      required String nameEn,
      required String nameAr,
      required String description,
      required double latitude,
      required double longitude,
      required double radiusMeters,
      required String ritualName,
      Value<bool> isActive,
      Value<DateTime> createdAt,
    });
typedef $$GeofenceLocationsTableUpdateCompanionBuilder =
    GeofenceLocationsCompanion Function({
      Value<int> id,
      Value<String> locationId,
      Value<String> nameEn,
      Value<String> nameAr,
      Value<String> description,
      Value<double> latitude,
      Value<double> longitude,
      Value<double> radiusMeters,
      Value<String> ritualName,
      Value<bool> isActive,
      Value<DateTime> createdAt,
    });

class $$GeofenceLocationsTableFilterComposer
    extends Composer<_$AppDatabase, $GeofenceLocationsTable> {
  $$GeofenceLocationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get locationId => $composableBuilder(
    column: $table.locationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameEn => $composableBuilder(
    column: $table.nameEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameAr => $composableBuilder(
    column: $table.nameAr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get radiusMeters => $composableBuilder(
    column: $table.radiusMeters,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ritualName => $composableBuilder(
    column: $table.ritualName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$GeofenceLocationsTableOrderingComposer
    extends Composer<_$AppDatabase, $GeofenceLocationsTable> {
  $$GeofenceLocationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get locationId => $composableBuilder(
    column: $table.locationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameEn => $composableBuilder(
    column: $table.nameEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameAr => $composableBuilder(
    column: $table.nameAr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get radiusMeters => $composableBuilder(
    column: $table.radiusMeters,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ritualName => $composableBuilder(
    column: $table.ritualName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$GeofenceLocationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $GeofenceLocationsTable> {
  $$GeofenceLocationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get locationId => $composableBuilder(
    column: $table.locationId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get nameEn =>
      $composableBuilder(column: $table.nameEn, builder: (column) => column);

  GeneratedColumn<String> get nameAr =>
      $composableBuilder(column: $table.nameAr, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);

  GeneratedColumn<double> get radiusMeters => $composableBuilder(
    column: $table.radiusMeters,
    builder: (column) => column,
  );

  GeneratedColumn<String> get ritualName => $composableBuilder(
    column: $table.ritualName,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$GeofenceLocationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GeofenceLocationsTable,
          GeofenceLocation,
          $$GeofenceLocationsTableFilterComposer,
          $$GeofenceLocationsTableOrderingComposer,
          $$GeofenceLocationsTableAnnotationComposer,
          $$GeofenceLocationsTableCreateCompanionBuilder,
          $$GeofenceLocationsTableUpdateCompanionBuilder,
          (
            GeofenceLocation,
            BaseReferences<
              _$AppDatabase,
              $GeofenceLocationsTable,
              GeofenceLocation
            >,
          ),
          GeofenceLocation,
          PrefetchHooks Function()
        > {
  $$GeofenceLocationsTableTableManager(
    _$AppDatabase db,
    $GeofenceLocationsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GeofenceLocationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GeofenceLocationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GeofenceLocationsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> locationId = const Value.absent(),
                Value<String> nameEn = const Value.absent(),
                Value<String> nameAr = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<double> latitude = const Value.absent(),
                Value<double> longitude = const Value.absent(),
                Value<double> radiusMeters = const Value.absent(),
                Value<String> ritualName = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => GeofenceLocationsCompanion(
                id: id,
                locationId: locationId,
                nameEn: nameEn,
                nameAr: nameAr,
                description: description,
                latitude: latitude,
                longitude: longitude,
                radiusMeters: radiusMeters,
                ritualName: ritualName,
                isActive: isActive,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String locationId,
                required String nameEn,
                required String nameAr,
                required String description,
                required double latitude,
                required double longitude,
                required double radiusMeters,
                required String ritualName,
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => GeofenceLocationsCompanion.insert(
                id: id,
                locationId: locationId,
                nameEn: nameEn,
                nameAr: nameAr,
                description: description,
                latitude: latitude,
                longitude: longitude,
                radiusMeters: radiusMeters,
                ritualName: ritualName,
                isActive: isActive,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$GeofenceLocationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GeofenceLocationsTable,
      GeofenceLocation,
      $$GeofenceLocationsTableFilterComposer,
      $$GeofenceLocationsTableOrderingComposer,
      $$GeofenceLocationsTableAnnotationComposer,
      $$GeofenceLocationsTableCreateCompanionBuilder,
      $$GeofenceLocationsTableUpdateCompanionBuilder,
      (
        GeofenceLocation,
        BaseReferences<
          _$AppDatabase,
          $GeofenceLocationsTable,
          GeofenceLocation
        >,
      ),
      GeofenceLocation,
      PrefetchHooks Function()
    >;
typedef $$RitualSettingsTableCreateCompanionBuilder =
    RitualSettingsCompanion Function({
      Value<int> id,
      required String ritualType,
      required String selectedRitual,
      Value<bool> audioEnabled,
      Value<bool> hapticEnabled,
      Value<int> audioVolume,
      Value<DateTime> updatedAt,
    });
typedef $$RitualSettingsTableUpdateCompanionBuilder =
    RitualSettingsCompanion Function({
      Value<int> id,
      Value<String> ritualType,
      Value<String> selectedRitual,
      Value<bool> audioEnabled,
      Value<bool> hapticEnabled,
      Value<int> audioVolume,
      Value<DateTime> updatedAt,
    });

class $$RitualSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $RitualSettingsTable> {
  $$RitualSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ritualType => $composableBuilder(
    column: $table.ritualType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get selectedRitual => $composableBuilder(
    column: $table.selectedRitual,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get audioEnabled => $composableBuilder(
    column: $table.audioEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get hapticEnabled => $composableBuilder(
    column: $table.hapticEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get audioVolume => $composableBuilder(
    column: $table.audioVolume,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RitualSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $RitualSettingsTable> {
  $$RitualSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ritualType => $composableBuilder(
    column: $table.ritualType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get selectedRitual => $composableBuilder(
    column: $table.selectedRitual,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get audioEnabled => $composableBuilder(
    column: $table.audioEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get hapticEnabled => $composableBuilder(
    column: $table.hapticEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get audioVolume => $composableBuilder(
    column: $table.audioVolume,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RitualSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RitualSettingsTable> {
  $$RitualSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get ritualType => $composableBuilder(
    column: $table.ritualType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get selectedRitual => $composableBuilder(
    column: $table.selectedRitual,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get audioEnabled => $composableBuilder(
    column: $table.audioEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get hapticEnabled => $composableBuilder(
    column: $table.hapticEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<int> get audioVolume => $composableBuilder(
    column: $table.audioVolume,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$RitualSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RitualSettingsTable,
          RitualSetting,
          $$RitualSettingsTableFilterComposer,
          $$RitualSettingsTableOrderingComposer,
          $$RitualSettingsTableAnnotationComposer,
          $$RitualSettingsTableCreateCompanionBuilder,
          $$RitualSettingsTableUpdateCompanionBuilder,
          (
            RitualSetting,
            BaseReferences<_$AppDatabase, $RitualSettingsTable, RitualSetting>,
          ),
          RitualSetting,
          PrefetchHooks Function()
        > {
  $$RitualSettingsTableTableManager(
    _$AppDatabase db,
    $RitualSettingsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RitualSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RitualSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RitualSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> ritualType = const Value.absent(),
                Value<String> selectedRitual = const Value.absent(),
                Value<bool> audioEnabled = const Value.absent(),
                Value<bool> hapticEnabled = const Value.absent(),
                Value<int> audioVolume = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => RitualSettingsCompanion(
                id: id,
                ritualType: ritualType,
                selectedRitual: selectedRitual,
                audioEnabled: audioEnabled,
                hapticEnabled: hapticEnabled,
                audioVolume: audioVolume,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String ritualType,
                required String selectedRitual,
                Value<bool> audioEnabled = const Value.absent(),
                Value<bool> hapticEnabled = const Value.absent(),
                Value<int> audioVolume = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => RitualSettingsCompanion.insert(
                id: id,
                ritualType: ritualType,
                selectedRitual: selectedRitual,
                audioEnabled: audioEnabled,
                hapticEnabled: hapticEnabled,
                audioVolume: audioVolume,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RitualSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RitualSettingsTable,
      RitualSetting,
      $$RitualSettingsTableFilterComposer,
      $$RitualSettingsTableOrderingComposer,
      $$RitualSettingsTableAnnotationComposer,
      $$RitualSettingsTableCreateCompanionBuilder,
      $$RitualSettingsTableUpdateCompanionBuilder,
      (
        RitualSetting,
        BaseReferences<_$AppDatabase, $RitualSettingsTable, RitualSetting>,
      ),
      RitualSetting,
      PrefetchHooks Function()
    >;
typedef $$ChatConversationsTableCreateCompanionBuilder =
    ChatConversationsCompanion Function({
      Value<int> id,
      required String title,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$ChatConversationsTableUpdateCompanionBuilder =
    ChatConversationsCompanion Function({
      Value<int> id,
      Value<String> title,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$ChatConversationsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ChatConversationsTable,
          ChatConversation
        > {
  $$ChatConversationsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$ChatMessagesTable, List<ChatMessage>>
  _chatMessagesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.chatMessages,
    aliasName: $_aliasNameGenerator(
      db.chatConversations.id,
      db.chatMessages.conversationId,
    ),
  );

  $$ChatMessagesTableProcessedTableManager get chatMessagesRefs {
    final manager = $$ChatMessagesTableTableManager(
      $_db,
      $_db.chatMessages,
    ).filter((f) => f.conversationId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_chatMessagesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ChatConversationsTableFilterComposer
    extends Composer<_$AppDatabase, $ChatConversationsTable> {
  $$ChatConversationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
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

  Expression<bool> chatMessagesRefs(
    Expression<bool> Function($$ChatMessagesTableFilterComposer f) f,
  ) {
    final $$ChatMessagesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.chatMessages,
      getReferencedColumn: (t) => t.conversationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChatMessagesTableFilterComposer(
            $db: $db,
            $table: $db.chatMessages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ChatConversationsTableOrderingComposer
    extends Composer<_$AppDatabase, $ChatConversationsTable> {
  $$ChatConversationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
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
}

class $$ChatConversationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChatConversationsTable> {
  $$ChatConversationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> chatMessagesRefs<T extends Object>(
    Expression<T> Function($$ChatMessagesTableAnnotationComposer a) f,
  ) {
    final $$ChatMessagesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.chatMessages,
      getReferencedColumn: (t) => t.conversationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChatMessagesTableAnnotationComposer(
            $db: $db,
            $table: $db.chatMessages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ChatConversationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ChatConversationsTable,
          ChatConversation,
          $$ChatConversationsTableFilterComposer,
          $$ChatConversationsTableOrderingComposer,
          $$ChatConversationsTableAnnotationComposer,
          $$ChatConversationsTableCreateCompanionBuilder,
          $$ChatConversationsTableUpdateCompanionBuilder,
          (ChatConversation, $$ChatConversationsTableReferences),
          ChatConversation,
          PrefetchHooks Function({bool chatMessagesRefs})
        > {
  $$ChatConversationsTableTableManager(
    _$AppDatabase db,
    $ChatConversationsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChatConversationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChatConversationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChatConversationsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => ChatConversationsCompanion(
                id: id,
                title: title,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String title,
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => ChatConversationsCompanion.insert(
                id: id,
                title: title,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ChatConversationsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({chatMessagesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (chatMessagesRefs) db.chatMessages],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (chatMessagesRefs)
                    await $_getPrefetchedData<
                      ChatConversation,
                      $ChatConversationsTable,
                      ChatMessage
                    >(
                      currentTable: table,
                      referencedTable: $$ChatConversationsTableReferences
                          ._chatMessagesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$ChatConversationsTableReferences(
                            db,
                            table,
                            p0,
                          ).chatMessagesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.conversationId == item.id,
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

typedef $$ChatConversationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ChatConversationsTable,
      ChatConversation,
      $$ChatConversationsTableFilterComposer,
      $$ChatConversationsTableOrderingComposer,
      $$ChatConversationsTableAnnotationComposer,
      $$ChatConversationsTableCreateCompanionBuilder,
      $$ChatConversationsTableUpdateCompanionBuilder,
      (ChatConversation, $$ChatConversationsTableReferences),
      ChatConversation,
      PrefetchHooks Function({bool chatMessagesRefs})
    >;
typedef $$ChatMessagesTableCreateCompanionBuilder =
    ChatMessagesCompanion Function({
      Value<int> id,
      required int conversationId,
      required String content,
      required bool isUser,
      Value<DateTime> timestamp,
    });
typedef $$ChatMessagesTableUpdateCompanionBuilder =
    ChatMessagesCompanion Function({
      Value<int> id,
      Value<int> conversationId,
      Value<String> content,
      Value<bool> isUser,
      Value<DateTime> timestamp,
    });

final class $$ChatMessagesTableReferences
    extends BaseReferences<_$AppDatabase, $ChatMessagesTable, ChatMessage> {
  $$ChatMessagesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ChatConversationsTable _conversationIdTable(_$AppDatabase db) =>
      db.chatConversations.createAlias(
        $_aliasNameGenerator(
          db.chatMessages.conversationId,
          db.chatConversations.id,
        ),
      );

  $$ChatConversationsTableProcessedTableManager get conversationId {
    final $_column = $_itemColumn<int>('conversation_id')!;

    final manager = $$ChatConversationsTableTableManager(
      $_db,
      $_db.chatConversations,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_conversationIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ChatMessagesTableFilterComposer
    extends Composer<_$AppDatabase, $ChatMessagesTable> {
  $$ChatMessagesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isUser => $composableBuilder(
    column: $table.isUser,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );

  $$ChatConversationsTableFilterComposer get conversationId {
    final $$ChatConversationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.conversationId,
      referencedTable: $db.chatConversations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChatConversationsTableFilterComposer(
            $db: $db,
            $table: $db.chatConversations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ChatMessagesTableOrderingComposer
    extends Composer<_$AppDatabase, $ChatMessagesTable> {
  $$ChatMessagesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isUser => $composableBuilder(
    column: $table.isUser,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );

  $$ChatConversationsTableOrderingComposer get conversationId {
    final $$ChatConversationsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.conversationId,
      referencedTable: $db.chatConversations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChatConversationsTableOrderingComposer(
            $db: $db,
            $table: $db.chatConversations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ChatMessagesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChatMessagesTable> {
  $$ChatMessagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<bool> get isUser =>
      $composableBuilder(column: $table.isUser, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  $$ChatConversationsTableAnnotationComposer get conversationId {
    final $$ChatConversationsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.conversationId,
          referencedTable: $db.chatConversations,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ChatConversationsTableAnnotationComposer(
                $db: $db,
                $table: $db.chatConversations,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$ChatMessagesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ChatMessagesTable,
          ChatMessage,
          $$ChatMessagesTableFilterComposer,
          $$ChatMessagesTableOrderingComposer,
          $$ChatMessagesTableAnnotationComposer,
          $$ChatMessagesTableCreateCompanionBuilder,
          $$ChatMessagesTableUpdateCompanionBuilder,
          (ChatMessage, $$ChatMessagesTableReferences),
          ChatMessage,
          PrefetchHooks Function({bool conversationId})
        > {
  $$ChatMessagesTableTableManager(_$AppDatabase db, $ChatMessagesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChatMessagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChatMessagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChatMessagesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> conversationId = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<bool> isUser = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
              }) => ChatMessagesCompanion(
                id: id,
                conversationId: conversationId,
                content: content,
                isUser: isUser,
                timestamp: timestamp,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int conversationId,
                required String content,
                required bool isUser,
                Value<DateTime> timestamp = const Value.absent(),
              }) => ChatMessagesCompanion.insert(
                id: id,
                conversationId: conversationId,
                content: content,
                isUser: isUser,
                timestamp: timestamp,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ChatMessagesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({conversationId = false}) {
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
                    if (conversationId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.conversationId,
                                referencedTable: $$ChatMessagesTableReferences
                                    ._conversationIdTable(db),
                                referencedColumn: $$ChatMessagesTableReferences
                                    ._conversationIdTable(db)
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

typedef $$ChatMessagesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ChatMessagesTable,
      ChatMessage,
      $$ChatMessagesTableFilterComposer,
      $$ChatMessagesTableOrderingComposer,
      $$ChatMessagesTableAnnotationComposer,
      $$ChatMessagesTableCreateCompanionBuilder,
      $$ChatMessagesTableUpdateCompanionBuilder,
      (ChatMessage, $$ChatMessagesTableReferences),
      ChatMessage,
      PrefetchHooks Function({bool conversationId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$PermitsTableTableManager get permits =>
      $$PermitsTableTableManager(_db, _db.permits);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db, _db.appSettings);
  $$DuasTableTableManager get duas => $$DuasTableTableManager(_db, _db.duas);
  $$GeofenceLocationsTableTableManager get geofenceLocations =>
      $$GeofenceLocationsTableTableManager(_db, _db.geofenceLocations);
  $$RitualSettingsTableTableManager get ritualSettings =>
      $$RitualSettingsTableTableManager(_db, _db.ritualSettings);
  $$ChatConversationsTableTableManager get chatConversations =>
      $$ChatConversationsTableTableManager(_db, _db.chatConversations);
  $$ChatMessagesTableTableManager get chatMessages =>
      $$ChatMessagesTableTableManager(_db, _db.chatMessages);
}
