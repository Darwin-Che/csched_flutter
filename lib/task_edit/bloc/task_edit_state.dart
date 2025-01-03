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
    required this.targetEffort,
    this.description = '',
  });

  final TaskEditStatus status;
  final TaskModel? initialTask;
  final String name;
  final int targetEffort;
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
      targetEffort: priority ?? this.targetEffort,
      description: description ?? this.description,
    );
  }

  @override
  List<Object?> get props => [status, initialTask, name, targetEffort, description];
}