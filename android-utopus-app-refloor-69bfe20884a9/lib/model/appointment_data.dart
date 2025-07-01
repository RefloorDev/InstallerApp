import 'package:json_annotation/json_annotation.dart';
part 'appointment_data.g.dart';
@JsonSerializable()
class AppointmentData {
  String? startDate;
  String? endDate;
  String? marketSegment;
  String? activityType;
  String? assignedTo;
  String? assignedToName;
  String? assignedToEmail;
  String? assignedToPhone;
  String? name;
  String? comments;
  String? id;
  String? projectId;
  String? completed;
  bool? sendInstallerSMS;
  String? prospectName;
  String? prospectPhoneNumber;
  String? prospectFullAddress;
  String? prospectAddress;
  String? prospectCity;
  String? prospectState;
  String? prospectZipCode;
  String? prospectPrimaryEmail;
  String? projectCoordinator;
  String? projectCoordinatorPhone;
  String? projectCoordinatorId;
  String? saleId;
  String? saleNumber;
  String? saleSummaryReportURL;
  String? picklistReportURL;
  String? laborBillReportURL;
  String? installAfterPhotosURL;
  String? installBeforePhotosURL;
  bool? isArrivalConfirmed;
  dynamic installerArrivalDateTime;
  bool? isInstallConfirmed;
 dynamic installerNotificationConfirmed;
 dynamic errors;
  dynamic message;
  String? success;
  String? installationManager;
  String? installationManagerPhone;
  String? installCoordinatorManager;
  String? appointmentLongitude;
  String? appointmentLatitude;
  AppointmentData(
      this.startDate,
      this.endDate,
      this.marketSegment,
      this.activityType,
      this.assignedTo,
      this.assignedToName,
      this.assignedToEmail,
      this.assignedToPhone,
      this.name,
      this.comments,
      this.id,
      this.projectId,
      this.completed,
      this.sendInstallerSMS,
      this.prospectName,
      this.prospectPhoneNumber,
      this.prospectFullAddress,
      this.prospectAddress,
      this.prospectCity,
      this.prospectState,
      this.prospectZipCode,
      this.prospectPrimaryEmail,
      this.projectCoordinator,
      this.projectCoordinatorPhone,
      this.projectCoordinatorId,
      this.saleId,
      this.saleNumber,
      this.saleSummaryReportURL,
      this.picklistReportURL,
      this.laborBillReportURL,
      this.installAfterPhotosURL,
      this.installBeforePhotosURL,
      this.isArrivalConfirmed,
      this.installerArrivalDateTime,
      this.isInstallConfirmed,
      this.installerNotificationConfirmed,
      this.errors,
      this.message,
      this.success,
      this.installationManager,
      this.installationManagerPhone,
      this.installCoordinatorManager,
      this.installCoordinatorManagerPhone,this.appointmentLongitude,this.appointmentLatitude);

  String? installCoordinatorManagerPhone;



  factory AppointmentData.fromJson(Map<String,dynamic> json) => _$AppointmentDataFromJson(json);
  Map<String,dynamic> toJson()=> _$AppointmentDataToJson(this);
}