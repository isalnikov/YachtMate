// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $UserActionAuditsTable extends UserActionAudits
    with TableInfo<$UserActionAuditsTable, UserActionAudit> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserActionAuditsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _tMeta = const VerificationMeta('t');
  @override
  late final GeneratedColumn<int> t = GeneratedColumn<int>(
    't',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
    'session_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _moduleMeta = const VerificationMeta('module');
  @override
  late final GeneratedColumn<String> module = GeneratedColumn<String>(
    'module',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _actionMeta = const VerificationMeta('action');
  @override
  late final GeneratedColumn<String> action = GeneratedColumn<String>(
    'action',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _severityMeta = const VerificationMeta(
    'severity',
  );
  @override
  late final GeneratedColumn<String> severity = GeneratedColumn<String>(
    'severity',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('info'),
  );
  static const VerificationMeta _contextJsonMeta = const VerificationMeta(
    'contextJson',
  );
  @override
  late final GeneratedColumn<String> contextJson = GeneratedColumn<String>(
    'context_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    t,
    sessionId,
    module,
    action,
    severity,
    contextJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_action_audits';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserActionAudit> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('t')) {
      context.handle(_tMeta, t.isAcceptableOrUnknown(data['t']!, _tMeta));
    } else if (isInserting) {
      context.missing(_tMeta);
    }
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('module')) {
      context.handle(
        _moduleMeta,
        module.isAcceptableOrUnknown(data['module']!, _moduleMeta),
      );
    } else if (isInserting) {
      context.missing(_moduleMeta);
    }
    if (data.containsKey('action')) {
      context.handle(
        _actionMeta,
        action.isAcceptableOrUnknown(data['action']!, _actionMeta),
      );
    } else if (isInserting) {
      context.missing(_actionMeta);
    }
    if (data.containsKey('severity')) {
      context.handle(
        _severityMeta,
        severity.isAcceptableOrUnknown(data['severity']!, _severityMeta),
      );
    }
    if (data.containsKey('context_json')) {
      context.handle(
        _contextJsonMeta,
        contextJson.isAcceptableOrUnknown(
          data['context_json']!,
          _contextJsonMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserActionAudit map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserActionAudit(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      t: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}t'],
      )!,
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}session_id'],
      )!,
      module: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}module'],
      )!,
      action: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}action'],
      )!,
      severity: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}severity'],
      )!,
      contextJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}context_json'],
      ),
    );
  }

  @override
  $UserActionAuditsTable createAlias(String alias) {
    return $UserActionAuditsTable(attachedDatabase, alias);
  }
}

