// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'work_flow.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WorkFlow _$WorkFlowFromJson(Map<String, dynamic> json) => WorkFlow(
      json['sessionId'] as String?,
      json['workflowId'] as String?,
      json['accessToken'] as String?,
      json['sfCreatedSessionId'] as String?,
    );

Map<String, dynamic> _$WorkFlowToJson(WorkFlow instance) => <String, dynamic>{
      'sessionId': instance.sessionId,
      'workflowId': instance.workflowId,
      'accessToken': instance.accessToken,
      'sfCreatedSessionId': instance.sfCreatedSessionId,
    };
