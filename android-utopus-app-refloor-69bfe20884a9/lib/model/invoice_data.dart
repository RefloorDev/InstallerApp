
import 'package:json_annotation/json_annotation.dart';
part 'invoice_data.g.dart';
@JsonSerializable()
class InvoiceData {
  String? id;
  String? projectId;

  InvoiceData(this.id, this.projectId, this.type, this.customerName,
      this.installationCrewName, this.laborBillAmount);

  String? type;
  String? customerName;
  String? installationCrewName;
  dynamic laborBillAmount;

  


  factory InvoiceData.fromJson(Map<String,dynamic> json) => _$InvoiceDataFromJson(json);
  Map<String,dynamic> toJson()=> _$InvoiceDataToJson(this);

}