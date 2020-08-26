import 'package:flutter/cupertino.dart';

enum ToastMessages {deviceSuccessfullyConnected, deviceAlreadyConnected, deviceNotFound, BluetoothOff}

/// This state triggers a toast.
class MessageState extends ChangeNotifier {
  ToastMessages _message;

  ToastMessages get message => _message;

  set message(ToastMessages value) {
    _message = value;
    notifyListeners();
  }
}