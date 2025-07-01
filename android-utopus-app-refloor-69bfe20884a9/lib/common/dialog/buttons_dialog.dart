import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reflore/common/button/my_button.dart';
import 'package:reflore/common/utilites/reflore_colors.dart';

import '../label/item_label_text.dart';

Future buttonsDialog(BuildContext context,String? title,String button,String navButton,Function(int type) onClick){
  return  showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          contentPadding: const EdgeInsets.all(20),
          backgroundColor: RefloreColors.login_border_color,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ItemLabelText(text: title,fontColor: Colors.white,fontSize: 17.0,fontWight: FontWeight.w700,isFont: true,),
              const SizedBox(height: 40,),
              Row(
                children: [
                  GestureDetector(
                      onTap: (){
                        Navigator.pop(context);
                        onClick(0);
                      },
                      child: myButton(
                          width: MediaQuery.of(context).size.width*0.25,
                          height: 45,
                          child: Center(child: ItemLabelText(text: button,fontColor: Colors.white,fontSize: 14.0,fontWight: FontWeight.w600,isFont: true,))),),
                  const SizedBox(width: 40,),
                  GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                      onClick(1);
                    },
                    child: myButton(
                        width: MediaQuery.of(context).size.width*0.25,
                        height: 45,
                        child: Center(child: ItemLabelText(text: navButton,fontColor: Colors.white,fontSize: 14.0,fontWight: FontWeight.w600,isFont: true,))),),
                ],
              ),

            ],
          ),
        );
      });
}