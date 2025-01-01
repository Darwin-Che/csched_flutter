import 'package:auto_route/auto_route.dart';
import 'package:csched_flutter/app/app_router.gr.dart';
import 'package:csched_flutter/helper/date_minute.dart';
import 'package:csched_flutter/now/bloc/now_bloc.dart';
import 'package:csched_flutter/now/bloc/timer_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      child: const NowView(),
    );
  }
}

@RoutePage()
class NowView extends StatelessWidget {
  const NowView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: const AutoLeadingButton(),
          title: const Text("Now"),
        ),
        body: Center(
            child: MultiBlocListener(
                listeners: [
              BlocListener<NowBloc, NowState>(
                listenWhen: (previous, current) =>
                    previous.runtimeType != current.runtimeType,
                listener: (context, state) {
                  if (state is ErrorNowState) {
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
                    builder: (context, nowState) =>
                        BlocBuilder<TimerCubit, int>(
                            builder: (context, timerState) {
                          final isDuringProgress = (nowState
                                  is LastestProgressNowState) &&
                              (nowState.progressModel != null) &&
                              (nowState.progressModel!.endDm * 60 > timerState);
                          if (isDuringProgress) {
                            final progressModel =
                                (nowState as LastestProgressNowState)
                                    .progressModel!;
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text("Current Task"),
                                Text(progressModel.taskId),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(DateMinute.fromInt(
                                            progressModel.startDm)
                                        .toHHMM()),
                                    SizedBox(
                                      width: 100,
                                      child: LinearProgressIndicator(
                                        value: (timerState -
                                                progressModel.startDm * 60) /
                                            (progressModel.endDm * 60 -
                                                progressModel.startDm * 60),
                                        backgroundColor: Colors.grey[300],
                                        color: Colors.blue,
                                        minHeight: 10,
                                      ),
                                    ),
                                    Text(DateMinute.fromInt(progressModel.endDm)
                                        .toHHMM()),
                                  ],
                                ),
                                Text(
                                    '${timerState ~/ 60 - progressModel.startDm} / ${progressModel.duration}'),
                                Spacer(),
                                TextButton(
                                  child: Text("SWITCH"),
                                  onPressed: () =>
                                      {context.pushRoute(const SwitchRoute())},
                                ),
                              ],
                            );
                          } else if (nowState is LastestProgressNowState &&
                              nowState.progressModel != null) {
                            final lastProgress = nowState.progressModel!;
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text("Pending"),
                                Text(
                                    "${DateTime.now().millisecondsSinceEpoch ~/ 1000} - ${lastProgress.endDm}"),
                                Text("Previous Task"),
                                Text("${lastProgress.taskId}"),
                                Spacer(),
                                TextButton(
                                  child: Text("SWITCH"),
                                  onPressed: () =>
                                      {context.pushRoute(const SwitchRoute())},
                                ),
                              ],
                            );
                          } else {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text("Start you first Progress!"),
                                TextButton(
                                  child: Text("SWITCH"),
                                  onPressed: () =>
                                      {context.pushRoute(const SwitchRoute())},
                                ),
                              ],
                            );
                          }
                        })))));
  }
}
