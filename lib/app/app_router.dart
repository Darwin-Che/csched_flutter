import 'package:auto_route/auto_route.dart';
import 'package:csched_flutter/app/app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          path: '/',
          page: MainRoute.page,
          initial: true,
          children: [
            AutoRoute(page: NowRouteWrapper.page, children: [
              AutoRoute(path: 'now', page: NowRoute.page, initial: true),
              AutoRoute(path: 'switch', page: SwitchRoute.page),
            ]),
            AutoRoute(page: TaskRouteWrapper.page, children: [
              AutoRoute(path: 'task_list', page: TaskListRoute.page, initial: true),
              AutoRoute(path: 'task_edit', page: TaskEditRoute.page)
            ]),
            AutoRoute(path: 'settings', page: SettingsRoute.page),
          ],
        ),
      ];
}
