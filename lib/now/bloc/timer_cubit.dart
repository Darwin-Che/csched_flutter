import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

class TimerCubit extends Cubit<int> {
  TimerCubit() : super(DateTime.now().millisecondsSinceEpoch ~/ 1000);

  Timer? _timer;

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      emit(DateTime.now().millisecondsSinceEpoch ~/ 1000); // Increment the counter
    });
  }

  // Stop the timer
  void stopTimer() {
    _timer?.cancel();
  }

  @override
  Future<void> close() {
    _timer?.cancel(); // Clean up the timer
    return super.close();
  }
}