import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:impulsrefactor/States/connected_device.dart';
import 'package:impulsrefactor/app_constants.dart';

final errorServiceProvider = StateNotifierProvider<ErrorServiceState, List<int>>((ref) => ErrorServiceState([], ref.read));

class ErrorServiceState extends StateNotifier<List<int>> {
  final Reader read;
  StreamSubscription _errorStream;

  ErrorServiceState(List<int> errors, this.read) : super(errors ?? []);

  /// Starts listening to the error code characteristic
  void listenForErrors() async {
    if (read(connectedDeviceProvider) == null) {
      print('Device is not connected!');
      return;
    }
    if (!read(connectedDeviceProvider.notifier).characteristics.containsKey(AppConstants.ERROR_CHARACTERISTIC_UUID)) {
      print('Characteristic Error Code not found!');
      return;
    }

    BluetoothCharacteristic error = read(connectedDeviceProvider.notifier).characteristics[AppConstants.ERROR_CHARACTERISTIC_UUID];

    if (_errorStream == null) {
      _errorStream = error.value.listen((event) {
        if (event.length == 1) {
          ByteData errorByteData = ByteData.sublistView(Uint8List.fromList(event.reversed.toList()));
          addError(errorByteData.getUint8(0));
        } else {
          print('Error event with length not equal to 1: $event');
        }
      });
      await error.setNotifyValue(true);
    }
    if (_errorStream.isPaused) {
      _errorStream.resume();
    }
  }

  void addError(int value) {
    if (state.length >= 10) {
      state.removeAt(0);
    }

    state.add(value);
    state = state; // Because editing a list doesn't notify the listeners
  }
}
