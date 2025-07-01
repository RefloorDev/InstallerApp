import 'package:flutter/material.dart';
import '../label/item_label_text.dart';
import '../utilites/reflore_colors.dart';
import '../utilites/strings.dart';

class SplashWidget extends StatelessWidget {
  Widget? child;
   SplashWidget({super.key,this.child});



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/splash_bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          alignment: Alignment.center,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: RefloreColors.app_color.withOpacity(0.85),
          child:  Center(child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/icons/app_logo.png'),
              //if(child!=null)ItemLabelText(text: Strings.appName,fontColor: RefloreColors.logo_yellow,fontSize: 24.0,fontWight: FontWeight.w600,),
              //ItemLabelText(text: Strings.projectPerfect,fontColor: Colors.white,fontSize: 14.0,fontWight: FontWeight.w600,isFont: true,),
              if(child!=null)child!,
            ],
          )),
        ),
      ),
    );
  }
}

