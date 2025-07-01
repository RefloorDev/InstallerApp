import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reflore/common/button/my_button.dart';
import 'package:reflore/common/utilites/reflore_colors.dart';

import '../label/item_label_text.dart';

Future commonDialog(BuildContext context,String? title,String button,Function() onClick){
  return  showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          contentPadding: EdgeInsets.all(20),
          backgroundColor: RefloreColors.login_border_color,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ItemLabelText(text: title,fontColor: (title!='No Internet Connection!')?Colors.white:Colors.red,fontSize: 14.0,fontWight: FontWeight.w700,isFont: true,textAlignment: TextAlign.center),
              const SizedBox(height: 30,),
              GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                    onClick();
                  },
                  child: myButton(
                      width: MediaQuery.of(context).size.width*0.25,
                      height: 45,
                      child: Center(child: ItemLabelText(text: button,fontColor: Colors.white,fontSize: 14.0,fontWight: FontWeight.w600,isFont: true,))),),

            ],
          ),
        );
      });
}