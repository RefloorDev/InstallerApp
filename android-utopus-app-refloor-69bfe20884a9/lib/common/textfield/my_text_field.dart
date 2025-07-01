import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:reflore/common/label/item_label_text.dart';
import 'package:reflore/common/utilites/reflore_colors.dart';
class MyTextField extends StatelessWidget {
  final TextEditingController? controller;
  final labelText;
  final hintText;
  final initialText;
  final obscureText;
  final double height;
  final inputAction;
  final keyboardType;
  final int linesLimit;
  final int? charactersLimit;
  final _focusNode;
  final _onSubmit;
  final _validationStream;
  final _onChange;
  final bool? readOnly;
  final Widget? sufix;
  final Widget? prefixIcon;
  final bool? onClickButton;
  final bool? isTextAlan;

  MyTextField(
      {labelText,
        hintText = '',
        initialText = '',
        obscureText = false,
        height = 50.0,
        inputAction,
        keyboardType,
        charactersLimit,
        linesLimit = 1,
        focusNode,
        onSubmit,
        validationStream,
        onChange,readOnly,sufix,prefixIcon,onClickButton,controller,isTextAlan})
      : this.labelText = labelText,
        this.hintText = hintText,
        this.initialText = initialText,
        this.obscureText = obscureText,
        this.height = height,
        this.inputAction = inputAction,
        this.charactersLimit=charactersLimit,
        this.linesLimit = linesLimit,
        this.keyboardType = keyboardType,
        _focusNode = focusNode,
        _onSubmit = onSubmit,
        _validationStream = validationStream,
        this.readOnly=readOnly,
        this.sufix=sufix,
        this.prefixIcon=prefixIcon,
        this.onClickButton=onClickButton,
        this.controller = controller,
        this.isTextAlan=isTextAlan,
        _onChange = onChange {

  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: StreamBuilder<String>(
        initialData: '',
        stream: _validationStream,
        builder: (c, s) {
          return Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                (labelText!="")?Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ItemLabelText(text:s.data!, isFont: true,fontSize: 14,fontColor: RefloreColors.login_icon_color,fontWight: FontWeight.w300,),
                ):const SizedBox(),
                Container(
                  padding: const EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                      color: RefloreColors.login_fields_color,
                      border: Border.all(color: RefloreColors.login_border_color),
                      borderRadius: const BorderRadius.all(Radius.circular(5))
                  ),
                  height: 60,
                  child: Stack(
                    children: [
                      (sufix!=null)?Align(
                          alignment: Alignment.centerRight,
                          child: sufix!):const SizedBox(),
                      (prefixIcon!=null)?Align(
                          alignment: Alignment.centerLeft,
                          child: prefixIcon!):const SizedBox(),
                      Container(
                        alignment: Alignment.center,
                        margin: isTextAlan!=null?isTextAlan==true?const EdgeInsets.only(left: 50,right: 50):const EdgeInsets.only(left: 50,right: 100):const EdgeInsets.only(left: 50,right: 100),
                        child: TextField(
                          key: Key(labelText),
                          controller: controller,
                          textAlign: isTextAlan!=null?isTextAlan==true?TextAlign.center:TextAlign.left:TextAlign.left,
                          keyboardType: keyboardType,
                          textInputAction: inputAction,
                          maxLines: linesLimit,
                          readOnly: (readOnly!=null)?readOnly!:false,
                          onChanged: _onChange,
                          style: GoogleFonts.inter(fontSize: 16,color: RefloreColors.login_icon_color, fontWeight: FontWeight.w600),
                          onSubmitted: _onSubmit,
                          obscureText: obscureText,
                          focusNode: _focusNode,
                          inputFormatters: [
                            if (charactersLimit != null)
                              LengthLimitingTextInputFormatter(charactersLimit)
                          ],
                          decoration: InputDecoration(
                            hintText: hintText,
                            hintStyle: GoogleFonts.inter(fontSize: 14,color: RefloreColors.login_icon_color,fontWeight: FontWeight.w400 ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if(onClickButton!=null)
                  (onClickButton!=false)?(s.data.toString()!="")?Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ItemLabelText(text:s.data!, isFont: true,fontSize: 10.0,fontColor: Colors.red,fontWight: FontWeight.w300,),
                  ):const SizedBox():const SizedBox()
              ],
            ),
          );
        },
      ),
    );
  }
}