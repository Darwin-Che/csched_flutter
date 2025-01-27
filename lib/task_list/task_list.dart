import 'package:auto_route/auto_route.dart';
import 'package:csched_flutter/app/app_router.gr.dart';
import 'package:csched_flutter/task_list/bloc/task_list_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasks_repository/tasks_repository.dart';

@RoutePage()
class TaskRouteWrapper extends AutoRouter {
  const TaskRouteWrapper({super.key});
}

@RoutePage()
class TaskListPage extends StatelessWidget {
  const TaskListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TaskListBloc(repo: context.read<TasksRepository>())
        ..add(const TaskListSubscriptionRequested()),
      child: const TaskListView(),
    );
  }
}

@RoutePage()
class TaskListView extends StatelessWidget {
  const TaskListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: const AutoLeadingButton(),
          title: const Text("Task List"),
          actions: [
            IconButton(
              icon: const Icon(Icons.delete_forever),
              onPressed: () {
                context.read<TasksRepository>().reset();
              },
            ),
          ]),
      body: MultiBlocListener(
          listeners: [
            BlocListener<TaskListBloc, TaskListState>(
              listenWhen: (previous, current) =>
                  previous.status != current.status,
              listener: (context, state) {
                if (state.status == TaskListStatus.failure) {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      const SnackBar(
                        content: Text("Failed to Load Tasks"),
                      ),
                    );
                }
              },
            ),
          ],
          child: BlocBuilder<TaskListBloc, TaskListState>(
              builder: (context, state) => ListView.separated(
                    itemCount: state.tasks.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () => {
                          context.pushRoute(TaskEditRoute(
                              initialTask: state.tasks.elementAt(index)))
                        },
                        child: TaskListItem(task: state.tasks.elementAt(index)),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return const Divider(
                        color: Colors.grey,
                        thickness: 1,
                        height: 0,
                      );
                    },
                  ))),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.pushRoute(TaskEditRoute());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class TaskListItem extends StatelessWidget {
  final TaskModel task;
  const TaskListItem({required this.task, super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: Colors.blue.shade100,
      leading: const Icon(Icons.label, color: Colors.blue),
      title: Text(task.name, style: const TextStyle(fontSize: 20)),
      trailing: Text('${task.targetEffort}',
          style: const TextStyle(fontSize: 18)),
    );
  }
}
