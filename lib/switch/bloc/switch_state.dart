part of 'switch_cubit.dart';

class SwitchTaskOption extends Equatable {
  final TaskModel taskModel;
  final double effort;

  const SwitchTaskOption({required this.taskModel, required this.effort});

  @override
  List<Object> get props => [taskModel, effort];
}

enum SwitchStateStatus { initial, loading, waiting, success, failure }

final class SwitchState extends Equatable {
  SwitchState({
    this.status = SwitchStateStatus.initial,
    this.selectedOption,
    this.options = const [],
    DateMinute? endDm,
  }) : endDm = endDm ?? DateMinute.now().afterMinutes(30);

  final SwitchStateStatus status;
  final List<SwitchTaskOption> options;
  final String? selectedOption;
  final DateMinute endDm;

  SwitchState copyWith({
    SwitchStateStatus? status,
    List<SwitchTaskOption>? options,
    String? selectedOption,
    DateMinute? endDm,
  }) {
    return SwitchState(
      status: status ?? this.status,
      options: options ?? this.options,
      selectedOption: selectedOption ?? this.selectedOption,
      endDm: endDm ?? this.endDm,
    );
  }

  @override
  List<Object?> get props => [status, options, selectedOption, endDm];
}
