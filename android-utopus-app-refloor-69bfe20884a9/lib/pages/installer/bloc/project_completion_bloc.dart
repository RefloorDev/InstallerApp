import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:reflore/common/validators/validators.dart';
import 'package:reflore/di/app_injector.dart';
import 'package:reflore/di/i_dashboard_page.dart';
import 'package:reflore/model/appointment_data.dart';
import 'package:reflore/repositories/dashboard/dashboard_api.dart';
import 'package:rxdart/rxdart.dart';

import '../../../app/arch/bloc_provider.dart';
import '../../../common/dialog/common_dialog.dart';
import '../../../common/utilites/common_data.dart';
import '../../../common/utilites/logger.dart';
import '../../../common/utilites/strings.dart';
import '../../../manager/user_data_store/user_data_store.dart';
import '../../../model/user_data.dart';
import '../../../repositories/end_point/end_point.dart';

typedef ProjectCompletionFactory = BlocProvider<ProjectCompletionBloc> Function(int type,AppointmentData? appointmentData);
class ProjectCompletionBloc extends BlocBase {
  UserDataStore? userDataStore;
  AppointmentData? appointmentData;
  int? type;
  final BehaviorSubject<bool> _isLoading = BehaviorSubject.seeded(false);
  final BehaviorSubject<String> _validationMsg = BehaviorSubject.seeded('');
  BehaviorSubject<String> _errMsg = BehaviorSubject.seeded('');
  Stream<String> get validationMsg => _validationMsg;
  Sink<String> get addValidationMsg => _validationMsg;
  Stream<String> get errMsg => _errMsg;
  final BehaviorSubject<bool>  _valid = BehaviorSubject.seeded(false);
  Sink<bool> get addIsLoading  => _isLoading;
  Stream<bool> get isLoading  => _isLoading;


  ProjectCompletionBloc({this.userDataStore,this.type,this.appointmentData}){
    _setListeners();
  }

  _setListeners() {

printLog("activityType", appointmentData!.activityType);

  }
  navigateData(BuildContext context,String number) async{
    if(await CommonData.checkConnectivity()!=ConnectivityResult.none) {
      _isLoading.add(true);
      DashboardService().createInstallSummary(
          '${EndPoints.refloor_auth}${appointmentData!.id}',
          {'instance': EndPoints.env}).then((value) {
        _isLoading.add(false);
        if (value.data != null) {
          _isLoading.add(true);
          DashboardService().lightCoWorkFlow({
            "customerFullName": appointmentData!.prospectName,
            "customerFirstName": appointmentData!.prospectName,
            "customerLastName": appointmentData!.prospectName,
            "customerEmail": appointmentData!.prospectPrimaryEmail,
            "customerPhone": number,
            "projectId": appointmentData!.projectId,
            "type": appointmentData!.activityType.toString().toLowerCase()
          }, {'instance': EndPoints.env}).then((value) {
            _isLoading.add(false);
            if (value.data != null) {
              commonDialog(context, Strings.completionCertificateMsg,
                  Strings.ok, () {
                    Get.offAll(AppInjector.instance.dashboard());
                  });
             /* _isLoading.add(true);
              DashboardService().jobCompletionCertificate({
                "sessionId": value.data!.sessionId,
                "workflowId": value.data!.workflowId,
                "accessToken": value.data!.accessToken,
                "sfCreatedSessionId": value.data!.sfCreatedSessionId,
              }, {'instance': EndPoints.env}).then((value) {
                _isLoading.add(false);
                if (value.data != null) {
                  commonDialog(context, Strings.completionCertificateMsg,
                      Strings.ok, () {
                        Get.offAll(AppInjector.instance.dashboard());
                      });
                } else {
                  if (value.error != null) {
                    if (value.error!.errors != null) {
                      if (value.error!.errors!.isNotEmpty) {
                        _errMsg.add(value.error!.errors![0].message!);
                        printLog(
                            "error message", value.error!.errors![0].message);
                      }
                    } else {
                      _errMsg.add(value.error!.error!);
                      printLog("error message", value.error!.error);
                    }
                  }
                }
              });*/
            } else {
              if (value.error!.errors != null) {
                if (value.error!.errors!.isNotEmpty) {
                  _errMsg.add(value.error!.errors![0].message!);
                  printLog("error message", value.error!.errors![0].message);
                }
              } else {
                _errMsg.add(value.error!.error!);
                printLog("error message", value.error!.error);
              }
            }
          });
          /* */
        } else {
          if (value.error!.errors != null) {
            if (value.error!.errors!.isNotEmpty) {
              _errMsg.add(value.error!.errors![0].message!);
              printLog("error message", value.error!.errors![0].message);
            }
          } else {
            _errMsg.add(value.error!.error!);
            printLog("error message", value.error!.error);
          }
        }
      });
    }else{
      _errMsg.add('No Internet Connection!');
    }
    }
}