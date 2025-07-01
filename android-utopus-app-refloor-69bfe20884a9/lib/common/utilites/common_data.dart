import 'dart:io';
import 'dart:typed_data';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:geocoding/geocoding.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multiple_image_camera/multiple_image_camera.dart';
import 'package:reflore/common/utilites/logger.dart';
import 'package:reflore/model/file_data.dart';
import 'package:url_launcher/url_launcher.dart';

abstract class CommonData{

  static Future<List<FileData>> getImageFromCamera(BuildContext context) async {
  List<FileData> selectedImages = [];
  var images =  await MultipleImageCamera.capture(context: context);
  if (images != null) {
    for (var image in images) {
      final filePath = File(image.file.path).absolute.path;
      int fileSize = await  File(image.file.path).length();
      double originalSize= fileSize / (1024 * 1024);
      final lastIndex = filePath.lastIndexOf(RegExp(r'\.(jpeg|png|bmp|jpg)$', caseSensitive: false));
      if(lastIndex!=null){
        final splitted = filePath.substring(0, (lastIndex));
        final outPath = "${splitted}_out${filePath.substring(lastIndex)}";

        final compressedImage = await FlutterImageCompress.compressAndGetFile(
            filePath,
            outPath,
            minWidth: 500,
            format: filePath.toString().endsWith("png")?CompressFormat.png:CompressFormat.jpeg,
            minHeight: 500,
            quality: 40);
        int fileSize = await  File(compressedImage!.path).length();
        double comppressSize= fileSize / (1024 * 1024);

        selectedImages.add(FileData(fileName: File(compressedImage!.path),isClick: false,isUpload: false,originalSize: originalSize,compressSize: comppressSize)) ;
      }else{
        final compressedImage = await FlutterImageCompress.compressAndGetFile(
            filePath,
            filePath,
            minWidth: 500,
            minHeight: 500,
            format: filePath.toString().endsWith("png")?CompressFormat.png:CompressFormat.jpeg,
            quality: 40);
        int fileSize = await  File(compressedImage!.path).length();
        double comppressSize= fileSize / (1024 * 1024);
        selectedImages.add(FileData(fileName: File(compressedImage!.path),isClick: false,isUpload: false,compressSize: comppressSize,originalSize: originalSize)) ;
      }
    }
    return selectedImages;

  } else {
    return [];
  }

}

static Future<List<FileData>> getImageFromGallery() async {
  List<FileData> selectedImages = [];
  var images = await ImagePicker.platform
      .getMultiImage();
  if (images != null) {
    for (var image in images) {
      String? filePath = File(image.path).absolute.path;
      int fileSize = await  File(image.path).length();
      double originalSize= fileSize / (1024 * 1024);
      final lastIndex = filePath.lastIndexOf(RegExp(r'\.(jpeg|png|bmp|jpg)$', caseSensitive: false));
      if(lastIndex!=null){
        final splitted = filePath.substring(0, (lastIndex));
        final outPath = "${splitted}_out${filePath.substring(lastIndex)}";
        final compressedImage = await FlutterImageCompress.compressAndGetFile(
            filePath,
            outPath,
            minWidth: 500,
            minHeight: 500,
            format: filePath.toString().endsWith("png")?CompressFormat.png:CompressFormat.jpeg,
            quality: 40);
        int fileSize = await  File(compressedImage!.path).length();
        double comppressSize= fileSize / (1024 * 1024);
        selectedImages.add(FileData(fileName: File(compressedImage!.path),isClick: false,isUpload: false,originalSize: originalSize,compressSize: comppressSize)) ;
      }else{
        final compressedImage = await FlutterImageCompress.compressAndGetFile(
            filePath,
            filePath,
            minWidth: 500,
            minHeight: 500,
            format: filePath.toString().endsWith("png")?CompressFormat.png:CompressFormat.jpeg,
            quality: 40);
        int fileSize = await  File(compressedImage!.path).length();
        double comppressSize= fileSize / (1024 * 1024);
        selectedImages.add(FileData(fileName: File(compressedImage!.path),isClick: false,isUpload: false,originalSize: originalSize,compressSize: comppressSize)) ;
      }
    }
    return selectedImages;

  } else {
    return [];
  }

}

static Future<ConnectivityResult> checkConnectivity() async {
  var connectivityResult = await Connectivity().checkConnectivity();
  return connectivityResult.first;

}


  static Future<void> openInGoogleMaps(String address) async {
    final String url = 'https://www.google.com/maps/search/?api=1&query=$address';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  static Future<void> openInAppleMaps(String address) async {
    final String url = 'https://maps.apple.com/?ll=$address';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  static  Future<void> openInWaze(String address) async {

    var url = 'waze://?ll=${address}&navigate=yes';
    printLog("url", url);
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }

  }

  static  Future<void> getDirectionsGoogleMaps(String endAddress) async {
    final String url = 'https://www.google.com/maps/dir/?api=1&origin=&destination=$endAddress';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  static Future<void> getDirectionsAppleMaps(String endAddress) async {
    final String url = 'https://maps.apple.com/?saddr=&daddr=$endAddress';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  static Future<void> getDirectionsWaze(String endAddress) async {
    final String url = 'waze://ul?ll=$endAddress&navigate=yes';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }



}