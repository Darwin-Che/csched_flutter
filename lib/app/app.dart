import 'package:csched_flutter/app/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasks_repository/tasks_repository.dart';

class App extends StatelessWidget {
  App({required this.tasksRepository, super.key});

  final _appRouter = AppRouter();
  final TasksRepository tasksRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: tasksRepository,
      child: MaterialApp.router(
        // theme: AppTheme.light,
        // darkTheme: AppTheme.dark,
        routerConfig: _appRouter.config(),
      ),
    );
  }
}
