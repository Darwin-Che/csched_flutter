import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tasks_api/tasks_api.dart';
import 'package:tasks_repository/tasks_repository.dart';

part 'now_event.dart';
part 'now_state.dart';

class NowBloc extends Bloc<NowEvent, NowState> {
  final TasksRepository _repo;

  NowBloc({
    required TasksRepository repo,
  })  : _repo = repo,
        super(const NowState(status: NowStateStatus.initial)) {
    on<LatestProgressSubscriptionRequested>(_onSubscriptionRequested);
    on<CommentChanged>(_onCommentChanged,
        transformer: debounceTransformer(const Duration(milliseconds: 500)));
  }

  Future<void> _onSubscriptionRequested(
    LatestProgressSubscriptionRequested event,
    Emitter<NowState> emit,
  ) async {
    emit(state.copyWith(status: NowStateStatus.loading));

    await emit.forEach<ProgressModel?>(
      _repo.getLatestProgressModelStream(),
      onData: (progressModel) {
        if (progressModel == null) {
          return state.copyWith(status: NowStateStatus.failure);
        } else {
          final taskModel = _repo.findTaskModel(progressModel.taskId);
          return state.copyWith(
              progressModel: progressModel, taskModel: taskModel);
        }
      },
      onError: (_, __) => state.copyWith(status: NowStateStatus.failure),
    );
  }

  Future<void> _onCommentChanged(
    CommentChanged comment,
    Emitter<NowState> emit,
  ) async {
    final progressModel = state.progressModel;
    if (progressModel != null) {
      var nextProgressModel = progressModel.copyWith(startComment: comment.startComment, endComment: comment.endComment);
      await _repo.editLatestProgressModel(nextProgressModel);
      emit(state.copyWith(progressModel: nextProgressModel));
    }
  }

  // Debounce transformer
  EventTransformer<E> debounceTransformer<E>(Duration duration) {
    return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
  }
}
