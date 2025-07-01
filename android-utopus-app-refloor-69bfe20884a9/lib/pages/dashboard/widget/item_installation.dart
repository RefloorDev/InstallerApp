import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:reflore/common/dialog/pdf_full_dialog.dart';
import 'package:reflore/common/utilites/common_data.dart';
import 'package:reflore/common/utilites/logger.dart';
import 'package:intl/intl.dart';
import 'package:reflore/common/button/my_button.dart';
import 'package:reflore/common/label/item_label_text.dart';
import 'package:reflore/common/utilites/reflore_colors.dart';
import 'package:reflore/di/i_installer_page.dart';
import 'package:reflore/model/appointment_data.dart';
import 'package:reflore/pages/dashboard/bloc/dashboard_bloc.dart';
import 'package:url_launcher/url_launcher.dart' hide map;

import '../../../common/dialog/common_dialog.dart';
import '../../../common/utilites/strings.dart';
import '../../../di/app_injector.dart';

Widget itemInstallation(BuildContext context,int type,DashboardBloc? bloc,AppointmentData data,){
  List<String> str=['Install a “Project Perfect” floor so I never need to return ',
    'Complete all assigned work',
    'Prep surface (subfloors) properly before installation ',
    'Not commit “Flagrant Fouls"',
  'Walk the job with the customer after installation',
  'Do a full inspection with pictures prior to leaving'];

 return GestureDetector(
   onTap: (){
     if(data.isInstallConfirmed!){
       //Get.to(AppInjector.instance.installerDetails(type,data))!.then((value) => bloc!.setListeners());
       //Get.to(AppInjector.instance.projectCompletion(type,data))!.then((value) => bloc!.setListeners());

     }

   },
   child: Container(
     margin: const EdgeInsets.all(15),
     padding: const EdgeInsets.all(10),
     color: RefloreColors.toolbarColor,
     child: Column(
       children: [
         Row(
           children: [
             Expanded(flex:3,child: ItemLabelText(text: Strings.type,fontSize: 14.0,isFont: true,fontWight: FontWeight.w700,fontColor:RefloreColors.login_icon_color ,)),
             Expanded(flex:5,child: ItemLabelText(text: type==0?Strings.installation:Strings.services,fontSize: 14.0,isFont: true,fontWight: FontWeight.w700,fontColor:Colors.white ,))

           ],
         ),
         const SizedBox(height: 15,),
         Row(
           children: [
             Expanded(flex:3,child: ItemLabelText(text: Strings.projectDates,fontSize: 14.0,isFont: true,fontWight: FontWeight.w700,fontColor:RefloreColors.login_icon_color ,)),
             Expanded(flex:5,child: ItemLabelText(text: '${DateFormat('MM/dd/yyyy').format(DateTime.parse((data.startDate!=null)?data.startDate!:""))} - ${DateFormat('MM/dd/yyyy').format(DateTime.parse((data.endDate!=null)?data.endDate!:""))}',fontSize: 14.0,isFont: true,fontWight: FontWeight.w700,fontColor:Colors.white ,))

           ],
         ),
         const SizedBox(height: 15,),
         Align(
             alignment: Alignment.centerLeft,
             child: ItemLabelText(text: Strings.customerInformation,fontSize: 14.0,isFont: true,fontWight: FontWeight.w700,fontColor:RefloreColors.login_icon_color ,)),
         const SizedBox(height: 10,),
         Row(
           children: [
             SvgPicture.asset('assets/icons/user.svg'),
             const SizedBox(width: 20,),
             Flexible(child: ItemLabelText(text: '${(data.prospectName!=null)?data.prospectName:""}',fontSize: 14.0,isFont: true,fontWight: FontWeight.w500,fontColor:Colors.white ,))

           ],
         ),
         const SizedBox(height: 10,),
         GestureDetector(
           onTap: () async {
             String? address='${(data.prospectFullAddress!=null)?data.prospectFullAddress:""}';
             final availableMaps = await MapLauncher.installedMaps;
             await showModalBottomSheet<void>(
               context: context,
               builder: (BuildContext context) {
                 return Container(
                   padding: EdgeInsets.all(16.0),
                   child: Column(
                     mainAxisAlignment: MainAxisAlignment.start,
                     crossAxisAlignment: CrossAxisAlignment.start,
                     mainAxisSize: MainAxisSize.min,
                     children: <Widget>[
                       ItemLabelText(
                         text:'Open with',
                         fontWight: FontWeight.w600,fontSize: 16.0,
                       ),
                       SizedBox(height: 16.0),
                       ...availableMaps.map((map) {
                         return ListTile(
                           title: ItemLabelText(text:map.mapName,fontSize: 14.0,fontWight: FontWeight.w400,),
                           onTap: () async {
                             Navigator.of(context).pop();  // Close the bottom sheet
                             map.showDirections(destination:Coords(double.parse(data.appointmentLatitude!), double.parse(data.appointmentLongitude!)),destinationTitle: address,directionsMode: DirectionsMode.driving,);

                        /*     if(map.mapType.toString().toLowerCase().contains('google')){
                               CommonData.getDirectionsGoogleMaps("${data.appointmentLatitude},${data.appointmentLongitude}");
                             }else  if(map.mapType.toString().toLowerCase().contains('apple')){
                               CommonData.getDirectionsAppleMaps("${data.appointmentLatitude},${data.appointmentLongitude}");
                             }else  if(map.mapType.toString().toLowerCase().contains('waze')){
                               CommonData.getDirectionsWaze("${data.appointmentLatitude},${data.appointmentLongitude}");
                             }else{
                               if(data.appointmentLatitude!=null&&data.appointmentLatitude!.isNotEmpty&&data.appointmentLongitude!=null&&data.appointmentLongitude!.isNotEmpty){
                                 map.showDirections(destination:Coords(double.parse(data.appointmentLatitude!), double.parse(data.appointmentLongitude!)),destinationTitle: address,directionsMode: DirectionsMode.driving,);

                               }
                             }*/
                           },
                         );
                       }).toList(),
                     ],
                   ),
                 );
               },
             );


           },
           child: Row(
             children: [
               SvgPicture.asset('assets/icons/loc.svg'),
               const SizedBox(width: 20,),
               Flexible(child: Text( '${(data.prospectFullAddress!=null)?data.prospectFullAddress:""}',style:TextStyle(fontSize: 14.0,fontWeight: FontWeight.w500,color:Colors.blue ,decoration:TextDecoration.underline,decorationColor: Colors.blue)))



             ],
           ),
         ),
         const SizedBox(height: 10,),
         InkWell(
           onTap: () async {
             //printLog("call Data", "'tel:${data.prospectPhoneNumber}'");
             if(data.prospectPhoneNumber!.isNotEmpty&&data.prospectPhoneNumber!=null){
               //final call = Uri.parse('tel:+${data.prospectPhoneNumber}');
               final call = Uri.parse(data.prospectPhoneNumber!.startsWith('+1')?"tel:${data!.prospectPhoneNumber}":'tel:+1${ data.prospectPhoneNumber}');

               if (await canLaunchUrl(call)) {
             launchUrl(call);
             } else {
             throw 'Could not launch $call';
             }
           }
           },
           child: Row(
             children: [
               SvgPicture.asset('assets/icons/call.svg',color: RefloreColors.login_border_color,),
               const SizedBox(width: 20,),
               Text( '${(data.prospectPhoneNumber!=null)?data.prospectPhoneNumber:""}',style:TextStyle(fontSize: 14.0,fontWeight: FontWeight.w500,color:Colors.white ,decoration:TextDecoration.underline,decorationColor: Colors.white))

             ],
           ),
         ),
         const SizedBox(height: 15,),
         Align(
             alignment: Alignment.centerLeft,
             child: ItemLabelText(text: Strings.jobTitle,fontSize: 14.0,isFont: true,fontWight: FontWeight.w700,fontColor:RefloreColors.login_icon_color ,)),
         Align(
             alignment: Alignment.centerLeft,
             child:  ItemLabelText(text: data.name ?? '',fontSize: 14.0,isFont: true,fontWight: FontWeight.w500,fontColor:Colors.white ,)),
         const SizedBox(height: 15,),
         Row(
           mainAxisAlignment: MainAxisAlignment.start,
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             Expanded(flex:5,child: ItemLabelText(text: Strings.installCoordinator,fontSize: 14.0,isFont: true,fontWight: FontWeight.w700,fontColor:RefloreColors.login_icon_color ,)),
             Expanded(flex:5,child: Column(
               mainAxisAlignment: MainAxisAlignment.start,
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 ItemLabelText(text: '${data.projectCoordinator}',textAlignment: TextAlign.start,fontSize: 14.0,isFont: true,fontWight: FontWeight.w700,fontColor:Colors.white ,),
                 GestureDetector(
                     onTap: () async {
                       if(data.projectCoordinatorPhone!.isNotEmpty&&data.projectCoordinatorPhone!=null){
                         final call = Uri.parse(data.projectCoordinatorPhone!.startsWith('+1')?"tel:${data!.projectCoordinatorPhone}":'tel:+1${ data.projectCoordinatorPhone}');

                         //final call = Uri.parse('tel:+${data.projectCoordinatorPhone}');
                         if (await canLaunchUrl(call)) {
                           launchUrl(call);
                         } else {
                           throw 'Could not launch $call';
                         }
                       }


                     },
                     child: Text( '${(data.projectCoordinatorPhone!=null)?data.projectCoordinatorPhone:""}',style:TextStyle(fontSize: 14.0,fontWeight: FontWeight.w500,color:Colors.white ,decoration:TextDecoration.underline,decorationColor: Colors.white))
                 )
               ],
             ))

           ],
         ),
         const SizedBox(height: 15,),
         Row(
           mainAxisAlignment: MainAxisAlignment.start,
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             Expanded(flex:5,child: ItemLabelText(text: Strings.installCoordinatorManager,fontSize: 14.0,isFont: true,fontWight: FontWeight.w700,fontColor:RefloreColors.login_icon_color ,)),
             Expanded(flex:5,child: Column(
               mainAxisAlignment: MainAxisAlignment.start,
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 ItemLabelText(text: '${data.installCoordinatorManager}',textAlignment: TextAlign.start,fontSize: 14.0,isFont: true,fontWight: FontWeight.w700,fontColor:Colors.white ,),
                 GestureDetector(
                     onTap: () async {
                       // printLog("call Data", "'tel:${data.installCoordinatorManagerPhone}'");
                       if(data.installCoordinatorManagerPhone!.isNotEmpty&&data.installCoordinatorManagerPhone!=null){
                         final call = Uri.parse(data.installCoordinatorManagerPhone!.startsWith('+1')?"tel:${data!.installCoordinatorManagerPhone}":'tel:+1${ data.installCoordinatorManagerPhone}');

                         //final call = Uri.parse('tel:+${data.projectCoordinatorPhone}');
                         if (await canLaunchUrl(call)) {
                           launchUrl(call);
                         } else {
                           throw 'Could not launch $call';
                         }
                       }


                     },
                     child: Text( '${(data.installCoordinatorManagerPhone!=null)?data.installCoordinatorManagerPhone:""}',style:TextStyle(fontSize: 14.0,fontWeight: FontWeight.w500,color:Colors.white ,decoration:TextDecoration.underline,decorationColor: Colors.white))
                 )
               ],
             ))

           ],
         ),
         const SizedBox(height: 15,),
        /* Align(
             alignment: Alignment.centerLeft,
             child: ItemLabelText(text: Strings.refloorOperations,fontSize: 14.0,isFont: true,fontWight: FontWeight.w700,fontColor:RefloreColors.login_icon_color ,)),
         const SizedBox(height: 15,),*/
         Row(
           mainAxisAlignment: MainAxisAlignment.start,
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             Expanded(flex:5,child: ItemLabelText(text: Strings.installManager,fontSize: 14.0,isFont: true,fontWight: FontWeight.w700,fontColor:RefloreColors.login_icon_color ,)),
             Expanded(flex:5,child: Column(
               mainAxisAlignment: MainAxisAlignment.start,
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 ItemLabelText(text: '${data.installationManager}',textAlignment: TextAlign.start,fontSize: 14.0,isFont: true,fontWight: FontWeight.w700,fontColor:Colors.white ,),
                 GestureDetector(
                     onTap: () async {
                      // printLog("call Data", "'tel:${data.installationManagerPhone}'");
                       if(data.installationManagerPhone!.isNotEmpty&&data.installationManagerPhone!=null){
                         final call = Uri.parse(data.installationManagerPhone!.startsWith('+1')?"tel:${data!.installationManagerPhone}":'tel:+1${ data.installationManagerPhone}');

                         //final call = Uri.parse('tel:+${data.projectCoordinatorPhone}');
                         if (await canLaunchUrl(call)) {
                           launchUrl(call);
                         } else {
                           throw 'Could not launch $call';
                         }
                       }


                     },
                     child: Text( '${(data.installationManagerPhone!=null)?data.installationManagerPhone:""}',style:TextStyle(fontSize: 14.0,fontWeight: FontWeight.w500,color:Colors.white ,decoration:TextDecoration.underline,decorationColor: Colors.white))
                 )
               ],
             ))

           ],
         ),
         const SizedBox(height: 15,),



         Align(
             alignment: Alignment.centerLeft,
             child: ItemLabelText(
               text: Strings.jobDetails,
               fontSize: 14.0,
               isFont: true,
               fontWight: FontWeight.w700,
               fontColor: RefloreColors.login_icon_color,
             )),
         Align(
             alignment: Alignment.centerLeft,child: ItemLabelText(text: data.comments,fontSize: 14.0,fontColor: Colors.white,isFont: true)),
         const SizedBox(height: 15,),
         Align(
             alignment: Alignment.centerLeft,
             child: ItemLabelText(text: Strings.confirming,fontSize: 14.0,isFont: true,fontWight: FontWeight.w700,fontColor:RefloreColors.login_icon_color ,)),
         const SizedBox(height: 10,),
         Column(
           children: str.map((s){
             return Column(
               children: [
                 Row(
                     children:[
                       ItemLabelText(text: "\u2022", fontSize: 14.0,fontColor: Colors.white,), //bullet text
                       const SizedBox(width: 10,), //space between bullet and text
                       Expanded(
                         child: ItemLabelText(text:s, fontSize: 14.0,fontColor: Colors.white,isFont: true,fontWight: FontWeight.w500), //text
                       )
                     ]
                 ),
                 const SizedBox(height: 10,)
               ],
             );
           }).toList(),
         ),
         if(type==0)SizedBox(height: 15,),
         if(type==0) GestureDetector(
           onTap: () {

             if(data.laborBillReportURL!=null&&data.laborBillReportURL!.isNotEmpty){
               viewPDFPage(data.laborBillReportURL!,Strings.laborBill,context);
             }else{
               Get.snackbar(
                 "Error",
                 "${Strings.laborBill} not available",
                 colorText: Colors.white,
                 backgroundColor: Colors.red,
                 icon: const Icon(Icons.notifications_active_outlined),
               );
             }
           },
           child: myButton(
               width: Get.width,
               height: 57,
               child: Padding(
                 padding: const EdgeInsets.only(
                     left: 8.0, right: 8.0),
                 child: Row(
                   children: [
                     ItemLabelText(
                       text: '${Strings.laborBill}',
                       fontColor: Colors.white,
                       fontWight: FontWeight.w600,
                       isFont: true,
                       fontSize: 16.0,
                     ),
                     const Spacer(),
                     SvgPicture.asset('assets/icons/pdf.svg')
                   ],
                 ),
               )),
         ),
         SizedBox(height: 15,),
         GestureDetector(
           onTap: () {

             if(data.saleSummaryReportURL!=null&&data.saleSummaryReportURL!.isNotEmpty){
               viewPDFPage(data.saleSummaryReportURL!,Strings.salesSummaryReport,context);
             }else{
               Get.snackbar(
                 "Error",
                 "${Strings.salesSummaryReport} not available",
                 colorText: Colors.white,
                 backgroundColor: Colors.red,
                 icon: const Icon(Icons.notifications_active_outlined),
               );
             }

           },
           child: myButton(
               width: Get.width,
               height: 57,
               child: Padding(
                 padding: const EdgeInsets.only(
                     left: 8.0, right: 8.0),
                 child: Row(
                   children: [
                     ItemLabelText(
                       text: '${Strings.salesSummaryReport}',
                       fontColor: Colors.white,
                       fontWight: FontWeight.w600,
                       isFont: true,
                       fontSize: 16.0,
                     ),
                     const Spacer(),
                     SvgPicture.asset('assets/icons/pdf.svg')
                   ],
                 ),
               )),
         ),

         const SizedBox(height: 50,),

        GestureDetector(
             onTap: (){
               if(data.isInstallConfirmed!){
                 Get.to(AppInjector.instance.installerDetails(type,data))!.then((value) => bloc!.setListeners());
                 //Get.to(AppInjector.instance.projectCompletion(type,data))!.then((value) => bloc!.setListeners());

               }else{
                 bloc!.confirmInstall(context,data);
               }

             },
             child: myButton(width: MediaQuery.of(context).size.width,height: 57,child: Center(child: ItemLabelText(text: data.isInstallConfirmed!?Strings.openProject:Strings.confirm,fontSize: 16.0,isFont: true,fontWight: FontWeight.w600,fontColor:Colors.white ,)))),
         const SizedBox(height: 30,),
       ],
     ),
   ),
 );



}

void viewPDFPage(String URL,String title,BuildContext context) async {
  if(URL!=null||URL.isNotEmpty){
    Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => PdfFullDialog(pdfPath:URL,title: title,),
      ),
    );

    //pdfDialog(context, () => null, file.path);

  }

}
