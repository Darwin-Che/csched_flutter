import 'package:auto_route/auto_route.dart';
import 'package:csched_flutter/app/app_router.gr.dart';
import 'package:csched_flutter/helper/date_minute.dart';
import 'package:csched_flutter/helper/time_helper.dart';
import 'package:csched_flutter/helper/widget_style.dart';
import 'package:csched_flutter/now/bloc/now_bloc.dart';
import 'package:csched_flutter/now/bloc/timer_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasks_api/tasks_api.dart';
import 'package:tasks_repository/tasks_repository.dart';

@RoutePage()
class NowPageWrapper extends StatelessWidget {
  const NowPageWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return const AutoRouter();
  }
}

@RoutePage()
class NowPage extends StatelessWidget {
  const NowPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => NowBloc(repo: context.read<TasksRepository>())
              ..add(const LatestProgressSubscriptionRequested())),
        BlocProvider(
          create: (context) => TimerCubit()..startTimer(),
        )
      ],
      child: NowView(),
    );
  }
}

@RoutePage()
class NowView extends StatelessWidget {
  final TextEditingController _controllerStartComment = TextEditingController();
  final TextEditingController _controllerEndComment = TextEditingController();

  NowView({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
            appBar: AppBar(
              leading: const AutoLeadingButton(),
              title: const Text("Now"),
            ),
            body: Center(
                child: MultiBlocListener(
                    listeners: [
                  BlocListener<NowBloc, NowState>(
                    listenWhen: (previous, current) =>
                        previous.status != current.status,
                    listener: (context, state) {
                      if (state.status == NowStateStatus.failure) {
                        ScaffoldMessenger.of(context)
                          ..hideCurrentSnackBar()
                          ..showSnackBar(
                            const SnackBar(
                              content: Text("Failed to Load Latest Progress"),
                            ),
                          );
                      }
                    },
                  ),
                ],
                    child: BlocBuilder<NowBloc, NowState>(
                        builder: (context, nowState) {
                      _controllerStartComment.text =
                          (nowState).progressModel?.startComment ?? "";
                      _controllerEndComment.text =
                          (nowState).progressModel?.endComment ?? "";

                      return BlocBuilder<TimerCubit, int>(
                          builder: (context, timerState) {
                        if (nowState.progressModel == null) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text("Start you first Progress!"),
                              TextButton(
                                child: const Text("SWITCH"),
                                onPressed: () =>
                                    {context.pushRoute(const SwitchRoute())},
                              ),
                            ],
                          );
                        }

                        if (nowState.taskModel == null) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                  "Error: The task associated with the progress is not found"),
                              TextButton(
                                child: const Text("SWITCH"),
                                onPressed: () =>
                                    {context.pushRoute(const SwitchRoute())},
                              ),
                            ],
                          );
                        }

                        final progressModel = nowState.progressModel!;
                        final taskModel = nowState.taskModel!;

                        final isProgressActive =
                            progressModel.endDm * 60 > timerState;

                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            if (!isProgressActive)
                              const SectionTitle(text: "Pending"),
                            if (!isProgressActive)
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(32, 0, 32, 16),
                                child: Text(
                                  TimeHelper.formatSeconds(
                                      DateTime.now().millisecondsSinceEpoch ~/
                                              1000 -
                                          progressModel.endDm * 60),
                                  style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            if (!isProgressActive) const Divider(),
                            if (!isProgressActive)
                              const SectionTitle(text: "Previous Task"),
                            if (isProgressActive)
                              const SectionTitle(text: "Current Task"),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(32, 0, 32, 16),
                              child: Text(
                                "${taskModel.name}",
                                style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blueGrey),
                              ),
                            ),
                            _ProgressBar(
                              progressModel: progressModel,
                              curSecond: timerState,
                            ),
                            const SizedBox(height: 28),
                            LayoutBuilder(builder: (context, constraints) {
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  SizedBox(
                                    width: constraints.maxWidth / 2 - 20,
                                    child: TextFormField(
                                        style: const TextStyle(fontSize: 12),
                                        controller: _controllerStartComment,
                                        keyboardType: TextInputType.multiline,
                                        maxLines: 8,
                                        minLines: 8,
                                        inputFormatters: [],
                                        textAlign: TextAlign.left,
                                        decoration: const InputDecoration(
                                          hintText: "StartComment",
                                          isDense: true,
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 8, horizontal: 8),
                                          border: OutlineInputBorder(),
                                        ),
                                        onChanged: (value) {
                                          context.read<NowBloc>().add(
                                              CommentChanged(
                                                  startComment: value));
                                        }),
                                  ),
                                  SizedBox(
                                    width: constraints.maxWidth / 2 - 20,
                                    child: TextFormField(
                                        style: const TextStyle(fontSize: 12),
                                        controller: _controllerEndComment,
                                        keyboardType: TextInputType.multiline,
                                        maxLines: 8,
                                        minLines: 8,
                                        inputFormatters: [],
                                        textAlign: TextAlign.left,
                                        decoration: const InputDecoration(
                                          hintText: "EndComment",
                                          isDense: true,
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 8, horizontal: 8),
                                          border: OutlineInputBorder(),
                                        ),
                                        onChanged: (value) {
                                          context.read<NowBloc>().add(
                                              CommentChanged(
                                                  endComment: value));
                                        }),
                                  ),
                                ],
                              );
                            }),
                            const Spacer(),
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(24, 16, 24, 32),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: const Size(
                                          240, 50), // Minimum height of 50
                                    ),
                                    onPressed: () {
                                      context.pushRoute(const SwitchRoute());
                                    },
                                    child: Text(
                                      isProgressActive
                                          ? "Switch Early"
                                          : "On to Next",
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      });
                    })))));
  }
}

class _ProgressBar extends StatelessWidget {
  final ProgressModel progressModel;
  final int curSecond;

  const _ProgressBar({required this.progressModel, required this.curSecond});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LayoutBuilder(
          builder: (context, constraints) => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "${DateMinute.fromInt(progressModel.startDm).toHHMM()}  ",
                style: const TextStyle(fontSize: 18),
              ),
              SizedBox(
                width: constraints.maxWidth / 2,
                child: LinearProgressIndicator(
                  borderRadius: BorderRadius.circular(5),
                  value: progressModel.endDm == progressModel.startDm
                      ? 1
                      : (curSecond - progressModel.startDm * 60) /
                          (progressModel.endDm * 60 -
                              progressModel.startDm * 60),
                  backgroundColor: Colors.grey[300],
                  color: Colors.amberAccent,
                  minHeight: 10,
                ),
              ),
              Text(
                "  ${DateMinute.fromInt(progressModel.endDm).toHHMM()}",
                style: const TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
        // Text(
        //     '${curSecond ~/ 60 - progressModel.startDm} / ${progressModel.duration}'),
      ],
    );
  }
}
