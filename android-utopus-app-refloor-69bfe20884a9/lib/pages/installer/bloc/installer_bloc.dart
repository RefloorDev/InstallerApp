import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart' hide FormData,MultipartFile;
import 'package:reflore/common/validators/validators.dart';
import 'package:reflore/di/app_injector.dart';
import 'package:reflore/di/i_installer_page.dart';
import 'package:reflore/model/checklist_data.dart';
import 'package:reflore/model/file_data.dart';
import 'package:reflore/model/invoice_data.dart';
import 'package:rxdart/rxdart.dart';

import '../../../app/arch/bloc_provider.dart';
import '../../../common/dialog/common_dialog.dart';
import '../../../common/dialog/upload_dialog.dart';
import '../../../common/utilites/common_data.dart';
import '../../../common/utilites/logger.dart';
import '../../../common/utilites/strings.dart';
import '../../../manager/user_data_store/user_data_store.dart';
import '../../../model/appointment_data.dart';
import '../../../model/user_data.dart';
import '../../../repositories/dashboard/dashboard_api.dart';
import '../../../repositories/end_point/end_point.dart';
import '../installer_details.dart';

typedef InstallerDetailsFactory = BlocProvider<InstallerDetailsBloc> Function(int type,AppointmentData? appointmentData);
class InstallerDetailsBloc extends BlocBase {
  UserDataStore? userDataStore;
  int? type;
  AppointmentData? appointmentData;
  final BehaviorSubject<bool> _isLoading = BehaviorSubject.seeded(false);
  final BehaviorSubject<bool>  _valid = BehaviorSubject.seeded(false);
  final BehaviorSubject<int>  _tabSelect = BehaviorSubject.seeded(-1);
  final BehaviorSubject<bool> _isArrival = BehaviorSubject.seeded(false);
  final BehaviorSubject<bool> _workOrder = BehaviorSubject.seeded(false);
  final BehaviorSubject<bool> _leveling = BehaviorSubject.seeded(false);
  final BehaviorSubject<List<FileData>> _uploadFiles = BehaviorSubject.seeded([]);
  final BehaviorSubject<AppointmentData> _installerData = BehaviorSubject();
  BehaviorSubject<String> _errMsg = BehaviorSubject.seeded('');
  BehaviorSubject<List<ChecklistData>> _arrivalCheckList=BehaviorSubject();
  BehaviorSubject<List<ChecklistData>> _completeCheckList=BehaviorSubject();
  BehaviorSubject<InvoiceData> _invoiceDetailsData=BehaviorSubject();
  final BehaviorSubject<bool> _isArrivalCheck = BehaviorSubject.seeded(false);
  final BehaviorSubject<bool> _isCompleteCheck = BehaviorSubject.seeded(false);
  final BehaviorSubject<bool> _isSave = BehaviorSubject.seeded(false);
  final BehaviorSubject<bool> _isInvoice = BehaviorSubject.seeded(false);
  Stream<bool> get isInvoice => _isInvoice;
  Sink<bool> get addIsInvoice => _isInvoice;
  Stream<bool> get isSave => _isSave;
  Sink<bool> get addIsSave => _isSave;
  Sink<bool> get addCompleteCheck => _isCompleteCheck;
  Stream<bool> get isCompleteCheck => _isCompleteCheck;
  Sink<bool> get addArrivalCheck => _isArrivalCheck;
  Stream<bool> get isArrivalCheck => _isArrivalCheck;
  Sink<List<ChecklistData>> get addCheckList => _arrivalCheckList;
  Stream<List<ChecklistData>> get checkList => _arrivalCheckList;

  Stream<InvoiceData> get invoiceDetailsData => _invoiceDetailsData;

  Sink<List<ChecklistData>> get addCompleteCheckList => _completeCheckList;
  Stream<List<ChecklistData>> get completeCheckList => _completeCheckList;
  Stream<String> get errMsg => _errMsg;
  Sink<String> get addErrMsg => _errMsg;
  Stream<AppointmentData> get installerData  => _installerData;
  Sink<int> get addTabSelect  => _tabSelect;
  Stream<int> get tabSelect  => _tabSelect;
  Sink<bool> get addIsLoading  => _isLoading;
  Stream<bool> get isLoading  => _isLoading;
  Sink<bool> get addIsArrival  => _isArrival;
  Stream<bool> get isArrival  => _isArrival;
  Sink<bool> get addWorkOrder  => _workOrder;
  Stream<bool> get workOrder  => _workOrder;
  Sink<bool> get addLeveling  => _leveling;
  Stream<bool> get leveling  => _leveling;
  Sink<List<FileData>> get addUploadFiles  => _uploadFiles;
  Stream<List<FileData>> get uploadFiles  => _uploadFiles;
  bool isConfirmArrivalCompleted=false;
  List<FileData> lastUpload=[];
  UserData? user;
  List<ChecklistData> list=[];


