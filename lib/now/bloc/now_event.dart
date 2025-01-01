part of 'now_bloc.dart';

sealed class NowEvent extends Equatable {
  const NowEvent();

  @override
  List<Object> get props => [];
}

final class LatestProgressSubscriptionRequested extends NowEvent {
  const LatestProgressSubscriptionRequested();
}
