// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i7;
import 'package:csched_flutter/main_page.dart' as _i1;
import 'package:csched_flutter/now/now.dart' as _i2;
import 'package:csched_flutter/switch/switch.dart' as _i4;
import 'package:csched_flutter/tabs/settings.dart' as _i3;
import 'package:csched_flutter/task_edit/task_edit.dart' as _i5;
import 'package:csched_flutter/task_list/task_list.dart' as _i6;
import 'package:flutter/material.dart' as _i8;
import 'package:tasks_repository/tasks_repository.dart' as _i9;

/// generated route for
/// [_i1.MainPage]
class MainRoute extends _i7.PageRouteInfo<void> {
  const MainRoute({List<_i7.PageRouteInfo>? children})
      : super(
          MainRoute.name,
          initialChildren: children,
        );

  static const String name = 'MainRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i1.MainPage();
    },
  );
}

/// generated route for
/// [_i2.NowPage]
class NowRoute extends _i7.PageRouteInfo<void> {
  const NowRoute({List<_i7.PageRouteInfo>? children})
      : super(
          NowRoute.name,
          initialChildren: children,
        );

  static const String name = 'NowRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i2.NowPage();
    },
  );
}

/// generated route for
/// [_i2.NowPageWrapper]
class NowRouteWrapper extends _i7.PageRouteInfo<void> {
  const NowRouteWrapper({List<_i7.PageRouteInfo>? children})
      : super(
          NowRouteWrapper.name,
          initialChildren: children,
        );

  static const String name = 'NowRouteWrapper';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i2.NowPageWrapper();
    },
  );
}

/// generated route for
/// [_i2.NowView]
class NowView extends _i7.PageRouteInfo<void> {
  const NowView({List<_i7.PageRouteInfo>? children})
      : super(
          NowView.name,
          initialChildren: children,
        );

  static const String name = 'NowView';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i2.NowView();
    },
  );
}

/// generated route for
/// [_i3.SettingsPage]
class SettingsRoute extends _i7.PageRouteInfo<SettingsRouteArgs> {
  SettingsRoute({
    _i8.Key? key,
    List<_i7.PageRouteInfo>? children,
  }) : super(
          SettingsRoute.name,
          args: SettingsRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'SettingsRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SettingsRouteArgs>(
          orElse: () => const SettingsRouteArgs());
      return _i3.SettingsPage(key: args.key);
    },
  );
}

class SettingsRouteArgs {
  const SettingsRouteArgs({this.key});

  final _i8.Key? key;

  @override
  String toString() {
    return 'SettingsRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i4.SwitchPage]
class SwitchRoute extends _i7.PageRouteInfo<void> {
  const SwitchRoute({List<_i7.PageRouteInfo>? children})
      : super(
          SwitchRoute.name,
          initialChildren: children,
        );

  static const String name = 'SwitchRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i4.SwitchPage();
    },
  );
}

/// generated route for
/// [_i4.SwitchView]
class SwitchView extends _i7.PageRouteInfo<SwitchViewArgs> {
  SwitchView({
    _i8.Key? key,
    List<_i7.PageRouteInfo>? children,
  }) : super(
          SwitchView.name,
          args: SwitchViewArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'SwitchView';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      final args =
          data.argsAs<SwitchViewArgs>(orElse: () => const SwitchViewArgs());
      return _i4.SwitchView(key: args.key);
    },
  );
}

class SwitchViewArgs {
  const SwitchViewArgs({this.key});

  final _i8.Key? key;

  @override
  String toString() {
    return 'SwitchViewArgs{key: $key}';
  }
}

/// generated route for
/// [_i5.TaskEditPage]
class TaskEditRoute extends _i7.PageRouteInfo<TaskEditRouteArgs> {
  TaskEditRoute({
    _i9.TaskModel? initialTask,
    _i8.Key? key,
    List<_i7.PageRouteInfo>? children,
  }) : super(
          TaskEditRoute.name,
          args: TaskEditRouteArgs(
            initialTask: initialTask,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'TaskEditRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<TaskEditRouteArgs>(
          orElse: () => const TaskEditRouteArgs());
      return _i5.TaskEditPage(
        initialTask: args.initialTask,
        key: args.key,
      );
    },
  );
}

class TaskEditRouteArgs {
  const TaskEditRouteArgs({
    this.initialTask,
    this.key,
  });

  final _i9.TaskModel? initialTask;

  final _i8.Key? key;

  @override
  String toString() {
    return 'TaskEditRouteArgs{initialTask: $initialTask, key: $key}';
  }
}

/// generated route for
/// [_i6.TaskListPage]
class TaskListRoute extends _i7.PageRouteInfo<void> {
  const TaskListRoute({List<_i7.PageRouteInfo>? children})
      : super(
          TaskListRoute.name,
          initialChildren: children,
        );

  static const String name = 'TaskListRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i6.TaskListPage();
    },
  );
}

/// generated route for
/// [_i6.TaskListView]
class TaskListView extends _i7.PageRouteInfo<void> {
  const TaskListView({List<_i7.PageRouteInfo>? children})
      : super(
          TaskListView.name,
          initialChildren: children,
        );

  static const String name = 'TaskListView';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i6.TaskListView();
    },
  );
}

/// generated route for
/// [_i6.TaskRouteWrapper]
class TaskRouteWrapper extends _i7.PageRouteInfo<void> {
  const TaskRouteWrapper({List<_i7.PageRouteInfo>? children})
      : super(
          TaskRouteWrapper.name,
          initialChildren: children,
        );

  static const String name = 'TaskRouteWrapper';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i6.TaskRouteWrapper();
    },
  );
}
