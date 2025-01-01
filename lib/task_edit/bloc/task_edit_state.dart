part of 'task_edit_bloc.dart';

enum TaskEditStatus { initial, loading, success, failure }

extension TaskEditStatusX on TaskEditStatus {
  bool get isLoadingOrSuccess => [
        TaskEditStatus.loading,
        TaskEditStatus.success,
      ].contains(this);
}

final class TaskEditState extends Equatable {
  const TaskEditState({
    this.status = TaskEditStatus.initial,
    this.initialTask,
    required this.name,
    required this.priority,
    this.description = '',
  });

  final TaskEditStatus status;
  final TaskModel? initialTask;
  final String name;
  final int priority;
  final String description;

  bool get isNewTask => initialTask == null;

  TaskEditState copyWith({
    TaskEditStatus? status,
    TaskModel? initialTask,
    String? name,
    int? priority,
    String? description,
  }) {
    return TaskEditState(
      status: status ?? this.status,
      initialTask: initialTask ?? this.initialTask,
      name: name ?? this.name,
      priority: priority ?? this.priority,
      description: description ?? this.description,
    );
  }

  @override
  List<Object?> get props => [status, initialTask, name, priority, description];
}