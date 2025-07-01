import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:reflore/common/label/item_label_text.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfFullDialog extends StatelessWidget {
  String? pdfPath;
  String? title;
   PdfFullDialog({this.pdfPath,this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          title: ItemLabelText(text: title,fontColor: Colors.black,fontSize: 16.0,fontWight: FontWeight.w600,),
        ),
        Expanded(
          child: SfPdfViewer.network(pdfPath!,
            interactionMode: PdfInteractionMode.selection,
            canShowScrollHead: false,
            canShowScrollStatus: false,
            initialZoomLevel: 1.0,
            maxZoomLevel: 2.0,),
        ),
      ],
    );
  }
}
