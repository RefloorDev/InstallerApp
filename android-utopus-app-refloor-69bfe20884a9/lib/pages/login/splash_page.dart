import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:reflore/app/arch/bloc_provider.dart';
import 'package:reflore/common/label/item_label_text.dart';
import 'package:reflore/common/splash_bg/splash_widget.dart';
import 'package:reflore/common/utilites/reflore_colors.dart';
import 'package:reflore/pages/login/bloc/splash_bloc.dart';

import '../../common/utilites/strings.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  SplashPageState createState() => SplashPageState();
}

class SplashPageState extends State<SplashPage> {
  SplashBloc? bloc;
  @override
  void initState() {
   bloc=BlocProvider.of(context);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
     return SplashWidget();
  }
}
