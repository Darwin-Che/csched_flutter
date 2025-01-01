import 'package:bloc/bloc.dart';
import 'package:csched_flutter/helper/date_minute.dart';
import 'package:equatable/equatable.dart';
import 'package:tasks_api/tasks_api.dart';
import 'package:tasks_repository/tasks_repository.dart';

part 'switch_state.dart';

class SwitchCubit extends Cubit<SwitchState> {
  final TasksRepository _repo;

  SwitchCubit({
    required TasksRepository repo,
  })  : _repo = repo,
        super(SwitchState());

  Future<void> loadOptions() async {
    final tasks = _repo.getTaskModels();
    final tasksEffort = await _repo.getTasksEffort();
    List<(TaskModel, double)> effortPercentageList = [];
    for (final task in tasks) {
      effortPercentageList
          .add((task, (tasksEffort[task.id] ?? 0) / task.targetEffort));
    }

    // sort by effort percentage from small to large
    effortPercentageList.sort((a, b) => a.$2.compareTo(b.$2));
    final options = effortPercentageList
        .take(3)
        .map((record) =>
            SwitchTaskOption(taskModel: record.$1, effort: record.$2))
        .toList();

    emit(state.copyWith(status: SwitchStateStatus.waiting, options: options));
  }

  void selectOption(String selectedId) {
    if (state.status == SwitchStateStatus.waiting) {
      if (state.options.any((option) => option.taskModel.id == selectedId)) {
        emit(state.copyWith(selectedOption: selectedId));
      }
    }
  }

  void setDuration(int m) {
    emit(state.copyWith(endDm: DateMinute.now().afterMinutes(m)));
  }

  void setDateMinute(DateMinute dm) {
    emit(state.copyWith(endDm: dm));
  }

  Future<void> start() async {
    if (state.status == SwitchStateStatus.waiting) {
      if (state.selectedOption != null) {
        DateMinute now = DateMinute.now();
        await _repo.addNewProgressModel(ProgressModel(
          taskId: state.selectedOption!,
          duration: state.endDm - now,
          startDm: now.toInt(),
          endDm: state.endDm.toInt(),
        ));
        emit(state.copyWith(status: SwitchStateStatus.success));
      }
    }
  }
}
