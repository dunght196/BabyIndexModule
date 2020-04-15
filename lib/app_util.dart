
import 'dart:ui';

import 'package:flutter/material.dart';

class AppUtil {
  static const String WEIGHT = 'Cân nặng';
  static const String HEIGHT = 'Chiều cao';
  static const String PERIMETER = 'Chu vi đầu';

  static Color getColorExplain(String title) {
    Color colorExplain = Colors.blue;
    switch (title) {
      case AppUtil.WEIGHT:
        {
          colorExplain = Colors.blue[700];
        }
        break;

      case AppUtil.HEIGHT:
        {
          colorExplain = Colors.lightGreen;
        }
        break;

      case AppUtil.PERIMETER:
        {
          colorExplain = Colors.cyan[100];
        }
        break;

      default:
        break;
    }

    return colorExplain;
  }

  static String getSuffixYAxis(String title) {
    if(title.contains(AppUtil.WEIGHT)) {
      return "kg ";
    }else {
      return "cm ";
    }
  }

}