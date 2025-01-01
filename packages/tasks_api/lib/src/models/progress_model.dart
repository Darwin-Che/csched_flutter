import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:tasks_api/src/models/json_map.dart';
import 'package:uuid/uuid.dart';

part 'progress_model.g.dart';

@immutable
@JsonSerializable()
class ProgressModel extends Equatable {
  final String id;
  final String taskId;
  final int duration;
  final int startDm;
  final int endDm;
  final String startComment;
  final String endComment;

  ProgressModel({
    required this.taskId,
    String? id,
    this.duration = 0,
    this.startDm = 0,
    this.endDm = 0,
    this.startComment = '',
    this.endComment = '',
  })  : assert(
          id == null || id.isNotEmpty,
          'id must either be null or not empty',
        ),
        id = id ?? const Uuid().v4();

  factory ProgressModel.fromJson(JsonMap json) => _$ProgressModelFromJson(json);
  JsonMap toJson() => _$ProgressModelToJson(this);

  ProgressModel copyWith({
    String? id,
    String? taskId,
    int? duration,
    int? startTs,
    int? endTs,
    String? startComment,
    String? endComment,
  }) {
    return ProgressModel(
      id: id ?? this.id,
      taskId: taskId ?? this.taskId,
      duration: duration ?? this.duration,
      startDm: startTs ?? this.startDm,
      endDm: endTs ?? this.endDm,
      startComment: startComment ?? this.startComment,
      endComment: endComment ?? this.endComment,
    );
  }

  @override
  List<Object> get props => [id, taskId, duration, startDm, endDm, startComment, endComment];
}
