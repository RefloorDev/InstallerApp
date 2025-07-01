
import 'package:reflore/pages/login/login_page.dart';

import '../app/arch/bloc_provider.dart';
import '../pages/login/bloc/login_bloc.dart';
import '../pages/login/bloc/splash_bloc.dart';
import '../pages/login/splash_page.dart';
import 'app_injector.dart';

extension LoginExtension on AppInjector {

  SplashFactory get  splashPage => container.get();
  LoginFactory get  login => container.get();

  registerLogin(){

    container.registerDependency<SplashFactory>((){
      return()=> BlocProvider<SplashBloc>(bloc: SplashBloc(userDataStore:userDataStore), child:  const SplashPage());
    });

    container.registerDependency<LoginFactory>((){
      return()=> BlocProvider<LoginBloc>(bloc: LoginBloc(userDataStore:userDataStore), child:  const LoginPage());
    });

  }

}