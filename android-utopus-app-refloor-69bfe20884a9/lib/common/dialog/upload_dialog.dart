import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reflore/common/button/my_button.dart';
import 'package:reflore/common/dialog/buttons_dialog.dart';
import 'package:reflore/common/dialog/imageview_dialog.dart';
import 'package:reflore/common/utilites/common_data.dart';
import 'package:reflore/common/utilites/logger.dart';
import 'package:reflore/common/utilites/reflore_colors.dart';
import 'package:reflore/common/utilites/strings.dart';
import 'package:reflore/model/file_data.dart';
import 'package:reflore/pages/installer/bloc/installer_bloc.dart';

import '../label/item_label_text.dart';
import 'common_dialog.dart';

Future uploadDialog(
    BuildContext context, InstallerDetailsBloc bloc, Function() onClick) {
  File? cameraFile;
  File? imageFile;
  return showGeneralDialog(
    context: context,
    barrierColor: RefloreColors.login_border_color,
    barrierDismissible: false,
    transitionDuration: Duration(milliseconds: 400),
    pageBuilder: (context, __, ___) {
      return Scaffold(

        backgroundColor:RefloreColors.login_border_color ,
        appBar: AppBar(
          backgroundColor: RefloreColors.toolbarColor,
          centerTitle: true,

          title: ItemLabelText(
              text:Strings.arrivalPhoto,
              fontSize: 16.0,
              fontWight: FontWeight.w600,
              isFont: true,
              fontColor: Colors.white),
        ),
        body: SafeArea(
          child: StreamBuilder<List<FileData>>(
              initialData: [],
              stream: bloc.uploadFiles,
              builder: (context, sp) {
                return Container(
                  padding: EdgeInsets.all(16),
                  width: MediaQuery.of(context).size.width,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              border:
                              Border.all(color: Colors.black, width: 1)),
                          height: 280,
                          width: Get.width,
                          child: (sp.data!.length > 0 && sp.data!.length<51)?GridView.builder(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 5,
                              crossAxisSpacing:0.5,
                              mainAxisSpacing: 0.5,
                              childAspectRatio: 0.9,
                            ),
                            itemBuilder: (context, i) {
                              return GestureDetector(
                                onTap: () async {
                                  printLog("title",  sp.data![i].fileName!);
                                  File file =  sp.data![i].fileName!;
                                  imageViewDialog(context,sp.data![i]);
                                  /*List<FileData> fileData=sp.data!;
                                  for(int k=0;k<fileData.length;k++){
                                    if(k==i) {
                                      fileData[k].isClick=!fileData[k].isClick!;
                                    } else {
                                      fileData[k].isClick=false;
                                    }
                                  }
                                  bloc.addUploadFiles.add(fileData);*/

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
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                            width: MediaQuery.of(context).size.width,
                            alignment: Alignment.centerRight,
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    List<FileData> list = sp.data ?? [];
                                    if(list.length<50){
                                      var file = await CommonData.getImageFromCamera(context);
                                      if (file != null) {
                                        if((list.length+file.length)<=50){
                                          list.addAll(file);
                                          bloc.addUploadFiles.add(list);
                                        }else{
                                          list.addAll(file);
                                          bloc.addUploadFiles.add(list.take(50).toList());
                                          commonDialog(context, "Maximum no. of images are uploaded", Strings.ok, () {});

                                        }

                                      }
                                    }else{

                                      bloc.addUploadFiles.add(list.take(50).toList());
                                      commonDialog(context, "Maximum no. of images are uploaded", Strings.ok, () {});
                                    }

                                  },
                                  child: myButton(
                                      width: Get.width*0.18,
                                      height: 38,
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
                                  width: 10,
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    List<FileData> list = sp.data ?? [];
                                    if(list.length<50){
                                      var file = await CommonData.getImageFromGallery();
                                      if (file != null) {

                                        if((list.length+file.length)<=50){
                                          list.addAll(file);
                                          bloc.addUploadFiles.add(list);
                                        }else{
                                          list.addAll(file);
                                          bloc.addUploadFiles.add(list.take(50).toList());
                                          commonDialog(context, "Maximum no. of images are uploaded", Strings.ok, () {});

                                        }
                                      }
                                    }else{
                                      bloc.addUploadFiles.add(list.take(50).toList());
                                      commonDialog(context, "Maximum no. of images are uploaded", Strings.ok, () {});



                                    }


                                  },
                                  child: myButton(
                                      width: Get.width*0.18,
                                      height: 38,
                                      child: Center(
                                          child: ItemLabelText(
                                            text: Strings.gallery,
                                            fontColor: Colors.white,
                                            fontSize: 12.0,
                                            fontWight: FontWeight.w400,
                                            isFont: true,
                                          ))),
                                ),
                                Spacer(),
                                ItemLabelText(text: '${sp.data!.length}/50', fontColor: Colors.white,fontWight: FontWeight.w600,isFont: true,),
                              ],
                            )),
                        const SizedBox(
                          height: 10,
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
                          children: ['All Rooms - From the Doorway', 'All Stairs & Landings', 'All Non-Ordinary Installation Areas']
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
                        GestureDetector(
                          onTap: () async {

                            if(sp.data!.isNotEmpty) {
                              Navigator.pop(context);
                              bloc.navigateData(sp.data!);
                            }else{
                              bloc.addErrMsg.add('No photos selected or captured');
                            }
                          },
                          child: myButton(
                              width: MediaQuery.of(context).size.width * 0.25,
                              height: 45,
                              child: Center(
                                  child: ItemLabelText(
                                    text: Strings.upload,
                                    fontColor: Colors.white,
                                    fontSize: 14.0,
                                    fontWight: FontWeight.w600,
                                    isFont: true,
                                  ))),
                        ),
                      ],
                    ),
                  ),
                );
              }),
        ),
      );
    },
  );
  /*return showDialog(
      context: context,
      barrierDismissible: false,

      builder: (BuildContext context) {
       // bloc.addUploadFiles.add([]);
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          backgroundColor: RefloreColors.login_border_color,
          insetPadding: const EdgeInsets.all(10),
          contentPadding: const EdgeInsets.all(10),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          content: StreamBuilder<List<FileData>>(
              initialData: [],
              stream: bloc.uploadFiles,
              builder: (context, sp) {
                return SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(right: 10),
                              alignment: Alignment.centerLeft,
                              child: ItemLabelText(
                              text: Strings.arrivalPhoto,
                              fontColor: Colors.white,
                              fontSize: Get.width*0.035,
                              fontWight: FontWeight.w700,
                              isFont: true,
                                                        ),
                            ),
                            Spacer(),
                            IconButton(onPressed: (){
                              buttonsDialog(context, Strings.imageMsg,
                                  Strings.ok, Strings.cancel, (type) {
                                    if(type==0){
                                      Navigator.pop(context);
                                    }
                                  });

                            }, icon: Icon(Icons.cancel_outlined,color: Colors.white,))



                          ],
                        ),

                        const SizedBox(
                          height: 10,
                        ),

                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.black, width: 1)),
                            height: 280,
                            width: Get.width,
                            child: (sp.data!.length > 0 && sp.data!.length<51)?GridView.builder(
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 5,
                                crossAxisSpacing:0.5,
                                mainAxisSpacing: 0.5,
                                childAspectRatio: 0.9,
                              ),
                              itemBuilder: (context, i) {
                                return GestureDetector(
                                  onTap: (){
                                    List<FileData> fileData=sp.data!;
                                    for(int k=0;k<fileData.length;k++){
                                      if(k==i) {
                                        fileData[k].isClick=!fileData[k].isClick!;
                                      } else {
                                        fileData[k].isClick=false;
                                      }
                                    }
                                    bloc.addUploadFiles.add(fileData);

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
                        const SizedBox(
                          height: 10,
                        ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                              alignment: Alignment.centerRight,
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      List<FileData> list = sp.data ?? [];
                                      if(list.length<50){
                                        var file = await CommonData.getImageFromCamera(context);
                                        if (file != null) {
                                          if((list.length+file.length)<=50){
                                            list.addAll(file);
                                            bloc.addUploadFiles.add(list);
                                          }else{

                                            Get.rawSnackbar(messageText: ItemLabelText(text: "Maximum no. of images are uploaded",fontColor: Colors.blue,fontSize: 16.0,isFont: true,),snackPosition: SnackPosition.TOP,backgroundColor: Colors.white,padding: const EdgeInsets.all(15),
                                              margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),);
                                          }

                                        }
                                      }else{

                                        Get.rawSnackbar(messageText: ItemLabelText(text: "Maximum no. of images are uploaded",fontColor: Colors.blue,fontSize: 16.0,isFont: true,),snackPosition: SnackPosition.TOP,backgroundColor: Colors.white,padding: const EdgeInsets.all(15),
                                          margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),);
                                      }

                                    },
                                    child: myButton(
                                        width: Get.width*0.18,
                                        height: 38,
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
                                    width: 10,
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      List<FileData> list = sp.data ?? [];
                                      if(list.length<50){
                                        var file = await CommonData.getImageFromGallery();
                                        if (file != null) {

                                          if((list.length+file.length)<=50){
                                            list.addAll(file);
                                            bloc.addUploadFiles.add(list);
                                          }else{
                                            Get.rawSnackbar(messageText: ItemLabelText(text: "Maximum no. of images are uploaded",fontColor: Colors.blue,fontSize: 16.0,isFont: true,),snackPosition: SnackPosition.TOP,backgroundColor: Colors.white,padding: const EdgeInsets.all(15),
                                              margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),);
                                          }
                                        }
                                      }else{
                Get.rawSnackbar(messageText: ItemLabelText(text: "Maximum no. of images are uploaded",fontColor: Colors.blue,fontSize: 16.0,isFont: true,),snackPosition: SnackPosition.TOP,backgroundColor: Colors.white,padding: const EdgeInsets.all(15),
                margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),);

                                      }


                                    },
                                    child: myButton(
                                        width: Get.width*0.18,
                                        height: 38,
                                        child: Center(
                                            child: ItemLabelText(
                                              text: Strings.gallery,
                                              fontColor: Colors.white,
                                              fontSize: 12.0,
                                              fontWight: FontWeight.w400,
                                              isFont: true,
                                            ))),
                                  ),
                                  Spacer(),
                                  ItemLabelText(text: '${sp.data!.length}/50', fontColor: Colors.white,fontWight: FontWeight.w600,isFont: true,),
                                ],
                              )),
                        const SizedBox(
                          height: 10,
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
                          children: ['All Rooms - From the Doorway', 'All Stairs & Landings', 'All Non-Ordinary Installation Areas']
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
                        GestureDetector(
                          onTap: () async {
                            Navigator.pop(context);
                            if(sp.data!.isNotEmpty) {
                              bloc.navigateData(sp.data!);
                            }else{
                              bloc.addErrMsg.add('No photos selected or captured');
                            }
                          },
                          child: myButton(
                              width: MediaQuery.of(context).size.width * 0.25,
                              height: 45,
                              child: Center(
                                  child: ItemLabelText(
                                text: Strings.upload,
                                fontColor: Colors.white,
                                fontSize: 14.0,
                                fontWight: FontWeight.w600,
                                isFont: true,
                              ))),
                        ),
                      ],
                    ),
                  ),
                );
              }),
        );
      });*/
}
