
import 'package:json_annotation/json_annotation.dart';
part 'user_data.g.dart';
@JsonSerializable()
class UserData {
  String? SalespersonID;
  @JsonKey(defaultValue: '')
  String? SalespersonName;
  @JsonKey(defaultValue: '')
  String? ShowCustomerPhone;

  UserData(
      this.SalespersonID,
      this.SalespersonName,
      this.ShowCustomerPhone);




  factory UserData.fromJson(Map<String,dynamic> json) => _$UserDataFromJson(json);
  Map<String,dynamic> toJson()=> _$UserDataToJson(this);

}