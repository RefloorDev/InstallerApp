import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:reflore/common/dialog/imageview_dialog.dart';
import 'package:reflore/common/dialog/pdf_full_dialog.dart';
import 'package:reflore/common/load_container/load_container.dart';
import 'package:reflore/common/utilites/logger.dart';
import 'package:reflore/di/app_injector.dart';
import 'package:reflore/di/i_installer_page.dart';
import 'package:reflore/model/file_data.dart';
import 'package:reflore/pages/installer/bloc/complete_installation_bloc.dart';

import '../../app/arch/bloc_provider.dart';
import '../../common/button/my_button.dart';
import '../../common/dialog/common_dialog.dart';
import '../../common/label/item_label_text.dart';
import '../../common/utilites/common_data.dart';
import '../../common/utilites/reflore_colors.dart';
import '../../common/utilites/strings.dart';

class CompleteInstallationPage extends StatefulWidget {
  const CompleteInstallationPage({super.key});

  @override
  CompleteInstallationState createState() => CompleteInstallationState();
}

class CompleteInstallationState extends State<CompleteInstallationPage> {
  CompleteInstallationBloc? bloc;

  @override
  void initState() {
    bloc = BlocProvider.of(context);
    validateErrorMsg();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return  StreamBuilder<List<FileData>>(
        initialData: [],
        stream: bloc!.uploadFiles,
        builder: (context, sp) {
          printLog("title", bloc!.isUploadAfterCompleted);
        return Scaffold(
          backgroundColor: RefloreColors.app_bg,
          appBar: AppBar(
            centerTitle: true,
            leading: IconButton(icon: Icon(Icons.arrow_back),onPressed: (){
              bloc!.onBack!(sp.data!);
              Navigator.of(context).pop();
            },),
            backgroundColor: RefloreColors.toolbarColor,
            title: ItemLabelText(
                text:'Complete ${bloc!.appointmentData!.activityType=="Service"?"Service":'Installation'}',
                fontSize: 18.0,
                fontWight: FontWeight.w600,
                isFont: true,
                fontColor: Colors.white),

          ),
         body: LoaderContainer(
           stream: bloc!.isLoading,
           child: SingleChildScrollView(
             child: Padding(
               padding: const EdgeInsets.all(25.0),
               child: Column(
                 children: [
                   SizedBox(height: 15,),
                   ItemLabelText(
                     text: Strings.uploadCompletionPhotos,
                     fontColor: Colors.white,
                     fontSize: 16.0,
                     fontWight: FontWeight.w600,
                     isFont: true,
                   ),
                   SizedBox(height: 20,),
                   Container(
                     padding: EdgeInsets.all(10),
                     decoration: BoxDecoration(
                         border:
                         Border.all(color: Colors.white, width: 0.5)),
                     height: 280,
                     width: Get.width,
                     child:   (sp.data!.length > 0)?GridView.builder(
                       gridDelegate:
                       const SliverGridDelegateWithFixedCrossAxisCount(
                         crossAxisCount: 5,
                         crossAxisSpacing:0.5,
                         mainAxisSpacing: 0.5,
                         childAspectRatio: 0.9,
                       ),
                       itemBuilder: (context, i) {
                         return GestureDetector(
                           onTap: (){
                             imageViewDialog(context,sp.data![i]);
                            /* List<FileData> fileData=sp.data!;
                             for(int k=0;k<fileData.length;k++){
                               if(k==i) {
                                 fileData[k].isClick=!fileData[k].isClick!;
                               } else {
                                 fileData[k].isClick=false;
                               }
                             }
                             bloc!.addUploadFiles.add(fileData);*/

                           },
                           child: Stack(
                             children: [
                           Container(
                           margin: EdgeInsets.all(4),
                           height: 150,
                           width: 140,
                           decoration: BoxDecoration(
                               border: Border.all(color: Colors.white,width: 2),
                               borderRadius: BorderRadius.circular(8)),
                           child: ClipRRect(
                             borderRadius: BorderRadius.circular(8),
                             child: Image.file(
                               sp.data![i].fileName!,
                               fit: BoxFit.fill,
                             ),
                           ),
                         ),
                         Row(
                         children: [
                         Spacer(),
                         GestureDetector(
                         onTap: (){
                         sp.data!.removeAt(i);
                         bloc!.addUploadFiles.add( sp.data!);
                         },
                         child: Padding(
                         padding: const EdgeInsets.only(top: 8.0,right: 8),
                         child: Icon(Icons.cancel_outlined,color: Colors.white,size: 20,),
                         ),
                         )

                         ],
                         ),
                             ],
                           ),
                         );
                       },
                       itemCount: sp.data!.length,
                     ):SizedBox(),
                   ),
                   SizedBox(height: 10,),
                   Container(
                       width: MediaQuery.of(context).size.width,
                       alignment: Alignment.centerRight,
                       child: Row(
                         children: [
                           Row(
                             mainAxisAlignment: MainAxisAlignment.center,
                             crossAxisAlignment: CrossAxisAlignment.center,
                             children: [
                               GestureDetector(
                                 onTap: () async {
                                   List<FileData> list = sp.data ?? [];
                                   if(list.length<50){
                                     var file = await CommonData.getImageFromCamera(context);
                                     if (file != null) {
                                       if((list.length+file.length)<=50){
                                         list.addAll(file);
                                         bloc?.addUploadFiles.add(list);
                                       }else{
                                         list.addAll(file);
                                         bloc?.addUploadFiles.add(list.take(50).toList());
                                         commonDialog(context, "Maximum no. of images are uploaded", Strings.ok, () {});

                                       }

                                     }
                                   }else{
                                     bloc?.addUploadFiles.add(list.take(50).toList());
                                     commonDialog(context, "Maximum no. of images are uploaded", Strings.ok, () {});

                                   }
                                 },
                                 child: myButton(
                                     width: 80,
                                     height: 28,
                                     child: Center(
                                         child: ItemLabelText(
                                           text: Strings.camera,
                                           fontColor: Colors.white,
                                           fontSize: 12.0,
                                           fontWight: FontWeight.w400,
                                           isFont: true,
                                         ))),
                               ),
                               const SizedBox(
                                 width: 30,
                               ),
                               GestureDetector(
                                 onTap: () async {
                                   List<FileData> list = sp.data ?? [];
                                   if(list.length<50){
                                     var file = await CommonData.getImageFromGallery();
                                     if (file != null) {

                                       if((list.length+file.length)<=50){
                                         list.addAll(file);
                                         bloc?.addUploadFiles.add(list);
                                       }else{
                                         list.addAll(file);
                                         bloc?.addUploadFiles.add(list.take(50).toList());
                                         commonDialog(context, "Maximum no. of images are uploaded", Strings.ok, () {});

                                       }
                                     }
                                   }else{
                                     bloc?.addUploadFiles.add(list.take(50).toList());
                                     commonDialog(context, "Maximum no. of images are uploaded", Strings.ok, () {});


                                   }

                                 },
                                 child: myButton(
                                     width: 80,
                                     height: 28,
                                     child: Center(
                                         child: ItemLabelText(
                                           text: Strings.gallery,
                                           fontColor: Colors.white,
                                           fontSize: 12.0,
                                           fontWight: FontWeight.w400,
                                           isFont: true,
                                         ))),
                               ),
                             ],
                           ),
                           Spacer(),
                           ItemLabelText(text: '${sp.data!.length}/50', fontColor: Colors.white,fontWight: FontWeight.w600,isFont: true,),
                         ],
                       )),
                   const SizedBox(
                     height: 15,
                   ),
                   Align(
                       alignment: Alignment.centerLeft,
                       child: ItemLabelText(
                         text: Strings.uploadPhotoOf,
                         fontColor: Colors.white,
                         fontWight: FontWeight.w700,
                         isFont: true,
                         fontSize: 16.0,
                       )),
                   const SizedBox(
                     height: 10,
                   ),
                   Column(
                     children: ['All Rooms - From the Doorway', 'All Corners - of Each Room', 'All Transitions','All Moldings','All Stairs & Landings','All Toilets, Appliances, and Reconnections','All Non-Ordinary Installation Areas','A ‘REFLOOR’ Sign in the Yard']
                         .map((s) {
                       return Column(
                         children: [
                           Row(children: [
                             ItemLabelText(
                               text: "\u2022",
                               fontSize: 14.0,
                               fontColor: Colors.white,
                             ), //bullet text
                             const SizedBox(
                               width: 10,
                             ), //space between bullet and text
                             Expanded(
                               child: ItemLabelText(
                                   text: s,
                                   fontSize: 14.0,
                                   fontColor: Colors.white,
                                   isFont: true,
                                   fontWight: FontWeight.w500), //text
                             )
                           ]),
                           const SizedBox(
                             height: 10,
                           )
                         ],
                       );
                     }).toList(),
                   ),
                   SizedBox(height: 15,),
                   GestureDetector(
                     onTap: () async {
                       if(sp.data!.length>0){
                         bloc!.navigateData(sp.data!);
                       }else{
                         bloc!.addErrMsg.add('No images selected or captured');
                       }

                     },
                     child: myButton(
                         width: MediaQuery.of(context).size.width * 0.25,
                         height: 47,
                         child: Center(
                             child: ItemLabelText(
                               text: Strings.upload,
                               fontColor: Colors.white,
                               fontSize: 14.0,
                               fontWight: FontWeight.w600,
                               isFont: true,
                             ))),
                   ),
                   /*SizedBox(height: 15,),
                       GestureDetector(
                         onTap: () {

                           if(bloc!.appointmentData!.laborBillReportURL!=null&&bloc!.appointmentData!.laborBillReportURL!.isNotEmpty){
                             viewPDFPage(bloc!.appointmentData!.laborBillReportURL!,Strings.laborBill);
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

                           if(bloc!.appointmentData!.saleSummaryReportURL!=null&&bloc!.appointmentData!.saleSummaryReportURL!.isNotEmpty){
                             viewPDFPage(bloc!.appointmentData!.saleSummaryReportURL!,Strings.salesSummaryReport);
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
                                     text: '${(bloc!.type==0)?"3. ":'2. '}${Strings.salesSummaryReport}',
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
                       ),*/
                   SizedBox(height: 25,),
                   (sp.data!.isNotEmpty&&sp.data![0].isUpload!)?GestureDetector(
                     onTap: () async {
                       Get.to(AppInjector.instance.projectCompletion(bloc!.type!,bloc!.appointmentData));
                     },
                     child: myButton(
                         width: MediaQuery.of(context).size.width * 0.85,
                         height: 57,
                         child: Center(
                             child: ItemLabelText(
                               text: Strings.sendCertificate,
                               fontColor: Colors.white,
                               fontSize: 14.0,
                               fontWight: FontWeight.w600,
                               isFont: true,
                             ))),
                   ):SizedBox()


                 ],
               ),
             ),
           ),
         ),);
      }
    );
  }


  void validateErrorMsg() {
    bloc!.errMsg.listen((event) {
      if(event.isNotEmpty){
        commonDialog(context,event,Strings.ok,(){

        });
      }

    });
  }

  void viewPDFPage(String URL,String title) async {
    if(URL!=null||URL.isNotEmpty){
      Navigator.of(context).push(
        MaterialPageRoute(
          fullscreenDialog: true,
          builder: (context) => PdfFullDialog(pdfPath:URL,title: title,),
        ),
      );
      /*bloc!.addIsLoading.add(true);
      Completer<File> completer = Completer();
      print("Start download file from internet!");
      try {
        final url = URL;
        final filename = url.substring(url.lastIndexOf("/") + 1);
        var request = await HttpClient().getUrl(Uri.parse(url));
        var response = await request.close();
        var bytes = await consolidateHttpClientResponseBytes(response);
        var dir = await getApplicationDocumentsDirectory();
        File file = File("${dir.path}/$filename");
        await file.writeAsBytes(bytes, flush: true);
        completer.complete(file);
        bloc!.addIsLoading.add(false);*/

        //pdfDialog(context, () => null, file.path);

    }

  }

}
