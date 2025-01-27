import 'dart:async';
import 'dart:math';

import 'package:local_storage_tasks_api/src/database_provider.dart';
import 'package:rxdart/rxdart.dart';

import 'package:tasks_api/tasks_api.dart';

class LocalStorageTasksApi extends TasksApi {
  final databaseProvider = DatabaseProvider.dbProvider;

  LocalStorageTasksApi._create();

  static Future<LocalStorageTasksApi> create() async {
    final taskApi = LocalStorageTasksApi._create();
    await taskApi._init();
    return taskApi;
  }

  late final _taskStreamController = BehaviorSubject<List<TaskModel>>.seeded(
    const [],
  );

  late final _latestProgressStreamController =
      BehaviorSubject<ProgressModel?>.seeded(
    null,
  );

  Future<void> _init() async {
    final db = await databaseProvider.db;

    final tasksJson = await db.query('task');
    final tasks = tasksJson.map(TaskModel.fromJson).toList();

    _taskStreamController.add(tasks);

    final lastestProgressJson =
        await db.query('progress', orderBy: 'startDm DESC', limit: 1);
    final lastestProgress = lastestProgressJson.isNotEmpty
        ? ProgressModel.fromJson(lastestProgressJson[0])
        : null;

    _latestProgressStreamController.add(lastestProgress);
  }

  @override
  Future<void> reset() async {
    await databaseProvider.deleteDatabaseFile();
    await databaseProvider.createDatabase();

    await _init();
  }

  @override
  Stream<List<TaskModel>> getTaskModelsStream() {
    return _taskStreamController.asBroadcastStream();
  }

  @override
  List<TaskModel> getTaskModels() {
    return _taskStreamController.value;
  }

  @override
  TaskModel findTaskModel(String id) {
    return _taskStreamController.value
        .firstWhere((taskModel) => taskModel.id == id);
  }

  @override
  Future<void> saveTaskModel(TaskModel taskModel) async {
    final db = await databaseProvider.db;
    final tasks = [..._taskStreamController.value];
    final index = tasks.indexWhere((t) => t.id == taskModel.id);

    if (index >= 0) {
      tasks[index] = taskModel;
      await db.update(
        'task',
        taskModel.toJson(),
        where: 'id = ?',
        whereArgs: [taskModel.id],
      );
    } else {
      tasks.add(taskModel);
      await db.insert('task', taskModel.toJson());
    }

    _taskStreamController.add(tasks);
  }

  @override
  Future<void> deleteTaskModel(String id) async {
    final db = await databaseProvider.db;

    final tasks = [..._taskStreamController.value];
    final index = tasks.indexWhere((t) => t.id == id);

    if (index == -1) {
      throw TaskNotFoundException();
    } else {
      tasks.removeAt(index);
      _taskStreamController.add(tasks);

      await db.delete('task', where: 'id = ?', whereArgs: [id]);
    }
  }

  @override
  Stream<ProgressModel?> getLatestProgressModelStream() {
    return _latestProgressStreamController.asBroadcastStream();
  }

  @override
  ProgressModel? getLatestProgressModel() {
    return _latestProgressStreamController.value;
  }

  @override
  Future<void> editLatestProgressModel(ProgressModel progressModel) async {
    final db = await databaseProvider.db;
    final progress = _latestProgressStreamController.value;

    if (progress == null || progress.id != progressModel.id) {
      throw FormatException('editLatestProgressModel $progress $progressModel');
    }

    await db.update(
      'progress',
      progressModel.toJson(),
      where: 'id = ?',
      whereArgs: [progressModel.id],
    );

    _latestProgressStreamController.add(progressModel);
  }

  @override
  Future<void> addNewProgressModel(ProgressModel progressModel) async {
    final db = await databaseProvider.db;
    final progress = _latestProgressStreamController.value;

    if (progress != null &&
        (progress.startDm > progressModel.endDm)) {
      throw FormatException('addNewProgressModel $progress $progressModel');
    }

    await db.insert('progress', progressModel.toJson());

    _latestProgressStreamController.add(progressModel);
  }

  @override
  Future<void> close() {
    return _taskStreamController.close();
  }

  @override
  Future<Map<String, double>> getTasksEffort() async {
    final db = await databaseProvider.db;

    final progressesJson = await db.query('progress', orderBy: 'startDm DESC');
    final progresses = progressesJson.map(ProgressModel.fromJson).toList();

    Map<String, double> tasksEffort = {};

    final curDm = DateTime.now().millisecondsSinceEpoch ~/ 60000;

    // The algorithm would be to have each week's progress decrease by half
    for (final progress in progresses) {
      // check how many weeks are between the task and current time
      final weeks = (curDm - progress.endDm) ~/ (24 * 60 * 7);
      final multiplier = pow(2.0, weeks).toDouble();

      tasksEffort[progress.taskId] =
          (tasksEffort[progress.taskId] ?? 0) + progress.duration * multiplier;
    }

    return tasksEffort;
  }
}
