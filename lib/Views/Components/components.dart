import 'package:flutter/material.dart';

class Components {
  static AppBar appBar(String title) {
    return AppBar(
      centerTitle: true,
      title: Text(title),
    );
  }

  static ScaffoldFeatureController loginErrorSnackBar(BuildContext context, int code) {
    String text = '';
    switch (code) {
      case 0: {
        text = 'Device successfully connected!';
        break;
      }
      case 1: {
        text = 'Bluetooth is turned off! Please turn it on to connect to the device.';
        break;
      }
      case 2: {
        text = 'Device is already connected!';
        break;
      }
      case 3: {
        text = 'Device was not found!';
        break;
      }
    }

    return Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
      ),
    );
  }
}
