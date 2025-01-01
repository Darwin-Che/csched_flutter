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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text("Options"),
                      ListView.separated(
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(8.0),
                        itemCount: state.options.length,
                        separatorBuilder: (context, index) =>
                            Divider(color: Colors.grey[400]),
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
                                style: const TextStyle(fontSize: 16)),
                            trailing: Text(
                                '${option.effort} / ${option.taskModel.targetEffort}',
                                style: const TextStyle(fontSize: 16)),
                            onTap: () {
                              context
                                  .read<SwitchCubit>()
                                  .selectOption(option.taskModel.id);
                            },
                          );
                        },
                      ),
                      Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Row(
                            children: [
                              const Text("Duration",
                                  style: TextStyle(fontSize: 16)),
                              const Spacer(),
                              SizedBox(
                                width: 100,
                                child: TextFormField(
                                  controller: _controllerDuration,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter
                                        .digitsOnly, // Allows only digits
                                    LengthLimitingTextInputFormatter(3),
                                  ],
                                  decoration: const InputDecoration(
                                    labelText: "MMM",
                                    border: OutlineInputBorder(),
                                  ),
                                  onChanged: (value) {
                                    context
                                        .read<SwitchCubit>()
                                        .setDuration(int.parse(value));
                                  },
                                ),
                              ),
                              const Text(" minutes",
                                  style: TextStyle(fontSize: 16)),
                            ],
                          )),
                      Padding(
                          padding: EdgeInsets.all(32.0),
                          child: Row(
                            children: [
                              Text("End at", style: TextStyle(fontSize: 16)),
                              Spacer(),
                              TextButton(
                                child: Text(
                                    "${state.endDm.localHour()} : ${state.endDm.localMinute()} "),
                                onPressed: () async {
                                  final TimeOfDay? picked =
                                      await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.fromDateTime(
                                        state.endDm.toDateTime()),
                                  );
                                  if (picked != null) {
                                    // Dispatch the selected time to the Bloc
                                    context.read<SwitchCubit>().setDateMinute(
                                        DateMinute.fromTimeOfDay(picked));
                                  }
                                },
                              ),
                            ],
                          )),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                context.maybePop();
                              },
                              child: const Text("Cancel"),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                context.read<SwitchCubit>().start();
                              },
                              child: const Text("Let's Go"),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }))));
  }
}
