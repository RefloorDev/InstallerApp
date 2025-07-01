// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserData _$UserDataFromJson(Map<String, dynamic> json) => UserData(
      json['SalespersonID'] as String?,
      json['SalespersonName'] as String? ?? '',
      json['ShowCustomerPhone'] as String? ?? '',
    );

Map<String, dynamic> _$UserDataToJson(UserData instance) => <String, dynamic>{
      'SalespersonID': instance.SalespersonID,
      'SalespersonName': instance.SalespersonName,
      'ShowCustomerPhone': instance.ShowCustomerPhone,
    };
