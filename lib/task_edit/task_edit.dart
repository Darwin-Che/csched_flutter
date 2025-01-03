import 'package:auto_route/auto_route.dart';
import 'package:csched_flutter/task_edit/bloc/task_edit_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasks_repository/tasks_repository.dart';

@RoutePage()
class TaskEditPage extends StatelessWidget {
  final TaskModel? initialTask;
  const TaskEditPage({this.initialTask, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => TaskEditBloc(
          repo: context.read<TasksRepository>(),
          initialTask: initialTask,
        ), child: const TaskEditView());
  }
}

class TaskEditView extends StatelessWidget {
  const TaskEditView({super.key});

  @override
  Widget build(BuildContext context) {
return BlocListener<TaskEditBloc, TaskEditState>(
      listenWhen: (previous, current) =>
          previous.status != current.status &&
          current.status == TaskEditStatus.success,
      listener: (context, state) => context.router.popUntilRouteWithPath('task_list'),
      child: const TaskEditViewBuilder(),
    );
  }
}

class TaskEditViewBuilder extends StatelessWidget {
  const TaskEditViewBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    final status = context.select((TaskEditBloc bloc) => bloc.state.status);
    final isNewTask = context.select(
      (TaskEditBloc bloc) => bloc.state.isNewTask,
    );

    return Scaffold(
      appBar: AppBar(
        leading: const AutoLeadingButton(),
        title: Text(isNewTask ? 'Add New Task' : 'Edit Task'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(
              flex: 1,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: _TaskNameField(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: _TaskTargetEffortField(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: _TaskDescriptionField(),
            ),
            const Spacer(
              flex: 1,
            ),
            TextButton(
              onPressed: status.isLoadingOrSuccess
                  ? null
                  : () => context
                      .read<TaskEditBloc>()
                      .add(const TaskEditSubmitted()),
              child: status.isLoadingOrSuccess
                  ? const CircularProgressIndicator()
                  : const Icon(Icons.check_rounded),
            ),
            const Spacer(
              flex: 1,
            ),
          ],
        ),
      ),
    );
  }
}

class _TaskNameField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final state = context.watch<TaskEditBloc>().state;
    return TextFormField(
      key: const Key('TaskEditView_TaskName_TextFormField'),
      initialValue: state.name,
      decoration: const InputDecoration(
          border: UnderlineInputBorder(), labelText: 'TaskName'),
      maxLength: 50,
      inputFormatters: [
        LengthLimitingTextInputFormatter(50),
        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\s]')),
      ],
      onChanged: (value) {
        context.read<TaskEditBloc>().add(TaskEditTaskNameChanged(value));
      },
    );
  }
}

class _TaskTargetEffortField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final state = context.watch<TaskEditBloc>().state;
    return TextFormField(
      key: const Key('TaskEditView_TargetEffort_TextFormField'),
      initialValue: '${state.targetEffort}',
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
          border: UnderlineInputBorder(), labelText: 'Target Effort (hours per week)'),
      maxLength: 50,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a value';
        }
        final intValue = int.tryParse(value);
        if (intValue == null) {
          return 'Please enter a valid integer';
        }
        return null;
      },
      onChanged: (value) {
        context
            .read<TaskEditBloc>()
            .add(TaskEditTargetEffortChanged(int.tryParse(value) ?? 0));
      },
    );
  }
}

class _TaskDescriptionField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final state = context.watch<TaskEditBloc>().state;
    return TextFormField(
      key: const Key('TaskEditView_Description_TextFormField'),
      initialValue: state.name,
      decoration: const InputDecoration(
          border: UnderlineInputBorder(), labelText: 'Description'),
      maxLength: 50,
      inputFormatters: [
        LengthLimitingTextInputFormatter(50),
      ],
      onChanged: (value) {
        context.read<TaskEditBloc>().add(TaskEditDescriptionChanged(value));
      },
    );
  }
}
