import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:reflore/model/file_data.dart';
import 'package:rxdart/rxdart.dart';
import 'package:get/get.dart' hide FormData,MultipartFile;
import 'package:dio/dio.dart';
import '../../../app/arch/bloc_provider.dart';
import '../../../common/dialog/common_dialog.dart';
import '../../../common/utilites/common_data.dart';
import '../../../common/utilites/logger.dart';
import '../../../common/utilites/strings.dart';
import '../../../manager/user_data_store/user_data_store.dart';
import '../../../model/appointment_data.dart';
import '../../../repositories/dashboard/dashboard_api.dart';
import '../../../repositories/end_point/end_point.dart';

typedef CompleteInstallationFactory = BlocProvider<CompleteInstallationBloc> Function(int type,  AppointmentData? appointmentData, List<FileData>? lastUpload,Function(List<FileData> list) onBack);
class CompleteInstallationBloc extends BlocBase {
  UserDataStore? userDataStore;
  AppointmentData? appointmentData;
  int? type;
  List<FileData>? lastUpload;
  Function(List<FileData> list)? onBack;
  final BehaviorSubject<bool> _isLoading = BehaviorSubject.seeded(false);
  final BehaviorSubject<bool> _isUploadAfter = BehaviorSubject.seeded(false);
  final BehaviorSubject<bool>  _valid = BehaviorSubject.seeded(false);
  final BehaviorSubject<List<FileData>> _uploadFiles = BehaviorSubject.seeded([]);
  BehaviorSubject<String> _errMsg = BehaviorSubject.seeded('');
  Stream<String> get errMsg => _errMsg;
  Sink<String> get addErrMsg =>_errMsg;
  Sink<bool> get addIsLoading  => _isLoading;
  Stream<bool> get isLoading  => _isLoading;
  Sink<bool> get addIsUploadAfter  => _isUploadAfter;
  Stream<bool> get isUploadAfter  => _isUploadAfter;
  Sink<List<FileData>> get addUploadFiles  => _uploadFiles;
  Stream<List<FileData>> get uploadFiles  => _uploadFiles;
  bool isUploadAfterCompleted=false;
  CompleteInstallationBloc({this.userDataStore,this.type,this.appointmentData,this.lastUpload,this.onBack}){
    _setListeners();
  }

  _setListeners() {
    _uploadFiles.add(lastUpload!);


  }
  navigateData(List<FileData> imageFiles) async {
    if(await CommonData.checkConnectivity()!=ConnectivityResult.none) {
      _isLoading.add(true);
     /* FormData formData = FormData.fromMap({
        for(int i = 0; i < imageFiles.length; i++)
          "": await MultipartFile.fromFile(
              imageFiles[i].path, filename: imageFiles[i].path
              .split('/')
              .last),

        'type': 'after'
      });*/
      FormData formData = FormData();

      for (int i = 0; i < imageFiles.length; i++) {
        formData.files.add(MapEntry(
            '',
            await MultipartFile.fromFile(
              imageFiles[i].fileName!.path,
              filename: imageFiles[i].fileName!.path.split('/').last,
            )));
      }

      formData.fields.add(MapEntry('type', 'after'));
      printLog("formDataMap", formData.files);
      printLog("formDataMap", formData.fields);
      DashboardService().imageUpload(
          '${EndPoints.refloor_auth}${appointmentData!.id}/after',
          {'instance': EndPoints.env}, formData).then((value) {
        _isLoading.add(false);
        printLog("Response", value.data);
        if (value.data != null) {
          _isUploadAfter.add(true);
          isUploadAfterCompleted=true;
          List<FileData> subImageFiles=[];
          for (int i = 0; i < imageFiles.length; i++) {
            subImageFiles.add(FileData(fileName: imageFiles[i].fileName,isClick: false,isUpload: true));
        }
          addUploadFiles.add(subImageFiles);
          commonDialog(
              Get.context!, Strings.uploadCompletionMsg, Strings.ok, () {

          });

          DashboardService().createInstallSummary(
              '${EndPoints.refloor_auth}${appointmentData!.id}',
              {'instance': EndPoints.env}).then((value) {
            _isLoading.add(false);
            if (value.data != null) {
            }});
        } else {
          if (value.error != null) {
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
        }
      });
    }else{
      _errMsg.add('No Internet Connection!');
    }
  }

}