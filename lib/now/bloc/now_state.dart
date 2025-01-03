part of 'now_bloc.dart';

enum NowStateStatus { initial, loading, success, failure }

class NowState extends Equatable {
  const NowState({
    required this.status,
    this.progressModel,
    this.taskModel,
  });

  final NowStateStatus status;
  final ProgressModel? progressModel;
  final TaskModel? taskModel;

  NowState copyWith({
    NowStateStatus? status,
    ProgressModel? progressModel,
    TaskModel? taskModel,
  }) {
    return NowState(
      status: status ?? this.status,
      progressModel: progressModel ?? this.progressModel,
      taskModel: taskModel ?? this.taskModel,
    );
  }

  @override
  List<Object?> get props => [status, progressModel, taskModel];
}
