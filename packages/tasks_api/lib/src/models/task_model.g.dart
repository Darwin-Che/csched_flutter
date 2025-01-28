// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaskModel _$TaskModelFromJson(Map<String, dynamic> json) => TaskModel(
      name: json['name'] as String? ?? '',
      targetEffort: (json['targetEffort'] as num?)?.toInt() ?? 0,
      id: json['id'] as String?,
      description: json['description'] as String? ?? '',
      status: $enumDecodeNullable(_$TaskModelStatusEnumMap, json['status']) ??
          TaskModelStatus.active,
      createdAtDm: (json['createdAtDm'] as num?)?.toInt(),
    );

Map<String, dynamic> _$TaskModelToJson(TaskModel instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'targetEffort': instance.targetEffort,
      'status': _$TaskModelStatusEnumMap[instance.status]!,
      'createdAtDm': instance.createdAtDm,
    };

const _$TaskModelStatusEnumMap = {
  TaskModelStatus.active: 'active',
};
