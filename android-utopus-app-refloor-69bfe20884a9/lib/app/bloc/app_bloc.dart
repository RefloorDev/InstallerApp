
import 'package:flutter/cupertino.dart';
import 'package:reflore/di/i_login_page.dart';
import 'package:rxdart/rxdart.dart';
import '../../di/app_injector.dart';
import '../../manager/user_data_store/user_data_store.dart';
import '../arch/bloc_provider.dart';

class AppBloc extends BlocBase{
  String? title;
  UserDataStore userDataStore;
  final BehaviorSubject<void> _onRouteGenerate = BehaviorSubject();
  final BehaviorSubject<Widget> _startPage = BehaviorSubject();

  Sink<void> get onRouteGenerate => _onRouteGenerate;

  Stream<Widget> get startPage => _startPage;


  AppBloc(this.title,this.userDataStore){
    setUpPlatform();
    init();
  }

  void setUpPlatform() {

  }

  void init() {

  }

  void onClick() async{
    _startPage.add(AppInjector.instance.splashPage());

  }

}
