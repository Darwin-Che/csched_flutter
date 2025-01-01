import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:csched_flutter/app/app.dart';
import 'package:csched_flutter/app/app_bloc_observer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:tasks_api/tasks_api.dart';
import 'package:tasks_repository/tasks_repository.dart';

void bootstrap({required TasksApi tasksApi}) {
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    log(error.toString(), stackTrace: stack);
    return true;
  };

  Bloc.observer = const AppBlocObserver();

  final tasksRepository = TasksRepository(tasksApi: tasksApi);

  runApp(App(tasksRepository: tasksRepository));
}