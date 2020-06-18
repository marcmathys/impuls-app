import 'package:flutter/material.dart';

class Components {
  static AppBar appBar(String title) {
    return AppBar(
      centerTitle: true,
      title: Text(title),
    );
  }
}