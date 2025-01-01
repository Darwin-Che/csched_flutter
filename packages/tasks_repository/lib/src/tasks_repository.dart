import 'package:tasks_api/tasks_api.dart';

class TasksRepository {
  const TasksRepository({
    required TasksApi tasksApi,
  }) : _tasksApi = tasksApi;

  final TasksApi _tasksApi;

  Future<void> reset() => _tasksApi.reset();

  Stream<List<TaskModel>> getTaskModelsStream() => _tasksApi.getTaskModelsStream();

  List<TaskModel> getTaskModels() => _tasksApi.getTaskModels();

  Future<void> saveTaskModel(TaskModel taskModel) => _tasksApi.saveTaskModel(taskModel);

  Future<void> deleteTaskModel(String id) => _tasksApi.deleteTaskModel(id);

  Stream<ProgressModel?> getLatestProgressModel() => _tasksApi.getLatestProgressModel();

  Future<void> editLatestProgressModel(ProgressModel progressModel) => _tasksApi.editLatestProgressModel(progressModel);

  Future<void> addNewProgressModel(ProgressModel progressModel) => _tasksApi.addNewProgressModel(progressModel);

  Future<Map<String, double>> getTasksEffort() => _tasksApi.getTasksEffort();
}
