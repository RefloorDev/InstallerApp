

import 'package:reflore/pages/dashboard/dashboard_page.dart';

import '../app/arch/bloc_provider.dart';
import '../pages/dashboard/bloc/dashboard_bloc.dart';
import '../pages/installer/bloc/complete_installation_bloc.dart';
import '../pages/installer/bloc/installer_bloc.dart';
import '../pages/installer/bloc/project_completion_bloc.dart';
import '../pages/installer/complete_installation.dart';
import '../pages/installer/installer_details.dart';
import '../pages/installer/project_completion.dart';
import 'app_injector.dart';

extension  InstallerDetailsExtension on AppInjector {
  InstallerDetailsFactory get  installerDetails => container.get();
  CompleteInstallationFactory get completeInstallation => container.get();
  ProjectCompletionFactory get projectCompletion => container.get();
  registerInstallerDetails(){


    container.registerDependency<InstallerDetailsFactory>((){
      return(type,appointmentData)=> BlocProvider<InstallerDetailsBloc>(bloc: InstallerDetailsBloc(userDataStore:userDataStore,type: type,appointmentData: appointmentData), child:  const InstallerDetails());
    });

    container.registerDependency<CompleteInstallationFactory>((){
      return(type,appointmentData,lastUpload,onBack)=> BlocProvider<CompleteInstallationBloc>(bloc:  CompleteInstallationBloc(userDataStore:userDataStore,type: type,appointmentData:appointmentData,lastUpload: lastUpload,onBack: onBack), child:  const  CompleteInstallationPage());
    });
    container.registerDependency<ProjectCompletionFactory>((){
      return(type,appointmentData)=> BlocProvider<ProjectCompletionBloc>(bloc:  ProjectCompletionBloc(userDataStore:userDataStore,type: type,appointmentData:appointmentData), child:  const  ProjectCompletionPage());
    });
  }

}