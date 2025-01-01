
import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:tasks_repository/tasks_repository.dart';

part 'task_list_event.dart';
part 'task_list_state.dart';

class TaskListBloc extends Bloc<TaskListEvent, TaskListState> {
  TaskListBloc({
    required TasksRepository repo,
  })  : _repo = repo,
        super(const TaskListState()) {
    on<TaskListSubscriptionRequested>(_onSubscriptionRequested);
    on<TaskListTaskDeleted>(_onTaskDeleted);
  }

  final TasksRepository _repo;

  Future<void> _onSubscriptionRequested(
    TaskListSubscriptionRequested event,
    Emitter<TaskListState> emit,
  ) async {
    emit(state.copyWith(status: () => TaskListStatus.loading));

    await emit.forEach<List<TaskModel>>(
      _repo.getTaskModelsStream(),
      onData: (tasks) => state.copyWith(
        status: () => TaskListStatus.success,
        tasks: () => tasks,
      ),
      onError: (_, __) => state.copyWith(
        status: () => TaskListStatus.failure,
      ),
    );
  }

  Future<void> _onTaskDeleted(
    TaskListTaskDeleted event,
    Emitter<TaskListState> emit,
  ) async {
    await _repo.deleteTaskModel(event.task.id);
  }
}