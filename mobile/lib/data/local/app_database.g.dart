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

class $TidesCacheRowsTable extends TidesCacheRows
    with TableInfo<$TidesCacheRowsTable, TidesCacheRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TidesCacheRowsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _tidesJsonMeta = const VerificationMeta(
    'tidesJson',
  );
  @override
  late final GeneratedColumn<String> tidesJson = GeneratedColumn<String>(
    'tides_json',
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
    tidesJson,
    fetchedAtMs,
    expiresAtMs,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tides_cache_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<TidesCacheRow> instance, {
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
    if (data.containsKey('tides_json')) {
      context.handle(
        _tidesJsonMeta,
        tidesJson.isAcceptableOrUnknown(data['tides_json']!, _tidesJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_tidesJsonMeta);
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
  TidesCacheRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TidesCacheRow(
      gridKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}grid_key'],
      )!,
      tidesJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tides_json'],
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
  $TidesCacheRowsTable createAlias(String alias) {
    return $TidesCacheRowsTable(attachedDatabase, alias);
  }
}

class TidesCacheRow extends DataClass implements Insertable<TidesCacheRow> {
  final String gridKey;
  final String tidesJson;
  final int fetchedAtMs;
  final int expiresAtMs;
  const TidesCacheRow({
    required this.gridKey,
    required this.tidesJson,
    required this.fetchedAtMs,
    required this.expiresAtMs,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['grid_key'] = Variable<String>(gridKey);
    map['tides_json'] = Variable<String>(tidesJson);
    map['fetched_at_ms'] = Variable<int>(fetchedAtMs);
    map['expires_at_ms'] = Variable<int>(expiresAtMs);
    return map;
  }

  TidesCacheRowsCompanion toCompanion(bool nullToAbsent) {
    return TidesCacheRowsCompanion(
      gridKey: Value(gridKey),
      tidesJson: Value(tidesJson),
      fetchedAtMs: Value(fetchedAtMs),
      expiresAtMs: Value(expiresAtMs),
    );
  }

  factory TidesCacheRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TidesCacheRow(
      gridKey: serializer.fromJson<String>(json['gridKey']),
      tidesJson: serializer.fromJson<String>(json['tidesJson']),
      fetchedAtMs: serializer.fromJson<int>(json['fetchedAtMs']),
      expiresAtMs: serializer.fromJson<int>(json['expiresAtMs']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'gridKey': serializer.toJson<String>(gridKey),
      'tidesJson': serializer.toJson<String>(tidesJson),
      'fetchedAtMs': serializer.toJson<int>(fetchedAtMs),
      'expiresAtMs': serializer.toJson<int>(expiresAtMs),
    };
  }

  TidesCacheRow copyWith({
    String? gridKey,
    String? tidesJson,
    int? fetchedAtMs,
    int? expiresAtMs,
  }) => TidesCacheRow(
    gridKey: gridKey ?? this.gridKey,
    tidesJson: tidesJson ?? this.tidesJson,
    fetchedAtMs: fetchedAtMs ?? this.fetchedAtMs,
    expiresAtMs: expiresAtMs ?? this.expiresAtMs,
  );
  TidesCacheRow copyWithCompanion(TidesCacheRowsCompanion data) {
    return TidesCacheRow(
      gridKey: data.gridKey.present ? data.gridKey.value : this.gridKey,
      tidesJson: data.tidesJson.present ? data.tidesJson.value : this.tidesJson,
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
    return (StringBuffer('TidesCacheRow(')
          ..write('gridKey: $gridKey, ')
          ..write('tidesJson: $tidesJson, ')
          ..write('fetchedAtMs: $fetchedAtMs, ')
          ..write('expiresAtMs: $expiresAtMs')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(gridKey, tidesJson, fetchedAtMs, expiresAtMs);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TidesCacheRow &&
          other.gridKey == this.gridKey &&
          other.tidesJson == this.tidesJson &&
          other.fetchedAtMs == this.fetchedAtMs &&
          other.expiresAtMs == this.expiresAtMs);
}

class TidesCacheRowsCompanion extends UpdateCompanion<TidesCacheRow> {
  final Value<String> gridKey;
  final Value<String> tidesJson;
  final Value<int> fetchedAtMs;
  final Value<int> expiresAtMs;
  final Value<int> rowid;
  const TidesCacheRowsCompanion({
    this.gridKey = const Value.absent(),
    this.tidesJson = const Value.absent(),
    this.fetchedAtMs = const Value.absent(),
    this.expiresAtMs = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TidesCacheRowsCompanion.insert({
    required String gridKey,
    required String tidesJson,
    required int fetchedAtMs,
    required int expiresAtMs,
    this.rowid = const Value.absent(),
  }) : gridKey = Value(gridKey),
       tidesJson = Value(tidesJson),
       fetchedAtMs = Value(fetchedAtMs),
       expiresAtMs = Value(expiresAtMs);
  static Insertable<TidesCacheRow> custom({
    Expression<String>? gridKey,
    Expression<String>? tidesJson,
    Expression<int>? fetchedAtMs,
    Expression<int>? expiresAtMs,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (gridKey != null) 'grid_key': gridKey,
      if (tidesJson != null) 'tides_json': tidesJson,
      if (fetchedAtMs != null) 'fetched_at_ms': fetchedAtMs,
      if (expiresAtMs != null) 'expires_at_ms': expiresAtMs,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TidesCacheRowsCompanion copyWith({
    Value<String>? gridKey,
    Value<String>? tidesJson,
    Value<int>? fetchedAtMs,
    Value<int>? expiresAtMs,
    Value<int>? rowid,
  }) {
    return TidesCacheRowsCompanion(
      gridKey: gridKey ?? this.gridKey,
      tidesJson: tidesJson ?? this.tidesJson,
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
    if (tidesJson.present) {
      map['tides_json'] = Variable<String>(tidesJson.value);
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
    return (StringBuffer('TidesCacheRowsCompanion(')
          ..write('gridKey: $gridKey, ')
          ..write('tidesJson: $tidesJson, ')
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
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _websiteUrlMeta = const VerificationMeta(
    'websiteUrl',
  );
  @override
  late final GeneratedColumn<String> websiteUrl = GeneratedColumn<String>(
    'website_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bookingUrlMeta = const VerificationMeta(
    'bookingUrl',
  );
  @override
  late final GeneratedColumn<String> bookingUrl = GeneratedColumn<String>(
    'booking_url',
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
  static const VerificationMeta _sourceUpdatedAtMsMeta = const VerificationMeta(
    'sourceUpdatedAtMs',
  );
  @override
  late final GeneratedColumn<int> sourceUpdatedAtMs = GeneratedColumn<int>(
    'source_updated_at_ms',
    aliasedName,
    true,
    type: DriftSqlType.int,
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
    email,
    websiteUrl,
    bookingUrl,
    servicesJson,
    notes,
    sourceUpdatedAtMs,
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
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    }
    if (data.containsKey('website_url')) {
      context.handle(
        _websiteUrlMeta,
        websiteUrl.isAcceptableOrUnknown(data['website_url']!, _websiteUrlMeta),
      );
    }
    if (data.containsKey('booking_url')) {
      context.handle(
        _bookingUrlMeta,
        bookingUrl.isAcceptableOrUnknown(data['booking_url']!, _bookingUrlMeta),
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
    if (data.containsKey('source_updated_at_ms')) {
      context.handle(
        _sourceUpdatedAtMsMeta,
        sourceUpdatedAtMs.isAcceptableOrUnknown(
          data['source_updated_at_ms']!,
          _sourceUpdatedAtMsMeta,
        ),
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
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      ),
      websiteUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}website_url'],
      ),
      bookingUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}booking_url'],
      ),
      servicesJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}services_json'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      sourceUpdatedAtMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}source_updated_at_ms'],
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
  final String? email;
  final String? websiteUrl;

  /// Партнёрское бронирование или веб-форма (deeplink).
  final String? bookingUrl;

  /// JSON: electricity, water, wifi, showers — флаги для карточки.
  final String? servicesJson;
  final String? notes;

  /// Версия строки каталога для merge при импорте пакетов (новее побеждает).
  final int? sourceUpdatedAtMs;
  const MooringPlaceRow({
    required this.id,
    required this.kind,
    required this.name,
    required this.lat,
    required this.lon,
    this.vhf,
    this.phone,
    this.email,
    this.websiteUrl,
    this.bookingUrl,
    this.servicesJson,
    this.notes,
    this.sourceUpdatedAtMs,
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
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || websiteUrl != null) {
      map['website_url'] = Variable<String>(websiteUrl);
    }
    if (!nullToAbsent || bookingUrl != null) {
      map['booking_url'] = Variable<String>(bookingUrl);
    }
    if (!nullToAbsent || servicesJson != null) {
      map['services_json'] = Variable<String>(servicesJson);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || sourceUpdatedAtMs != null) {
      map['source_updated_at_ms'] = Variable<int>(sourceUpdatedAtMs);
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
      email: email == null && nullToAbsent
          ? const Value.absent()
          : Value(email),
      websiteUrl: websiteUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(websiteUrl),
      bookingUrl: bookingUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(bookingUrl),
      servicesJson: servicesJson == null && nullToAbsent
          ? const Value.absent()
          : Value(servicesJson),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      sourceUpdatedAtMs: sourceUpdatedAtMs == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceUpdatedAtMs),
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
      email: serializer.fromJson<String?>(json['email']),
      websiteUrl: serializer.fromJson<String?>(json['websiteUrl']),
      bookingUrl: serializer.fromJson<String?>(json['bookingUrl']),
      servicesJson: serializer.fromJson<String?>(json['servicesJson']),
      notes: serializer.fromJson<String?>(json['notes']),
      sourceUpdatedAtMs: serializer.fromJson<int?>(json['sourceUpdatedAtMs']),
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
      'email': serializer.toJson<String?>(email),
      'websiteUrl': serializer.toJson<String?>(websiteUrl),
      'bookingUrl': serializer.toJson<String?>(bookingUrl),
      'servicesJson': serializer.toJson<String?>(servicesJson),
      'notes': serializer.toJson<String?>(notes),
      'sourceUpdatedAtMs': serializer.toJson<int?>(sourceUpdatedAtMs),
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
    Value<String?> email = const Value.absent(),
    Value<String?> websiteUrl = const Value.absent(),
    Value<String?> bookingUrl = const Value.absent(),
    Value<String?> servicesJson = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    Value<int?> sourceUpdatedAtMs = const Value.absent(),
  }) => MooringPlaceRow(
    id: id ?? this.id,
    kind: kind ?? this.kind,
    name: name ?? this.name,
    lat: lat ?? this.lat,
    lon: lon ?? this.lon,
    vhf: vhf.present ? vhf.value : this.vhf,
    phone: phone.present ? phone.value : this.phone,
    email: email.present ? email.value : this.email,
    websiteUrl: websiteUrl.present ? websiteUrl.value : this.websiteUrl,
    bookingUrl: bookingUrl.present ? bookingUrl.value : this.bookingUrl,
    servicesJson: servicesJson.present ? servicesJson.value : this.servicesJson,
    notes: notes.present ? notes.value : this.notes,
    sourceUpdatedAtMs: sourceUpdatedAtMs.present
        ? sourceUpdatedAtMs.value
        : this.sourceUpdatedAtMs,
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
      email: data.email.present ? data.email.value : this.email,
      websiteUrl: data.websiteUrl.present
          ? data.websiteUrl.value
          : this.websiteUrl,
      bookingUrl: data.bookingUrl.present
          ? data.bookingUrl.value
          : this.bookingUrl,
      servicesJson: data.servicesJson.present
          ? data.servicesJson.value
          : this.servicesJson,
      notes: data.notes.present ? data.notes.value : this.notes,
      sourceUpdatedAtMs: data.sourceUpdatedAtMs.present
          ? data.sourceUpdatedAtMs.value
          : this.sourceUpdatedAtMs,
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
          ..write('email: $email, ')
          ..write('websiteUrl: $websiteUrl, ')
          ..write('bookingUrl: $bookingUrl, ')
          ..write('servicesJson: $servicesJson, ')
          ..write('notes: $notes, ')
          ..write('sourceUpdatedAtMs: $sourceUpdatedAtMs')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    kind,
    name,
    lat,
    lon,
    vhf,
    phone,
    email,
    websiteUrl,
    bookingUrl,
    servicesJson,
    notes,
    sourceUpdatedAtMs,
  );
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
          other.email == this.email &&
          other.websiteUrl == this.websiteUrl &&
          other.bookingUrl == this.bookingUrl &&
          other.servicesJson == this.servicesJson &&
          other.notes == this.notes &&
          other.sourceUpdatedAtMs == this.sourceUpdatedAtMs);
}

class MooringPlacesCompanion extends UpdateCompanion<MooringPlaceRow> {
  final Value<String> id;
  final Value<String> kind;
  final Value<String> name;
  final Value<double> lat;
  final Value<double> lon;
  final Value<String?> vhf;
  final Value<String?> phone;
  final Value<String?> email;
  final Value<String?> websiteUrl;
  final Value<String?> bookingUrl;
  final Value<String?> servicesJson;
  final Value<String?> notes;
  final Value<int?> sourceUpdatedAtMs;
  final Value<int> rowid;
  const MooringPlacesCompanion({
    this.id = const Value.absent(),
    this.kind = const Value.absent(),
    this.name = const Value.absent(),
    this.lat = const Value.absent(),
    this.lon = const Value.absent(),
    this.vhf = const Value.absent(),
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    this.websiteUrl = const Value.absent(),
    this.bookingUrl = const Value.absent(),
    this.servicesJson = const Value.absent(),
    this.notes = const Value.absent(),
    this.sourceUpdatedAtMs = const Value.absent(),
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
    this.email = const Value.absent(),
    this.websiteUrl = const Value.absent(),
    this.bookingUrl = const Value.absent(),
    this.servicesJson = const Value.absent(),
    this.notes = const Value.absent(),
    this.sourceUpdatedAtMs = const Value.absent(),
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
    Expression<String>? email,
    Expression<String>? websiteUrl,
    Expression<String>? bookingUrl,
    Expression<String>? servicesJson,
    Expression<String>? notes,
    Expression<int>? sourceUpdatedAtMs,
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
      if (email != null) 'email': email,
      if (websiteUrl != null) 'website_url': websiteUrl,
      if (bookingUrl != null) 'booking_url': bookingUrl,
      if (servicesJson != null) 'services_json': servicesJson,
      if (notes != null) 'notes': notes,
      if (sourceUpdatedAtMs != null) 'source_updated_at_ms': sourceUpdatedAtMs,
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
    Value<String?>? email,
    Value<String?>? websiteUrl,
    Value<String?>? bookingUrl,
    Value<String?>? servicesJson,
    Value<String?>? notes,
    Value<int?>? sourceUpdatedAtMs,
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
      email: email ?? this.email,
      websiteUrl: websiteUrl ?? this.websiteUrl,
      bookingUrl: bookingUrl ?? this.bookingUrl,
      servicesJson: servicesJson ?? this.servicesJson,
      notes: notes ?? this.notes,
      sourceUpdatedAtMs: sourceUpdatedAtMs ?? this.sourceUpdatedAtMs,
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
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (websiteUrl.present) {
      map['website_url'] = Variable<String>(websiteUrl.value);
    }
    if (bookingUrl.present) {
      map['booking_url'] = Variable<String>(bookingUrl.value);
    }
    if (servicesJson.present) {
      map['services_json'] = Variable<String>(servicesJson.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (sourceUpdatedAtMs.present) {
      map['source_updated_at_ms'] = Variable<int>(sourceUpdatedAtMs.value);
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
          ..write('email: $email, ')
          ..write('websiteUrl: $websiteUrl, ')
          ..write('bookingUrl: $bookingUrl, ')
          ..write('servicesJson: $servicesJson, ')
          ..write('notes: $notes, ')
          ..write('sourceUpdatedAtMs: $sourceUpdatedAtMs, ')
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

class $LogbookEntriesTable extends LogbookEntries
    with TableInfo<$LogbookEntriesTable, LogbookEntryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LogbookEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadJsonMeta = const VerificationMeta(
    'payloadJson',
  );
  @override
  late final GeneratedColumn<String> payloadJson = GeneratedColumn<String>(
    'payload_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, t, category, payloadJson];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'logbook_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<LogbookEntryRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('t')) {
      context.handle(_tMeta, t.isAcceptableOrUnknown(data['t']!, _tMeta));
    } else if (isInserting) {
      context.missing(_tMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('payload_json')) {
      context.handle(
        _payloadJsonMeta,
        payloadJson.isAcceptableOrUnknown(
          data['payload_json']!,
          _payloadJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_payloadJsonMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LogbookEntryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LogbookEntryRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      t: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}t'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      payloadJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload_json'],
      )!,
    );
  }

  @override
  $LogbookEntriesTable createAlias(String alias) {
    return $LogbookEntriesTable(attachedDatabase, alias);
  }
}

class LogbookEntryRow extends DataClass implements Insertable<LogbookEntryRow> {
  final String id;
  final int t;
  final String category;
  final String payloadJson;
  const LogbookEntryRow({
    required this.id,
    required this.t,
    required this.category,
    required this.payloadJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['t'] = Variable<int>(t);
    map['category'] = Variable<String>(category);
    map['payload_json'] = Variable<String>(payloadJson);
    return map;
  }

  LogbookEntriesCompanion toCompanion(bool nullToAbsent) {
    return LogbookEntriesCompanion(
      id: Value(id),
      t: Value(t),
      category: Value(category),
      payloadJson: Value(payloadJson),
    );
  }

  factory LogbookEntryRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LogbookEntryRow(
      id: serializer.fromJson<String>(json['id']),
      t: serializer.fromJson<int>(json['t']),
      category: serializer.fromJson<String>(json['category']),
      payloadJson: serializer.fromJson<String>(json['payloadJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      't': serializer.toJson<int>(t),
      'category': serializer.toJson<String>(category),
      'payloadJson': serializer.toJson<String>(payloadJson),
    };
  }

  LogbookEntryRow copyWith({
    String? id,
    int? t,
    String? category,
    String? payloadJson,
  }) => LogbookEntryRow(
    id: id ?? this.id,
    t: t ?? this.t,
    category: category ?? this.category,
    payloadJson: payloadJson ?? this.payloadJson,
  );
  LogbookEntryRow copyWithCompanion(LogbookEntriesCompanion data) {
    return LogbookEntryRow(
      id: data.id.present ? data.id.value : this.id,
      t: data.t.present ? data.t.value : this.t,
      category: data.category.present ? data.category.value : this.category,
      payloadJson: data.payloadJson.present
          ? data.payloadJson.value
          : this.payloadJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LogbookEntryRow(')
          ..write('id: $id, ')
          ..write('t: $t, ')
          ..write('category: $category, ')
          ..write('payloadJson: $payloadJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, t, category, payloadJson);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LogbookEntryRow &&
          other.id == this.id &&
          other.t == this.t &&
          other.category == this.category &&
          other.payloadJson == this.payloadJson);
}

class LogbookEntriesCompanion extends UpdateCompanion<LogbookEntryRow> {
  final Value<String> id;
  final Value<int> t;
  final Value<String> category;
  final Value<String> payloadJson;
  final Value<int> rowid;
  const LogbookEntriesCompanion({
    this.id = const Value.absent(),
    this.t = const Value.absent(),
    this.category = const Value.absent(),
    this.payloadJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LogbookEntriesCompanion.insert({
    required String id,
    required int t,
    required String category,
    required String payloadJson,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       t = Value(t),
       category = Value(category),
       payloadJson = Value(payloadJson);
  static Insertable<LogbookEntryRow> custom({
    Expression<String>? id,
    Expression<int>? t,
    Expression<String>? category,
    Expression<String>? payloadJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (t != null) 't': t,
      if (category != null) 'category': category,
      if (payloadJson != null) 'payload_json': payloadJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LogbookEntriesCompanion copyWith({
    Value<String>? id,
    Value<int>? t,
    Value<String>? category,
    Value<String>? payloadJson,
    Value<int>? rowid,
  }) {
    return LogbookEntriesCompanion(
      id: id ?? this.id,
      t: t ?? this.t,
      category: category ?? this.category,
      payloadJson: payloadJson ?? this.payloadJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (t.present) {
      map['t'] = Variable<int>(t.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (payloadJson.present) {
      map['payload_json'] = Variable<String>(payloadJson.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LogbookEntriesCompanion(')
          ..write('id: $id, ')
          ..write('t: $t, ')
          ..write('category: $category, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TrackTripsTable extends TrackTrips
    with TableInfo<$TrackTripsTable, TrackTripRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TrackTripsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startedAtMsMeta = const VerificationMeta(
    'startedAtMs',
  );
  @override
  late final GeneratedColumn<int> startedAtMs = GeneratedColumn<int>(
    'started_at_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endedAtMsMeta = const VerificationMeta(
    'endedAtMs',
  );
  @override
  late final GeneratedColumn<int> endedAtMs = GeneratedColumn<int>(
    'ended_at_ms',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, startedAtMs, endedAtMs];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'track_trips';
  @override
  VerificationContext validateIntegrity(
    Insertable<TrackTripRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('started_at_ms')) {
      context.handle(
        _startedAtMsMeta,
        startedAtMs.isAcceptableOrUnknown(
          data['started_at_ms']!,
          _startedAtMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_startedAtMsMeta);
    }
    if (data.containsKey('ended_at_ms')) {
      context.handle(
        _endedAtMsMeta,
        endedAtMs.isAcceptableOrUnknown(data['ended_at_ms']!, _endedAtMsMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TrackTripRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TrackTripRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      startedAtMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}started_at_ms'],
      )!,
      endedAtMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ended_at_ms'],
      ),
    );
  }

  @override
  $TrackTripsTable createAlias(String alias) {
    return $TrackTripsTable(attachedDatabase, alias);
  }
}

class TrackTripRow extends DataClass implements Insertable<TrackTripRow> {
  final String id;
  final int startedAtMs;
  final int? endedAtMs;
  const TrackTripRow({
    required this.id,
    required this.startedAtMs,
    this.endedAtMs,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['started_at_ms'] = Variable<int>(startedAtMs);
    if (!nullToAbsent || endedAtMs != null) {
      map['ended_at_ms'] = Variable<int>(endedAtMs);
    }
    return map;
  }

  TrackTripsCompanion toCompanion(bool nullToAbsent) {
    return TrackTripsCompanion(
      id: Value(id),
      startedAtMs: Value(startedAtMs),
      endedAtMs: endedAtMs == null && nullToAbsent
          ? const Value.absent()
          : Value(endedAtMs),
    );
  }

  factory TrackTripRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TrackTripRow(
      id: serializer.fromJson<String>(json['id']),
      startedAtMs: serializer.fromJson<int>(json['startedAtMs']),
      endedAtMs: serializer.fromJson<int?>(json['endedAtMs']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'startedAtMs': serializer.toJson<int>(startedAtMs),
      'endedAtMs': serializer.toJson<int?>(endedAtMs),
    };
  }

  TrackTripRow copyWith({
    String? id,
    int? startedAtMs,
    Value<int?> endedAtMs = const Value.absent(),
  }) => TrackTripRow(
    id: id ?? this.id,
    startedAtMs: startedAtMs ?? this.startedAtMs,
    endedAtMs: endedAtMs.present ? endedAtMs.value : this.endedAtMs,
  );
  TrackTripRow copyWithCompanion(TrackTripsCompanion data) {
    return TrackTripRow(
      id: data.id.present ? data.id.value : this.id,
      startedAtMs: data.startedAtMs.present
          ? data.startedAtMs.value
          : this.startedAtMs,
      endedAtMs: data.endedAtMs.present ? data.endedAtMs.value : this.endedAtMs,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TrackTripRow(')
          ..write('id: $id, ')
          ..write('startedAtMs: $startedAtMs, ')
          ..write('endedAtMs: $endedAtMs')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, startedAtMs, endedAtMs);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TrackTripRow &&
          other.id == this.id &&
          other.startedAtMs == this.startedAtMs &&
          other.endedAtMs == this.endedAtMs);
}

class TrackTripsCompanion extends UpdateCompanion<TrackTripRow> {
  final Value<String> id;
  final Value<int> startedAtMs;
  final Value<int?> endedAtMs;
  final Value<int> rowid;
  const TrackTripsCompanion({
    this.id = const Value.absent(),
    this.startedAtMs = const Value.absent(),
    this.endedAtMs = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TrackTripsCompanion.insert({
    required String id,
    required int startedAtMs,
    this.endedAtMs = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       startedAtMs = Value(startedAtMs);
  static Insertable<TrackTripRow> custom({
    Expression<String>? id,
    Expression<int>? startedAtMs,
    Expression<int>? endedAtMs,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (startedAtMs != null) 'started_at_ms': startedAtMs,
      if (endedAtMs != null) 'ended_at_ms': endedAtMs,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TrackTripsCompanion copyWith({
    Value<String>? id,
    Value<int>? startedAtMs,
    Value<int?>? endedAtMs,
    Value<int>? rowid,
  }) {
    return TrackTripsCompanion(
      id: id ?? this.id,
      startedAtMs: startedAtMs ?? this.startedAtMs,
      endedAtMs: endedAtMs ?? this.endedAtMs,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (startedAtMs.present) {
      map['started_at_ms'] = Variable<int>(startedAtMs.value);
    }
    if (endedAtMs.present) {
      map['ended_at_ms'] = Variable<int>(endedAtMs.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TrackTripsCompanion(')
          ..write('id: $id, ')
          ..write('startedAtMs: $startedAtMs, ')
          ..write('endedAtMs: $endedAtMs, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TrackPointsTable extends TrackPoints
    with TableInfo<$TrackPointsTable, TrackPointRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TrackPointsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _tripIdMeta = const VerificationMeta('tripId');
  @override
  late final GeneratedColumn<String> tripId = GeneratedColumn<String>(
    'trip_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  static const VerificationMeta _sogMeta = const VerificationMeta('sog');
  @override
  late final GeneratedColumn<double> sog = GeneratedColumn<double>(
    'sog',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cogMeta = const VerificationMeta('cog');
  @override
  late final GeneratedColumn<double> cog = GeneratedColumn<double>(
    'cog',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, tripId, t, lat, lon, sog, cog];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'track_points';
  @override
  VerificationContext validateIntegrity(
    Insertable<TrackPointRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('trip_id')) {
      context.handle(
        _tripIdMeta,
        tripId.isAcceptableOrUnknown(data['trip_id']!, _tripIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tripIdMeta);
    }
    if (data.containsKey('t')) {
      context.handle(_tMeta, t.isAcceptableOrUnknown(data['t']!, _tMeta));
    } else if (isInserting) {
      context.missing(_tMeta);
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
    if (data.containsKey('sog')) {
      context.handle(
        _sogMeta,
        sog.isAcceptableOrUnknown(data['sog']!, _sogMeta),
      );
    }
    if (data.containsKey('cog')) {
      context.handle(
        _cogMeta,
        cog.isAcceptableOrUnknown(data['cog']!, _cogMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TrackPointRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TrackPointRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      tripId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}trip_id'],
      )!,
      t: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}t'],
      )!,
      lat: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}lat'],
      )!,
      lon: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}lon'],
      )!,
      sog: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}sog'],
      ),
      cog: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}cog'],
      ),
    );
  }

  @override
  $TrackPointsTable createAlias(String alias) {
    return $TrackPointsTable(attachedDatabase, alias);
  }
}

class TrackPointRow extends DataClass implements Insertable<TrackPointRow> {
  final int id;
  final String tripId;
  final int t;
  final double lat;
  final double lon;
  final double? sog;
  final double? cog;
  const TrackPointRow({
    required this.id,
    required this.tripId,
    required this.t,
    required this.lat,
    required this.lon,
    this.sog,
    this.cog,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['trip_id'] = Variable<String>(tripId);
    map['t'] = Variable<int>(t);
    map['lat'] = Variable<double>(lat);
    map['lon'] = Variable<double>(lon);
    if (!nullToAbsent || sog != null) {
      map['sog'] = Variable<double>(sog);
    }
    if (!nullToAbsent || cog != null) {
      map['cog'] = Variable<double>(cog);
    }
    return map;
  }

  TrackPointsCompanion toCompanion(bool nullToAbsent) {
    return TrackPointsCompanion(
      id: Value(id),
      tripId: Value(tripId),
      t: Value(t),
      lat: Value(lat),
      lon: Value(lon),
      sog: sog == null && nullToAbsent ? const Value.absent() : Value(sog),
      cog: cog == null && nullToAbsent ? const Value.absent() : Value(cog),
    );
  }

  factory TrackPointRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TrackPointRow(
      id: serializer.fromJson<int>(json['id']),
      tripId: serializer.fromJson<String>(json['tripId']),
      t: serializer.fromJson<int>(json['t']),
      lat: serializer.fromJson<double>(json['lat']),
      lon: serializer.fromJson<double>(json['lon']),
      sog: serializer.fromJson<double?>(json['sog']),
      cog: serializer.fromJson<double?>(json['cog']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'tripId': serializer.toJson<String>(tripId),
      't': serializer.toJson<int>(t),
      'lat': serializer.toJson<double>(lat),
      'lon': serializer.toJson<double>(lon),
      'sog': serializer.toJson<double?>(sog),
      'cog': serializer.toJson<double?>(cog),
    };
  }

  TrackPointRow copyWith({
    int? id,
    String? tripId,
    int? t,
    double? lat,
    double? lon,
    Value<double?> sog = const Value.absent(),
    Value<double?> cog = const Value.absent(),
  }) => TrackPointRow(
    id: id ?? this.id,
    tripId: tripId ?? this.tripId,
    t: t ?? this.t,
    lat: lat ?? this.lat,
    lon: lon ?? this.lon,
    sog: sog.present ? sog.value : this.sog,
    cog: cog.present ? cog.value : this.cog,
  );
  TrackPointRow copyWithCompanion(TrackPointsCompanion data) {
    return TrackPointRow(
      id: data.id.present ? data.id.value : this.id,
      tripId: data.tripId.present ? data.tripId.value : this.tripId,
      t: data.t.present ? data.t.value : this.t,
      lat: data.lat.present ? data.lat.value : this.lat,
      lon: data.lon.present ? data.lon.value : this.lon,
      sog: data.sog.present ? data.sog.value : this.sog,
      cog: data.cog.present ? data.cog.value : this.cog,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TrackPointRow(')
          ..write('id: $id, ')
          ..write('tripId: $tripId, ')
          ..write('t: $t, ')
          ..write('lat: $lat, ')
          ..write('lon: $lon, ')
          ..write('sog: $sog, ')
          ..write('cog: $cog')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, tripId, t, lat, lon, sog, cog);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TrackPointRow &&
          other.id == this.id &&
          other.tripId == this.tripId &&
          other.t == this.t &&
          other.lat == this.lat &&
          other.lon == this.lon &&
          other.sog == this.sog &&
          other.cog == this.cog);
}

class TrackPointsCompanion extends UpdateCompanion<TrackPointRow> {
  final Value<int> id;
  final Value<String> tripId;
  final Value<int> t;
  final Value<double> lat;
  final Value<double> lon;
  final Value<double?> sog;
  final Value<double?> cog;
  const TrackPointsCompanion({
    this.id = const Value.absent(),
    this.tripId = const Value.absent(),
    this.t = const Value.absent(),
    this.lat = const Value.absent(),
    this.lon = const Value.absent(),
    this.sog = const Value.absent(),
    this.cog = const Value.absent(),
  });
  TrackPointsCompanion.insert({
    this.id = const Value.absent(),
    required String tripId,
    required int t,
    required double lat,
    required double lon,
    this.sog = const Value.absent(),
    this.cog = const Value.absent(),
  }) : tripId = Value(tripId),
       t = Value(t),
       lat = Value(lat),
       lon = Value(lon);
  static Insertable<TrackPointRow> custom({
    Expression<int>? id,
    Expression<String>? tripId,
    Expression<int>? t,
    Expression<double>? lat,
    Expression<double>? lon,
    Expression<double>? sog,
    Expression<double>? cog,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tripId != null) 'trip_id': tripId,
      if (t != null) 't': t,
      if (lat != null) 'lat': lat,
      if (lon != null) 'lon': lon,
      if (sog != null) 'sog': sog,
      if (cog != null) 'cog': cog,
    });
  }

  TrackPointsCompanion copyWith({
    Value<int>? id,
    Value<String>? tripId,
    Value<int>? t,
    Value<double>? lat,
    Value<double>? lon,
    Value<double?>? sog,
    Value<double?>? cog,
  }) {
    return TrackPointsCompanion(
      id: id ?? this.id,
      tripId: tripId ?? this.tripId,
      t: t ?? this.t,
      lat: lat ?? this.lat,
      lon: lon ?? this.lon,
      sog: sog ?? this.sog,
      cog: cog ?? this.cog,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (tripId.present) {
      map['trip_id'] = Variable<String>(tripId.value);
    }
    if (t.present) {
      map['t'] = Variable<int>(t.value);
    }
    if (lat.present) {
      map['lat'] = Variable<double>(lat.value);
    }
    if (lon.present) {
      map['lon'] = Variable<double>(lon.value);
    }
    if (sog.present) {
      map['sog'] = Variable<double>(sog.value);
    }
    if (cog.present) {
      map['cog'] = Variable<double>(cog.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TrackPointsCompanion(')
          ..write('id: $id, ')
          ..write('tripId: $tripId, ')
          ..write('t: $t, ')
          ..write('lat: $lat, ')
          ..write('lon: $lon, ')
          ..write('sog: $sog, ')
          ..write('cog: $cog')
          ..write(')'))
        .toString();
  }
}

class $ChecklistInstancesTable extends ChecklistInstances
    with TableInfo<$ChecklistInstancesTable, ChecklistInstanceRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChecklistInstancesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _templateKeyMeta = const VerificationMeta(
    'templateKey',
  );
  @override
  late final GeneratedColumn<String> templateKey = GeneratedColumn<String>(
    'template_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _itemsJsonMeta = const VerificationMeta(
    'itemsJson',
  );
  @override
  late final GeneratedColumn<String> itemsJson = GeneratedColumn<String>(
    'items_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMsMeta = const VerificationMeta(
    'updatedAtMs',
  );
  @override
  late final GeneratedColumn<int> updatedAtMs = GeneratedColumn<int>(
    'updated_at_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _completedMeta = const VerificationMeta(
    'completed',
  );
  @override
  late final GeneratedColumn<bool> completed = GeneratedColumn<bool>(
    'completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    templateKey,
    itemsJson,
    updatedAtMs,
    completed,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'checklist_instances';
  @override
  VerificationContext validateIntegrity(
    Insertable<ChecklistInstanceRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('template_key')) {
      context.handle(
        _templateKeyMeta,
        templateKey.isAcceptableOrUnknown(
          data['template_key']!,
          _templateKeyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_templateKeyMeta);
    }
    if (data.containsKey('items_json')) {
      context.handle(
        _itemsJsonMeta,
        itemsJson.isAcceptableOrUnknown(data['items_json']!, _itemsJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_itemsJsonMeta);
    }
    if (data.containsKey('updated_at_ms')) {
      context.handle(
        _updatedAtMsMeta,
        updatedAtMs.isAcceptableOrUnknown(
          data['updated_at_ms']!,
          _updatedAtMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMsMeta);
    }
    if (data.containsKey('completed')) {
      context.handle(
        _completedMeta,
        completed.isAcceptableOrUnknown(data['completed']!, _completedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChecklistInstanceRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChecklistInstanceRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      templateKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}template_key'],
      )!,
      itemsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}items_json'],
      )!,
      updatedAtMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at_ms'],
      )!,
      completed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}completed'],
      )!,
    );
  }

  @override
  $ChecklistInstancesTable createAlias(String alias) {
    return $ChecklistInstancesTable(attachedDatabase, alias);
  }
}

class ChecklistInstanceRow extends DataClass
    implements Insertable<ChecklistInstanceRow> {
  final String id;
  final String templateKey;

  /// [{\"id\":\"a\",\"label\":\"...\",\"done\":false}, ...]
  final String itemsJson;
  final int updatedAtMs;
  final bool completed;
  const ChecklistInstanceRow({
    required this.id,
    required this.templateKey,
    required this.itemsJson,
    required this.updatedAtMs,
    required this.completed,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['template_key'] = Variable<String>(templateKey);
    map['items_json'] = Variable<String>(itemsJson);
    map['updated_at_ms'] = Variable<int>(updatedAtMs);
    map['completed'] = Variable<bool>(completed);
    return map;
  }

  ChecklistInstancesCompanion toCompanion(bool nullToAbsent) {
    return ChecklistInstancesCompanion(
      id: Value(id),
      templateKey: Value(templateKey),
      itemsJson: Value(itemsJson),
      updatedAtMs: Value(updatedAtMs),
      completed: Value(completed),
    );
  }

  factory ChecklistInstanceRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChecklistInstanceRow(
      id: serializer.fromJson<String>(json['id']),
      templateKey: serializer.fromJson<String>(json['templateKey']),
      itemsJson: serializer.fromJson<String>(json['itemsJson']),
      updatedAtMs: serializer.fromJson<int>(json['updatedAtMs']),
      completed: serializer.fromJson<bool>(json['completed']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'templateKey': serializer.toJson<String>(templateKey),
      'itemsJson': serializer.toJson<String>(itemsJson),
      'updatedAtMs': serializer.toJson<int>(updatedAtMs),
      'completed': serializer.toJson<bool>(completed),
    };
  }

  ChecklistInstanceRow copyWith({
    String? id,
    String? templateKey,
    String? itemsJson,
    int? updatedAtMs,
    bool? completed,
  }) => ChecklistInstanceRow(
    id: id ?? this.id,
    templateKey: templateKey ?? this.templateKey,
    itemsJson: itemsJson ?? this.itemsJson,
    updatedAtMs: updatedAtMs ?? this.updatedAtMs,
    completed: completed ?? this.completed,
  );
  ChecklistInstanceRow copyWithCompanion(ChecklistInstancesCompanion data) {
    return ChecklistInstanceRow(
      id: data.id.present ? data.id.value : this.id,
      templateKey: data.templateKey.present
          ? data.templateKey.value
          : this.templateKey,
      itemsJson: data.itemsJson.present ? data.itemsJson.value : this.itemsJson,
      updatedAtMs: data.updatedAtMs.present
          ? data.updatedAtMs.value
          : this.updatedAtMs,
      completed: data.completed.present ? data.completed.value : this.completed,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChecklistInstanceRow(')
          ..write('id: $id, ')
          ..write('templateKey: $templateKey, ')
          ..write('itemsJson: $itemsJson, ')
          ..write('updatedAtMs: $updatedAtMs, ')
          ..write('completed: $completed')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, templateKey, itemsJson, updatedAtMs, completed);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChecklistInstanceRow &&
          other.id == this.id &&
          other.templateKey == this.templateKey &&
          other.itemsJson == this.itemsJson &&
          other.updatedAtMs == this.updatedAtMs &&
          other.completed == this.completed);
}

class ChecklistInstancesCompanion
    extends UpdateCompanion<ChecklistInstanceRow> {
  final Value<String> id;
  final Value<String> templateKey;
  final Value<String> itemsJson;
  final Value<int> updatedAtMs;
  final Value<bool> completed;
  final Value<int> rowid;
  const ChecklistInstancesCompanion({
    this.id = const Value.absent(),
    this.templateKey = const Value.absent(),
    this.itemsJson = const Value.absent(),
    this.updatedAtMs = const Value.absent(),
    this.completed = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ChecklistInstancesCompanion.insert({
    required String id,
    required String templateKey,
    required String itemsJson,
    required int updatedAtMs,
    this.completed = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       templateKey = Value(templateKey),
       itemsJson = Value(itemsJson),
       updatedAtMs = Value(updatedAtMs);
  static Insertable<ChecklistInstanceRow> custom({
    Expression<String>? id,
    Expression<String>? templateKey,
    Expression<String>? itemsJson,
    Expression<int>? updatedAtMs,
    Expression<bool>? completed,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (templateKey != null) 'template_key': templateKey,
      if (itemsJson != null) 'items_json': itemsJson,
      if (updatedAtMs != null) 'updated_at_ms': updatedAtMs,
      if (completed != null) 'completed': completed,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ChecklistInstancesCompanion copyWith({
    Value<String>? id,
    Value<String>? templateKey,
    Value<String>? itemsJson,
    Value<int>? updatedAtMs,
    Value<bool>? completed,
    Value<int>? rowid,
  }) {
    return ChecklistInstancesCompanion(
      id: id ?? this.id,
      templateKey: templateKey ?? this.templateKey,
      itemsJson: itemsJson ?? this.itemsJson,
      updatedAtMs: updatedAtMs ?? this.updatedAtMs,
      completed: completed ?? this.completed,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (templateKey.present) {
      map['template_key'] = Variable<String>(templateKey.value);
    }
    if (itemsJson.present) {
      map['items_json'] = Variable<String>(itemsJson.value);
    }
    if (updatedAtMs.present) {
      map['updated_at_ms'] = Variable<int>(updatedAtMs.value);
    }
    if (completed.present) {
      map['completed'] = Variable<bool>(completed.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChecklistInstancesCompanion(')
          ..write('id: $id, ')
          ..write('templateKey: $templateKey, ')
          ..write('itemsJson: $itemsJson, ')
          ..write('updatedAtMs: $updatedAtMs, ')
          ..write('completed: $completed, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $VaultFilesTable extends VaultFiles
    with TableInfo<$VaultFilesTable, VaultFileRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VaultFilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _displayNameMeta = const VerificationMeta(
    'displayName',
  );
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
    'display_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cipherPayloadBase64Meta =
      const VerificationMeta('cipherPayloadBase64');
  @override
  late final GeneratedColumn<String> cipherPayloadBase64 =
      GeneratedColumn<String>(
        'cipher_payload_base64',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _plainSizeBytesMeta = const VerificationMeta(
    'plainSizeBytes',
  );
  @override
  late final GeneratedColumn<int> plainSizeBytes = GeneratedColumn<int>(
    'plain_size_bytes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    displayName,
    cipherPayloadBase64,
    plainSizeBytes,
    createdAtMs,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'vault_files';
  @override
  VerificationContext validateIntegrity(
    Insertable<VaultFileRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('display_name')) {
      context.handle(
        _displayNameMeta,
        displayName.isAcceptableOrUnknown(
          data['display_name']!,
          _displayNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_displayNameMeta);
    }
    if (data.containsKey('cipher_payload_base64')) {
      context.handle(
        _cipherPayloadBase64Meta,
        cipherPayloadBase64.isAcceptableOrUnknown(
          data['cipher_payload_base64']!,
          _cipherPayloadBase64Meta,
        ),
      );
    } else if (isInserting) {
      context.missing(_cipherPayloadBase64Meta);
    }
    if (data.containsKey('plain_size_bytes')) {
      context.handle(
        _plainSizeBytesMeta,
        plainSizeBytes.isAcceptableOrUnknown(
          data['plain_size_bytes']!,
          _plainSizeBytesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_plainSizeBytesMeta);
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
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  VaultFileRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VaultFileRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      displayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_name'],
      )!,
      cipherPayloadBase64: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cipher_payload_base64'],
      )!,
      plainSizeBytes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}plain_size_bytes'],
      )!,
      createdAtMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at_ms'],
      )!,
    );
  }

  @override
  $VaultFilesTable createAlias(String alias) {
    return $VaultFilesTable(attachedDatabase, alias);
  }
}

class VaultFileRow extends DataClass implements Insertable<VaultFileRow> {
  final String id;
  final String displayName;

  /// AES-GCM: nonce + ciphertext, base64.
  final String cipherPayloadBase64;
  final int plainSizeBytes;
  final int createdAtMs;
  const VaultFileRow({
    required this.id,
    required this.displayName,
    required this.cipherPayloadBase64,
    required this.plainSizeBytes,
    required this.createdAtMs,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['display_name'] = Variable<String>(displayName);
    map['cipher_payload_base64'] = Variable<String>(cipherPayloadBase64);
    map['plain_size_bytes'] = Variable<int>(plainSizeBytes);
    map['created_at_ms'] = Variable<int>(createdAtMs);
    return map;
  }

  VaultFilesCompanion toCompanion(bool nullToAbsent) {
    return VaultFilesCompanion(
      id: Value(id),
      displayName: Value(displayName),
      cipherPayloadBase64: Value(cipherPayloadBase64),
      plainSizeBytes: Value(plainSizeBytes),
      createdAtMs: Value(createdAtMs),
    );
  }

  factory VaultFileRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VaultFileRow(
      id: serializer.fromJson<String>(json['id']),
      displayName: serializer.fromJson<String>(json['displayName']),
      cipherPayloadBase64: serializer.fromJson<String>(
        json['cipherPayloadBase64'],
      ),
      plainSizeBytes: serializer.fromJson<int>(json['plainSizeBytes']),
      createdAtMs: serializer.fromJson<int>(json['createdAtMs']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'displayName': serializer.toJson<String>(displayName),
      'cipherPayloadBase64': serializer.toJson<String>(cipherPayloadBase64),
      'plainSizeBytes': serializer.toJson<int>(plainSizeBytes),
      'createdAtMs': serializer.toJson<int>(createdAtMs),
    };
  }

  VaultFileRow copyWith({
    String? id,
    String? displayName,
    String? cipherPayloadBase64,
    int? plainSizeBytes,
    int? createdAtMs,
  }) => VaultFileRow(
    id: id ?? this.id,
    displayName: displayName ?? this.displayName,
    cipherPayloadBase64: cipherPayloadBase64 ?? this.cipherPayloadBase64,
    plainSizeBytes: plainSizeBytes ?? this.plainSizeBytes,
    createdAtMs: createdAtMs ?? this.createdAtMs,
  );
  VaultFileRow copyWithCompanion(VaultFilesCompanion data) {
    return VaultFileRow(
      id: data.id.present ? data.id.value : this.id,
      displayName: data.displayName.present
          ? data.displayName.value
          : this.displayName,
      cipherPayloadBase64: data.cipherPayloadBase64.present
          ? data.cipherPayloadBase64.value
          : this.cipherPayloadBase64,
      plainSizeBytes: data.plainSizeBytes.present
          ? data.plainSizeBytes.value
          : this.plainSizeBytes,
      createdAtMs: data.createdAtMs.present
          ? data.createdAtMs.value
          : this.createdAtMs,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VaultFileRow(')
          ..write('id: $id, ')
          ..write('displayName: $displayName, ')
          ..write('cipherPayloadBase64: $cipherPayloadBase64, ')
          ..write('plainSizeBytes: $plainSizeBytes, ')
          ..write('createdAtMs: $createdAtMs')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    displayName,
    cipherPayloadBase64,
    plainSizeBytes,
    createdAtMs,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VaultFileRow &&
          other.id == this.id &&
          other.displayName == this.displayName &&
          other.cipherPayloadBase64 == this.cipherPayloadBase64 &&
          other.plainSizeBytes == this.plainSizeBytes &&
          other.createdAtMs == this.createdAtMs);
}

class VaultFilesCompanion extends UpdateCompanion<VaultFileRow> {
  final Value<String> id;
  final Value<String> displayName;
  final Value<String> cipherPayloadBase64;
  final Value<int> plainSizeBytes;
  final Value<int> createdAtMs;
  final Value<int> rowid;
  const VaultFilesCompanion({
    this.id = const Value.absent(),
    this.displayName = const Value.absent(),
    this.cipherPayloadBase64 = const Value.absent(),
    this.plainSizeBytes = const Value.absent(),
    this.createdAtMs = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  VaultFilesCompanion.insert({
    required String id,
    required String displayName,
    required String cipherPayloadBase64,
    required int plainSizeBytes,
    required int createdAtMs,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       displayName = Value(displayName),
       cipherPayloadBase64 = Value(cipherPayloadBase64),
       plainSizeBytes = Value(plainSizeBytes),
       createdAtMs = Value(createdAtMs);
  static Insertable<VaultFileRow> custom({
    Expression<String>? id,
    Expression<String>? displayName,
    Expression<String>? cipherPayloadBase64,
    Expression<int>? plainSizeBytes,
    Expression<int>? createdAtMs,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (displayName != null) 'display_name': displayName,
      if (cipherPayloadBase64 != null)
        'cipher_payload_base64': cipherPayloadBase64,
      if (plainSizeBytes != null) 'plain_size_bytes': plainSizeBytes,
      if (createdAtMs != null) 'created_at_ms': createdAtMs,
      if (rowid != null) 'rowid': rowid,
    });
  }

  VaultFilesCompanion copyWith({
    Value<String>? id,
    Value<String>? displayName,
    Value<String>? cipherPayloadBase64,
    Value<int>? plainSizeBytes,
    Value<int>? createdAtMs,
    Value<int>? rowid,
  }) {
    return VaultFilesCompanion(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      cipherPayloadBase64: cipherPayloadBase64 ?? this.cipherPayloadBase64,
      plainSizeBytes: plainSizeBytes ?? this.plainSizeBytes,
      createdAtMs: createdAtMs ?? this.createdAtMs,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (cipherPayloadBase64.present) {
      map['cipher_payload_base64'] = Variable<String>(
        cipherPayloadBase64.value,
      );
    }
    if (plainSizeBytes.present) {
      map['plain_size_bytes'] = Variable<int>(plainSizeBytes.value);
    }
    if (createdAtMs.present) {
      map['created_at_ms'] = Variable<int>(createdAtMs.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VaultFilesCompanion(')
          ..write('id: $id, ')
          ..write('displayName: $displayName, ')
          ..write('cipherPayloadBase64: $cipherPayloadBase64, ')
          ..write('plainSizeBytes: $plainSizeBytes, ')
          ..write('createdAtMs: $createdAtMs, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ExpenseEntriesTable extends ExpenseEntries
    with TableInfo<$ExpenseEntriesTable, ExpenseEntryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExpenseEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMinorMeta = const VerificationMeta(
    'amountMinor',
  );
  @override
  late final GeneratedColumn<int> amountMinor = GeneratedColumn<int>(
    'amount_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('EUR'),
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    t,
    category,
    amountMinor,
    currency,
    note,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'expense_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<ExpenseEntryRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('t')) {
      context.handle(_tMeta, t.isAcceptableOrUnknown(data['t']!, _tMeta));
    } else if (isInserting) {
      context.missing(_tMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('amount_minor')) {
      context.handle(
        _amountMinorMeta,
        amountMinor.isAcceptableOrUnknown(
          data['amount_minor']!,
          _amountMinorMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountMinorMeta);
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ExpenseEntryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExpenseEntryRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      t: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}t'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      amountMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_minor'],
      )!,
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
    );
  }

  @override
  $ExpenseEntriesTable createAlias(String alias) {
    return $ExpenseEntriesTable(attachedDatabase, alias);
  }
}

class ExpenseEntryRow extends DataClass implements Insertable<ExpenseEntryRow> {
  final String id;
  final int t;

  /// fuel, food, marina, mooring_fee, gear, provisions, other
  final String category;

  /// В минимальных единицах валюты (центы).
  final int amountMinor;
  final String currency;
  final String? note;
  const ExpenseEntryRow({
    required this.id,
    required this.t,
    required this.category,
    required this.amountMinor,
    required this.currency,
    this.note,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['t'] = Variable<int>(t);
    map['category'] = Variable<String>(category);
    map['amount_minor'] = Variable<int>(amountMinor);
    map['currency'] = Variable<String>(currency);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    return map;
  }

  ExpenseEntriesCompanion toCompanion(bool nullToAbsent) {
    return ExpenseEntriesCompanion(
      id: Value(id),
      t: Value(t),
      category: Value(category),
      amountMinor: Value(amountMinor),
      currency: Value(currency),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
    );
  }

  factory ExpenseEntryRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExpenseEntryRow(
      id: serializer.fromJson<String>(json['id']),
      t: serializer.fromJson<int>(json['t']),
      category: serializer.fromJson<String>(json['category']),
      amountMinor: serializer.fromJson<int>(json['amountMinor']),
      currency: serializer.fromJson<String>(json['currency']),
      note: serializer.fromJson<String?>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      't': serializer.toJson<int>(t),
      'category': serializer.toJson<String>(category),
      'amountMinor': serializer.toJson<int>(amountMinor),
      'currency': serializer.toJson<String>(currency),
      'note': serializer.toJson<String?>(note),
    };
  }

  ExpenseEntryRow copyWith({
    String? id,
    int? t,
    String? category,
    int? amountMinor,
    String? currency,
    Value<String?> note = const Value.absent(),
  }) => ExpenseEntryRow(
    id: id ?? this.id,
    t: t ?? this.t,
    category: category ?? this.category,
    amountMinor: amountMinor ?? this.amountMinor,
    currency: currency ?? this.currency,
    note: note.present ? note.value : this.note,
  );
  ExpenseEntryRow copyWithCompanion(ExpenseEntriesCompanion data) {
    return ExpenseEntryRow(
      id: data.id.present ? data.id.value : this.id,
      t: data.t.present ? data.t.value : this.t,
      category: data.category.present ? data.category.value : this.category,
      amountMinor: data.amountMinor.present
          ? data.amountMinor.value
          : this.amountMinor,
      currency: data.currency.present ? data.currency.value : this.currency,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExpenseEntryRow(')
          ..write('id: $id, ')
          ..write('t: $t, ')
          ..write('category: $category, ')
          ..write('amountMinor: $amountMinor, ')
          ..write('currency: $currency, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, t, category, amountMinor, currency, note);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExpenseEntryRow &&
          other.id == this.id &&
          other.t == this.t &&
          other.category == this.category &&
          other.amountMinor == this.amountMinor &&
          other.currency == this.currency &&
          other.note == this.note);
}

class ExpenseEntriesCompanion extends UpdateCompanion<ExpenseEntryRow> {
  final Value<String> id;
  final Value<int> t;
  final Value<String> category;
  final Value<int> amountMinor;
  final Value<String> currency;
  final Value<String?> note;
  final Value<int> rowid;
  const ExpenseEntriesCompanion({
    this.id = const Value.absent(),
    this.t = const Value.absent(),
    this.category = const Value.absent(),
    this.amountMinor = const Value.absent(),
    this.currency = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ExpenseEntriesCompanion.insert({
    required String id,
    required int t,
    required String category,
    required int amountMinor,
    this.currency = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       t = Value(t),
       category = Value(category),
       amountMinor = Value(amountMinor);
  static Insertable<ExpenseEntryRow> custom({
    Expression<String>? id,
    Expression<int>? t,
    Expression<String>? category,
    Expression<int>? amountMinor,
    Expression<String>? currency,
    Expression<String>? note,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (t != null) 't': t,
      if (category != null) 'category': category,
      if (amountMinor != null) 'amount_minor': amountMinor,
      if (currency != null) 'currency': currency,
      if (note != null) 'note': note,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ExpenseEntriesCompanion copyWith({
    Value<String>? id,
    Value<int>? t,
    Value<String>? category,
    Value<int>? amountMinor,
    Value<String>? currency,
    Value<String?>? note,
    Value<int>? rowid,
  }) {
    return ExpenseEntriesCompanion(
      id: id ?? this.id,
      t: t ?? this.t,
      category: category ?? this.category,
      amountMinor: amountMinor ?? this.amountMinor,
      currency: currency ?? this.currency,
      note: note ?? this.note,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (t.present) {
      map['t'] = Variable<int>(t.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (amountMinor.present) {
      map['amount_minor'] = Variable<int>(amountMinor.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExpenseEntriesCompanion(')
          ..write('id: $id, ')
          ..write('t: $t, ')
          ..write('category: $category, ')
          ..write('amountMinor: $amountMinor, ')
          ..write('currency: $currency, ')
          ..write('note: $note, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $VhfRecordingsTable extends VhfRecordings
    with TableInfo<$VhfRecordingsTable, VhfRecordingRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VhfRecordingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  static const VerificationMeta _pathMeta = const VerificationMeta('path');
  @override
  late final GeneratedColumn<String> path = GeneratedColumn<String>(
    'path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _transcriptMeta = const VerificationMeta(
    'transcript',
  );
  @override
  late final GeneratedColumn<String> transcript = GeneratedColumn<String>(
    'transcript',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _durationMsMeta = const VerificationMeta(
    'durationMs',
  );
  @override
  late final GeneratedColumn<int> durationMs = GeneratedColumn<int>(
    'duration_ms',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, t, path, transcript, durationMs];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'vhf_recordings';
  @override
  VerificationContext validateIntegrity(
    Insertable<VhfRecordingRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('t')) {
      context.handle(_tMeta, t.isAcceptableOrUnknown(data['t']!, _tMeta));
    } else if (isInserting) {
      context.missing(_tMeta);
    }
    if (data.containsKey('path')) {
      context.handle(
        _pathMeta,
        path.isAcceptableOrUnknown(data['path']!, _pathMeta),
      );
    } else if (isInserting) {
      context.missing(_pathMeta);
    }
    if (data.containsKey('transcript')) {
      context.handle(
        _transcriptMeta,
        transcript.isAcceptableOrUnknown(data['transcript']!, _transcriptMeta),
      );
    }
    if (data.containsKey('duration_ms')) {
      context.handle(
        _durationMsMeta,
        durationMs.isAcceptableOrUnknown(data['duration_ms']!, _durationMsMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  VhfRecordingRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VhfRecordingRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      t: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}t'],
      )!,
      path: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}path'],
      )!,
      transcript: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}transcript'],
      ),
      durationMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_ms'],
      ),
    );
  }

  @override
  $VhfRecordingsTable createAlias(String alias) {
    return $VhfRecordingsTable(attachedDatabase, alias);
  }
}

class VhfRecordingRow extends DataClass implements Insertable<VhfRecordingRow> {
  final String id;
  final int t;
  final String path;
  final String? transcript;
  final int? durationMs;
  const VhfRecordingRow({
    required this.id,
    required this.t,
    required this.path,
    this.transcript,
    this.durationMs,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['t'] = Variable<int>(t);
    map['path'] = Variable<String>(path);
    if (!nullToAbsent || transcript != null) {
      map['transcript'] = Variable<String>(transcript);
    }
    if (!nullToAbsent || durationMs != null) {
      map['duration_ms'] = Variable<int>(durationMs);
    }
    return map;
  }

  VhfRecordingsCompanion toCompanion(bool nullToAbsent) {
    return VhfRecordingsCompanion(
      id: Value(id),
      t: Value(t),
      path: Value(path),
      transcript: transcript == null && nullToAbsent
          ? const Value.absent()
          : Value(transcript),
      durationMs: durationMs == null && nullToAbsent
          ? const Value.absent()
          : Value(durationMs),
    );
  }

  factory VhfRecordingRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VhfRecordingRow(
      id: serializer.fromJson<String>(json['id']),
      t: serializer.fromJson<int>(json['t']),
      path: serializer.fromJson<String>(json['path']),
      transcript: serializer.fromJson<String?>(json['transcript']),
      durationMs: serializer.fromJson<int?>(json['durationMs']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      't': serializer.toJson<int>(t),
      'path': serializer.toJson<String>(path),
      'transcript': serializer.toJson<String?>(transcript),
      'durationMs': serializer.toJson<int?>(durationMs),
    };
  }

  VhfRecordingRow copyWith({
    String? id,
    int? t,
    String? path,
    Value<String?> transcript = const Value.absent(),
    Value<int?> durationMs = const Value.absent(),
  }) => VhfRecordingRow(
    id: id ?? this.id,
    t: t ?? this.t,
    path: path ?? this.path,
    transcript: transcript.present ? transcript.value : this.transcript,
    durationMs: durationMs.present ? durationMs.value : this.durationMs,
  );
  VhfRecordingRow copyWithCompanion(VhfRecordingsCompanion data) {
    return VhfRecordingRow(
      id: data.id.present ? data.id.value : this.id,
      t: data.t.present ? data.t.value : this.t,
      path: data.path.present ? data.path.value : this.path,
      transcript: data.transcript.present
          ? data.transcript.value
          : this.transcript,
      durationMs: data.durationMs.present
          ? data.durationMs.value
          : this.durationMs,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VhfRecordingRow(')
          ..write('id: $id, ')
          ..write('t: $t, ')
          ..write('path: $path, ')
          ..write('transcript: $transcript, ')
          ..write('durationMs: $durationMs')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, t, path, transcript, durationMs);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VhfRecordingRow &&
          other.id == this.id &&
          other.t == this.t &&
          other.path == this.path &&
          other.transcript == this.transcript &&
          other.durationMs == this.durationMs);
}

class VhfRecordingsCompanion extends UpdateCompanion<VhfRecordingRow> {
  final Value<String> id;
  final Value<int> t;
  final Value<String> path;
  final Value<String?> transcript;
  final Value<int?> durationMs;
  final Value<int> rowid;
  const VhfRecordingsCompanion({
    this.id = const Value.absent(),
    this.t = const Value.absent(),
    this.path = const Value.absent(),
    this.transcript = const Value.absent(),
    this.durationMs = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  VhfRecordingsCompanion.insert({
    required String id,
    required int t,
    required String path,
    this.transcript = const Value.absent(),
    this.durationMs = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       t = Value(t),
       path = Value(path);
  static Insertable<VhfRecordingRow> custom({
    Expression<String>? id,
    Expression<int>? t,
    Expression<String>? path,
    Expression<String>? transcript,
    Expression<int>? durationMs,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (t != null) 't': t,
      if (path != null) 'path': path,
      if (transcript != null) 'transcript': transcript,
      if (durationMs != null) 'duration_ms': durationMs,
      if (rowid != null) 'rowid': rowid,
    });
  }

  VhfRecordingsCompanion copyWith({
    Value<String>? id,
    Value<int>? t,
    Value<String>? path,
    Value<String?>? transcript,
    Value<int?>? durationMs,
    Value<int>? rowid,
  }) {
    return VhfRecordingsCompanion(
      id: id ?? this.id,
      t: t ?? this.t,
      path: path ?? this.path,
      transcript: transcript ?? this.transcript,
      durationMs: durationMs ?? this.durationMs,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (t.present) {
      map['t'] = Variable<int>(t.value);
    }
    if (path.present) {
      map['path'] = Variable<String>(path.value);
    }
    if (transcript.present) {
      map['transcript'] = Variable<String>(transcript.value);
    }
    if (durationMs.present) {
      map['duration_ms'] = Variable<int>(durationMs.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VhfRecordingsCompanion(')
          ..write('id: $id, ')
          ..write('t: $t, ')
          ..write('path: $path, ')
          ..write('transcript: $transcript, ')
          ..write('durationMs: $durationMs, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GribImportCacheTable extends GribImportCache
    with TableInfo<$GribImportCacheTable, GribImportCacheRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GribImportCacheTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _pathMeta = const VerificationMeta('path');
  @override
  late final GeneratedColumn<String> path = GeneratedColumn<String>(
    'path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _importedAtMsMeta = const VerificationMeta(
    'importedAtMs',
  );
  @override
  late final GeneratedColumn<int> importedAtMs = GeneratedColumn<int>(
    'imported_at_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _decodeSummaryMeta = const VerificationMeta(
    'decodeSummary',
  );
  @override
  late final GeneratedColumn<String> decodeSummary = GeneratedColumn<String>(
    'decode_summary',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _decodeErrorMeta = const VerificationMeta(
    'decodeError',
  );
  @override
  late final GeneratedColumn<String> decodeError = GeneratedColumn<String>(
    'decode_error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _windSampleLabelMeta = const VerificationMeta(
    'windSampleLabel',
  );
  @override
  late final GeneratedColumn<String> windSampleLabel = GeneratedColumn<String>(
    'wind_sample_label',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    path,
    importedAtMs,
    decodeSummary,
    decodeError,
    windSampleLabel,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'grib_import_cache';
  @override
  VerificationContext validateIntegrity(
    Insertable<GribImportCacheRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('path')) {
      context.handle(
        _pathMeta,
        path.isAcceptableOrUnknown(data['path']!, _pathMeta),
      );
    } else if (isInserting) {
      context.missing(_pathMeta);
    }
    if (data.containsKey('imported_at_ms')) {
      context.handle(
        _importedAtMsMeta,
        importedAtMs.isAcceptableOrUnknown(
          data['imported_at_ms']!,
          _importedAtMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_importedAtMsMeta);
    }
    if (data.containsKey('decode_summary')) {
      context.handle(
        _decodeSummaryMeta,
        decodeSummary.isAcceptableOrUnknown(
          data['decode_summary']!,
          _decodeSummaryMeta,
        ),
      );
    }
    if (data.containsKey('decode_error')) {
      context.handle(
        _decodeErrorMeta,
        decodeError.isAcceptableOrUnknown(
          data['decode_error']!,
          _decodeErrorMeta,
        ),
      );
    }
    if (data.containsKey('wind_sample_label')) {
      context.handle(
        _windSampleLabelMeta,
        windSampleLabel.isAcceptableOrUnknown(
          data['wind_sample_label']!,
          _windSampleLabelMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {path};
  @override
  GribImportCacheRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GribImportCacheRow(
      path: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}path'],
      )!,
      importedAtMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}imported_at_ms'],
      )!,
      decodeSummary: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}decode_summary'],
      ),
      decodeError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}decode_error'],
      ),
      windSampleLabel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}wind_sample_label'],
      ),
    );
  }

  @override
  $GribImportCacheTable createAlias(String alias) {
    return $GribImportCacheTable(attachedDatabase, alias);
  }
}

class GribImportCacheRow extends DataClass
    implements Insertable<GribImportCacheRow> {
  final String path;
  final int importedAtMs;
  final String? decodeSummary;
  final String? decodeError;
  final String? windSampleLabel;
  const GribImportCacheRow({
    required this.path,
    required this.importedAtMs,
    this.decodeSummary,
    this.decodeError,
    this.windSampleLabel,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['path'] = Variable<String>(path);
    map['imported_at_ms'] = Variable<int>(importedAtMs);
    if (!nullToAbsent || decodeSummary != null) {
      map['decode_summary'] = Variable<String>(decodeSummary);
    }
    if (!nullToAbsent || decodeError != null) {
      map['decode_error'] = Variable<String>(decodeError);
    }
    if (!nullToAbsent || windSampleLabel != null) {
      map['wind_sample_label'] = Variable<String>(windSampleLabel);
    }
    return map;
  }

  GribImportCacheCompanion toCompanion(bool nullToAbsent) {
    return GribImportCacheCompanion(
      path: Value(path),
      importedAtMs: Value(importedAtMs),
      decodeSummary: decodeSummary == null && nullToAbsent
          ? const Value.absent()
          : Value(decodeSummary),
      decodeError: decodeError == null && nullToAbsent
          ? const Value.absent()
          : Value(decodeError),
      windSampleLabel: windSampleLabel == null && nullToAbsent
          ? const Value.absent()
          : Value(windSampleLabel),
    );
  }

  factory GribImportCacheRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GribImportCacheRow(
      path: serializer.fromJson<String>(json['path']),
      importedAtMs: serializer.fromJson<int>(json['importedAtMs']),
      decodeSummary: serializer.fromJson<String?>(json['decodeSummary']),
      decodeError: serializer.fromJson<String?>(json['decodeError']),
      windSampleLabel: serializer.fromJson<String?>(json['windSampleLabel']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'path': serializer.toJson<String>(path),
      'importedAtMs': serializer.toJson<int>(importedAtMs),
      'decodeSummary': serializer.toJson<String?>(decodeSummary),
      'decodeError': serializer.toJson<String?>(decodeError),
      'windSampleLabel': serializer.toJson<String?>(windSampleLabel),
    };
  }

  GribImportCacheRow copyWith({
    String? path,
    int? importedAtMs,
    Value<String?> decodeSummary = const Value.absent(),
    Value<String?> decodeError = const Value.absent(),
    Value<String?> windSampleLabel = const Value.absent(),
  }) => GribImportCacheRow(
    path: path ?? this.path,
    importedAtMs: importedAtMs ?? this.importedAtMs,
    decodeSummary: decodeSummary.present
        ? decodeSummary.value
        : this.decodeSummary,
    decodeError: decodeError.present ? decodeError.value : this.decodeError,
    windSampleLabel: windSampleLabel.present
        ? windSampleLabel.value
        : this.windSampleLabel,
  );
  GribImportCacheRow copyWithCompanion(GribImportCacheCompanion data) {
    return GribImportCacheRow(
      path: data.path.present ? data.path.value : this.path,
      importedAtMs: data.importedAtMs.present
          ? data.importedAtMs.value
          : this.importedAtMs,
      decodeSummary: data.decodeSummary.present
          ? data.decodeSummary.value
          : this.decodeSummary,
      decodeError: data.decodeError.present
          ? data.decodeError.value
          : this.decodeError,
      windSampleLabel: data.windSampleLabel.present
          ? data.windSampleLabel.value
          : this.windSampleLabel,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GribImportCacheRow(')
          ..write('path: $path, ')
          ..write('importedAtMs: $importedAtMs, ')
          ..write('decodeSummary: $decodeSummary, ')
          ..write('decodeError: $decodeError, ')
          ..write('windSampleLabel: $windSampleLabel')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    path,
    importedAtMs,
    decodeSummary,
    decodeError,
    windSampleLabel,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GribImportCacheRow &&
          other.path == this.path &&
          other.importedAtMs == this.importedAtMs &&
          other.decodeSummary == this.decodeSummary &&
          other.decodeError == this.decodeError &&
          other.windSampleLabel == this.windSampleLabel);
}

class GribImportCacheCompanion extends UpdateCompanion<GribImportCacheRow> {
  final Value<String> path;
  final Value<int> importedAtMs;
  final Value<String?> decodeSummary;
  final Value<String?> decodeError;
  final Value<String?> windSampleLabel;
  final Value<int> rowid;
  const GribImportCacheCompanion({
    this.path = const Value.absent(),
    this.importedAtMs = const Value.absent(),
    this.decodeSummary = const Value.absent(),
    this.decodeError = const Value.absent(),
    this.windSampleLabel = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GribImportCacheCompanion.insert({
    required String path,
    required int importedAtMs,
    this.decodeSummary = const Value.absent(),
    this.decodeError = const Value.absent(),
    this.windSampleLabel = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : path = Value(path),
       importedAtMs = Value(importedAtMs);
  static Insertable<GribImportCacheRow> custom({
    Expression<String>? path,
    Expression<int>? importedAtMs,
    Expression<String>? decodeSummary,
    Expression<String>? decodeError,
    Expression<String>? windSampleLabel,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (path != null) 'path': path,
      if (importedAtMs != null) 'imported_at_ms': importedAtMs,
      if (decodeSummary != null) 'decode_summary': decodeSummary,
      if (decodeError != null) 'decode_error': decodeError,
      if (windSampleLabel != null) 'wind_sample_label': windSampleLabel,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GribImportCacheCompanion copyWith({
    Value<String>? path,
    Value<int>? importedAtMs,
    Value<String?>? decodeSummary,
    Value<String?>? decodeError,
    Value<String?>? windSampleLabel,
    Value<int>? rowid,
  }) {
    return GribImportCacheCompanion(
      path: path ?? this.path,
      importedAtMs: importedAtMs ?? this.importedAtMs,
      decodeSummary: decodeSummary ?? this.decodeSummary,
      decodeError: decodeError ?? this.decodeError,
      windSampleLabel: windSampleLabel ?? this.windSampleLabel,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (path.present) {
      map['path'] = Variable<String>(path.value);
    }
    if (importedAtMs.present) {
      map['imported_at_ms'] = Variable<int>(importedAtMs.value);
    }
    if (decodeSummary.present) {
      map['decode_summary'] = Variable<String>(decodeSummary.value);
    }
    if (decodeError.present) {
      map['decode_error'] = Variable<String>(decodeError.value);
    }
    if (windSampleLabel.present) {
      map['wind_sample_label'] = Variable<String>(windSampleLabel.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GribImportCacheCompanion(')
          ..write('path: $path, ')
          ..write('importedAtMs: $importedAtMs, ')
          ..write('decodeSummary: $decodeSummary, ')
          ..write('decodeError: $decodeError, ')
          ..write('windSampleLabel: $windSampleLabel, ')
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
  late final $TidesCacheRowsTable tidesCacheRows = $TidesCacheRowsTable(this);
  late final $MooringPlacesTable mooringPlaces = $MooringPlacesTable(this);
  late final $MooringReviewDraftsTable mooringReviewDrafts =
      $MooringReviewDraftsTable(this);
  late final $LogbookEntriesTable logbookEntries = $LogbookEntriesTable(this);
  late final $TrackTripsTable trackTrips = $TrackTripsTable(this);
  late final $TrackPointsTable trackPoints = $TrackPointsTable(this);
  late final $ChecklistInstancesTable checklistInstances =
      $ChecklistInstancesTable(this);
  late final $VaultFilesTable vaultFiles = $VaultFilesTable(this);
  late final $ExpenseEntriesTable expenseEntries = $ExpenseEntriesTable(this);
  late final $VhfRecordingsTable vhfRecordings = $VhfRecordingsTable(this);
  late final $GribImportCacheTable gribImportCache = $GribImportCacheTable(
    this,
  );
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
    tidesCacheRows,
    mooringPlaces,
    mooringReviewDrafts,
    logbookEntries,
    trackTrips,
    trackPoints,
    checklistInstances,
    vaultFiles,
    expenseEntries,
    vhfRecordings,
    gribImportCache,
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
typedef $$TidesCacheRowsTableCreateCompanionBuilder =
    TidesCacheRowsCompanion Function({
      required String gridKey,
      required String tidesJson,
      required int fetchedAtMs,
      required int expiresAtMs,
      Value<int> rowid,
    });
typedef $$TidesCacheRowsTableUpdateCompanionBuilder =
    TidesCacheRowsCompanion Function({
      Value<String> gridKey,
      Value<String> tidesJson,
      Value<int> fetchedAtMs,
      Value<int> expiresAtMs,
      Value<int> rowid,
    });

class $$TidesCacheRowsTableFilterComposer
    extends Composer<_$AppDatabase, $TidesCacheRowsTable> {
  $$TidesCacheRowsTableFilterComposer({
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

  ColumnFilters<String> get tidesJson => $composableBuilder(
    column: $table.tidesJson,
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

class $$TidesCacheRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $TidesCacheRowsTable> {
  $$TidesCacheRowsTableOrderingComposer({
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

  ColumnOrderings<String> get tidesJson => $composableBuilder(
    column: $table.tidesJson,
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

class $$TidesCacheRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TidesCacheRowsTable> {
  $$TidesCacheRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get gridKey =>
      $composableBuilder(column: $table.gridKey, builder: (column) => column);

  GeneratedColumn<String> get tidesJson =>
      $composableBuilder(column: $table.tidesJson, builder: (column) => column);

  GeneratedColumn<int> get fetchedAtMs => $composableBuilder(
    column: $table.fetchedAtMs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get expiresAtMs => $composableBuilder(
    column: $table.expiresAtMs,
    builder: (column) => column,
  );
}

class $$TidesCacheRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TidesCacheRowsTable,
          TidesCacheRow,
          $$TidesCacheRowsTableFilterComposer,
          $$TidesCacheRowsTableOrderingComposer,
          $$TidesCacheRowsTableAnnotationComposer,
          $$TidesCacheRowsTableCreateCompanionBuilder,
          $$TidesCacheRowsTableUpdateCompanionBuilder,
          (
            TidesCacheRow,
            BaseReferences<_$AppDatabase, $TidesCacheRowsTable, TidesCacheRow>,
          ),
          TidesCacheRow,
          PrefetchHooks Function()
        > {
  $$TidesCacheRowsTableTableManager(
    _$AppDatabase db,
    $TidesCacheRowsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TidesCacheRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TidesCacheRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TidesCacheRowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> gridKey = const Value.absent(),
                Value<String> tidesJson = const Value.absent(),
                Value<int> fetchedAtMs = const Value.absent(),
                Value<int> expiresAtMs = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TidesCacheRowsCompanion(
                gridKey: gridKey,
                tidesJson: tidesJson,
                fetchedAtMs: fetchedAtMs,
                expiresAtMs: expiresAtMs,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String gridKey,
                required String tidesJson,
                required int fetchedAtMs,
                required int expiresAtMs,
                Value<int> rowid = const Value.absent(),
              }) => TidesCacheRowsCompanion.insert(
                gridKey: gridKey,
                tidesJson: tidesJson,
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

typedef $$TidesCacheRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TidesCacheRowsTable,
      TidesCacheRow,
      $$TidesCacheRowsTableFilterComposer,
      $$TidesCacheRowsTableOrderingComposer,
      $$TidesCacheRowsTableAnnotationComposer,
      $$TidesCacheRowsTableCreateCompanionBuilder,
      $$TidesCacheRowsTableUpdateCompanionBuilder,
      (
        TidesCacheRow,
        BaseReferences<_$AppDatabase, $TidesCacheRowsTable, TidesCacheRow>,
      ),
      TidesCacheRow,
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
      Value<String?> email,
      Value<String?> websiteUrl,
      Value<String?> bookingUrl,
      Value<String?> servicesJson,
      Value<String?> notes,
      Value<int?> sourceUpdatedAtMs,
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
      Value<String?> email,
      Value<String?> websiteUrl,
      Value<String?> bookingUrl,
      Value<String?> servicesJson,
      Value<String?> notes,
      Value<int?> sourceUpdatedAtMs,
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

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get websiteUrl => $composableBuilder(
    column: $table.websiteUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bookingUrl => $composableBuilder(
    column: $table.bookingUrl,
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

  ColumnFilters<int> get sourceUpdatedAtMs => $composableBuilder(
    column: $table.sourceUpdatedAtMs,
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

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get websiteUrl => $composableBuilder(
    column: $table.websiteUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bookingUrl => $composableBuilder(
    column: $table.bookingUrl,
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

  ColumnOrderings<int> get sourceUpdatedAtMs => $composableBuilder(
    column: $table.sourceUpdatedAtMs,
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

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get websiteUrl => $composableBuilder(
    column: $table.websiteUrl,
    builder: (column) => column,
  );

  GeneratedColumn<String> get bookingUrl => $composableBuilder(
    column: $table.bookingUrl,
    builder: (column) => column,
  );

  GeneratedColumn<String> get servicesJson => $composableBuilder(
    column: $table.servicesJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<int> get sourceUpdatedAtMs => $composableBuilder(
    column: $table.sourceUpdatedAtMs,
    builder: (column) => column,
  );
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
                Value<String?> email = const Value.absent(),
                Value<String?> websiteUrl = const Value.absent(),
                Value<String?> bookingUrl = const Value.absent(),
                Value<String?> servicesJson = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int?> sourceUpdatedAtMs = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MooringPlacesCompanion(
                id: id,
                kind: kind,
                name: name,
                lat: lat,
                lon: lon,
                vhf: vhf,
                phone: phone,
                email: email,
                websiteUrl: websiteUrl,
                bookingUrl: bookingUrl,
                servicesJson: servicesJson,
                notes: notes,
                sourceUpdatedAtMs: sourceUpdatedAtMs,
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
                Value<String?> email = const Value.absent(),
                Value<String?> websiteUrl = const Value.absent(),
                Value<String?> bookingUrl = const Value.absent(),
                Value<String?> servicesJson = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int?> sourceUpdatedAtMs = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MooringPlacesCompanion.insert(
                id: id,
                kind: kind,
                name: name,
                lat: lat,
                lon: lon,
                vhf: vhf,
                phone: phone,
                email: email,
                websiteUrl: websiteUrl,
                bookingUrl: bookingUrl,
                servicesJson: servicesJson,
                notes: notes,
                sourceUpdatedAtMs: sourceUpdatedAtMs,
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
typedef $$LogbookEntriesTableCreateCompanionBuilder =
    LogbookEntriesCompanion Function({
      required String id,
      required int t,
      required String category,
      required String payloadJson,
      Value<int> rowid,
    });
typedef $$LogbookEntriesTableUpdateCompanionBuilder =
    LogbookEntriesCompanion Function({
      Value<String> id,
      Value<int> t,
      Value<String> category,
      Value<String> payloadJson,
      Value<int> rowid,
    });

class $$LogbookEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $LogbookEntriesTable> {
  $$LogbookEntriesTableFilterComposer({
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

  ColumnFilters<int> get t => $composableBuilder(
    column: $table.t,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LogbookEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $LogbookEntriesTable> {
  $$LogbookEntriesTableOrderingComposer({
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

  ColumnOrderings<int> get t => $composableBuilder(
    column: $table.t,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LogbookEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $LogbookEntriesTable> {
  $$LogbookEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get t =>
      $composableBuilder(column: $table.t, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => column,
  );
}

class $$LogbookEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LogbookEntriesTable,
          LogbookEntryRow,
          $$LogbookEntriesTableFilterComposer,
          $$LogbookEntriesTableOrderingComposer,
          $$LogbookEntriesTableAnnotationComposer,
          $$LogbookEntriesTableCreateCompanionBuilder,
          $$LogbookEntriesTableUpdateCompanionBuilder,
          (
            LogbookEntryRow,
            BaseReferences<
              _$AppDatabase,
              $LogbookEntriesTable,
              LogbookEntryRow
            >,
          ),
          LogbookEntryRow,
          PrefetchHooks Function()
        > {
  $$LogbookEntriesTableTableManager(
    _$AppDatabase db,
    $LogbookEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LogbookEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LogbookEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LogbookEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> t = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String> payloadJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LogbookEntriesCompanion(
                id: id,
                t: t,
                category: category,
                payloadJson: payloadJson,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int t,
                required String category,
                required String payloadJson,
                Value<int> rowid = const Value.absent(),
              }) => LogbookEntriesCompanion.insert(
                id: id,
                t: t,
                category: category,
                payloadJson: payloadJson,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LogbookEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LogbookEntriesTable,
      LogbookEntryRow,
      $$LogbookEntriesTableFilterComposer,
      $$LogbookEntriesTableOrderingComposer,
      $$LogbookEntriesTableAnnotationComposer,
      $$LogbookEntriesTableCreateCompanionBuilder,
      $$LogbookEntriesTableUpdateCompanionBuilder,
      (
        LogbookEntryRow,
        BaseReferences<_$AppDatabase, $LogbookEntriesTable, LogbookEntryRow>,
      ),
      LogbookEntryRow,
      PrefetchHooks Function()
    >;
typedef $$TrackTripsTableCreateCompanionBuilder =
    TrackTripsCompanion Function({
      required String id,
      required int startedAtMs,
      Value<int?> endedAtMs,
      Value<int> rowid,
    });
typedef $$TrackTripsTableUpdateCompanionBuilder =
    TrackTripsCompanion Function({
      Value<String> id,
      Value<int> startedAtMs,
      Value<int?> endedAtMs,
      Value<int> rowid,
    });

class $$TrackTripsTableFilterComposer
    extends Composer<_$AppDatabase, $TrackTripsTable> {
  $$TrackTripsTableFilterComposer({
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

  ColumnFilters<int> get startedAtMs => $composableBuilder(
    column: $table.startedAtMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get endedAtMs => $composableBuilder(
    column: $table.endedAtMs,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TrackTripsTableOrderingComposer
    extends Composer<_$AppDatabase, $TrackTripsTable> {
  $$TrackTripsTableOrderingComposer({
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

  ColumnOrderings<int> get startedAtMs => $composableBuilder(
    column: $table.startedAtMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get endedAtMs => $composableBuilder(
    column: $table.endedAtMs,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TrackTripsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TrackTripsTable> {
  $$TrackTripsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get startedAtMs => $composableBuilder(
    column: $table.startedAtMs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get endedAtMs =>
      $composableBuilder(column: $table.endedAtMs, builder: (column) => column);
}

class $$TrackTripsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TrackTripsTable,
          TrackTripRow,
          $$TrackTripsTableFilterComposer,
          $$TrackTripsTableOrderingComposer,
          $$TrackTripsTableAnnotationComposer,
          $$TrackTripsTableCreateCompanionBuilder,
          $$TrackTripsTableUpdateCompanionBuilder,
          (
            TrackTripRow,
            BaseReferences<_$AppDatabase, $TrackTripsTable, TrackTripRow>,
          ),
          TrackTripRow,
          PrefetchHooks Function()
        > {
  $$TrackTripsTableTableManager(_$AppDatabase db, $TrackTripsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TrackTripsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TrackTripsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TrackTripsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> startedAtMs = const Value.absent(),
                Value<int?> endedAtMs = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TrackTripsCompanion(
                id: id,
                startedAtMs: startedAtMs,
                endedAtMs: endedAtMs,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int startedAtMs,
                Value<int?> endedAtMs = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TrackTripsCompanion.insert(
                id: id,
                startedAtMs: startedAtMs,
                endedAtMs: endedAtMs,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TrackTripsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TrackTripsTable,
      TrackTripRow,
      $$TrackTripsTableFilterComposer,
      $$TrackTripsTableOrderingComposer,
      $$TrackTripsTableAnnotationComposer,
      $$TrackTripsTableCreateCompanionBuilder,
      $$TrackTripsTableUpdateCompanionBuilder,
      (
        TrackTripRow,
        BaseReferences<_$AppDatabase, $TrackTripsTable, TrackTripRow>,
      ),
      TrackTripRow,
      PrefetchHooks Function()
    >;
typedef $$TrackPointsTableCreateCompanionBuilder =
    TrackPointsCompanion Function({
      Value<int> id,
      required String tripId,
      required int t,
      required double lat,
      required double lon,
      Value<double?> sog,
      Value<double?> cog,
    });
typedef $$TrackPointsTableUpdateCompanionBuilder =
    TrackPointsCompanion Function({
      Value<int> id,
      Value<String> tripId,
      Value<int> t,
      Value<double> lat,
      Value<double> lon,
      Value<double?> sog,
      Value<double?> cog,
    });

class $$TrackPointsTableFilterComposer
    extends Composer<_$AppDatabase, $TrackPointsTable> {
  $$TrackPointsTableFilterComposer({
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

  ColumnFilters<String> get tripId => $composableBuilder(
    column: $table.tripId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get t => $composableBuilder(
    column: $table.t,
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

  ColumnFilters<double> get sog => $composableBuilder(
    column: $table.sog,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get cog => $composableBuilder(
    column: $table.cog,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TrackPointsTableOrderingComposer
    extends Composer<_$AppDatabase, $TrackPointsTable> {
  $$TrackPointsTableOrderingComposer({
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

  ColumnOrderings<String> get tripId => $composableBuilder(
    column: $table.tripId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get t => $composableBuilder(
    column: $table.t,
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

  ColumnOrderings<double> get sog => $composableBuilder(
    column: $table.sog,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get cog => $composableBuilder(
    column: $table.cog,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TrackPointsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TrackPointsTable> {
  $$TrackPointsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get tripId =>
      $composableBuilder(column: $table.tripId, builder: (column) => column);

  GeneratedColumn<int> get t =>
      $composableBuilder(column: $table.t, builder: (column) => column);

  GeneratedColumn<double> get lat =>
      $composableBuilder(column: $table.lat, builder: (column) => column);

  GeneratedColumn<double> get lon =>
      $composableBuilder(column: $table.lon, builder: (column) => column);

  GeneratedColumn<double> get sog =>
      $composableBuilder(column: $table.sog, builder: (column) => column);

  GeneratedColumn<double> get cog =>
      $composableBuilder(column: $table.cog, builder: (column) => column);
}

class $$TrackPointsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TrackPointsTable,
          TrackPointRow,
          $$TrackPointsTableFilterComposer,
          $$TrackPointsTableOrderingComposer,
          $$TrackPointsTableAnnotationComposer,
          $$TrackPointsTableCreateCompanionBuilder,
          $$TrackPointsTableUpdateCompanionBuilder,
          (
            TrackPointRow,
            BaseReferences<_$AppDatabase, $TrackPointsTable, TrackPointRow>,
          ),
          TrackPointRow,
          PrefetchHooks Function()
        > {
  $$TrackPointsTableTableManager(_$AppDatabase db, $TrackPointsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TrackPointsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TrackPointsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TrackPointsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> tripId = const Value.absent(),
                Value<int> t = const Value.absent(),
                Value<double> lat = const Value.absent(),
                Value<double> lon = const Value.absent(),
                Value<double?> sog = const Value.absent(),
                Value<double?> cog = const Value.absent(),
              }) => TrackPointsCompanion(
                id: id,
                tripId: tripId,
                t: t,
                lat: lat,
                lon: lon,
                sog: sog,
                cog: cog,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String tripId,
                required int t,
                required double lat,
                required double lon,
                Value<double?> sog = const Value.absent(),
                Value<double?> cog = const Value.absent(),
              }) => TrackPointsCompanion.insert(
                id: id,
                tripId: tripId,
                t: t,
                lat: lat,
                lon: lon,
                sog: sog,
                cog: cog,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TrackPointsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TrackPointsTable,
      TrackPointRow,
      $$TrackPointsTableFilterComposer,
      $$TrackPointsTableOrderingComposer,
      $$TrackPointsTableAnnotationComposer,
      $$TrackPointsTableCreateCompanionBuilder,
      $$TrackPointsTableUpdateCompanionBuilder,
      (
        TrackPointRow,
        BaseReferences<_$AppDatabase, $TrackPointsTable, TrackPointRow>,
      ),
      TrackPointRow,
      PrefetchHooks Function()
    >;
typedef $$ChecklistInstancesTableCreateCompanionBuilder =
    ChecklistInstancesCompanion Function({
      required String id,
      required String templateKey,
      required String itemsJson,
      required int updatedAtMs,
      Value<bool> completed,
      Value<int> rowid,
    });
typedef $$ChecklistInstancesTableUpdateCompanionBuilder =
    ChecklistInstancesCompanion Function({
      Value<String> id,
      Value<String> templateKey,
      Value<String> itemsJson,
      Value<int> updatedAtMs,
      Value<bool> completed,
      Value<int> rowid,
    });

class $$ChecklistInstancesTableFilterComposer
    extends Composer<_$AppDatabase, $ChecklistInstancesTable> {
  $$ChecklistInstancesTableFilterComposer({
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

  ColumnFilters<String> get templateKey => $composableBuilder(
    column: $table.templateKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get itemsJson => $composableBuilder(
    column: $table.itemsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAtMs => $composableBuilder(
    column: $table.updatedAtMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get completed => $composableBuilder(
    column: $table.completed,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ChecklistInstancesTableOrderingComposer
    extends Composer<_$AppDatabase, $ChecklistInstancesTable> {
  $$ChecklistInstancesTableOrderingComposer({
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

  ColumnOrderings<String> get templateKey => $composableBuilder(
    column: $table.templateKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get itemsJson => $composableBuilder(
    column: $table.itemsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAtMs => $composableBuilder(
    column: $table.updatedAtMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get completed => $composableBuilder(
    column: $table.completed,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ChecklistInstancesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChecklistInstancesTable> {
  $$ChecklistInstancesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get templateKey => $composableBuilder(
    column: $table.templateKey,
    builder: (column) => column,
  );

  GeneratedColumn<String> get itemsJson =>
      $composableBuilder(column: $table.itemsJson, builder: (column) => column);

  GeneratedColumn<int> get updatedAtMs => $composableBuilder(
    column: $table.updatedAtMs,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get completed =>
      $composableBuilder(column: $table.completed, builder: (column) => column);
}

class $$ChecklistInstancesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ChecklistInstancesTable,
          ChecklistInstanceRow,
          $$ChecklistInstancesTableFilterComposer,
          $$ChecklistInstancesTableOrderingComposer,
          $$ChecklistInstancesTableAnnotationComposer,
          $$ChecklistInstancesTableCreateCompanionBuilder,
          $$ChecklistInstancesTableUpdateCompanionBuilder,
          (
            ChecklistInstanceRow,
            BaseReferences<
              _$AppDatabase,
              $ChecklistInstancesTable,
              ChecklistInstanceRow
            >,
          ),
          ChecklistInstanceRow,
          PrefetchHooks Function()
        > {
  $$ChecklistInstancesTableTableManager(
    _$AppDatabase db,
    $ChecklistInstancesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChecklistInstancesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChecklistInstancesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChecklistInstancesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> templateKey = const Value.absent(),
                Value<String> itemsJson = const Value.absent(),
                Value<int> updatedAtMs = const Value.absent(),
                Value<bool> completed = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChecklistInstancesCompanion(
                id: id,
                templateKey: templateKey,
                itemsJson: itemsJson,
                updatedAtMs: updatedAtMs,
                completed: completed,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String templateKey,
                required String itemsJson,
                required int updatedAtMs,
                Value<bool> completed = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChecklistInstancesCompanion.insert(
                id: id,
                templateKey: templateKey,
                itemsJson: itemsJson,
                updatedAtMs: updatedAtMs,
                completed: completed,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ChecklistInstancesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ChecklistInstancesTable,
      ChecklistInstanceRow,
      $$ChecklistInstancesTableFilterComposer,
      $$ChecklistInstancesTableOrderingComposer,
      $$ChecklistInstancesTableAnnotationComposer,
      $$ChecklistInstancesTableCreateCompanionBuilder,
      $$ChecklistInstancesTableUpdateCompanionBuilder,
      (
        ChecklistInstanceRow,
        BaseReferences<
          _$AppDatabase,
          $ChecklistInstancesTable,
          ChecklistInstanceRow
        >,
      ),
      ChecklistInstanceRow,
      PrefetchHooks Function()
    >;
typedef $$VaultFilesTableCreateCompanionBuilder =
    VaultFilesCompanion Function({
      required String id,
      required String displayName,
      required String cipherPayloadBase64,
      required int plainSizeBytes,
      required int createdAtMs,
      Value<int> rowid,
    });
typedef $$VaultFilesTableUpdateCompanionBuilder =
    VaultFilesCompanion Function({
      Value<String> id,
      Value<String> displayName,
      Value<String> cipherPayloadBase64,
      Value<int> plainSizeBytes,
      Value<int> createdAtMs,
      Value<int> rowid,
    });

class $$VaultFilesTableFilterComposer
    extends Composer<_$AppDatabase, $VaultFilesTable> {
  $$VaultFilesTableFilterComposer({
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

  ColumnFilters<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cipherPayloadBase64 => $composableBuilder(
    column: $table.cipherPayloadBase64,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get plainSizeBytes => $composableBuilder(
    column: $table.plainSizeBytes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAtMs => $composableBuilder(
    column: $table.createdAtMs,
    builder: (column) => ColumnFilters(column),
  );
}

class $$VaultFilesTableOrderingComposer
    extends Composer<_$AppDatabase, $VaultFilesTable> {
  $$VaultFilesTableOrderingComposer({
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

  ColumnOrderings<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cipherPayloadBase64 => $composableBuilder(
    column: $table.cipherPayloadBase64,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get plainSizeBytes => $composableBuilder(
    column: $table.plainSizeBytes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAtMs => $composableBuilder(
    column: $table.createdAtMs,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$VaultFilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $VaultFilesTable> {
  $$VaultFilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get cipherPayloadBase64 => $composableBuilder(
    column: $table.cipherPayloadBase64,
    builder: (column) => column,
  );

  GeneratedColumn<int> get plainSizeBytes => $composableBuilder(
    column: $table.plainSizeBytes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get createdAtMs => $composableBuilder(
    column: $table.createdAtMs,
    builder: (column) => column,
  );
}

class $$VaultFilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $VaultFilesTable,
          VaultFileRow,
          $$VaultFilesTableFilterComposer,
          $$VaultFilesTableOrderingComposer,
          $$VaultFilesTableAnnotationComposer,
          $$VaultFilesTableCreateCompanionBuilder,
          $$VaultFilesTableUpdateCompanionBuilder,
          (
            VaultFileRow,
            BaseReferences<_$AppDatabase, $VaultFilesTable, VaultFileRow>,
          ),
          VaultFileRow,
          PrefetchHooks Function()
        > {
  $$VaultFilesTableTableManager(_$AppDatabase db, $VaultFilesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VaultFilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VaultFilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VaultFilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> displayName = const Value.absent(),
                Value<String> cipherPayloadBase64 = const Value.absent(),
                Value<int> plainSizeBytes = const Value.absent(),
                Value<int> createdAtMs = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => VaultFilesCompanion(
                id: id,
                displayName: displayName,
                cipherPayloadBase64: cipherPayloadBase64,
                plainSizeBytes: plainSizeBytes,
                createdAtMs: createdAtMs,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String displayName,
                required String cipherPayloadBase64,
                required int plainSizeBytes,
                required int createdAtMs,
                Value<int> rowid = const Value.absent(),
              }) => VaultFilesCompanion.insert(
                id: id,
                displayName: displayName,
                cipherPayloadBase64: cipherPayloadBase64,
                plainSizeBytes: plainSizeBytes,
                createdAtMs: createdAtMs,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$VaultFilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $VaultFilesTable,
      VaultFileRow,
      $$VaultFilesTableFilterComposer,
      $$VaultFilesTableOrderingComposer,
      $$VaultFilesTableAnnotationComposer,
      $$VaultFilesTableCreateCompanionBuilder,
      $$VaultFilesTableUpdateCompanionBuilder,
      (
        VaultFileRow,
        BaseReferences<_$AppDatabase, $VaultFilesTable, VaultFileRow>,
      ),
      VaultFileRow,
      PrefetchHooks Function()
    >;
typedef $$ExpenseEntriesTableCreateCompanionBuilder =
    ExpenseEntriesCompanion Function({
      required String id,
      required int t,
      required String category,
      required int amountMinor,
      Value<String> currency,
      Value<String?> note,
      Value<int> rowid,
    });
typedef $$ExpenseEntriesTableUpdateCompanionBuilder =
    ExpenseEntriesCompanion Function({
      Value<String> id,
      Value<int> t,
      Value<String> category,
      Value<int> amountMinor,
      Value<String> currency,
      Value<String?> note,
      Value<int> rowid,
    });

class $$ExpenseEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $ExpenseEntriesTable> {
  $$ExpenseEntriesTableFilterComposer({
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

  ColumnFilters<int> get t => $composableBuilder(
    column: $table.t,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountMinor => $composableBuilder(
    column: $table.amountMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ExpenseEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $ExpenseEntriesTable> {
  $$ExpenseEntriesTableOrderingComposer({
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

  ColumnOrderings<int> get t => $composableBuilder(
    column: $table.t,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountMinor => $composableBuilder(
    column: $table.amountMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ExpenseEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExpenseEntriesTable> {
  $$ExpenseEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get t =>
      $composableBuilder(column: $table.t, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<int> get amountMinor => $composableBuilder(
    column: $table.amountMinor,
    builder: (column) => column,
  );

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);
}

class $$ExpenseEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExpenseEntriesTable,
          ExpenseEntryRow,
          $$ExpenseEntriesTableFilterComposer,
          $$ExpenseEntriesTableOrderingComposer,
          $$ExpenseEntriesTableAnnotationComposer,
          $$ExpenseEntriesTableCreateCompanionBuilder,
          $$ExpenseEntriesTableUpdateCompanionBuilder,
          (
            ExpenseEntryRow,
            BaseReferences<
              _$AppDatabase,
              $ExpenseEntriesTable,
              ExpenseEntryRow
            >,
          ),
          ExpenseEntryRow,
          PrefetchHooks Function()
        > {
  $$ExpenseEntriesTableTableManager(
    _$AppDatabase db,
    $ExpenseEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExpenseEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExpenseEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExpenseEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> t = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<int> amountMinor = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ExpenseEntriesCompanion(
                id: id,
                t: t,
                category: category,
                amountMinor: amountMinor,
                currency: currency,
                note: note,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int t,
                required String category,
                required int amountMinor,
                Value<String> currency = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ExpenseEntriesCompanion.insert(
                id: id,
                t: t,
                category: category,
                amountMinor: amountMinor,
                currency: currency,
                note: note,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ExpenseEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExpenseEntriesTable,
      ExpenseEntryRow,
      $$ExpenseEntriesTableFilterComposer,
      $$ExpenseEntriesTableOrderingComposer,
      $$ExpenseEntriesTableAnnotationComposer,
      $$ExpenseEntriesTableCreateCompanionBuilder,
      $$ExpenseEntriesTableUpdateCompanionBuilder,
      (
        ExpenseEntryRow,
        BaseReferences<_$AppDatabase, $ExpenseEntriesTable, ExpenseEntryRow>,
      ),
      ExpenseEntryRow,
      PrefetchHooks Function()
    >;
typedef $$VhfRecordingsTableCreateCompanionBuilder =
    VhfRecordingsCompanion Function({
      required String id,
      required int t,
      required String path,
      Value<String?> transcript,
      Value<int?> durationMs,
      Value<int> rowid,
    });
typedef $$VhfRecordingsTableUpdateCompanionBuilder =
    VhfRecordingsCompanion Function({
      Value<String> id,
      Value<int> t,
      Value<String> path,
      Value<String?> transcript,
      Value<int?> durationMs,
      Value<int> rowid,
    });

class $$VhfRecordingsTableFilterComposer
    extends Composer<_$AppDatabase, $VhfRecordingsTable> {
  $$VhfRecordingsTableFilterComposer({
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

  ColumnFilters<int> get t => $composableBuilder(
    column: $table.t,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get path => $composableBuilder(
    column: $table.path,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get transcript => $composableBuilder(
    column: $table.transcript,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => ColumnFilters(column),
  );
}

class $$VhfRecordingsTableOrderingComposer
    extends Composer<_$AppDatabase, $VhfRecordingsTable> {
  $$VhfRecordingsTableOrderingComposer({
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

  ColumnOrderings<int> get t => $composableBuilder(
    column: $table.t,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get path => $composableBuilder(
    column: $table.path,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get transcript => $composableBuilder(
    column: $table.transcript,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$VhfRecordingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $VhfRecordingsTable> {
  $$VhfRecordingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get t =>
      $composableBuilder(column: $table.t, builder: (column) => column);

  GeneratedColumn<String> get path =>
      $composableBuilder(column: $table.path, builder: (column) => column);

  GeneratedColumn<String> get transcript => $composableBuilder(
    column: $table.transcript,
    builder: (column) => column,
  );

  GeneratedColumn<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => column,
  );
}

class $$VhfRecordingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $VhfRecordingsTable,
          VhfRecordingRow,
          $$VhfRecordingsTableFilterComposer,
          $$VhfRecordingsTableOrderingComposer,
          $$VhfRecordingsTableAnnotationComposer,
          $$VhfRecordingsTableCreateCompanionBuilder,
          $$VhfRecordingsTableUpdateCompanionBuilder,
          (
            VhfRecordingRow,
            BaseReferences<_$AppDatabase, $VhfRecordingsTable, VhfRecordingRow>,
          ),
          VhfRecordingRow,
          PrefetchHooks Function()
        > {
  $$VhfRecordingsTableTableManager(_$AppDatabase db, $VhfRecordingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VhfRecordingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VhfRecordingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VhfRecordingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> t = const Value.absent(),
                Value<String> path = const Value.absent(),
                Value<String?> transcript = const Value.absent(),
                Value<int?> durationMs = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => VhfRecordingsCompanion(
                id: id,
                t: t,
                path: path,
                transcript: transcript,
                durationMs: durationMs,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int t,
                required String path,
                Value<String?> transcript = const Value.absent(),
                Value<int?> durationMs = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => VhfRecordingsCompanion.insert(
                id: id,
                t: t,
                path: path,
                transcript: transcript,
                durationMs: durationMs,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$VhfRecordingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $VhfRecordingsTable,
      VhfRecordingRow,
      $$VhfRecordingsTableFilterComposer,
      $$VhfRecordingsTableOrderingComposer,
      $$VhfRecordingsTableAnnotationComposer,
      $$VhfRecordingsTableCreateCompanionBuilder,
      $$VhfRecordingsTableUpdateCompanionBuilder,
      (
        VhfRecordingRow,
        BaseReferences<_$AppDatabase, $VhfRecordingsTable, VhfRecordingRow>,
      ),
      VhfRecordingRow,
      PrefetchHooks Function()
    >;
typedef $$GribImportCacheTableCreateCompanionBuilder =
    GribImportCacheCompanion Function({
      required String path,
      required int importedAtMs,
      Value<String?> decodeSummary,
      Value<String?> decodeError,
      Value<String?> windSampleLabel,
      Value<int> rowid,
    });
typedef $$GribImportCacheTableUpdateCompanionBuilder =
    GribImportCacheCompanion Function({
      Value<String> path,
      Value<int> importedAtMs,
      Value<String?> decodeSummary,
      Value<String?> decodeError,
      Value<String?> windSampleLabel,
      Value<int> rowid,
    });

class $$GribImportCacheTableFilterComposer
    extends Composer<_$AppDatabase, $GribImportCacheTable> {
  $$GribImportCacheTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get path => $composableBuilder(
    column: $table.path,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get importedAtMs => $composableBuilder(
    column: $table.importedAtMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get decodeSummary => $composableBuilder(
    column: $table.decodeSummary,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get decodeError => $composableBuilder(
    column: $table.decodeError,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get windSampleLabel => $composableBuilder(
    column: $table.windSampleLabel,
    builder: (column) => ColumnFilters(column),
  );
}

class $$GribImportCacheTableOrderingComposer
    extends Composer<_$AppDatabase, $GribImportCacheTable> {
  $$GribImportCacheTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get path => $composableBuilder(
    column: $table.path,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get importedAtMs => $composableBuilder(
    column: $table.importedAtMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get decodeSummary => $composableBuilder(
    column: $table.decodeSummary,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get decodeError => $composableBuilder(
    column: $table.decodeError,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get windSampleLabel => $composableBuilder(
    column: $table.windSampleLabel,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$GribImportCacheTableAnnotationComposer
    extends Composer<_$AppDatabase, $GribImportCacheTable> {
  $$GribImportCacheTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get path =>
      $composableBuilder(column: $table.path, builder: (column) => column);

  GeneratedColumn<int> get importedAtMs => $composableBuilder(
    column: $table.importedAtMs,
    builder: (column) => column,
  );

  GeneratedColumn<String> get decodeSummary => $composableBuilder(
    column: $table.decodeSummary,
    builder: (column) => column,
  );

  GeneratedColumn<String> get decodeError => $composableBuilder(
    column: $table.decodeError,
    builder: (column) => column,
  );

  GeneratedColumn<String> get windSampleLabel => $composableBuilder(
    column: $table.windSampleLabel,
    builder: (column) => column,
  );
}

class $$GribImportCacheTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GribImportCacheTable,
          GribImportCacheRow,
          $$GribImportCacheTableFilterComposer,
          $$GribImportCacheTableOrderingComposer,
          $$GribImportCacheTableAnnotationComposer,
          $$GribImportCacheTableCreateCompanionBuilder,
          $$GribImportCacheTableUpdateCompanionBuilder,
          (
            GribImportCacheRow,
            BaseReferences<
              _$AppDatabase,
              $GribImportCacheTable,
              GribImportCacheRow
            >,
          ),
          GribImportCacheRow,
          PrefetchHooks Function()
        > {
  $$GribImportCacheTableTableManager(
    _$AppDatabase db,
    $GribImportCacheTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GribImportCacheTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GribImportCacheTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GribImportCacheTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> path = const Value.absent(),
                Value<int> importedAtMs = const Value.absent(),
                Value<String?> decodeSummary = const Value.absent(),
                Value<String?> decodeError = const Value.absent(),
                Value<String?> windSampleLabel = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GribImportCacheCompanion(
                path: path,
                importedAtMs: importedAtMs,
                decodeSummary: decodeSummary,
                decodeError: decodeError,
                windSampleLabel: windSampleLabel,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String path,
                required int importedAtMs,
                Value<String?> decodeSummary = const Value.absent(),
                Value<String?> decodeError = const Value.absent(),
                Value<String?> windSampleLabel = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GribImportCacheCompanion.insert(
                path: path,
                importedAtMs: importedAtMs,
                decodeSummary: decodeSummary,
                decodeError: decodeError,
                windSampleLabel: windSampleLabel,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$GribImportCacheTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GribImportCacheTable,
      GribImportCacheRow,
      $$GribImportCacheTableFilterComposer,
      $$GribImportCacheTableOrderingComposer,
      $$GribImportCacheTableAnnotationComposer,
      $$GribImportCacheTableCreateCompanionBuilder,
      $$GribImportCacheTableUpdateCompanionBuilder,
      (
        GribImportCacheRow,
        BaseReferences<
          _$AppDatabase,
          $GribImportCacheTable,
          GribImportCacheRow
        >,
      ),
      GribImportCacheRow,
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
  $$TidesCacheRowsTableTableManager get tidesCacheRows =>
      $$TidesCacheRowsTableTableManager(_db, _db.tidesCacheRows);
  $$MooringPlacesTableTableManager get mooringPlaces =>
      $$MooringPlacesTableTableManager(_db, _db.mooringPlaces);
  $$MooringReviewDraftsTableTableManager get mooringReviewDrafts =>
      $$MooringReviewDraftsTableTableManager(_db, _db.mooringReviewDrafts);
  $$LogbookEntriesTableTableManager get logbookEntries =>
      $$LogbookEntriesTableTableManager(_db, _db.logbookEntries);
  $$TrackTripsTableTableManager get trackTrips =>
      $$TrackTripsTableTableManager(_db, _db.trackTrips);
  $$TrackPointsTableTableManager get trackPoints =>
      $$TrackPointsTableTableManager(_db, _db.trackPoints);
  $$ChecklistInstancesTableTableManager get checklistInstances =>
      $$ChecklistInstancesTableTableManager(_db, _db.checklistInstances);
  $$VaultFilesTableTableManager get vaultFiles =>
      $$VaultFilesTableTableManager(_db, _db.vaultFiles);
  $$ExpenseEntriesTableTableManager get expenseEntries =>
      $$ExpenseEntriesTableTableManager(_db, _db.expenseEntries);
  $$VhfRecordingsTableTableManager get vhfRecordings =>
      $$VhfRecordingsTableTableManager(_db, _db.vhfRecordings);
  $$GribImportCacheTableTableManager get gribImportCache =>
      $$GribImportCacheTableTableManager(_db, _db.gribImportCache);
}
