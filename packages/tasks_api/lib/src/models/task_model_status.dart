enum TaskModelStatus {
  active,
}

extension TaskModelStatusExtension on TaskModelStatus {
  String get value {
    switch (this) {
      case TaskModelStatus.active:
        return 'ACTIVE';
    }
  }

  static TaskModelStatus fromString(String value) {
    switch (value) {
      case 'ACTIVE':
      case 'active':
        return TaskModelStatus.active;
      default:
        throw ArgumentError('Invalid status value: $value');
    }
  }
}
