import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:reflore/common/utilites/common_data.dart';
import 'package:reflore/common/validators/validators.dart';
import 'package:reflore/repositories/dashboard/dashboard_api.dart';
import 'package:reflore/repositories/end_point/end_point.dart';
import 'package:rxdart/rxdart.dart';

import '../../../app/arch/bloc_provider.dart';
import '../../../common/dialog/common_dialog.dart';
import '../../../common/utilites/logger.dart';
import '../../../common/utilites/strings.dart';
import '../../../manager/user_data_store/user_data_store.dart';
import '../../../model/appointment_data.dart';
import '../../../model/user_data.dart';

typedef DashboardFactory = BlocProvider<DashboardBloc> Function();
class DashboardBloc extends BlocBase {
  UserDataStore? userDataStore;

  final BehaviorSubject<bool> _isLoading = BehaviorSubject.seeded(false);
  final BehaviorSubject<List<AppointmentData>> _dashboardData = BehaviorSubject();
  final BehaviorSubject<bool>  _valid = BehaviorSubject.seeded(false);
  final BehaviorSubject<int>  _tabSelect = BehaviorSubject.seeded(0);
  BehaviorSubject<String> _errMsg = BehaviorSubject.seeded('');
  Stream<String> get errMsg => _errMsg;
  Stream<int> get tabSelect  => _tabSelect;
  Stream<bool> get isLoading  => _isLoading;
  Sink<int> get addTabSelect  => _tabSelect;
  Stream<List<AppointmentData>> get dashboardData  => _dashboardData;
  Sink<List<AppointmentData>> get addDashboardData  => _dashboardData;
  UserData? user;
  ConnectivityResult? connectivityResult;
  DashboardBloc({this.userDataStore}){

    setListeners();
  }

  setListeners() async{
    user= await userDataStore!.getUser();
    if(await CommonData.checkConnectivity()==ConnectivityResult.none) {
      _errMsg.add('No Internet Connection!');
    }else{
      _isLoading.add(true);
      DashboardService().appointmentDetails('${EndPoints.refloor_auth}${user!.SalespersonID}', {'instance':EndPoints.env}).then((value){
        _isLoading.add(false);
        if(value.data!=null){
          _dashboardData.add(value.data!);
        }else{
          _dashboardData.add([]);
          if(value.error!=null){
            if( value.error!.errors!=null){
              if(value.error!.errors!.isNotEmpty){
                _errMsg.add(value.error!.errors![0].message!);
                printLog("error message", value.error!.errors![0].message);
              }
            }else{

              _errMsg.add(value.error!.error!);
              printLog("error message", value.error!.error);

            }
          }

        }
      });
    }


  }
  confirmInstall(BuildContext context, AppointmentData appointmentData) async {

     if(await CommonData.checkConnectivity()!=ConnectivityResult.none){
        _isLoading.add(true);
        DashboardService().confirmInstall('${EndPoints.refloor_auth}${appointmentData.id}', {'instance':EndPoints.env}).then((value){
          _isLoading.add(false);
          if(value.data!=null){
            setListeners();
            commonDialog(context,Strings.thankMsg,Strings.ok,(){
            });
          }else{
            if( value.error!.errors!=null){
              if(value.error!.errors!.isNotEmpty){
                _errMsg.add(value.error!.errors![0].message!);
                printLog("error message", value.error!.errors![0].message);
              }
            }else{

              _errMsg.add(value.error!.error!);
              printLog("error message", value.error!.error);

            }

          }
        });
      }


  }
  navigateData(Map<String,dynamic> data){


  }
}