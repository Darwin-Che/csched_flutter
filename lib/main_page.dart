import 'package:auto_route/auto_route.dart';
import 'package:csched_flutter/app/app_router.gr.dart';
import 'package:flutter/material.dart';

@RoutePage()
class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AutoTabsScaffold(
      // appBarBuilder:(context, tabsRouter) => AppBar(
      //   leading: const AutoLeadingButton(),
      //   title: const Text("Do Something!"),
      // ),
      routes: [
        const NowRouteWrapper(),
        const TaskRouteWrapper(),
        SettingsRoute()
      ],
      bottomNavigationBuilder: (context, tabsRouter) => NavigationBar(
        onDestinationSelected: context.tabsRouter.setActiveIndex,
        indicatorColor: Colors.amber,
        selectedIndex: context.tabsRouter.activeIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Now',
          ),
          NavigationDestination(
            icon: Icon(Icons.task_sharp),
            label: 'Tasks',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_sharp),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