  InstallerDetailsBloc({this.userDataStore,this.type,this.appointmentData}){
   // _setListeners();
    _installerData.add(appointmentData!);
    getInvoice();

    
  }

  _setListeners() async {
    user= await userDataStore!.getUser();
    if(await CommonData.checkConnectivity()!=ConnectivityResult.none) {
    _isLoading.add(true);
    DashboardService().getReleasedInstallations(
        '${EndPoints.refloor_auth}${user!.SalespersonID}',
        {'instance': EndPoints.env}).then((value) {
      _isLoading.add(false);
      if (value.data != null) {
      } else {
        if(value.error!=null){
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
  confirmArrival(BuildContext context) async{
    var user= await userDataStore!.getUser();
    if(await CommonData.checkConnectivity()!=ConnectivityResult.none) {
      _isLoading.add(true);
      DashboardService().confirmArrival(
          '${EndPoints.refloor_auth}${appointmentData!.id}',
          {'instance': EndPoints.env}).then((value) {
        _isLoading.add(false);
        if (value.data != null) {
          addIsArrival.add(true);
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

  getCheckList(String type) async{
    var user= await userDataStore!.getUser();
    if(await CommonData.checkConnectivity()!=ConnectivityResult.none) {
      _isLoading.add(true);
      DashboardService().getCheckList(
          '${EndPoints.refloor_auth}${type}',
          {'instance': EndPoints.env}).then((value) {
        _isLoading.add(false);
        if (value.data != null) {
          if(type=="Completion") {
            addCompleteCheckList.add(value.data!);
          } else {
            addCheckList.add(value.data!);
          }
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

  getInvoice() async{
    var user= await userDataStore!.getUser();
    if(await CommonData.checkConnectivity()!=ConnectivityResult.none) {
      _isLoading.add(true);
      DashboardService().getInvoiceDetails(
          '${EndPoints.refloor_auth}${appointmentData!.projectId}',
          {'instance': EndPoints.env}).then((value) {
        _isLoading.add(false);
        if (value.data != null) {
          _invoiceDetailsData.add(value.data!);
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

  sendInvoiceAmount(String amount) async{
    var user= await userDataStore!.getUser();
    if(await CommonData.checkConnectivity()!=ConnectivityResult.none) {
      _isLoading.add(true);
      DashboardService().sendInvoiceAmount(
          '${EndPoints.refloor_auth}${appointmentData!.projectId}/$amount',
          {'instance': EndPoints.env}).then((value) {
        _isLoading.add(false);
        if (value.data != null) {

          addIsInvoice.add(true);
          Get.to(AppInjector.instance.completeInstallation(
             type!, appointmentData, lastUpload, (list) {lastUpload = list;
          }))!.then((val) {});
         // _invoiceDetailsData.add(value.data!);
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

  navigateData(List<FileData> imageFiles) async {
    if(await CommonData.checkConnectivity()!=ConnectivityResult.none) {


      FormData formData = FormData();

      for (int i = 0; i < imageFiles.length; i++) {
          formData.files.add(MapEntry(
            '',
            await MultipartFile.fromFile(
              imageFiles[i].fileName!.path,
              filename:  imageFiles[i].fileName!.path.split('/').last,
            )));
      }

      formData.fields.add(MapEntry('type', 'before'));


     _isLoading.add(true);
    DashboardService().imageUpload(
          '${EndPoints.refloor_auth}${appointmentData!.id}/before',
          {'instance': EndPoints.env}, formData).then((value) {

        printLog("Response", value.data);
        if (value.data != null) {
          if(value.data!.success!="false"){
            isConfirmArrivalCompleted = true;
           // addUploadFiles.add([]);
            DashboardService().createInstallSummary(
                '${EndPoints.refloor_auth}${appointmentData!.id}',
                {'instance': EndPoints.env}).then((value) {
              _isLoading.add(false);
              if (value.data != null) {
                commonDialog(Get.context!, Strings.uploadMsg, Strings.ok, () {});

              }});
          }else{
            commonDialog(Get.context!, value.data!.errors[0].message, Strings.ok, () {});
          }

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

  setCompleteList(){
    getCheckList("Completion");
  }

  arrvialCheck(){
    getCheckList("Arrival");
  }
}