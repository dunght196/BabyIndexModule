
import 'dart:ui';

import 'package:babyindexmodule/util/string.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppUtil {

  static Color getColorExplain(String title) {
    Color colorExplain = Colors.blue;
    switch (title) {
      case Strings.WEIGHT:
        {
          colorExplain = Colors.blue[700];
        }
        break;

      case Strings.HEIGHT:
        {
          colorExplain = Colors.lightGreen;
        }
        break;

      case Strings.PERIMETER:
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
    if(title.contains(Strings.WEIGHT)) {
      return "kg ";
    }else {
      return "cm ";
    }
  }

  static Future<String> getGuuToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(Strings.GUU_TOKEN) ?? '';
  }

  static getGuuId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(Strings.GUU_ID) ?? '';
  }

  static getRelativeId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(Strings.RELATIVE_ID) ?? '';
  }

  static setGuuToken(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(Strings.GUU_TOKEN, value);
  }

  static setGuuId(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(Strings.GUU_ID, value);
  }

  static setRelativeId(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(Strings.RELATIVE_ID, value);
  }

}