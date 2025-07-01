

import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

class ItemLabelText extends StatelessWidget{
  final String text;
  final double? fontSize;
  final Color? fontColor;
  final FontWeight? fontWight;
  final TextOverflow? overflow;
  final  int? maxlines;
  final TextAlign? textAlignment;
  final bool? isFont;
  final TextDecoration? decoration;

  ItemLabelText({text,decoration,overflow,maxlines,textAlignment,fontSize,fontColor,fontWight,isFont}):
        this.text=text,
        this.fontSize=fontSize,
        this.fontColor=fontColor,
        this.overflow=overflow,
        this.fontWight=fontWight,
         this.isFont=isFont,
        this.maxlines=maxlines,
        this.decoration=decoration,
        this.textAlignment=textAlignment;



  @override
  Widget build(BuildContext context) {
    return Text(text,
      style: (isFont!=null)?isFont==true?GoogleFonts.inter(fontSize: fontSize,color: fontColor,fontWeight: fontWight,decoration:decoration):TextStyle(fontSize: fontSize,color: fontColor,fontWeight: fontWight,decoration:decoration):TextStyle(fontSize: fontSize,color: fontColor,fontWeight: fontWight,decoration:decoration),
      overflow: overflow,
      maxLines: maxlines,
      textAlign: textAlignment,);

  }


}