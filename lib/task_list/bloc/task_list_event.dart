part of 'task_list_bloc.dart';

sealed class TaskListEvent extends Equatable {
  const TaskListEvent();

  @override
  List<Object> get props => [];
}

final class TaskListSubscriptionRequested extends TaskListEvent {
  const TaskListSubscriptionRequested();
}

final class TaskListTaskDeleted extends TaskListEvent {
  const TaskListTaskDeleted(this.task);

  final TaskModel task;

  @override
  List<Object> get props => [task];
}
