import 'package:flutter/material.dart';
import 'package:impulsrefactor/States/message_state.dart';

class Components {
  static AppBar appBar(String title) {
    return AppBar(
      centerTitle: true,
      title: Text(title),
    );
  }

  static String bluetoothErrorMessageText(ToastMessages messageCode) {
    String text = '';
    switch (messageCode) {
      case ToastMessages.deviceSuccessfullyConnected: {
        text = 'Device successfully connected!';
        break;
      }
      case ToastMessages.BluetoothOff: {
        text = 'Bluetooth is turned off! Please turn it on to connect to the device.';
        break;
      }
      case ToastMessages.deviceAlreadyConnected: {
        text = 'Device is already connected!';
        break;
      }
      case ToastMessages.deviceNotFound: {
        text = 'Device was not found!';
        break;
      }
    }
    return text;
  }
}