class UserActionAudit extends DataClass implements Insertable<UserActionAudit> {
  final int id;
  final int t;
  final String sessionId;
  final String module;
  final String action;
  final String severity;
  final String? contextJson;
  const UserActionAudit({
    required this.id,
    required this.t,
    required this.sessionId,
    required this.module,
    required this.action,
    required this.severity,
    this.contextJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['t'] = Variable<int>(t);
    map['session_id'] = Variable<String>(sessionId);
    map['module'] = Variable<String>(module);
    map['action'] = Variable<String>(action);
    map['severity'] = Variable<String>(severity);
    if (!nullToAbsent || contextJson != null) {
      map['context_json'] = Variable<String>(contextJson);
    }
    return map;
  }

  UserActionAuditsCompanion toCompanion(bool nullToAbsent) {
    return UserActionAuditsCompanion(
      id: Value(id),
      t: Value(t),
      sessionId: Value(sessionId),
      module: Value(module),
      action: Value(action),
      severity: Value(severity),
      contextJson: contextJson == null && nullToAbsent
          ? const Value.absent()
          : Value(contextJson),
    );
  }

  factory UserActionAudit.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserActionAudit(
      id: serializer.fromJson<int>(json['id']),
      t: serializer.fromJson<int>(json['t']),
      sessionId: serializer.fromJson<String>(json['sessionId']),
      module: serializer.fromJson<String>(json['module']),
      action: serializer.fromJson<String>(json['action']),
      severity: serializer.fromJson<String>(json['severity']),
      contextJson: serializer.fromJson<String?>(json['contextJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      't': serializer.toJson<int>(t),
      'sessionId': serializer.toJson<String>(sessionId),
      'module': serializer.toJson<String>(module),
      'action': serializer.toJson<String>(action),
      'severity': serializer.toJson<String>(severity),
      'contextJson': serializer.toJson<String?>(contextJson),
    };
  }

  UserActionAudit copyWith({
    int? id,
    int? t,
    String? sessionId,
    String? module,
    String? action,
    String? severity,
    Value<String?> contextJson = const Value.absent(),
  }) => UserActionAudit(
    id: id ?? this.id,
    t: t ?? this.t,
    sessionId: sessionId ?? this.sessionId,
    module: module ?? this.module,
    action: action ?? this.action,
    severity: severity ?? this.severity,
    contextJson: contextJson.present ? contextJson.value : this.contextJson,
  );
  UserActionAudit copyWithCompanion(UserActionAuditsCompanion data) {
    return UserActionAudit(
      id: data.id.present ? data.id.value : this.id,
      t: data.t.present ? data.t.value : this.t,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      module: data.module.present ? data.module.value : this.module,
      action: data.action.present ? data.action.value : this.action,
      severity: data.severity.present ? data.severity.value : this.severity,
      contextJson: data.contextJson.present
          ? data.contextJson.value
          : this.contextJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserActionAudit(')
          ..write('id: $id, ')
          ..write('t: $t, ')
          ..write('sessionId: $sessionId, ')
          ..write('module: $module, ')
          ..write('action: $action, ')
          ..write('severity: $severity, ')
          ..write('contextJson: $contextJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, t, sessionId, module, action, severity, contextJson);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserActionAudit &&
          other.id == this.id &&
          other.t == this.t &&
          other.sessionId == this.sessionId &&
          other.module == this.module &&
          other.action == this.action &&
          other.severity == this.severity &&
          other.contextJson == this.contextJson);
}

class UserActionAuditsCompanion extends UpdateCompanion<UserActionAudit> {
  final Value<int> id;
  final Value<int> t;
  final Value<String> sessionId;
  final Value<String> module;
  final Value<String> action;
  final Value<String> severity;
  final Value<String?> contextJson;
  const UserActionAuditsCompanion({
    this.id = const Value.absent(),
    this.t = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.module = const Value.absent(),
    this.action = const Value.absent(),
    this.severity = const Value.absent(),
    this.contextJson = const Value.absent(),
  });
  UserActionAuditsCompanion.insert({
    this.id = const Value.absent(),
    required int t,
    required String sessionId,
    required String module,
    required String action,
    this.severity = const Value.absent(),
    this.contextJson = const Value.absent(),
  }) : t = Value(t),
       sessionId = Value(sessionId),
       module = Value(module),
       action = Value(action);
  static Insertable<UserActionAudit> custom({
    Expression<int>? id,
    Expression<int>? t,
    Expression<String>? sessionId,
    Expression<String>? module,
    Expression<String>? action,
    Expression<String>? severity,
    Expression<String>? contextJson,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (t != null) 't': t,
      if (sessionId != null) 'session_id': sessionId,
      if (module != null) 'module': module,
      if (action != null) 'action': action,
      if (severity != null) 'severity': severity,
      if (contextJson != null) 'context_json': contextJson,
    });
  }

  UserActionAuditsCompanion copyWith({
    Value<int>? id,
    Value<int>? t,
    Value<String>? sessionId,
    Value<String>? module,
    Value<String>? action,
    Value<String>? severity,
    Value<String?>? contextJson,
  }) {
    return UserActionAuditsCompanion(
      id: id ?? this.id,
      t: t ?? this.t,
      sessionId: sessionId ?? this.sessionId,
      module: module ?? this.module,
      action: action ?? this.action,
      severity: severity ?? this.severity,
      contextJson: contextJson ?? this.contextJson,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (t.present) {
      map['t'] = Variable<int>(t.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    if (module.present) {
      map['module'] = Variable<String>(module.value);
    }
    if (action.present) {
      map['action'] = Variable<String>(action.value);
    }
    if (severity.present) {
      map['severity'] = Variable<String>(severity.value);
    }
    if (contextJson.present) {
      map['context_json'] = Variable<String>(contextJson.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserActionAuditsCompanion(')
          ..write('id: $id, ')
          ..write('t: $t, ')
          ..write('sessionId: $sessionId, ')
          ..write('module: $module, ')
          ..write('action: $action, ')
          ..write('severity: $severity, ')
          ..write('contextJson: $contextJson')
          ..write(')'))
        .toString();
  }
}

class $RoutesTable extends Routes with TableInfo<$RoutesTable, RouteEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RoutesTable(this.attachedDatabase, [this._alias]);
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
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    createdAt,
    updatedAt,
    version,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'routes';
  @override
  VerificationContext validateIntegrity(
    Insertable<RouteEntity> instance, {
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
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RouteEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RouteEntity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
    );
  }

  @override
  $RoutesTable createAlias(String alias) {
    return $RoutesTable(attachedDatabase, alias);
  }
}

class RouteEntity extends DataClass implements Insertable<RouteEntity> {
  final String id;
  final String name;
  final int createdAt;
  final int updatedAt;
  final int version;
  const RouteEntity({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    map['version'] = Variable<int>(version);
    return map;
  }

  RoutesCompanion toCompanion(bool nullToAbsent) {
    return RoutesCompanion(
      id: Value(id),
      name: Value(name),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      version: Value(version),
    );
  }

  factory RouteEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RouteEntity(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      version: serializer.fromJson<int>(json['version']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'version': serializer.toJson<int>(version),
    };
  }

  RouteEntity copyWith({
    String? id,
    String? name,
    int? createdAt,
    int? updatedAt,
    int? version,
  }) => RouteEntity(
    id: id ?? this.id,
    name: name ?? this.name,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    version: version ?? this.version,
  );
  RouteEntity copyWithCompanion(RoutesCompanion data) {
    return RouteEntity(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      version: data.version.present ? data.version.value : this.version,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RouteEntity(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('version: $version')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, createdAt, updatedAt, version);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RouteEntity &&
          other.id == this.id &&
          other.name == this.name &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.version == this.version);
}

class RoutesCompanion extends UpdateCompanion<RouteEntity> {
  final Value<String> id;
  final Value<String> name;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int> version;
  final Value<int> rowid;
  const RoutesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.version = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RoutesCompanion.insert({
    required String id,
    required String name,
    required int createdAt,
    required int updatedAt,
    this.version = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<RouteEntity> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? version,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (version != null) 'version': version,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RoutesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int>? version,
    Value<int>? rowid,
  }) {
    return RoutesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      version: version ?? this.version,
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
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RoutesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('version: $version, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RouteWaypointsTable extends RouteWaypoints
    with TableInfo<$RouteWaypointsTable, RouteWaypointRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RouteWaypointsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _routeIdMeta = const VerificationMeta(
    'routeId',
  );
  @override
  late final GeneratedColumn<String> routeId = GeneratedColumn<String>(
    'route_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES routes (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _seqMeta = const VerificationMeta('seq');
  @override
  late final GeneratedColumn<int> seq = GeneratedColumn<int>(
    'seq',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _latMeta = const VerificationMeta('lat');
  @override
  late final GeneratedColumn<double> lat = GeneratedColumn<double>(
    'lat',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lonMeta = const VerificationMeta('lon');
  @override
  late final GeneratedColumn<double> lon = GeneratedColumn<double>(
    'lon',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, routeId, seq, lat, lon, name];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'route_waypoints';
  @override
  VerificationContext validateIntegrity(
    Insertable<RouteWaypointRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('route_id')) {
      context.handle(
        _routeIdMeta,
        routeId.isAcceptableOrUnknown(data['route_id']!, _routeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_routeIdMeta);
    }
    if (data.containsKey('seq')) {
      context.handle(
        _seqMeta,
        seq.isAcceptableOrUnknown(data['seq']!, _seqMeta),
      );
    } else if (isInserting) {
      context.missing(_seqMeta);
    }
    if (data.containsKey('lat')) {
      context.handle(
        _latMeta,
        lat.isAcceptableOrUnknown(data['lat']!, _latMeta),
      );
    } else if (isInserting) {
      context.missing(_latMeta);
    }
    if (data.containsKey('lon')) {
      context.handle(
        _lonMeta,
        lon.isAcceptableOrUnknown(data['lon']!, _lonMeta),
      );
    } else if (isInserting) {
      context.missing(_lonMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RouteWaypointRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RouteWaypointRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      routeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}route_id'],
      )!,
      seq: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}seq'],
      )!,
      lat: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}lat'],
      )!,
      lon: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}lon'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      ),
    );
  }

  @override
  $RouteWaypointsTable createAlias(String alias) {
    return $RouteWaypointsTable(attachedDatabase, alias);
  }
}

class RouteWaypointRow extends DataClass
    implements Insertable<RouteWaypointRow> {
  final String id;
  final String routeId;
  final int seq;
  final double lat;
  final double lon;
  final String? name;
  const RouteWaypointRow({
    required this.id,
    required this.routeId,
    required this.seq,
    required this.lat,
    required this.lon,
    this.name,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['route_id'] = Variable<String>(routeId);
    map['seq'] = Variable<int>(seq);
    map['lat'] = Variable<double>(lat);
    map['lon'] = Variable<double>(lon);
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    return map;
  }

  RouteWaypointsCompanion toCompanion(bool nullToAbsent) {
    return RouteWaypointsCompanion(
      id: Value(id),
      routeId: Value(routeId),
      seq: Value(seq),
      lat: Value(lat),
      lon: Value(lon),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
    );
  }

  factory RouteWaypointRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RouteWaypointRow(
      id: serializer.fromJson<String>(json['id']),
      routeId: serializer.fromJson<String>(json['routeId']),
      seq: serializer.fromJson<int>(json['seq']),
      lat: serializer.fromJson<double>(json['lat']),
      lon: serializer.fromJson<double>(json['lon']),
      name: serializer.fromJson<String?>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'routeId': serializer.toJson<String>(routeId),
      'seq': serializer.toJson<int>(seq),
      'lat': serializer.toJson<double>(lat),
      'lon': serializer.toJson<double>(lon),
      'name': serializer.toJson<String?>(name),
    };
  }

  RouteWaypointRow copyWith({
    String? id,
    String? routeId,
    int? seq,
    double? lat,
    double? lon,
    Value<String?> name = const Value.absent(),
  }) => RouteWaypointRow(
    id: id ?? this.id,
    routeId: routeId ?? this.routeId,
    seq: seq ?? this.seq,
    lat: lat ?? this.lat,
    lon: lon ?? this.lon,
    name: name.present ? name.value : this.name,
  );
  RouteWaypointRow copyWithCompanion(RouteWaypointsCompanion data) {
    return RouteWaypointRow(
      id: data.id.present ? data.id.value : this.id,
      routeId: data.routeId.present ? data.routeId.value : this.routeId,
      seq: data.seq.present ? data.seq.value : this.seq,
      lat: data.lat.present ? data.lat.value : this.lat,
      lon: data.lon.present ? data.lon.value : this.lon,
      name: data.name.present ? data.name.value : this.name,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RouteWaypointRow(')
          ..write('id: $id, ')
          ..write('routeId: $routeId, ')
          ..write('seq: $seq, ')
          ..write('lat: $lat, ')
          ..write('lon: $lon, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, routeId, seq, lat, lon, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RouteWaypointRow &&
          other.id == this.id &&
          other.routeId == this.routeId &&
          other.seq == this.seq &&
          other.lat == this.lat &&
          other.lon == this.lon &&
          other.name == this.name);
}

class RouteWaypointsCompanion extends UpdateCompanion<RouteWaypointRow> {
  final Value<String> id;
  final Value<String> routeId;
  final Value<int> seq;
  final Value<double> lat;
  final Value<double> lon;
  final Value<String?> name;
  final Value<int> rowid;
  const RouteWaypointsCompanion({
    this.id = const Value.absent(),
    this.routeId = const Value.absent(),
    this.seq = const Value.absent(),
    this.lat = const Value.absent(),
    this.lon = const Value.absent(),
    this.name = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RouteWaypointsCompanion.insert({
    required String id,
    required String routeId,
    required int seq,
    required double lat,
    required double lon,
    this.name = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       routeId = Value(routeId),
       seq = Value(seq),
       lat = Value(lat),
       lon = Value(lon);
  static Insertable<RouteWaypointRow> custom({
    Expression<String>? id,
    Expression<String>? routeId,
    Expression<int>? seq,
    Expression<double>? lat,
    Expression<double>? lon,
    Expression<String>? name,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (routeId != null) 'route_id': routeId,
      if (seq != null) 'seq': seq,
      if (lat != null) 'lat': lat,
      if (lon != null) 'lon': lon,
      if (name != null) 'name': name,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RouteWaypointsCompanion copyWith({
    Value<String>? id,
    Value<String>? routeId,
    Value<int>? seq,
    Value<double>? lat,
    Value<double>? lon,
    Value<String?>? name,
    Value<int>? rowid,
  }) {
    return RouteWaypointsCompanion(
      id: id ?? this.id,
      routeId: routeId ?? this.routeId,
      seq: seq ?? this.seq,
      lat: lat ?? this.lat,
      lon: lon ?? this.lon,
      name: name ?? this.name,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (routeId.present) {
      map['route_id'] = Variable<String>(routeId.value);
    }
    if (seq.present) {
      map['seq'] = Variable<int>(seq.value);
    }
    if (lat.present) {
      map['lat'] = Variable<double>(lat.value);
    }
    if (lon.present) {
      map['lon'] = Variable<double>(lon.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RouteWaypointsCompanion(')
          ..write('id: $id, ')
          ..write('routeId: $routeId, ')
          ..write('seq: $seq, ')
          ..write('lat: $lat, ')
          ..write('lon: $lon, ')
          ..write('name: $name, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ChartRegionsTable extends ChartRegions
    with TableInfo<$ChartRegionsTable, ChartRegionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChartRegionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _regionIdMeta = const VerificationMeta(
    'regionId',
  );
  @override
  late final GeneratedColumn<String> regionId = GeneratedColumn<String>(
    'region_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pathMeta = const VerificationMeta('path');
  @override
  late final GeneratedColumn<String> path = GeneratedColumn<String>(
    'path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _checksumMeta = const VerificationMeta(
    'checksum',
  );
  @override
  late final GeneratedColumn<String> checksum = GeneratedColumn<String>(
    'checksum',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _installedAtMeta = const VerificationMeta(
    'installedAt',
  );
  @override
  late final GeneratedColumn<int> installedAt = GeneratedColumn<int>(
    'installed_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _licenseTierMeta = const VerificationMeta(
    'licenseTier',
  );
  @override
  late final GeneratedColumn<String> licenseTier = GeneratedColumn<String>(
    'license_tier',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    regionId,
    path,
    checksum,
    installedAt,
    licenseTier,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'chart_regions';
  @override
  VerificationContext validateIntegrity(
    Insertable<ChartRegionRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('region_id')) {
      context.handle(
        _regionIdMeta,
        regionId.isAcceptableOrUnknown(data['region_id']!, _regionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_regionIdMeta);
    }
    if (data.containsKey('path')) {
      context.handle(
        _pathMeta,
        path.isAcceptableOrUnknown(data['path']!, _pathMeta),
      );
    } else if (isInserting) {
      context.missing(_pathMeta);
    }
    if (data.containsKey('checksum')) {
      context.handle(
        _checksumMeta,
        checksum.isAcceptableOrUnknown(data['checksum']!, _checksumMeta),
      );
    }
    if (data.containsKey('installed_at')) {
      context.handle(
        _installedAtMeta,
        installedAt.isAcceptableOrUnknown(
          data['installed_at']!,
          _installedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_installedAtMeta);
    }
    if (data.containsKey('license_tier')) {
      context.handle(
        _licenseTierMeta,
        licenseTier.isAcceptableOrUnknown(
          data['license_tier']!,
          _licenseTierMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_licenseTierMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {regionId};
  @override
  ChartRegionRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChartRegionRow(
      regionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}region_id'],
      )!,
      path: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}path'],
      )!,
      checksum: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}checksum'],
      ),
      installedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}installed_at'],
      )!,
      licenseTier: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}license_tier'],
      )!,
    );
  }

  @override
  $ChartRegionsTable createAlias(String alias) {
    return $ChartRegionsTable(attachedDatabase, alias);
  }
}

class ChartRegionRow extends DataClass implements Insertable<ChartRegionRow> {
  final String regionId;
  final String path;
  final String? checksum;
  final int installedAt;
  final String licenseTier;
  const ChartRegionRow({
    required this.regionId,
    required this.path,
    this.checksum,
    required this.installedAt,
    required this.licenseTier,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['region_id'] = Variable<String>(regionId);
    map['path'] = Variable<String>(path);
    if (!nullToAbsent || checksum != null) {
      map['checksum'] = Variable<String>(checksum);
    }
    map['installed_at'] = Variable<int>(installedAt);
    map['license_tier'] = Variable<String>(licenseTier);
    return map;
  }

  ChartRegionsCompanion toCompanion(bool nullToAbsent) {
    return ChartRegionsCompanion(
      regionId: Value(regionId),
      path: Value(path),
      checksum: checksum == null && nullToAbsent
          ? const Value.absent()
          : Value(checksum),
      installedAt: Value(installedAt),
      licenseTier: Value(licenseTier),
    );
  }

  factory ChartRegionRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChartRegionRow(
      regionId: serializer.fromJson<String>(json['regionId']),
      path: serializer.fromJson<String>(json['path']),
      checksum: serializer.fromJson<String?>(json['checksum']),
      installedAt: serializer.fromJson<int>(json['installedAt']),
      licenseTier: serializer.fromJson<String>(json['licenseTier']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'regionId': serializer.toJson<String>(regionId),
      'path': serializer.toJson<String>(path),
      'checksum': serializer.toJson<String?>(checksum),
      'installedAt': serializer.toJson<int>(installedAt),
      'licenseTier': serializer.toJson<String>(licenseTier),
    };
  }

  ChartRegionRow copyWith({
    String? regionId,
    String? path,
    Value<String?> checksum = const Value.absent(),
    int? installedAt,
    String? licenseTier,
  }) => ChartRegionRow(
    regionId: regionId ?? this.regionId,
    path: path ?? this.path,
    checksum: checksum.present ? checksum.value : this.checksum,
    installedAt: installedAt ?? this.installedAt,
    licenseTier: licenseTier ?? this.licenseTier,
  );
  ChartRegionRow copyWithCompanion(ChartRegionsCompanion data) {
    return ChartRegionRow(
      regionId: data.regionId.present ? data.regionId.value : this.regionId,
      path: data.path.present ? data.path.value : this.path,
      checksum: data.checksum.present ? data.checksum.value : this.checksum,
      installedAt: data.installedAt.present
          ? data.installedAt.value
          : this.installedAt,
      licenseTier: data.licenseTier.present
          ? data.licenseTier.value
          : this.licenseTier,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChartRegionRow(')
          ..write('regionId: $regionId, ')
          ..write('path: $path, ')
          ..write('checksum: $checksum, ')
          ..write('installedAt: $installedAt, ')
          ..write('licenseTier: $licenseTier')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(regionId, path, checksum, installedAt, licenseTier);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChartRegionRow &&
          other.regionId == this.regionId &&
          other.path == this.path &&
          other.checksum == this.checksum &&
          other.installedAt == this.installedAt &&
          other.licenseTier == this.licenseTier);
}

class ChartRegionsCompanion extends UpdateCompanion<ChartRegionRow> {
  final Value<String> regionId;
  final Value<String> path;
  final Value<String?> checksum;
  final Value<int> installedAt;
  final Value<String> licenseTier;
  final Value<int> rowid;
  const ChartRegionsCompanion({
    this.regionId = const Value.absent(),
    this.path = const Value.absent(),
    this.checksum = const Value.absent(),
    this.installedAt = const Value.absent(),
    this.licenseTier = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ChartRegionsCompanion.insert({
    required String regionId,
    required String path,
    this.checksum = const Value.absent(),
    required int installedAt,
    required String licenseTier,
    this.rowid = const Value.absent(),
  }) : regionId = Value(regionId),
       path = Value(path),
       installedAt = Value(installedAt),
       licenseTier = Value(licenseTier);
  static Insertable<ChartRegionRow> custom({
    Expression<String>? regionId,
    Expression<String>? path,
    Expression<String>? checksum,
    Expression<int>? installedAt,
    Expression<String>? licenseTier,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (regionId != null) 'region_id': regionId,
      if (path != null) 'path': path,
      if (checksum != null) 'checksum': checksum,
      if (installedAt != null) 'installed_at': installedAt,
      if (licenseTier != null) 'license_tier': licenseTier,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ChartRegionsCompanion copyWith({
    Value<String>? regionId,
    Value<String>? path,
    Value<String?>? checksum,
    Value<int>? installedAt,
    Value<String>? licenseTier,
    Value<int>? rowid,
  }) {
    return ChartRegionsCompanion(
      regionId: regionId ?? this.regionId,
      path: path ?? this.path,
      checksum: checksum ?? this.checksum,
      installedAt: installedAt ?? this.installedAt,
      licenseTier: licenseTier ?? this.licenseTier,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (regionId.present) {
      map['region_id'] = Variable<String>(regionId.value);
    }
    if (path.present) {
      map['path'] = Variable<String>(path.value);
    }
    if (checksum.present) {
      map['checksum'] = Variable<String>(checksum.value);
    }
    if (installedAt.present) {
      map['installed_at'] = Variable<int>(installedAt.value);
    }
    if (licenseTier.present) {
      map['license_tier'] = Variable<String>(licenseTier.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChartRegionsCompanion(')
          ..write('regionId: $regionId, ')
          ..write('path: $path, ')
          ..write('checksum: $checksum, ')
          ..write('installedAt: $installedAt, ')
          ..write('licenseTier: $licenseTier, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WeatherCacheRowsTable extends WeatherCacheRows
    with TableInfo<$WeatherCacheRowsTable, WeatherCacheRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WeatherCacheRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _gridKeyMeta = const VerificationMeta(
    'gridKey',
  );
  @override
  late final GeneratedColumn<String> gridKey = GeneratedColumn<String>(
    'grid_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _forecastJsonMeta = const VerificationMeta(
    'forecastJson',
  );
  @override
  late final GeneratedColumn<String> forecastJson = GeneratedColumn<String>(
    'forecast_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fetchedAtMsMeta = const VerificationMeta(
    'fetchedAtMs',
  );
  @override
  late final GeneratedColumn<int> fetchedAtMs = GeneratedColumn<int>(
    'fetched_at_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _expiresAtMsMeta = const VerificationMeta(
    'expiresAtMs',
  );
  @override
  late final GeneratedColumn<int> expiresAtMs = GeneratedColumn<int>(
    'expires_at_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    gridKey,
    forecastJson,
    fetchedAtMs,
    expiresAtMs,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'weather_cache_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<WeatherCacheRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('grid_key')) {
      context.handle(
        _gridKeyMeta,
        gridKey.isAcceptableOrUnknown(data['grid_key']!, _gridKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_gridKeyMeta);
    }
    if (data.containsKey('forecast_json')) {
      context.handle(
        _forecastJsonMeta,
        forecastJson.isAcceptableOrUnknown(
          data['forecast_json']!,
          _forecastJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_forecastJsonMeta);
    }
    if (data.containsKey('fetched_at_ms')) {
      context.handle(
        _fetchedAtMsMeta,
        fetchedAtMs.isAcceptableOrUnknown(
          data['fetched_at_ms']!,
          _fetchedAtMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_fetchedAtMsMeta);
    }
    if (data.containsKey('expires_at_ms')) {
      context.handle(
        _expiresAtMsMeta,
        expiresAtMs.isAcceptableOrUnknown(
          data['expires_at_ms']!,
          _expiresAtMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_expiresAtMsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {gridKey};
  @override
  WeatherCacheRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WeatherCacheRow(
      gridKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}grid_key'],
      )!,
      forecastJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}forecast_json'],
      )!,
      fetchedAtMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}fetched_at_ms'],
      )!,
      expiresAtMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}expires_at_ms'],
      )!,
    );
  }

  @override
  $WeatherCacheRowsTable createAlias(String alias) {
    return $WeatherCacheRowsTable(attachedDatabase, alias);
  }
}

class WeatherCacheRow extends DataClass implements Insertable<WeatherCacheRow> {
  final String gridKey;
  final String forecastJson;
  final int fetchedAtMs;
  final int expiresAtMs;
  const WeatherCacheRow({
    required this.gridKey,
    required this.forecastJson,
    required this.fetchedAtMs,
    required this.expiresAtMs,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['grid_key'] = Variable<String>(gridKey);
    map['forecast_json'] = Variable<String>(forecastJson);
    map['fetched_at_ms'] = Variable<int>(fetchedAtMs);
    map['expires_at_ms'] = Variable<int>(expiresAtMs);
    return map;
  }

  WeatherCacheRowsCompanion toCompanion(bool nullToAbsent) {
    return WeatherCacheRowsCompanion(
      gridKey: Value(gridKey),
      forecastJson: Value(forecastJson),
      fetchedAtMs: Value(fetchedAtMs),
      expiresAtMs: Value(expiresAtMs),
    );
  }

  factory WeatherCacheRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WeatherCacheRow(
      gridKey: serializer.fromJson<String>(json['gridKey']),
      forecastJson: serializer.fromJson<String>(json['forecastJson']),
      fetchedAtMs: serializer.fromJson<int>(json['fetchedAtMs']),
      expiresAtMs: serializer.fromJson<int>(json['expiresAtMs']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'gridKey': serializer.toJson<String>(gridKey),
      'forecastJson': serializer.toJson<String>(forecastJson),
      'fetchedAtMs': serializer.toJson<int>(fetchedAtMs),
      'expiresAtMs': serializer.toJson<int>(expiresAtMs),
    };
  }

  WeatherCacheRow copyWith({
    String? gridKey,
    String? forecastJson,
    int? fetchedAtMs,
    int? expiresAtMs,
  }) => WeatherCacheRow(
    gridKey: gridKey ?? this.gridKey,
    forecastJson: forecastJson ?? this.forecastJson,
    fetchedAtMs: fetchedAtMs ?? this.fetchedAtMs,
    expiresAtMs: expiresAtMs ?? this.expiresAtMs,
  );
  WeatherCacheRow copyWithCompanion(WeatherCacheRowsCompanion data) {
    return WeatherCacheRow(
      gridKey: data.gridKey.present ? data.gridKey.value : this.gridKey,
      forecastJson: data.forecastJson.present
          ? data.forecastJson.value
          : this.forecastJson,
      fetchedAtMs: data.fetchedAtMs.present
          ? data.fetchedAtMs.value
          : this.fetchedAtMs,
      expiresAtMs: data.expiresAtMs.present
          ? data.expiresAtMs.value
          : this.expiresAtMs,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WeatherCacheRow(')
          ..write('gridKey: $gridKey, ')
          ..write('forecastJson: $forecastJson, ')
          ..write('fetchedAtMs: $fetchedAtMs, ')
          ..write('expiresAtMs: $expiresAtMs')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(gridKey, forecastJson, fetchedAtMs, expiresAtMs);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WeatherCacheRow &&
          other.gridKey == this.gridKey &&
          other.forecastJson == this.forecastJson &&
          other.fetchedAtMs == this.fetchedAtMs &&
          other.expiresAtMs == this.expiresAtMs);
}

class WeatherCacheRowsCompanion extends UpdateCompanion<WeatherCacheRow> {
  final Value<String> gridKey;
  final Value<String> forecastJson;
  final Value<int> fetchedAtMs;
  final Value<int> expiresAtMs;
  final Value<int> rowid;
  const WeatherCacheRowsCompanion({
    this.gridKey = const Value.absent(),
    this.forecastJson = const Value.absent(),
    this.fetchedAtMs = const Value.absent(),
    this.expiresAtMs = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WeatherCacheRowsCompanion.insert({
    required String gridKey,
    required String forecastJson,
    required int fetchedAtMs,
    required int expiresAtMs,
    this.rowid = const Value.absent(),
  }) : gridKey = Value(gridKey),
       forecastJson = Value(forecastJson),
       fetchedAtMs = Value(fetchedAtMs),
       expiresAtMs = Value(expiresAtMs);
  static Insertable<WeatherCacheRow> custom({
    Expression<String>? gridKey,
    Expression<String>? forecastJson,
    Expression<int>? fetchedAtMs,
    Expression<int>? expiresAtMs,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (gridKey != null) 'grid_key': gridKey,
      if (forecastJson != null) 'forecast_json': forecastJson,
      if (fetchedAtMs != null) 'fetched_at_ms': fetchedAtMs,
      if (expiresAtMs != null) 'expires_at_ms': expiresAtMs,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WeatherCacheRowsCompanion copyWith({
    Value<String>? gridKey,
    Value<String>? forecastJson,
    Value<int>? fetchedAtMs,
    Value<int>? expiresAtMs,
    Value<int>? rowid,
  }) {
    return WeatherCacheRowsCompanion(
      gridKey: gridKey ?? this.gridKey,
      forecastJson: forecastJson ?? this.forecastJson,
      fetchedAtMs: fetchedAtMs ?? this.fetchedAtMs,
      expiresAtMs: expiresAtMs ?? this.expiresAtMs,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (gridKey.present) {
      map['grid_key'] = Variable<String>(gridKey.value);
    }
    if (forecastJson.present) {
      map['forecast_json'] = Variable<String>(forecastJson.value);
    }
    if (fetchedAtMs.present) {
      map['fetched_at_ms'] = Variable<int>(fetchedAtMs.value);
    }
    if (expiresAtMs.present) {
      map['expires_at_ms'] = Variable<int>(expiresAtMs.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WeatherCacheRowsCompanion(')
          ..write('gridKey: $gridKey, ')
          ..write('forecastJson: $forecastJson, ')
          ..write('fetchedAtMs: $fetchedAtMs, ')
          ..write('expiresAtMs: $expiresAtMs, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MooringPlacesTable extends MooringPlaces
    with TableInfo<$MooringPlacesTable, MooringPlaceRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MooringPlacesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
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
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _latMeta = const VerificationMeta('lat');
  @override
  late final GeneratedColumn<double> lat = GeneratedColumn<double>(
    'lat',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lonMeta = const VerificationMeta('lon');
  @override
  late final GeneratedColumn<double> lon = GeneratedColumn<double>(
    'lon',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _vhfMeta = const VerificationMeta('vhf');
  @override
  late final GeneratedColumn<String> vhf = GeneratedColumn<String>(
    'vhf',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _servicesJsonMeta = const VerificationMeta(
    'servicesJson',
  );
  @override
  late final GeneratedColumn<String> servicesJson = GeneratedColumn<String>(
    'services_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    kind,
    name,
    lat,
    lon,
    vhf,
    phone,
    servicesJson,
    notes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'mooring_places';
  @override
  VerificationContext validateIntegrity(
    Insertable<MooringPlaceRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('lat')) {
      context.handle(
        _latMeta,
        lat.isAcceptableOrUnknown(data['lat']!, _latMeta),
      );
    } else if (isInserting) {
      context.missing(_latMeta);
    }
    if (data.containsKey('lon')) {
      context.handle(
        _lonMeta,
        lon.isAcceptableOrUnknown(data['lon']!, _lonMeta),
      );
    } else if (isInserting) {
      context.missing(_lonMeta);
    }
    if (data.containsKey('vhf')) {
      context.handle(
        _vhfMeta,
        vhf.isAcceptableOrUnknown(data['vhf']!, _vhfMeta),
      );
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('services_json')) {
      context.handle(
        _servicesJsonMeta,
        servicesJson.isAcceptableOrUnknown(
          data['services_json']!,
          _servicesJsonMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MooringPlaceRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MooringPlaceRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      lat: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}lat'],
      )!,
      lon: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}lon'],
      )!,
      vhf: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}vhf'],
      ),
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      ),
      servicesJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}services_json'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
    );
  }

  @override
  $MooringPlacesTable createAlias(String alias) {
    return $MooringPlacesTable(attachedDatabase, alias);
  }
}

class MooringPlaceRow extends DataClass implements Insertable<MooringPlaceRow> {
  final String id;
  final String kind;
  final String name;
  final double lat;
  final double lon;
  final String? vhf;
  final String? phone;

  /// JSON: electricity, water, wifi, showers — флаги для карточки.
  final String? servicesJson;
  final String? notes;
  const MooringPlaceRow({
    required this.id,
    required this.kind,
    required this.name,
    required this.lat,
    required this.lon,
    this.vhf,
    this.phone,
    this.servicesJson,
    this.notes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['kind'] = Variable<String>(kind);
    map['name'] = Variable<String>(name);
    map['lat'] = Variable<double>(lat);
    map['lon'] = Variable<double>(lon);
    if (!nullToAbsent || vhf != null) {
      map['vhf'] = Variable<String>(vhf);
    }
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || servicesJson != null) {
      map['services_json'] = Variable<String>(servicesJson);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  MooringPlacesCompanion toCompanion(bool nullToAbsent) {
    return MooringPlacesCompanion(
      id: Value(id),
      kind: Value(kind),
      name: Value(name),
      lat: Value(lat),
      lon: Value(lon),
      vhf: vhf == null && nullToAbsent ? const Value.absent() : Value(vhf),
      phone: phone == null && nullToAbsent
          ? const Value.absent()
          : Value(phone),
      servicesJson: servicesJson == null && nullToAbsent
          ? const Value.absent()
          : Value(servicesJson),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
    );
  }

  factory MooringPlaceRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MooringPlaceRow(
      id: serializer.fromJson<String>(json['id']),
      kind: serializer.fromJson<String>(json['kind']),
      name: serializer.fromJson<String>(json['name']),
      lat: serializer.fromJson<double>(json['lat']),
      lon: serializer.fromJson<double>(json['lon']),
      vhf: serializer.fromJson<String?>(json['vhf']),
      phone: serializer.fromJson<String?>(json['phone']),
      servicesJson: serializer.fromJson<String?>(json['servicesJson']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'kind': serializer.toJson<String>(kind),
      'name': serializer.toJson<String>(name),
      'lat': serializer.toJson<double>(lat),
      'lon': serializer.toJson<double>(lon),
      'vhf': serializer.toJson<String?>(vhf),
      'phone': serializer.toJson<String?>(phone),
      'servicesJson': serializer.toJson<String?>(servicesJson),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  MooringPlaceRow copyWith({
    String? id,
    String? kind,
    String? name,
    double? lat,
    double? lon,
    Value<String?> vhf = const Value.absent(),
    Value<String?> phone = const Value.absent(),
    Value<String?> servicesJson = const Value.absent(),
    Value<String?> notes = const Value.absent(),
  }) => MooringPlaceRow(
    id: id ?? this.id,
    kind: kind ?? this.kind,
    name: name ?? this.name,
    lat: lat ?? this.lat,
    lon: lon ?? this.lon,
    vhf: vhf.present ? vhf.value : this.vhf,
    phone: phone.present ? phone.value : this.phone,
    servicesJson: servicesJson.present ? servicesJson.value : this.servicesJson,
    notes: notes.present ? notes.value : this.notes,
  );
  MooringPlaceRow copyWithCompanion(MooringPlacesCompanion data) {
    return MooringPlaceRow(
      id: data.id.present ? data.id.value : this.id,
      kind: data.kind.present ? data.kind.value : this.kind,
      name: data.name.present ? data.name.value : this.name,
      lat: data.lat.present ? data.lat.value : this.lat,
      lon: data.lon.present ? data.lon.value : this.lon,
      vhf: data.vhf.present ? data.vhf.value : this.vhf,
      phone: data.phone.present ? data.phone.value : this.phone,
      servicesJson: data.servicesJson.present
          ? data.servicesJson.value
          : this.servicesJson,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MooringPlaceRow(')
          ..write('id: $id, ')
          ..write('kind: $kind, ')
          ..write('name: $name, ')
          ..write('lat: $lat, ')
          ..write('lon: $lon, ')
          ..write('vhf: $vhf, ')
          ..write('phone: $phone, ')
          ..write('servicesJson: $servicesJson, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, kind, name, lat, lon, vhf, phone, servicesJson, notes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MooringPlaceRow &&
          other.id == this.id &&
          other.kind == this.kind &&
          other.name == this.name &&
          other.lat == this.lat &&
          other.lon == this.lon &&
          other.vhf == this.vhf &&
          other.phone == this.phone &&
          other.servicesJson == this.servicesJson &&
          other.notes == this.notes);
}

class MooringPlacesCompanion extends UpdateCompanion<MooringPlaceRow> {
  final Value<String> id;
  final Value<String> kind;
  final Value<String> name;
  final Value<double> lat;
  final Value<double> lon;
  final Value<String?> vhf;
  final Value<String?> phone;
  final Value<String?> servicesJson;
  final Value<String?> notes;
  final Value<int> rowid;
  const MooringPlacesCompanion({
    this.id = const Value.absent(),
    this.kind = const Value.absent(),
    this.name = const Value.absent(),
    this.lat = const Value.absent(),
    this.lon = const Value.absent(),
    this.vhf = const Value.absent(),
    this.phone = const Value.absent(),
    this.servicesJson = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MooringPlacesCompanion.insert({
    required String id,
    required String kind,
    required String name,
    required double lat,
    required double lon,
    this.vhf = const Value.absent(),
    this.phone = const Value.absent(),
    this.servicesJson = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       kind = Value(kind),
       name = Value(name),
       lat = Value(lat),
       lon = Value(lon);
  static Insertable<MooringPlaceRow> custom({
    Expression<String>? id,
    Expression<String>? kind,
    Expression<String>? name,
    Expression<double>? lat,
    Expression<double>? lon,
    Expression<String>? vhf,
    Expression<String>? phone,
    Expression<String>? servicesJson,
    Expression<String>? notes,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (kind != null) 'kind': kind,
      if (name != null) 'name': name,
      if (lat != null) 'lat': lat,
      if (lon != null) 'lon': lon,
      if (vhf != null) 'vhf': vhf,
      if (phone != null) 'phone': phone,
      if (servicesJson != null) 'services_json': servicesJson,
      if (notes != null) 'notes': notes,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MooringPlacesCompanion copyWith({
    Value<String>? id,
    Value<String>? kind,
    Value<String>? name,
    Value<double>? lat,
    Value<double>? lon,
    Value<String?>? vhf,
    Value<String?>? phone,
    Value<String?>? servicesJson,
    Value<String?>? notes,
    Value<int>? rowid,
  }) {
    return MooringPlacesCompanion(
      id: id ?? this.id,
      kind: kind ?? this.kind,
      name: name ?? this.name,
      lat: lat ?? this.lat,
      lon: lon ?? this.lon,
      vhf: vhf ?? this.vhf,
      phone: phone ?? this.phone,
      servicesJson: servicesJson ?? this.servicesJson,
      notes: notes ?? this.notes,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (lat.present) {
      map['lat'] = Variable<double>(lat.value);
    }
    if (lon.present) {
      map['lon'] = Variable<double>(lon.value);
    }
    if (vhf.present) {
      map['vhf'] = Variable<String>(vhf.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (servicesJson.present) {
      map['services_json'] = Variable<String>(servicesJson.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MooringPlacesCompanion(')
          ..write('id: $id, ')
          ..write('kind: $kind, ')
          ..write('name: $name, ')
          ..write('lat: $lat, ')
          ..write('lon: $lon, ')
          ..write('vhf: $vhf, ')
          ..write('phone: $phone, ')
          ..write('servicesJson: $servicesJson, ')
          ..write('notes: $notes, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MooringReviewDraftsTable extends MooringReviewDrafts
    with TableInfo<$MooringReviewDraftsTable, MooringReviewDraftRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MooringReviewDraftsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _placeIdMeta = const VerificationMeta(
    'placeId',
  );
  @override
  late final GeneratedColumn<String> placeId = GeneratedColumn<String>(
    'place_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _starsMeta = const VerificationMeta('stars');
  @override
  late final GeneratedColumn<int> stars = GeneratedColumn<int>(
    'stars',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _commentMeta = const VerificationMeta(
    'comment',
  );
  @override
  late final GeneratedColumn<String> comment = GeneratedColumn<String>(
    'comment',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMsMeta = const VerificationMeta(
    'createdAtMs',
  );
  @override
  late final GeneratedColumn<int> createdAtMs = GeneratedColumn<int>(
    'created_at_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _syncedMeta = const VerificationMeta('synced');
  @override
  late final GeneratedColumn<bool> synced = GeneratedColumn<bool>(
    'synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    placeId,
    stars,
    comment,
    createdAtMs,
    synced,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'mooring_review_drafts';
  @override
  VerificationContext validateIntegrity(
    Insertable<MooringReviewDraftRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('place_id')) {
      context.handle(
        _placeIdMeta,
        placeId.isAcceptableOrUnknown(data['place_id']!, _placeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_placeIdMeta);
    }
    if (data.containsKey('stars')) {
      context.handle(
        _starsMeta,
        stars.isAcceptableOrUnknown(data['stars']!, _starsMeta),
      );
    } else if (isInserting) {
      context.missing(_starsMeta);
    }
    if (data.containsKey('comment')) {
      context.handle(
        _commentMeta,
        comment.isAcceptableOrUnknown(data['comment']!, _commentMeta),
      );
    }
    if (data.containsKey('created_at_ms')) {
      context.handle(
        _createdAtMsMeta,
        createdAtMs.isAcceptableOrUnknown(
          data['created_at_ms']!,
          _createdAtMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_createdAtMsMeta);
    }
    if (data.containsKey('synced')) {
      context.handle(
        _syncedMeta,
        synced.isAcceptableOrUnknown(data['synced']!, _syncedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MooringReviewDraftRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MooringReviewDraftRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      placeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}place_id'],
      )!,
      stars: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}stars'],
      )!,
      comment: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}comment'],
      ),
      createdAtMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at_ms'],
      )!,
      synced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}synced'],
      )!,
    );
  }

  @override
  $MooringReviewDraftsTable createAlias(String alias) {
    return $MooringReviewDraftsTable(attachedDatabase, alias);
  }
}

class MooringReviewDraftRow extends DataClass
    implements Insertable<MooringReviewDraftRow> {
  final String id;
  final String placeId;
  final int stars;
  final String? comment;
  final int createdAtMs;
  final bool synced;
  const MooringReviewDraftRow({
    required this.id,
    required this.placeId,
    required this.stars,
    this.comment,
    required this.createdAtMs,
    required this.synced,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['place_id'] = Variable<String>(placeId);
    map['stars'] = Variable<int>(stars);
    if (!nullToAbsent || comment != null) {
      map['comment'] = Variable<String>(comment);
    }
    map['created_at_ms'] = Variable<int>(createdAtMs);
    map['synced'] = Variable<bool>(synced);
    return map;
  }

  MooringReviewDraftsCompanion toCompanion(bool nullToAbsent) {
    return MooringReviewDraftsCompanion(
      id: Value(id),
      placeId: Value(placeId),
      stars: Value(stars),
      comment: comment == null && nullToAbsent
          ? const Value.absent()
          : Value(comment),
      createdAtMs: Value(createdAtMs),
      synced: Value(synced),
    );
  }

  factory MooringReviewDraftRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MooringReviewDraftRow(
      id: serializer.fromJson<String>(json['id']),
      placeId: serializer.fromJson<String>(json['placeId']),
      stars: serializer.fromJson<int>(json['stars']),
      comment: serializer.fromJson<String?>(json['comment']),
      createdAtMs: serializer.fromJson<int>(json['createdAtMs']),
      synced: serializer.fromJson<bool>(json['synced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'placeId': serializer.toJson<String>(placeId),
      'stars': serializer.toJson<int>(stars),
      'comment': serializer.toJson<String?>(comment),
      'createdAtMs': serializer.toJson<int>(createdAtMs),
      'synced': serializer.toJson<bool>(synced),
    };
  }

  MooringReviewDraftRow copyWith({
    String? id,
    String? placeId,
    int? stars,
    Value<String?> comment = const Value.absent(),
    int? createdAtMs,
    bool? synced,
  }) => MooringReviewDraftRow(
    id: id ?? this.id,
    placeId: placeId ?? this.placeId,
    stars: stars ?? this.stars,
    comment: comment.present ? comment.value : this.comment,
    createdAtMs: createdAtMs ?? this.createdAtMs,
    synced: synced ?? this.synced,
  );
  MooringReviewDraftRow copyWithCompanion(MooringReviewDraftsCompanion data) {
    return MooringReviewDraftRow(
      id: data.id.present ? data.id.value : this.id,
      placeId: data.placeId.present ? data.placeId.value : this.placeId,
      stars: data.stars.present ? data.stars.value : this.stars,
      comment: data.comment.present ? data.comment.value : this.comment,
      createdAtMs: data.createdAtMs.present
          ? data.createdAtMs.value
          : this.createdAtMs,
      synced: data.synced.present ? data.synced.value : this.synced,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MooringReviewDraftRow(')
          ..write('id: $id, ')
          ..write('placeId: $placeId, ')
          ..write('stars: $stars, ')
          ..write('comment: $comment, ')
          ..write('createdAtMs: $createdAtMs, ')
          ..write('synced: $synced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, placeId, stars, comment, createdAtMs, synced);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MooringReviewDraftRow &&
          other.id == this.id &&
          other.placeId == this.placeId &&
          other.stars == this.stars &&
          other.comment == this.comment &&
          other.createdAtMs == this.createdAtMs &&
          other.synced == this.synced);
}

class MooringReviewDraftsCompanion
    extends UpdateCompanion<MooringReviewDraftRow> {
  final Value<String> id;
  final Value<String> placeId;
  final Value<int> stars;
  final Value<String?> comment;
  final Value<int> createdAtMs;
  final Value<bool> synced;
  final Value<int> rowid;
  const MooringReviewDraftsCompanion({
    this.id = const Value.absent(),
    this.placeId = const Value.absent(),
    this.stars = const Value.absent(),
    this.comment = const Value.absent(),
    this.createdAtMs = const Value.absent(),
    this.synced = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MooringReviewDraftsCompanion.insert({
    required String id,
    required String placeId,
    required int stars,
    this.comment = const Value.absent(),
    required int createdAtMs,
    this.synced = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       placeId = Value(placeId),
       stars = Value(stars),
       createdAtMs = Value(createdAtMs);
  static Insertable<MooringReviewDraftRow> custom({
    Expression<String>? id,
    Expression<String>? placeId,
    Expression<int>? stars,
    Expression<String>? comment,
    Expression<int>? createdAtMs,
    Expression<bool>? synced,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (placeId != null) 'place_id': placeId,
      if (stars != null) 'stars': stars,
      if (comment != null) 'comment': comment,
      if (createdAtMs != null) 'created_at_ms': createdAtMs,
      if (synced != null) 'synced': synced,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MooringReviewDraftsCompanion copyWith({
    Value<String>? id,
    Value<String>? placeId,
    Value<int>? stars,
    Value<String?>? comment,
    Value<int>? createdAtMs,
    Value<bool>? synced,
    Value<int>? rowid,
  }) {
    return MooringReviewDraftsCompanion(
      id: id ?? this.id,
      placeId: placeId ?? this.placeId,
      stars: stars ?? this.stars,
      comment: comment ?? this.comment,
      createdAtMs: createdAtMs ?? this.createdAtMs,
      synced: synced ?? this.synced,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (placeId.present) {
      map['place_id'] = Variable<String>(placeId.value);
    }
    if (stars.present) {
      map['stars'] = Variable<int>(stars.value);
    }
    if (comment.present) {
      map['comment'] = Variable<String>(comment.value);
    }
    if (createdAtMs.present) {
      map['created_at_ms'] = Variable<int>(createdAtMs.value);
    }
    if (synced.present) {
      map['synced'] = Variable<bool>(synced.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MooringReviewDraftsCompanion(')
          ..write('id: $id, ')
          ..write('placeId: $placeId, ')
          ..write('stars: $stars, ')
          ..write('comment: $comment, ')
          ..write('createdAtMs: $createdAtMs, ')
          ..write('synced: $synced, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UserActionAuditsTable userActionAudits = $UserActionAuditsTable(
    this,
  );
  late final $RoutesTable routes = $RoutesTable(this);
  late final $RouteWaypointsTable routeWaypoints = $RouteWaypointsTable(this);
  late final $ChartRegionsTable chartRegions = $ChartRegionsTable(this);
  late final $WeatherCacheRowsTable weatherCacheRows = $WeatherCacheRowsTable(
    this,
  );
  late final $MooringPlacesTable mooringPlaces = $MooringPlacesTable(this);
  late final $MooringReviewDraftsTable mooringReviewDrafts =
      $MooringReviewDraftsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    userActionAudits,
    routes,
    routeWaypoints,
    chartRegions,
    weatherCacheRows,
    mooringPlaces,
    mooringReviewDrafts,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'routes',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('route_waypoints', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$UserActionAuditsTableCreateCompanionBuilder =
    UserActionAuditsCompanion Function({
      Value<int> id,
      required int t,
      required String sessionId,
      required String module,
      required String action,
      Value<String> severity,
      Value<String?> contextJson,
    });
typedef $$UserActionAuditsTableUpdateCompanionBuilder =
    UserActionAuditsCompanion Function({
      Value<int> id,
      Value<int> t,
      Value<String> sessionId,
      Value<String> module,
      Value<String> action,
      Value<String> severity,
      Value<String?> contextJson,
    });

class $$UserActionAuditsTableFilterComposer
    extends Composer<_$AppDatabase, $UserActionAuditsTable> {
  $$UserActionAuditsTableFilterComposer({
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

  ColumnFilters<int> get t => $composableBuilder(
    column: $table.t,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sessionId => $composableBuilder(
    column: $table.sessionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get module => $composableBuilder(
    column: $table.module,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get action => $composableBuilder(
    column: $table.action,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get severity => $composableBuilder(
    column: $table.severity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contextJson => $composableBuilder(
    column: $table.contextJson,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UserActionAuditsTableOrderingComposer
    extends Composer<_$AppDatabase, $UserActionAuditsTable> {
  $$UserActionAuditsTableOrderingComposer({
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

  ColumnOrderings<int> get t => $composableBuilder(
    column: $table.t,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sessionId => $composableBuilder(
    column: $table.sessionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get module => $composableBuilder(
    column: $table.module,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get action => $composableBuilder(
    column: $table.action,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get severity => $composableBuilder(
    column: $table.severity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contextJson => $composableBuilder(
    column: $table.contextJson,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserActionAuditsTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserActionAuditsTable> {
  $$UserActionAuditsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get t =>
      $composableBuilder(column: $table.t, builder: (column) => column);

  GeneratedColumn<String> get sessionId =>
      $composableBuilder(column: $table.sessionId, builder: (column) => column);

  GeneratedColumn<String> get module =>
      $composableBuilder(column: $table.module, builder: (column) => column);

  GeneratedColumn<String> get action =>
      $composableBuilder(column: $table.action, builder: (column) => column);

  GeneratedColumn<String> get severity =>
      $composableBuilder(column: $table.severity, builder: (column) => column);

  GeneratedColumn<String> get contextJson => $composableBuilder(
    column: $table.contextJson,
    builder: (column) => column,
  );
}

class $$UserActionAuditsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserActionAuditsTable,
          UserActionAudit,
          $$UserActionAuditsTableFilterComposer,
          $$UserActionAuditsTableOrderingComposer,
          $$UserActionAuditsTableAnnotationComposer,
          $$UserActionAuditsTableCreateCompanionBuilder,
          $$UserActionAuditsTableUpdateCompanionBuilder,
          (
            UserActionAudit,
            BaseReferences<
              _$AppDatabase,
              $UserActionAuditsTable,
              UserActionAudit
            >,
          ),
          UserActionAudit,
          PrefetchHooks Function()
        > {
  $$UserActionAuditsTableTableManager(
    _$AppDatabase db,
    $UserActionAuditsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserActionAuditsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserActionAuditsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserActionAuditsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> t = const Value.absent(),
                Value<String> sessionId = const Value.absent(),
                Value<String> module = const Value.absent(),
                Value<String> action = const Value.absent(),
                Value<String> severity = const Value.absent(),
                Value<String?> contextJson = const Value.absent(),
              }) => UserActionAuditsCompanion(
                id: id,
                t: t,
                sessionId: sessionId,
                module: module,
                action: action,
                severity: severity,
                contextJson: contextJson,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int t,
                required String sessionId,
                required String module,
                required String action,
                Value<String> severity = const Value.absent(),
                Value<String?> contextJson = const Value.absent(),
              }) => UserActionAuditsCompanion.insert(
                id: id,
                t: t,
                sessionId: sessionId,
                module: module,
                action: action,
                severity: severity,
                contextJson: contextJson,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UserActionAuditsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserActionAuditsTable,
      UserActionAudit,
      $$UserActionAuditsTableFilterComposer,
      $$UserActionAuditsTableOrderingComposer,
      $$UserActionAuditsTableAnnotationComposer,
      $$UserActionAuditsTableCreateCompanionBuilder,
      $$UserActionAuditsTableUpdateCompanionBuilder,
      (
        UserActionAudit,
        BaseReferences<_$AppDatabase, $UserActionAuditsTable, UserActionAudit>,
      ),
      UserActionAudit,
      PrefetchHooks Function()
    >;
typedef $$RoutesTableCreateCompanionBuilder =
    RoutesCompanion Function({
      required String id,
      required String name,
      required int createdAt,
      required int updatedAt,
      Value<int> version,
      Value<int> rowid,
    });
typedef $$RoutesTableUpdateCompanionBuilder =
    RoutesCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<int> version,
      Value<int> rowid,
    });

final class $$RoutesTableReferences
    extends BaseReferences<_$AppDatabase, $RoutesTable, RouteEntity> {
  $$RoutesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$RouteWaypointsTable, List<RouteWaypointRow>>
  _routeWaypointsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.routeWaypoints,
    aliasName: $_aliasNameGenerator(db.routes.id, db.routeWaypoints.routeId),
  );

  $$RouteWaypointsTableProcessedTableManager get routeWaypointsRefs {
    final manager = $$RouteWaypointsTableTableManager(
      $_db,
      $_db.routeWaypoints,
    ).filter((f) => f.routeId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_routeWaypointsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$RoutesTableFilterComposer
    extends Composer<_$AppDatabase, $RoutesTable> {
  $$RoutesTableFilterComposer({
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

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> routeWaypointsRefs(
    Expression<bool> Function($$RouteWaypointsTableFilterComposer f) f,
  ) {
    final $$RouteWaypointsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.routeWaypoints,
      getReferencedColumn: (t) => t.routeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RouteWaypointsTableFilterComposer(
            $db: $db,
            $table: $db.routeWaypoints,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RoutesTableOrderingComposer
    extends Composer<_$AppDatabase, $RoutesTable> {
  $$RoutesTableOrderingComposer({
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

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RoutesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RoutesTable> {
  $$RoutesTableAnnotationComposer({
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

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  Expression<T> routeWaypointsRefs<T extends Object>(
    Expression<T> Function($$RouteWaypointsTableAnnotationComposer a) f,
  ) {
    final $$RouteWaypointsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.routeWaypoints,
      getReferencedColumn: (t) => t.routeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RouteWaypointsTableAnnotationComposer(
            $db: $db,
            $table: $db.routeWaypoints,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RoutesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RoutesTable,
          RouteEntity,
          $$RoutesTableFilterComposer,
          $$RoutesTableOrderingComposer,
          $$RoutesTableAnnotationComposer,
          $$RoutesTableCreateCompanionBuilder,
          $$RoutesTableUpdateCompanionBuilder,
          (RouteEntity, $$RoutesTableReferences),
          RouteEntity,
          PrefetchHooks Function({bool routeWaypointsRefs})
        > {
  $$RoutesTableTableManager(_$AppDatabase db, $RoutesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RoutesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RoutesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RoutesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RoutesCompanion(
                id: id,
                name: name,
                createdAt: createdAt,
                updatedAt: updatedAt,
                version: version,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required int createdAt,
                required int updatedAt,
                Value<int> version = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RoutesCompanion.insert(
                id: id,
                name: name,
                createdAt: createdAt,
                updatedAt: updatedAt,
                version: version,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$RoutesTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({routeWaypointsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (routeWaypointsRefs) db.routeWaypoints,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (routeWaypointsRefs)
                    await $_getPrefetchedData<
                      RouteEntity,
                      $RoutesTable,
                      RouteWaypointRow
                    >(
                      currentTable: table,
                      referencedTable: $$RoutesTableReferences
                          ._routeWaypointsRefsTable(db),
                      managerFromTypedResult: (p0) => $$RoutesTableReferences(
                        db,
                        table,
                        p0,
                      ).routeWaypointsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.routeId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$RoutesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RoutesTable,
      RouteEntity,
      $$RoutesTableFilterComposer,
      $$RoutesTableOrderingComposer,
      $$RoutesTableAnnotationComposer,
      $$RoutesTableCreateCompanionBuilder,
      $$RoutesTableUpdateCompanionBuilder,
      (RouteEntity, $$RoutesTableReferences),
      RouteEntity,
      PrefetchHooks Function({bool routeWaypointsRefs})
    >;
typedef $$RouteWaypointsTableCreateCompanionBuilder =
    RouteWaypointsCompanion Function({
      required String id,
      required String routeId,
      required int seq,
      required double lat,
      required double lon,
      Value<String?> name,
      Value<int> rowid,
    });
typedef $$RouteWaypointsTableUpdateCompanionBuilder =
    RouteWaypointsCompanion Function({
      Value<String> id,
      Value<String> routeId,
      Value<int> seq,
      Value<double> lat,
      Value<double> lon,
      Value<String?> name,
      Value<int> rowid,
    });

final class $$RouteWaypointsTableReferences
    extends
        BaseReferences<_$AppDatabase, $RouteWaypointsTable, RouteWaypointRow> {
  $$RouteWaypointsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $RoutesTable _routeIdTable(_$AppDatabase db) => db.routes.createAlias(
    $_aliasNameGenerator(db.routeWaypoints.routeId, db.routes.id),
  );

  $$RoutesTableProcessedTableManager get routeId {
    final $_column = $_itemColumn<String>('route_id')!;

    final manager = $$RoutesTableTableManager(
      $_db,
      $_db.routes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_routeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$RouteWaypointsTableFilterComposer
    extends Composer<_$AppDatabase, $RouteWaypointsTable> {
  $$RouteWaypointsTableFilterComposer({
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

  ColumnFilters<int> get seq => $composableBuilder(
    column: $table.seq,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lat => $composableBuilder(
    column: $table.lat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lon => $composableBuilder(
    column: $table.lon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  $$RoutesTableFilterComposer get routeId {
    final $$RoutesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.routeId,
      referencedTable: $db.routes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutesTableFilterComposer(
            $db: $db,
            $table: $db.routes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RouteWaypointsTableOrderingComposer
    extends Composer<_$AppDatabase, $RouteWaypointsTable> {
  $$RouteWaypointsTableOrderingComposer({
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

  ColumnOrderings<int> get seq => $composableBuilder(
    column: $table.seq,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lat => $composableBuilder(
    column: $table.lat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lon => $composableBuilder(
    column: $table.lon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  $$RoutesTableOrderingComposer get routeId {
    final $$RoutesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.routeId,
      referencedTable: $db.routes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutesTableOrderingComposer(
            $db: $db,
            $table: $db.routes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RouteWaypointsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RouteWaypointsTable> {
  $$RouteWaypointsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get seq =>
      $composableBuilder(column: $table.seq, builder: (column) => column);

  GeneratedColumn<double> get lat =>
      $composableBuilder(column: $table.lat, builder: (column) => column);

  GeneratedColumn<double> get lon =>
      $composableBuilder(column: $table.lon, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  $$RoutesTableAnnotationComposer get routeId {
    final $$RoutesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.routeId,
      referencedTable: $db.routes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutesTableAnnotationComposer(
            $db: $db,
            $table: $db.routes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RouteWaypointsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RouteWaypointsTable,
          RouteWaypointRow,
          $$RouteWaypointsTableFilterComposer,
          $$RouteWaypointsTableOrderingComposer,
          $$RouteWaypointsTableAnnotationComposer,
          $$RouteWaypointsTableCreateCompanionBuilder,
          $$RouteWaypointsTableUpdateCompanionBuilder,
          (RouteWaypointRow, $$RouteWaypointsTableReferences),
          RouteWaypointRow,
          PrefetchHooks Function({bool routeId})
        > {
  $$RouteWaypointsTableTableManager(
    _$AppDatabase db,
    $RouteWaypointsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RouteWaypointsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RouteWaypointsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RouteWaypointsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> routeId = const Value.absent(),
                Value<int> seq = const Value.absent(),
                Value<double> lat = const Value.absent(),
                Value<double> lon = const Value.absent(),
                Value<String?> name = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RouteWaypointsCompanion(
                id: id,
                routeId: routeId,
                seq: seq,
                lat: lat,
                lon: lon,
                name: name,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String routeId,
                required int seq,
                required double lat,
                required double lon,
                Value<String?> name = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RouteWaypointsCompanion.insert(
                id: id,
                routeId: routeId,
                seq: seq,
                lat: lat,
                lon: lon,
                name: name,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$RouteWaypointsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({routeId = false}) {
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
                    if (routeId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.routeId,
                                referencedTable: $$RouteWaypointsTableReferences
                                    ._routeIdTable(db),
                                referencedColumn:
                                    $$RouteWaypointsTableReferences
                                        ._routeIdTable(db)
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

typedef $$RouteWaypointsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RouteWaypointsTable,
      RouteWaypointRow,
      $$RouteWaypointsTableFilterComposer,
      $$RouteWaypointsTableOrderingComposer,
      $$RouteWaypointsTableAnnotationComposer,
      $$RouteWaypointsTableCreateCompanionBuilder,
      $$RouteWaypointsTableUpdateCompanionBuilder,
      (RouteWaypointRow, $$RouteWaypointsTableReferences),
      RouteWaypointRow,
      PrefetchHooks Function({bool routeId})
    >;
typedef $$ChartRegionsTableCreateCompanionBuilder =
    ChartRegionsCompanion Function({
      required String regionId,
      required String path,
      Value<String?> checksum,
      required int installedAt,
      required String licenseTier,
      Value<int> rowid,
    });
typedef $$ChartRegionsTableUpdateCompanionBuilder =
    ChartRegionsCompanion Function({
      Value<String> regionId,
      Value<String> path,
      Value<String?> checksum,
      Value<int> installedAt,
      Value<String> licenseTier,
      Value<int> rowid,
    });

class $$ChartRegionsTableFilterComposer
    extends Composer<_$AppDatabase, $ChartRegionsTable> {
  $$ChartRegionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get regionId => $composableBuilder(
    column: $table.regionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get path => $composableBuilder(
    column: $table.path,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get checksum => $composableBuilder(
    column: $table.checksum,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get installedAt => $composableBuilder(
    column: $table.installedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get licenseTier => $composableBuilder(
    column: $table.licenseTier,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ChartRegionsTableOrderingComposer
    extends Composer<_$AppDatabase, $ChartRegionsTable> {
  $$ChartRegionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get regionId => $composableBuilder(
    column: $table.regionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get path => $composableBuilder(
    column: $table.path,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get checksum => $composableBuilder(
    column: $table.checksum,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get installedAt => $composableBuilder(
    column: $table.installedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get licenseTier => $composableBuilder(
    column: $table.licenseTier,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ChartRegionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChartRegionsTable> {
  $$ChartRegionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get regionId =>
      $composableBuilder(column: $table.regionId, builder: (column) => column);

  GeneratedColumn<String> get path =>
      $composableBuilder(column: $table.path, builder: (column) => column);

  GeneratedColumn<String> get checksum =>
      $composableBuilder(column: $table.checksum, builder: (column) => column);

  GeneratedColumn<int> get installedAt => $composableBuilder(
    column: $table.installedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get licenseTier => $composableBuilder(
    column: $table.licenseTier,
    builder: (column) => column,
  );
}

class $$ChartRegionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ChartRegionsTable,
          ChartRegionRow,
          $$ChartRegionsTableFilterComposer,
          $$ChartRegionsTableOrderingComposer,
          $$ChartRegionsTableAnnotationComposer,
          $$ChartRegionsTableCreateCompanionBuilder,
          $$ChartRegionsTableUpdateCompanionBuilder,
          (
            ChartRegionRow,
            BaseReferences<_$AppDatabase, $ChartRegionsTable, ChartRegionRow>,
          ),
          ChartRegionRow,
          PrefetchHooks Function()
        > {
  $$ChartRegionsTableTableManager(_$AppDatabase db, $ChartRegionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChartRegionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChartRegionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChartRegionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> regionId = const Value.absent(),
                Value<String> path = const Value.absent(),
                Value<String?> checksum = const Value.absent(),
                Value<int> installedAt = const Value.absent(),
                Value<String> licenseTier = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChartRegionsCompanion(
                regionId: regionId,
                path: path,
                checksum: checksum,
                installedAt: installedAt,
                licenseTier: licenseTier,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String regionId,
                required String path,
                Value<String?> checksum = const Value.absent(),
                required int installedAt,
                required String licenseTier,
                Value<int> rowid = const Value.absent(),
              }) => ChartRegionsCompanion.insert(
                regionId: regionId,
                path: path,
                checksum: checksum,
                installedAt: installedAt,
                licenseTier: licenseTier,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ChartRegionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ChartRegionsTable,
      ChartRegionRow,
      $$ChartRegionsTableFilterComposer,
      $$ChartRegionsTableOrderingComposer,
      $$ChartRegionsTableAnnotationComposer,
      $$ChartRegionsTableCreateCompanionBuilder,
      $$ChartRegionsTableUpdateCompanionBuilder,
      (
        ChartRegionRow,
        BaseReferences<_$AppDatabase, $ChartRegionsTable, ChartRegionRow>,
      ),
      ChartRegionRow,
      PrefetchHooks Function()
    >;
typedef $$WeatherCacheRowsTableCreateCompanionBuilder =
    WeatherCacheRowsCompanion Function({
      required String gridKey,
      required String forecastJson,
      required int fetchedAtMs,
      required int expiresAtMs,
      Value<int> rowid,
    });
typedef $$WeatherCacheRowsTableUpdateCompanionBuilder =
    WeatherCacheRowsCompanion Function({
      Value<String> gridKey,
      Value<String> forecastJson,
      Value<int> fetchedAtMs,
      Value<int> expiresAtMs,
      Value<int> rowid,
    });

class $$WeatherCacheRowsTableFilterComposer
    extends Composer<_$AppDatabase, $WeatherCacheRowsTable> {
  $$WeatherCacheRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get gridKey => $composableBuilder(
    column: $table.gridKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get forecastJson => $composableBuilder(
    column: $table.forecastJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get fetchedAtMs => $composableBuilder(
    column: $table.fetchedAtMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get expiresAtMs => $composableBuilder(
    column: $table.expiresAtMs,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WeatherCacheRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $WeatherCacheRowsTable> {
  $$WeatherCacheRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get gridKey => $composableBuilder(
    column: $table.gridKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get forecastJson => $composableBuilder(
    column: $table.forecastJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get fetchedAtMs => $composableBuilder(
    column: $table.fetchedAtMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get expiresAtMs => $composableBuilder(
    column: $table.expiresAtMs,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WeatherCacheRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WeatherCacheRowsTable> {
  $$WeatherCacheRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get gridKey =>
      $composableBuilder(column: $table.gridKey, builder: (column) => column);

  GeneratedColumn<String> get forecastJson => $composableBuilder(
    column: $table.forecastJson,
    builder: (column) => column,
  );

  GeneratedColumn<int> get fetchedAtMs => $composableBuilder(
    column: $table.fetchedAtMs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get expiresAtMs => $composableBuilder(
    column: $table.expiresAtMs,
    builder: (column) => column,
  );
}

class $$WeatherCacheRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WeatherCacheRowsTable,
          WeatherCacheRow,
          $$WeatherCacheRowsTableFilterComposer,
          $$WeatherCacheRowsTableOrderingComposer,
          $$WeatherCacheRowsTableAnnotationComposer,
          $$WeatherCacheRowsTableCreateCompanionBuilder,
          $$WeatherCacheRowsTableUpdateCompanionBuilder,
          (
            WeatherCacheRow,
            BaseReferences<
              _$AppDatabase,
              $WeatherCacheRowsTable,
              WeatherCacheRow
            >,
          ),
          WeatherCacheRow,
          PrefetchHooks Function()
        > {
  $$WeatherCacheRowsTableTableManager(
    _$AppDatabase db,
    $WeatherCacheRowsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WeatherCacheRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WeatherCacheRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WeatherCacheRowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> gridKey = const Value.absent(),
                Value<String> forecastJson = const Value.absent(),
                Value<int> fetchedAtMs = const Value.absent(),
                Value<int> expiresAtMs = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WeatherCacheRowsCompanion(
                gridKey: gridKey,
                forecastJson: forecastJson,
                fetchedAtMs: fetchedAtMs,
                expiresAtMs: expiresAtMs,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String gridKey,
                required String forecastJson,
                required int fetchedAtMs,
                required int expiresAtMs,
                Value<int> rowid = const Value.absent(),
              }) => WeatherCacheRowsCompanion.insert(
                gridKey: gridKey,
                forecastJson: forecastJson,
                fetchedAtMs: fetchedAtMs,
                expiresAtMs: expiresAtMs,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WeatherCacheRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WeatherCacheRowsTable,
      WeatherCacheRow,
      $$WeatherCacheRowsTableFilterComposer,
      $$WeatherCacheRowsTableOrderingComposer,
      $$WeatherCacheRowsTableAnnotationComposer,
      $$WeatherCacheRowsTableCreateCompanionBuilder,
      $$WeatherCacheRowsTableUpdateCompanionBuilder,
      (
        WeatherCacheRow,
        BaseReferences<_$AppDatabase, $WeatherCacheRowsTable, WeatherCacheRow>,
      ),
      WeatherCacheRow,
      PrefetchHooks Function()
    >;
typedef $$MooringPlacesTableCreateCompanionBuilder =
    MooringPlacesCompanion Function({
      required String id,
      required String kind,
      required String name,
      required double lat,
      required double lon,
      Value<String?> vhf,
      Value<String?> phone,
      Value<String?> servicesJson,
      Value<String?> notes,
      Value<int> rowid,
    });
typedef $$MooringPlacesTableUpdateCompanionBuilder =
    MooringPlacesCompanion Function({
      Value<String> id,
      Value<String> kind,
      Value<String> name,
      Value<double> lat,
      Value<double> lon,
      Value<String?> vhf,
      Value<String?> phone,
      Value<String?> servicesJson,
      Value<String?> notes,
      Value<int> rowid,
    });

class $$MooringPlacesTableFilterComposer
    extends Composer<_$AppDatabase, $MooringPlacesTable> {
  $$MooringPlacesTableFilterComposer({
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

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lat => $composableBuilder(
    column: $table.lat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lon => $composableBuilder(
    column: $table.lon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get vhf => $composableBuilder(
    column: $table.vhf,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get servicesJson => $composableBuilder(
    column: $table.servicesJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MooringPlacesTableOrderingComposer
    extends Composer<_$AppDatabase, $MooringPlacesTable> {
  $$MooringPlacesTableOrderingComposer({
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

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lat => $composableBuilder(
    column: $table.lat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lon => $composableBuilder(
    column: $table.lon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get vhf => $composableBuilder(
    column: $table.vhf,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get servicesJson => $composableBuilder(
    column: $table.servicesJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MooringPlacesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MooringPlacesTable> {
  $$MooringPlacesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<double> get lat =>
      $composableBuilder(column: $table.lat, builder: (column) => column);

  GeneratedColumn<double> get lon =>
      $composableBuilder(column: $table.lon, builder: (column) => column);

  GeneratedColumn<String> get vhf =>
      $composableBuilder(column: $table.vhf, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get servicesJson => $composableBuilder(
    column: $table.servicesJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);
}

class $$MooringPlacesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MooringPlacesTable,
          MooringPlaceRow,
          $$MooringPlacesTableFilterComposer,
          $$MooringPlacesTableOrderingComposer,
          $$MooringPlacesTableAnnotationComposer,
          $$MooringPlacesTableCreateCompanionBuilder,
          $$MooringPlacesTableUpdateCompanionBuilder,
          (
            MooringPlaceRow,
            BaseReferences<_$AppDatabase, $MooringPlacesTable, MooringPlaceRow>,
          ),
          MooringPlaceRow,
          PrefetchHooks Function()
        > {
  $$MooringPlacesTableTableManager(_$AppDatabase db, $MooringPlacesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MooringPlacesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MooringPlacesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MooringPlacesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<double> lat = const Value.absent(),
                Value<double> lon = const Value.absent(),
                Value<String?> vhf = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> servicesJson = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MooringPlacesCompanion(
                id: id,
                kind: kind,
                name: name,
                lat: lat,
                lon: lon,
                vhf: vhf,
                phone: phone,
                servicesJson: servicesJson,
                notes: notes,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String kind,
                required String name,
                required double lat,
                required double lon,
                Value<String?> vhf = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> servicesJson = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MooringPlacesCompanion.insert(
                id: id,
                kind: kind,
                name: name,
                lat: lat,
                lon: lon,
                vhf: vhf,
                phone: phone,
                servicesJson: servicesJson,
                notes: notes,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MooringPlacesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MooringPlacesTable,
      MooringPlaceRow,
      $$MooringPlacesTableFilterComposer,
      $$MooringPlacesTableOrderingComposer,
      $$MooringPlacesTableAnnotationComposer,
      $$MooringPlacesTableCreateCompanionBuilder,
      $$MooringPlacesTableUpdateCompanionBuilder,
      (
        MooringPlaceRow,
        BaseReferences<_$AppDatabase, $MooringPlacesTable, MooringPlaceRow>,
      ),
      MooringPlaceRow,
      PrefetchHooks Function()
    >;
typedef $$MooringReviewDraftsTableCreateCompanionBuilder =
    MooringReviewDraftsCompanion Function({
      required String id,
      required String placeId,
      required int stars,
      Value<String?> comment,
      required int createdAtMs,
      Value<bool> synced,
      Value<int> rowid,
    });
typedef $$MooringReviewDraftsTableUpdateCompanionBuilder =
    MooringReviewDraftsCompanion Function({
      Value<String> id,
      Value<String> placeId,
      Value<int> stars,
      Value<String?> comment,
      Value<int> createdAtMs,
      Value<bool> synced,
      Value<int> rowid,
    });

class $$MooringReviewDraftsTableFilterComposer
    extends Composer<_$AppDatabase, $MooringReviewDraftsTable> {
  $$MooringReviewDraftsTableFilterComposer({
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

  ColumnFilters<String> get placeId => $composableBuilder(
    column: $table.placeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get stars => $composableBuilder(
    column: $table.stars,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get comment => $composableBuilder(
    column: $table.comment,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAtMs => $composableBuilder(
    column: $table.createdAtMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get synced => $composableBuilder(
    column: $table.synced,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MooringReviewDraftsTableOrderingComposer
    extends Composer<_$AppDatabase, $MooringReviewDraftsTable> {
  $$MooringReviewDraftsTableOrderingComposer({
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

  ColumnOrderings<String> get placeId => $composableBuilder(
    column: $table.placeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get stars => $composableBuilder(
    column: $table.stars,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get comment => $composableBuilder(
    column: $table.comment,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAtMs => $composableBuilder(
    column: $table.createdAtMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get synced => $composableBuilder(
    column: $table.synced,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MooringReviewDraftsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MooringReviewDraftsTable> {
  $$MooringReviewDraftsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get placeId =>
      $composableBuilder(column: $table.placeId, builder: (column) => column);

  GeneratedColumn<int> get stars =>
      $composableBuilder(column: $table.stars, builder: (column) => column);

  GeneratedColumn<String> get comment =>
      $composableBuilder(column: $table.comment, builder: (column) => column);

  GeneratedColumn<int> get createdAtMs => $composableBuilder(
    column: $table.createdAtMs,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get synced =>
      $composableBuilder(column: $table.synced, builder: (column) => column);
}

class $$MooringReviewDraftsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MooringReviewDraftsTable,
          MooringReviewDraftRow,
          $$MooringReviewDraftsTableFilterComposer,
          $$MooringReviewDraftsTableOrderingComposer,
          $$MooringReviewDraftsTableAnnotationComposer,
          $$MooringReviewDraftsTableCreateCompanionBuilder,
          $$MooringReviewDraftsTableUpdateCompanionBuilder,
          (
            MooringReviewDraftRow,
            BaseReferences<
              _$AppDatabase,
              $MooringReviewDraftsTable,
              MooringReviewDraftRow
            >,
          ),
          MooringReviewDraftRow,
          PrefetchHooks Function()
        > {
  $$MooringReviewDraftsTableTableManager(
    _$AppDatabase db,
    $MooringReviewDraftsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MooringReviewDraftsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MooringReviewDraftsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$MooringReviewDraftsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> placeId = const Value.absent(),
                Value<int> stars = const Value.absent(),
                Value<String?> comment = const Value.absent(),
                Value<int> createdAtMs = const Value.absent(),
                Value<bool> synced = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MooringReviewDraftsCompanion(
                id: id,
                placeId: placeId,
                stars: stars,
                comment: comment,
                createdAtMs: createdAtMs,
                synced: synced,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String placeId,
                required int stars,
                Value<String?> comment = const Value.absent(),
                required int createdAtMs,
                Value<bool> synced = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MooringReviewDraftsCompanion.insert(
                id: id,
                placeId: placeId,
                stars: stars,
                comment: comment,
                createdAtMs: createdAtMs,
                synced: synced,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MooringReviewDraftsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MooringReviewDraftsTable,
      MooringReviewDraftRow,
      $$MooringReviewDraftsTableFilterComposer,
      $$MooringReviewDraftsTableOrderingComposer,
      $$MooringReviewDraftsTableAnnotationComposer,
      $$MooringReviewDraftsTableCreateCompanionBuilder,
      $$MooringReviewDraftsTableUpdateCompanionBuilder,
      (
        MooringReviewDraftRow,
        BaseReferences<
          _$AppDatabase,
          $MooringReviewDraftsTable,
          MooringReviewDraftRow
        >,
      ),
      MooringReviewDraftRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UserActionAuditsTableTableManager get userActionAudits =>
      $$UserActionAuditsTableTableManager(_db, _db.userActionAudits);
  $$RoutesTableTableManager get routes =>
      $$RoutesTableTableManager(_db, _db.routes);
  $$RouteWaypointsTableTableManager get routeWaypoints =>
      $$RouteWaypointsTableTableManager(_db, _db.routeWaypoints);
  $$ChartRegionsTableTableManager get chartRegions =>
      $$ChartRegionsTableTableManager(_db, _db.chartRegions);
  $$WeatherCacheRowsTableTableManager get weatherCacheRows =>
      $$WeatherCacheRowsTableTableManager(_db, _db.weatherCacheRows);
  $$MooringPlacesTableTableManager get mooringPlaces =>
      $$MooringPlacesTableTableManager(_db, _db.mooringPlaces);
  $$MooringReviewDraftsTableTableManager get mooringReviewDrafts =>
      $$MooringReviewDraftsTableTableManager(_db, _db.mooringReviewDrafts);
}
