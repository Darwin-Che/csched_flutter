import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tasks_repository/tasks_repository.dart';

part 'task_edit_event.dart';
part 'task_edit_state.dart';

class TaskEditBloc extends Bloc<TaskEditEvent, TaskEditState> {
  TaskEditBloc({
    required TasksRepository repo,
    required TaskModel? initialTask,
  })  : _repo = repo,
        super(
          TaskEditState(
            initialTask: initialTask,
            name: initialTask?.name ?? '',
            targetEffort: initialTask?.targetEffort ?? 0,
            description: initialTask?.description ?? '',
          ),
        ) {
    on<TaskEditTaskNameChanged>(_onNameChanged);
    on<TaskEditTargetEffortChanged>(_onPriorityChanged);
    on<TaskEditDescriptionChanged>(_onDescriptionChanged);
    on<TaskEditSubmitted>(_onSubmitted);
  }

  final TasksRepository _repo;

  void _onNameChanged(
    TaskEditTaskNameChanged event,
    Emitter<TaskEditState> emit,
  ) {
    emit(state.copyWith(name: event.name));
  }

  void _onPriorityChanged(
    TaskEditTargetEffortChanged event,
    Emitter<TaskEditState> emit,
  ) {
    emit(state.copyWith(priority: event.targetEffort));
  }

  void _onDescriptionChanged(
    TaskEditDescriptionChanged event,
    Emitter<TaskEditState> emit,
  ) {
    emit(state.copyWith(description: event.description));
  }

  Future<void> _onSubmitted(
    TaskEditSubmitted event,
    Emitter<TaskEditState> emit,
  ) async {
    emit(state.copyWith(status: TaskEditStatus.loading));
    final task = (state.initialTask ?? TaskModel()).copyWith(
      name: state.name,
      targetEffort: state.targetEffort,
      description: state.description,
    );

    try {
      await _repo.saveTaskModel(task);
      emit(state.copyWith(status: TaskEditStatus.success));
    } catch (e) {
      print(e.toString());
      emit(state.copyWith(status: TaskEditStatus.failure));
    }
  }
}