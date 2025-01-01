import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:local_storage_tasks_api/local_storage_tasks_api.dart';

@RoutePage()
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: Column(
        children: [
          TextButton(
              onPressed: () {
                DatabaseProvider.shareDatabaseFile();
              },
              child: const Text("Download main.db"))
        ],
      ),
    );
  }
}
