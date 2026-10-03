import 'package:flutter/material.dart';

class ResponsiveHelper {

  static bool isMobile(BuildContext context) {
    final size = MediaQuery.of(context).size.width;
    if (size < 650 ) {
      return true;
    } else {
      return false;
    }
  }

  static bool isTab(BuildContext context) {
    final size = MediaQuery
        .of(context)
        .size
        .width;
    if (size < 1300 && size >= 650) {
      return true;
    } else {
      return false;
    }
  }
}