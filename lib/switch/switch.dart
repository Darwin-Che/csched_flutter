import 'package:auto_route/auto_route.dart';
import 'package:csched_flutter/helper/date_minute.dart';
import 'package:csched_flutter/switch/bloc/switch_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasks_repository/tasks_repository.dart';

@RoutePage()
class SwitchPage extends StatelessWidget {
  const SwitchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          SwitchCubit(repo: context.read<TasksRepository>())..loadOptions(),
      child: SwitchView(),
    );
  }
}

@RoutePage()
class SwitchView extends StatelessWidget {
  final TextEditingController _controllerDuration = TextEditingController();

  SwitchView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: const AutoLeadingButton(),
          title: const Text("Switch Task"),
        ),
        body: Center(
            child: MultiBlocListener(
                listeners: [
              BlocListener<SwitchCubit, SwitchState>(
                listenWhen: (previous, current) =>
                    previous.status != current.status,
                listener: (context, state) {
                  if (state.status == SwitchStateStatus.success) {
                    context.maybePop();
                  }
                },
              ),
            ],
                child: BlocBuilder<SwitchCubit, SwitchState>(
                    builder: (context, state) {
                  _controllerDuration.text =
                      (state.endDm - DateMinute.now()).toString();

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
                        child: Text(
                          "Task Options",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                        itemCount: state.options.length,
                        itemBuilder: (context, index) {
                          final option = state.options[index];
                          return ListTile(
                            tileColor:
                                state.selectedOption == option.taskModel.id
                                    ? Colors.blue.shade100
                                    : null,
                            leading:
                                const Icon(Icons.label, color: Colors.blue),
                            title: Text(option.taskModel.name,
                                style: const TextStyle(fontSize: 20)),
                            trailing: Text(
                                '${option.effort.toStringAsFixed(1)} / ${option.taskModel.targetEffort}',
                                style: const TextStyle(fontSize: 18)),
                            onTap: () {
                              context
                                  .read<SwitchCubit>()
                                  .selectOption(option.taskModel.id);
                            },
                          );
                        },
                      ),
                      Divider(),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
                        child: Text(
                          "Timing",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ),
                      ListView(
                        shrinkWrap: true,
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                        children: [
                          Padding(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                              child: Row(
                                children: [
                                  const Text("Duration",
                                      style: TextStyle(fontSize: 18)),
                                  const Spacer(),
                                  SizedBox(
                                    width: 50,
                                    child: TextFormField(
                                      style: TextStyle(fontSize: 18),
                                      controller: _controllerDuration,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter
                                            .digitsOnly, // Allows only digits
                                        LengthLimitingTextInputFormatter(3),
                                      ],
                                      textAlign: TextAlign.right,
                                      decoration: InputDecoration(
                                        isDense: true,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 6, horizontal: 8),
                                        border: OutlineInputBorder(),
                                      ),
                                      onChanged: (value) {
                                        if (value != "") {
                                          context
                                              .read<SwitchCubit>()
                                              .setDuration(int.parse(value));
                                        }
                                      },
                                    ),
                                  ),
                                  const Text("  min",
                                      style: TextStyle(fontSize: 18)),
                                ],
                              )),
                          Padding(
                              padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                              child: Row(
                                children: [
                                  Text("End at",
                                      style: TextStyle(fontSize: 18)),
                                  Spacer(),
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      side: BorderSide(
                                          color: Colors.grey,
                                          width: 1), // Border
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            4), // Match OutlineInputBorder
                                      ),
                                      padding: EdgeInsets.symmetric(
                                          vertical: 4,
                                          horizontal: 8), // Padding
                                    ),
                                    child: Text(state.endDm.toHHMM(),
                                        style: TextStyle(fontSize: 18)),
                                    onPressed: () async {
                                      final TimeOfDay? picked =
                                          await showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.fromDateTime(
                                            state.endDm.toDateTime()),
                                      );
                                      if (picked != null) {
                                        // Dispatch the selected time to the Bloc
                                        context
                                            .read<SwitchCubit>()
                                            .setDateMinute(
                                                DateMinute.fromTimeOfDay(
                                                    picked));
                                      }
                                    },
                                  ),
                                ],
                              )),
                        ],
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                minimumSize:
                                    Size(120, 50), // Minimum height of 50
                              ),
                              onPressed: () {
                                context.maybePop();
                              },
                              child: const Text(
                                "Cancel",
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                minimumSize:
                                    Size(120, 50), // Minimum height of 50
                              ),
                              onPressed: () {
                                context.read<SwitchCubit>().start();
                              },
                              child: const Text(
                                "Let's Go",
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }))));
  }
}
