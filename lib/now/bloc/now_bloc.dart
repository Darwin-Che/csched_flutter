import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tasks_api/tasks_api.dart';
import 'package:tasks_repository/tasks_repository.dart';

part 'now_event.dart';
part 'now_state.dart';

class NowBloc extends Bloc<NowEvent, NowState> {
  final TasksRepository _repo;

  NowBloc({
    required TasksRepository repo,
  })  : _repo = repo,
        super(InitialNowState()) {
    on<LatestProgressSubscriptionRequested>(_onSubscriptionRequested);
  }

  Future<void> _onSubscriptionRequested(
    LatestProgressSubscriptionRequested event,
    Emitter<NowState> emit,
  ) async {
    emit(LoadingNowState());

    await emit.forEach<ProgressModel?>(
      _repo.getLatestProgressModel(),
      onData: (progressModel) => LastestProgressNowState(progressModel: progressModel),
      onError: (_, __) => ErrorNowState(),
    );
  }
}
