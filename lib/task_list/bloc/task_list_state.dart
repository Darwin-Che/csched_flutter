part of 'task_list_bloc.dart';

enum TaskListStatus { initial, loading, success, failure }

final class TaskListState extends Equatable {
  const TaskListState({
    this.status = TaskListStatus.initial,
    this.tasks = const [],
  });

  final TaskListStatus status;
  final List<TaskModel> tasks;

  TaskListState copyWith({
    TaskListStatus Function()? status,
    List<TaskModel> Function()? tasks,
  }) {
    return TaskListState(
      status: status != null ? status() : this.status,
      tasks: tasks != null ? tasks() : this.tasks,
    );
  }

  @override
  List<Object?> get props => [
        status,
        tasks,
      ];
}