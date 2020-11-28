import 'package:flutter/material.dart';
import 'package:impulsrefactor/Services/firebase_service.dart';
import 'package:impulsrefactor/States/message_state.dart';

class Components {
  static AppBar appBar(BuildContext context, String title) {
    FirebaseHandler _firebaseHandler = FirebaseHandler();

    return AppBar(
      leading: Container(),
      centerTitle: true,
      title: Text(title),
      actions: [
        FlatButton(
          onPressed: () async {
            await _firebaseHandler.signOut();
            Navigator.of(context).popUntil(ModalRoute.withName('/login'));
          },
          child: Icon(Icons.power_settings_new),
        ),
      ],
    );
  }

  static String bluetoothErrorMessageText(ToastMessages messageCode) {
    String text = '';
    switch (messageCode) {
      case ToastMessages.deviceSuccessfullyConnected:
        {
          text = 'Device successfully connected!';
          break;
        }
      case ToastMessages.BluetoothOff:
        {
          text = 'Bluetooth is turned off! Please turn it on to connect to the device.';
          break;
        }
      case ToastMessages.deviceAlreadyConnected:
        {
          text = 'Device is already connected!';
          break;
        }
      case ToastMessages.deviceNotFound:
        {
          text = 'Device was not found!';
          break;
        }
    }
    return text;
  }
}
