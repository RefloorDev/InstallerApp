import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:reflore/app/arch/bloc_provider.dart';
import 'package:reflore/common/label/item_label_text.dart';
import 'package:reflore/common/load_container/load_container.dart';
import 'package:reflore/common/splash_bg/splash_widget.dart';
import 'package:reflore/common/textfield/my_text_field.dart';
import 'package:reflore/common/utilites/logger.dart';
import 'package:reflore/common/utilites/reflore_colors.dart';
import 'package:reflore/pages/login/bloc/login_bloc.dart';

import '../../common/button/my_button.dart';
import '../../common/dialog/common_dialog.dart';
import '../../common/utilites/common_data.dart';
import '../../common/utilites/strings.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  LoginBloc? bloc;
  final TextEditingController user=TextEditingController();
  final TextEditingController password=TextEditingController();
  @override
  void initState() {
   bloc=BlocProvider.of(context);
   validateErrorMsg();
    super.initState();


  }
  void validateErrorMsg() {
    bloc!.errMsg.listen((event) {
      if(event.isNotEmpty){
        commonDialog(context,event,Strings.ok,(){
          user.text="";
          password.text="";
        });
      }

    });
  }
  @override
  Widget build(BuildContext context) {
     return LoaderContainer(
       stream: bloc!.isLoading,
       child: SplashWidget(child: Padding(
         padding: const EdgeInsets.all(20.0),
         child: StreamBuilder<bool>(
           initialData: false,
           stream: bloc!.onClickButton,
           builder: (context, sp) {
             return Column(
               mainAxisAlignment: MainAxisAlignment.center,
               crossAxisAlignment: CrossAxisAlignment.center,
               children: [
                 const SizedBox(height: 15,),
                 MyTextField(
                  controller: user,
                     onChange: (val){
                       bloc!.addPhone.add(val);
                     },
                   prefixIcon: Icon(Icons.mail_rounded,color: HexColor('#A7B0BA'),),
                   labelText: "",
                   hintText: Strings.hint_mobile,
                   inputAction: TextInputAction.next,
                   keyboardType: TextInputType.emailAddress,
                   validationStream: bloc!.phoneValidation,
                     onClickButton:sp.data
                 ),
                 const SizedBox(height: 15,),
                 StreamBuilder<bool>(
                   initialData: true,
                   stream: bloc!.isVisible,
                   builder: (b,s){
                     return MyTextField(
                         controller: password,
                         initialText: 'password',
                         onChange: (val){
                           bloc!.password.add(val);
                         },
                         prefixIcon: SvgPicture.asset('assets/icons/password.svg',),
                         sufix: Padding(
                           padding: const EdgeInsets.only(right: 8.0,left: 8.0),
                           child: GestureDetector(
                               onTap: (){
                                 bloc!.addIsVisible.add(!s.data!);
                               },
                               child: (s.data!)?Icon(Icons.visibility_off,color: HexColor('#C6D1DD'),):SvgPicture.asset('assets/icons/eye.svg')),
                         ),
                         obscureText: s.data!,
                         labelText: "",
                         hintText: Strings.hint_password,
                         inputAction: TextInputAction.done,
                         keyboardType: TextInputType.text,
                         validationStream: bloc!.passwordValidation,
                         onClickButton:sp.data
                     );
                   },
                 ),
                 const SizedBox(height: 20,),
                 StreamBuilder<bool>(
                   initialData: false,
                   stream: bloc!.isSave,
                   builder: (context, s) {
                     return InkWell(
                       onTap: (){
                         bloc!.addIsSave.add(s.data==true?false:true);
                       },
                       child: Row(
                         children: [
                           StreamBuilder<bool>(
                             initialData: false,
                             stream: bloc!.isSave,
                             builder: (context, c) {
                               return Checkbox(value: c.data, onChanged: (val){
                                 printLog("title",val);
                                 bloc!.isSaveData(val!);
                               },activeColor: RefloreColors.app_color);
                             }
                           ),
                           //SvgPicture.asset('assets/icons/uncheck.svg'),
                           const SizedBox(width: 5,),
                           ItemLabelText(text: 'Remember me',fontColor: Colors.white,fontSize: 16.0,isFont: true,fontWight: FontWeight.w400,)
                         ],
                       ),
                     );
                   }
                 ),
                 const SizedBox(height: 25,),
                 GestureDetector(
                     onTap: (){
                       bloc!.addOnClickButton.add(true);
                       bloc!.login.add(null);
                     },
                     child: myButton(child: Center(child: ItemLabelText(text: Strings.login,fontWight: FontWeight.w600,fontSize: 18.0,fontColor: Colors.white,)),width: MediaQuery.of(context).size.width,height: 57.0))
               ],
             );
           }
         ),
       ),),
     );
  }
}


