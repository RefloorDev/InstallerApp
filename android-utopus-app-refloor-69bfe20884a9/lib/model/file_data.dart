import 'dart:io';
class FileData {
  File? fileName;

  FileData({this.fileName, this.isClick,this.isUpload,this.originalSize,this.compressSize});
  bool? isUpload;
  bool? isClick;
  double? originalSize;
  double? compressSize;




}