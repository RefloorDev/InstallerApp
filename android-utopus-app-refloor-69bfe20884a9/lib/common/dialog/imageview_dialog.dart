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
import 'package:reflore/common/utilites/common_data.dart';
import 'package:reflore/common/utilites/logger.dart';
import 'package:reflore/common/utilites/reflore_colors.dart';
import 'package:reflore/common/utilites/strings.dart';
import 'package:reflore/model/file_data.dart';
import 'package:reflore/pages/installer/bloc/installer_bloc.dart';

import '../label/item_label_text.dart';
import 'common_dialog.dart';

Future imageViewDialog(BuildContext context, FileData file) async {

  int fileSize = await file.fileName!.length();
  double mb= fileSize / (1024 * 1024);
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
              text:'View Image',
              fontSize: 16.0,
              fontWight: FontWeight.w600,
              isFont: true,
              fontColor: Colors.white),
        ),
        body: Container(
          padding: EdgeInsets.all(16),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Expanded(
                flex: 8,
                child: Image.file(
                  file.fileName!,
                  fit: BoxFit.fill,
                ),
              ),
              
              Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ItemLabelText(text: 'Before Size  : ${file.originalSize!.toStringAsFixed(2)} in MBs',fontSize: 14.0,fontWight: FontWeight.w500,fontColor: Colors.black,),

                      ItemLabelText(text: 'After Size in MBs : ${file.compressSize!.toStringAsFixed(2)} in MBs',fontSize: 14.0,fontWight: FontWeight.w500,fontColor: Colors.black,),
                    ],
                  ))
              
        
            ],
          ),
        ),
      );
    },
  );
}
