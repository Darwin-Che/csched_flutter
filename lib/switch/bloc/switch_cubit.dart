import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:csched_flutter/helper/date_minute.dart';
import 'package:csched_flutter/helper/time_helper.dart';
import 'package:csched_flutter/notification/notif_wrapper.dart';
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
          .add((task, (tasksEffort[task.id] ?? 0) - task.targetEffort));
    }

    // sort by effort percentage from small to large
    effortPercentageList.sort((a, b) => (a.$2 / a.$1.targetEffort).compareTo(b.$2 / b.$1.targetEffort));
    final options = effortPercentageList
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
      if (state.selectedOption != null && state.endDm.minutesSinceEpoch > DateMinute.now().minutesSinceEpoch) {
        DateMinute now = DateMinute.now();
        var currentProgress = _repo.getLatestProgressModel();
        if (currentProgress!= null && currentProgress.endDm > now.toInt()) {
          currentProgress.copyWith(endDm: now.toInt());
          await _repo.editLatestProgressModel(currentProgress);
        }

        final newProgressModel = ProgressModel(
          taskId: state.selectedOption!,
          duration: state.endDm - now,
          startDm: now.toInt(),
          endDm: state.endDm.toInt(),
        );

        await _repo.addNewProgressModel(newProgressModel);

        await NotifWrapper.deleteAllPending();
        await scheduleReminderNotifications(newProgressModel);

        emit(state.copyWith(status: SwitchStateStatus.success));
      }
    }
  }
}

Future<void> scheduleReminderNotifications(ProgressModel progressModel) async {
  final alertAfterEnd = [
    0, 5, 10, 15, 20, 25, 30, 35, 45, 60, 75, 90, 120, 150, 180, 210, 240, 270, 300,
  ];

  final endDateTime = DateMinute.fromInt(progressModel.endDm).toDateTime();
  final countSeconds = (endDateTime.millisecondsSinceEpoch - DateTime.now().millisecondsSinceEpoch) ~/ 1000;

  for (final (i, m) in alertAfterEnd.indexed) {
    NotifWrapper.schedule(
      id: i,
      title: "Csched: What's next!",
      body: m == 0 ? "Congrats! Task finished!" : "It has been ${TimeHelper.formatMinutes(m)}!",
      seconds: 5 + countSeconds + m * 60,
    );
  }
}
