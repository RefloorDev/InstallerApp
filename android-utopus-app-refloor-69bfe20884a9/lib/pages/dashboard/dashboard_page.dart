import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reflore/app/arch/bloc_provider.dart';
import 'package:reflore/common/label/item_label_text.dart';
import 'package:reflore/common/load_container/load_container.dart';
import 'package:reflore/common/utilites/common_data.dart';
import 'package:reflore/common/utilites/reflore_colors.dart';
import 'package:reflore/model/appointment_data.dart';
import 'package:reflore/pages/dashboard/bloc/dashboard_bloc.dart';
import 'package:reflore/pages/dashboard/widget/item_installation.dart';

import '../../common/dialog/common_dialog.dart';
import '../../common/utilites/strings.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  DashboardPageState createState() => DashboardPageState();
}

class DashboardPageState extends State<DashboardPage> {
  DashboardBloc? bloc;
  @override
  void initState() {
  bloc=BlocProvider.of(context);
  validateErrorMsg();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RefloreColors.app_bg,
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: RefloreColors.toolbarColor,
        title: ItemLabelText(text:Strings.installerList,fontSize: 18.0,fontWight: FontWeight.w600,isFont: true,fontColor: Colors.white),
      ),
      body: LoaderContainer(
        stream: bloc!.isLoading,
        child:  RefreshIndicator(
          onRefresh: () => _refreshData(context),
          child: SingleChildScrollView(
            child:  StreamBuilder<int>(
                initialData: 0,
                stream: bloc!.tabSelect,
                builder: (context, st) {
                return Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                            flex:2,
                            child: GestureDetector(
                              onTap: (){
                                bloc!.addTabSelect.add(0);
                                _refreshData(context);
                              },
                              child: Container(
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                      color: (st.data==0)?RefloreColors.button_color:RefloreColors.toolbarColor,
                                      borderRadius:  BorderRadius.only(bottomLeft: Radius.circular((st.data==0)?10:0),bottomRight: Radius.circular((st.data==0)?10:0)),
                                      border: Border.all(color:(st.data==0)? RefloreColors.login_border_color:RefloreColors.toolbarColor,width: 2)
                                  ),
                                  child: ItemLabelText(text: Strings.installation,fontSize: 16.0,fontColor: Colors.white,fontWight: FontWeight.w600,isFont: true,)),
                            )),

                        Expanded(
                            flex:2,
                            child: GestureDetector(
                              onTap:(){
                                bloc!.addTabSelect.add(1);
                                _refreshData(context);
                              },
                              child: Container(
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                      color: (st.data==1)?RefloreColors.button_color:RefloreColors.toolbarColor,
                                      borderRadius:  BorderRadius.only(bottomLeft: Radius.circular((st.data==1)?10:0),bottomRight: Radius.circular((st.data==1)?10:0)),
                                      border: Border.all(color: (st.data==1)?RefloreColors.login_border_color:RefloreColors.toolbarColor,width: 2)
                                  ),
                                  child: ItemLabelText(text: Strings.services,fontSize: 16.0,fontColor: Colors.white,fontWight: FontWeight.w600,isFont: true,)),
                            )),

                      ],
                    ),
                   StreamBuilder<List<AppointmentData>>(
                       initialData: [],
                       stream: bloc!.dashboardData,
                       builder: (b,s){
                         return (s!=null)?(s.data!.isNotEmpty)?ListView.builder(
                             itemCount: s.data!.length,
                             physics: const NeverScrollableScrollPhysics(),
                             shrinkWrap: true,
                             itemBuilder: (b,i){
                               return (st.data==0)?(s.data![i].activityType!="Service")?itemInstallation(context,st.data!,bloc,s.data![i]):const SizedBox():(s.data![i].activityType=="Service")?itemInstallation(context,st.data!,bloc,s.data![i]):const SizedBox();
                             }):Container(
                             height: Get.height,
                             width: Get.width,

                             alignment: Alignment.center,
                             child: ItemLabelText(text: 'No Appointments',fontColor: Colors.white,fontSize: 18.0,isFont: true,)):Container(
                             height: Get.height,
                             width: Get.width,
                             alignment: Alignment.center,
                             child: ItemLabelText(text: 'No Appointments',fontColor: Colors.white,fontSize: 18.0,isFont: true,));
                       }),
                  ],
                );
              }
            ),
          ),
        ),
      ),
    );
  }
  Future<void> _refreshData(BuildContext context) async {
    return bloc!. setListeners();
  }
  void validateErrorMsg() {
    bloc!.errMsg.listen((event) {
      if(event.isNotEmpty){
        commonDialog(context,event,Strings.ok,(){

        });
      }

    });
  }
}
