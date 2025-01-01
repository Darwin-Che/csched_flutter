// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'progress_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProgressModel _$ProgressModelFromJson(Map<String, dynamic> json) =>
    ProgressModel(
      taskId: json['taskId'] as String,
      id: json['id'] as String?,
      duration: (json['duration'] as num?)?.toInt() ?? 0,
      startDm: (json['startDm'] as num?)?.toInt() ?? 0,
      endDm: (json['endDm'] as num?)?.toInt() ?? 0,
      startComment: json['startComment'] as String? ?? '',
      endComment: json['endComment'] as String? ?? '',
    );

Map<String, dynamic> _$ProgressModelToJson(ProgressModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'taskId': instance.taskId,
      'duration': instance.duration,
      'startDm': instance.startDm,
      'endDm': instance.endDm,
      'startComment': instance.startComment,
      'endComment': instance.endComment,
    };
