part of 'now_bloc.dart';

sealed class NowState extends Equatable {
  const NowState();
  
  @override
  List<Object?> get props => [];
}

final class InitialNowState extends NowState {}
final class LoadingNowState extends NowState {}

final class LastestProgressNowState extends NowState {
  final ProgressModel? progressModel;

  const LastestProgressNowState({required this.progressModel});

  @override
  List<Object?> get props => [progressModel];
}

final class ErrorNowState extends NowState {}
