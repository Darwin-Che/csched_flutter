import 'package:tasks_api/src/models/progress_model.dart';
import 'package:tasks_api/src/models/task_model.dart';

abstract class TasksApi {
  const TasksApi();

  Future<void> reset();

  Stream<List<TaskModel>> getTaskModelsStream();

  List<TaskModel> getTaskModels();

  Future<void> saveTaskModel(TaskModel taskModel);

  Future<void> deleteTaskModel(String id);

  Stream<ProgressModel?> getLatestProgressModel();

  Future<void> editLatestProgressModel(ProgressModel progressModel);

  Future<void> addNewProgressModel(ProgressModel progressModel);

  Future<void> close();

  Future<Map<String, double>> getTasksEffort();
}

class TaskNotFoundException implements Exception {}
