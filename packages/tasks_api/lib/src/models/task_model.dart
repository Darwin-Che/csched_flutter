import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:tasks_api/src/models/json_map.dart';
import 'package:tasks_api/src/models/task_model_status.dart';
import 'package:uuid/uuid.dart';

part 'task_model.g.dart';

@immutable
@JsonSerializable()
class TaskModel extends Equatable {
  final String id;
  final String name;
  final String description;
  final int targetEffort;
  final TaskModelStatus status;

  TaskModel({
    this.name = '',
    this.targetEffort = 0,
    String? id,
    this.description = '',
    this.status = TaskModelStatus.active,
  })  : assert(
          id == null || id.isNotEmpty,
          'id must either be null or not empty',
        ),
        id = id ?? const Uuid().v4();

  factory TaskModel.fromJson(JsonMap json) => _$TaskModelFromJson(json);
  JsonMap toJson() => _$TaskModelToJson(this);

  TaskModel copyWith({
    String? id,
    String? name,
    String? description,
    int? priority,
    TaskModelStatus? status,
  }) {
    return TaskModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      targetEffort: priority ?? this.targetEffort,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [id, name, description, targetEffort, status];
}
