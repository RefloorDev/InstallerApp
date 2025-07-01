
import 'package:json_annotation/json_annotation.dart';
part 'work_flow.g.dart';
@JsonSerializable()
class WorkFlow {
  String? sessionId;
  String? workflowId;

  WorkFlow(this.sessionId, this.workflowId, this.accessToken,
      this.sfCreatedSessionId);

  String? accessToken;
  String? sfCreatedSessionId;

  


  factory WorkFlow.fromJson(Map<String,dynamic> json) => _$WorkFlowFromJson(json);
  Map<String,dynamic> toJson()=> _$WorkFlowToJson(this);

}