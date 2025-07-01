import 'package:flutter/material.dart';




abstract class ContainerWithWidget {
  Widget? getContainer();
}

abstract class ContainerWithAction extends ContainerWithWidget {

  Widget? additionalWidget;


}