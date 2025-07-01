import 'package:json_annotation/json_annotation.dart';
part 'checklist_data.g.dart';
@JsonSerializable()
class ChecklistData{
  String? name;
  String? arrival_Or_Completion;
  @JsonKey(defaultValue: false)
  bool? isCheck;

  ChecklistData(this.name, this.arrival_Or_Completion, this.isCheck);



  factory ChecklistData.fromJson(Map<String,dynamic> json) => _$ChecklistDataFromJson(json);
  Map<String,dynamic> toJson()=> _$ChecklistDataToJson(this);
}