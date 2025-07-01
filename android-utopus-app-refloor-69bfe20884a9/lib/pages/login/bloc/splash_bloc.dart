import 'package:get/get.dart';
import 'package:reflore/di/i_dashboard_page.dart';
import 'package:reflore/di/i_login_page.dart';

import '../../../app/arch/bloc_provider.dart';
import '../../../di/app_injector.dart';
import '../../../manager/user_data_store/user_data_store.dart';
import '../../../model/user_data.dart';

typedef SplashFactory = BlocProvider<SplashBloc> Function();
class SplashBloc extends BlocBase {
  UserDataStore? userDataStore;

  SplashBloc({this.userDataStore}){
    getUser();
  }

  void getUser() async{
    Future.delayed(const Duration(seconds: 2)).then((value)  async{
      UserData? user= await userDataStore?.getUser();
      if(user == null){
        Get.offAll(AppInjector.instance.login());
      }else{
        if(user.SalespersonID == null) {
          Get.offAll(AppInjector.instance.login());
        } else {
          Get.offAll(AppInjector.instance.dashboard());
        }
      }
    });

  }
}