import 'package:flutter/cupertino.dart';
import 'package:reflore/common/utilites/reflore_colors.dart';

Widget myButton({Widget? child,double? height,double? width,int? isChange}){
  return Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      borderRadius: const BorderRadius.all(Radius.circular(4)),
      border: Border.all(color: RefloreColors.login_border_color,width: 1),
      color: (isChange!=null)?(isChange==1)?RefloreColors.greenColor:(isChange==2)?RefloreColors.login_border_color:RefloreColors.button_color:RefloreColors.button_color
    ),
    child: child,
  );
}