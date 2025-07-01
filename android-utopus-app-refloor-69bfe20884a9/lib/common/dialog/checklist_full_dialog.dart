import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reflore/common/button/my_button.dart';
import 'package:reflore/common/dialog/common_dialog.dart';
import 'package:reflore/common/label/item_label_text.dart';
import 'package:reflore/common/load_container/load_container.dart';
import 'package:reflore/common/utilites/logger.dart';
import 'package:reflore/common/utilites/reflore_colors.dart';
import 'package:reflore/common/utilites/strings.dart';
import 'package:reflore/model/checklist_data.dart';
import 'package:reflore/pages/installer/bloc/installer_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

Future checklistDialog(BuildContext context, InstallerDetailsBloc bloc,int type,Function(bool isVerify) onClick) {



  return showGeneralDialog(
    context: context,
    barrierColor: RefloreColors.login_border_color,
    barrierDismissible: false,
    transitionDuration: Duration(milliseconds: 400),
    pageBuilder: (context, __, ___) {

      return LoaderContainer(
        stream: bloc.isLoading,
        child: (type==0)?StreamBuilder<List<ChecklistData>>(
          initialData: [],
          stream: bloc.checkList,
          builder: (context, s) {
            bool isCheckAll=false;
            if(s.data!=null){
              for(var s in s.data!) {
                if (!s.isCheck!) {
                  isCheckAll = false;
                  break;
                }else{
                  isCheckAll=true;
                }
              }
            }

            return Scaffold(
              backgroundColor: RefloreColors.login_border_color,
              appBar: AppBar(
                backgroundColor: RefloreColors.toolbarColor,
                centerTitle: true,

                title: ItemLabelText(
                    text: type==0?Strings.arrivalChecklist:Strings.completeChecklist,
                    fontSize: 16.0,
                    fontWight: FontWeight.w600,
                    isFont: true,
                    fontColor: Colors.white),
              ),
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: (s.data!=null)?ListView.separated(
                  padding: EdgeInsets.only(bottom: 100),
                    itemCount: s.data!.length,
                    itemBuilder: (b,i){
                      return GestureDetector(
                        onTap: (){
                          s.data![i].isCheck=!s.data![i].isCheck!;
                          bloc.addCheckList.add(s.data!);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(s.data![i].isCheck!?Icons.check_box_outlined:Icons.check_box_outline_blank, color: Colors.white,),
                              SizedBox(width: 10,),
                              Flexible(
                                child: ItemLabelText(text: s.data![i].name,fontColor: Colors.white,fontWight: FontWeight.w500,fontSize: 16.0,isFont: true,),
                              )
                            ],
                          ),
                        ),
                      );
                    }, separatorBuilder: (BuildContext context, int index) {

                      return SizedBox(height: 10,);
                },):SizedBox(),
              ),
              bottomNavigationBar: isCheckAll?Container(
                decoration: BoxDecoration(
                  color: RefloreColors.login_border_color,
                  borderRadius: BorderRadius.only(topRight: Radius.circular(10),topLeft: Radius.circular(10))
                ),

                width: Get.width,
                margin: EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: (){

                        if(isCheckAll==true){
                          onClick(true);
                          Navigator.of(context).pop();

                        }else{
                          commonDialog(context, "Please check all checkboxes", Strings.ok, () {});

                        }

                      },
                      child: myButton(
                          width: Get.width * 0.9,
                          height: 55,
                          isChange: 0,
                          child: Padding(
                            padding:
                            const EdgeInsets
                                .all(8.0),
                            child: Center(
                              child: ItemLabelText(
                                text: Strings
                                    .submit,
                                fontColor:
                                Colors
                                    .white,
                                fontWight:
                                FontWeight
                                    .w600,
                                isFont:
                                true,
                                fontSize:
                                16.0,
                              ),
                            ),
                          )),
                    )
                  ],
                ),
                ):null,
              );

          }
        ):StreamBuilder<List<ChecklistData>>(
            stream: bloc.completeCheckList,
            builder: (context, s) {
              bool isCheckAll=false;
              if(s.data!=null){
                for(var s in s.data!) {
                  if (!s.isCheck!) {
                    isCheckAll = false;
                    break;
                  }else{
                    isCheckAll=true;
                  }
                }
              }
              return Scaffold(
                backgroundColor: RefloreColors.login_border_color,
                appBar: AppBar(
                  backgroundColor: RefloreColors.toolbarColor,
                  centerTitle: true,

                  title: ItemLabelText(
                      text: type==0?Strings.arrivalChecklist:Strings.completeChecklist,
                      fontSize: 16.0,
                      fontWight: FontWeight.w600,
                      isFont: true,
                      fontColor: Colors.white),
                ),
                body: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: (s.data!=null)?ListView.separated(
                    padding: EdgeInsets.only(bottom: 100),
                    itemCount: s.data!.length,
                    itemBuilder: (b,i){
                      return GestureDetector(
                        onTap: (){
                          s.data![i].isCheck=!s.data![i].isCheck!;
                          bloc.addCompleteCheckList.add(s.data!);
                        },
                        child:
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(s.data![i].isCheck!?Icons.check_box_outlined:Icons.check_box_outline_blank, color: Colors.white,),
                              SizedBox(width: 10,),
                              Flexible(child: ItemLabelText(text: s.data![i].name,fontColor: Colors.white,fontWight: FontWeight.w500,fontSize: 16.0,isFont: true,))
                            ],
                          ),
                        ),
                      );
                    }, separatorBuilder: (BuildContext context, int index) {

                    return SizedBox(height: 10,);
                  },):SizedBox(),
                ),
                bottomNavigationBar: isCheckAll?Container(
                  decoration: BoxDecoration(
                      color: RefloreColors.login_border_color,
                      borderRadius: BorderRadius.only(topRight: Radius.circular(10),topLeft: Radius.circular(10))
                  ),

                  width: Get.width,
                  margin: EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: (){
                          bool isCheckAll=true;
                          for(var s in s.data!) {
                            if (!s.isCheck!) {
                              isCheckAll = false;
                              break;
                            }
                          }
                          if(isCheckAll==true){
                            onClick(true);
                            Navigator.of(context).pop();

                          }else{
                            commonDialog(context, "Please check all checkboxes", Strings.ok, () {});

                          }

                        },
                        child: myButton(
                            width: Get.width * 0.9,
                            height: 55,
                            isChange: 0,
                            child: Padding(
                              padding:
                              const EdgeInsets
                                  .all(8.0),
                              child: Center(
                                child: ItemLabelText(
                                  text: Strings
                                      .submit,
                                  fontColor:
                                  Colors
                                      .white,
                                  fontWight:
                                  FontWeight
                                      .w600,
                                  isFont:
                                  true,
                                  fontSize:
                                  16.0,
                                ),
                              ),
                            )),
                      )
                    ],
                  ),
                ):null,
              );

            }
        ),
      );
    },
  );
}
