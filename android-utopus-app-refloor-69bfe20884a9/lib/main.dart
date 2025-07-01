import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'di/app_injector.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final context = SecurityContext.defaultContext;
  context.allowLegacyUnsafeRenegotiation = true;
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarBrightness: Brightness.light));
  runApp( MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AppInjector.instance.app));
}


