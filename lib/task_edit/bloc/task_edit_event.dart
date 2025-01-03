part of 'task_edit_bloc.dart';

sealed class TaskEditEvent extends Equatable {
  const TaskEditEvent();

  @override
  List<Object> get props => [];
}

final class TaskEditTaskNameChanged extends TaskEditEvent {
  const TaskEditTaskNameChanged(this.name);

  final String name;

  @override
  List<Object> get props => [name];
}

final class TaskEditTargetEffortChanged extends TaskEditEvent {
  const TaskEditTargetEffortChanged(this.targetEffort);

  final int targetEffort;

  @override
  List<Object> get props => [targetEffort];
}

final class TaskEditDescriptionChanged extends TaskEditEvent {
  const TaskEditDescriptionChanged(this.description);

  final String description;

  @override
  List<Object> get props => [description];
}

final class TaskEditSubmitted extends TaskEditEvent {
  const TaskEditSubmitted();
}