import 'package:csched_flutter/bootstrap.dart';
import 'package:flutter/material.dart';
import 'package:local_storage_tasks_api/local_storage_tasks_api.dart';


void main() async {
  // Avoid errors caused by flutter upgrade.
  // Importing 'package:flutter/widgets.dart' is required.
  WidgetsFlutterBinding.ensureInitialized();

  final tasksApi = await LocalStorageTasksApi.create();

  bootstrap(tasksApi: tasksApi);
}

