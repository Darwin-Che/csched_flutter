// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:local_storage_tasks_api/local_storage_tasks_api.dart';

void main() {
  group('LocalStorageTasksApi', () {
    test('can be instantiated', () {
      expect(LocalStorageTasksApi.create(), isNotNull);
    });
  });
}
