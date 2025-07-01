

import 'package:reflore/pages/dashboard/dashboard_page.dart';

import '../app/arch/bloc_provider.dart';
import '../pages/dashboard/bloc/dashboard_bloc.dart';
import 'app_injector.dart';

extension DashboardExtension on AppInjector {
  DashboardFactory get  dashboard => container.get();

  registerDashboard(){


    container.registerDependency<DashboardFactory>((){
      return()=> BlocProvider<DashboardBloc>(bloc: DashboardBloc(userDataStore:userDataStore), child:  const DashboardPage());
    });

  }

}