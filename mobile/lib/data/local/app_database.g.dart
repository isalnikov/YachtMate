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

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UserActionAuditsTable userActionAudits = $UserActionAuditsTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [userActionAudits];
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

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UserActionAuditsTableTableManager get userActionAudits =>
      $$UserActionAuditsTableTableManager(_db, _db.userActionAudits);
}
