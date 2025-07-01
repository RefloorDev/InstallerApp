import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reflore/common/load_container/load_container.dart';
import 'package:reflore/common/utilites/logger.dart';

import '../../app/arch/bloc_provider.dart';
import '../../common/button/my_button.dart';
import '../../common/dialog/common_dialog.dart';
import '../../common/label/item_label_text.dart';
import '../../common/textfield/my_text_field.dart';
import '../../common/utilites/common_data.dart';
import '../../common/utilites/reflore_colors.dart';
import '../../common/utilites/strings.dart';
import 'bloc/project_completion_bloc.dart';

class ProjectCompletionPage extends StatefulWidget {
  const ProjectCompletionPage({super.key});

  @override
  ProjectCompletionState createState() => ProjectCompletionState();
}

class ProjectCompletionState extends State<ProjectCompletionPage> {
  ProjectCompletionBloc? bloc;
  TextEditingController _userId=TextEditingController();
  @override
  void initState() {
    bloc = BlocProvider.of(context);
    validateErrorMsg();
    _userId.text=bloc!.appointmentData!.prospectPhoneNumber!;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: RefloreColors.app_bg,
      appBar: AppBar(
        centerTitle: true,
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
         child: Container(
           color: RefloreColors.toolbarColor,
           margin: const EdgeInsets.all(20),
           width: MediaQuery.of(context).size.width,
           height: MediaQuery.of(context).size.height*0.85,
           child: Column(
             mainAxisAlignment: MainAxisAlignment.start,
             crossAxisAlignment: CrossAxisAlignment.center,
             children: [
               Image.asset('assets/icons/app_logo.png'),
               //ItemLabelText(text: Strings.installer,fontColor: RefloreColors.logo_yellow,fontSize: 24.0,fontWight: FontWeight.w600,),
               //ItemLabelText(text: Strings.projectPerfect,fontColor: Colors.white,fontSize: 14.0,fontWight: FontWeight.w600,isFont: true,),
                SizedBox(height: 30,),
               ItemLabelText(text: Strings.projectCompletion,fontColor: Colors.white,fontSize: 20.0,fontWight: FontWeight.w700,isFont: true,),
               const SizedBox(height: 20,),
               ItemLabelText(text: 'Enter customer\'s phone number below\nto send virtual completion form',textAlignment: TextAlign.center,fontColor: Colors.white,fontSize: 16.0,fontWight: FontWeight.w500,isFont: true,),
               const SizedBox(height: 25,),
               Container(
                 margin: const EdgeInsets.all(20.0),
                 decoration: BoxDecoration(
                     color: RefloreColors.login_fields_color,
                     border: Border.all(color: RefloreColors.login_border_color),
                     borderRadius: const BorderRadius.all(Radius.circular(5))
                 ),
                 height: 60,
                 child: Container(
                   alignment: Alignment.center,
                   child: TextField(
                     controller: _userId,
                     textAlign: TextAlign.center,
                     keyboardType: TextInputType.phone,
                     textInputAction: TextInputAction.done,
                     maxLines: 1,
                     inputFormatters: [LengthLimitingTextInputFormatter(14)],
                     readOnly: false,
                     onChanged: (val){
                       if(val.length==10){
                         _userId.text=formatMobileNumber(val);
                         _userId.selection = TextSelection.fromPosition(
                           TextPosition(offset: _userId.text.length),
                         );
                       }else{
                         _userId.text= val.replaceAll(RegExp(r'\D+'), '');
                         _userId.selection = TextSelection.fromPosition(
                           TextPosition(offset: _userId.text.length),
                         );

                       }
                     // bloc!.addValidationMsg.add(msg?'':'Invalid Mobile Number Format : Hint (xxx) xxx-xxxx');
                     },
                     style: GoogleFonts.inter(fontSize: 16,color: RefloreColors.login_icon_color, fontWeight: FontWeight.w600),

                     decoration: InputDecoration(
                       hintText: 'Mobile Number',
                       hintStyle: GoogleFonts.inter(fontSize: 14,color: RefloreColors.login_icon_color,fontWeight: FontWeight.w400 ),
                       border: InputBorder.none,
                     ),
                   ),
                 ),
               ),
               StreamBuilder<String>(
                 initialData: '',
                 stream: bloc!.validationMsg,
                 builder: (context, se) {
                   return ItemLabelText(text: se.data,textAlignment: TextAlign.center,fontColor: Colors.red,fontSize: 16.0,fontWight: FontWeight.w500,isFont: true,);
                 }
               ),

               const SizedBox(height: 15,),

               SizedBox(height: 25,),
               StreamBuilder<String>(
                 initialData: 'data',
                 stream: bloc!.validationMsg,
                 builder: (context, sv) {
                   return GestureDetector(
                     onTap: () async {
                      _userId.text=formatMobileNumber(_userId.text);
                       if(validateUSMobile(_userId.text)){
                         if(_userId.text.isNotEmpty){
                           bloc!.navigateData(context,_userId.text);
                         }
                       }


                     },
                     child: myButton(
                         width: MediaQuery.of(context).size.width * 0.82,
                         height: 57,
                         child: Center(
                             child: ItemLabelText(
                               text: Strings.sendCertificate,
                               fontColor: Colors.white,
                               fontSize: 14.0,
                               fontWight: FontWeight.w600,
                               isFont: true,
                             ))),
                   );
                 }
               ),
             ],
           ),
         ),
       ),
     ),);
  }


  void validateErrorMsg() {
    bloc!.errMsg.listen((event) {
      if(event.isNotEmpty){
        commonDialog(context,event,Strings.ok,(){

        });
      }

    });
  }
  bool validateUSMobile(String value) {
    // Regular expression to match a US mobile number format: (XXX) XXX-XXXX
    RegExp regExp = RegExp(r"^\(\d{3}\) \d{3}-\d{4}$");
    return regExp.hasMatch(value);
  }

  String formatMobileNumber(String number) {
    String cleanedNumber = number.replaceAll(RegExp(r'\D+'), '');
    if (cleanedNumber.length != 10) {
      return number;
    }

    // Format the number as (XXX) XXX-XXXX
    return '(${cleanedNumber.substring(0, 3)}) ${cleanedNumber.substring(3, 6)}-${cleanedNumber.substring(6)}';
  }
}
