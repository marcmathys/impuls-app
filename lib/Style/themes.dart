import 'package:flutter/material.dart';

class Themes {
  static TextStyle getDefaultTextStyle() {
    return TextStyle(fontSize: 18);
  }

  static TextStyle getSmallTextStyle() {
    return TextStyle(fontSize: 12);
  }

  static TextStyle getLargeTextStyle() {
    return TextStyle(fontSize: 20);
  }

  static TextStyle getButtonTextStyle() {
    return TextStyle(fontSize: 14);
  }

  static TextStyle getErrorTextStyle() {
    return TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red);
  }

  static TextStyle getHeadingTextStyle() {
    return TextStyle(fontSize: 24, fontWeight: FontWeight.bold);
  }

  static double getMoney() {
    return double.infinity;
  }
}